; Constants
buffer_keyboard                     = 0
inkey_key_shift                     = 255
osbyte_acknowledge_escape           = 126
osbyte_enter_language               = 142
osbyte_flush_buffer                 = 21
osbyte_inkey                        = 129
osbyte_read_write_basic_rom_bank    = 187
osbyte_read_write_bell_duration     = 214
osbyte_read_write_bell_frequency    = 213
osbyte_read_write_last_break_type   = 253
osbyte_scan_keyboard                = 121
osbyte_set_cursor_editing           = 4
osfile_load                         = 255
osfile_read_catalogue_info          = 5
osfile_save                         = 0
osfind_close                        = 0
osfind_open_input                   = 64
osfind_open_output                  = 128

; Memory locations
l0006               = &0006
l0070               = &0070
l0071               = &0071
l0072               = &0072
l0073               = &0073
l0075               = &0075
l0076               = &0076
l0077               = &0077
l0078               = &0078
l0079               = &0079
l007a               = &007a
l007b               = &007b
l007c               = &007c
l007d               = &007d
l007e               = &007e
l007f               = &007f
l0080               = &0080
l0081               = &0081
l0082               = &0082
l0084               = &0084
l0085               = &0085
l0086               = &0086
l0087               = &0087
l0088               = &0088
l0089               = &0089
l008a               = &008a
l008e               = &008e
l008f               = &008f
os_text_ptr         = &00f2
romsel_copy         = &00f4
l00fd               = &00fd
l0103               = &0103
brkv                = &0202
l0400_device_type   = &0400
l0401_misca_shadow  = &0401
l0402_miscb_shadow  = &0402
l0403               = &0403
l0500               = &0500
l0501               = &0501
l0502               = &0502
l0503               = &0503
l0504               = &0504
l0505               = &0505
l0506               = &0506
l0507               = &0507
l0508               = &0508
l0509               = &0509
l050a               = &050a
l050b               = &050b
l050c               = &050c
l0580               = &0580
l0600               = &0600
l0680               = &0680
l06a0               = &06a0
l06a1               = &06a1
l06a2               = &06a2
l06a3               = &06a3
l06a4               = &06a4
l06a5               = &06a5
l06a6               = &06a6
l06a7               = &06a7
l06a8               = &06a8
l06a9               = &06a9
l06aa               = &06aa
l06ab               = &06ab
l06ac               = &06ac
l06ad               = &06ad
l06ae               = &06ae
l06af               = &06af
l06b0               = &06b0
l0700               = &0700
l2003               = &2003
l2004               = &2004
l2005               = &2005
l2006               = &2006
l2007               = &2007
l2008               = &2008
sub_ca5b0           = &a5b0
PIA1_PortA_Addr_Lo  = &fcc0
PIA1_ControlA       = &fcc1
PIA1_PortB_Addr_Hi  = &fcc2
PIA1_ControlB       = &fcc3
PIA2_PortA_Data     = &fcc4
PIA2_ControlA       = &fcc5
PIA2_PortB_Misc     = &fcc6
PIA2_ControlB       = &fcc7
romsel              = &fe30
user_via_t2c_l      = &fe68
user_via_t2c_h      = &fe69
user_via_acr        = &fe6b
user_via_ifr        = &fe6d
user_via_ier        = &fe6e
osfind              = &ffce
osbput              = &ffd4
osbget              = &ffd7
osfile              = &ffdd
osrdch              = &ffe0
osasci              = &ffe3
osnewl              = &ffe7
oswrch              = &ffee
osbyte              = &fff4
oscli               = &fff7

    org &8000

.pydis_start
    jmp c80b9

    jmp c804e

    equb &c2, &2a,   3
    equs "MICRON PLUS EPROM PROGRAMMER 1.41"
    equb 0
    equs "(C)H.C.R. ELECTRONIC SERVICES 1987"
    equb 0

.c804e
    pha
    tya
    pha
    txa
    pha
    tsx
    lda l0103,x
    cmp #4
    bne c8080
    ldx #0
.loop_c805d
    lda (os_text_ptr),y
    cmp l91c6,x
    bne c8084
    iny
    inx
    cpx #5
    bne loop_c805d
    jsr jmp_Reset_Hardware
    jsr sub_c8d73
    ldx #1
    ldy #0
    lda #osbyte_read_write_last_break_type
    jsr osbyte                                                        ; Write type of last reset, value X=1
    pla
    tax                                                               ; X=ROM number
    lda #osbyte_enter_language
    jmp osbyte                                                        ; Enter language ROM X

.c8080
    cmp #9
    beq c808a
.c8084
    pla
    tax
    pla
    tay
    pla
    rts

.c808a
    lda (os_text_ptr),y
    cmp #&0d
    bne c8084
    jsr osnewl                                                        ; Write newline (characters 10 and 13)
    ldx #9
    ldy #&80
    jsr sub_c80a4
    ldx #&63 ; 'c'
    ldy #&8e
    jsr sub_c80a4
    jmp c8084

.sub_c80a4
    stx l0088
    sty l0089
    ldy #0
.c80aa
    lda (l0088),y
    beq c80b8
    jsr osasci                                                        ; Write character
    iny
    bne c80aa
    inc l0089
    bne c80aa
.c80b8
    rts

.c80b9
    cmp #1
    bne c80b8
    cli
    ldx #&ff
    txs
    jsr jmp_Reset_Hardware
    lda #&83
    sta brkv+1
    lda #&c2
    sta brkv
    ldx #0
    ldy #&ff
    lda #osbyte_read_write_last_break_type
    jsr osbyte                                                        ; Read type of last reset
    cpx #0                                                            ; X=value of type of last reset
    beq c80de
.loop_c80db
    jsr sub_c81c2
.c80de
    jsr Summary_Screen
    ldx #&be
    ldy #&8e
    jsr sub_c80a4
.c80e8
    jsr osrdch                                                        ; Read a character from the current input stream
    cmp #&1b                                                          ; A=character read
    bne c80f5
    jsr c8bcb
    jmp loop_c80db

.c80f5
    cmp #&2a ; '*'
    bne c80ff
    jsr sub_c8378
    jmp c80de

.c80ff
    cmp #&31 ; '1'
    bne c810c
    jsr sub_c8e06
    jsr jmp_Copy_ROM
    jmp c80de

.c810c
    cmp #&32 ; '2'
    bne c8119
    jsr sub_c8e06
    jsr jmp_Blank_Check_ROM
    jmp c80de

.c8119
    cmp #&33 ; '3'
    bne c8126
    jsr sub_c8e06
    jsr jmp_Program_ROM
    jmp c80de

.c8126
    cmp #&34 ; '4'
    bne c8133
    jsr sub_c8e06
    jsr jmp_Verify_ROM
    jmp c80de

.c8133
    cmp #&35 ; '5'
    bne c813d
    jsr sub_c876d
    jmp c80de

.c813d
    cmp #&36 ; '6'
    bne c8144
    jsr sub_c83f0
.c8144
    cmp #&37 ; '7'
    bne c814b
    jsr sub_c8559
.c814b
    cmp #&38 ; '8'
    bne c8155
    jsr jmp_Rom_Image_Creator
    jmp c80de

.c8155
    cmp #&39 ; '9'
    bne c816d
    jsr osnewl                                                        ; Write newline (characters 10 and 13)
    jsr osnewl                                                        ; Write newline (characters 10 and 13)
    ldy #&ff
    ldx #0
    lda #osbyte_read_write_basic_rom_bank
    jsr osbyte                                                        ; Read BASIC ROM number
    lda #osbyte_enter_language
    jsr osbyte                                                        ; Enter language ROM X
.c816d
    cmp #&16
    bne c819e
    lda l0501
    sta l0082
    and #&0e
    bne c8184
    lda l0082
    ora #2
    sta l0501
    jmp c80de

.c8184
    cmp #2
    bne c8194
    lda l0082
    and #&fd
    ora #4
    sta l0501
    jmp c80de

.c8194
    lda l0082
    and #&f1
    sta l0501
    jmp c80de

.c819e
    jmp c80e8

.sub_c81a1
    cmp #&1b
    bne c81aa
    jsr c8bcb
.c81a8
    sec
    rts

.c81aa
    cmp #&30 ; '0'
    bcc c81a8
    cmp #&47 ; 'G'
    bcs c81a8
    cmp #&3a ; ':'
    bcc c81bd
    cmp #&41 ; 'A'
    bcc c81a8
    sec
    sbc #7
.c81bd
    sec
    sbc #&30 ; '0'
    clc
    rts

.sub_c81c2
    ldx #&c8
    ldy #&8f
    jsr sub_c80a4
.c81c9
    jsr osrdch                                                        ; Read a character from the current input stream
    cmp #&1b                                                          ; A=character read
    bne c81d6
    jsr c8bcb
    jmp c81c9

.c81d6
    jsr sub_c81a1
    bcs c81c9
    cmp #&0a
    bcs c81c9
    sta l0400_device_type
    asl a
    asl a
    asl a
    asl a
    tax
    jsr jmp_Set_Device_Variables
    rts

.Summary_Screen
    lda #&16
    jsr oswrch                                                        ; Write character 22
    lda #7
    jsr oswrch                                                        ; Write character 7
    jsr osnewl                                                        ; Write newline (characters 10 and 13)
    jsr Cursor_Off
    ldx #2
.loop_c81fd
    jsr Print_Device_Type
    jsr Print_VPP_Voltage
    jsr Print_Slow_Fast
    jsr osnewl                                                        ; Write newline (characters 10 and 13)
    dex
    bne loop_c81fd
    rts

.Print_Device_Type
    lda l0400_device_type
    bne c8226
    jsr print_string
    equs &84, &9d, &83, &8d, "27513 (64K)", 0

    rts

.c8226
    cmp #1
    bne c823e
    jsr print_string
    equs &84, &9d, &83, &8d, "27512 (64K)", 0

    rts

.c823e
    cmp #2
    bne c8256
    jsr print_string
    equs &84, &9d, &83, &8d, "27256 (32K)", 0

    rts

.c8256
    cmp #3
    bne c826e
    jsr print_string
    equs &84, &9d, &83, &8d, "27128 (16K)", 0

    rts

.c826e
    cmp #4
    bne c8286
    jsr print_string
    equs &84, &9d, &83, &8d, "2764 (8K)  ", 0

    rts

.c8286
    cmp #5
    bne c829e
    jsr print_string
    equs &84, &9d, &83, &8d, "2732 (4K)  ", 0

    rts

.c829e
    cmp #6
    bne c82b6
    jsr print_string
    equs &84, &9d, &83, &8d, "2716 (2K)  ", 0

    rts

.c82b6
    cmp #7
    bne c82ce
    jsr print_string
    equs &84, &9d, &83, &8d, "2564 (8K)  ", 0

    rts

.c82ce
    cmp #8
    bne c82e6
    jsr print_string
    equs &84, &9d, &83, &8d, "2532 (4K)  ", 0

    rts

.c82e6
    jsr print_string
    equs &84, &9d, &83, &8d, "27011 (128K)", 0

    rts

.Print_VPP_Voltage
    lda l0501
    and #&0e
    cmp #4
    bne c8312
    jsr print_string
    equs "    12.5V", 0

    rts

.c8312
    cmp #2
    bne c8324
    jsr print_string
    equs "      21V", 0

    rts

.c8324
    jsr print_string
    equs "      25V", 0

    rts

.Print_Slow_Fast
    lda l0502
    bne c8348
    jsr print_string
    equs "        SLOW", 0

    rts

.c8348
    jsr print_string
    equs "        FAST", 0

    rts

.print_string
    pla
    sta l0088
    pla
    sta l0089
    ldy #0
.loop_c8361
    inc l0088
    bne c8367
    inc l0089
.c8367
    lda (l0088),y
    beq c8371
    jsr osasci                                                        ; Write character
    clc
    bcc loop_c8361
.c8371
    lda l0089
    pha
    lda l0088
    pha
    rts

.sub_c8378
    pha
    jsr osnewl                                                        ; Write newline (characters 10 and 13)
    jsr osnewl                                                        ; Write newline (characters 10 and 13)
    pla
    jsr oswrch                                                        ; Write character
    ldx #0
.c8385
    jsr osrdch                                                        ; Read a character from the current input stream
    cmp #&1b                                                          ; A=character read
    bne c8390
    jsr c8bcb
    rts

.c8390
    cmp #&7f
    bne c83a0
    cpx #0
    beq c8385
    lda #&7f
    jsr oswrch                                                        ; Write character 127
    dex
    bpl c8385
.c83a0
    jsr oswrch                                                        ; Write character
    sta l0700,x
    cmp #&0d
    beq c83ad
    inx
    bpl c8385
.c83ad
    lda #&0c
    jsr oswrch                                                        ; Write character 12
    jsr osnewl                                                        ; Write newline (characters 10 and 13)
    jsr osnewl                                                        ; Write newline (characters 10 and 13)
    ldx #<(l0700)
    ldy #>(l0700)
    jsr oscli
    jmp c83e3

.brk_handler
    lda #&1f
    jsr oswrch                                                        ; Write character 31
    lda #&0c
    jsr oswrch                                                        ; Write character 12
    lda #&15
    jsr oswrch                                                        ; Write character 21
    lda #7
    jsr oswrch                                                        ; Write character 7
    ldy #0
.loop_c83d8
    iny
    lda (l00fd),y
    beq c83e3
    jsr oswrch                                                        ; Write character
    jmp loop_c83d8

.c83e3
    ldy #&91
    ldx #&7a ; 'z'
    jsr sub_c80a4
    jsr osrdch                                                        ; Read a character from the current input stream
    jmp c80de

.sub_c83f0
    jsr sub_c863d
    ldx #0
    jsr c8742
    jsr sub_c8515
    jsr osrdch                                                        ; Read a character from the current input stream
    cmp #&0d                                                          ; A=character read
    bne c8414
    lda #0
    sta l0070
    sta l0072
    lda #&20 ; ' '
    sta l0071
    lda l0504
    sta l0073
    jmp c8498

.c8414
    jsr print_string
    equs &1f, 1, &0f, "Enter START address for save :- ", 0

    jsr sub_c8bd1
    lda l0084
    asl a
    asl a
    asl a
    asl a
    clc
    adc l0085
    adc #&20 ; ' '
    sta l0071
    lda l0086
    asl a
    asl a
    asl a
    asl a
    clc
    adc l0087
    sta l0070
    jsr print_string
    equs &1f, 1, &12, "Enter END address+1 for save :- ", 0

    jsr sub_c8bd1
    lda l0084
    asl a
    asl a
    asl a
    asl a
    clc
    adc l0085
    adc #&20 ; ' '
    sta l0073
    lda l0086
    asl a
    asl a
    asl a
    asl a
    clc
    adc l0087
    sta l0072
.c8498
    jsr osnewl                                                        ; Write newline (characters 10 and 13)
    jsr osnewl                                                        ; Write newline (characters 10 and 13)
    ldx #<(l0700)
    ldy #>(l0700)
    lda #osfind_open_output
    jsr osfind                                                        ; Open file for output (A=128)
    sta l0082                                                         ; A=file handle (or zero on failure)
.c84a9
    lda l0071
    cmp l0073
    beq c84b3
    bcs c84d8
    bcc c84b9
.c84b3
    lda l0070
    cmp l0072
    bcs c84d8
.c84b9
    lda l0071
    cmp #&60 ; '`'
    bcc c84c2
    jmp c84e2

.c84c2
    ldy #0
    lda (l0070),y
.c84c6
    ldy l0082                                                         ; Y=file handle
    jsr osbput                                                        ; Write a single byte A to an open file Y
    inc l0070
    bne c84a9
    inc l0071
    lda l0071
    cmp l0504
    bne c84a9
.c84d8
    lda #osfind_close
    ldy l0082
    jsr osfind                                                        ; Close one or all files
    jmp c83e3

.c84e2
    sec
    sbc #&60 ; '`'
    sta PIA1_PortB_Addr_Hi
    lda l0070
    sta PIA1_PortA_Addr_Lo
    lda #&cf
    sta PIA2_PortB_Misc
    lda #&3c ; '<'
    sta PIA2_ControlB
    lda #&34 ; '4'
    sta PIA2_ControlB
    lda PIA2_PortA_Data
    sta l0084
    lda #&ff
    sta PIA2_PortB_Misc
    lda #&3c ; '<'
    sta PIA2_ControlB
    lda #&34 ; '4'
    sta PIA2_ControlB
    lda l0084
    jmp c84c6

