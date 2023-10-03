	EXPORT ntt_fast_m3
barrett_constant EQU 20159
	
	MACRO
	butterflym3 $a0, $a2, $twiddle, $q, $qinv, $tmp
    muls $a2, $twiddle, $a2
	mov $tmp, $qinv
    muls $tmp, $a2, $tmp
    sxth $tmp, $tmp
	push {$twiddle}
	mov $twiddle, $q
    muls $tmp, $twiddle, $tmp
    add $tmp, $tmp, $a2
	push{$tmp}
	asrs $tmp, #16
    subs $a2, $a0, $tmp
	pop{$tmp}
	push{$tmp}
	asrs $tmp, #16
    add $a0, $a0, $tmp
	pop{$tmp}
	pop{$twiddle}
	MEND
	
	MACRO
	barrettm3 $a, $tmp, $q, $barrettconst
	mov $tmp, $barrettconst
    muls $tmp, $a, $tmp
    asrs $tmp, $tmp, #26
	push{$barrettconst}
	mov $barrettconst, $q
    muls $tmp, $barrettconst, $tmp
    subs $a, $a, $tmp
	pop{$barrettconst}
	MEND
	
	PRESERVE8
    AREA MEM_ENCRYPTION, CODE, READONLY

		
ntt_fast_m3

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
  ;poly4       .req r11
  ;oly5       .req r8
  ;poly6       .req r9
  ;poly7       .req r10
  ;twiddle     .req r6
  ;barrettconst .req r6
  ;qinv        .req r12
  ;q           .req r14
  ;tmp         .req r7

  ldr r7, =3327
  mov r12, r7
  ldr r7, =3329
  mov r14, r7
 
  ;### LAYER 7+6+5
  ldr r7, =32
  
  
xp
    push {r7}

	ldr r7, =0
    ldrsh r2, [r0, r7]
	ldr r7, =64
    ldrsh r3, [r0, r7]
	ldr r7, =128
    ldrsh r4, [r0, r7]
	ldr r7, =192
    ldrsh r5, [r0, r7]
	ldr r7, =256
    ldrsh r7, [r0, r7]
	mov r11, r7
	ldr r7, =320
    ldrsh r7, [r0, r7]
	mov r8, r7
	ldr r7, =384
    ldrsh r7, [r0, r7]
	mov r9, r7
	ldr r7, =448
    ldrsh r7, [r0, r7]
	mov r10, r7

	ldr r7, =0
    ldrsh r6, [r1, r7]
	push{r1}
	mov r1, r11
    butterflym3 r2, r1, r6, r14, r12, r7
	mov r11, r1
	mov r1, r8
    butterflym3 r3, r1, r6, r14, r12, r7
	mov r8, r1
	mov r1, r9
    butterflym3 r4, r1, r6, r14, r12, r7
	mov r9, r1
	mov r1, r10
    butterflym3 r5, r1, r6, r14, r12, r7
	mov r10, r1
	pop{r1}

	ldr r7, =2
    ldrsh r6, [r1, r7]
    butterflym3 r2, r4, r6, r14, r12, r7
    butterflym3 r3, r5, r6, r14, r12, r7
	ldr r7, =4
    ldrsh r6, [r1, r7]
	push{r2}
	push{r1}
	mov r1, r11
	mov r2, r9
    butterflym3 r1, r2, r6, r12, r12, r7
	mov r11, r1
	mov r9, r2
	
	mov r1, r8
	mov r2, r10
    butterflym3 r1, r2, r6, r14, r12, r7
	mov r8, r1
	mov r10, r2
	pop{r1}
	pop{r2}

	ldr r7, =6
    ldrsh r6, [r1, r7]
    butterflym3 r2, r3, r6, r14, r12, r7
	ldr r7, =8
    ldrsh r6, [r1, r7]
    butterflym3 r4, r5, r6, r14, r12, r7
	ldr r7, =10
    ldrsh r6, [r1, r7]
	
	push{r2}
	push{r1}
	mov r1, r11
	mov r2, r8
    butterflym3 r1, r2, r6, r14, r12, r7
	mov r11, r1
	mov r8, r2
	pop{r1}
	ldr r7, =12
    ldrsh r6, [r1, r7]
	push{r1}
	mov r1, r9
	mov r2, r10
    butterflym3 r1, r2, r6, r14, r12, r7
	mov r9, r1
	mov r10, r2
	pop{r1}
	pop{r2}

	ldr r7, =64
    strh r3, [r0, r7]
	ldr r7, =128
    strh r4, [r0, r7]
	ldr r7, =192
    strh r5, [r0, r7]
	ldr r7, =256
	push{r5}
	mov r5, r11
    strh r5, [r0, r7]
	ldr r7, =320
	mov r5, r8
    strh r5, [r0, r7]
	ldr r7, =384
	mov r5, r9
    strh r5, [r0, r7]
	ldr r7, =448
	mov r5, r10
    strh r5, [r0, r7]
    strh r2, [r0]
	adds r0, #2
	pop{r5}

	pop {r7}
    subs r7, #1
	LTORG
	bne e1
	b e2
