.data
    # Substitution macros
    .eqv PRINT_STRING     4    # Permite la lectura de un string
    .eqv READ_STRING      8    # Permite la escritura de caracteres
    .eqv MAX_STRING_SIZE  80   # Tamaño máximo del string
    .eqv PROGRAM_EXIT     10

    # Variables
    input:                .space   80
    prompt:               .asciiz  "Ingresa un string: " 
    is_palindrome_msg:    .asciiz  "El string es un palíndromo.\n"
    not_palindrome_msg:   .asciiz  "El string no es un palíndromo.\n"

.text
    main:
        # Permite lectura de input
        li  $v0, PRINT_STRING
        la  $t0, prompt
        add $a0, $t0, $zero
        syscall

        # Permite escritura del input
        la      $a0, input
        li      $a1, 80
        li      $v0, READ_STRING
        syscall

        la      $t1, input
        la      $t2, input

    get_string_length: 
        lb      $t3, ($t2)
        beqz    $t3, length_is_ready
        addu    $t2, $t2, 1
        b       get_string_length

    length_is_ready:
        subu    $t2, $t2, 2

    start_loop:
        bge     $t1, $t2, is_palindrome
        lb      $t3, ($t1)
        lb      $t4, ($t2)
        bne     $t3, $t4, not_palindrome
        addu    $t1, $t1, 1
        subu    $t2, $t2, 1
        b       start_loop
 
    # Muestra resulta en consola (es palíndromo)
    is_palindrome:
        la      $a0, is_palindrome_msg
        li      $v0, PRINT_STRING
        syscall
        b       program_exit
    
    # Muestra resulta en consola (no es palíndromo)
    not_palindrome:
        la      $a0, not_palindrome_msg
        li      $v0, PRINT_STRING
        syscall
        b       program_exit

    # Escapa del programa
    program_exit:
        li      $v0, PROGRAM_EXIT
        syscall