.sub_c8515
    jsr print_string
    equs &1f, 1, &0a, "Press RETURN to save CURRENT BUFFER", &0d, &0d
    equs " Or ANY key to specify.", 0

    rts

.sub_c8559
    jsr sub_c8696
    ldx #0
    jsr c8742
    jsr sub_c86ef
    jsr osrdch                                                        ; Read a character from the current input stream
    cmp #&0d                                                          ; A=character read
    bne c8575
    lda #0
    sta l0070
    lda #&20 ; ' '
    sta l0071
    bne c85af
.c8575
    jsr print_string
    equs &1f, 6, &0f, "Enter Buffer Address :- ", 0

    jsr sub_c8bd1
    lda l0084
    asl a
    asl a
    asl a
    asl a
    clc
    adc l0085
    adc #&20 ; ' '
    sta l0071
    lda l0086
    asl a
    asl a
    asl a
    asl a
    clc
    adc l0087
    sta l0070
.c85af
    jsr osnewl                                                        ; Write newline (characters 10 and 13)
    jsr osnewl                                                        ; Write newline (characters 10 and 13)
    lda #&30 ; '0'
    sta PIA2_ControlA
    lda #&ff
    sta PIA2_PortA_Data
    lda #&34 ; '4'
    sta PIA2_ControlA
    ldx #<(l0700)
    ldy #>(l0700)
    lda #osfind_open_input
    jsr osfind                                                        ; Open file for input (A=64)
    sta l0082                                                         ; A=file handle (or zero on failure)
.c85cf
    ldy l0082                                                         ; Y=file handle
    jsr osbget                                                        ; Read a single byte from an open file Y
    sta l0084
    bcs c85f3
    lda l0071
    cmp #&60 ; '`'
    bcc c85e1
    jmp c860c

.c85e1
    lda l0084
    ldy #0
    sta (l0070),y
.c85e7
    inc l0070
    bne c85cf
    inc l0071
    lda l0071
    cmp #&a0
    bne c85cf
.c85f3
    lda #osfind_close
    ldy l0082
    jsr osfind                                                        ; Close one or all files
    lda #&30 ; '0'
    sta PIA2_ControlA
    lda #0
    sta PIA2_PortA_Data
    lda #&34 ; '4'
    sta PIA2_ControlA
    jmp c83e3

.c860c
    sec
    sbc #&60 ; '`'
    sta PIA1_PortB_Addr_Hi
    lda l0070
    sta PIA1_PortA_Addr_Lo
    lda l0084
    sta PIA2_PortA_Data
    lda #&9f
    sta PIA2_PortB_Misc
    lda #&3c ; '<'
    sta PIA2_ControlB
    lda #&34 ; '4'
    sta PIA2_ControlB
    lda #&ff
    sta PIA2_PortB_Misc
    lda #&3c ; '<'
    sta PIA2_ControlB
    lda #&34 ; '4'
    sta PIA2_ControlB
    jmp c85e7

.sub_c863d
    jsr print_string
    equs &0c, &0d, &84, &9d, &83, &8d, "      SAVE BUFFER TO FILE."
    equs &0d, &84, &9d, &83, &8d, "      SAVE BUFFER TO FILE.", &1f
    equs 5, 6, "Enter File Name:- ", 0

    rts

.sub_c8696
    jsr print_string
    equs &0c, &0d, &84, &9d, &83, &8d, "      LOAD FILE TO BUFFER."
    equs &0d, &84, &9d, &83, &8d, "      LOAD FILE TO BUFFER.", &1f
    equs 5, 6, "ENTER FILE NAME:- ", 0

    rts

.sub_c86ef
    jsr print_string
    equs &1f, 1, &0a, "Press RETURN to load to START OF BUFF.", &0d
    equs &0d, " Or ANY key for a specific Address.", 0

    rts

.c8742
    jsr osrdch                                                        ; Read a character from the current input stream
    cmp #&7f                                                          ; A=character read
    bne c8754
    cpx #0
    beq c8742
    dex
    jsr oswrch                                                        ; Write character
    jmp c8742

.c8754
    jsr oswrch                                                        ; Write character
    cmp #&1b
    beq c8767
    sta l0700,x
    cmp #&0d
    beq c8766
    inx
    jmp c8742

.c8766
    rts

.c8767
    jsr c8bcb
    jmp c80de

.sub_c876d
    lda #0
    sta l0078
    sta l0082
    lda l0503
    sta l0079
.c8778
    lda #&0c
    jsr oswrch                                                        ; Write character 12
    jsr osnewl                                                        ; Write newline (characters 10 and 13)
    ldx #&8c
    ldy #&91
    jsr sub_c80a4
    lda #osbyte_set_cursor_editing
    ldx #1
    jsr osbyte                                                        ; Disable cursor editing (edit keys give ASCII 135-139) (X=1)
    lda #0
    sta l0072
    sta l0073
    jsr sub_c879a
    jmp c88fc

.sub_c879a
    jsr Cursor_Off
    lda l0078
    sta l0070
    lda l0079
    sta l0071
    lda #&13
    sta l0075
    ldy #0
    lda #&1f
    jsr oswrch                                                        ; Write character 31
    tya
    jsr oswrch                                                        ; Write character
    lda #5
    jsr oswrch                                                        ; Write character 5
.c87b9
    lda #&86
    jsr oswrch                                                        ; Write character 134
    lda l0071
    sec
    sbc #&20 ; ' '
    jsr PrintHexA
    lda l0070
    jsr PrintHexA
    lda #&87
    jsr oswrch                                                        ; Write character 135
    lda l0070
    sta l0076
    lda l0071
    sta l0077
    cmp #&60 ; '`'
    bcc c87df
    jsr sub_c88b5
.c87df
    ldx #8
    ldy #0
.loop_c87e3
    lda (l0076),y
    jsr PrintHexA
    lda #&20 ; ' '
    jsr oswrch                                                        ; Write character 32
    inc l0076
    dex
    bne loop_c87e3
    lda #&20 ; ' '
    jsr oswrch                                                        ; Write character 32
    lda l0070
    sta l0076
    lda l0071
    sta l0077
    cmp #&60 ; '`'
    bcc c880b
    lda #&80
    sta l0076
    lda #5
    sta l0077
.c880b
    ldx #8
    ldy #0
.loop_c880f
    lda (l0076),y
    and #&7f
    cmp #&20 ; ' '
    bcc c881b
    cmp #&7f
    bcc c881d
.c881b
    lda #&2e ; '.'
.c881d
    jsr oswrch                                                        ; Write character 46
    inc l0076
    dex
    bne loop_c880f
    lda #&20 ; ' '
    jsr oswrch                                                        ; Write character 32
    lda l0070
    clc
    adc #8
    sta l0070
    lda l0071
    adc #0
    sta l0071
    dec l0075
    beq c883e
    jmp c87b9

.c883e
    jsr sub_c8b14
    jsr sub_c887d
    rts

.Cursor_Off
    lda #&17
    jsr oswrch                                                        ; Write character 23
    lda #1
    jsr oswrch                                                        ; Write character 1
    lda #0
    jsr oswrch                                                        ; Write character 0
    lda #0
    jsr oswrch                                                        ; Write character 0
    lda #0
    jsr oswrch                                                        ; Write character 0
    lda #0
    jsr oswrch                                                        ; Write character 0
    lda #0
    jsr oswrch                                                        ; Write character 0
    lda #0
    jsr oswrch                                                        ; Write character 0
    lda #0
    jsr oswrch                                                        ; Write character 0
    lda #0
    jsr oswrch                                                        ; Write character 0
    lda #0
    jsr oswrch                                                        ; Write character 0
    rts

.sub_c887d
    lda #&17
    jsr oswrch                                                        ; Write character 23
    lda #1
    jsr oswrch                                                        ; Write character 1
    lda #1
    jsr oswrch                                                        ; Write character 1
    lda #0
    jsr oswrch                                                        ; Write character 0
    lda #0
    jsr oswrch                                                        ; Write character 0
    lda #0
    jsr oswrch                                                        ; Write character 0
    lda #0
    jsr oswrch                                                        ; Write character 0
    lda #0
    jsr oswrch                                                        ; Write character 0
    lda #0
    jsr oswrch                                                        ; Write character 0
    lda #0
    jsr oswrch                                                        ; Write character 0
    lda #0
    jsr oswrch                                                        ; Write character 0
    rts

.sub_c88b5
    sec
    sbc #&60 ; '`'
    sta PIA1_PortB_Addr_Hi
    lda l0076
    sta PIA1_PortA_Addr_Lo
    lda #&cf
    sta PIA2_PortB_Misc
    lda #&3c ; '<'
    sta PIA2_ControlB
    lda #&34 ; '4'
    sta PIA2_ControlB
    ldx #0
.loop_c88d1
    lda PIA2_PortA_Data
    sta l0580,x
    inc PIA1_PortA_Addr_Lo
    bne c88df
    inc PIA1_PortB_Addr_Hi
.c88df
    inx
    cpx #8
    bne loop_c88d1
    lda #&ff
    sta PIA2_PortB_Misc
    lda #&3c ; '<'
    sta PIA2_ControlB
    lda #&34 ; '4'
    sta PIA2_ControlB
    lda #&80
    sta l0076
    lda #5
    sta l0077
    rts

.c88fc
    lda #osbyte_flush_buffer
    ldx #buffer_keyboard
    jsr osbyte                                                        ; Flush the keyboard buffer (X=0)
    jsr osrdch                                                        ; Read a character from the current input stream
    cmp #&8b                                                          ; A=character read
    bne c891b
    ldx #(255 - inkey_key_shift) EOR 128                              ; X=internal key number EOR 128
    lda #osbyte_scan_keyboard
    jsr osbyte                                                        ; Test for 'SHIFT' key pressed (X=128)
    cpx #0                                                            ; X has top bit set if 'SHIFT' pressed
    bpl c8918
    jmp c8ac9

.c8918
    jmp c8ae8

.c891b
    cmp #&8a
    bne c8930
    ldx #(255 - inkey_key_shift) EOR 128                              ; X=internal key number EOR 128
    lda #osbyte_scan_keyboard
    jsr osbyte                                                        ; Test for 'SHIFT' key pressed (X=128)
    cpx #0                                                            ; X has top bit set if 'SHIFT' pressed
    bpl c892d
    jmp c8a68

.c892d
    jmp c8a8d

.c8930
    cmp #&88
    bne c8937
    jmp c8b4c

.c8937
    cmp #&89
    bne c893e
    jmp c8b59

.c893e
    cmp #9
    bne c8945
    jmp c8b68

.c8945
    cmp #&87
    bne c894c
    jmp c8b71

.c894c
    cmp #3
    bne c8953
    jmp c8d45

.c8953
    cmp #&10
    bne c895a
    jmp c8c0b

.c895a
    cmp #&1b
    bne c8961
    jmp c8bcb

.c8961
    cmp #&20 ; ' '
    bcc c896c
    cmp #&7f
    bcs c896c
    jmp c896f

.c896c
    jmp c88fc

.c896f
    sta l0084
    lda l0082
    beq c899b
    lda l0084
    jsr oswrch                                                        ; Write character
    jsr sub_c89ef
    pha
    lda l0072
    sta l0084
    asl a
    clc
    adc l0084
    adc #6
    sta l0084
    lda l0073
    clc
    adc #5
    sta l0085
    jsr c8b36
    pla
    jsr PrintHexA
    jmp c8b59

.c899b
    lda l0084
    pha
    jsr sub_c81a1
    bcc c89a7
    pla
    jmp c88fc

.c89a7
    sta l0084
    pla
    jsr oswrch                                                        ; Write character
.loop_c89ad
    jsr osrdch                                                        ; Read a character from the current input stream
    sta l0086                                                         ; A=character read
    jsr sub_c81a1
    bcs loop_c89ad
    sta l0085
    lda l0086
    jsr oswrch                                                        ; Write character
    lda l0084
    asl a
    asl a
    asl a
    asl a
    clc
    adc l0085
    jsr sub_c89ef
    and #&7f
    cmp #&20 ; ' '
    bcc c89d4
    cmp #&7f
    bcc c89d6
.c89d4
    lda #&2e ; '.'
.c89d6
    pha
    lda l0072
    clc
    adc #&1f
    sta l0084
    lda l0073
    clc
    adc #5
    sta l0085
    jsr c8b36
    pla
    jsr oswrch                                                        ; Write character
    jmp c8b59

.sub_c89ef
    pha
    lda l0073
    asl a
    asl a
    asl a
    clc
    adc l0072
    clc
    adc l0078
    sta l0086
    lda l0079
    adc #0
    sta l0087
    cmp #&60 ; '`'
    bcc c8a0e
    pla
    sta l0085
    jsr sub_c8a14
    rts

.c8a0e
    ldy #0
    pla
    sta (l0086),y
    rts

.sub_c8a14
    lda l0087
    sec
    sbc #&60 ; '`'
    sta PIA1_PortB_Addr_Hi
    lda l0086
    sta PIA1_PortA_Addr_Lo
    lda #&30 ; '0'
    sta PIA2_ControlA
    lda #&ff
    sta PIA2_PortA_Data
    lda #&34 ; '4'
    sta PIA2_ControlA
    lda l0085
    sta PIA2_PortA_Data
    lda l0402_miscb_shadow
    and #&9f
    sta PIA2_PortB_Misc
    lda #&3c ; '<'
    sta PIA2_ControlB
    lda #&34 ; '4'
    sta PIA2_ControlB
    lda #&ff
    sta PIA2_PortB_Misc
    lda #&3c ; '<'
    sta PIA2_ControlB
    lda #&34 ; '4'
    sta PIA2_ControlB
    lda #&30 ; '0'
    sta PIA2_ControlA
    lda #0
    sta PIA2_PortA_Data
    lda #&34 ; '4'
    sta PIA2_ControlA
    lda l0085
    rts

.c8a68
    lda l0078
    clc
    adc #&80
    sta l0078
    lda l0079
    adc #0
    sta l0079
    cmp #&9f
    bcc c8a87
    lda l0078
    cmp #&68 ; 'h'
    bcc c8a87
    lda #&68 ; 'h'
    sta l0078
    lda #&9f
    sta l0079
.c8a87
    jsr sub_c879a
    jmp c88fc

.c8a8d
    lda #&0a
    jsr oswrch                                                        ; Write character 10
    inc l0073
    lda l0073
    cmp #&13
    bne c8ac3
    lda l0078
    clc
    adc #8
    sta l0078
    lda l0079
    adc #0
    sta l0079
    cmp #&9f
    bcc c8ab9
    lda l0078
    cmp #&68 ; 'h'
    bcc c8ab9
    lda #&68 ; 'h'
    sta l0078
    lda #&9f
    sta l0079
.c8ab9
    lda #&12
    sta l0073
    jsr sub_c879a
    jmp c88fc

.c8ac3
    jsr sub_c8b14
    jmp c88fc

.c8ac9
    lda l0078
    sec
    sbc #&80
    sta l0078
    lda l0079
    sbc #0
    cmp #&20 ; ' '
    bcs c8ae0
    lda #0
    sta l0078
    lda #&20 ; ' '
    sta l0079
.c8ae0
    sta l0079
    jsr sub_c879a
    jmp c88fc

.c8ae8
    lda #&0b
    jsr oswrch                                                        ; Write character 11
    dec l0073
    lda l0073
    bpl c8ac3
    lda l0078
    sec
    sbc #8
    sta l0078
    lda l0079
    sbc #0
    cmp #&20 ; ' '
    bcs c8b08
    lda #0
    sta l0078
    lda #&20 ; ' '
.c8b08
    sta l0079
    lda #0
    sta l0073
    jsr sub_c879a
    jmp c88fc

.sub_c8b14
    lda l0072
    sta l0084
    lda l0073
    clc
    adc #5
    sta l0085
    lda l0082
    bne c8b2f
    lda l0084
    asl a
    clc
    adc l0084
    adc #6
    sta l0084
    bpl c8b36
.c8b2f
    lda l0084
    clc
    adc #&1f
    sta l0084
.c8b36
    lda #&1f
    jsr oswrch                                                        ; Write character 31
    lda l0084
    jsr oswrch                                                        ; Write character
    lda l0085
    jsr oswrch                                                        ; Write character
    rts

.c8b46
    jsr sub_c8b14
    jmp c88fc

.c8b4c
    dec l0072
    lda l0072
    bpl c8b46
    lda #7
    sta l0072
    jmp c8ae8

.c8b59
    inc l0072
    lda l0072
    cmp #8
    bcc c8b46
    lda #0
    sta l0072
    jmp c8a8d

