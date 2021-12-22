
;<Memory Test for 64KB of continues ram>
;Address ending in 32768 is intentional. 
;We go one byte over into the second ram chip.
	mvi d,0		;load 0 into the 'D' reg
start:	lxi sp,65500	;start the stack pointer here
	lxi h,421	;start address
	lxi b,32768	;end address
tst1:	mvi m,170	;load bit pattern into memory pointed to by HL
	mov a,l		;move L to A
	cmp c		;compare it to C
	jnz tstn1	;if not zero then jump
	mov a,h		;move H to A
	cmp b		;compare it to B
	jnz tstn1	;if not zero then jump
;flip between ram chips to test proper bank switching.
	lxi h,32769	;start address
	lxi b,65535	;end address
tst3:	mvi m,85	;load bit pattern into memory pointed to by HL
	mov a,l		;move L to A
	cmp c		;compare it to C
	jnz tstn3	;if not zero then jump
	mov a,h		;move H to A
	cmp b		;compare it to B
	jnz tstn3	;if not zero then jump
;Now read back and test...
	lxi h,421	;start address
	lxi b,32768	;end address
tst2:	mov a,m		;move MEM to A
	cpi 170		;compare it to number
	jnz fail	;if not zero then jump
	mov a,l		;move L to A
	cmp c		;compare it to C
	jnz tstn2	;if not zero then jump
	mov a,h		;more H to A
	cmp b		;compare it to B
	jnz tstn2	;if not zero then jump
;flip between ram chips to test proper bank switching.
	lxi h,32769	;start address
	lxi b,65535	;end address
tst4:	mov a,m		;move MEM to A
	cpi 85		;compare it to number
	jnz fail	;if not zero then jump
	mov a,l		;move L to A
	cmp c		;compare it to C
	jnz tstn4	;if not zero then jump
	mov a,h		;more H to A
	cmp b		;compare it to B
	jnz tstn4	;if not zero then jump
;******************************************
;now test multiples of 3 byte patterns.
	lxi h,421
	lxi b,32768
	mvi e,1
tst5:   mov a,e
	cpi 1
	jnz t5nxt1
	mvi m,240
	mvi e,2
	jmp cnt5
t5nxt1:	mov a,e
	cpi 2
	jnz t5nxt2
	mvi m,100
	mvi e,3
	jmp cnt5
t5nxt2:	mvi m,255
	mvi e,1
cnt5:	mov a,l
	cmp c
	jnz tstn5
	mov a,h
	cmp b
	jnz tstn5
;****************************
	lxi h,32769
	lxi b,65535
	mvi e,1
tst7:	mov a,e
	cpi 1
	jnz t7nxt1
	mvi m,1
	mvi e,2
	jmp cnt7
t7nxt1:	mov a,e
	cpi 2
	jnz t7nxt2
	mvi m,88
	mvi e,3
	jmp cnt7
t7nxt2:	mvi m,55
	mvi e,1
cnt7:	mov a,l
	cmp c
	jnz tstn7
	mov a,h
	cmp b
	jnz tstn7
;*****************
	lxi h,421
	lxi b,32768
	mvi e,1
tst6:	mov a,e
	cpi 1
	jnz t6nxt1
	mov a,m
	cpi 240
	jnz fail
	mvi e,2
	jmp cnt6
t6nxt1:	mov a,e
	cpi 2
	jnz t6nxt2
	mov a,m
	cpi 100
	jnz fail
	mvi e,3
	jmp cnt6
t6nxt2:	mov a,m
	cpi 255
	jnz fail
	mvi e,1
cnt6:	mov a,l
	cmp c
	jnz tstn6
	mov a,h
	cmp b
	jnz tstn6
;*********************************
	lxi h,32769
	lxi b,65535
	mvi e,1
tst8:	mov a,e
	cpi 1
	jnz t8nxt1
	mov a,m
	cpi 1
	jnz fail
	mvi e,2
	jmp cnt8
t8nxt1:	mov a,e
	cpi 2
	jnz t8nxt2
	mov a,m
	cpi 88
	jnz fail
	mvi e,3
	jmp cnt8
t8nxt2:	mov a,m
	cpi 55
	jnz fail
	mvi e,1
cnt8:	mov a,l
	cmp c
	jnz tstn8
	mov a,h
	cmp b
	jnz tstn8
;test passed if we got this far.
	inr d
	mov a,d
	out 240
	mvi b,80	;letter 'P'
	call tx
	jmp start

tstn1:	inx h
	jmp tst1

tstn2:	inx h
	jmp tst2

tstn3:	inx h
	jmp tst3

tstn4:	inx h
	jmp tst4

tstn5:	inx h
	jmp tst5

tstn6:	inx h
	jmp tst6

tstn7:	inx h
	jmp tst7

tstn8:	inx h
	jmp tst8

fail:	mvi d,0
	mov a,d
	out 240
	mvi b,70		;letter 'F'
	call tx
	jmp start

;Text Output
tx:	push d
	mvi a,192
	sim
	call sdl
	nop		;4
	nop		;4
	mvi a,64	;start
	sim
	call sdl
	mvi c,9
ttx:	dcr c		;10
	jz ttxnd	;7/10
	mov a,b		;4
	rrc		;4
	mov b,a		;4
	push b
	mvi c,64
	ora c		;4
	sim		;4
	pop b
	call sdl	;18
	jmp ttx
ttxnd:	nop		;4
	nop		;4
	nop		;4
	nop		;4
	mvi a,192	;stop
	sim
	call sdl
	call sdl
	pop d
	ret

sdl:	mvi d,1		;7  need 1250 T states
	mvi e,71	;7  need 1181 Ts was 53 for 2400, for 4mhz and 1200bd use 70
sd:	mov a,e		;4  22
	sub d		;4  53
	mov e,a		;4
	jnz sd		;7/10
	nop
	ret		;10 (38+31=69
