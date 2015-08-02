###############################################################################
## GroupID-7 (13114064_13114073) - Sidakpal Singh Sachdeva & Vikash Kumar    
## Date: 09/11/2014								
## 13114064_13114073_ascii.asm - 
## 		Mips Assembly Program to verify that multidigit ASCII addition of 
##		the strings gives the same result as sum calculated by converting
##		the ASCII strings into integer.
##
## Registers used in main :  no temporary or saved registers used
##
## Registers used in method1 : 
##		 $t5 -> to hold the final answer
##		 $t1 -> to hold the first integer returned from method 
##		 $t2 -> to hold the second integer returned from method 
##  
## Registers used in method2 : 
##  
## Registers used in asciiToInt : 
##		 $t4 -> To hold the base address of the input string
##		 $t0 -> To hold the final result
##	     $t1 -> To hold the length of the string
##		 $t2 -> To be used as counter
##		 $t3 -> To store a particular byte from the input string
##  
################################################################################

# Data Declarations

.data
	str1:	.space 9		# str1 stores the value of 1st enrollment no.
	str2:	.space 9		# str2 stores the value of 2nd enrollment no.
	str3:	.space 10		# str3 stores the value of final answer (sum).
	temp:	.space 9
	len:	.word 8			# len stores the value of length of string
	int1:	.word 0			
	int2:	.word 0
	prompt:	.asciiz "Please enter the two enrollment numbers \n"
	msg1:	.asciiz "\n Answer calculated by converting ascii to int \n"
	msg2:	.asciiz "\n Answer calculated by multi-digit ascii addition \n"
	flag:	.word 0

# -------------------------------------------------------------------------------
# Code Section

.text

# -----The main entry program--------#

.globl main
.ent main
main:
	
	li $v0, 4			# print the prompt string
	la $a0, prompt
	syscall
	
	li $v0, 8			# read the str1
	la $a0, str1
	syscall
	
	li $v0, 8			# read the str2
	la $a0, str2
	syscall
	
	li $v0, 4			#print msg1
	la $a0, msg1
	syscall
	
	jal method1			#call method1
	
	li $v0, 4			#print msg2
	la $a0, msg2
	syscall
	
	jal method2			#call method2
	
	li $v0, 10			#terminate program
	syscall
	
.end main

# -----This method prints the sum by converting each string to integer--------#
	# Arguments
	# NULL

	# Returns
	# NULL
	
	# Registers used 
	# $t5 -> to hold the final answer
	# $t1 -> to hold the first integer returned from method 
	# $t2 -> to hold the second integer returned from method 
#------------------------------------------------------------------------------#	
.globl method1
.ent method1
method1:
	li $t5, 0				
	
	la $a0, str1			# store the address of str1 in $a0 to pass as an argument
	
	subu $sp , $sp,4		# allocate space in stack
	sw $ra, ($sp)			# store the value of $ra in stack 
	
	jal asciiToInt			# call helper method to convert the str1 to integer word
	
	lw $ra , ($sp)			# restore the original value of $ra from stack
	addu $sp, $sp, 4		# free space in stack
	
	move $t1, $v0			# store the return value of the method in $t1
	
	add $t5,$t5, $t1		
	
	la $a0, str2			# store the address of str2 in $a0 to pass as an argument
	
	subu $sp , $sp,4		# allocate space in stack
	sw $ra, ($sp)			# store the value of $ra in stack 
	
	jal asciiToInt			# call helper method to convert the str2 to integer word
	
	lw $ra , ($sp)			# restore the original value of $ra from stack
	addu $sp, $sp, 4		# free space in stack
	
	move $t2, $v0			# store the return value of the method in $t2
	
	add $t5,$t5, $t2
	
	li $v0, 1				# output the final sum
	move $a0, $t5
	syscall
	
	j $ra					# jump back to calling routine
	
.end method1

# -----Helper method to convert ASCII to integer--------#

	# Arguments
	# $a0 -> Argument passed on by the caller method 
	#   	which stores the base address of the string
	

	# Returns
	# $v0 -> Integer value of the string
	
	# Registers used
	# $t4 -> To hold the base address of the input string
	# $t0 -> To hold the final result
	# $t1 -> To hold the length of the string
	# $t2 -> To be used as counter
	# $t3 -> To store a particular byte from the input string
# --------------------------------------------------------#	
.globl asciiToInt
.ent asciiToInt

asciiToInt:
							# load registers with initial values
	move $t4, $a0	
	
	li $t0, 0		
	lw $t1, len		
	
	li $t2, 0		
	
	loop:
		
		lb $t3, 0($t4)		# $t3 = Mem[ $t4 + 0]   
		sub $t3, $t3, 48	# $t3 = $t3 - 48 , convert from ascii representation to integer
		mul $t0, $t0, 10	# $t0 = $t0 * 10	
		add $t0, $t0, $t3	# $t0 = $t0 + $t3	
		
		add $t2, $t2, 1		# increment the value in register (counter)
		add $t4, $t4, 1		# increment the offset for accessing the next byte 
		
		blt $t2, $t1, loop  # if $t2 < $t1 , branch to loop
	
	move $v0, $t0			# store the final integer result in $v0
	j $ra					# jump back to caller method 
.end asciiToInt

# -----This method prints the sum by digit-by-digit addition--------#
	
	# Arguments
	# NULL

	# Returns
	# NULL
	
.globl method2
.ent method2
method2:
	
	# store the len of string in t0
	lw $t0, len 
	sub $t0, $t0, 1 # index i for str1 and str2
	
	#store base address of str3
	la $t3, str3
	
	li $t4, 0	#t4 is endCarry
	
	li $t5, 10	
	# prob for signed
	
	addiu $t3, $t3, 9  
	sb $zero, 0($t3)
	subu $t3, $t3, 1
	
	addStr:
		lb $t1, str1($t0)
		lb $t2, str2($t0)
		sub $t1, $t1,48
		sub $t2, $t2,48
		
		add $t1, $t1, $t2
		add $t1, $t1, $t4
		move $t6, $t1
		bge $t6, $t5, handleCarry
		blt $t6, $t5, noCarry
		
	cont:
		sub $t0, $t0, 1
		subu $t3, $t3, 1
		bltz $t0, lastCase
		j addStr 
		
			
	handleCarry:
		addi $t1, $t1, 38
		sb $t1, 0($t3)
		li $t4, 1
		
		j cont
		
		
	noCarry:	
		addi $t1, $t1, 48
		sb $t1, 0($t3)
		li $t4, 0
		
		j cont
		
	lastCase:
		move $t7, $t4
		addi $t4, $t4, 48
		sb $t4, 0($t3)
		
		blez $t7, printWithoutCarry
		
		move $t7, $zero
		j printWithCarry
	
	
	
	printWithoutCarry:
		la $t7, str3
		addiu $t7, $t7, 1
		li $v0, 4
		move $a0, $t7 
		syscall
		
		lw $t7, flag
		addi $t7, $t7, 1
	
	printWithCarry:
		bgtz $t7, return
		li $v0, 4
		la $a0, str3
		syscall
	
	return:
		j $ra
	
	
.end method2