.c8b68
    lda l0082
    eor #&ff
    sta l0082
    jmp c8b46

.c8b71
    jsr print_string
    equs &0c, &1f, 5, &0c, "Enter HEX Address:- ", 0

    jsr sub_c8bd1
    cmp #&0d
    bne c8bb9
    lda l0084
    asl a
    asl a
    asl a
    asl a
    clc
    adc l0085
    sta l0079
    lda l0086
    asl a
    asl a
    asl a
    asl a
    clc
    adc l0087
    sta l0078
    lda l0079
    bmi c8bb9
    lda l0078
    clc
    adc #&98
    lda l0079
    adc #0
    bpl c8bc1
.c8bb9
    lda #&68 ; 'h'
    sta l0078
    lda #&7f
    sta l0079
.c8bc1
    lda l0079
    clc
    adc #&20 ; ' '
    sta l0079
    jmp c8778

.c8bcb
    lda #osbyte_acknowledge_escape
    jsr osbyte                                                        ; Clear escape condition and perform escape effects
    rts

.sub_c8bd1
    ldx #0
.c8bd3
    jsr osrdch                                                        ; Read a character from the current input stream
    cmp #&1b                                                          ; A=character read
    bne c8bdf
    jsr c8bcb
    sec
    rts

.c8bdf
    cmp #&0d
    bne c8be9
    cpx #4
    bne c8bd3
    clc
    rts

.c8be9
    cmp #&7f
    bne c8bf7
    cpx #0
    beq c8bd3
    jsr oswrch                                                        ; Write character
    dex
    bpl c8bd3
.c8bf7
    pha
    jsr sub_c81a1
    bcc c8c01
    pla
    jmp c8bd3

.c8c01
    sta l0084,x
    inx
    pla
    jsr oswrch                                                        ; Write character
    jmp c8bd3

.c8c0b
    jsr print_string
    equs &0c, &1f, 1, &0c, "Enter START address for print:- ", 0

    jsr sub_c8bd1
    bcc c8c3b
    jmp c8778

.c8c3b
    lda l0084
    asl a
    asl a
    asl a
    asl a
    clc
    adc l0085
    adc #&20 ; ' '
    sta l0071
    lda l0086
    asl a
    asl a
    asl a
    asl a
    clc
    adc l0087
    sta l0070
    jsr print_string
    equs &1f, 1, &0f, "Enter END address+1 for print:- ", 0

    jsr sub_c8bd1
    bcc c8c82
    jmp c8778

.c8c82
    lda l0084
    asl a
    asl a
    asl a
    asl a
    clc
    adc l0085
    adc #&20 ; ' '
    sta l0073
    lda l0086
    asl a
    asl a
    asl a
    asl a
    clc
    adc l0087
    sta l0072
    lda #&0c
    jsr oswrch                                                        ; Write character 12
    lda #2
    jsr oswrch                                                        ; Write character 2
    lda #1
    jsr oswrch                                                        ; Write character 1
    lda #&1b
    jsr oswrch                                                        ; Write character 27
    lda #1
    jsr oswrch                                                        ; Write character 1
    lda #&40 ; '@'
    jsr oswrch                                                        ; Write character 64
.c8cb8
    lda l0070
    sta l0076
    lda l0071
    sta l0077
    ldy #0
    lda l0077
    sec
    sbc #&20 ; ' '
    jsr PrintHexA
    lda l0076
    jsr PrintHexA
    lda #&20 ; ' '
    jsr oswrch                                                        ; Write character 32
    jsr oswrch                                                        ; Write character
    lda l0071
    cmp #&60 ; '`'
    bcc c8ce0
    jsr sub_c88b5
.c8ce0
    lda (l0076),y
    jsr PrintHexA
    lda #&20 ; ' '
    jsr oswrch                                                        ; Write character 32
    iny
    cpy #8
    bne c8ce0
    lda #&20 ; ' '
    jsr oswrch                                                        ; Write character 32
    ldy #0
.loop_c8cf6
    lda (l0076),y
    cmp #&20 ; ' '
    bcc c8d02
    cmp #&7f
    bcs c8d02
    bcc c8d04
.c8d02
    lda #&2e ; '.'
.c8d04
    jsr oswrch                                                        ; Write character 46
    iny
    cpy #8
    bne loop_c8cf6
    jsr osnewl                                                        ; Write newline (characters 10 and 13)
    lda l0070
    clc
    adc #8
    sta l0070
    bne c8d1a
    inc l0071
.c8d1a
    lda l0071
    cmp l0073
    bcc c8cb8
    lda l0070
    cmp l0072
    bcc c8cb8
    jsr osnewl                                                        ; Write newline (characters 10 and 13)
    lda #1
    jsr oswrch                                                        ; Write character 1
    lda #&1b
    jsr oswrch                                                        ; Write character 27
    lda #1
    jsr oswrch                                                        ; Write character 1
    lda #&40 ; '@'
    jsr oswrch                                                        ; Write character 64
    lda #3
    jsr oswrch                                                        ; Write character 3
    jmp c8778

.c8d45
    jsr print_string
    equs &0c, &1f, &0b, &0c, "CLEAR BUFFER Y/N? ", 0

    jsr osrdch                                                        ; Read a character from the current input stream
    cmp #&59 ; 'Y'                                                    ; A=character read
    bne c8d69
    jsr sub_c8d73
.c8d69
    cmp #&1b
    bne c8d70
    jsr c8bcb
.c8d70
    jmp c8778

.sub_c8d73
    ldy #0
    sty l0086
    lda #&20 ; ' '
    sta l0087
.c8d7b
    lda #&ff
    sta (l0086),y
    iny
    bne c8d7b
    inc l0087
    lda l0087
    cmp #&60 ; '`'
    bne c8d7b
    lda #0
    sta l0070
    sta l0071
    lda #&30 ; '0'
    sta PIA2_ControlA
    lda #&ff
    sta PIA2_PortA_Data
    lda #&34 ; '4'
    sta PIA2_ControlA
    lda #&ff
    sta PIA2_PortA_Data
.c8da4
    lda l0070
    sta PIA1_PortA_Addr_Lo
    lda l0071
    sta PIA1_PortB_Addr_Hi
    lda l0402_miscb_shadow
    and #&9f
    sta PIA2_PortB_Misc
    lda #&3c ; '<'
    sta PIA2_ControlB
    lda #&34 ; '4'
    sta PIA2_ControlB
    lda #&ff
    sta PIA2_PortB_Misc
    lda #&3c ; '<'
    sta PIA2_ControlB
    lda #&34 ; '4'
    sta PIA2_ControlB
    inc l0070
    bne c8da4
    inc l0071
    lda l0071
    cmp #&40 ; '@'
    bne c8da4
    lda #&30 ; '0'
    sta PIA2_ControlA
    lda #0
    sta PIA2_PortA_Data
    lda #&34 ; '4'
    sta PIA2_ControlA
    rts

.PrintHexA
    pha
    lsr a
    lsr a
    lsr a
    lsr a
    jsr sub_c8dfa
    pla
    and #&0f
    jsr sub_c8dfa
    rts

.sub_c8dfa
    cmp #&0a
    bcc c8e00
    adc #6
.c8e00
    adc #&30 ; '0'
    jsr oswrch                                                        ; Write character
    rts

.sub_c8e06
    lda #&aa
    sta PIA1_PortA_Addr_Lo
    lda #&55 ; 'U'
    sta PIA1_PortB_Addr_Hi
    lda PIA1_PortA_Addr_Lo
    cmp #&aa
    beq c8e62
    jsr print_string
    equs &0c, &1f, 4, &0b, &81, &88, &8d, "PROGRAMMER NOT CONNECTE"
    equs "D.", &1f, 4, &0c, &81, &88, &8d, "PROGRAMMER NOT CONNECT"
    equs "ED.", 0

    jsr jmp_Press_Any_Key_To_Return
    pla
    pla
    jmp c80de

.c8e62
    rts

    equb &0d
    equs "  EPROM"
    equb &0d,   0, &16,   7, &0d, &84, &9d, &83, &8d
    equs "27128 (16K)     VPP=21V      FAST"
    equb &0d, &84, &9d, &83, &8d
    equs "27128 (16K)     VPP=21V      FAST"
    equb &0d, &0d,   0, &0d, &83
    equs "1.)"
    equb &86
    equs "COPY ROM TO BUFFER."
    equb &0d, &0d, &83
    equs "2.)"
    equb &86
    equs "BLANK CHECK ROM."
    equb &0d, &0d, &83
    equs "3.)"
    equb &86
    equs "PROGRAM EPROM FROM BUFFER."
    equb &0d, &0d, &83
    equs "4.)"
    equb &86
    equs "VERIFY EPROM AGAINST BUFFER."
    equb &0d, &0d, &83
    equs "5.)"
    equb &86
    equs "LIST / EDIT BUFFER."
    equb &0d, &0d, &83
    equs "6.)"
    equb &86
    equs "SAVE BUFFER TO FILE."
    equb &0d, &0d, &83
    equs "7.)"
    equb &86
    equs "LOAD FILE TO BUFFER."
    equb &0d, &0d, &83
    equs "8.)"
    equb &86
    equs "CREATE BBC. ROM IMAGE."
    equb &0d, &0d, &83
    equs "9.)"
    equb &86
    equs "RETURN TO BASIC."
    equb &0d, &0d
    equs " Enter choice:-"
    equb   0, &16,   7, &0d, &84, &9d, &83, &8d
    equs "  MICRON PLUS EPROM PROGRAMMER."
    equb &0d, &84, &9d, &83, &8d
    equs "  MICRON PLUS EPROM PROGRAMMER."
    equb &0d, &84, &9d, &83
    equs "  (C) H.C.R. ELECTRONIC SERVICES."
    equb &0d, &0d, &83
    equs "SELECT EPROM TYPE FROM THE FOLLOWING:-"
    equb &0d, &0d, &0d, &83
    equs "0.)"
    equb &86
    equs "27513 (64K)    12.5V"
    equb &0d, &83
    equs "1.)"
    equb &86
    equs "27512 (64K)    12.5V"
    equb &0d, &83
    equs "2.)"
    equb &86
    equs "27256 (32K)    12.5V"
    equb &0d, &83
    equs "3.)"
    equb &86
    equs "27128 (16K)      21V"
    equb &0d, &83
    equs "4.)"
    equb &86
    equs "2764 (8K)        21V"
    equb &0d, &83
    equs "5.)"
    equb &86
    equs "2732 (4K)        25V"
    equb &0d, &83
    equs "6.)"
    equb &86
    equs "2716 (2K)        25V"
    equb &0d, &83
    equs "7.)"
    equb &86
    equs "2564 (8K)        25V"
    equb &0d, &83
    equs "8.)"
    equb &86
    equs "2532 (4K)        25V"
    equb &0d, &83
    equs "9.)"
    equb &86
    equs "27011 (128K)   12.5V"
    equb &0d, &0d, &0d
    equs " Enter choice:- "
    equb   0, &1f, &0c, &17
    equs "Press any key."
    equb   0, &1f,   7,   1, &8d, &84, &9d, &83
    equs "LIST / EDIT MEMORY  "
    equb &9c, &0d, &1f,   7,   2, &8d, &84, &9d, &83
    equs "LIST / EDIT MEMORY  "
    equb &9c,   0
.l91c6
    equs "EPROM"

.Set_Device_Variables
    ldy #0
.loop_c91cd
    lda l91da,x
    sta l0500,y
    inx
    iny
    cpy #&10
    bne loop_c91cd
    rts

.l91da
    equb &40, &c4,   1, &20, &60, &fb, &c0, &fb, &ff, &c0, &ff,   4, &7f,   0,   0,   0
    equb &40, &c4,   1, &20, &a0, &fb,   0, &fb, &ff, &c0,   1,   1, &7f,   1,   1,   1
    equb &40, &e5,   1, &20, &a0, &fb,   0, &fb, &ff, &c0, &ff,   4, &7f,   2,   2,   2
    equb &40, &e3,   1, &20, &60, &fb, &c0, &ff, &bf,   3, &fb,   0, &7f,   3,   3,   3
    equb &20, &e3,   1, &20, &40, &fb, &c0, &fb, &bf,   4, &fb,   0, &7f,   4,   4,   4
    equb &10, &f1,   0, &20, &30,   5,   5,   5,   5,   5,   5,   5,   5,   5,   5,   5
    equb   8, &f1,   0, &20, &28,   6,   6,   6,   6,   6,   6,   6,   6,   6,   6,   6
    equb &20, &f1,   0, &20, &40,   7,   7,   7,   7,   7,   7,   7,   7,   7,   7,   7
    equb &10, &f1,   0, &20, &30,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   7
    equb &40, &e4,   1, &20, &60, &fb, &c0, &ff, &bf,   3, &fb,   0, &7f,   0,   0,   0

.Reset_Hardware
    lda #0
    sta PIA1_ControlA
    sta PIA1_ControlB
    sta PIA2_ControlA
    sta PIA2_ControlB
    sta PIA2_PortA_Data
    lda #&ff
    sta PIA1_PortA_Addr_Lo
    sta PIA1_PortB_Addr_Hi
    sta PIA2_PortB_Misc
    lda #&3c ; '<'
    sta PIA1_ControlA
    sta PIA1_ControlB
    lda #&34 ; '4'
    sta PIA2_ControlA
    sta PIA2_ControlB
    lda #&ff
    jsr Set_MiscB
    lda #&f9
    jsr Set_MiscA
    lda #&34 ; '4'
    sta PIA1_ControlB
    rts

.Copy_ROM
    jsr jmp_Summary_Screen
    jsr Enter_ROM_Page_If_Needed
    jsr Enter_Address_Space_If_Needed
    lda l0400_device_type
    cmp #5
    bcc c92cd
    cmp #9
    beq c92cd
    jmp c9543

.c92cd
    jsr jmp_print_string
    equs &1f, 3, 6, &83, "COPY CONTENTS OF ROM TO MEMORY", &1f, &0f
    equs &0c, "GO? Y/N", 0

    jsr Get_Y_Or_N
    bcc c9303
    rts

.c9303
    jsr jmp_print_string
    equs &1f, &0e, &0c, "PLEASE WAIT", 0

    lda l0402_miscb_shadow
    and l050c
    jsr Set_MiscB
    lda l0402_miscb_shadow
    and l0505
    jsr Set_MiscB
    lda l0071
    ora l0506
    sta PIA1_PortB_Addr_Hi
    lda #&34 ; '4'
    sta PIA1_ControlA
    lda #&f8
    jsr Set_MiscA
    lda #0
    sta l0070
    sta l0071
    sta l0072
    sta l008a
    sta l0081
    sta l0080
    lda l0503
    sta l0073
    jsr Set_ROM_Page_If_Needed
    ldy #0
.c9351
    lda l0071
    ora l0506
    sta PIA1_PortB_Addr_Hi
    lda l0070
    sta PIA1_PortA_Addr_Lo
    lda l0402_miscb_shadow
    and #&fd
    jsr Set_MiscB
    lda PIA2_PortA_Data
    sta (l0072),y
    sta l0082
    lda l0402_miscb_shadow
    ora #2
    jsr Set_MiscB
    lda l0082
    clc
    adc l0080
    sta l0080
    lda #0
    adc l0081
    sta l0081
    lda #0
    adc l008a
    sta l008a
    inc l0070
    inc l0072
    bne c9351
    inc l0071
    inc l0073
    lda l0071
    cmp l0500
    bne c9351
    jsr Reset_Hardware
    lda l0400_device_type
    cmp #2
    beq c93a7
    cmp #1
    bne c93aa
.c93a7
    jsr sub_c93e9
.c93aa
    jsr jmp_print_string
    equs &1f, 9, &0c, "ROM COPIED TO MEMORY", &1f, &0c, &10, "CHEC"
    equs "KSUM = ", 0

    lda l008a
    jsr jmp_PrintHexA
    lda l0081
    jsr jmp_PrintHexA
    lda l0080
    jsr jmp_PrintHexA
    jsr osnewl                                                        ; Write newline (characters 10 and 13)
    jsr Press_Any_Key_To_Return
    rts

.sub_c93e9
    lda l0402_miscb_shadow
    and l050c
    jsr Set_MiscB
    lda l0402_miscb_shadow
    and l0505
    jsr Set_MiscB
    lda l0071
    ora l0509
    sta PIA1_PortB_Addr_Hi
    lda #&34 ; '4'
    sta PIA1_ControlA
    lda #&f8
    jsr Set_MiscA
    lda #0
    sta l0070
    sta l0071
    ldy #0
