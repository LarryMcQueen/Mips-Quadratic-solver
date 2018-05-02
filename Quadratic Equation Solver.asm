.data
	AX:  .asciiz "Enter a value for (a): "
	BX:  .asciiz "Enter a value for (b): "
	CX:  .asciiz "Enter a value for (c): "
	join: .asciiz " and "
	
	
.text
main:

	#Enter a value for a
	li $v0, 4
	la $a0, AX
	syscall

	#input a
	li $v0, 5
	syscall
	move $t0, $v0
	
	
	#Enter a value for b
	li $v0, 4
	la $a0, BX
	syscall
	
	#input b
	li $v0, 5
	syscall
	move $t1, $v0
	
	
	#Enter a value for c
	li $v0, 4
	la $a0, CX
	syscall
	
	#input c	
	li $v0, 5
	syscall
	move $t2, $v0
	
	#multiply a by c
	mult $t0, $t2
	mflo $t3
	
	#introduce 4
	#li $v0, 4
	#move $t4, $v0
	li $t4, 4
	
	#solve 4*a*c
	mult $t4, $t3
	mflo $t4
	
	#solve b*b
	mult $t1, $t1
	mflo $t5
	
	
	#introduce 2
	#li $v0, 2
	#move $t6, $v0
	li $t6, 2
	
	#solve 2*a
	mult $t6, $t0
	mflo $t6
	
	#subtract b*b by 4ac = d
	sub $t7, $t5, $t4
	
	# introduce 0
	li $t3, 0
	
	# check if d (i.e. $t7) is less than or equal to zero
	ble $t7, $t3, exit
	
	#moving to c0 processor 1 so i can complete the rest of the equation in float
	mtc1 $t7, $f1
	
	#converting from word to float
	cvt.s.w $f1, $f1
	
	#squareroot of d 
	sqrt.s $f3, $f1	
	
	#moving 2*a to co processor 1 
	mtc1 $t6, $f5
	
	#converting from word to float
	cvt.s.w $f5, $f5
	
	#moving b into co processor 1
	mtc1 $t1, $f2


	#converting from word to float
	cvt.s.w $f2, $f2
	
	#negate b
	neg.s $f4, $f2
	
	#add -b + d
	add.s $f6, $f4, $f3
	
	#divide -b + d/2a
	div.s $f7, $f6, $f5
	
	#divide -b - d
	sub.s $f8, $f4, $f3
	
	#divide -b - d/2a
	div.s $f9, $f8, $f5
	
	
	
	li $v0, 2	
	mov.s $f12, $f7
 	syscall
 	
 	li $v0, 4
	la $a0, join
	syscall
 	
 	li $v0, 2	
	mov.s $f12, $f9
 	syscall
	
exit:
	li $v0, 10
	syscall