e1
	ldr r3, =xp
	bx r3
e2
	subs r0, #64
	adds r1, #14

	;### LAYER 4+3+2
	ldr r7, =8
	LTORG
xp1
    push {r7}
	movs r7, #1
	push {r7}
	
	  
	movs r7, #0
	ldrsh r2, [r0, r7]
	movs r7, #8
	ldrsh r3, [r0, r7]
	movs r7, #16
	ldrsh r4, [r0, r7]
	movs r7, #24
	ldrsh r5, [r0, r7]
	movs r7, #32
	ldrsh r7, [r0, r7]
	mov r11, r7
	movs r7, #40
	ldrsh r7, [r0, r7]
	mov r8, r7
	movs r7, #48
	ldrsh r7, [r0, r7]
	mov r9, r7
	movs r7, #56
	ldrsh r7, [r0, r7]
	mov r10, r7

	movs r7, #0
	ldrsh r6, [r1, r7]	
	push{r1}
	mov r1, r11
	butterflym3 r2, r1, r6, r14, r12, r7
	mov r11, r1
	mov r1, r8
	butterflym3 r3, r1, r6, r14, r12, r7
	mov r8, r1
	mov r1, r9
	butterflym3 r4, r1, r6, r14, r12, r7
	mov r9, r1
	mov r1, r10
	butterflym3 r5, r1, r6, r14, r12, r7
	mov r10, r1
	pop{r1}

	movs r7, #2
	ldrsh r6, [r1, r7]
	butterflym3 r2, r4, r6, r14, r12, r7
	butterflym3 r3, r5, r6, r14, r12, r7

	movs r7, #4
	ldrsh r6, [r1, r7]
	push{r2}
	push{r1}
	mov r1, r11
	mov r2, r9
	butterflym3 r1, r2, r6, r14, r12, r7
	mov r11, r1
	mov r9, r2

	mov r1, r8
	mov r2, r10
	butterflym3 r1, r2, r6, r14, r12, r7
	mov r8, r1
	mov r10, r2
	pop{r1}
	pop{r2}

	movs r7, #6
	ldrsh r6, [r1, r7]
	butterflym3 r2, r3, r6, r14, r12, r7
	movs r7, #8
	ldrsh r6, [r1, r7]
	butterflym3 r4, r5, r6, r14, r12, r7

	movs r7, #10
	ldrsh r6, [r1, r7]
	mov r6, r7
	push{r2}
	push{r1}
	mov r1, r11
	mov r2, r8
	butterflym3 r1, r2, r6, r14, r12, r7
	mov r11, r1
	mov r8, r2

	movs r7, #12
	pop{r1}
	ldrsh r6, [r1, r7]
	push{r1}
	mov r1, r9
	mov r2, r10
	butterflym3 r1, r2, r6, r14, r12, r7
	mov r9, r1
	mov r10, r2
	pop{r1}
	pop{r2}

	movs r7, #8
	strh r3, [r0, r7]
	movs r7, #16
	strh r4, [r0, r7]
	movs r7, #24
	strh r5, [r0, r7]
	movs r7, #32
	push{r5}
	mov r5, r11
	strh r5, [r0, r7]
	movs r7, #40
	mov r5, r8
	strh r5, [r0, r7]
	movs r7, #48
	mov r5, r9
	strh r5, [r0, r7]
	movs r7, #56
	mov r5, r10
	strh r5, [r0, r7]
	pop{r5}

	pop {r7}
	cmp r7, #4
	push{r7}
	bne pa
	movs r7, #0
	strh r2, [r0, r7]
	adds r0, #58
	b pb
    
pa
	movs r7, #0
	strh r2, [r0, r7]
	adds r0, #2
	  
