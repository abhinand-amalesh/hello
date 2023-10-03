	EXPORT invntt_fast_m3

	MACRO 
	montgomerym3 $q, $qinv, $a, $tmp
	mov $tmp, $qinv
	muls $tmp, $a, $tmp
	sxth $tmp, $tmp
	muls $tmp, $q, $tmp
	add $a, $tmp, $a
	asrs $a, $a, #16
	MEND

	MACRO
	gsbutterflym3 $poly0, $poly1, $twiddle, $tmp, $q, $qinv
	subs $tmp, $poly0, $poly1
	add $poly0, $poly0, $poly1

	muls $tmp, $twiddle, $tmp
	mov $poly1, $tmp
	push{$twiddle}
	mov $twiddle, $q
	montgomerym3 $twiddle, $qinv, $poly1, $tmp
	mov $q, $twiddle
	pop{$twiddle}
	MEND

	MACRO
	fqmulprecompm3 $a, $twiddle, $tmp,  $q, $qinv
	muls $a, $twiddle, $a
	push{$twiddle}
	mov $twiddle, $q
	montgomerym3 $twiddle, $qinv, $a, $tmp
	mov $q, $twiddle
	pop{$twiddle}
	MEND

	MACRO
	signed_barrettm3 $a, $q, $tmp, $barrettconst
	mov $tmp, $barrettconst
	muls $tmp, $a, $tmp
	push{$barrettconst}
	ldr $barrettconst, =67108864
	add $tmp, $tmp, $barrettconst
	asrs $tmp, $tmp, #27
	mov $barrettconst, $q
	muls $tmp, $barrettconst, $tmp
	add $a, $tmp, $a
	pop{$barrettconst}
	MEND
	
	PRESERVE8
    AREA MEM_ENCRYPTION, CODE, READONLY
    THUMB
		
invntt_fast_m3
  
  push {r4-r7, r14}
  mov r4, r8
  mov r5, r9
  mov r6, r10
  mov r7, r11
  push{r4-r7}

  ;poly        .req r0
  ;twiddle_ptr .req r1
  ;poly0       .req r2
  ;poly1       .req r3
  ;poly2       .req r4
  ;poly3       .req r5
  ;poly4       .req r10
  ;poly5       .req r12
  ;poly6       .req r8
  ;poly7       .req r9
  ;twiddle     .req r6
  ;montconst   .req r6
  ;barrettconst .req r6
  ;qinv        .req r14
  ;q           .req r11
  ;tmp         .req r7
 

  ldr r7, =3329
  mov r11, r7
  ldr r7, =3327
  mov r14, r7

  ;### LAYER 1 (skip layer 0)
  ldr r7, =32
;  LTORG
ck1
	push {r7}

	ldr r7, =0
	ldrsh r2, [r0 ,r7]
	ldr r7, =2
	ldrsh r3, [r0 ,r7]
	ldr r7, =4
	ldrsh r4, [r0 ,r7]
	ldr r7, =6
	ldrsh r5, [r0 ,r7]
	ldr r7, =8
	ldrsh r7, [r0 ,r7]
	mov r10, r7
	ldr r7, =10
	ldrsh r7, [r0 ,r7]
	mov r12, r7
	ldr r7, =12
	ldrsh r7, [r0 ,r7]
	mov r8, r7
	ldr r7, =14
	ldrsh r7, [r0 ,r7]
	mov r9, r7

	ldr r7, =0
	ldrsh r6, [r1, r7]
	adds r1, #2
	gsbutterflym3 r2, r4, r6, r7, r11, r14
	gsbutterflym3 r3, r5, r6, r7, r11, r14

	ldr r7, =0
	ldrsh r6, [r1, r7]
	adds r1, #2
	push{r2}
	push{r1}
	mov r1, r10
	mov r2, r8
	gsbutterflym3 r1, r2, r6, r7, r11, r14
	mov r10, r1
	mov r8, r2
	
	mov r1, r12
	mov r2, r9
	gsbutterflym3 r1, r2, r6, r7, r11, r14
	mov r12, r1
	mov r9, r2
	
	pop{r1}
	pop{r2}

	push{r1}
	ldr r6, =25218
	sxth r6, r6
	signed_barrettm3 r2, r11, r7, r6
	signed_barrettm3 r3, r11, r7, r6
	mov r1, r10
	signed_barrettm3 r1, r11, r7, r6
	mov r10, r1
	mov r1, r12
	signed_barrettm3 r1, r11, r7, r6
	mov r12, r1
	pop{r1}


	ldr r7, =2
	strh r3, [r0, r7]
	ldr r7, =4
	strh r4, [r0, r7]
	ldr r7, =6
	strh r5, [r0, r7]
	ldr r7, =8
	push{r5}
	mov r5, r10
	strh r5, [r0, r7]
	ldr r7, =10
	mov r5, r12
	strh r5, [r0, r7]
	ldr r7, =12
	mov  r5, r8
	strh r5, [r0, r7]
	ldr r7, =14
	mov r5, r9
	strh r5, [r0, r7]
	strh  r2, [r0]
	adds r0, #16
	pop{r5}

	pop {r7}
	subs r7, #1
