# this program uses jump to print 11 after asking user

.data 
    prompt: .asciiz "Do you want to output an 11 (1 == yes):"


.text 
    li $v0, 4
    la $a0, prompt
    syscall

    li $v0, 5
    syscall
    move $t0, $v0

    beq $t0, 1, eleven

    li $v0, 1
    li $a0, 0
    syscall 