.c9415
    lda l0071
    ora l0509
    sta PIA1_PortB_Addr_Hi
    lda l0070
    sta PIA1_PortA_Addr_Lo
    lda l0402_miscb_shadow
    and #&fd
    jsr Set_MiscB
    lda l0402_miscb_shadow
    and #&9f
    jsr Set_MiscB
    lda PIA2_PortA_Data
    sta l0082
    lda l0402_miscb_shadow
    ora #&60 ; '`'
    jsr Set_MiscB
    lda l0402_miscb_shadow
    ora #2
    jsr Set_MiscB
    lda l0082
    clc
    adc l0080
    sta l0080
    lda #0
    adc l0081
    sta l0081
    lda #0
    adc l008a
    sta l008a
    inc l0070
    bne c9415
    inc l0071
    lda l0071
    cmp l0500
    bne c9415
    jsr Reset_Hardware
    rts

.Set_ROM_Page
    lda #&3c ; '<'
    sta PIA1_PortA_Addr_Lo
    lda #&30 ; '0'
    sta PIA2_ControlA
    lda #&ff
    sta PIA2_PortA_Data
    lda #&34 ; '4'
    sta PIA2_ControlA
    lda l0402_miscb_shadow
    and #&fe
    jsr Set_MiscB
    lda l0403
    sta PIA2_PortA_Data
    lda #&34 ; '4'
    sta PIA1_PortA_Addr_Lo
    lda l0071
    and #&bf
    sta PIA1_PortB_Addr_Hi
    lda l0071
    ora #&c0
    sta PIA1_PortB_Addr_Hi
    lda #&3c ; '<'
    sta PIA1_PortA_Addr_Lo
    lda l0402_miscb_shadow
    ora #1
    jsr Set_MiscB
    lda #&30 ; '0'
    sta PIA2_ControlA
    lda #0
    sta PIA2_PortA_Data
    lda #&34 ; '4'
    sta PIA2_ControlA
    lda #&34 ; '4'
    sta PIA1_PortA_Addr_Lo
    rts

.Enter_ROM_Page_If_Needed
    lda l0400_device_type
    bne c94ea
    jsr jmp_print_string
    equs &1f, 8, 6, "ENTER ROM PAGE No. (0-3) ", 0

    jmp c950e

.c94ea
    cmp #9
    bne c9531
    jsr jmp_print_string
    equs &1f, 8, 6, "ENTER ROM PAGE No. (0-7) ", 0

.c950e
    jsr Get_Rom_Page
    jsr jmp_Summary_Screen
    jsr jmp_print_string
    equs &1f, &0c, 9, "ROM PAGE No. ", 0

    lda l0403
    ora #&30 ; '0'
    jsr oswrch                                                        ; Write character
    rts

.c9531
    rts

.Set_ROM_Page_If_Needed
    lda l0400_device_type
    bne c953b
    jsr Set_ROM_Page
    rts

.c953b
    cmp #9
    bne c9542
    jsr Set_ROM_Page
.c9542
    rts

.c9543
    jsr jmp_Summary_Screen
    jsr jmp_print_string
    equs &1f, 3, 6, &83, "COPY CONTENTS OF ROM TO MEMORY", &1f, &0f
    equs &0c, "GO? Y/N", 0

    jsr Get_Y_Or_N
    bcc c957c
    rts

.c957c
    jsr jmp_print_string
    equs &1f, &0e, &0c, "PLEASE WAIT", 0

    lda #0
    sta l0075
    jsr Handle_24Pin_Device
    jsr c93aa
    rts

.Blank_Check_ROM
    jsr jmp_Summary_Screen
    jsr Enter_ROM_Page_If_Needed
    jsr Enter_Address_Space_If_Needed
    lda l0400_device_type
    cmp #5
    bcc Blank_Check_28pin
    cmp #9
    beq Blank_Check_28pin
    jmp Blank_Check_24pin

.Blank_Check_28pin
    jsr jmp_print_string
    equs &1f, &0a, 6, &83, "BLANK CHECK EPROM", &1f, &0e, &0c, "PL"
    equs "EASE WAIT", 0

    lda l0402_miscb_shadow
    and l050c
    jsr Set_MiscB
    lda l0402_miscb_shadow
    and l0505
    jsr Set_MiscB
    lda l0071
    ora #&c0
    sta PIA1_PortB_Addr_Hi
    lda #&34 ; '4'
    sta PIA1_ControlA
    lda #&f8
    jsr Set_MiscA
    lda #0
    sta l0070
    sta l0071
    sta l0072
    sta l0081
    sta l0080
    lda l0503
    sta l0073
    jsr Set_ROM_Page_If_Needed
    ldy #0
.c9610
    lda l0071
    ora l0506
    sta PIA1_PortB_Addr_Hi
    lda l0070
    sta PIA1_PortA_Addr_Lo
    lda l0402_miscb_shadow
    and #&fd
    jsr Set_MiscB
    lda PIA2_PortA_Data
    cmp #&ff
    beq c962f
    jmp jmp_Failed

.c962f
    lda l0402_miscb_shadow
    ora #2
    jsr Set_MiscB
    inc l0070
    inc l0072
    bne c9610
    inc l0071
    inc l0073
    lda l0071
    cmp l0500
    bne c9610
    jsr Reset_Hardware
    lda l0400_device_type
    cmp #2
    beq c9656
    cmp #1
    bne c9659
.c9656
    jsr Blank_Check_28pin_More
.c9659
    jsr jmp_print_string
    equs &1f, 8, &0c, "BLANK CHECK SUCCESSFUL", 0

    jsr Press_Any_Key_To_Return
    rts

.Blank_Check_28pin_More
    lda l0402_miscb_shadow
    and l050c
    jsr Set_MiscB
    lda l0402_miscb_shadow
    and l0505
    jsr Set_MiscB
    lda l0071
    ora l0509
    sta PIA1_PortB_Addr_Hi
    lda #&34 ; '4'
    sta PIA1_ControlA
    lda #&f8
    jsr Set_MiscA
    lda #0
    sta l0070
    sta l0071
    ldy #0
.c96a6
    lda l0071
    ora l0509
    sta PIA1_PortB_Addr_Hi
    lda l0070
    sta PIA1_PortA_Addr_Lo
    lda l0402_miscb_shadow
    and #&fd
    jsr Set_MiscB
    lda PIA2_PortA_Data
    cmp #&ff
    beq c96cc
    lda l0071
    clc
    adc #&40 ; '@'
    sta l0071
    jmp jmp_Failed

.c96cc
    lda l0402_miscb_shadow
    ora #2
    jsr Set_MiscB
    inc l0070
    bne c96a6
    inc l0071
    lda l0071
    cmp l0500
    bne c96a6
    jsr Reset_Hardware
    rts

.Get_Rom_Page
    jsr osrdch                                                        ; Read a character from the current input stream
    cmp #&1b                                                          ; A=character read
    bne c96f9
    lda #osbyte_acknowledge_escape
    jsr osbyte                                                        ; Clear escape condition and perform escape effects
    lda #7
    jsr oswrch                                                        ; Write character 7
    jmp Get_Rom_Page

.c96f9
    pha
    lda l0400_device_type
    bne c970b
    pla
    cmp #&30 ; '0'
    bcc Get_Rom_Page
    cmp #&34 ; '4'
    bcs Get_Rom_Page
    jmp c9714

.c970b
    pla
    cmp #&30 ; '0'
    bcc Get_Rom_Page
    cmp #&38 ; '8'
    bcs Get_Rom_Page
.c9714
    sec
    sbc #&30 ; '0'
    sta l0403
    rts

.Blank_Check_24pin
    jsr jmp_Summary_Screen
    jsr jmp_print_string
    equs &1f, &0a, 6, &83, "BLANK CHECK EPROM", &1f, &0e, &0c, "PL"
    equs "EASE WAIT", 0

    lda #1
    sta l0075
    jsr Handle_24Pin_Device
    jsr c9659
    rts

.Verify_ROM
    jsr jmp_Summary_Screen
    jsr Enter_ROM_Page_If_Needed
.Verify_ROM_Inner
    jsr Enter_Address_Space_If_Needed
    lda l0400_device_type
    cmp #5
    bcc Verify_ROM_Inner_28pin
    cmp #9
    beq Verify_ROM_Inner_28pin
    jmp Verify_ROM_Inner_24pin

.Verify_ROM_Inner_28pin
    jsr jmp_print_string
    equs &1f, 1, 6, &83, "VERIFY CONTENT OF EPROM AGAINST MEMORY", &1f
    equs &0e, &0c, "PLEASE WAIT", 0

    lda l0402_miscb_shadow
    and l050c
    jsr Set_MiscB
    lda l0402_miscb_shadow
    and l0505
    jsr Set_MiscB
    lda l0071
    ora l0506
    sta PIA1_PortB_Addr_Hi
    lda #&34 ; '4'
    sta PIA1_ControlA
    lda #&f8
    jsr Set_MiscA
    lda #0
    sta l0070
    sta l0071
    sta l0072
    sta l0081
    sta l0080
    sta l008a
    lda l0503
    sta l0073
    jsr Set_ROM_Page_If_Needed
    ldy #0
.c97df
    lda l0071
    ora l0506
    sta PIA1_PortB_Addr_Hi
    lda l0070
    sta PIA1_PortA_Addr_Lo
    lda l0402_miscb_shadow
    and #&fd
    jsr Set_MiscB
    lda PIA2_PortA_Data
    cmp (l0072),y
    sta l0082
    beq c9800
    jmp jmp_Failed

.c9800
    lda l0402_miscb_shadow
    ora #2
    jsr Set_MiscB
    lda l0082
    clc
    adc l0080
    sta l0080
    lda #0
    adc l0081
    sta l0081
    lda #0
    adc l008a
    sta l008a
    inc l0070
    inc l0072
    bne c97df
    inc l0071
    inc l0073
    lda l0071
    cmp l0500
    bne c97df
    jsr Reset_Hardware
    lda l0400_device_type
    cmp #2
    beq c983d
    cmp #1
    beq c983d
    jmp c98d9

.c983d
    lda l0402_miscb_shadow
    and l050c
    jsr Set_MiscB
    lda l0402_miscb_shadow
    and l0505
    jsr Set_MiscB
    lda l0071
    ora l0509
    sta PIA1_PortB_Addr_Hi
    lda #&34 ; '4'
    sta PIA1_ControlA
    lda #&f8
    jsr Set_MiscA
    lda #0
    sta l0070
    sta l0071
    ldy #0
.c9869
    lda l0071
    ora l0509
    sta PIA1_PortB_Addr_Hi
    lda l0070
    sta PIA1_PortA_Addr_Lo
    lda l0402_miscb_shadow
    and #&fd
    jsr Set_MiscB
    lda PIA2_PortA_Data
    sta l0082
    lda l0402_miscb_shadow
    ora #2
    jsr Set_MiscB
    lda #&3c ; '<'
    sta PIA1_ControlA
    lda l0402_miscb_shadow
    and #&cf
    jsr Set_MiscB
    lda PIA2_PortA_Data
    cmp l0082
    beq c98a9
    lda l0071
    clc
    adc #&40 ; '@'
    sta l0071
    jmp jmp_Failed

.c98a9
    lda l0402_miscb_shadow
    ora #&30 ; '0'
    jsr Set_MiscB
    lda #&34 ; '4'
    sta PIA1_ControlA
    lda l0082
    clc
    adc l0080
    sta l0080
    lda #0
    adc l0081
    sta l0081
    lda #0
    adc l008a
    sta l008a
    inc l0070
    bne c9869
    inc l0071
    lda l0071
    cmp l0500
    bne c9869
    jsr Reset_Hardware
.c98d9
    jsr jmp_print_string
    equs &1f, 8, &0c, "VERIFICATION SUCCESSFUL", &1f, &0c, &10, "C"
    equs "HECKSUM = ", 0

    lda l008a
    jsr jmp_PrintHexA
    lda l0081
    jsr jmp_PrintHexA
    lda l0080
    jsr jmp_PrintHexA
    jsr osnewl                                                        ; Write newline (characters 10 and 13)
    jsr Press_Any_Key_To_Return
    rts

.Set_MiscB
    sta PIA2_PortB_Misc
    sta l0402_miscb_shadow
    lda #&3c ; '<'
    sta PIA2_ControlB
    lda #&34 ; '4'
    sta PIA2_ControlB
    rts

.Set_MiscA
    sta PIA2_PortB_Misc
    sta l0401_misca_shadow
    lda #&3c ; '<'
    sta PIA2_ControlA
    lda #&34 ; '4'
    sta PIA2_ControlA
    rts

.Get_Y_Or_N
    jsr osrdch                                                        ; Read a character from the current input stream
    cmp #&59 ; 'Y'                                                    ; A=character read
    beq c9946
    sec
    rts

.c9946
    clc
    rts

.Press_Any_Key_To_Return
    jsr jmp_print_string
    equs &1f, 2, &17, "Press any key to return to main menu.", 0

    jsr osrdch                                                        ; Read a character from the current input stream
    rts

.Enter_Address_Space_If_Needed
    lda l0400_device_type
    cmp #1
    beq c9980
    rts

.c9980
    jsr jmp_print_string
    equs &1f, 7, &0c, &86, "ENTER ROM ADDRESS SPACE", &1f, 3, &0e, &86
    equs "(L)----ADDRESS LO. (0 TO &7FFF).", &1f, 3, &10, &86, "(U"
    equs ")----ADDRESS HI. (&8000 TO &FFFF).", &1f, 4, &12, "Enter"
    equs " choice:-", 0

.c99fc
    jsr osrdch                                                        ; Read a character from the current input stream
    sta l0403                                                         ; A=character read
    cmp #&1b
    bne c9a0e
    lda #osbyte_acknowledge_escape
    jsr osbyte                                                        ; Clear escape condition and perform escape effects
    jmp c99fc

.c9a0e
    cmp #&4c ; 'L'
    bne c9a1a
    lda #&ff
    sta l050c
    jmp c9a23

.c9a1a
    cmp #&55 ; 'U'
    bne c99fc
    lda #&7f
    sta l050c
.c9a23
    jsr jmp_Summary_Screen
    lda l0403
    cmp #&4c ; 'L'
    bne c9a4c
    jsr jmp_print_string
    equs &1f, 9, 8, &86, "LOWER Address space.", 0

    jmp c9a68

.c9a4c
    jsr jmp_print_string
    equs &1f, 9, 8, &86, "UPPER Address space.", 0

.c9a68
    rts

.Verify_ROM_Inner_24pin
    jsr jmp_Summary_Screen
    jsr jmp_print_string
    equs &1f, 1, 6, &83, "VERIFY CONTENT OF EPROM AGAINST MEMORY", &1f
    equs &0e, &0c, "PLEASE WAIT", 0

    lda #2
    sta l0075
    jsr Handle_24Pin_Device
    jsr c98d9
    rts

.Handle_24Pin_Device
    lda #&7b ; '{'
    jsr Set_MiscB
    lda #&b9
    jsr Set_MiscA
    lda l0400_device_type
    cmp #5
    beq c9ad9
    cmp #6
    beq c9ad4
    cmp #7
    bne c9ad4
    lda #&73 ; 's'
    jsr Set_MiscB
    jmp c9ad9

.c9ad4
    lda #&39 ; '9'
    jsr Set_MiscA
.c9ad9
    ldx #0
    ldy #0
    lda #&0a
    sta l0070
.c9ae1
    dex
    bne c9ae1
    dey
    bne c9ae1
    dec l0070
    bne c9ae1
    lda l0401_misca_shadow
    and #&fe
    jsr Set_MiscA
    lda #&34 ; '4'
    sta PIA1_ControlA
    lda #0
    sta l0070
    sta l0071
    sta l0072
    sta l008a
    sta l0081
    sta l0080
    lda l0503
    sta l0073
    ldy #0
.c9b0d
    lda l0071
    sta PIA1_PortB_Addr_Hi
    lda l0400_device_type
    cmp #5
    beq c9b32
    lda l0071
    and #8
    beq c9b2a
    lda l0402_miscb_shadow
    ora #4
    jsr Set_MiscB
    clc
    bcc c9b32
.c9b2a
    lda l0402_miscb_shadow
    and #&fb
    jsr Set_MiscB