pb	  	  
	pop{r7}
	adds r7, #1
	push {r7}

	movs r7, #0
	ldrsh r2, [r0, r7]
	movs r7, #8
	ldrsh r3, [r0, r7]
	movs r7, #16
	ldrsh r4, [r0, r7]
	movs r7, #24
	ldrsh r5, [r0, r7]
	movs r7, #32
	ldrsh r7, [r0, r7]
	mov r11, r7
	movs r7, #40
	ldrsh r7, [r0, r7]
	mov r8, r7
	movs r7, #48
	ldrsh r7, [r0, r7]
	mov r9, r7
	movs r7, #56
	ldrsh r7, [r0, r7]
	mov r10, r7

	movs r7, #0
	ldrsh r6, [r1, r7]
	push{r1}
	mov r1, r11
	butterflym3 r2, r1, r6, r14, r12, r7
	mov r11, r1
	mov r1, r8
	butterflym3 r3, r1, r6, r14, r12, r7
	mov r8, r1
	mov r1, r9
	butterflym3 r4, r1, r6, r14, r12, r7
	mov r9, r1
	mov r1, r10
	butterflym3 r5, r1, r6, r14, r12, r7
	mov r10, r1
	pop{r1}

	movs r7, #2
	ldrsh r6, [r1, r7]
	butterflym3 r2, r4, r6, r14, r12, r7
	butterflym3 r3, r5, r6, r14, r12, r7
	movs r7, #4
	ldrsh r6, [r1, r7]
	push{r2}
	push{r1}
	mov r1, r11
	mov r2, r9
	butterflym3 r1, r2, r6, r14, r12, r7
	mov r11, r1
	mov r9, r2

	mov r1, r8
	mov r2, r10
	butterflym3 r1, r2, r6, r14, r12, r7
	mov r8, r1
	mov r10, r2
	pop{r1}
	pop{r2}

	movs r7, #6
	ldrsh r6, [r1, r7]
	butterflym3 r2, r3, r6, r14, r12, r7
	movs r7, #8
	ldrsh r6, [r1, r7]
	butterflym3 r4, r5, r6, r14, r12, r7
	movs r7, #10
	ldrsh r6, [r1, r7]


	push{r2}
	push{r1}
	mov r1, r11
	mov r2, r8
	butterflym3 r1, r2, r6, r14, r12, r7
	mov r11, r1
	mov r8, r2

	movs r7, #12
	pop{r1}
	ldrsh r6, [r1, r7]
	push{r1}
	mov r1, r9
	mov r2, r10
	butterflym3 r1, r2, r6, r14, r12, r7
	mov r9, r1
	mov r10, r2
	pop{r1}
	pop{r2}

	movs r7, #8
	strh r3, [r0, r7]
	movs r7, #16
	strh r4, [r0, r7]
	movs r7, #24
	strh r5, [r0, r7]
	movs r7, #32
	push{r5}
	mov r5, r11
	strh r5, [r0, r7]
	movs r7, #40
	mov r5, r8
	strh r5, [r0, r7]
	movs r7, #48
	mov r5, r9
	strh r5, [r0, r7]
	movs r7, #56
	mov r5, r10
	strh r5, [r0, r7]
	pop{r5}

	pop {r7}
	cmp r7, #4
	push{r7}
	bne pd
	movs r7, #0
	strh r2, [r0, r7]
	adds r0, #58
	b pe
    
pd
	movs r7, #0
	strh r2, [r0, r7]
	adds r0, #2
	  
