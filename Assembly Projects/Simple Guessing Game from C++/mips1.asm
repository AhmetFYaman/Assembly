.data	
	
	prompt1:		.asciiz		"Player 1: Enter a number between 1 and 10: "
	prompt2:		.asciiz		"Next player\n"	
	prompt3:		.asciiz		"Please enter your guess between 1 and 10: "
	prompt4:		.asciiz		"Please guess again!\n"
	prompt5:		.asciiz		"YOU WIN!"


.text
	 # prompt user for a number
	 li $v0, 4
	 la $a0, prompt1
	 syscall
	 
	 li $v0, 5
	 syscall
	 move $t0, $v0   # store hidden number in $t0
	 
	  # next player
	  
	 li $v0, 4
	 la $a0, prompt2
	 syscall
	 
	 li $t1, 0  # take guesses to $t1
	 
	 
while_loop:
	
	# prompt for player two
	li $v0, 4
	la $a0, prompt3    # prompt useer guess
	syscall
	
	li $v0, 5      # take user guess
	syscall       
	move $t1, $v0 
	
	beq $t1, $t0, win    # if they guessed right skip immediately
	
	li $v0, 4
	la $a0, prompt4
	syscall
	
	j while_loop
	
win:
    # print "YOU WIN!"
        li $v0, 4
        la $a0, prompt5
    	syscall

	    # Exit program
    	li $v0, 10
    	syscall	
	 	
	
	
	
	 	    
	 