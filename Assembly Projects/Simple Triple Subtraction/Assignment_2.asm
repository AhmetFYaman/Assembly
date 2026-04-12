.data 
	promptWelcome:		.asciiz		" Welcome! This program subtracts three integer numbers.\n"
	promptQuestion:		.asciiz 	"Please input three integers x, y, z: \n"
	promptResult:		.asciiz		"The result of (x - y - z) is: "
	
.text
	#prompt the welcome
	li $v0, 4
	la $a0, promptWelcome
	syscall
	
	#prompt the question
	li $v0, 4
	la $a0, promptQuestion
	syscall
	
	#get number
	li $v0, 5
	syscall
	move $t0, $v0 #move number x to t0
	
	li $v0, 5
	syscall
	move $t1, $v0 #move number y to t1
	
	li $v0, 5
	syscall 
	move $t2, $v0 #move number z to t2
	
	sub $t0, $t0, $t1 #  t0(x) = t0(x) - t1(y)
	sub $t0, $t0, $t2 #  t0(x-y) = t0(x-y) - t2(z)
	
	li $v0, 4
	la $a0, promptResult
	syscall	
	
	li $v0, 1
	move $a0, $t0
	syscall	
	
	li $v0, 10
	syscall