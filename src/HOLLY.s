!///////////////////////////////////////////////////////////////////////////////
!// Initialization of the HOLLY that is not covered by regular applications
!// Copyright 2023 by T_chan
!//
!// R0 to R7: not preserved, R8 to R13: preserved, R14/R15: do not touch
!///////////////////////////////////////////////////////////////////////////////
    .globl _HOLLY_init
    .text

_HOLLY_init:

!///////////////////////////////////////////////////////////////////////////////
!// VRAM (aka "Texture Memory") initialization
!///////////////////////////////////////////////////////////////////////////////
.HOLLY_VRAM_init:
    mov.l VRAM_ARB_CFG_DATA, R1           ! 
    mov.l VRAM_ARB_CFG_ADDR, R2           !
    mov.l R1, @R2                         ! 
    mov.l VRAM_CFG_DATA, R1               ! Set up video timings copied from libnaomi <- Naomi BIOS.
    mov.l VRAM_CFG_ADDR, R2               !
    mov.l R1, @R2                         ! 
    mov.l VRAM_REFRESH_DATA, R1           ! copied from libnaomi <- Naomi BIOS.
    mov.l VRAM_REFRESH_ADDR, R2           !
    mov.l R1, @R2                         ! 

!///////////////////////////////////////////////////////////////////////////////
!// 
!///////////////////////////////////////////////////////////////////////////////
.HOLLY_FB_init:

    mov.l FB_R_CTRL_DISABLE, R1           ! 
    mov.l FB_R_CTRL_ADDR, R2              ! 
    mov.l R1, @R2                         ! 
    mov.l VO_CONTROL_HIDE_SCREEN, R1      !
    mov.l VO_CONTROL_ADDR, R2             ! 
    mov.l R1, @R2                         ! 
    mov.l SOFTRESET_DATA, R1              ! copied from libnaomi <- Naomi BIOS.   Make sure video is not in reset.
    mov.l SOFTRESET_ADDR, R2              !
    mov.l R1, @R2                         ! 

    mov.l FB_W_CTRL_RGB555, R1            ! 
    mov.l FB_W_CTRL_ADDR, R2              !     
    mov.l R1, @R2                         ! 
    mov.l FB_BURSTCTRL_DEFAULT, R1        ! 
    mov.l FB_BURSTCTRL_ADDR, R2           ! 
    mov.l R1, @R2                         ! 
    mov.l FB_Y_COEFF_DEFAULT, R1          ! 
    mov.l FB_Y_COEFF_ADDR, R2             ! 
    mov.l R1, @R2                         ! 
    mov.l FB_R_SOF1_DEFAULT, R1           !
    mov.l FB_R_SOF1_ADDR, R2              ! 
    mov.l R1, @R2                         ! 
    mov.l FB_R_SOF2_DEFAULT, R1           !
    mov.l FB_R_SOF2_ADDR, R2              ! 
    mov.l R1, @R2                         ! 

!///////////////////////////////////////////////////////////////////////////////
!// 
!///////////////////////////////////////////////////////////////////////////////
.HOLLY_SPG_init:
    mov.l SPG_LOAD_VGA, R1                ! LIBNAOMI USES THIS (524<<16 | 857)-> SAME 
    mov.l SPG_LOAD_ADDR, R2               ! 
    mov.l R1, @R2                         ! 
    
    mov.l SPG_HBLANK_NON_PAL, R1          ! 
    mov.l SPG_HBLANK_ADDR, R2             ! 
    mov.l R1, @R2                         ! 

    mov.l SPG_VBLANK_VGA, R1              ! LIBNAOMI USES THIS (40<<16 | 480 + 40)-> SAME 
    mov.l SPG_VBLANK_ADDR, R2             ! 
    mov.l R1, @R2                         ! 

    mov.l SPG_WIDTH_VGA, R1               ! 
    mov.l SPG_WIDTH_ADDR, R2              ! 
    mov.l R1, @R2                         ! 

    mov.l SPG_CONTROL_VGA, R1             ! LIBNAOMI USES THIS (for 31 kHz. for 15: also | 1 << 6)-> SAME 
    mov.l SPG_CONTROL_ADDR, R2            ! 
    mov.l R1, @R2                         ! 

    mov.l SPG_HBLANK_INT_DEFAULT, R1      !
    mov.l SPG_HBLANK_INT_ADDR, R2         ! 
    mov.l R1, @R2                         ! 
    mov.l SPG_VBLANK_INT_DEFAULT, R1      !
    mov.l SPG_VBLANK_INT_ADDR, R2         ! 
    mov.l R1, @R2                         ! 

!///////////////////////////////////////////////////////////////////////////////
!// 
!///////////////////////////////////////////////////////////////////////////////
.HOLLY_VO_init:

    mov.l VO_STARTX_VGA, R1               ! 
    mov.l VO_STARTX_ADDR, R2              ! 
    mov.l R1, @R2                         ! 

    mov.l VO_STARTY_VGA, R1               !  
    mov.l VO_STARTY_ADDR, R2              ! 
    mov.l R1, @R2                         ! 

    mov.l FB_R_CTRL_ENABLE, R1            !
    mov.l FB_R_CTRL_ADDR, R2              ! 
    mov.l R1, @R2                         ! 
    mov.l VO_CONTROL_640, R1              ! LIBNAOMI USES THIS -> SAME 0x00160000
    mov.l VO_CONTROL_ADDR, R2             ! 
    mov.l R1, @R2                         ! 