pe	  	  

	pop{r7}
	adds r7, #1
	push {r7}
	movs r7, #0
	ldrsh r2, [r0, r7]
	movs r7, #8
	ldrsh r3, [r0, r7]
	movs r7, #16
	ldrsh r4, [r0, r7]
	movs r7, #24
	ldrsh r5, [r0, r7]
	movs r7, #32
	ldrsh r7, [r0, r7]
	mov r11, r7
	movs r7, #40
	ldrsh r7, [r0, r7]
	mov r8, r7
	movs r7, #48
	ldrsh r7, [r0, r7]
	mov r9, r7
	movs r7, #56
	ldrsh r7, [r0, r7]
	mov r10, r7

	movs r7, #0
	ldrsh r6, [r1, r7]
	push{r1}
	mov r1, r11
	butterflym3 r2, r1, r6, r14, r12, r7
	mov r11, r1
	mov r1, r8
	butterflym3 r3, r1, r6, r14, r12, r7
	mov r8, r1
	mov r1, r9
	butterflym3 r4, r1, r6, r14, r12, r7
	mov r9, r1
	mov r1, r10
	butterflym3 r5, r1, r6, r14, r12, r7
	mov r10, r1

	pop{r1}
	movs r7, #2
	ldrsh r6, [r1, r7]
	butterflym3 r2, r4, r6, r14, r12, r7
	butterflym3 r3, r5, r6, r14, r12, r7
	movs r7, #4
	ldrsh r6, [r1, r7]
	push{r2}
	push{r1}
	mov r1, r11
	mov r2, r9
	butterflym3 r1, r2, r6, r14, r12, r7
	mov r11, r1
	mov r9, r2

	mov r1, r8
	mov r2, r10
	butterflym3 r1, r2, r6, r14, r12, r7
	mov r8, r1
	mov r10, r2
	pop{r1}
	pop{r2}

	movs r7, #6
	ldrsh r6, [r1, r7]
	butterflym3 r2, r3, r6, r14, r12, r7
	movs r7, #8
	ldrsh r6, [r1, r7]
	butterflym3 r4, r5, r6, r14, r12, r7
	movs r7, #10
	ldrsh r6, [r1, r7]

	push{r2}
	push{r1}
	mov r1, r11
	mov r2, r8
	butterflym3 r1, r2, r6, r14, r12, r7
	mov r11, r1
	mov r8, r2
	movs r7, #12

	pop{r1}
	ldrsh r6, [r1, r7]
	push{r1}

	mov r1, r9
	mov r2, r10
	butterflym3 r1, r2, r6, r14, r12, r7
	mov r9, r1
	mov r10, r2
	pop{r1}
	pop{r2}

	movs r7, #8
	strh r3, [r0, r7]
	movs r7, #16
	strh r4, [r0, r7]
	movs r7, #24
	strh r5, [r0, r7]
	movs r7, #32
	push{r5}
	mov r5, r11
	strh r5, [r0, r7]
	movs r7, #40
	mov r5, r8
	strh r5, [r0, r7]
	movs r7, #48
	mov r5, r9
	strh r5, [r0, r7]
	movs r7, #56
	mov r5, r10
	strh r5, [r0, r7]
	pop{r5}

	  
	pop {r7}
	cmp r7, #4
	push{r7}
	bne pf
	movs r7, #0
	strh r2, [r0, r7]
	adds r0, #58
	b pg
    
pf
	movs r7, #0
	strh r2, [r0, r7]
	adds r0, #2
	  
pg	  	  

	pop{r7}
	adds r7, #1
	push {r7}

	  
	ldr r7, =0
	ldrsh r2, [r0, r7]
	ldr r7, =8
	ldrsh r3, [r0, r7]
	ldr r7, =16
	ldrsh r4, [r0, r7]
	ldr r7, =24
	ldrsh r5, [r0, r7]
	ldr r7, =32
	ldrsh r7, [r0, r7]
	mov r11, r7
	ldr r7, =40
	ldrsh r7, [r0, r7]
	mov r8, r7
	ldr r7, =48
	ldrsh r7, [r0, r7]
	mov r9, r7
	ldr r7, =56
	ldrsh r7, [r0, r7]
	mov r10, r7

	ldr r7, =0
	ldrsh r6, [r1, r7]
	push{r1}
	mov r1, r11
	butterflym3 r2, r1, r6, r14, r12, r7
	mov r11, r1
	mov r1, r8
	butterflym3 r3, r1, r6, r14, r12, r7
	mov r8, r1
	mov r1, r9
	butterflym3 r4, r1, r6, r14, r12, r7
	mov r9, r1
	mov r1, r10
	butterflym3 r5, r1, r6, r14, r12, r7
	mov r10, r1

	pop{r1}
	ldr r7, =2
	ldrsh r6, [r1, r7]
	butterflym3 r2, r4, r6, r14, r12, r7
	butterflym3 r3, r5, r6, r14, r12, r7
	ldr r7, =4
	ldrsh r6, [r1, r7]
	push{r2}
	push{r1}
	mov r1, r11
	mov r2, r9
	butterflym3 r1, r2, r6, r14, r12, r7
	mov r11, r1
	mov r9, r2

	mov r1, r8
	mov r2, r10
	butterflym3 r1, r2, r6, r14, r12, r7
	mov r8, r1
	mov r10, r2
	pop{r1}
	pop{r2}

	ldr r7, =6
	ldrsh r6, [r1, r7]
	butterflym3 r2, r3, r6, r14, r12, r7
	ldr r7, =8
	ldrsh r6, [r1, r7]
	butterflym3 r4, r5, r6, r14, r12, r7
	ldr r7, =10
	ldrsh r6, [r1, r7]

	push{r2}
	push{r1}
	mov r1, r11
	mov r2, r8
	butterflym3 r1, r2, r6, r14, r12, r7
	mov r11, r1
	mov r8, r2
	ldr r7, =12

	pop{r1}
	ldrsh r6, [r1, r7]
	push{r1}

	mov r1, r9
	mov r2, r10
	butterflym3 r1, r2, r6, r14, r12, r7
	mov r9, r1
	mov r10, r2
	pop{r1}
	pop{r2}

	ldr r7, =8
	strh r3, [r0, r7]
	ldr r7, =16
	strh r4, [r0, r7]
	ldr r7, =24
	strh r5, [r0, r7]
	ldr r7, =32
	push{r5}
	mov r5, r11
	strh r5, [r0, r7]
	ldr r7, =40
	mov r5, r8
	strh r5, [r0, r7]
	ldr r7, =48
	mov r5, r9
	strh r5, [r0, r7]
	ldr r7, =56
	mov r5, r10
	strh r5, [r0, r7]
	pop{r5}



	pop {r7}
	cmp r7, #4
	push{r7}
	bne ph
	movs r7, #0
	strh r2, [r0, r7]
	adds r0, #58
	b pi
    
