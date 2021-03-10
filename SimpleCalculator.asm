; Intel 8051
;
; Simple calculator 
; n1 (+ , -, *, /, ^) n2
; MaxValue: 0xFF
;
; 03/10/2021
;
; Author: github.com/edsonphx

org 0x00

	mov p0, #0xFF
	mov p1, #0xFF
	
main: 
	jnb p0.0, loadData		;load data if p0.0 is off
	jnb p0.1, executeOperation	;execute operation if p0.1 is off
	jmp main

loadData:
	mov a, p1
	push a
	jnb p0.0, $ 	; wait for turn off pin
	jmp main

executeOperation:
	pop b		; load second number
	pop a		; load operator
	mov r1, a
	pop a		; load first number

	addVerify: cjne r1, #0x01, subVerify
	call add
	
	subVerify: cjne r1, #0x02, mulVerify
	call sub

	mulVerify: cjne r1, #0x04, divVerify
	call mul

	divVerify: cjne r1, #0x8, powVerify
	call div

	powVerify: cjne r1, #0x10, wait
	call pow

	jmp wait

wait:
	jnb p0.1, $ 	; wait for turn off pin
	jmp main
	
add:
	add a, b
	mov r0, a
	ret 
	
sub:
	subb a, b
	mov r0, a
	ret
mul:
	mul ab
	mov r0, a
	ret

div:
	div ab
	mov r0, a
	ret

pow:
	mov r1, b	; exponent
	mov r2, a	; base
	mov r0, a
	mov r3, #0x00	; index

powLoop:
	inc r3
	mov a, r3;
	cjne a, 0x01, powCallMul
	ret
	
powCallMul:
	mov a, r2 ; load base
	mov b, r0
	call mul
	jmp powLoop
