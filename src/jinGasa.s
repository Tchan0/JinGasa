!///////////////////////////////////////////////////////////////////////////////
!// Initialization of DC-like systems that is not covered by regular applications
!// Copyright 2023 by T_chan
!//
!// R0 to R7: not preserved, R8 to R13: preserved, R14/R15: do not touch
!///////////////////////////////////////////////////////////////////////////////
    .globl .start
    .globl _jinGasa_init
    .text

.start:
_jinGasa_init:

!///////////////////////////////////////////////////////////////////////////////
!// initialize the different systems
!///////////////////////////////////////////////////////////////////////////////
    mov.l SH4_INIT_ADDR, R0
    jsr @R0
    nop

    mov.l HOLLY_INIT_ADDR, R0 
    jsr @R0
    nop

    mov.l VECTORS_INIT_ADDR, R0 
    jsr @R0
    nop

    !mov.l AICA_INIT_ADDR, R0             ! TODO: AICA init
    !jsr @R0
    !nop

!///////////////////////////////////////////////////////////////////////////////
!// Load dc-load-ser, and jump to it
!///////////////////////////////////////////////////////////////////////////////
.dcloadserial_copy_start:
    mov.l DCLOADSERIAL_ROM_OFFSET, R0
    mov.l JINGASA_START_ADDR, R1
    add R1, R0
    mov.l DCLOADSERIAL_SIZE, R3
    mov.l DCLOADSERIAL_DEST_ADDR, R2

dcloadserial_copy_loop:
    mov.l @R0+, R1
    dt R3                                 !  <- only works if >>2 has been done on the size
    mov.l R1, @R2
    bf/s dcloadserial_copy_loop
    add #4, R2

.dcloadserial_copy_end:
    mov.l DCLOADSERIAL_JMP_ADDR, R0
    jmp	@R0
    nop

!///////////////////////////////////////////////////////////////////////////////
!// Variables
!///////////////////////////////////////////////////////////////////////////////
    .align 4

JINGASA_START_ADDR:
    .long        .start                   ! Where this BIOS is loaded in RAM. Will be used for relative offsets

SH4_INIT_ADDR:
    .long        _SH4_init
HOLLY_INIT_ADDR:
    .long        _HOLLY_init
VECTORS_INIT_ADDR:
    .long        _vectors_init
AICA_INIT_ADDR:
    .long        _AICA_init

DCLOADSERIAL_ROM_OFFSET:
   .long         0x00010000               ! Must be the same offset as specified in the Makefile !
DCLOADSERIAL_SIZE:
    .long        0x00008000  >> 2         ! overkill (32 kB copy), but avoids having to adapt this everytime dcload-ser size
!   .long        15796       >> 2         !  increases a little bit (currently it's +- 15.5 kB big)
DCLOADSERIAL_DEST_ADDR:
    .long        0xAC010000
DCLOADSERIAL_JMP_ADDR:
    .long        0x8C010000