.c9b32
    lda l0070
    sta PIA1_PortA_Addr_Lo
    lda l0402_miscb_shadow
    and #&fd
    jsr Set_MiscB
    lda PIA2_PortA_Data
    sta l0082
    lda l0402_miscb_shadow
    ora #2
    jsr Set_MiscB
    lda l0082
    clc
    adc l0080
    sta l0080
    lda #0
    adc l0081
    sta l0081
    lda #0
    adc l008a
    sta l008a
    lda l0075
    bne c9b6a
    lda l0082
    sta (l0072),y
    clc
    bcc c9b94
.c9b6a
    cmp #1
    bne c9b81
    lda l0082
    cmp #&ff
    beq c9b94
    lda l0401_misca_shadow
    ora #1
    jsr Set_MiscA
    pla
    pla
    jmp jmp_Failed

.c9b81
    lda l0082
    cmp (l0072),y
    beq c9b94
    lda l0401_misca_shadow
    ora #1
    jsr Set_MiscA
    pla
    pla
    jmp jmp_Failed

.c9b94
    inc l0070
    inc l0072
    beq c9b9d
    jmp c9b0d

.c9b9d
    inc l0071
    inc l0073
    lda l0071
    cmp l0500
    beq c9bab
    jmp c9b0d

.c9bab
    lda l0401_misca_shadow
    ora #1
    jsr Set_MiscA
    jsr Reset_Hardware
    rts

.Program_ROM
    jsr jmp_Summary_Screen
    lda l0400_device_type
    bne c9bc2
    jmp Program_ROM_27513_27011

.c9bc2
    cmp #1
    bne c9bc9
    jmp Program_ROM_27512

.c9bc9
    cmp #2
    bne c9bd0
    jmp Program_ROM_27256_27128_2764

.c9bd0
    cmp #3
    bne c9bd7
    jmp Program_ROM_27256_27128_2764

.c9bd7
    cmp #4
    bne c9bde
    jmp Program_ROM_27256_27128_2764

.c9bde
    cmp #9
    bne c9be5
    jmp Program_ROM_27513_27011

.c9be5
    jmp Program_ROM_2732_2716_2564_2532

.Program_ROM_27256_27128_2764
    jsr jmp_print_string
    equs &1f, 7, 6, "PROGRAM EPROM FROM MEMORY", &1f, &0f, &0c, "G"
    equs "O? Y/N", 0

    jsr jmp_Get_Y_Or_N
    bcc c9c18
    rts

.c9c18
    jsr jmp_print_string
    equs &1f, 4, &0c, "PROGRAMMING ROM LOCATION ", 0

    jsr jmp_Reset_Hardware
    lda #&30 ; '0'
    sta PIA2_ControlA
    lda #&ff
    sta PIA2_PortA_Data
    lda #&34 ; '4'
    sta PIA2_ControlA
    lda l0402_miscb_shadow
    and l050a
    jsr jmp_Set_MiscB
    lda l0402_miscb_shadow
    and #&7e ; '~'
    jsr jmp_Set_MiscB
    lda l0501
    jsr jmp_Set_MiscA
    lda l0071
    ora l0506
    sta PIA1_PortB_Addr_Hi
    lda l0401_misca_shadow
    and #&fe
    jsr jmp_Set_MiscA
    lda #0
    sta l0070
    sta l0071
    sta l0072
    lda l0503
    sta l0073
    ldy #0
    lda #1
    sei
    lda #0
    sta user_via_acr
    lda #&7f
    sta user_via_ier
    sta user_via_ifr
    lda #&a0
    sta user_via_ier
.c9c95
    jsr PrintHexAddress
    jsr jmp_print_string
    equs 8, 8, 8, 8, 0

    lda #0
    sta l0075
    lda #1
    sta l0078
    sta l0079
    lda #&e8
    sta l0077
    lda #3
    sta l0076
    lda l0071
    ora l0506
    sta PIA1_PortB_Addr_Hi
    lda l0070
    sta PIA1_PortA_Addr_Lo
.c9cbf
    lda (l0072),y
    cmp #&ff
    bne c9cc8
    jmp c9d8f

.c9cc8
    sta PIA2_PortA_Data
    lda #&34 ; '4'
    sta PIA1_ControlA
    lda l0071
    and l0508
    sta PIA1_PortB_Addr_Hi
    lda l0402_miscb_shadow
    and l0507
    jsr jmp_Set_MiscB
    jsr Calculate_Pulse_WidthA
    lda l0077
    sta user_via_t2c_l
    lda l0076
    sta user_via_t2c_h
.loop_c9cee
    bit user_via_ifr
    bpl loop_c9cee
    lda l0071
    ora l0506
    sta PIA1_PortB_Addr_Hi
    lda l0402_miscb_shadow
    ora l050b
    jsr jmp_Set_MiscB
    lda #&3c ; '<'
    sta PIA1_ControlA
    lda #&30 ; '0'
    sta PIA2_ControlA
    lda #0
    sta PIA2_PortA_Data
    lda #&34 ; '4'
    sta PIA2_ControlA
    lda l0402_miscb_shadow
    ora #1
    jsr jmp_Set_MiscB
    lda #&34 ; '4'
    sta PIA1_ControlA
    lda l0402_miscb_shadow
    and #&fd
    jsr jmp_Set_MiscB
    lda l0400_device_type
    cmp #2
    bne c9d3c
    lda l0402_miscb_shadow
    and #&fb
    jsr jmp_Set_MiscB
.c9d3c
    lda PIA2_PortA_Data
    pha
    lda l0400_device_type
    cmp #2
    bne c9d4f
    lda l0402_miscb_shadow
    ora #4
    jsr jmp_Set_MiscB
.c9d4f
    lda l0402_miscb_shadow
    ora #2
    jsr jmp_Set_MiscB
    lda #&3c ; '<'
    sta PIA1_ControlA
    lda #&30 ; '0'
    sta PIA2_ControlA
    lda #&ff
    sta PIA2_PortA_Data
    lda #&34 ; '4'
    sta PIA2_ControlA
    lda l0402_miscb_shadow
    and #&fe
    jsr jmp_Set_MiscB
    lda l0079
    cmp #4
    bcc c9d7d
    lda #1
    sta l0075
.c9d7d
    pla
    cmp (l0072),y
    bne c9db5
.c9d82
    lda l0078
    asl a
    asl a
    sta l0079
    lda l0075
    bne c9d8f
    jmp c9cbf

.c9d8f
    inc l0070
    inc l0072
    beq c9d98
    jmp c9c95

.c9d98
    inc l0071
    inc l0073
    lda l0071
    cmp l0500
    beq c9da6
    jmp c9c95

.c9da6
    jsr jmp_Reset_Hardware
    lda #&7f
    sta user_via_ier
    sta user_via_ifr
    cli
    jmp c9dc7

.c9db5
    lda l0075
    beq c9dbc
    jmp Failed

.c9dbc
    lda l0078
    cmp #&0f
    beq c9d82
    inc l0078
    jmp c9cbf

.c9dc7
    lda l0400_device_type
    cmp #2
    beq c9dd1
    jmp c9f09

.c9dd1
    lda l0402_miscb_shadow
    and #&7e ; '~'
    jsr jmp_Set_MiscB
    lda l0501
    jsr jmp_Set_MiscA
    lda l0071
    ora #&c0
    sta PIA1_PortB_Addr_Hi
    lda l0401_misca_shadow
    and #&fe
    jsr jmp_Set_MiscA
    lda #0
    sta l0070
    sta l0071
    sei
    lda #0
    sta user_via_acr
    lda #&7f
    sta user_via_ier
    sta user_via_ifr
    lda #&a0
    sta user_via_ier
.c9e07
    lda l0071
    clc
    adc #&40 ; '@'
    jsr jmp_PrintHexA
    lda l0070
    jsr jmp_PrintHexA
    jsr jmp_print_string
    equs 8, 8, 8, 8, 0

    lda #0
    sta l0075
    lda #1
    sta l0078
    sta l0079
    lda #&e8
    sta l0077
    lda #3
    sta l0076
    lda l0071
    ora #&c0
    sta PIA1_PortB_Addr_Hi
    lda l0070
    sta PIA1_PortA_Addr_Lo
.c9e3a
    lda l0402_miscb_shadow
    and #&cf
    jsr jmp_Set_MiscB
    lda PIA2_PortA_Data
    sta l0082
    cmp #&ff
    bne c9e4e
    jmp c9eea

.c9e4e
    lda #&34 ; '4'
    sta PIA1_ControlA
    lda l0402_miscb_shadow
    and #&fb
    jsr jmp_Set_MiscB
    jsr Calculate_Pulse_WidthA
    lda l0077
    sta user_via_t2c_l
    lda l0076
    sta user_via_t2c_h
.loop_c9e68
    bit user_via_ifr
    bpl loop_c9e68
    lda l0402_miscb_shadow
    ora #4
    jsr jmp_Set_MiscB
    lda l0402_miscb_shadow
    ora #&1e
    jsr jmp_Set_MiscB
    lda #&3c ; '<'
    sta PIA1_ControlA
    lda l0402_miscb_shadow
    ora #1
    jsr jmp_Set_MiscB
    lda #&34 ; '4'
    sta PIA1_ControlA
    lda l0402_miscb_shadow
    and #&fd
    jsr jmp_Set_MiscB
    lda l0400_device_type
    cmp #2
    bne c9ea6
    lda l0402_miscb_shadow
    and #&fb
    jsr jmp_Set_MiscB
.c9ea6
    lda PIA2_PortA_Data
    pha
    lda l0400_device_type
    cmp #2
    bne c9eb9
    lda l0402_miscb_shadow
    ora #4
    jsr jmp_Set_MiscB
.c9eb9
    lda l0402_miscb_shadow
    ora #2
    jsr jmp_Set_MiscB
    lda #&3c ; '<'
    sta PIA1_ControlA
    lda l0402_miscb_shadow
    and #&fe
    jsr jmp_Set_MiscB
    lda l0079
    cmp #4
    bcc c9ed8
    lda #1
    sta l0075
.c9ed8
    pla
    cmp l0082
    bne c9f0d
.c9edd
    lda l0078
    asl a
    asl a
    sta l0079
    lda l0075
    bne c9eea
    jmp c9e3a

.c9eea
    inc l0070
    beq c9ef1
    jmp c9e07

.c9ef1
    inc l0071
    lda l0071
    cmp l0500
    beq c9efd
    jmp c9e07

.c9efd
    jsr jmp_Reset_Hardware
    lda #&7f
    sta user_via_ier
    sta user_via_ifr
    cli
.c9f09
    jsr jmp_Verify_ROM
    rts

.c9f0d
    lda l0075
    beq c9f1b
    lda l0071
    clc
    adc #&40 ; '@'
    sta l0071
    jmp Failed

.c9f1b
    lda l0078
    cmp #&0f
    beq c9edd
    inc l0078
    jmp c9e3a

.Failed
    jsr jmp_Reset_Hardware
    lda #&7f
    sta user_via_ier
    sta user_via_ifr
    cli
    jsr jmp_print_string
    equs &1f, 4, &0c, &88, &81, "FAILED AT ROM LOCATION ", 0

    jsr PrintHexAddress
    ldy #0
    ldx #3
    lda #osbyte_read_write_bell_duration
    jsr osbyte                                                        ; Write CTRL G duration, value X=3
.c9f5e
    ldy #0
    ldx #&32 ; '2'
    lda #osbyte_read_write_bell_frequency
    jsr osbyte                                                        ; Write CTRL G frequency, value X=50
    lda #7
    jsr oswrch                                                        ; Write character 7
    jsr sub_c9fab
    cpy #0
    beq c9f95
    cpy #&1b
    beq c9f90
    ldy #0
    ldx #&96
    lda #osbyte_read_write_bell_frequency
    jsr osbyte                                                        ; Write CTRL G frequency, value X=150
    lda #7
    jsr oswrch                                                        ; Write character 7
    jsr sub_c9fab
    cpy #0
    bne c9f5e
    cpy #&1b
    bne c9f95
.c9f90
    lda #osbyte_acknowledge_escape
    jsr osbyte                                                        ; Clear escape condition and perform escape effects
.c9f95
    ldy #0
    ldx #7
    lda #osbyte_read_write_bell_duration
    jsr osbyte                                                        ; Write CTRL G duration, value X=7
    ldy #0
    ldx #&65 ; 'e'
    lda #osbyte_read_write_bell_frequency
    jsr osbyte                                                        ; Write CTRL G frequency, value X=101
    jsr jmp_Press_Any_Key_To_Return
    rts

.sub_c9fab
    ldy #0
    ldx #&0f
    lda #osbyte_inkey
    jsr osbyte                                                        ; Wait for a key press within 15 centiseconds
    rts

.Calculate_Pulse_WidthA
    ldx l0079
    cpx #1
    bne c9fbc
    rts

.c9fbc
    lda #0
    sta l0077
    sta l0076
.loop_c9fc2
    lda l0077
    clc
    adc #&e8
    sta l0077
    lda l0076
    adc #3
    sta l0076
    dex
    bne loop_c9fc2
    rts

.PrintHexAddress
    lda l0071
    jsr jmp_PrintHexA
    lda l0070
    jsr jmp_PrintHexA
    rts

.Program_ROM_27513_27011
    jsr jmp_Summary_Screen
    lda l0400_device_type
    bne ca023
    jsr jmp_print_string
    equs &1f, &0b, &0c, "ENTER ROM PAGE No.", &0d, &0d, "         "
    equs "TO BE PROGRAMMED (0-3)", 0

    jmp ca05d

.ca023
    jsr jmp_print_string
    equs &1f, &0b, &0c, "ENTER ROM PAGE No.", &0d, &0d, "         "
    equs "TO BE PROGRAMMED (0-7)", 0

.ca05d
    jsr jmp_Get_Rom_Page
    jsr jmp_Summary_Screen
    lda l0400_device_type
    bne ca093
    jsr jmp_print_string
    equs &1f, 3, 6, "PROGRAMMING EPROM 27513 PAGE No. ", 0

    jmp ca0bb

.ca093
    jsr jmp_print_string
    equs &1f, 3, 6, "PROGRAMMING EPROM 27011 PAGE No. ", 0

.ca0bb
    lda l0403
    ora #&30 ; '0'
    jsr oswrch                                                        ; Write character
    jsr jmp_print_string
    equs &1f, &0f, &0c, "GO? Y/N", 0

    jsr jmp_Get_Y_Or_N
    bcc ca0d7
    rts

.ca0d7
    jsr jmp_print_string
    equs &1f, 4, &0c, "PROGRAMMING ROM LOCATION ", 0

    jsr jmp_Reset_Hardware
    lda #&30 ; '0'
    sta PIA2_ControlA
    lda #&ff
    sta PIA2_PortA_Data
    lda #&34 ; '4'
    sta PIA2_ControlA
    lda l0403
    sta PIA2_PortA_Data
    lda l0402_miscb_shadow
    and #&7e ; '~'
    jsr jmp_Set_MiscB
    lda #&f9
    jsr jmp_Set_MiscA
    lda l0400_device_type
    bne ca126
    lda #&d9
    jsr jmp_Set_MiscA
.ca126
    lda #0
    sta l0070
    sta l0071
    sta l0072
    lda l0503
    sta l0073
    ldy #0
    lda #&34 ; '4'
    sta PIA1_ControlA
    lda l0071
    ora #&c0
    sta PIA1_PortB_Addr_Hi
    lda l0401_misca_shadow
    and #&fe
    jsr jmp_Set_MiscA
    jsr sub_ca976
    lda l0402_miscb_shadow
    and #&fb
    jsr jmp_Set_MiscB
    lda l0071
    and #&bf
    sta PIA1_PortB_Addr_Hi
    lda l0071
    ora #&c0
    sta PIA1_PortB_Addr_Hi
    lda l0402_miscb_shadow
    ora #4
    jsr jmp_Set_MiscB
    lda #&3c ; '<'
    sta PIA1_ControlA
    sei
    lda #0
    sta user_via_acr
    lda #&7f
    sta user_via_ier
    sta user_via_ifr
    lda #&a0
    sta user_via_ier
    lda l0501
    jsr jmp_Set_MiscA
    lda l0400_device_type
    beq ca195
    lda l0402_miscb_shadow
    and #&fb
    jsr jmp_Set_MiscB
.ca195
    jsr sub_ca976
.ca198
    jsr PrintHexAddress
    jsr jmp_print_string
    equs 8, 8, 8, 8, 0

    lda #0
    sta l0075
    lda #1
    sta l0078
    sta l0079
    lda #&e8
    sta l0077
    lda #3
    sta l0076
    lda l0071
    ora #&c0
    sta PIA1_PortB_Addr_Hi
    lda l0070
    sta PIA1_PortA_Addr_Lo
