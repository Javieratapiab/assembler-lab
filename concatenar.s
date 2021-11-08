## Segmento de datos ##
.data
  # Substitution macros
  .eqv PRINT_STRING     4     # Permite la lectura de un string
  .eqv READ_STRING      8     # Permite la escritura de caracteres
  .eqv PROGRAM_EXIT     10
  .eqv MAX_STRING_SIZE  80   # Tamaño máximo del string

  # Variables 
  prompt_str_1:      .asciiz     "Ingresa el primer string: "
  prompt_str_2:      .asciiz     "Ingresa el segundo string: "
  prompt_final_msg:  .asciiz     "El string concatenado es: "
  input_str_1:       .space      128
  input_str_2:       .space      128
  output:            .space      256

.text
  main:
    # Permite lectura de primer string
    la $a0, prompt_str_1
    li $v0, PRINT_STRING
    syscall

    # Permite escritura de primer string
    li $v0, READ_STRING
    la $a0, input_str_1
    li $a1, MAX_STRING_SIZE
    add $t1, $zero, $a0
    syscall

    # Permite lectura de segundo string
    li $v0, PRINT_STRING
    la $a0, prompt_str_2
    syscall

    # Permite escritura de segundo string
    li $v0, READ_STRING
    la $a0, input_str_2
    li $a1, MAX_STRING_SIZE
    add $t2, $zero, $a0 
    syscall

    li $t3, 0

  concat_one:
    lb $t4, 0($t1)
    beq $t4, '\n', concat_two
    sb $t4, output($t3)
    addi $t3, $t3, 1
    addi $t1, $t1, 1
    j concat_one

  concat_two:
    lb $t4, 0($t2)
    beq	$t4, '\n', print_result
    sb	$t4, output($t3)
    addi $t3, $t3, 1
    addi $t2, $t2, 1
    j concat_two

  print_result:
    # Imprime mensaje final
    li $t4, 0
    sb $t4, output($t3)
    la $a0, prompt_final_msg
    li $v0, PRINT_STRING
    syscall
    
    # Imprime resultado
    la $a0, output
    li $v0, PRINT_STRING
    syscall
