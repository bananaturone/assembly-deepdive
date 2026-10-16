# assembly-32bit

A small, beginner-friendly collection of 32-bit x86 assembly examples written in NASM. The starter program prints `Hello, world!` using Linux's i386 system-call interface (`int 0x80`).

## Requirements

This project targets **Linux ELF32**. On Windows, use WSL (Windows Subsystem for Linux) or another compatible Linux environment. You need NASM, GNU binutils (`ld`), and Make. On Debian/Ubuntu/WSL, install them with:

```sh
sudo apt update
sudo apt install nasm binutils make
```

The resulting 32-bit executable also needs a Linux kernel/environment capable of running i386 binaries.

## Build and run

From the repository directory:

```sh
make
make run
```

The executable is written to `build/hello`. Remove generated files with `make clean`.

## Source

- `src/hello.asm` — commented 32-bit NASM hello-world example.

## Adding examples

Add `.asm` source files under `src/` and define corresponding build targets in the `Makefile`. Keep examples focused and comment the purpose of registers, instructions, and system calls.

## License

This repository is provided under the MIT License. See `LICENSE`.
