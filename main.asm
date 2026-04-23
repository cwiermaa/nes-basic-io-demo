.include "memory.asm"

.8bit
.bank 1 SLOT 1
.section "reset" FREE

reset:
	cld					;Initialize stack pointer and processor flags
	sei
	ldx #$FF
	txs

	lda #$00			;Disable rendering
	sta $2000
	sta $2001
	jsr wait3vbls		;PPU warm-up
	jsr cleartable		;Clear name tables
	
	ldx #0				;Initialize RAM to all 0 values
	txa
-
	sta $0,x
	sta $100,x
	sta $200,x
	sta $300,x
	sta $400,x
	sta $500,x
	sta $600,x
	sta $700,x
	inx
	bne -

	lda #$3F			;Set up palette
	sta $2006
	lda #$00
	sta $2006
	ldx #32
	ldy #0

palload:
	lda pal.w,y
	sta $2007
	iny
	dex
	bne palload

	lda #$21			;Render spaceship onto name table
	sta $2006
	lda #$0C
	sta $2006
	sta $1
	ldx #8
	lda #$88
	sta $3
-
	lda $3
	sta $2007
	inc $3
	dex
	bne -
	clc
	lda $1
	adc #$20
	sta $1
	lda #$21
	sta $2006
	lda $1
	sta $2006
	ldx #8
	lda $3
	cmp #$C8
	bne -

	lda #$23			;Set up attribute table using palette #1 for all regions
	sta $2006
	lda #$C0
	sta $2006
	ldx #$40
	ldy #0
-
	lda #$55
	sta $2007
	iny
	dex
	bne -

	lda #$01			;Enable square wave #1 with hardware sweep sound effect
	sta $4015
	lda #$BF
	sta $4000
	lda #$B7
	sta $4001
	lda #$FF
	sta $4002
	lda #$F1
	sta $4003

	lda #$00			;Set scroll to mid-screen vertically
	sta $2005
	lda #$80
	sta $2005
	sta $1
	lda #$1E			;Enable rendering
	sta $2001
	lda #$88
	sta $2000
loop1:
	lda $2002			;Loop until V-blank
	bpl loop1
	lda #$00			;Decrement scroll by 1 pixel vertically
	sta $2005
	lda $1
	sta $2005
	dec $1
	bne loop1			;This loop (loop1) is responsible for the spaceship landing
	lda #$00			;After spaceship lands, silence audio
	sta $4000
	sta $4001
	sta $4002
	sta $4003
	sta $4015
	lda #100			;Set frame counter variable to 100
	sta $2
-
	lda $2002
	bpl -
	dec $2
	bne -				;This loop waits 100 frames

	lda #$00			;Disable rendering
	sta $2000
	sta $2001
	jsr cleartable		;Clear name table

	lda #$21			;Point to mid-name table
	sta $2006
	sta $3
	lda #$2C
	sta $2006
	sta $2
	lda #$60
	sta $0
	ldx #$08
	stx $1
-
	lda $0				;This loop renders the mooninites onto the name table
	sta $2007
	inc $0
	dex
	bne -
	clc
	lda $2
	adc #$20
	sta $2
	lda #$21
	sta $2006
	lda $2
	sta $2006
	ldx $1
	lda $0
	cmp #$88
	bne -


	lda #$22			;These loops render the lines of text onto the name table
	sta $2006
	lda #$06
	sta $2006
	ldx #21
	ldy #0
-
	lda Text.w,y
	sta $2007
	iny
	dex
	bne -

	lda #$22
	sta $2006
	lda #$48
	sta $2006
	ldx #16
	ldy #0
-
	lda Text2.w,y
	sta $2007
	iny
	dex
	bne -


	lda #$22
	sta $2006
	lda #$85
	sta $2006
	ldx #24
	ldy #0
-
	lda Text3.w,y
	sta $2007
	iny
	dex
	bne -

	
	lda #$01			;Re-enable audio (just square wave #1)
	sta $4015
	lda #$04
	sta $4000
	lda #$FF
	sta $4002
	lda #$F9
	sta $4003			;Make a small blip type of sound
	lda #$00
	sta $2005
	sta $2005
	lda #$50			;Initialize sprite position for test on-screen sprite that can be moved around
	sta $600
	sta $603
	lda #$60
	sta $601
	jsr wait3vbls
	lda #$1E
	sta $2001
	lda #$88
	sta $2000
loop:
	jmp loop			;The program's default endless loop

nmi:
	lda #6				;Every frame, read and respond to joypad events
	sta $4014
	jsr joypad
	rti

joypad:
	ldx #1
	stx $4016.w
	dex
	stx $4016.w

	lda $4016
	lda $4016
	lda $4016
	lda $4016
	lda $4016
	and #1
	bne up
	lda $4016
	and #1
	bne dn
	lda $4016
	and #1
	bne lf
	lda $4016
	and #1
	bne rt
	rts
						;These handlers increase/decrease the sprite's X/Y coordinates
up:
	dec $600
	rts
dn:
	inc $600
	rts
lf:
	dec $603
	rts
rt:
	inc $603
	rts

irq:
	rti

wait3vbls:
	lda $2002
	bpl wait3vbls
-
	lda $2002
	bpl -
-
	lda $2002
	bpl -
	rts

cleartable:
	lda #$20
	sta $2006
	lda #$00
	sta $2006
	ldx #4
	ldy #0
-
	sta $2007
	iny
	bne -
	dex
	bne -

	lda #$00
	sta $2005
	sta $2005
	rts

pal:
	.db $3F,$24,$02,$2A,$3F,$13,$02,$30,$3F,$00,$10,$30,$3F,$00,$10,$30
	.db $3F,$00,$10,$30,$3F,$00,$10,$30,$3F,$00,$10,$30,$3F,$00,$10,$30

Text:
	.db "WE ARE THE MOONINITES"

Text2:
	.db "AND WE HAVE COME"

Text3:
	.db "TO INVADE YOUR NINTENDO"

.ends

.bank 2 SLOT 2
.section "graph" FREE
.incbin "chr_data.chr"
.ends

.bank 1 SLOT 1
.orga $FFFA
.section "vectors" FORCE
.dw nmi
.dw reset
.dw irq
.ends