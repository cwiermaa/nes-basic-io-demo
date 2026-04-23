@echo off
set TOOLS=%~dp0tools
pause
"%TOOLS%\wla-6502.exe" -o main.asm main.o
"%TOOLS%\wlalink.exe" -v link.txt build.nes
pause