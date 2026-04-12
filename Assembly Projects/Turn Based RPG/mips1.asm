.data

	gameData: 	.space	32   # 4 objects each with 2 ints (8),  4 x 8 = 32
	objectSize:	.word	8 
	
	str_player:    .asciiz "=== PLAYER ===\n"
	str_monster:   .asciiz "=== Monster "
	str_hp:        .asciiz " | HP: "
	str_str:       .asciiz " | STR: "
	str_newline:   .asciiz "\n"
	str_dead:      .asciiz " | DEAD\n"	
	
	str_choice:   .asciiz "\nAttack (1) or Heal (2): "
	str_attack:   .asciiz "You attacked the monster!\n"
	str_heal:     .asciiz "You healed yourself!\n"
	str_invalid:  .asciiz "Invalid choice, try again!\n"
	
	str_monsterhit: .asciiz "A monster attacked you!\n"
	
	str_win:  .asciiz "You win!\n"
	str_lose: .asciiz "You died!\n"
	

.text
	jal createPlayer
	jal createMonster
	
gameLoop:
	jal displayAll
	jal playerTurn
	jal checkGameOver
	beq  $v0, 1, gameExit
	jal monsterTurn
	jal checkGameOver
	beq  $v0, 1, gameExit
	
	j gameLoop
	
	#---- Exit ---
gameExit:	
	li $v0, 10
	syscall
	





randRange:
	move $t0, $a0        #save min in $t0 to give the illusion that we can set a specific min in $a0 for simplicity, but its 0 unchangable
	sub $a1, $a1, $a0       # range_size = max - min  subtract the min from our max because we can't set a min 
	addi $a1, $a1, 1         #make inclusive
	li $v0, 42              # load random into v0
	li $a0, 0              # RNG id = 0    $a0 original purpose is to set the rng ID, so we grab rng 0 numbers
	syscall        #  get the random int back in $a0
	add $v0, $a0, $t0        # add minimum back to keep the illusion that we were able to set the minimum using $a0 in the function
	jr $ra

	
createPlayer:
	
    	addi $sp, $sp, -4
    	sw $ra, 0($sp)	
    	
    	# random strength between 5 - 12
	li $a0, 5  # a0 is our min, kinda, check the comments in the function
	li $a1, 12 # that is our max
	jal randRange
	sw $v0, gameData+4   # store random strength to offset of 4
	
	# random health between 25 - 50
	
	li $a0, 25  # a0 is our min, kinda, check the comments in the function
	li $a1, 50 # that is our max
	jal randRange
	sw $v0, gameData   # store random hp to no offset

	
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4
    	jr $ra
createMonster:  # called right after creating the player to base it off of the player's stats

	addi $sp, $sp, -4
	sw $ra, 0($sp)    # save return address
	
	lw $s0, gameData  #get player health to $s0
	lw $s1, gameData+4  #get player strength to $s1
	
	li $s2, 1 # monsters start with index 1 till 3. for 3 monsters
	
monsterLoop:  # creation continued, simplified, looped
	
	bgt $s2, 3, monsterLoopEnd  # condition to end loop and go to the next step, s2 can be 1, 2, 3 
	
	lw $t2, objectSize
	mul $t0, $s2, $t2  # store the offset for each monster in $s3, because t1 will be corrupted in randRange

	la $s3, gameData
	add $s3, $s3, $t0	
	# ------------ health ------------
	li $t2, 3
	div $s0, $t2       # divide player health that we stored in $s0 with 3
	mflo $a0      # load quotient into $a0 to use as min 
	
	li $t2, 110
	mul $t3, $s0, $t2   # multiply by 110
	li $t2, 100  # load 100  
	div  $t3, $t2  # divide by 100 to get x110 /100  = 110%
	mflo $a1    #store it in $a1 for max random
	
	jal  randRange    # generate random value 



	sw $v0, 0($s3)         # store random value as monster health first
	
	# ----------- strength ----------------
	li $t2, 3
	div $s1, $t2       # divide player strength  that we stored in $s0 with 3
	mflo $a0      # load quotient into $a0 to use as min 
	
	li $t2, 110
	mul $t3, $s1, $t2   # multiply by 110
	li $t2, 100  # load 100  
	div  $t3, $t2  # divide by 100 to get x110 /100  = 110%
	mflo $a1    #store it in $a1 for max random
	
	jal  randRange    # generate random value 
	sw $v0, 4($s3)    #store monster strength 4 from the health position
	
	addi $s2, $s2, 1   # increment monster index
	j monsterLoop    # jump to start   each monster gets a shot
	
monsterLoopEnd:                 # next step, return
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	

displayAll:
 	
	# --------- print player ------------
	li $v0, 4
	la $a0, str_player
	syscall       # print "=== PLAYER ==="
	
	li $v0, 4
    	la $a0, str_hp
 	syscall

	
	li $v0, 1
    	lw $a0, gameData        # player health at offset 0
    	syscall	
	

    	li $v0, 4
   	la $a0, str_str
  	syscall

 	li $v0, 1
 	lw $a0, gameData+4      # player strength at offset 4
   	syscall

 	li $v0, 4
 	la $a0, str_newline
  	syscall	
	
	
	# --------- priont Monster loop
	
	li $s0, 1 # monster index 1
	
