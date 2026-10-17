; Problem 1: Check if a character is a vowel
; Target: 32-bit x86 NASM, Linux ELF32

section .data
    vowel_msg db "The character is a vowel.", 10
    vowel_len equ $ - vowel_msg
    not_vowel_msg db "The character is not a vowel.", 10
    not_vowel_len equ $ - not_vowel_msg

section .text
    global _start

_start:
    ; Change this character to test another input.
    mov al, 'E'

    ; Compare the character with each uppercase vowel.
    cmp al, 'A'
    je vowel
    cmp al, 'E'
    je vowel
    cmp al, 'I'
    je vowel
    cmp al, 'O'
    je vowel
    cmp al, 'U'
    je vowel
    jmp not_vowel

vowel:
    mov eax, 4              ; sys_write
    mov ebx, 1              ; standard output
    mov ecx, vowel_msg
    mov edx, vowel_len
    int 0x80
    jmp exit

not_vowel:
    mov eax, 4              ; sys_write
    mov ebx, 1
    mov ecx, not_vowel_msg
    mov edx, not_vowel_len
    int 0x80

exit:
    mov eax, 1              ; sys_exit
    xor ebx, ebx            ; return code 0
    int 0x80