ph
	movs r7, #0
	strh r2, [r0, r7]
	adds r0, #2
	  
pi	  	  

	pop{r7}
	adds r7, #1

	adds r1, #14

	pop{r7}
	subs r7, #1
	bne kp
	b kr
kp	
	ldr r3, =xp1
	bx r3

kr
	ldr r7, =512
	subs r0, r7


	;### LAYER 1 (skip layer 0)
	movs r7, #32
	LTORG

xp2
	push {r7}

	movs r7, #0
	ldrsh r2, [r0, r7]
	movs r7, #2
	ldrsh r3, [r0, r7]
	movs r7, #4
	ldrsh r4, [r0, r7]
	movs r7, #6
	ldrsh r5, [r0, r7]
	movs r7, #8
	ldrsh r7, [r0, r7]
	mov r11, r7
	movs r7, #10
	ldrsh r7, [r0, r7]
	mov r8, r7
	movs r7, #12
	ldrsh r7, [r0, r7]
	mov r9, r7
	movs r7, #14
	ldrsh r7, [r0, r7]
	mov r10, r7

	movs r7, #0
	ldrsh r6, [r1, r7]
	adds r1, #2
	butterflym3 r2, r4, r6, r14, r12, r7
	butterflym3 r3, r5, r6, r14, r12, r7

	movs r7, #0
	ldrsh r6, [r1, r7]
	adds r1, #2
	push{r2}
	push{r1}
	mov r1, r11
	mov r2, r9
	butterflym3 r1, r2, r6, r14, r12, r7
	mov r11, r1
	mov r9, r2

	mov r1, r8
	mov r2, r10
	butterflym3 r1, r2, r6, r14, r12, r7
	mov r8, r1
	mov r10, r2
	pop{r1}
	pop{r2}

	ldr r6, =barrett_constant
	barrettm3 r2, r7, r14, r6
	barrettm3 r3, r7, r14, r6
	barrettm3 r4, r7, r14, r6
	barrettm3 r5, r7, r14, r6

	push{r1}
	mov r1, r11
	barrettm3 r1, r7, r14, r6
	mov r11, r1
	mov r1, r8
	barrettm3 r1, r7, r14, r6
	mov r8, r1
	mov r1, r9
	barrettm3 r1, r7, r14, r6
	mov r9, r1
	mov r1, r10
	barrettm3 r1, r7, r14, r6
	mov r10, r1
	pop{r1}

	movs r7, #2
	strh r3, [r0, r7]
	movs r7, #4
	strh r4, [r0, r7]
	movs r7, #6
	strh r5, [r0, r7]
	movs r7, #8
	push{r5}
	mov r5, r11
	strh r5, [r0, r7]
	movs r7, #10
	mov r5, r8
	strh r5, [r0, r7]
	movs r7, #12
	mov r5, r9
	strh r5, [r0, r7]
	movs r7, #14
	mov r5, r10
	strh r5, [r0, r7]
	strh r2, [r0]
	adds r0, #16
	pop{r5}

	pop {r7}
	subs r7, #1
	bne kl
	b kll
kl	
	ldr r3, =xp2
	bx r3
kll
	pop{r4-r7}
	mov r8, r4
	mov r9, r5
	mov r10, r6
	mov r11, r7
	pop {r4-r7, pc}
  
  END
