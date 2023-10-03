	EXPORT doublebasemul_asm_acc_m3
	EXPORT asm_barrett_reduce_m3
	EXPORT asm_frommont_m3
	EXPORT basemul_asm_acc_m3
	EXPORT basemul_asm_m3
	EXPORT doublebasemul_asm_m3
	EXPORT pointwise_add_m3
	EXPORT pointwise_sub_m3
	
	MACRO
	barrettm3 $a, $tmp, $q, $barrettconst
	mov $tmp, $barrettconst
	push{$barrettconst}
	mov $barrettconst, $a
	muls $tmp, $barrettconst, $tmp
	asrs $tmp, $tmp, #26
	mov $barrettconst, $q
	muls $tmp, $barrettconst, $tmp
	mov $barrettconst, $a
	subs $barrettconst, $barrettconst, $tmp
	mov $a, $barrettconst
	pop{$barrettconst}
	MEND

	MACRO
	montgomerym3 $q, $qinv, $a, $tmp
	mov $tmp, $qinv
	push{r0}
	mov r0, $a
	muls $tmp, r0, $tmp
	sxth $tmp, $tmp
	mov r0, $q
	muls $tmp, r0, $tmp
	add $a, $tmp, $a
	mov r0, $a
	asrs r0, r0, #16
	mov $a, r0
	pop{r0}
	MEND

	PRESERVE8
    AREA MEM_ENCRYPTION, CODE, READONLY
    THUMB
		

pointwise_sub_m3

	push{r4-r7, lr}
    mov r4, r8
    mov r5, r9
    mov r6, r10
    mov r7, r11
    push{r4-r7}


  movs r7, #51
  mov r14, r7
  
