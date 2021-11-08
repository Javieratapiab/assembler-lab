## Segmento de datos ##
.data
# Substitution macros
    .eqv PRINT_STRING     4    # Permite la lectura de un string
    .eqv READ_STRING      8    # Permite la escritura de caracteres
    .eqv PRINT_INT        1
    .eqv PROGRAM_EXIT     10
    .eqv MAX_STRING_SIZE  80   # Tamaño máximo del string
    .eqv NEWLINE          0xA  # Salto de línea

# Variables 
    prompt:        .asciiz      "Ingresa un string: "
    final_prompt:  .asciiz      "El string invertido es: "
    input:         .space       80
    idx_head:      .word        0
    idx_tail:      .word        0

## Texto ##
.text
    # Permite lectura de input
    li  $v0, PRINT_STRING
    la  $t0, prompt                # Setea $t0 con la dirección del mensaje en terminal
    add $a0, $t0, $zero           
    syscall                        
	
    # Permite escritura del input
    li  $v0, READ_STRING   
    la  $t0, input                 # Setea $t0 con la dirección del input
    add $a0, $t0, $zero            
    li  $a1, MAX_STRING_SIZE
    syscall

    # Calcula el largo del string en $t3
    la  $a0, input
    jal get_string_length
    move $s3, $t3                  # Preserva el largo del input calculado
    beqz $s3, program_exit         # Escapa del programa si el input está vacío
    
    # Explicación algoritmo: Se define un puntero para la cola y cabeza del string,
    # de esta manera, podemos hacer un swap de caracteres al mover los índices de ambos hasta recorrer
    # todo el string.
    move $t0, $s3                  # Obtiene largo del input
    move $t1, $zero                # Inicia idx_head 
    addu $t2, $t1, $t0             # Inicia idx_tail
    la   $t4, input              

# Intercambia caracteres (in place)
swap_chars:
    lb   $t5, input($t1)     
    lb   $t6, input($t2)      
    sb   $t6, input($t1)      
    sb   $t5, input($t2)      
    addi $t1, $t1,  1         
    addi $t2, $t2, -1         
    slt  $t7, $t1, $t2        
    bnez $t7, swap_chars

    # Imprime el resultado
    li  $v0, PRINT_STRING
    la  $t0, final_prompt
    add $a0, $t0, $zero
    syscall  

    li  $v0, PRINT_STRING
    la  $t0, input 
    add $a0, $t0, $zero
    syscall

# Escapa del programa si el string es vacío
program_exit:    
    li $v0, PROGRAM_EXIT
    syscall

## Procedimientos ##
get_string_length:
    addiu $sp, $sp, -20               # Asigna espacio para preservar 5 registros de 4-bytes
    sw $ra, 0($sp)
    sw $t1, 4($sp)
    sw $a0, 8($sp)
    sw $t2, 12($sp)
    sw $t4, 16($sp)

    # Busca el largo del string
    move $t4, $a0                     # Dirección del string
    move $t3, $zero                   # Inicia el buffer del índice
    li   $t1, NEWLINE
   
# Compara cada caracter con un salto de línea
# para saber si es o no el final del string
is_char_newline:
    addu $a0, $t4, $t3                # Computa la dirección de un char
    lb   $t2, 0($a0)                  # Carga el siguiente caracter desde el input
    beq  $t1, $t2, length_is_ready    # Compara el char con el salto de línea \n
    addi $t3, $t3, 1                  # Incrementa el index
    j is_char_newline

length_is_ready:
    lw $ra, 0($sp)
    lw $t1, 4($sp)
    lw $a0, 8($sp)
    lw $t2, 12($sp)
    lw $t4, 16($sp)
    addiu $sp, $sp, 20                # Desasigna espacio de registro
    jr $ra                            # Retorno a la instrucción de llamada