;	LTORG
	
	bne e1
	B e2
e1
	ldr r3, =ck1
	bx r3

e2

  ldr r7, =512
  subs r0, r7

  ;### LAYER 2+3+4
  ldr r7, =8
 ; LTORG
ck2
	push {r7}

	;.set k, 1
	movs r7, #1
	;.rept 4
	push{r7}
	
	movs r7, #0
	ldrsh r2, [r0 ,r7]
	movs r7, #8
	ldrsh r3, [r0 ,r7]
	movs r7, #16
	ldrsh r4, [r0 ,r7]
	movs r7, #24
	ldrsh r5, [r0 ,r7]
	movs r7, #32
	ldrsh r7, [r0 ,r7]
	mov r10, r7
	movs r7, #40
	ldrsh r7, [r0 ,r7]
	mov r12, r7
	movs r7, #48
	ldrsh r7, [r0 ,r7]
	mov r8, r7
	movs r7, #56
	ldrsh r7, [r0 ,r7]
	mov r9, r7

	movs r7, #0
	ldrsh r6, [r1, r7]
	gsbutterflym3 r2, r3, r6, r7, r11, r14
	movs r7, #2
	ldrsh r6, [r1, r7]
	gsbutterflym3 r4, r5, r6, r7, r11, r14
	movs r7, #4
	ldrsh r6, [r1, r7]
	push{r2}
	push{r1}
	mov r1, r10
	mov r2, r12
	gsbutterflym3 r1, r2, r6, r7, r11, r14
	mov r10, r1
	mov r12, r2

	movs r7, #6
	pop{r1}
	ldrsh r6, [r1, r7]
	push{r1}
	mov r1, r8
	mov r2, r9
	gsbutterflym3 r1, r2, r6, r7, r11, r14
	mov r8, r1
	mov r9, r2
	
	movs r7, #8
	pop{r1}
	pop{r2}
	ldrsh r6, [r1, r7]
	gsbutterflym3 r2, r4, r6, r7, r11, r14
	gsbutterflym3 r3, r5, r6, r7, r11, r14


	movs r7, #10
	ldrsh r6, [r1, r7]
	push{r2}
	push{r1}
	mov r1, r10
	mov r2, r8
	gsbutterflym3 r1, r2, r6, r7, r11, r14
	mov r10, r1
	mov r8, r2
	mov r1, r12
	mov r2, r9
	gsbutterflym3 r1, r2, r6, r7, r11, r14
	mov r12, r1
	mov r9, r2
	pop{r1}
	pop{r2}

	movs r7, #12
	ldrsh r6, [r1, r7]
	push{r1}
	mov r1, r10
	gsbutterflym3 r2, r1, r6, r7, r11, r14
	mov r10, r1
	mov r1, r12
	gsbutterflym3 r3, r1, r6, r7, r11, r14
	mov r12, r1
	mov r1, r8
	gsbutterflym3 r4, r1, r6, r7, r11, r14
	mov r8, r1
	mov r1, r9
	gsbutterflym3 r5, r1, r6, r7, r11, r14
	mov r9, r1
	pop{r1}

	ldr r6, =2285
	LTORG
	fqmulprecompm3 r2, r6, r7, r11, r14
	fqmulprecompm3 r3, r6, r7, r11, r14
	fqmulprecompm3 r4, r6, r7, r11, r14
	fqmulprecompm3 r5, r6, r7, r11, r14

	movs r7, #8
	strh r3, [r0, r7]
	movs r7, #16
	strh r4, [r0, r7]
	movs r7, #24
	strh r5, [r0, r7]
	movs r7, #32
	push{r5}
	mov r5, r10
	strh r5, [r0, r7]
	movs r7, #40
	mov r5, r12
	strh r5, [r0, r7]
	movs r7, #48
	mov r5, r8
	strh r5, [r0, r7]
	movs r7, #56
	mov r5, r9
	strh r5, [r0, r7]
	pop{r5}
	
	pop{r7}
	cmp r7, #4
	;.if k != 4
	bne pa
	strh r2, [r0]
	adds r0, #58
	b pb