.ca1c1
    lda (l0072),y
    cmp #&ff
    bne ca1ca
    jmp ca2a5

.ca1ca
    sta PIA2_PortA_Data
    lda #&34 ; '4'
    sta PIA1_ControlA
    lda l0402_miscb_shadow
    and #&fb
    jsr jmp_Set_MiscB
    lda l0400_device_type
    beq ca1e6
    lda l0071
    and #&bf
    sta PIA1_PortB_Addr_Hi
.ca1e6
    jsr Calculate_Pulse_WidthB
    lda l0077
    sta user_via_t2c_l
    lda l0076
    sta user_via_t2c_h
.loop_ca1f3
    bit user_via_ifr
    bpl loop_ca1f3
    lda l0400_device_type
    bne ca205
    lda l0402_miscb_shadow
    ora #4
    jsr jmp_Set_MiscB
.ca205
    lda l0071
    ora #&c0
    sta PIA1_PortB_Addr_Hi
    lda #&3c ; '<'
    sta PIA1_ControlA
    lda #&30 ; '0'
    sta PIA2_ControlA
    lda #0
    sta PIA2_PortA_Data
    lda #&34 ; '4'
    sta PIA2_ControlA
    lda l0402_miscb_shadow
    ora #1
    jsr jmp_Set_MiscB
    lda #&34 ; '4'
    sta PIA1_ControlA
    lda l0400_device_type
    bne ca23a
    lda l0402_miscb_shadow
    ora #&80
    jsr jmp_Set_MiscB
.ca23a
    lda l0402_miscb_shadow
    and #&fd
    jsr jmp_Set_MiscB
    lda l0402_miscb_shadow
    and #&fb
    jsr jmp_Set_MiscB
    lda PIA2_PortA_Data
    pha
    lda l0400_device_type
    bne ca25b
    lda l0402_miscb_shadow
    ora #4
    jsr jmp_Set_MiscB
.ca25b
    lda l0402_miscb_shadow
    and #&7f
    jsr jmp_Set_MiscB
    lda l0402_miscb_shadow
    ora #2
    jsr jmp_Set_MiscB
    lda #&3c ; '<'
    sta PIA1_ControlA
    lda #&30 ; '0'
    sta PIA2_ControlA
    lda #&ff
    sta PIA2_PortA_Data
    lda #&34 ; '4'
    sta PIA2_ControlA
    lda l0402_miscb_shadow
    and #&fe
    jsr jmp_Set_MiscB
    lda l0079
    cmp #3
    bcc ca291
    lda #1
    sta l0075
.ca291
    pla
    cmp (l0072),y
    bne ca2d7
.ca296
    lda l0078
    asl a
    clc
    adc l0078
    sta l0079
    lda l0075
    bne ca2a5
    jmp ca1c1

.ca2a5
    inc l0070
    inc l0072
    beq ca2ae
    jmp ca198

.ca2ae
    inc l0071
    inc l0073
    lda l0071
    cmp l0500
    beq ca2bc
    jmp ca198

.ca2bc
    lda l0401_misca_shadow
    ora #1
    jsr jmp_Set_MiscA
    jsr jmp_Reset_Hardware
    lda #&7f
    sta user_via_ier
    sta user_via_ifr
    cli
    jsr jmp_Summary_Screen
    jsr jmp_Verify_ROM_Inner
    rts

.ca2d7
    lda l0075
    beq ca2e6
    lda l0401_misca_shadow
    ora #1
    jsr jmp_Set_MiscA
    jmp Failed

.ca2e6
    lda l0078
    cmp #&19
    beq ca296
    inc l0078
    jmp ca1c1

    equb &60

.Calculate_Pulse_WidthB
    ldx l0079
    cpx #1
    bne ca2f9
    rts

.ca2f9
    cpx #&41 ; 'A'
    bcs ca314
    lda #0
    sta l0077
    sta l0076
.loop_ca303
    lda l0077
    clc
    adc #&e8
    sta l0077
    lda l0076
    adc #3
    sta l0076
    dex
    bne loop_ca303
    rts

.ca314
    lda #&ff
    sta l0077
    sta l0076
    rts

.Program_ROM_27512
    jsr jmp_Summary_Screen
    jsr jmp_print_string
    equs &1f, 7, 6, &83, "PROGRAMMING EPROM 27512", &1f, 7, 9, &86
    equs "ENTER ROM ADDRESS SPACE", &0d, &86, "           TO BE PR"
    equs "OGRAMMED.", &1f, 3, &0c, &86, "(L)----LOWER. (0 TO &7FFF"
    equs ").", &0d, &0d, &86, "   (U)----UPPER. (&8000 TO &FFFF).", 0

.loop_ca3ba
    jsr osrdch                                                        ; Read a character from the current input stream
    cmp #&1b                                                          ; A=character read
    bne ca3c6
    lda #osbyte_acknowledge_escape
    jsr osbyte                                                        ; Clear escape condition and perform escape effects
.ca3c6
    cmp #&55 ; 'U'
    bne ca3d6
    lda #&80
    sta l0403
    lda #&7f
    sta l050c
    bne ca3e4
.ca3d6
    cmp #&4c ; 'L'
    bne loop_ca3ba
    lda #0
    sta l0403
    lda #&ff
    sta l050c
.ca3e4
    jsr jmp_Summary_Screen
    jsr jmp_print_string
    equs &1f, 7, 6, &83, "PROGRAMMING EPROM 27512", 0

    lda l0403
    bne ca437
    jsr jmp_print_string
    equs &1f, 3, 8, &86, "LOWER ADDRESS SPACE (0 TO &7FFF).", 0

    clc
    bcc ca464
.ca437
    jsr jmp_print_string
    equs &1f, 1, 8, &86, "UPPER ADDRESS SPACE (&8000 TO &FFFF).", 0

.ca464
    jsr jmp_print_string
    equs &1f, &0f, &0c, "GO? Y/N", 0

    jsr jmp_Get_Y_Or_N
    bcc ca478
    rts

.ca478
    jsr jmp_print_string
    equs &1f, 4, &0c, "PROGRAMMING ROM LOCATION ", 0

    jsr jmp_Reset_Hardware
    lda #&30 ; '0'
    sta PIA2_ControlA
    lda #&ff
    sta PIA2_PortA_Data
    lda #&34 ; '4'
    sta PIA2_ControlA
    lda l0402_miscb_shadow
    and #&7e ; '~'
    jsr jmp_Set_MiscB
    lda #&d9
    jsr jmp_Set_MiscA
    lda #0
    sta l0070
    sta l0071
    sta l0072
    lda l0503
    sta l0073
    ldy #0
    lda l0401_misca_shadow
    and #&fe
    jsr jmp_Set_MiscA
    sei
    lda #0
    sta user_via_acr
    lda #&7f
    sta user_via_ier
    sta user_via_ifr
    lda #&a0
    sta user_via_ier
    lda l0501
    jsr jmp_Set_MiscA
.ca4e7
    jsr PrintHexAddress
    jsr jmp_print_string
    equs 8, 8, 8, 8, 0

    lda #0
    sta l0075
    lda #1
    sta l0078
    sta l0079
    lda #&e8
    sta l0077
    lda #3
    sta l0076
    lda l0071
    ora l0403
    sta PIA1_PortB_Addr_Hi
    lda l0070
    sta PIA1_PortA_Addr_Lo
.ca511
    lda (l0072),y
    cmp #&ff
    bne ca51a
    jmp ca5c3

.ca51a
    sta PIA2_PortA_Data
    lda #&34 ; '4'
    sta PIA1_ControlA
    lda l0402_miscb_shadow
    and #&fb
    jsr jmp_Set_MiscB
    jsr Calculate_Pulse_WidthC
    lda l0077
    sta user_via_t2c_l
    lda l0076
    sta user_via_t2c_h
.loop_ca537
    bit user_via_ifr
    bpl loop_ca537
    lda l0402_miscb_shadow
    ora #4
    jsr jmp_Set_MiscB
    lda #&3c ; '<'
    sta PIA1_ControlA
    lda #&30 ; '0'
    sta PIA2_ControlA
    lda #0
    sta PIA2_PortA_Data
    lda #&34 ; '4'
    sta PIA2_ControlA
    lda l0402_miscb_shadow
    ora #1
    jsr jmp_Set_MiscB
    lda #&34 ; '4'
    sta PIA1_ControlA
    lda l0402_miscb_shadow
    ora #&80
    jsr jmp_Set_MiscB
    lda l0402_miscb_shadow
    and #&fb
    jsr jmp_Set_MiscB
    lda PIA2_PortA_Data
    pha
    lda l0402_miscb_shadow
    ora #4
    jsr jmp_Set_MiscB
    lda l0402_miscb_shadow
    and #&7f
    jsr jmp_Set_MiscB
    lda #&3c ; '<'
    sta PIA1_ControlA
    lda #&30 ; '0'
    sta PIA2_ControlA
    lda #&ff
    sta PIA2_PortA_Data
    lda #&34 ; '4'
    sta PIA2_ControlA
    lda l0402_miscb_shadow
    and #&fe
    jsr jmp_Set_MiscB
    lda l0079
    cmp #3
    bcc ca5af
    lda #1
    sta l0075
.ca5af
    pla
    cmp (l0072),y
    bne ca5dd
.ca5b4
    lda l0078
    asl a
    clc
    adc l0078
    sta l0079
    lda l0075
    bne ca5c3
    jmp ca511

.ca5c3
    inc l0070
    inc l0072
    beq ca5cc
    jmp ca4e7

.ca5cc
    inc l0071
    inc l0073
    lda l0071
    cmp l0500
    beq ca5da
    jmp ca4e7

.ca5da
    jmp ca621

.ca5dd
    lda l0075
    beq ca5ec
    lda l0401_misca_shadow
    ora #1
    jsr jmp_Set_MiscA
    jmp Failed

.ca5ec
    lda l0078
    cmp #&19
    beq ca5b4
    inc l0078
    jmp ca511

    equb &60

.Calculate_Pulse_WidthC
    ldx l0079
    cpx #1
    bne ca5ff
    rts

.ca5ff
    cpx #&41 ; 'A'
    bcs ca61a
    lda #0
    sta l0077
    sta l0076
.loop_ca609
    lda l0077
    clc
    adc #&e8
    sta l0077
    lda l0076
    adc #3
    sta l0076
    dex
    bne loop_ca609
    rts

.ca61a
    lda #&ff
    sta l0077
    sta l0076
    rts

.ca621
    lda #0
    sta l0070
    sta l0071
    lda l0403
    ora #&40 ; '@'
    sta l0403
    lda #&30 ; '0'
    sta PIA2_ControlA
    lda #0
    sta PIA2_PortA_Data
    lda #&34 ; '4'
    sta PIA2_ControlA
.ca63e
    lda l0071
    clc
    adc #&40 ; '@'
    jsr jmp_PrintHexA
    lda l0070
    jsr jmp_PrintHexA
    jsr jmp_print_string
    equs 8, 8, 8, 8, 0

    lda #0
    sta l0075
    lda #1
    sta l0078
    sta l0079
    lda #&e8
    sta l0077
    lda #3
    sta l0076
    lda l0071
    ora l0403
    sta PIA1_PortB_Addr_Hi
    lda l0070
    sta PIA1_PortA_Addr_Lo
.ca672
    lda l0402_miscb_shadow
    and #&cf
    jsr jmp_Set_MiscB
    lda PIA2_PortA_Data
    sta l0082
    cmp #&ff
    bne ca686
    jmp ca716

.ca686
    lda #&34 ; '4'
    sta PIA1_ControlA
    lda l0402_miscb_shadow
    and #&fb
    jsr jmp_Set_MiscB
    jsr Calculate_Pulse_WidthD
    lda l0077
    sta user_via_t2c_l
    lda l0076
    sta user_via_t2c_h
.loop_ca6a0
    bit user_via_ifr
    bpl loop_ca6a0
    lda l0402_miscb_shadow
    ora #4
    jsr jmp_Set_MiscB
    lda #&3c ; '<'
.sub_ca6af
la6b1 = sub_ca6af+2
    sta PIA1_ControlA
    lda l0402_miscb_shadow
    ora #&20 ; ' '
    jsr jmp_Set_MiscB
    lda l0402_miscb_shadow
    ora #1
    jsr jmp_Set_MiscB
    lda #&34 ; '4'
    sta PIA1_ControlA
    lda l0402_miscb_shadow
    ora #&80
    jsr jmp_Set_MiscB
    lda l0402_miscb_shadow
    and #&fb
    jsr jmp_Set_MiscB
    lda PIA2_PortA_Data
    pha
    lda l0402_miscb_shadow
    ora #4
    jsr jmp_Set_MiscB
    lda l0402_miscb_shadow
    and #&7f
    jsr jmp_Set_MiscB
    lda #&3c ; '<'
    sta PIA1_ControlA
    lda l0402_miscb_shadow
    and #&fe
    jsr jmp_Set_MiscB
    lda l0079
    cmp #3
    bcc ca702
    lda #1
    sta l0075
.ca702
    pla
    cmp l0082
    bne ca74b
.ca707
    lda l0078
    asl a
    clc
    adc l0078
    sta l0079
    lda l0075
    bne ca716
    jmp ca672

.ca716
    inc l0070
    inc l0072
    beq ca71f
    jmp ca63e

.ca71f
    inc l0071
    inc l0073
    lda l0071
    cmp l0500
    beq ca72d
    jmp ca63e

.ca72d
    lda l0401_misca_shadow
    ora #1
    jsr jmp_Set_MiscA
    jsr jmp_Reset_Hardware
    lda #&7f
    sta user_via_ier
    sta user_via_ifr
    cli
    jsr jmp_Summary_Screen
    jsr sub_ca78f
    jsr jmp_Verify_ROM_Inner_28pin
    rts

.ca74b
    lda l0075
    beq ca75a
    lda l0401_misca_shadow
    ora #1
    jsr jmp_Set_MiscA
    jmp Failed

.ca75a
    lda l0078
    cmp #&19
    beq ca707
    inc l0078
    jmp ca672

    equb &60

.Calculate_Pulse_WidthD
    ldx l0079
    cpx #1
    bne ca76d
    rts

.ca76d
    cpx #&41 ; 'A'
    bcs ca788
    lda #0
    sta l0077
    sta l0076
.loop_ca777
    lda l0077
    clc
    adc #&e8
    sta l0077
    lda l0076
    adc #3
    sta l0076
    dex
    bne loop_ca777
    rts

.ca788
    lda #&ff
    sta l0077
    sta l0076
    rts

.sub_ca78f
    ldy #0
    ldx #0
    lda #5
    sta l0070
.ca797
    dex
    bne ca797
    dey
    bne ca797
    dec l0070
    lda l0070
    bne ca797
    rts

.Program_ROM_2732_2716_2564_2532
    jsr jmp_print_string
    equs &1f, 7, 6, "PROGRAM EPROM FROM MEMORY", &1f, &0f, &0c, "G"
    equs "O? Y/N", 0

    jsr jmp_Get_Y_Or_N
    bcc ca7d4
    rts

.ca7d4
    jsr jmp_print_string
    equs &1f, 4, &0c, "PROGRAMMING ROM LOCATION ", 0

    jsr jmp_Reset_Hardware
    lda #&30 ; '0'
    sta PIA2_ControlA
    lda #&ff
    sta PIA2_PortA_Data
    lda #&34 ; '4'
    sta PIA2_ControlA
    lda l0402_miscb_shadow
    and #&7e ; '~'
    jsr jmp_Set_MiscB
    lda l0501
    jsr jmp_Set_MiscA
    lda l0400_device_type
    cmp #5
    bne ca826
    lda l0401_misca_shadow
    and #&9f
    jsr jmp_Set_MiscA
    jmp ca860

.ca826
    cmp #6
    beq ca850
    cmp #9
    beq ca850
    cmp #7
    bne ca845
    lda l0402_miscb_shadow
    and #&f7
    jsr jmp_Set_MiscB
    lda l0401_misca_shadow
    and #&bf
    jsr jmp_Set_MiscA
    jmp ca860

.ca845
    lda l0401_misca_shadow
    and #&3f ; '?'
    jsr jmp_Set_MiscA
    jmp ca860

.ca850
    lda l0401_misca_shadow
    and #&3f ; '?'
    jsr jmp_Set_MiscA
    lda l0402_miscb_shadow
    and #&fb
    jsr jmp_Set_MiscB
