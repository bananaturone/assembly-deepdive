; Problem 2: Simple calculator
; Target: 32-bit x86 NASM, Linux ELF32
; Inputs are single digits from 0 to 9.

section .data
    title db 10, "=== SIMPLE CALCULATOR ===", 10
          db "1. Addition", 10
          db "2. Subtraction", 10
          db "3. Multiplication", 10
          db "4. Division", 10
          db "5. Exit", 10
          db "Choose operation: "
    title_len equ $ - title
    first_msg db "Enter first number (0-9): "
    first_len equ $ - first_msg
    second_msg db "Enter second number (0-9): "
    second_len equ $ - second_msg
    result_msg db "Result: "
    result_len equ $ - result_msg
    again_msg db "Do another calculation? (Y/N): "
    again_len equ $ - again_msg
    invalid_msg db "Invalid choice!", 10
    invalid_len equ $ - invalid_msg
    zero_msg db "Cannot divide by zero!", 10
    zero_len equ $ - zero_msg
    newline db 10

section .bss
    choice resb 2
    num1 resb 2
    num2 resb 2
    again resb 2
    result_buffer resb 12
    negative_flag resb 1

section .text
    global _start

_start:
calculator_loop:
    ; Show the menu and read the operation.
    mov eax, 4
    mov ebx, 1
    mov ecx, title
    mov edx, title_len
    int 0x80

    mov eax, 3
    xor ebx, ebx
    mov ecx, choice
    mov edx, 2
    int 0x80

    cmp byte [choice], '5'
    je exit_program

    ; Reject anything except choices 1 to 4.
    cmp byte [choice], '1'
    jb invalid_choice
    cmp byte [choice], '4'
    ja invalid_choice

    ; Read the two single-digit numbers.
    mov eax, 4
    mov ebx, 1
    mov ecx, first_msg
    mov edx, first_len
    int 0x80

    mov eax, 3
    xor ebx, ebx
    mov ecx, num1
    mov edx, 2
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, second_msg
    mov edx, second_len
    int 0x80

    mov eax, 3
    xor ebx, ebx
    mov ecx, num2
    mov edx, 2
    int 0x80

    ; Convert ASCII digits to numbers.
    movzx eax, byte [num1]
    sub eax, '0'
    movzx ebx, byte [num2]
    sub ebx, '0'

    mov cl, [choice]
    cmp cl, '1'
    je addition
    cmp cl, '2'
    je subtraction
    cmp cl, '3'
    je multiplication
    jmp division

addition:
    mov byte [negative_flag], 0
    add eax, ebx
    jmp display_result

subtraction:
    cmp eax, ebx
    jae subtract_positive
    sub ebx, eax
    mov eax, ebx
    mov byte [negative_flag], 1
    jmp display_result
subtract_positive:
    sub eax, ebx
    mov byte [negative_flag], 0
    jmp display_result

multiplication:
    mov byte [negative_flag], 0
    imul eax, ebx
    jmp display_result

division:
    mov byte [negative_flag], 0
    cmp ebx, 0
    je divide_by_zero
    xor edx, edx
    div ebx
    jmp display_result

; Convert the non-negative value in EAX to decimal text.
display_result:
    mov esi, result_buffer + 11
    mov byte [esi], 10
    dec esi
    mov ebx, 10
    cmp eax, 0
    jne convert_digits
    mov byte [esi], '0'
    jmp print_result

convert_digits:
    xor edx, edx
    div ebx
    add dl, '0'
    mov [esi], dl
    dec esi
    test eax, eax
    jnz convert_digits
    inc esi

print_result:
    cmp byte [negative_flag], 1
    jne print_result_message
    dec esi
    mov byte [esi], '-'

print_result_message:
    mov eax, 4
    mov ebx, 1
    mov ecx, result_msg
    mov edx, result_len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, esi
    mov edx, result_buffer + 12
    sub edx, esi
    int 0x80
    jmp ask_again

invalid_choice:
    mov eax, 4
    mov ebx, 1
    mov ecx, invalid_msg
    mov edx, invalid_len
    int 0x80
    jmp calculator_loop

divide_by_zero:
    mov eax, 4
    mov ebx, 1
    mov ecx, zero_msg
    mov edx, zero_len
    int 0x80
    jmp ask_again

ask_again:
    mov eax, 4
    mov ebx, 1
    mov ecx, again_msg
    mov edx, again_len
    int 0x80

    mov eax, 3
    xor ebx, ebx
    mov ecx, again
    mov edx, 2
    int 0x80

    cmp byte [again], 'Y'
    je calculator_loop
    cmp byte [again], 'y'
    je calculator_loop
    jmp exit_program

exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80