pa	
	strh r2, [r0]
	adds r0, #2
	;.else
	;.endif
pb

	adds r7, #1
	push{r7}
	;.set k, k+1
	
		
	movs r7, #0
	ldrsh r2, [r0 ,r7]
	movs r7, #8
	ldrsh r3, [r0 ,r7]
	movs r7, #16
	ldrsh r4, [r0 ,r7]
	movs r7, #24
	ldrsh r5, [r0 ,r7]
	movs r7, #32
	ldrsh r7, [r0 ,r7]
	mov r10, r7
	movs r7, #40
	ldrsh r7, [r0 ,r7]
	mov r12, r7
	movs r7, #48
	ldrsh r7, [r0 ,r7]
	mov r8, r7
	movs r7, #56
	ldrsh r7, [r0 ,r7]
	mov r9, r7

	movs r7, #0
	ldrsh r6, [r1, r7]
	gsbutterflym3 r2, r3, r6, r7, r11, r14
	movs r7, #2
	ldrsh r6, [r1, r7]
	gsbutterflym3 r4, r5, r6, r7, r11, r14
	movs r7, #4
	ldrsh r6, [r1, r7]
	push{r2}
	push{r1}
	mov r1, r10
	mov r2, r12
	gsbutterflym3 r1, r2, r6, r7, r11, r14
	mov r10, r1
	mov r12, r2
	movs r7, #6
	
	pop{r1}
	ldrsh r6, [r1, r7]
	push{r1}
	mov r1, r8
	mov r2, r9
	gsbutterflym3 r1, r2, r6, r7, r11, r14
	mov r8, r1
	mov r9, r2
	movs r7, #8
	pop{r1}
	pop{r2}
	ldrsh r6, [r1, r7]
	
	gsbutterflym3 r2, r4, r6, r7, r11, r14
	gsbutterflym3 r3, r5, r6, r7, r11, r14


	movs r7, #10
	ldrsh r6, [r1, r7]
	push{r2}
	push{r1}
	mov r1, r10
	mov r2, r8
	gsbutterflym3 r1, r2, r6, r7, r11, r14
	mov r10, r1
	mov r8, r2
	mov r1, r12
	mov r2, r9
	gsbutterflym3 r1, r2, r6, r7, r11, r14
	mov r12, r1
	mov r9, r2
	pop{r1}
	pop{r2}

	movs r7, #12
	ldrsh r6, [r1, r7]
	push{r1}
	mov r1, r10
	gsbutterflym3 r2, r1, r6, r7, r11, r14
	mov r10, r1
	mov r1, r12
	gsbutterflym3 r3, r1, r6, r7, r11, r14
	mov r12, r1
	mov r1, r8
	gsbutterflym3 r4, r1, r6, r7, r11, r14
	mov r8, r1
	mov r1, r9
	gsbutterflym3 r5, r1, r6, r7, r11, r14
	mov r9, r1
	pop{r1}

	ldr r6, =2285
	LTORG
	fqmulprecompm3 r2, r6, r7, r11, r14
	fqmulprecompm3 r3, r6, r7, r11, r14
	fqmulprecompm3 r4, r6, r7, r11, r14
	fqmulprecompm3 r5, r6, r7, r11, r14

	movs r7, #8
	strh r3, [r0, r7]
	movs r7, #16
	strh r4, [r0, r7]
	movs r7, #24
	strh r5, [r0, r7]
	push{r5}
	movs r7, #32
	mov r5, r10
	strh r5, [r0, r7]
	movs r7, #40
	mov r5, r12
	strh r5, [r0, r7]
	movs r7, #48
	mov r5, r8
	strh r5, [r0, r7]
	movs r7, #56
	mov r5, r9
	strh r5, [r0, r7]
	pop{r5}
	
	
	pop{r7}
	cmp r7, #4
	;.if k != 4
	bne pd
	strh r2, [r0]
	adds r0, #58
	b pe