.ca860
    jsr sub_ca976
    lda l0401_misca_shadow
    and #&fe
    jsr jmp_Set_MiscA
    lda #&34 ; '4'
    sta PIA1_ControlA
    lda #0
    sta l0070
    sta l0071
    sta l0072
    lda l0503
    sta l0073
    ldy #0
    sei
    lda #0
    sta user_via_acr
    lda #&7f
    sta user_via_ier
    sta user_via_ifr
    lda #&a0
    sta user_via_ier
.ca892
    jsr PrintHexAddress
    jsr jmp_print_string
    equs 8, 8, 8, 8, 0

    lda #&50 ; 'P'
    sta l0077
    lda #&c3
    sta l0076
    lda l0071
    sta PIA1_PortB_Addr_Hi
    lda l0400_device_type
    cmp #5
    beq ca8ca
    lda l0071
    and #8
    beq ca8c2
    lda l0402_miscb_shadow
    ora #4
    jsr jmp_Set_MiscB
    clc
    bcc ca8ca
.ca8c2
    lda l0402_miscb_shadow
    and #&fb
    jsr jmp_Set_MiscB
.ca8ca
    lda l0070
    sta PIA1_PortA_Addr_Lo
    lda (l0072),y
    cmp #&ff
    bne ca8d8
    jmp ca944

.ca8d8
    sta PIA2_PortA_Data
    lda l0077
    sta user_via_t2c_l
    lda l0400_device_type
    cmp #5
    bne ca8f2
    lda l0402_miscb_shadow
    and #&fb
    jsr jmp_Set_MiscB
    jmp ca90d

.ca8f2
    cmp #6
    beq ca905
    cmp #9
    beq ca905
    lda l0402_miscb_shadow
    and #&fd
    jsr jmp_Set_MiscB
    jmp ca90d

.ca905
    lda l0402_miscb_shadow
    ora #4
    jsr jmp_Set_MiscB
.ca90d
    lda l0076
    sta user_via_t2c_h
.loop_ca912
    bit user_via_ifr
    bpl loop_ca912
    lda l0400_device_type
    cmp #5
    bne ca929
    lda l0402_miscb_shadow
    ora #4
    jsr jmp_Set_MiscB
    jmp ca944

.ca929
    cmp #6
    beq ca93c
    cmp #9
    beq ca93c
    lda l0402_miscb_shadow
    ora #2
    jsr jmp_Set_MiscB
    jmp ca944

.ca93c
    lda l0402_miscb_shadow
    and #&fb
    jsr jmp_Set_MiscB
.ca944
    inc l0070
    inc l0072
    beq ca94d
    jmp ca892

.ca94d
    inc l0071
    inc l0073
    lda l0071
    cmp l0500
    beq ca95b
    jmp ca892

.ca95b
    lda l0401_misca_shadow
    ora #1
    jsr jmp_Set_MiscA
    jsr jmp_Reset_Hardware
    lda #&7f
    sta user_via_ier
    sta user_via_ifr
    cli
    jsr sub_ca976
    jmp jmp_Verify_ROM_Inner_24pin

    equb &60

.sub_ca976
    lda #7
    sta l0070
    ldx #0
    ldy #0
.ca97e
    dex
    bne ca97e
    dey
    bne ca97e
    dec l0070
    bne ca97e
    rts

.Rom_Image_Creator
    jsr jmp_print_string
    equs &0c, &0d, &8d, &84, &9d, &83, "        ROM IMAGE CREATOR."
    equs &0d, &8d, &84, &9d, &83, "        ROM IMAGE CREATOR.", &1f
    equs 3, 4, "Enter Romlength (8/16)K ? ", 0

    jsr osrdch                                                        ; Read a character from the current input stream
    cmp #&1b                                                          ; A=character read
    bne ca9f8
    lda #osbyte_acknowledge_escape
    jsr osbyte                                                        ; Clear escape condition and perform escape effects
    jmp Rom_Image_Creator

.ca9f8
    cmp #&38 ; '8'
    bne caa0a
    jsr oswrch                                                        ; Write character
    lda #&4b ; 'K'
    jsr oswrch                                                        ; Write character 75
    lda #&20 ; ' '
    sta l0075
    bne caa1d
.caa0a
    lda #&31 ; '1'
    jsr oswrch                                                        ; Write character 49
    lda #&36 ; '6'
    jsr oswrch                                                        ; Write character 54
    lda #&4b ; 'K'
    jsr oswrch                                                        ; Write character 75
    lda #&40 ; '@'
    sta l0075
.caa1d
    jsr jmp_print_string
    equs &1f, 3, 6, "Enter Rom Title ? ", &1f, 3, 8, 0

    lda #&1e
    sta l0076
    jsr sub_cb200
    bcc caa45
    jmp Rom_Image_Creator

.caa45
    lda #&20 ; ' '
    sta l0071
    sta l0073
    lda #9
    sta l0072
    lda #0
    sta l0070
    ldx #&40 ; '@'
    ldy #0
.caa57
    sta (l0070),y
    iny
    bne caa57
    inc l0071
    dex
    bne caa57
    lda #&4c ; 'L'
    sta l2003
    lda #&82
    sta l2006
    ldx #0
    ldy #0
.caa6f
    lda l0600,x
    cmp #&0d
    beq caa81
    sta (l0072),y
    inx
    inc l0072
    bne caa6f
    inc l0073
    bne caa6f
.caa81
    lda l0072
    sta l2007
    lda #0
    sta (l0072),y
    inc l0072
    bne caa90
    inc l0073
.caa90
    lda #&28 ; '('
    sta (l0072),y
    inc l0072
    bne caa9a
    inc l0073
.caa9a
    lda #&43 ; 'C'
    sta (l0072),y
    inc l0072
    bne caaa4
    inc l0073
.caaa4
    lda #&29 ; ')'
    sta (l0072),y
    inc l0072
    bne caaae
    inc l0073
.caaae
    jsr jmp_print_string
    equs &1f, 3, &0a, "Enter Copyright string ? ", &1f, 3, &0c, "("
    equs "C)", 0

    lda #&1e
    sta l0076
    jsr sub_cb200
    bcc caae0
    jmp Rom_Image_Creator

.caae0
    jsr jmp_print_string
    equs &1f, 3, &0e, "Enter Version No. (0-9) ? ", 0

.cab01
    jsr osrdch                                                        ; Read a character from the current input stream
    cmp #&30 ; '0'                                                    ; A=character read
    bcc cab01
    cmp #&40 ; '@'
    bcs cab01
    jsr oswrch                                                        ; Write character
    sec
    sbc #&30 ; '0'
    sta l2008
    ldx #0
    ldy #0
.cab19
    lda l0600,x
    cmp #&0d
    beq cab2b
    sta (l0072),y
    inx
    inc l0072
    bne cab19
    inc l0073
    bne cab19
.cab2b
    lda #0
    sta (l0072),y
    inc l0072
    bne cab35
    inc l0073
.cab35
    lda l0072
    sta l2004
    sta l0080
    lda l0073
    sta l0081
    clc
    adc #&60 ; '`'
    sta l2005
    lda lb05e
    sta l0070
    lda lb05f
    sta l0071
    ldy #0
.cab52
    lda (l0070),y
    bne cab66
    iny
    lda (l0070),y
    bne cab62
    iny
    lda (l0070),y
    bne cab62
    beq cab77
.cab62
    ldy #0
    lda (l0070),y
.cab66
    sta (l0072),y
    inc l0070
    bne cab6e
    inc l0071
.cab6e
    inc l0072
    bne cab74
    inc l0073
.cab74
    clc
    bcc cab52
.cab77
    ldy #0
    lda l0080
    clc
    adc #3
    sta l0080
    lda l0081
    adc #0
    sta l0081
    lda l0072
    sta (l0080),y
    iny
    lda l0073
    clc
    adc #&60 ; '`'
    sta (l0080),y
    jsr jmp_print_string
    equs &1f, 3, &10, "Enter Help Message ?", &1f, 3, &12, 0

    lda #&1e
    sta l0076
    jsr sub_cb200
    bcc cabbc
    jmp Rom_Image_Creator

.cabbc
    ldx #0
    ldy #0
.cabc0
    lda l0600,x
    cmp #&0d
    beq cabd2
    sta (l0072),y
    inx
    inc l0072
    bne cabc0
    inc l0073
    bne cabc0
.cabd2
    lda #0
    sta (l0072),y
    inc l0072
    bne cabdc
    inc l0073
.cabdc
    iny
    iny
    lda l0072
    sta (l0080),y
    iny
    lda l0073
    clc
    adc #&60 ; '`'
    sta (l0080),y
    jsr jmp_print_string
    equs &1c, 3, &17, "%", 3, 0

    lda brkv
    sta l008e
    lda brkv+1
    sta l008f
    lda #&60 ; '`'
    sta brkv
    lda #&ae
    sta brkv+1
.cac07
    jsr jmp_print_string
    equs &0c, &1f, 1, 1, "ROM LENGTH SELECTED &", 0

    lda l0075
    jsr jmp_PrintHexA
    lda #0
    jsr jmp_PrintHexA
    jsr jmp_print_string
    equs &1f, 1, 3, "FREE SPACE IN ROM= &", 0

    lda #0
    sta l0080
    lda l0075
    clc
    adc #&20 ; ' '
    sta l0081
    lda l0080
    sec
    sbc l0072
    sta l0080
    lda l0081
    sbc l0073
    sta l0081
    jsr jmp_PrintHexA
    lda l0080
    jsr jmp_PrintHexA
    jsr jmp_print_string
    equs " Bytes.", &1f, 1, 6, "Enter PROGRAM FILE NAME ON DISC. ?"
    equs &0d, 9, 0

    ldy #0
    lda #0
    sta (l0072),y
    ldx #0
.caca3
    jsr osrdch                                                        ; Read a character from the current input stream
    cmp #&1b                                                          ; A=character read
    bne cacad
    jmp cae91

.cacad
    cmp #&7f
    bne cacbb
    cpx #0
    beq caca3
    jsr oswrch                                                        ; Write character
    dex
    bpl caca3
.cacbb
    sta l0680,x
    cmp #&0d
    beq cacc8
    jsr oswrch                                                        ; Write character
    inx
    bne caca3
.cacc8
    jsr jmp_print_string
    equs &1f, 1, &0a, "BASIC OR M/CODE (B/M) ? ", 0

.cace7
    jsr osrdch                                                        ; Read a character from the current input stream
    cmp #&1b                                                          ; A=character read
    bne cacf6
    lda #osbyte_acknowledge_escape
    jsr osbyte                                                        ; Clear escape condition and perform escape effects
    jmp cac07

.cacf6
    cmp #&42 ; 'B'
    bne cad0a
    jsr jmp_print_string
    equs "BASIC", 0

    lda #&fe
    sta l0082
    jmp cad1c

.cad0a
    cmp #&4d ; 'M'
    bne cace7
    jsr jmp_print_string
    equs "M/CODE", 0

    lda #&ff
    sta l0082
.cad1c
    jsr jmp_print_string
    equs &1f, 1, &0e, "Enter STAR COMMAND. ?", &0d, &0d, 9, 0

    lda #&1e
    sta l0076
    jsr sub_cb200
    bcc cad47
    jmp cac07

.cad47
    jsr jmp_print_string
    equs &1f, 1, &12, "ABOVE DETAILS CORRECT Y/N ? ", 0

    jsr osrdch                                                        ; Read a character from the current input stream
    cmp #&59 ; 'Y'                                                    ; A=character read
    beq cad74
    jmp cac07

.cad74
    lda l0072
    sta l007a
    lda l0073
    sta l007b
    ldy #0
    ldx #0
.cad80
    lda l0600,x
    cmp #&0d
    beq cad92
    sta (l007a),y
    inx
    inc l007a
    bne cad80
    inc l007b
    bne cad80
.cad92
    lda l0082
    sta (l007a),y
    inc l007a
    bne cad9c
    inc l007b
.cad9c
    ldx #<(l06a0)
    ldy #>(l06a0)
    lda #&80
    sta l06a0
    lda #6
    sta l06a1
    lda #osfile_read_catalogue_info
    jsr osfile                                                        ; Read catalogue information (A=5)
    lda l06aa
    clc
    adc l007a
    sta l007c
    lda l06ab
    adc l007b
    sta l007d
    lda l007c
    clc
    adc #6
    sta l007c
    lda l007d
    adc #0
    sta l007d
    sec
    sbc #&20 ; ' '
    cmp l0075
    bcc cae0c
    jsr jmp_print_string
    equs &0c, &1f, 6, &0c, &81, &88, "PROGRAM TOO LARGE", &0d, &0d
    equs "          PRESS ANY KEY", 0

    jsr osrdch                                                        ; Read a character from the current input stream
    jmp cac07

.cae0c
    ldy #0
    lda l007c
    sta (l007a),y
    iny
    lda l007d
    clc
    adc #&60 ; '`'
    sta (l007a),y
    iny
    lda l06a2
    sta (l007a),y
    iny
    lda l06a3
    sta (l007a),y
    iny
    lda l06a6
    sta (l007a),y
    iny
    lda l06a7
    sta (l007a),y
    lda l007a
    clc
    adc #6
    sta l06a2
    lda l007b
    adc #0
    sta l06a3
    lda #0
    sta l06a4
    sta l06a5
    sta l06a6
    ldx #<(l06a0)
    ldy #>(l06a0)
    lda #osfile_load
    jsr osfile                                                        ; Load named file (if XY+6 contains 0, use specified address) (A=255)
    lda l007c
    sta l0072
    lda l007d
    sta l0073
    jmp cac07

    equb &20, &2a, &bf, &0c, &1f,   1, &0c, &a0,   0, &c8, &b1, &fd
    equb &f0,   5, &20, &e3, &ff, &d0, &f6

.cae73
    jsr jmp_print_string
    equs "  Press any key", 0

    lda #7
    jsr oswrch                                                        ; Write character 7
    jsr osrdch                                                        ; Read a character from the current input stream
    jmp cac07

.cae91
    lda #osbyte_acknowledge_escape
    jsr osbyte                                                        ; Clear escape condition and perform escape effects
    jsr jmp_print_string
    equs &0c, &1f, 1, 3, "1) SAVE ROM IMAGE TO DISC.", &0d, &0d, " "
    equs "2) SAVE ROM IMAGE TO SIDEWAYS RAM.", &0d, &0d, " Enter c"
    equs "hoice:-", 0

.loop_caeee
    jsr osrdch                                                        ; Read a character from the current input stream
    cmp #&1b                                                          ; A=character read
    bne caefd
    lda #osbyte_acknowledge_escape
    jsr osbyte                                                        ; Clear escape condition and perform escape effects
    jmp cac07

.caefd
    cmp #&31 ; '1'
    bne caf04
    jmp caf0b

.caf04
    cmp #&32 ; '2'
    bne loop_caeee
    jmp caf90

.caf0b
    jsr jmp_print_string
    equs &0c, &1f, 1, 3, "Enter file name for save:-", &0d, &0d, 9
    equs 0

    lda #7
    sta l0076
    jsr sub_cb200
    bcc caf3c
    jmp cac07

.caf3c
    ldx #<(l06a0)
    ldy #>(l06a0)
    lda #0
    sta l06a0
    sta l06a2
    sta l0006
    sta l06a5
    sta l06a6
    sta l06a8
    sta l06a9
    sta l06aa
    sta l06ac
    sta l06ad
    sta l06ae
    sta l06b0
    sta la6b1
    lda #6
    sta l06a1
    lda #&80
    sta l06a3
    sta l06a7
    lda #&20 ; ' '
    sta l06ab
    lda l0075
    clc
    adc #&20 ; ' '
    sta l06af
    lda #osfile_save
    jsr osfile                                                        ; Save a block of memory (returning file length and attributes) (A=0)
    jsr osnewl                                                        ; Write newline (characters 10 and 13)
    jsr osnewl                                                        ; Write newline (characters 10 and 13)
    jmp cae73

.caf90
    lda l0075
    sta l007b
    jsr jmp_print_string
    equs &0c, &1f, 1, 3, "Enter sideways ram bank No. (0-F).", &0d
    equs &0d, 9, 0

.cafc1
    jsr osrdch                                                        ; Read a character from the current input stream
    cmp #&1b                                                          ; A=character read
    bne cafd0
    lda #osbyte_acknowledge_escape
    jsr osbyte                                                        ; Clear escape condition and perform escape effects
    jmp cac07

.cafd0
    cmp #&30 ; '0'
    bcs cafd7
    jmp cafc1

