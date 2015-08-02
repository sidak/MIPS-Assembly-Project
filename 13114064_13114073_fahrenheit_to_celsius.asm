##########################################################################################################
## GroupID- 7 (13114073_13114064) - Vikash Kumar & Sidakpal Singh Sachdeva
## Date: 08/11/2014 
## 13114064_13114073.asm - 
## 			Mips program to change input fahrenheit value to celsius value , as C = 5*(F-32)/9
 
##	Registers used: 
##  $f0 - used to hold fahrenheit input (can be float value) $f0---> F
##	$f1 - used to hold value 5.0
## 	$f2 - used to hold value 9.0
##  $f3 - used to hold value 32.0
##	$f4 - used to hold value (F-32.0) 
## 	$f5 - used to hold value 5.0*(F-32.0)
## 	$f12 - used to hold value 5.0*(F-32.0)/9.0 , which is converted celsius value
###########################################################################################################

.data
	prompt:		.asciiz		"Please enter temp in fahrenheit "     			# input prompt for fahrenheit input
	output:	.asciiz		"Converted temp in degree celsius is : "		# output prompt for celcius 

	five:		.float 		5.0												# 5.0 value as float
	nine:		.float 		9.0												# 9.0 value as float
	thirty_two:	.float		32.0 											# 32.0 value as float 

	fahrenheit:	.float		0.0 											# fahrenheit as float for input storage
	celsius:	.float		0.0 											# celsius as float for output storage

.text                       												# main starts here  
.globl main
.ent main

main:
	li	$v0 , 4																#print prompt for taking fahrenheit input
	la	$a0 , prompt
	syscall

	li  $v0 , 6																#fahrenheit input taken 
	syscall
	s.s $f0 , fahrenheit													# fahrenheit ---> $f0

	l.s 	$f1 , five                                                      # $f1 ---> 5.0
	l.s 	$f2 , nine														# $f2 ---> 9.0
	
	l.s  	$f3 , thirty_two												# $f3 ---> 32.0
	sub.s 	$f4 , $f0 , $f3	# (F-32)										# $f4 ---> (F-32.0)

	mul.s 	$f5 , $f1 , $f4													# $f5 ---> 5.0*(F-32.0)
	div.s   $f12 , $f5 , $f2												# $f12 ---> 5.0/9.0*(f-32.0)

	s.s 	$f12 , celsius													# celsius ---> $f12

	li	$v0 , 4																# output prompt
	la	$a0 , output
	syscall

	li 		$v0 , 2
	l.s 	$f12, celsius													# printing celsius value
	syscall

	li 		$v0 ,11 														# for line change
	la		$a0 ,10
	syscall

	li		$v0 , 10 														# terminate code
	syscall
.end main	
