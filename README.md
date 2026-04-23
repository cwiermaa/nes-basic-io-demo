# NES Basic IO Demo

A small, self-contained demonstration of fundamental input/output systems on the Nintendo Entertainment System (NES), implemented in 6502 assembly.

## Overview

This project was created as a compact, approachable example of how core NES systems work together in practice. It demonstrates:

- Controller input handling
- Sprite rendering
- Background scrolling
- Attribute table usage
- Basic audio output
- Simple scene sequencing

The demo presents these features in a short interactive sequence, followed by a controllable character.

## Purpose

The goal of this project is not to be a full game or engine, but rather to serve as a **clear and minimal reference** for developers learning NES architecture and 6502-based development.

It is intentionally small and focused, making it useful as a starting point or study resource.

## Build

This project uses the **WLA-DX** assembler toolchain (v9.3).

For convenience and reproducibility, the required Windows binaries are included in the `tools/` directory.

### Windows

To build the project on Windows, simply run:

```bat
build.bat
```

The required assembler binaries are located in the `tools/` directory. Newer versions of the assembler are not syntax-compatible with this project.

## Running

After building, load the generated .nes file in an emulator such as:

- Nestopia
- FCEUX
- Mesen

## Notes

- The included toolchain is a legacy version of WLA-DX (v9.3) used during original development.
- Newer versions of WLA-DX are not syntax-compatible with this project and will fail to build without modification.
- The build script assumes the included binaries and uses relative paths for portability.

##Other Platforms

This project has only been tested with the included Windows binaries.

To build on other platforms, you would need to:

- Install a compatible version of WLA-DX (v9.3)
- Adapt the build script accordingly