!///////////////////////////////////////////////////////////////////////////////
!// end
!///////////////////////////////////////////////////////////////////////////////
    rts
    nop

!///////////////////////////////////////////////////////////////////////////////
!// Constants
!///////////////////////////////////////////////////////////////////////////////
    .align 4

VRAM_REFRESH_ADDR:                        ! Texture Memory refresh counter
    .long        0xA05F80A0               !    Initial: 
VRAM_REFRESH_DATA:                        !    Bios:    0x00000020
    .long        0x00000020
VRAM_ARB_CFG_ADDR:                        ! Texture Memory arbiter control
    .long        0xA05F80A4               !    Initial: 
VRAM_ARB_CFG_DATA:                        !    Bios:    0x0000001F
    .long        0x0000001F
VRAM_CFG_ADDR:                            ! Texture Memory control
    .long        0xA05F80A8               !    Initial: 
VRAM_CFG_DATA:                            !    Bios:    0x15d1c951
    .long        0x15d1c951               ! TODO ? naomi: 0x15D1C955

FB_R_CTRL_ADDR:                           !
    .long        0xa05f8044               !    Initial: 
FB_R_CTRL_DISABLE:                        !    Bios: 0x00800005 = VGA, 565 RGB
    .long        0x00800000               !    = VGA, RGB555, disable FB reads
FB_R_CTRL_ENABLE:            
    .long        0x00800001               !    = VGA, RGB555, enable FB reads
FB_W_CTRL_ADDR: 
    .long        0xa05f8048               !    Initial:
FB_W_CTRL_RGB565:                         !    Bios:    0x00000009
    .long        0x00000009               ! dithering, RGB565
FB_W_CTRL_RGB555: 
    .long        0x00000008               ! dithering, RGB555
FB_BURSTCTRL_ADDR:
    .long        0xa05f8110
FB_BURSTCTRL_DEFAULT:                     ! Bios: 0x00093f39
    .long        0x00093f39
FB_Y_COEFF_ADDR:
    .long        0xa05f8118
FB_Y_COEFF_DEFAULT:                       ! Bios: 0x00008040
    .long        0x00008040
FB_R_SOF1_ADDR:
    .long        0xa05f8050
FB_R_SOF1_DEFAULT:                        ! Bios: 0x00200000
    .long        0x00200000
FB_R_SOF2_ADDR:
    .long        0xa05f8054
FB_R_SOF2_DEFAULT:                        ! Bios: 0x00205000
    .long        0x00205000

SPG_HBLANK_INT_ADDR:
    .long        0xa05f80c8
SPG_HBLANK_INT_DEFAULT:                   ! Bios: 0x03450000
    .long        0x03450000
SPG_VBLANK_INT_ADDR:
    .long        0xa05f80cc
SPG_VBLANK_INT_DEFAULT:                   ! Bios: 0x00150208
    .long        0x00150208

SPG_CONTROL_ADDR:                         ! Sync pulse generator control   ! used in libnaomi
    .long        0xA05F80D0
SPG_CONTROL_VGA:                          ! Bios: 0x00000100
    .long        0x00000100               ! 
SPG_HBLANK_ADDR:                          ! H-blank control                ! Not used in libnaomi ?
    .long        0xA05F80D4
SPG_HBLANK_NON_PAL:                       ! Bios: 0x007E0345
    .long        0x007E0345               !
SPG_LOAD_ADDR:                            ! HV counter load value          ! used in libnaomi
    .long        0xA05F80D8
SPG_LOAD_VGA:                             ! Bios: 0x020C0359
    .long        0x020C0359               ! 
SPG_VBLANK_ADDR:                          ! V-blank control                ! used in libnaomi
    .long        0xA05F80DC
SPG_VBLANK_VGA:                           ! Bios: 0x00280208   
    .long        0x00280208               ! 
SPG_WIDTH_ADDR:                           ! Sync width control             ! Not used in libnaomi ?
    .long        0xA05F80E0
SPG_WIDTH_VGA:                            ! Bios: 0x03F1933F
    .long        0x03F1933F               !

VO_BORDER_COL_ADDR:                       ! Border area color: background color            ! used in libnaomi
    .long        0xA05F8040

VO_CONTROL_ADDR:                          ! Video output control: hide/display screen      ! used in libnaomi
    .long        0xA05F80E8
VO_CONTROL_640:                           ! Bios: 0x00160000
    .long        0x00160000
VO_CONTROL_HIDE_SCREEN:
    .long        0x00160008

VO_STARTX_ADDR:                           ! Video output start X position                  ! used in libnaomi
    .long        0xA05F80EC
VO_STARTX_VGA:                            ! LIBNAOMI USES THIS (slighly different: A6 for 31 kHz. for 15: A4)-> NOT SAME (kos: not same: AC (172))
    .long        0x000000A8               ! Bios: 0x000000A8

VO_STARTY_ADDR:                           ! Video output start Y position                  ! used in libnaomi
    .long        0xA05F80F0
VO_STARTY_VGA:                            ! LIBNAOMI USES THIS (slighly different: 0x00230023 for 31 kHz, for 15: 0x00160016) -> NOT SAME (KOS: same: 0x00280028)
    .long        0x00280028               ! Bios: 0x00280028

SOFTRESET_ADDR:
    .long        0xA05F8008
SOFTRESET_DATA:
    .long        0x00000000               ! SOFT RESET  sdram Pipeline  TA