pd	
	strh r2, [r0]
	adds r0, #2
	;.else
	;.endif
pe

	adds r7, #1
	push{r7}
	;.set k, k+1
	
		
	
	movs r7, #0
	ldrsh r2, [r0 ,r7]
	movs r7, #8
	ldrsh r3, [r0 ,r7]
	movs r7, #16
	ldrsh r4, [r0 ,r7]
	movs r7, #24
	ldrsh r5, [r0 ,r7]
	movs r7, #32
	ldrsh r7, [r0 ,r7]
	mov r10, r7
	movs r7, #40
	ldrsh r7, [r0 ,r7]
	mov r12, r7
	movs r7, #48
	ldrsh r7, [r0 ,r7]
	mov r8, r7
	movs r7, #56
	ldrsh r7, [r0 ,r7]
	mov r9, r7

	movs r7, #0
	ldrsh r6, [r1, r7]
	gsbutterflym3 r2, r3, r6, r7, r11, r14
	movs r7, #2
	ldrsh r6, [r1, r7]
	gsbutterflym3 r4, r5, r6, r7, r11, r14
	movs r7, #4
	ldrsh r6, [r1, r7]
	push{r2}
	push{r1}
	mov r1, r10
	mov r2, r12
	gsbutterflym3 r1, r2, r6, r7, r11, r14
	mov r10, r1
	mov r12, r2
	movs r7, #6
	
	pop{r1}
	ldrsh r6, [r1, r7]
	push{r1}
	mov r1, r8
	mov r2, r9
	gsbutterflym3 r1, r2, r6, r7, r11, r14
	mov r8, r1
	mov r9, r2
	movs r7, #8
	pop{r1}
	pop{r2}
	ldrsh r6, [r1, r7]
	gsbutterflym3 r2, r4, r6, r7, r11, r14
	gsbutterflym3 r3, r5, r6, r7, r11, r14


	movs r7, #10
	ldrsh r6, [r1, r7]
	push{r2}
	push{r1}
	mov r1, r10
	mov r2, r8
	gsbutterflym3 r1, r2, r6, r7, r11, r14
	mov r10, r1
	mov r8, r2
	mov r1, r12
	mov r2, r9
	gsbutterflym3 r1, r2, r6, r7, r11, r14
	mov r12, r1
	mov r9, r2
	pop{r1}
	pop{r2}

	movs r7, #12
	ldrsh r6, [r1, r7]
	push{r1}
	mov r1, r10
	gsbutterflym3 r2, r1, r6, r7, r11, r14
	mov r10, r1
	mov r1, r12
	gsbutterflym3 r3, r1, r6, r7, r11, r14
	mov r12, r1
	mov r1, r8
	gsbutterflym3 r4, r1, r6, r7, r11, r14
	mov r8, r1
	mov r1, r9
	gsbutterflym3 r5, r1, r6, r7, r11, r14
	mov r9, r1
	pop{r1}

	ldr r6, =2285
	fqmulprecompm3 r2, r6, r7, r11, r14
	fqmulprecompm3 r3, r6, r7, r11, r14
	fqmulprecompm3 r4, r6, r7, r11, r14
	fqmulprecompm3 r5, r6, r7, r11, r14

	movs r7, #8
	strh r3, [r0, r7]
	movs r7, #16
	strh r4, [r0, r7]
	movs r7, #24
	strh r5, [r0, r7]
	movs r7, #32
	push{r5}
	mov r5, r10
	strh r5, [r0, r7]
	movs r7, #40
	mov r5, r12
	strh r5, [r0, r7]
	movs r7, #48
	mov r5, r8
	strh r5, [r0, r7]
	movs r7, #56
	mov r5, r9
	strh r5, [r0, r7]
	pop{r5}
	
	
	
	pop{r7}
	cmp r7, #4
	;.if k != 4
	bne pf
	strh r2, [r0]
	adds r0, #58
	b pg