co0

	movs r3, #2
    ldrsh r4, [r1, r3]
	movs r3, #4
    ldrsh r5, [r1, r3]
	movs r3, #6
    ldrsh r6, [r1, r3]
	movs r3, #8
    ldrsh r7, [r1, r3]
	
	push{r7}
	
	movs r7, #0
    ldrsh r3, [r1, r7]
	adds r1, #10
	
	movs r7, #2
    ldrsh r7, [r2, r7]
	mov r9, r7
	movs r7, #4
    ldrsh r7, [r2, r7]
	mov r10, r7
	movs r7, #6
    ldrsh r7, [r2, r7]
	mov r11, r7
	movs r7, #8
    ldrsh r7, [r2, r7]
	mov r12, r7
	movs r7, #0
    ldrsh r7, [r2, r7]
	mov r8, r7
	adds r2, #10
	
	mov r7, r8
    subs r3, r3, r7
	mov r7, r9
    subs r4, r4, r7
	mov r7, r10
    subs r5, r5, r7
	mov r7, r11
    subs r6, r6, r7
	pop{r7}

	push{r6}
	mov r6, r12
    subs r7, r7, r6
	pop{r6}

    strh r4, [r0, #2]
    strh r5, [r0, #4]
    strh r6, [r0, #6]
    strh r7, [r0, #8]
    strh r3, [r0] 
	adds r0, #10
	
	push {r7}
	mov r7, r14
    subs r7, #1
	mov r14, r7
    pop{r7}
	bne e1
	B e2
e1
	ldr r7, =co0
	bx r7

e2
  push{r7}
  movs r7, #0
  ldrsh r3, [r1, r7]
  ldrsh r4, [r2, r7]
  subs r3, r3, r4
  strh r3, [r0]
  pop{r7}
  
  pop{r4-r7}
  mov r8, r4
  mov r9, r5
  mov r10, r6
  mov r11, r7
  pop{r4-r7, pc}
	

pointwise_add_m3

  push{r4-r7, lr}
  mov r4, r8
  mov r5, r9
  mov r6, r10
  mov r7, r11
  push{r4-r7}
  
  movs r7, #51
  mov r14, r7

co1

	movs r7, #2
    ldrsh r4, [r1, r7]
	movs r7, #4
    ldrsh r5, [r1, r7]
	movs r7, #6
    ldrsh r6, [r1, r7]
	movs r7, #8
    ldrsh r7, [r1, r7]
	push{r7}
	movs r7, #0
    ldrsh r3, [r1, r7]
	adds r1, #10
	movs r7, #2
    ldrsh r7, [r2, r7]
	mov r9, r7
	movs r7, #4
    ldrsh r7, [r2, r7]
	mov r10, r7
	movs r7, #6
    ldrsh r7, [r2, r7]
	mov r11, r7
	movs r7, #8
    ldrsh r7, [r2, r7]
	mov r12, r7
	movs r7, #0
    ldrsh r7, [r2, r7]
	mov r8, r7
	adds r2, #10
	pop{r7}

    add r3, r3, r8
    add r4, r4, r9
    add r5, r5, r10
    add r6, r6, r11
    add r7, r7, r12

    strh r4, [r0, #2]
    strh r5, [r0, #4]
    strh r6, [r0, #6]
    strh r7, [r0, #8]
    strh r3, [r0]
	adds r0, #10
	push{r7}
	mov r7, r14
    subs r7, #1
	mov r14, r7
	pop{r7}
	bne e3
	b e4
e3
	ldr r7, =co1
	bx r7

e4

  movs r7, #0
  ldrsh r3, [r1, r7]
  ldrsh r4, [r2, r7]
  add r3, r3, r4
  strh r3, [r0]

  pop{r4-r7}
  mov r8, r4
  mov r9, r5
  mov r10, r6
  mov r11, r7

  pop{r4-r7, pc}



asm_barrett_reduce_m3

  push{r4-r7, r14}
  mov r4, r8
  mov r5, r9
  mov r6, r10
  mov r7, r11
  push{r4-r7}

  ;poly        .req r0
  ;poly0       .req r1
  ;poly1       .req r2
  ;poly2       .req r3
  ;poly3       .req r4
  ;poly4       .req r5
  ;poly5       .req r10
  ;poly6       .req r12
  ;poly7       .req r8
  ;poly8       .req r14
  ;loop        .req r9
  ;barrettconst .req r6
  ;q           .req r11
  ;tmp         .req r7


  ldr r6, =20159
  ldr r7, =3329
  mov r11, r7

  ldr r7, =28
  mov r9, r7
	LTORG
  
co2
	movs r7, #0
    ldrsh r1, [r0, r7]
	movs r7, #2
    ldrsh r2, [r0, r7]
	movs r7, #4
    ldrsh r3, [r0, r7]
	movs r7, #6
    ldrsh r4, [r0, r7]
	movs r7, #8
    ldrsh r5, [r0, r7]
	movs r7, #10
    ldrsh r7, [r0, r7]
	mov r10, r7
	movs r7, #12
    ldrsh r7, [r0, r7]
	mov r12, r7
	movs r7, #14
    ldrsh r7, [r0, r7]
	mov r8, r7
	movs r7, #16
    ldrsh r7, [r0, r7]
	mov r14, r7

    barrettm3 r1, r7, r11, r6
    barrettm3 r2, r7, r11, r6
    barrettm3 r3, r7, r11, r6
    barrettm3 r4, r7, r11, r6
    barrettm3 r5, r7, r11, r6
    barrettm3 r10, r7, r11, r6
    barrettm3 r12, r7, r11, r6
    barrettm3 r8, r7, r11, r6
    barrettm3 r14, r7, r11, r6

	movs r7, #2
    strh r2, [r0, r7]
	movs r7, #4
    strh r3, [r0, r7]
	movs r7, #6
    strh r4, [r0, r7]
	movs r7, #8
    strh r5, [r0, r7]
	movs r7, #10
	push{r5}
	mov r5, r10
    strh r5, [r0, r7]
	movs r7, #12
	mov r5, r12
    strh r5, [r0, r7]
	movs r7, #14
	mov r5, r8
    strh r5, [r0, r7]
	movs r7, #16
	mov r5, r14
    strh r5, [r0, #16]
    strh r1, [r0]
	adds r0, #18
    pop{r5}
	mov r7, r9
    subs r7, #1
	mov r9, r7
	bne e5
	b e6
e5
	ldr r7, =co2
	bx r7
e6
  movs r7, #0
  ldrsh r1, [r0, r7]
  movs r7, #2
  ldrsh r2, [r0, r7]
  movs r7, #4
  ldrsh r3, [r0, r7]
  movs r7, #6
  ldrsh r4, [r0, r7]
  
  barrettm3 r1, r7, r11, r6
  barrettm3 r2, r7, r11, r6
  barrettm3 r3, r7, r11, r6
  barrettm3 r4, r7, r11, r6
 
  movs r7, #0 
  strh r1, [r0, r7]
  movs r7, #2
  strh r2, [r0, r7]
  movs r7, #4
  strh r3, [r0, r7]
  movs r7, #6
  strh r4, [r0, r7]
  pop{r4-r7}
  mov r8, r4
  mov r9, r5
  mov r10, r6
  mov r11, r7
  pop {r4-r7, pc}



asm_frommont_m3
  push{r4-r7, r14}
  mov r4, r8
  mov r5, r9
  mov r6, r10
  mov r7, r11
  push{r4-r7}

  ;poly        .req r0
  ;poly0       .req r1
  ;poly1       .req r2
  ;poly2       .req r3
  ;poly3       .req r4
  ;poly4       .req r5
  ;poly5       .req r10
  ;poly6       .req r12
  ;poly7       .req r8
  ;loop        .req r9
  ;constant    .req r6
  ;qinv        .req r14
  ;q           .req r11
  ;tmp         .req r7

  ldr r7, =3329
  mov r11, r7
  ldr r7, =3327
  mov r14, r7

  ldr r6, =1353

  movs r7, #32
  mov r9, r7
  LTORG
  
co3

    movs r7, #0
    ldrsh r1, [r0, r7]
	movs r7, #2
    ldrsh r2, [r0, r7]
	movs r7, #4
    ldrsh r3, [r0, r7]
	movs r7, #6
    ldrsh r4, [r0, r7]
	movs r7, #8
    ldrsh r5, [r0, r7]
	movs r7, #10
    ldrsh r7, [r0, r7]
	mov r10, r7
	movs r7, #12
    ldrsh r7, [r0, r7]
	mov r12, r7
	movs r7, #14
    ldrsh r7, [r0, r7]
	mov r8, r7

    muls r1, r6, r1
    muls r2, r6, r2
    muls r3, r6, r3
    muls r4, r6, r4
    muls r5, r6, r5
	mov r7, r10
    muls r7, r6, r7
	mov r10, r7
	mov r7, r12
    muls r7, r6, r7
	mov r12, r7
	mov r7, r8
    muls r7, r6, r7
	mov r8, r7
	
    montgomerym3 r11, r14, r1, r7
    montgomerym3 r11, r14, r2, r7
    montgomerym3 r11, r14, r3, r7
    montgomerym3 r11, r14, r4, r7
    montgomerym3 r11, r14, r5, r7
    montgomerym3 r11, r14, r10, r7
    montgomerym3 r11, r14, r12, r7
    montgomerym3 r11, r14, r8, r7

	movs r7, #2
    strh r2, [r0, r7]
	movs r7, #4
    strh r3, [r0, r7]
	movs r7, #6
    strh r4, [r0, r7]
	movs r7, #8
    strh r5, [r0, r7]
	movs r7, #10
	push{r5}
	mov r5, r10
    strh r5, [r0, r7]
	movs r7, #12
	mov r5, r12
    strh r5, [r0, r7]
	movs r7, #14
	mov r5, r8
    strh r5, [r0, r7]
    strh r1, [r0] 
	adds r0, #16

	mov r7, r9
    subs r7, #1
	mov r9, r7
    pop{r5}
	bne e7
	b e8
e7	
	ldr r7, =co3
	bx r7
e8
  pop{r4-r7}
  mov r8, r4
  mov r9, r5
  mov r10, r6
  mov r11, r7
  pop{r4-r7, pc}





doublebasemul_asm_m3

  push {r4-r7, lr}
  mov r4, r8
  mov r5, r9
  mov r6, r10
  mov r7, r11
  push{r4-r7}

  ;rptr  .req r0
  ;aptr  .req r1
  ;bptr  .req r2
  ;zeta  .req r3
  ;poly0 .req r4
  ;poly1 .req r5
  ;poly2 .req r9
  ;poly3 .req r10
  ;q     .req r8
  ;qinv  .req r14
  ;tmp   .req r6
  ;tmp2  .req r7


  ldr  r7, =3329
  mov r8, r7
  ldr r7, =3327
  mov r14, r7

  movs r7, #0
  ldrsh r4, [r1, r7]
  movs r7, #2
  ldrsh r5, [r1, r7]
  movs r7, #0
  ldrsh r7, [r2, r7]
  mov r9, r7
  movs r7, #0
  ldrsh r7, [r2, r7]
  mov r10, r7

  mov r6, r10
  muls r6, r5, r6
  montgomerym3 r8, r14, r6, r7
  muls r6, r3, r6
  mov r7, r9
  muls r7, r4, r7
  add r6, r7, r6
  montgomerym3 r8, r14, r6, r7
  movs r7, #0
  strh r6, [r0, r7]

  mov r6, r10
  muls r6, r4, r6
  mov r7, r9
  muls r7, r5, r7
  add r6, r6, r7
  montgomerym3 r8, r14, r6, r7
  movs r7, #2
  strh r6, [r0, r7]

  rsbs r3, r3, #0
  
  movs r7, #4
  ldrsh r4, [r1, r7]
  movs r7, #6
  ldrsh r5, [r1, r7]
  movs r7, #4
  ldrsh r7, [r2, r7]
  mov r9, r7
  movs r7, #6
  ldrsh r7, [r2, r7]
  mov r10, r7

  mov r6, r10
  muls r6, r5, r6
  montgomerym3 r8, r14, r6, r7
  muls r6, r3, r6
  mov r7, r9
  muls r7, r4, r7
  add r6, r7, r6

  montgomerym3 r8, r14, r6, r7
  movs r7, #4
  strh r6, [r0, r7]

  mov r6, r10
  muls r6, r4, r6
  mov r7, r9
  muls r7, r5, r7
  add r6, r7, r6
  
  montgomerym3 r8, r14, r6, r7
  movs r7, #6
  strh r6, [r0, r7]

  pop{r4-r7}
  mov r8, r4
  mov r9, r5
  mov r10, r6
  mov r11, r7

  pop{r4-r7, pc}
  LTORG
  

doublebasemul_asm_acc_m3

  push{r4-r7, lr}
  mov r4, r8
  mov r5, r9
  mov r6, r10
  mov r7, r11
  push{r4-r7}

  ;rptr  .req r0
  ;aptr  .req r1
  ;bptr  .req r2
  ;zeta  .req r3
  ;poly0 .req r4
  ;poly1 .req r5
  ;poly2 .req r9
  ;poly3 .req r10
  ;q     .req r8
  ;qinv  .req r11
  ;tmp   .req r6
  ;tmp2  .req r7
  ;res0  .req r12
  ;res1  .req r14


  ldr  r7, =3329
  mov r8, r7
  ldr r7, =3327
  mov r11, r7

  movs r7, #0
  ldrsh r4, [r1, r7]
  movs r7, #2
  ldrsh r5, [r1, r7]
  movs r7, #0
  ldrsh r7, [r2, r7]
  mov r9, r7
  movs r7, #2
  ldrsh r7, [r2, r7]
  mov r10, r7
  movs r7, #0
  ldrsh r7, [r0, r7]
  mov r12, r7
  movs r7, #2
  ldrsh r7, [r0, r7]
  mov r14, r7

  mov r6, r10
  muls r6, r5, r6
  montgomerym3 r8, r11, r6, r7
  muls r6, r3, r6
  mov r7, r9
  muls r7, r4, r7
  add r6, r7, r6

  montgomerym3 r8, r11, r6, r7
  add r12, r12, r6
  mov r7, r12
  movs r6, #0
  strh r7, [r0, r6]

  mov r6, r10
  muls r6, r4, r6
  mov r7, r9
  muls r7, r5, r7
  add r6, r7, r6
  
  montgomerym3 r8, r11, r6, r7
  add r14, r14, r6
  mov r7, r14
  movs r6, #2
  strh r7, [r0, r6]

  rsbs r3, r3, #0

  movs r7, #4
  ldrsh r4, [r1, r7]
  movs r7, #6
  ldrsh r5, [r1, r7]
  movs r7, #4
  ldrsh r7, [r2, r7]
  mov r9, r7
  movs r7, #6
  ldrsh r7, [r2, r7]
  mov r10, r7
  movs r7, #4
  ldrsh r7, [r0, r7]
  mov r12, r7
  movs r7, #6
  ldrsh r7, [r0, r7]
  mov r14, r7

  mov r6, r10
  muls r6, r5, r6
  montgomerym3 r8, r11, r6, r7
  muls r6, r3, r6
  mov r7, r9
  muls r7, r4, r7
  add r6, r7, r6
  
  montgomerym3 r8, r11, r6, r7
  add r12, r12, r6
  movs r7, #4
  push{r5}
  mov r5, r12
  strh r5, [r0, r7]
  pop{r5}

  mov r6, r10
  muls r6, r4, r6
  mov r7, r9
  muls r7, r5, r7
  add r6, r7, r6
  
  montgomerym3 r8, r11, r6, r7
  add r14, r14, r6
  movs r7, #6
  push{r5}
  mov r5, r14
  strh r5, [r0, r7]
  pop{r5}

  pop{r4-r7}
  mov r8, r4
  mov r9, r5
  mov r10, r6
  mov r11, r7

  pop{r4-r7, pc}
  


basemul_asm_m3

    push{r4-r7, lr}
    mov r4, r8
    mov r5, r9
    mov r6, r10
    mov r7, r11
    push{r4-r7}

	;rptr    .req r0
    ;aptr    .req r1
    ;bptr    .req r2
    ;zetaptr .req r3
    ;poly0   .req r4
    ;poly1   .req r6
    ;poly2   .req r9
    ;poly3   .req r10
    ;q       .req r8
    ;qinv    .req r11
    ;tmp     .req r6
    ;tmp2    .req r7
    ;zeta    .req r12
    ;loop    .req r14

    ldr r7, =3329
	mov r8, r7 
    ldr r7, =3327
	mov r11, r7
    movs r7, #64
	mov r14, r7
	
co4
      movs r7, #0
	  ldrsh r7, [r3, r7]
	  mov r12, r7
	  adds r3, #2
	  movs r7, #2
      ldrsh r5, [r1, r7]
	  movs r7, #0
      ldrsh r4, [r1, r7]
	  adds r1, #4
	  movs r7, #2
      ldrsh r7, [r2, r7]
	  mov r10, r7
	  movs r7, #0
      ldrsh r7, [r2, r7]
	  mov r9, r7
	  adds r2, #4

      mov r6, r10
	  muls r6, r5, r6
	  montgomerym3 r8, r11, r6, r7
	  mov r7, r12
	  muls r6, r7, r6
	  mov r7, r9
	  muls r7, r4, r7
	  add r6, r7, r6
      montgomerym3 r8, r11, r6, r7
      strh r6, [r0]
	  adds r0, #2

      mov r6, r10
	  muls r6, r4, r6
	  mov r7, r9
	  muls r7, r5, r7
	  add r6, r7, r6
      montgomerym3 r8, r11, r6, r7
      strh r6, [r0]
	  adds r0, #2

	  mov r7, r12
      rsbs r7, r7, #0
	  mov r12, r7

	  movs r7, #2
      ldrsh r5, [r1, r7]
	  movs r7, #0
      ldrsh r4, [r1, r7]
	  adds r1, #4
	  movs r7, #2
      ldrsh r7, [r2, r7]
	  mov r10, r7
	  movs r7, #0
      ldrsh r7, [r2, r7]
	  mov r9, r7
	  adds r2, #4

      mov r6, r10
	  muls r6, r5, r6
	  montgomerym3 r8, r11, r6, r7
	  mov r7, r12
	  muls r6, r7, r6
	  mov r7, r9
	  muls r7, r4, r7
	  add r6, r7, r6  
      montgomerym3 r8, r11, r6, r7
      strh r6, [r0]
	  adds r0, #2

      mov r6, r10
	  muls r6, r4, r6
	  mov r7, r9
	  muls r7, r5, r7
	  add r6, r7, r6     
      montgomerym3 r8, r11, r6, r7
      strh r6, [r0]
	  adds r0, #2

	  mov r7, r14
      subs r7, #1
	  mov r14, r7
	  bne k1
	  b k2
k1
	  ldr r7, =co4
	  bx r7
k2
    pop{r4-r7}
    mov r8, r4
    mov r9, r5
    mov r10, r6
    mov r11, r7
    pop{r4-r7, pc}


basemul_asm_acc_m3
    push{r4-r7, lr}
    mov r4, r8
    mov r5, r9
    mov r6, r10
    mov r7, r11
    push{r4-r7}


    ldr r7, =3329
	mov r8, r7
    ldr r7, =3327
	mov r11, r7

    movs r7, #64
	mov r14, r7
	
co5
	  movs r7, #0
      ldrsh r7, [r3, r7] 
	  mov r12, r7
	  adds r3, #2

	  movs r7, #2
      ldrsh r5, [r1,  r7]
	  movs r7, #0
      ldrsh r4, [r1, r7]
	  adds r1, #4
	  movs r7, #2
      ldrsh r7, [r2, r7]
	  mov r10, r7
	  movs r7, #0
      ldrsh r7, [r2, r7]
	  mov r9, r7
	  adds r2, #4


	  mov r6, r10
      muls r6, r5, r6
      montgomerym3 r8, r11, r6, r7
	  mov r7, r12
      muls r6, r7, r6
	  mov r7, r9
      muls r7, r4, r7
      add r6, r6, r7
      
      montgomerym3 r8, r11, r6, r7
	  movs r7, #0
      ldrsh r7, [r0, r7]
      add r6, r6, r7
      strh r6, [r0]
	  adds r0, #2

      mov r6, r10
      muls r6, r4, r6
      mov r7, r9
      muls r7, r5, r7
      add r6, r6, r7
      
      montgomerym3 r8, r11, r6, r7
	  movs r7, #0
      ldrsh r7, [r0, r7]
      add r6, r6, r7
      strh r6, [r0]
	  adds r0, #2

	  mov r7, r12
      rsbs r7, r7, #0
	  mov r12, r7

      movs r7, #2
      ldrsh r5, [r1,  r7]
	  movs r7, #0
      ldrsh r4, [r1, r7]
	  adds r1, #4
	  movs r7, #2
      ldrsh r7, [r2, r7]
	  mov r10, r7
	  movs r7, #0
      ldrsh r7, [r2, r7]
	  mov r9, r7
	  adds r2, #4


      mov r6, r10
      muls r6, r5, r6
      montgomerym3 r8, r11, r6, r7
	  mov r7, r12
      muls r6, r7, r6
	  mov r7, r9
      muls r7, r4, r7
      add r6, r6, r7
    
      montgomerym3 r8, r11, r6, r7
	  movs r7, #0
      ldrsh r7, [r0, r7]
      add r6, r6, r7
      strh r6, [r0]
	  adds r0, #2

      mov r6, r10
      muls r6, r4, r6
      mov r7, r9
      muls r7, r5, r7
      add r6, r6, r7
      
      montgomerym3 r8, r11, r6, r7
      movs r7, #0
      ldrsh r7, [r0, r7]
      add r6, r6, r7
      strh r6, [r0]
	  adds r0, #2
	  mov r7, r14

      subs r7, #1
	  mov r14, r7
	  bne k3
	  b k4
k3
	  ldr r7, =co5
	  bx r7
k4
    pop{r4-r7}
    mov r8, r4
    mov r9, r5
    mov r10, r6
    mov r11, r7
    pop{r4-r7, pc}
	END