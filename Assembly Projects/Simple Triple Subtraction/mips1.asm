.data
	prompt_p1:  .asciiz "Please enter an x and y value for the first point: "
	prompt_p2:  .asciiz "Please enter an x and y value for the second point: "
	result:     .asciiz "The distance between the two points is approximately: "

.text

    li $v0, 4
    la $a0, prompt_p1
    syscall
    
    li $v0, 5
    syscall
    move $t0, $v0
    
    li $v0, 5
    syscall
    move $t1, $v0

    li $v0, 4
    la $a0, prompt_p2
    syscall
    
    li $v0, 5
    syscall
    move $t2, $v0
    
    li $v0, 5
    syscall
    move $t3, $v0

    # push x1 y1 x2 y2
    addi $sp, $sp, -4
    sw $t0, 0($sp)
    
    addi $sp, $sp, -4
    sw $t1, 0($sp)
    
    addi $sp, $sp, -4
    sw $t2, 0($sp)
    
    addi $sp, $sp, -4
    sw $t3, 0($sp)
    
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    jal distance
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    
    move $t0, $v0   # distance result
    
    # print result
    li $v0, 4
    la $a0, result
    syscall
    
    li $v0, 1
    move $a0, $t0
    syscall
    
    li $v0, 10
    syscall


# ---------------------
distance:

    lw $t3, 4($sp)   # y2
    lw $t2, 8($sp)   # x2
    lw $t1, 12($sp)  # y1
    lw $t0, 16($sp)  # x1
    
    sub $t0, $t2, $t0   # dx
    sub $t1, $t3, $t1   # dy

    # square dx
    addi $sp, $sp, -4
    sw $t0, 0($sp)
    
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    jal square_me
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    lw $t4, 0($sp)      # dx^2
    addi $sp, $sp, 4

    # square dy
    addi $sp, $sp, -4
    sw $t1, 0($sp)
    
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    jal square_me
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    lw $t5, 0($sp)      # dy^2
    addi $sp, $sp, 4

    add $t6, $t4, $t5   # dx^2 + dy^2

    move $v0, $t6       # returning squared distance (integer)

    jr $ra


# ---------------------
square_me:

    lw $t0, 4($sp)
    mul $t0, $t0, $t0
    sw $t0, 4($sp)

    jr $ra