pf	
	strh r2, [r0]
	adds r0, #2
	;.else
	;.endif
pg

	adds r7, #1
	push{r7}
	;.set k, k+1
	
		
	movs r7, #0
	ldrsh r2, [r0 ,r7]
	movs r7, #8
	ldrsh r3, [r0 ,r7]
	movs r7, #16
	ldrsh r4, [r0 ,r7]
	movs r7, #24
	ldrsh r5, [r0 ,r7]
	movs r7, #32
	ldrsh r7, [r0 ,r7]
	mov r10, r7
	movs r7, #40
	ldrsh r7, [r0 ,r7]
	mov r12, r7
	movs r7, #48
	ldrsh r7, [r0 ,r7]
	mov r8, r7
	movs r7, #56
	ldrsh r7, [r0 ,r7]
	mov r9, r7

	movs r7, #0
	ldrsh r6, [r1, r7]
	gsbutterflym3 r2, r3, r6, r7, r11, r14
	movs r7, #2
	ldrsh r6, [r1, r7]
	gsbutterflym3 r4, r5, r6, r7, r11, r14
	movs r7, #4
	ldrsh r6, [r1, r7]
	push{r2}
	push{r1}
	mov r1, r10
	mov r2, r12
	gsbutterflym3 r1, r2, r6, r7, r11, r14
	mov r10, r1
	mov r12, r2
	movs r7, #6
	
	pop{r1}
	ldrsh r6, [r1, r7]
	push{r1}
	mov r1, r8
	mov r2, r9
	gsbutterflym3 r1, r2, r6, r7, r11, r14
	mov r8, r1
	mov r9, r2
	movs r7, #8
	pop{r1}
	pop{r2}
	ldrsh r6, [r1, r7]
	
	gsbutterflym3 r2, r4, r6, r7, r11, r14
	gsbutterflym3 r3, r5, r6, r7, r11, r14


	movs r7, #10
	ldrsh r6, [r1, r7]
	push{r2}
	push{r1}
	mov r1, r10
	mov r2, r8
	gsbutterflym3 r1, r2, r6, r7, r11, r14
	mov r10, r1
	mov r8, r2
	mov r1, r12
	mov r2, r9
	gsbutterflym3 r1, r2, r6, r7, r11, r14
	mov r12, r1
	mov r9, r2
	pop{r1}
	pop{r2}

	movs r7, #12
	ldrsh r6, [r1, r7]
	push{r1}
	mov r1, r10
	gsbutterflym3 r2, r1, r6, r7, r11, r14
	mov r10, r1
	mov r1, r12
	gsbutterflym3 r3, r1, r6, r7, r11, r14
	mov r12, r1
	mov r1, r8
	gsbutterflym3 r4, r1, r6, r7, r11, r14
	mov r8, r1
	mov r1, r9
	gsbutterflym3 r5, r1, r6, r7, r11, r14
	mov r9, r1
	pop{r1}

	ldr r6, =2285
	fqmulprecompm3 r2, r6, r7, r11, r14
	fqmulprecompm3 r3, r6, r7, r11, r14
	fqmulprecompm3 r4, r6, r7, r11, r14
	fqmulprecompm3 r5, r6, r7, r11, r14

	movs r7, #8
	strh r3, [r0, r7]
	movs r7, #16
	strh r4, [r0, r7]
	movs r7, #24
	strh r5, [r0, r7]
	movs r7, #32
	mov r5, r10
	strh r5, [r0, r7]
	movs r7, #40
	mov r5, r12
	strh r5, [r0, r7]
	movs r7, #48
	mov r5, r8
	strh r5, [r0, r7]
	movs r7, #56
	mov r5, r9
	strh r5, [r0, r7]
	
	
	pop{r7}
	cmp r7, #4
	;.if k != 4
	bne ph
	strh r2, [r0]
	adds r0, #58
	b pi
ph	
	strh r2, [r0]
	adds r0, #2
	;.else
	;.endif
pi

	adds r7, #1
	;.set k, k+1
			
	;.endr	
	
	adds r1, #14
	pop {r7}
	subs r7, #1
	LTORG
	bne e3
	b e4
