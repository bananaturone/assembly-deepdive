; 32-bit x86 NASM hello-world for Linux (ELF32).
; Build with: nasm -f elf32 src/hello.asm -o build/hello.o
; Link with:  ld -m elf_i386 build/hello.o -o build/hello

section .data
    message db "Hello, world!", 10 ; Text followed by a newline.
    message_length equ $ - message

section .text
    global _start

_start:
    ; write(1, message, message_length)
    mov eax, 4                  ; i386 sys_write
    mov ebx, 1                  ; file descriptor: stdout
    mov ecx, message            ; address of the text
    mov edx, message_length     ; number of bytes to write
    int 0x80                    ; enter the kernel

    ; exit(0)
    mov eax, 1                  ; i386 sys_exit
    xor ebx, ebx                ; status code 0
    int 0x80                    ; enter the kernel