.cafd7
    cmp #&47 ; 'G'
    bcs cafc1
    jsr oswrch                                                        ; Write character
    cmp #&40 ; '@'
    bcs caff6
    sec
    sbc #&30 ; '0'
    sta l007a
    jsr sub_cb007
    jsr l0700
    jsr osnewl                                                        ; Write newline (characters 10 and 13)
    jsr osnewl                                                        ; Write newline (characters 10 and 13)
    jmp cae73

.caff6
    sec
    sbc #&37 ; '7'
    sta l007a
    jsr sub_cb007
    jsr l0700
    jsr osnewl                                                        ; Write newline (characters 10 and 13)
    jmp cae73

.sub_cb007
    ldx #&30 ; '0'
    lda lb02c
    sta l007c
    lda lb02d
    sta l007d
    ldy #0
    sty l007e
    lda #7
    sta l007f
.cb01b
    lda (l007c),y
    sta (l007e),y
    dex
    bne cb023
    rts

.cb023
    iny
    bne cb01b
    inc l007d
    inc l007f
    bne cb01b
; overlapping: rol sub_ca5b0
.lb02c
    equb &2e
.lb02d
    equb &b0

    lda romsel_copy
    pha
    lda l007a
    sta romsel
    sta romsel_copy
    lda #0
    sta l007c
    sta l007e
    lda #&80
    sta l007d
    lda #&20 ; ' '
    sta l007f
    ldy #0
.cb048
    lda (l007e),y
    sta (l007c),y
    iny
    bne cb048
    inc l007d
    inc l007f
    dec l007b
    bne cb048
    pla
    sta romsel_copy
    sta romsel
    rts

.lb05e
    equb &60
.lb05f
    equb &b0, &18, &90,   4, &ff, &ff, &ff, &ff,   8, &48, &98, &48
    equb &8a, &48, &ba, &bd,   3,   1, &c9,   9, &d0, &42, &20, &e7
    equb &ff, &ad,   5, &80, &85, &73, &ad,   4, &80, &18, &69,   3
    equb &85, &72, &a5, &73, &69,   0, &85, &73, &a0,   0, &b1, &72
    equb &85, &70, &c8, &b1, &72, &85, &71, &a0,   0, &b1, &70, &f0
    equb &11, &c9, &23, &d0,   2, &a9, &0d, &20, &e3, &ff, &e6, &70
    equb &d0, &ef, &e6, &71, &d0, &eb, &20, &e7, &ff, &68, &aa, &68
    equb &a8
    equs "h(`"
    equb &c9,   4, &d0, &f5, &84, &78, &ad,   5, &80, &85, &71, &ad
    equb   4, &80, &18, &69,   5, &85, &70, &a5, &71, &69,   0, &85
    equb &71, &a0,   0, &b1, &70, &85, &72, &c8, &b1, &70, &85, &73
    equb &a5, &72, &85, &70, &a5, &73, &85, &71, &a5, &78, &85, &76
    equb &a0,   0, &b1, &70, &85, &79, &f0, &c1
    equs "$y0,"
    equb &a4, &76, &10, &2b, &c5, &79, &d0, &0b, &e6, &76, &e6, &70
    equb &d0,   2, &e6, &71, &18, &90, &e1, &a0,   0, &e6, &70, &d0
    equb   2, &e6, &71, &b1, &70, &10, &f6, &c8, &b1, &70, &85, &72
    equb &c8, &b1, &70, &85, &73, &18, &90, &bc, &18, &90, &4c, &b1
    equb &f2, &c9, &40, &90, &cf, &29, &df, &d0, &cb, &18, &18, &69
    equb   7, &85, &70, &a5, &71, &69,   0, &85, &71, &a0,   0, &b1
    equb &70, &91, &74, &e6, &70, &d0,   2, &e6, &71, &e6, &74, &d0
    equb   2, &e6, &75, &a5, &72, &c5, &70, &d0, &ea, &a5, &73, &c5
    equb &71, &d0, &e4, &a5
    equs "yFy"
    equb &90, &2b, &a9, &6c, &85, &70, &a9, &76, &85, &71, &a9,   0
    equb &85
    equs "r p"
    equb   0, &18, &90, &40, &a2,   0, &c8, &b1, &70, &95, &72, &e8
    equb &e0,   6, &d0, &f6, &a5, &79, &4a, &a5, &70, &b0, &ab, &a6
    equb &18, &86, &75, &d0, &a5, &a9, &8a, &a2,   0, &a0, &4f, &20
    equb &f4, &ff, &a0, &2e, &20, &f4, &ff, &a0, &0d, &20, &f4, &ff
    equb &a0, &52, &20, &f4, &ff, &a0, &55, &20, &f4, &ff, &a0, &4e
    equb &20, &f4, &ff, &a0, &0d, &20, &f4, &ff, &68, &aa, &68, &a8
    equb &68, &28, &a9,   0, &60,   0,   0,   0
    equs "Spare to &B1FF"
    equb &ea, &20, &ee, &ff, &e8, &4c, &99, &b1, &18, &60,   0,   0
    equb   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    equb   0,   0,   0,   0,   0,   0,   0,   0

.sub_cb200
    ldx #0
.cb202
    jsr osrdch                                                        ; Read a character from the current input stream
    cmp #&7f                                                          ; A=character read
    bne cb214
    cpx #0
    beq cb202
    jsr oswrch                                                        ; Write character
    dex
    jmp cb202

.cb214
    cmp #&1b
    bne cb21f
    lda #osbyte_acknowledge_escape
    jsr osbyte                                                        ; Clear escape condition and perform escape effects
    sec
    rts

.cb21f
    cpx l0076
    bne cb22b
    lda #7
    jsr oswrch                                                        ; Write character 7
    jmp cb202

.cb22b
    sta l0600,x
    cmp #&0d
    beq cb239
    jsr oswrch                                                        ; Write character
    inx
    jmp cb202

.cb239
    clc
    rts

    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

.jmp_Rom_Image_Creator
    jmp Rom_Image_Creator

.jmp_Set_Device_Variables
    jmp Set_Device_Variables

.jmp_Reset_Hardware
    jmp Reset_Hardware

.jmp_Copy_ROM
    jmp Copy_ROM

.jmp_Blank_Check_ROM
    jmp Blank_Check_ROM

.jmp_Program_ROM
    jmp Program_ROM

.jmp_Verify_ROM
    jmp Verify_ROM

.jmp_Verify_ROM_Inner
    jmp Verify_ROM_Inner

.jmp_Verify_ROM_Inner_28pin
    jmp Verify_ROM_Inner_28pin

.jmp_Verify_ROM_Inner_24pin
    jmp Verify_ROM_Inner_24pin

.jmp_Set_MiscA
    jmp Set_MiscA

.jmp_Set_MiscB
    jmp Set_MiscB

.jmp_Press_Any_Key_To_Return
    jmp Press_Any_Key_To_Return

.jmp_Summary_Screen
    jmp Summary_Screen

.jmp_print_string
    jmp print_string

.jmp_PrintHexA
    jmp PrintHexA

.jmp_Failed
    jmp Failed

.jmp_Get_Y_Or_N
    jmp Get_Y_Or_N

.jmp_Get_Rom_Page
    jmp Get_Rom_Page

    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    equb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
.pydis_end

; Automatically generated labels:
;     c804e
;     c8080
;     c8084
;     c808a
;     c80aa
;     c80b8
;     c80b9
;     c80de
;     c80e8
;     c80f5
;     c80ff
;     c810c
;     c8119
;     c8126
;     c8133
;     c813d
;     c8144
;     c814b
;     c8155
;     c816d
;     c8184
;     c8194
;     c819e
;     c81a8
;     c81aa
;     c81bd
;     c81c9
;     c81d6
;     c8226
;     c823e
;     c8256
;     c826e
;     c8286
;     c829e
;     c82b6
;     c82ce
;     c82e6
;     c8312
;     c8324
;     c8348
;     c8367
;     c8371
;     c8385
;     c8390
;     c83a0
;     c83ad
;     c83e3
;     c8414
;     c8498
;     c84a9
;     c84b3
;     c84b9
;     c84c2
;     c84c6
;     c84d8
;     c84e2
;     c8575
;     c85af
;     c85cf
;     c85e1
;     c85e7
;     c85f3
;     c860c
;     c8742
;     c8754
;     c8766
;     c8767
;     c8778
;     c87b9
;     c87df
;     c880b
;     c881b
;     c881d
;     c883e
;     c88df
;     c88fc
;     c8918
;     c891b
;     c892d
;     c8930
;     c8937
;     c893e
;     c8945
;     c894c
;     c8953
;     c895a
;     c8961
;     c896c
;     c896f
;     c899b
;     c89a7
;     c89d4
;     c89d6
;     c8a0e
;     c8a68
;     c8a87
;     c8a8d
;     c8ab9
;     c8ac3
;     c8ac9
;     c8ae0
;     c8ae8
;     c8b08
;     c8b2f
;     c8b36
;     c8b46
;     c8b4c
;     c8b59
;     c8b68
;     c8b71
;     c8bb9
;     c8bc1
;     c8bcb
;     c8bd3
;     c8bdf
;     c8be9
;     c8bf7
;     c8c01
;     c8c0b
;     c8c3b
;     c8c82
;     c8cb8
;     c8ce0
;     c8d02
;     c8d04
;     c8d1a
;     c8d45
;     c8d69
;     c8d70
;     c8d7b
;     c8da4
;     c8e00
;     c8e62
;     c92cd
;     c9303
;     c9351
;     c93a7
;     c93aa
;     c9415
;     c94ea
;     c950e
;     c9531
;     c953b
;     c9542
;     c9543
;     c957c
;     c9610
;     c962f
;     c9656
;     c9659
;     c96a6
;     c96cc
;     c96f9
;     c970b
;     c9714
;     c97df
;     c9800
;     c983d
;     c9869
;     c98a9
;     c98d9
;     c9946
;     c9980
;     c99fc
;     c9a0e
;     c9a1a
;     c9a23
;     c9a4c
;     c9a68
;     c9ad4
;     c9ad9
;     c9ae1
;     c9b0d
;     c9b2a
;     c9b32
;     c9b6a
;     c9b81
;     c9b94
;     c9b9d
;     c9bab
;     c9bc2
;     c9bc9
;     c9bd0
;     c9bd7
;     c9bde
;     c9be5
;     c9c18
;     c9c95
;     c9cbf
;     c9cc8
;     c9d3c
;     c9d4f
;     c9d7d
;     c9d82
;     c9d8f
;     c9d98
;     c9da6
;     c9db5
;     c9dbc
;     c9dc7
;     c9dd1
;     c9e07
;     c9e3a
;     c9e4e
;     c9ea6
;     c9eb9
;     c9ed8
;     c9edd
;     c9eea
;     c9ef1
;     c9efd
;     c9f09
;     c9f0d
;     c9f1b
;     c9f5e
;     c9f90
;     c9f95
;     c9fbc
;     ca023
;     ca05d
;     ca093
;     ca0bb
;     ca0d7
;     ca126
;     ca195
;     ca198
;     ca1c1
;     ca1ca
;     ca1e6
;     ca205
;     ca23a
;     ca25b
;     ca291
;     ca296
;     ca2a5
;     ca2ae
;     ca2bc
;     ca2d7
;     ca2e6
;     ca2f9
;     ca314
;     ca3c6
;     ca3d6
;     ca3e4
;     ca437
;     ca464
;     ca478
;     ca4e7
;     ca511
;     ca51a
;     ca5af
;     ca5b4
;     ca5c3
;     ca5cc
;     ca5da
;     ca5dd
;     ca5ec
;     ca5ff
;     ca61a
;     ca621
;     ca63e
;     ca672
;     ca686
;     ca702
;     ca707
;     ca716
;     ca71f
;     ca72d
;     ca74b
;     ca75a
;     ca76d
;     ca788
;     ca797
;     ca7d4
;     ca826
;     ca845
;     ca850
;     ca860
;     ca892
;     ca8c2
;     ca8ca
;     ca8d8
;     ca8f2
;     ca905
;     ca90d
;     ca929
;     ca93c
;     ca944
;     ca94d
;     ca95b
;     ca97e
;     ca9f8
;     caa0a
;     caa1d
;     caa45
;     caa57
;     caa6f
;     caa81
;     caa90
;     caa9a
;     caaa4
;     caaae
;     caae0
;     cab01
;     cab19
;     cab2b
;     cab35
;     cab52
;     cab62
;     cab66
;     cab6e
;     cab74
;     cab77
;     cabbc
;     cabc0
;     cabd2
;     cabdc
;     cac07
;     caca3
;     cacad
;     cacbb
;     cacc8
;     cace7
;     cacf6
;     cad0a
;     cad1c
;     cad47
;     cad74
;     cad80
;     cad92
;     cad9c
;     cae0c
;     cae73
;     cae91
;     caefd
;     caf04
;     caf0b
;     caf3c
;     caf90
;     cafc1
;     cafd0
;     cafd7
;     caff6
;     cb01b
;     cb023
;     cb048
;     cb202
;     cb214
;     cb21f
;     cb22b
;     cb239
;     l0006
;     l0070
;     l0071
;     l0072
;     l0073
;     l0075
;     l0076
;     l0077
;     l0078
;     l0079
;     l007a
;     l007b
;     l007c
;     l007d
;     l007e
;     l007f
;     l0080
;     l0081
;     l0082
;     l0084
;     l0085
;     l0086
;     l0087
;     l0088
;     l0089
;     l008a
;     l008e
;     l008f
;     l00fd
;     l0103
;     l0403
;     l0500
;     l0501
;     l0502
;     l0503
;     l0504
;     l0505
;     l0506
;     l0507
;     l0508
;     l0509
;     l050a
;     l050b
;     l050c
;     l0580
;     l0600
;     l0680
;     l06a0
;     l06a1
;     l06a2
;     l06a3
;     l06a4
;     l06a5
;     l06a6
;     l06a7
;     l06a8
;     l06a9
;     l06aa
;     l06ab
;     l06ac
;     l06ad
;     l06ae
;     l06af
;     l06b0
;     l0700
;     l2003
;     l2004
;     l2005
;     l2006
;     l2007
;     l2008
;     l91c6
;     l91da
;     la6b1
;     lb02c
;     lb02d
;     lb05e
;     lb05f
;     loop_c805d
;     loop_c80db
;     loop_c81fd
;     loop_c8361
;     loop_c83d8
;     loop_c87e3
;     loop_c880f
;     loop_c88d1
;     loop_c89ad
;     loop_c8cf6
;     loop_c91cd
;     loop_c9cee
;     loop_c9e68
;     loop_c9fc2
;     loop_ca1f3
;     loop_ca303
;     loop_ca3ba
;     loop_ca537
;     loop_ca609
;     loop_ca6a0
;     loop_ca777
;     loop_ca912
;     loop_caeee
;     sub_c80a4
;     sub_c81a1
;     sub_c81c2
;     sub_c8378
;     sub_c83f0
;     sub_c8515
;     sub_c8559
;     sub_c863d
;     sub_c8696
;     sub_c86ef
;     sub_c876d
;     sub_c879a
;     sub_c887d
;     sub_c88b5
;     sub_c89ef
;     sub_c8a14
;     sub_c8b14
;     sub_c8bd1
;     sub_c8d73
;     sub_c8dfa
;     sub_c8e06
;     sub_c93e9
;     sub_c9fab
;     sub_ca5b0
;     sub_ca6af
;     sub_ca78f
;     sub_ca976
;     sub_cb007
;     sub_cb200
    assert (255 - inkey_key_shift) EOR 128 == &80
    assert <(l06a0) == &a0
    assert <(l0700) == &00
    assert >(l06a0) == &06
    assert >(l0700) == &07
    assert buffer_keyboard == &00
    assert osbyte_acknowledge_escape == &7e
    assert osbyte_enter_language == &8e
    assert osbyte_flush_buffer == &15
    assert osbyte_inkey == &81
    assert osbyte_read_write_basic_rom_bank == &bb
    assert osbyte_read_write_bell_duration == &d6
    assert osbyte_read_write_bell_frequency == &d5
    assert osbyte_read_write_last_break_type == &fd
    assert osbyte_scan_keyboard == &79
    assert osbyte_set_cursor_editing == &04
    assert osfile_load == &ff
    assert osfile_read_catalogue_info == &05
    assert osfile_save == &00
    assert osfind_close == &00
    assert osfind_open_input == &40
    assert osfind_open_output == &80

save pydis_start, pydis_end