e3
	ldr r3, =ck2
	bx r3
  
e4
  push{r7}
  ldr r7, =512
  subs r0, r7
  pop{r7}

  ;### LAYER 5+6+7
  ldr r7, =32
ck3
	push {r7}

	ldr r7, =0
	ldrsh r2, [r0 ,r7]
	ldr r7, =64
	ldrsh r3, [r0 ,r7]
	ldr r7, =128
	ldrsh r4, [r0 ,r7]
	ldr r7, =192
	ldrsh r5, [r0 ,r7]
	ldr r7, =256
	ldrsh r7, [r0 ,r7]
	mov r10, r7
	ldr r7, =320
	ldrsh r7, [r0 ,r7]
	mov r12, r7
	ldr r7, =384
	ldrsh r7, [r0 ,r7]
	mov r8, r7
	ldr r7, =448
	ldrsh r7, [r0 ,r7]
	mov r9, r7

	ldr r7, =0
	ldrsh r6, [r1, r7]
	gsbutterflym3 r2, r3, r6, r7, r11, r14
	ldr r7, =2
	ldrsh r6, [r1, r7]
	gsbutterflym3 r4, r5, r6, r7, r11, r14
	ldr r7, =4
	ldrsh r6, [r1, r7]
	push{r2}
	push{r3}
	mov r3, r10
	mov r2, r12
	gsbutterflym3 r3, r2, r6, r7, r11, r14
	mov r10, r3
	mov r12, r2
	ldr r7, =6
	ldrsh r6, [r1, r7]
	mov r3, r8
	mov r2, r9
	gsbutterflym3 r3, r2, r6, r7, r11, r14
	mov r8, r3
	mov r9, r2
	pop{r3}
	pop{r2}
	ldr r7, =8
	ldrsh r6, [r1, r7]
	gsbutterflym3 r2, r4, r6, r7, r11, r14
	gsbutterflym3 r3, r5, r6, r7, r11, r14

	ldr r7, =10
	ldrsh r6, [r1, r7]
	push{r2}
	push{r1}
	mov r1, r10
	mov r2, r8
	gsbutterflym3 r1, r2, r6, r7, r11, r14
	mov r10, r1
	mov r8, r2
	
	mov r1, r12
	mov r2, r9
	gsbutterflym3 r1, r2, r6, r7, r11, r14
	mov r12, r1
	mov r9, r2
	pop{r1}
	pop{r2}

	ldr r7, =12
	ldrsh r6, [r1, r7]
	push{r1}
	mov r1, r10
	gsbutterflym3 r2, r1, r6, r7, r11, r14
	mov r10, r1
	mov r1, r12
	gsbutterflym3 r3, r1, r6, r7, r11, r14
	mov r12, r1
	mov r1, r8
	gsbutterflym3 r4, r1, r6, r7, r11, r14
	mov r1, r9
	gsbutterflym3 r5, r1, r6, r7, r11, r14
	mov r9, r1
	pop{r1}

	ldr r7, =14
	ldrsh r6, [r1, r7]
	fqmulprecompm3 r2, r6, r7,  r11, r14
	fqmulprecompm3 r3, r6, r7,  r11, r14
	fqmulprecompm3 r4, r6, r7,  r11, r14
	fqmulprecompm3 r5, r6, r7,  r11, r14

	
	ldr r7, =64
	strh r3, [r0, r7]
	ldr r7, =128
	strh r4, [r0, r7]
	ldr r7, =192
	strh r5, [r0, r7]
	ldr r7, =256
	push{r5}
	mov r5, r10
	strh r5, [r0, r7]
	ldr r7, =320
	mov r5, r12
	strh r5, [r0, r7]
	ldr r7, =384
	mov r5, r8
	strh r5, [r0, r7]
	ldr r7, =448
	mov r5, r9
	strh r5, [r0, r7]
	strh r2, [r0]
	adds r0, #2
	pop{r5}

	pop {r7}
	subs r7, #1
	bne e6
	b e5
e6	
	ldr r2, =ck3
	bx r2

e5
  pop{r4-r7}
  mov r8, r4
  mov r9, r5
  mov r10, r6
  mov r11, r7
  pop {r4-r7, pc}
  END