displayLoop:
	bgt $s0, 3, displayDone     # if greater than the 3rd monster jump to done
	
	lw $t2, objectSize
	mul $t1, $s0, $t2   # multiply index x objectSize to get right offset
   	la $t0, gameData            # get array start
    	add $t0, $t0, $t1	      # add offset to t0 
	
  	lw $t2, 0($t0)                # load monster health
   	ble $t2, 0, skipMonster      # skip if dead
   	
    	li $v0, 4     
	la $a0, str_monster  # print  ---monster----
    	syscall  
    	
    	li $v0, 1
    	move $a0, $s0             # print monster index number
    	syscall	
    	
    	# --- Print Monster HP ---
    	li $v0, 4
    	la $a0, str_hp
    	syscall

    	li $v0, 1        # t0 is the monster health
    	lw $a0, 0($t0)        
    	syscall

    	# --- Print Monster STR ---
    	li $v0, 4
    	la $a0, str_str
    	syscall

    	li $v0, 1
    	lw $a0, 4($t0)          # monster strength
    	syscall

    	li $v0, 4
    	la $a0, str_newline
    	syscall    	
	
	
skipMonster:
    addi $s0, $s0, 1
    j displayLoop

displayDone:
    jr $ra	
	

playerTurn:
	# handling player input and action, no parameters needed
	# it will use $s0 for player strength, $s1 for loop counter for finding first monster
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)     # we are gonna call range which will use $ra, so lets save the return $ra in the stack to keep it safe if we need it
	
promptAgain:	# come back here to ask until he gives a 1 or a 2
    	li $v0, 4
    	la $a0, str_choice         # prompt the choices (1) attack, (2) heal
    	syscall

    	li $v0, 5             # get int input
    	syscall
    	move $t0, $v0       # move it to $t0

    # invalid check
    	beq $t0, 1, doAttack         # if its 1 go do Attack
    	beq $t0, 2, doHeal          # if its 2 go do heal
    	li $v0, 4         
    	la $a0, str_invalid          # prompt invalid if it gets here
    	syscall
    	j promptAgain                 # loop back to ask the choices again
    	
doHeal:
    	lw $t0, gameData       # load player health to $t0 , we stopped using it
    	lw $t1, gameData+4      # load player strength into $t1
    	add $t0, $t0, $t1         # add heal = heal + strength
    	sw $t0, gameData          # save it back in our array
    	li $v0, 4        # print
    	la $a0, str_heal         # healed 
    	syscall
    	j playerTurnDone      #jump to done
    	
    	
doAttack:
	lw $s0, gameData+4          # load player strength to s0
	li $s1, 1                # index the monsters
	
attackLoop:

	lw $t2, objectSize
	mul $t0, $s1, $t2     # stores the offset we will use
	
	la $t1, gameData        # get the array to t1
    	add $t1, $t1, $t0        # add in the offset
    	lw $t2, 0($t1)	  # load whats in that offset (index - moster health) into t2  
    	bgt $t2, 0, attackHit    # monster has more health than 0, take the attck
    	addi $s1, $s1, 1          # that monster is dead, add an index value to monster index
    	bgt $s1, 3, playerTurnDone  # if index value crossed 3 just finish the turn, end the stuff
    	j attackLoop     # if we get all the way down here, that means we picked a dead monster, so we start over with the new index that does exist (1-3)
	
attackHit:
    	sub $t2, $t2, $s0   # t2 the monsters health value - s0 the players strength loaded at doAttack
    	sw $t2, 0($t1)         # store the resulting health back into t1 the address with the offset of the monsters health
    	li $v0, 4         # print
    	la $a0, str_attack          # the attack
    	syscall       
    	
playerTurnDone:         # returning
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4
    	jr $ra             

monsterTurn:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $s0, 1       # create its own indexing, start at index 1
	
monsterLoop1:

	bgt $s0, 3, monsterTurnDone  # if monsters 1-3 are done with, end it
	
	lw $t2, objectSize
	mul $t0, $s0, $t2  # create offset tracking on t0 based off of indexing at s0 
	la $s3, gameData      # hold aray start at s3, because the t0,t1 will get curropted in randRange
	add $s3, $s3, $t0     # combine the offset with the gameData address to get monster hp
	lw $t2, 0($s3)         # load that monsters health
	ble $t2, 0, monsterNext    # if its zero skip monster and start over 
	
	# ----- 50% attack chance ----------
	
	li $a0, 1
	li $a1, 10         # pick from a list of numbers 1-10 just like the assignment wants
	jal randRange      # half of the numbers picked will be attack, half of the numbers picked will be skip
	
	ble $v0, 5, monsterNext     # if 5 or less  skip turn for this monster, move onto what the next monster will do
	
	# monster attacks
	
	lw $t3, 4($s3)                # store monster strength
	lw $t4, gameData            # store player health to t4
	sub $t4, $t4, $t3           # sub the monster st from player hp
	sw $t4, gameData             # store new player hp back to array
	li $v0, 4                  #print
	la $a0, str_monsterhit      # monster hit us
	syscall
	
monsterNext: 
	addi $s0, $s0, 1
	j monsterLoop1

monsterTurnDone:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra


	
checkGameOver:

	# at the end , lets check for win/lose conditions
	
	lw $t0, gameData
	ble $t0, 0, playerDead	
	
	# check all monster health to see if we can continue
    	lw $t0, gameData+8     # monster 1 health
    	bgt $t0, 0, gameOngoing # still alive, game continues
    	lw $t0, gameData+16    # monster 2 health
    	bgt $t0, 0, gameOngoing
    	lw $t0, gameData+24    # monster 3 health
    	bgt $t0, 0, gameOngoing	
    	
    	
    	# if all monsters are dead
    	
    	li $v0, 4
    	la $a0, str_win
    	syscall
    	li $v0, 1
    	jr $ra
    	
playerDead:
	li $v0, 4
	la $a0, str_lose 
	syscall
	li $v0, 1  # will indicate a stop
	jr $ra
	
	
gameOngoing:
    	li $v0, 0   # will indicate a continue
    	jr $ra
    	
    	