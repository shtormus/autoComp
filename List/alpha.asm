
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8
;Program type             : Application
;Clock frequency          : 8,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _temp_control=R5
	.DEF _bias=R4
	.DEF _Vop=R7
	.DEF _disp_config=R6
	.DEF _LcdCacheIdx=R8
	.DEF __outTemperature=R10
	.DEF __internalTemperature=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP _ext_int0_isr
	RJMP _ext_int1_isr
	RJMP 0x00
	RJMP _timer2_ovf_isr
	RJMP 0x00
	RJMP _timer1_compa_isr
	RJMP 0x00
	RJMP 0x00
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_table:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x2,0x0,0x1,0x3C,0x42,0x42,0x24,0x24
	.DB  0x92,0xFF,0x92,0x24,0x0,0x80,0xE0,0x20
	.DB  0x3A,0x23,0x13,0x8,0x64,0x62,0x36,0x49
	.DB  0x55,0x22,0x50,0x0,0x5,0x3,0x0,0x0
	.DB  0x0,0x1C,0x22,0x41,0x0,0x0,0x41,0x22
	.DB  0x1C,0x0,0x14,0x8,0x3E,0x8,0x14,0x8
	.DB  0x8,0x3E,0x8,0x8,0x0,0x50,0x30,0x0
	.DB  0x0,0x8,0x8,0x8,0x8,0x8,0x0,0x60
	.DB  0x60,0x0,0x0,0x20,0x10,0x8,0x4,0x2
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x5F
	.DB  0x0,0x0,0x0,0x7,0x0,0x7,0x0,0x14
	.DB  0x7F,0x14,0x7F,0x14,0x24,0x2A,0x7F,0x2A
	.DB  0x12,0x23,0x13,0x8,0x64,0x62,0x36,0x49
	.DB  0x55,0x22,0x50,0x0,0x5,0x3,0x0,0x0
	.DB  0x0,0x1C,0x22,0x41,0x0,0x0,0x41,0x22
	.DB  0x1C,0x0,0x14,0x8,0x3E,0x8,0x14,0x8
	.DB  0x8,0x3E,0x8,0x8,0x0,0x50,0x30,0x0
	.DB  0x0,0x8,0x8,0x8,0x8,0x8,0x0,0x60
	.DB  0x60,0x0,0x0,0x20,0x10,0x8,0x4,0x2
	.DB  0x0,0x0,0x0,0x0,0x0,0x81,0x0,0x0
	.DB  0x0,0x81,0x0,0x7,0x0,0x7,0x0,0x14
	.DB  0x7F,0x14,0x7F,0x14,0x24,0x2A,0x7F,0x2A
	.DB  0x12,0x23,0x13,0x8,0x64,0x62,0x36,0x49
	.DB  0x55,0x22,0x50,0x0,0x5,0x3,0x0,0x0
	.DB  0x0,0x1C,0x22,0x41,0x0,0x0,0x41,0x22
	.DB  0x1C,0x0,0x14,0x8,0x3E,0x8,0x14,0x8
	.DB  0x8,0x3E,0x8,0x8,0x0,0x50,0x30,0x0
	.DB  0x0,0x8,0x8,0x8,0x8,0x8,0x0,0x60
	.DB  0x60,0x0,0x0,0x20,0x10,0x8,0x4,0x2
	.DB  0x3E,0x51,0x49,0x45,0x3E,0x0,0x42,0x7F
	.DB  0x40,0x0,0x42,0x61,0x51,0x49,0x46,0x21
	.DB  0x41,0x45,0x4B,0x31,0x18,0x14,0x12,0x7F
	.DB  0x10,0x27,0x45,0x45,0x45,0x39,0x3C,0x4A
	.DB  0x49,0x49,0x30,0x1,0x71,0x9,0x5,0x3
	.DB  0x36,0x49,0x49,0x49,0x36,0x6,0x49,0x49
	.DB  0x29,0x1E,0x0,0x36,0x36,0x0,0x0,0x0
	.DB  0x56,0x36,0x0,0x0,0x8,0x14,0x22,0x41
	.DB  0x0,0x14,0x14,0x14,0x14,0x14,0x0,0x41
	.DB  0x22,0x14,0x8,0x2,0x1,0x51,0x9,0x6
	.DB  0x32,0x49,0x79,0x41,0x3E,0x7E,0x11,0x11
	.DB  0x11,0x7E,0x7F,0x49,0x49,0x49,0x36,0x3E
	.DB  0x41,0x41,0x41,0x22,0x7F,0x41,0x41,0x22
	.DB  0x1C,0x7F,0x49,0x49,0x49,0x41,0x7F,0x9
	.DB  0x9,0x9,0x1,0x3E,0x41,0x49,0x49,0x7A
	.DB  0x7F,0x8,0x8,0x8,0x7F,0x0,0x41,0x7F
	.DB  0x41,0x0,0x20,0x40,0x41,0x3F,0x1,0x7F
	.DB  0x8,0x14,0x22,0x41,0x7F,0x40,0x40,0x40
	.DB  0x40,0x7F,0x2,0xC,0x2,0x7F,0x7F,0x4
	.DB  0x8,0x10,0x7F,0x3E,0x41,0x41,0x41,0x3E
	.DB  0x7F,0x9,0x9,0x9,0x6,0x3E,0x41,0x51
	.DB  0x21,0x5E,0x7F,0x9,0x19,0x29,0x46,0x46
	.DB  0x49,0x49,0x49,0x31,0x1,0x1,0x7F,0x1
	.DB  0x1,0x3F,0x40,0x40,0x40,0x3F,0x1F,0x20
	.DB  0x40,0x20,0x1F,0x3F,0x40,0x38,0x40,0x3F
	.DB  0x63,0x14,0x8,0x14,0x63,0x7,0x8,0x70
	.DB  0x8,0x7,0x61,0x51,0x49,0x45,0x43,0x0
	.DB  0x7F,0x41,0x41,0x0,0x2,0x4,0x8,0x10
	.DB  0x20,0x0,0x41,0x41,0x7F,0x0,0x4,0x2
	.DB  0x1,0x2,0x4,0x40,0x40,0x40,0x40,0x40
	.DB  0x0,0x1,0x2,0x4,0x0,0x20,0x54,0x54
	.DB  0x54,0x78,0x7F,0x48,0x44,0x44,0x38,0x38
	.DB  0x44,0x44,0x44,0x20,0x38,0x44,0x44,0x48
	.DB  0x7F,0x38,0x54,0x54,0x54,0x18,0x8,0x7E
	.DB  0x9,0x1,0x2,0xC,0x52,0x52,0x52,0x3E
	.DB  0x7F,0x8,0x4,0x4,0x78,0x0,0x44,0x7D
	.DB  0x40,0x0,0x20,0x40,0x44,0x3D,0x0,0x7F
	.DB  0x10,0x28,0x44,0x0,0x0,0x41,0x7F,0x40
	.DB  0x0,0x7C,0x4,0x18,0x4,0x78,0x7C,0x8
	.DB  0x4,0x4,0x78,0x38,0x44,0x44,0x44,0x38
	.DB  0x7C,0x14,0x14,0x14,0x8,0x8,0x14,0x14
	.DB  0x18,0x7C,0x7C,0x8,0x4,0x4,0x8,0x48
	.DB  0x54,0x54,0x54,0x20,0x4,0x3F,0x44,0x40
	.DB  0x20,0x3C,0x40,0x40,0x20,0x7C,0x1C,0x20
	.DB  0x40,0x20,0x1C,0x3C,0x40,0x30,0x40,0x3C
	.DB  0x44,0x28,0x10,0x28,0x44,0xC,0x50,0x50
	.DB  0x50,0x3C,0x44,0x64,0x54,0x4C,0x44,0x0
	.DB  0x8,0x36,0x41,0x0,0x0,0x0,0x7F,0x0
	.DB  0x0,0x0,0x41,0x36,0x8,0x0,0x10,0x8
	.DB  0x8,0x10,0x8,0x78,0x46,0x41,0x46,0x78
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x5F
	.DB  0x0,0x0,0x0,0x7,0x0,0x7,0x0,0x14
	.DB  0x7F,0x14,0x7F,0x14,0x24,0x2A,0x7F,0x2A
	.DB  0x12,0x23,0x13,0x8,0x64,0x62,0x36,0x49
	.DB  0x55,0x22,0x50,0x0,0x5,0x3,0x0,0x0
	.DB  0x0,0x1C,0x22,0x41,0x0,0x0,0x41,0x22
	.DB  0x1C,0x0,0x14,0x8,0x3E,0x8,0x14,0x8
	.DB  0x8,0x3E,0x8,0x8,0x0,0x50,0x30,0x0
	.DB  0x0,0x8,0x8,0x8,0x8,0x8,0x0,0x60
	.DB  0x60,0x0,0x0,0x20,0x10,0x8,0x4,0x2
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x5F
	.DB  0x0,0x0,0x0,0x7,0x0,0x7,0x0,0x14
	.DB  0x7F,0x14,0x7F,0x14,0x24,0x2A,0x7F,0x2A
	.DB  0x12,0x23,0x13,0x8,0x64,0x62,0x36,0x49
	.DB  0x55,0x22,0x50,0x0,0x5,0x3,0x0,0x0
	.DB  0x0,0x1C,0x22,0x41,0x0,0x0,0x41,0x22
	.DB  0x1C,0x0,0x14,0x8,0x3E,0x8,0x14,0x8
	.DB  0x8,0x3E,0x8,0x8,0x0,0x50,0x30,0x0
	.DB  0x0,0x8,0x8,0x8,0x8,0x8,0x0,0x60
	.DB  0x60,0x0,0x0,0x20,0x10,0x8,0x4,0x2
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x5F
	.DB  0x0,0x0,0x0,0x7,0x0,0x7,0x0,0x14
	.DB  0x7F,0x14,0x7F,0x14,0x24,0x2A,0x7F,0x2A
	.DB  0x12,0x23,0x13,0x8,0x64,0x62,0x36,0x49
	.DB  0x55,0x22,0x50,0x0,0x5,0x3,0x0,0x0
	.DB  0x0,0x1C,0x22,0x41,0x0,0x0,0x41,0x22
	.DB  0x1C,0x0,0x14,0x8,0x3E,0x8,0x14,0x8
	.DB  0x8,0x3E,0x8,0x8,0x0,0x50,0x30,0x0
	.DB  0x0,0x8,0x8,0x8,0x8,0x8,0x0,0x60
	.DB  0x60,0x0,0x0,0x20,0x10,0x8,0x4,0x2
	.DB  0x3E,0x51,0x49,0x45,0x3E,0x0,0x42,0x7F
	.DB  0x40,0x0,0x42,0x61,0x51,0x49,0x46,0x21
	.DB  0x41,0x45,0x4B,0x31,0x18,0x14,0x12,0x7F
	.DB  0x10,0x27,0x45,0x45,0x45,0x39,0x3C,0x4A
	.DB  0x49,0x49,0x30,0x1,0x71,0x9,0x5,0x3
	.DB  0x36,0x49,0x49,0x49,0x36,0x6,0x49,0x49
	.DB  0x29,0x1E,0x0,0x36,0x36,0x0,0x0,0x0
	.DB  0x56,0x36,0x0,0x0,0x8,0x14,0x22,0x41
	.DB  0x0,0x14,0x14,0x14,0x14,0x14,0x0,0x41
	.DB  0x22,0x14,0x8,0x2,0x1,0x51,0x9,0x6
	.DB  0x7E,0x11,0x11,0x11,0x7E,0x7F,0x49,0x49
	.DB  0x49,0x31,0x7F,0x49,0x49,0x49,0x36,0x7F
	.DB  0x1,0x1,0x1,0x3,0x70,0x29,0x27,0x21
	.DB  0x7F,0x7F,0x49,0x49,0x49,0x41,0x77,0x8
	.DB  0x7F,0x8,0x77,0x41,0x41,0x41,0x49,0x76
	.DB  0x7F,0x10,0x8,0x4,0x7F,0x7F,0x10,0x9
	.DB  0x4,0x7F,0x7F,0x8,0x14,0x22,0x41,0x20
	.DB  0x41,0x3F,0x1,0x7F,0x7F,0x2,0xC,0x2
	.DB  0x7F,0x7F,0x8,0x8,0x8,0x7F,0x3E,0x41
	.DB  0x41,0x41,0x3E,0x7F,0x1,0x1,0x1,0x7F
	.DB  0x7F,0x9,0x9,0x9,0x6,0x3E,0x41,0x41
	.DB  0x41,0x22,0x1,0x1,0x7F,0x1,0x1,0x47
	.DB  0x28,0x10,0x8,0x7,0x1E,0x21,0x7F,0x21
	.DB  0x1E,0x63,0x14,0x8,0x14,0x63,0x3F,0x20
	.DB  0x20,0x20,0x5F,0x7,0x8,0x8,0x8,0x7F
	.DB  0x7F,0x40,0x7F,0x40,0x7F,0x3F,0x20,0x3F
	.DB  0x20,0x5F,0x1,0x7F,0x48,0x48,0x30,0x7F
	.DB  0x48,0x30,0x0,0x7F,0x0,0x7F,0x48,0x48
	.DB  0x30,0x41,0x41,0x41,0x49,0x3E,0x7F,0x8
	.DB  0x3E,0x41,0x3E,0x46,0x29,0x19,0x9,0x7F
	.DB  0x20,0x54,0x54,0x54,0x78,0x3C,0x4A,0x4A
	.DB  0x49,0x31,0x7C,0x54,0x54,0x28,0x0,0x7C
	.DB  0x4,0x4,0x4,0xC,0x72,0x2A,0x26,0x22
	.DB  0x7E,0x38,0x54,0x54,0x54,0x18,0x6C,0x10
	.DB  0x7C,0x10,0x6C,0x44,0x44,0x54,0x54,0x38
	.DB  0x7C,0x20,0x10,0x8,0x7C,0x7C,0x21,0x12
	.DB  0x9,0x7C,0x7C,0x10,0x28,0x44,0x0,0x20
	.DB  0x44,0x3C,0x4,0x7C,0x7C,0x8,0x10,0x8
	.DB  0x7C,0x7C,0x10,0x10,0x10,0x7C,0x38,0x44
	.DB  0x44,0x44,0x38,0x7C,0x4,0x4,0x4,0x7C
	.DB  0x7C,0x14,0x14,0x14,0x8,0x38,0x44,0x44
	.DB  0x44,0x20,0x4,0x4,0x7C,0x4,0x4,0x44
	.DB  0x28,0x10,0x8,0x4,0x8,0x14,0x7E,0x14
	.DB  0x8,0x44,0x28,0x10,0x28,0x44,0x3C,0x40
	.DB  0x40,0x7C,0x40,0xC,0x10,0x10,0x10,0x7C
	.DB  0x7C,0x40,0x7C,0x40,0x7C,0x3C,0x20,0x3C
	.DB  0x20,0x7C,0x4,0x7C,0x50,0x50,0x20,0x7C
	.DB  0x50,0x20,0x0,0x7C,0x0,0x7C,0x50,0x50
	.DB  0x20,0x28,0x44,0x44,0x54,0x38,0x7C,0x10
	.DB  0x38,0x44,0x38,0x48,0x54,0x34,0x14,0x7C
_pic1:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0xFC,0x4,0x4
	.DB  0x4,0xFC,0x8,0x8,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0xFC,0x4,0x4,0xFC,0x20,0x20,0x0
	.DB  0x0,0xFF,0x0,0x0,0x0,0xFF,0x2,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x40,0x40,0x40,0xFF,0x0,0x0
	.DB  0xFF,0x4,0x4,0x0,0x0,0xFF,0x0,0x0
	.DB  0x0,0xFF,0x81,0x1,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x10,0x10
	.DB  0x92,0xFF,0x0,0x0,0xFF,0x0,0x0,0x0
	.DB  0x0,0x7F,0x40,0x40,0x40,0x7F,0x10,0x10
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x4,0x4,0x24,0xFF,0x0,0x0
	.DB  0xFF,0x0,0x0,0x0,0x80,0xFF,0xF9,0xF9
	.DB  0xF9,0xFF,0x90,0x22,0x3C,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x1C,0x3E
	.DB  0x7F,0xF7,0x81,0xB7,0xFD,0x7F,0x3E,0x1C
_icon:
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0x81,0xFD,0x91,0xFD,0x81
	.DB  0xB9,0xC5,0xC5,0xB9,0x81,0x85,0xFD,0x85
	.DB  0x81,0xDD,0x81,0xFF,0x0,0xFE,0x82,0x93
	.DB  0x93,0x92,0x82,0x82,0x82,0x82,0x92,0xBB
	.DB  0x93,0x82,0xFE,0x0,0x0,0x0,0x0,0xFF
	.DB  0x81,0xDD,0x81,0xFF,0x0,0x49,0x2A,0x1C
	.DB  0x7F,0x1C,0x2A,0x49,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0
_conv_delay_G100:
	.DB  0x64,0x0,0xC8,0x0,0x90,0x1,0x20,0x3
_bit_mask_G100:
	.DB  0xF8,0xFF,0xFC,0xFF,0xFE,0xFF,0xFF,0xFF
_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x7C:
	.DB  0x1
_0x7D:
	.DB  0x2
_0x9D:
	.DB  0x3,0x3,0x2,0x50
_0x0:
	.DB  0x25,0x33,0x75,0x0,0x25,0x75,0x0,0x25
	.DB  0x33,0x69,0x2,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x01
	.DW  _outTempDevice
	.DW  _0x7C*2

	.DW  0x01
	.DW  _internalTempDevice
	.DW  _0x7D*2

	.DW  0x04
	.DW  0x04
	.DW  _0x9D*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.3 Standard
;Automatic Program Generator
;© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 21.03.2014
;Author  : PerTic@n
;Company : If You Like This Software,Buy It
;Comments:
;
;
;Chip type               : ATmega8
;Program type            : Application
;AVR Core Clock frequency: 8,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;#include <delay.h>
;
;// 1 Wire Bus interface functions
;//#include <1wire.h>
;
;// DS1820 Temperature Sensor functions
;#include <ds18b20.h>
;
;#include <stdio.h>
;#include <custom_menu.c>
;#include <n3310lcd.c>
;/**********************************************
;****************PCD8544 Driver*****************
;**********************************************
;
;for original NOKIA 3310 & alternative "chinese" version of display
;
;48x84 dots, 6x14 symbols
;
;**********************************************/
;
;//#define china 0	//если определено - работаем по алгоритмам "китайского" дисплея, иначе - оригинального
;
;//LCD Port & pinout setup
;#define LCD_PORT		    PORTB
;#define LCD_DDR        		DDRB
;
;#define LCD_DC_PIN        	    2  //любой пин порта
;#define LCD_CE_PIN              1  //любой пин порта
;#define SPI_MOSI_PIN            3  //должен быть соответствующий пин аппаратного SPI
;#define LCD_RST_PIN             0  //любой пин порта
;#define SPI_CLK_PIN             5  //должен быть соответствующий пин аппаратного SPI
;
;//***********************************************************
;//Настройки контроллера дисплея и пеерменные для работы с ним
;//***********************************************************
;
;unsigned char lcd_buf[14];		//текстовый буфер для вывода на LCD
;
;bit power_down = 0;			//power-down control: 0 - chip is active, 1 - chip is in PD-mode
;bit addressing = 0;			//направление адресации: 0 - горизонтальная, 1- вертикальная
;//bit instuct_set = 0;			//набор инструкций: 0 - стандартный, 1 - расширенный - в текущей версии не используется
;
;#ifdef china
;bit x_mirror = 0;			//зеркалирование по X: 0 - выкл., 1 - вкл.
;bit y_mirror = 0;			//зеркалирование по Y: 0 - выкл., 1 - вкл.
;bit SPI_invert = 0;			//порядок битов в SPI: 0 - MSB first, 1 - LSB first
;#endif
;
;//unsigned char set_y;			//адрес по У, 0..5 - в текущей версии не используется
;//unsigned char set_x;                 	//адрес по Х, 0..83 - в текущей версии не используется
;unsigned char temp_control = 3;  	//температурный коэффициент, 0..3
;unsigned char bias = 3;                 //смещение, 0..7
;unsigned char Vop = 80;			//рабочее напрядение LCD, 0..127 (определяет контрастность)
;unsigned char disp_config = 2;		//режим дисплея: 0 - blank, 1 - all on, 2 - normal, 3 - inverse
;
;#ifdef china
;unsigned char shift = 5;		//0..3F - сдвиг экрана вверх, в точках
;#endif
;
;#define PIXEL_OFF	0		//режимы отображения пикселя - используются в графических функциях
;#define PIXEL_ON	1
;#define PIXEL_XOR	2
;
;#define LCD_X_RES               84	//разрешение экрана
;#define LCD_Y_RES               48
;#define LCD_CACHE_SIZE          LCD_X_RES*LCD_Y_RES/8
;
;#define Cntr_X_RES              102    	//разрешение контроллера - предполагаемое - но работает))
;#define Cntr_Y_RES              64
;#define Cntr_buf_size           Cntr_X_RES*Cntr_Y_RES/8
;
;unsigned char  LcdCache [LCD_CACHE_SIZE];	//Cache buffer in SRAM 84*48 bits or 504 bytes
;unsigned int   LcdCacheIdx;              	//Cache index
;
;#define LCD_CMD         0
;#define LCD_DATA        1
;
;//***************************************************
;//****************Прототипы функций******************
;//***************************************************
;void LcdSend (unsigned char data, unsigned char cmd);    			//Sends data to display controller
;void LcdUpdate (void);   							//Copies the LCD cache into the device RAM
;void LcdClear (void);    							//Clears the display
;void LcdInit ( void );								//Настройка SPI и дисплея
;void LcdContrast (unsigned char contrast); 					//contrast -> Contrast value from 0x00 to 0x7F
;void LcdMode (unsigned char mode); 						//режимы дисплея: 0 - blank, 1 - all on, 2 - normal, 3 - inverse
;void LcdPwrMode (void);								//инвертирует состояние вкл/выкл дисплея
;void LcdImage (flash unsigned char *imageData);					//вывод изображения
;void LcdPixel (unsigned char x, unsigned char y, unsigned char mode);     	//Displays a pixel at given absolute (x, y) location, mode -> Off, On or Xor
;void LcdLine (int x1, int y1, int x2, int y2, unsigned char mode);  		//Draws a line between two points on the display
;void LcdCircle(char x, char y, char radius, unsigned char mode);		//рисуем круг с координатами центра и радиусом
;void LcdBar(int x1, int y1, int x2, int y2, unsigned char persent);		//рисуем батарейку и заполняем ее на %
;void LcdGotoXYFont (unsigned char x, unsigned char y);   			//Sets cursor location to xy location. Range: 1,1 .. 14,6
;void clean_lcd_buf (void);							//очистка текстового буфера
;void LcdChr (int ch);								//Displays a character at current cursor location and increment cursor location
;void LcdString (unsigned char x, unsigned char y);				//Displays a string at current cursor location
;void LcdChrBold (int ch);							//Печатает символ на текущем месте, большой и жирный)
;void LcdStringBold (unsigned char x, unsigned char y);				//Печатает большую и жирную строку
;void LcdChrBig (int ch);							//Печатает символ на текущем месте, большой
;void LcdStringBig (unsigned char x, unsigned char y);				//Печатает большую строку
;//***************************************************
;
;//ASCII
;flash char table[0x0500] =
;{
;0x00, 0x00, 0x00, 0x00, 0x00,// 00
;0x00, 0x00, 0x00, 0x02, 0x00,// 01
;0x01, 0x3C, 0x42, 0x42, 0x24,// 02 значек цельсия
;0x24, 0x92, 0xFF, 0x92, 0x24,// 03 ёлочка
;0x00, 0x80, 0xE0, 0x20, 0x3A,// 04 пасажир
;0x23, 0x13, 0x08, 0x64, 0x62,// 05
;0x36, 0x49, 0x55, 0x22, 0x50,// 06
;0x00, 0x05, 0x03, 0x00, 0x00,// 07
;0x00, 0x1C, 0x22, 0x41, 0x00,// 08
;0x00, 0x41, 0x22, 0x1C, 0x00,// 09
;0x14, 0x08, 0x3E, 0x08, 0x14,// 0A
;0x08, 0x08, 0x3E, 0x08, 0x08,// 0B
;0x00, 0x50, 0x30, 0x00, 0x00,// 0C
;0x08, 0x08, 0x08, 0x08, 0x08,// 0D
;0x00, 0x60, 0x60, 0x00, 0x00,// 0E
;0x20, 0x10, 0x08, 0x04, 0x02,// 0F
;0x00, 0x00, 0x00, 0x00, 0x00,// 10
;0x00, 0x00, 0x5F, 0x00, 0x00,// 11
;0x00, 0x07, 0x00, 0x07, 0x00,// 12
;0x14, 0x7F, 0x14, 0x7F, 0x14,// 13
;0x24, 0x2A, 0x7F, 0x2A, 0x12,// 14
;0x23, 0x13, 0x08, 0x64, 0x62,// 15
;0x36, 0x49, 0x55, 0x22, 0x50,// 16
;0x00, 0x05, 0x03, 0x00, 0x00,// 17
;0x00, 0x1C, 0x22, 0x41, 0x00,// 18
;0x00, 0x41, 0x22, 0x1C, 0x00,// 19
;0x14, 0x08, 0x3E, 0x08, 0x14,// 1A
;0x08, 0x08, 0x3E, 0x08, 0x08,// 1B
;0x00, 0x50, 0x30, 0x00, 0x00,// 1C
;0x08, 0x08, 0x08, 0x08, 0x08,// 1D
;0x00, 0x60, 0x60, 0x00, 0x00,// 1E
;0x20, 0x10, 0x08, 0x04, 0x02,// 1F
;0x00, 0x00, 0x00, 0x00, 0x00,// 20 space
;0x81, 0x00, 0x00, 0x00, 0x81,// 21 ! 0x00, 0x5F, 0x00, 0x00,
;0x00, 0x07, 0x00, 0x07, 0x00,// 22 "
;0x14, 0x7F, 0x14, 0x7F, 0x14,// 23 #
;0x24, 0x2A, 0x7F, 0x2A, 0x12,// 24 $
;0x23, 0x13, 0x08, 0x64, 0x62,// 25 %
;0x36, 0x49, 0x55, 0x22, 0x50,// 26 &
;0x00, 0x05, 0x03, 0x00, 0x00,// 27 '
;0x00, 0x1C, 0x22, 0x41, 0x00,// 28 (
;0x00, 0x41, 0x22, 0x1C, 0x00,// 29 )
;0x14, 0x08, 0x3E, 0x08, 0x14,// 2a *
;0x08, 0x08, 0x3E, 0x08, 0x08,// 2b +
;0x00, 0x50, 0x30, 0x00, 0x00,// 2c ,
;0x08, 0x08, 0x08, 0x08, 0x08,// 2d -
;0x00, 0x60, 0x60, 0x00, 0x00,// 2e .
;0x20, 0x10, 0x08, 0x04, 0x02,// 2f /
;0x3E, 0x51, 0x49, 0x45, 0x3E,// 30 0
;0x00, 0x42, 0x7F, 0x40, 0x00,// 31 1
;0x42, 0x61, 0x51, 0x49, 0x46,// 32 2
;0x21, 0x41, 0x45, 0x4B, 0x31,// 33 3
;0x18, 0x14, 0x12, 0x7F, 0x10,// 34 4
;0x27, 0x45, 0x45, 0x45, 0x39,// 35 5
;0x3C, 0x4A, 0x49, 0x49, 0x30,// 36 6
;0x01, 0x71, 0x09, 0x05, 0x03,// 37 7
;0x36, 0x49, 0x49, 0x49, 0x36,// 38 8
;0x06, 0x49, 0x49, 0x29, 0x1E,// 39 9
;0x00, 0x36, 0x36, 0x00, 0x00,// 3a :
;0x00, 0x56, 0x36, 0x00, 0x00,// 3b ;
;0x08, 0x14, 0x22, 0x41, 0x00,// 3c <
;0x14, 0x14, 0x14, 0x14, 0x14,// 3d =
;0x00, 0x41, 0x22, 0x14, 0x08,// 3e >
;0x02, 0x01, 0x51, 0x09, 0x06,// 3f ?
;0x32, 0x49, 0x79, 0x41, 0x3E,// 40 @
;0x7E, 0x11, 0x11, 0x11, 0x7E,// 41 A
;0x7F, 0x49, 0x49, 0x49, 0x36,// 42 B
;0x3E, 0x41, 0x41, 0x41, 0x22,// 43 C
;0x7F, 0x41, 0x41, 0x22, 0x1C,// 44 D
;0x7F, 0x49, 0x49, 0x49, 0x41,// 45 E
;0x7F, 0x09, 0x09, 0x09, 0x01,// 46 F
;0x3E, 0x41, 0x49, 0x49, 0x7A,// 47 G
;0x7F, 0x08, 0x08, 0x08, 0x7F,// 48 H
;0x00, 0x41, 0x7F, 0x41, 0x00,// 49 I
;0x20, 0x40, 0x41, 0x3F, 0x01,// 4a J
;0x7F, 0x08, 0x14, 0x22, 0x41,// 4b K
;0x7F, 0x40, 0x40, 0x40, 0x40,// 4c L
;0x7F, 0x02, 0x0C, 0x02, 0x7F,// 4d M
;0x7F, 0x04, 0x08, 0x10, 0x7F,// 4e N
;0x3E, 0x41, 0x41, 0x41, 0x3E,// 4f O
;0x7F, 0x09, 0x09, 0x09, 0x06,// 50 P
;0x3E, 0x41, 0x51, 0x21, 0x5E,// 51 Q
;0x7F, 0x09, 0x19, 0x29, 0x46,// 52 R
;0x46, 0x49, 0x49, 0x49, 0x31,// 53 S
;0x01, 0x01, 0x7F, 0x01, 0x01,// 54 T
;0x3F, 0x40, 0x40, 0x40, 0x3F,// 55 U
;0x1F, 0x20, 0x40, 0x20, 0x1F,// 56 V
;0x3F, 0x40, 0x38, 0x40, 0x3F,// 57 W
;0x63, 0x14, 0x08, 0x14, 0x63,// 58 X
;0x07, 0x08, 0x70, 0x08, 0x07,// 59 Y
;0x61, 0x51, 0x49, 0x45, 0x43,// 5a Z
;0x00, 0x7F, 0x41, 0x41, 0x00,// 5b [
;0x02, 0x04, 0x08, 0x10, 0x20,// 5c Yen Currency Sign
;0x00, 0x41, 0x41, 0x7F, 0x00,// 5d ]
;0x04, 0x02, 0x01, 0x02, 0x04,// 5e ^
;0x40, 0x40, 0x40, 0x40, 0x40,// 5f _
;0x00, 0x01, 0x02, 0x04, 0x00,// 60 `
;0x20, 0x54, 0x54, 0x54, 0x78,// 61 a
;0x7F, 0x48, 0x44, 0x44, 0x38,// 62 b
;0x38, 0x44, 0x44, 0x44, 0x20,// 63 c
;0x38, 0x44, 0x44, 0x48, 0x7F,// 64 d
;0x38, 0x54, 0x54, 0x54, 0x18,// 65 e
;0x08, 0x7E, 0x09, 0x01, 0x02,// 66 f
;0x0C, 0x52, 0x52, 0x52, 0x3E,// 67 g
;0x7F, 0x08, 0x04, 0x04, 0x78,// 68 h
;0x00, 0x44, 0x7D, 0x40, 0x00,// 69 i
;0x20, 0x40, 0x44, 0x3D, 0x00,// 6a j
;0x7F, 0x10, 0x28, 0x44, 0x00,// 6b k
;0x00, 0x41, 0x7F, 0x40, 0x00,// 6c l
;0x7C, 0x04, 0x18, 0x04, 0x78,// 6d m
;0x7C, 0x08, 0x04, 0x04, 0x78,// 6e n
;0x38, 0x44, 0x44, 0x44, 0x38,// 6f o
;0x7C, 0x14, 0x14, 0x14, 0x08,// 70 p
;0x08, 0x14, 0x14, 0x18, 0x7C,// 71 q
;0x7C, 0x08, 0x04, 0x04, 0x08,// 72 r
;0x48, 0x54, 0x54, 0x54, 0x20,// 73 s
;0x04, 0x3F, 0x44, 0x40, 0x20,// 74 t
;0x3C, 0x40, 0x40, 0x20, 0x7C,// 75 u
;0x1C, 0x20, 0x40, 0x20, 0x1C,// 76 v
;0x3C, 0x40, 0x30, 0x40, 0x3C,// 77 w
;0x44, 0x28, 0x10, 0x28, 0x44,// 78 x
;0x0C, 0x50, 0x50, 0x50, 0x3C,// 79 y
;0x44, 0x64, 0x54, 0x4C, 0x44,// 7a z
;0x00, 0x08, 0x36, 0x41, 0x00,// 7b <
;0x00, 0x00, 0x7F, 0x00, 0x00,// 7c |
;0x00, 0x41, 0x36, 0x08, 0x00,// 7d >
;0x10, 0x08, 0x08, 0x10, 0x08,// 7e Right Arrow ->
;0x78, 0x46, 0x41, 0x46, 0x78,// 7f Left Arrow <-
;0x00, 0x00, 0x00, 0x00, 0x00,// 80
;0x00, 0x00, 0x5F, 0x00, 0x00,// 81
;0x00, 0x07, 0x00, 0x07, 0x00,// 82
;0x14, 0x7F, 0x14, 0x7F, 0x14,// 83
;0x24, 0x2A, 0x7F, 0x2A, 0x12,// 84
;0x23, 0x13, 0x08, 0x64, 0x62,// 85
;0x36, 0x49, 0x55, 0x22, 0x50,// 86
;0x00, 0x05, 0x03, 0x00, 0x00,// 87
;0x00, 0x1C, 0x22, 0x41, 0x00,// 88
;0x00, 0x41, 0x22, 0x1C, 0x00,// 89
;0x14, 0x08, 0x3E, 0x08, 0x14,// 8A
;0x08, 0x08, 0x3E, 0x08, 0x08,// 8B
;0x00, 0x50, 0x30, 0x00, 0x00,// 8C
;0x08, 0x08, 0x08, 0x08, 0x08,// 8D
;0x00, 0x60, 0x60, 0x00, 0x00,// 8E
;0x20, 0x10, 0x08, 0x04, 0x02,// 8F
;0x00, 0x00, 0x00, 0x00, 0x00,// 90
;0x00, 0x00, 0x5F, 0x00, 0x00,// 91
;0x00, 0x07, 0x00, 0x07, 0x00,// 92
;0x14, 0x7F, 0x14, 0x7F, 0x14,// 93
;0x24, 0x2A, 0x7F, 0x2A, 0x12,// 94
;0x23, 0x13, 0x08, 0x64, 0x62,// 95
;0x36, 0x49, 0x55, 0x22, 0x50,// 96
;0x00, 0x05, 0x03, 0x00, 0x00,// 97
;0x00, 0x1C, 0x22, 0x41, 0x00,// 98
;0x00, 0x41, 0x22, 0x1C, 0x00,// 99
;0x14, 0x08, 0x3E, 0x08, 0x14,// 9A
;0x08, 0x08, 0x3E, 0x08, 0x08,// 9B
;0x00, 0x50, 0x30, 0x00, 0x00,// 9C
;0x08, 0x08, 0x08, 0x08, 0x08,// 9D
;0x00, 0x60, 0x60, 0x00, 0x00,// 9E
;0x20, 0x10, 0x08, 0x04, 0x02,// 9F
;0x00, 0x00, 0x00, 0x00, 0x00,// A0
;0x00, 0x00, 0x5F, 0x00, 0x00,// A1
;0x00, 0x07, 0x00, 0x07, 0x00,// A2
;0x14, 0x7F, 0x14, 0x7F, 0x14,// A3
;0x24, 0x2A, 0x7F, 0x2A, 0x12,// A4
;0x23, 0x13, 0x08, 0x64, 0x62,// A5
;0x36, 0x49, 0x55, 0x22, 0x50,// A6
;0x00, 0x05, 0x03, 0x00, 0x00,// A7
;0x00, 0x1C, 0x22, 0x41, 0x00,// A8
;0x00, 0x41, 0x22, 0x1C, 0x00,// A9
;0x14, 0x08, 0x3E, 0x08, 0x14,// AA
;0x08, 0x08, 0x3E, 0x08, 0x08,// AB
;0x00, 0x50, 0x30, 0x00, 0x00,// AC
;0x08, 0x08, 0x08, 0x08, 0x08,// AD
;0x00, 0x60, 0x60, 0x00, 0x00,// AE
;0x20, 0x10, 0x08, 0x04, 0x02,// AF
;0x3E, 0x51, 0x49, 0x45, 0x3E,// B0
;0x00, 0x42, 0x7F, 0x40, 0x00,// B1
;0x42, 0x61, 0x51, 0x49, 0x46,// B2
;0x21, 0x41, 0x45, 0x4B, 0x31,// B3
;0x18, 0x14, 0x12, 0x7F, 0x10,// B4
;0x27, 0x45, 0x45, 0x45, 0x39,// B5
;0x3C, 0x4A, 0x49, 0x49, 0x30,// B6
;0x01, 0x71, 0x09, 0x05, 0x03,// B7
;0x36, 0x49, 0x49, 0x49, 0x36,// B8
;0x06, 0x49, 0x49, 0x29, 0x1E,// B9
;0x00, 0x36, 0x36, 0x00, 0x00,// BA
;0x00, 0x56, 0x36, 0x00, 0x00,// BB
;0x08, 0x14, 0x22, 0x41, 0x00,// BC
;0x14, 0x14, 0x14, 0x14, 0x14,// BD
;0x00, 0x41, 0x22, 0x14, 0x08,// BE
;0x02, 0x01, 0x51, 0x09, 0x06,// BF
;0x7E, 0x11, 0x11, 0x11, 0x7E,// C0 ?
;0x7F, 0x49, 0x49, 0x49, 0x31,// C1 ?
;0x7F, 0x49, 0x49, 0x49, 0x36,// C2 ?
;0x7F, 0x01, 0x01, 0x01, 0x03,// C3 ?
;0x70, 0x29, 0x27, 0x21, 0x7F,// C4 ?
;0x7F, 0x49, 0x49, 0x49, 0x41,// C5 ?
;0x77, 0x08, 0x7F, 0x08, 0x77,// C6 ?
;0x41, 0x41, 0x41, 0x49, 0x76,// C7 ?
;0x7F, 0x10, 0x08, 0x04, 0x7F,// C8 ?
;0x7F, 0x10, 0x09, 0x04, 0x7F,// C9 ?
;0x7F, 0x08, 0x14, 0x22, 0x41,// CA ?
;0x20, 0x41, 0x3F, 0x01, 0x7F,// CB ?
;0x7F, 0x02, 0x0C, 0x02, 0x7F,// CC ?
;0x7F, 0x08, 0x08, 0x08, 0x7F,// CD ?
;0x3E, 0x41, 0x41, 0x41, 0x3E,// CE ?
;0x7F, 0x01, 0x01, 0x01, 0x7F,// CF ?
;0x7F, 0x09, 0x09, 0x09, 0x06,// D0 ?
;0x3E, 0x41, 0x41, 0x41, 0x22,// D1 ?
;0x01, 0x01, 0x7F, 0x01, 0x01,// D2 ?
;0x47, 0x28, 0x10, 0x08, 0x07,// D3 ?
;0x1E, 0x21, 0x7F, 0x21, 0x1E,// D4 ?
;0x63, 0x14, 0x08, 0x14, 0x63,// D5 ?
;0x3F, 0x20, 0x20, 0x20, 0x5F,// D6 ?
;0x07, 0x08, 0x08, 0x08, 0x7F,// D7 ?
;0x7F, 0x40, 0x7F, 0x40, 0x7F,// D8 ?
;0x3F, 0x20, 0x3F, 0x20, 0x5F,// D9 ?
;0x01, 0x7F, 0x48, 0x48, 0x30,// DA ?
;0x7F, 0x48, 0x30, 0x00, 0x7F,// DB ?
;0x00, 0x7F, 0x48, 0x48, 0x30,// DC ?
;0x41, 0x41, 0x41, 0x49, 0x3E,// DD ?
;0x7F, 0x08, 0x3E, 0x41, 0x3E,// DE ?
;0x46, 0x29, 0x19, 0x09, 0x7F,// DF ?
;0x20, 0x54, 0x54, 0x54, 0x78,// E0 ?
;0x3C, 0x4A, 0x4A, 0x49, 0x31,// E1 ?
;0x7C, 0x54, 0x54, 0x28, 0x00,// E2 ?
;0x7C, 0x04, 0x04, 0x04, 0x0C,// E3 ?
;0x72, 0x2A, 0x26, 0x22, 0x7E,// E4 ?
;0x38, 0x54, 0x54, 0x54, 0x18,// E5 ?
;0x6C, 0x10, 0x7C, 0x10, 0x6C,// E6 ?
;0x44, 0x44, 0x54, 0x54, 0x38,// E7 ?
;0x7C, 0x20, 0x10, 0x08, 0x7C,// E8 ?
;0x7C, 0x21, 0x12, 0x09, 0x7C,// E9 ?
;0x7C, 0x10, 0x28, 0x44, 0x00,// EA ?
;0x20, 0x44, 0x3C, 0x04, 0x7C,// EB ?
;0x7C, 0x08, 0x10, 0x08, 0x7C,// EC ?
;0x7C, 0x10, 0x10, 0x10, 0x7C,// ED ?
;0x38, 0x44, 0x44, 0x44, 0x38,// EE ?
;0x7C, 0x04, 0x04, 0x04, 0x7C,// EF ?
;0x7C, 0x14, 0x14, 0x14, 0x08,// F0 ?
;0x38, 0x44, 0x44, 0x44, 0x20,// F1 ?
;0x04, 0x04, 0x7C, 0x04, 0x04,// F2 ?
;0x44, 0x28, 0x10, 0x08, 0x04,// F3 ?
;0x08, 0x14, 0x7E, 0x14, 0x08,// F4 ?
;0x44, 0x28, 0x10, 0x28, 0x44,// F5 ?
;0x3C, 0x40, 0x40, 0x7C, 0x40,// F6 ?
;0x0C, 0x10, 0x10, 0x10, 0x7C,// F7 ?
;0x7C, 0x40, 0x7C, 0x40, 0x7C,// F8 ?
;0x3C, 0x20, 0x3C, 0x20, 0x7C,// F9 ?
;0x04, 0x7C, 0x50, 0x50, 0x20,// FA ?
;0x7C, 0x50, 0x20, 0x00, 0x7C,// FB ?
;0x00, 0x7C, 0x50, 0x50, 0x20,// FC ?
;0x28, 0x44, 0x44, 0x54, 0x38,// FD ?
;0x7C, 0x10, 0x38, 0x44, 0x38,// FE ?
;0x48, 0x54, 0x34, 0x14, 0x7C }; // FF
;
;void LcdSend (unsigned char data, unsigned char cmd)    //Sends data to display controller
; 0000 0023         {

	.CSEG
_LcdSend:
;        LCD_PORT.LCD_CE_PIN = 0;                //Enable display controller (active low)
	ST   -Y,R26
;	data -> Y+1
;	cmd -> Y+0
	CBI  0x18,1
;
;        if (cmd) LCD_PORT.LCD_DC_PIN = 1;	//выбираем команда или данные
	LD   R30,Y
	CPI  R30,0
	BREQ _0x5
	SBI  0x18,2
;                else LCD_PORT.LCD_DC_PIN = 0;
	RJMP _0x8
_0x5:
	CBI  0x18,2
;        SPDR = data;                            //Send data to display controller
_0x8:
	LDD  R30,Y+1
	OUT  0xF,R30
;        while ( (SPSR & 0x80) != 0x80 );        //Wait until Tx register empty
_0xB:
	IN   R30,0xE
	ANDI R30,LOW(0x80)
	CPI  R30,LOW(0x80)
	BRNE _0xB
;        LCD_PORT.LCD_CE_PIN = 1;                //Disable display controller
	SBI  0x18,1
;        }
	RJMP _0x2080005
;
;void LcdUpdate (void)   //Copies the LCD cache into the device RAM
;        {
_LcdUpdate:
;        int i;
;	#ifdef china
;	char j;
;	#endif
;
;        LcdSend(0x80, LCD_CMD);		//команды установки указателя памяти дисплея на 0,0
	RCALL SUBOPT_0x0
;	i -> R16,R17
;        LcdSend(0x40, LCD_CMD);
;
;        #ifdef china                    		//если китайский дисплей - грузим пустую строку
;		for (j = Cntr_X_RES; j>0; j--) LcdSend(0, LCD_DATA);
;	#endif
;
;        for (i = 0; i < LCD_CACHE_SIZE; i++)		//грузим данные
_0x11:
	RCALL SUBOPT_0x1
	BRGE _0x12
;                {
;                LcdSend(LcdCache[i], LCD_DATA);
	RCALL SUBOPT_0x2
	LD   R30,X
	RCALL SUBOPT_0x3
	RCALL _LcdSend
;		#ifdef china				//если дисплей китайский - догружаем каждую строку до размера его буфера
;		if (++j == LCD_X_RES)
;			{
;			for (j = (Cntr_X_RES-LCD_X_RES); j>0; j--) LcdSend(0, LCD_DATA);
;			j=0;
;			}
;		#endif
;                }
	RCALL SUBOPT_0x4
	RJMP _0x11
_0x12:
;        }
	RJMP _0x2080007
;
;void LcdClear (void)    //Clears the display
;        {
_LcdClear:
;        int i;
;
;	    for (i = 0; i < LCD_CACHE_SIZE; i++) LcdCache[i] = 0;	//забиваем всю память 0
	RCALL __SAVELOCR2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x14:
	RCALL SUBOPT_0x1
	BRGE _0x15
	RCALL SUBOPT_0x2
	LDI  R30,LOW(0)
	ST   X,R30
	RCALL SUBOPT_0x4
	RJMP _0x14
_0x15:
	RCALL _LcdUpdate
;        }
	RJMP _0x2080007
;
;void LcdInit ( void )	//инициализация SPI и дисплея
;        {
_LcdInit:
;        LCD_PORT.LCD_RST_PIN = 1;       //настроили порты ввода/вывода
	SBI  0x18,0
;        LCD_DDR.LCD_RST_PIN = LCD_DDR.LCD_DC_PIN = LCD_DDR.LCD_CE_PIN = LCD_DDR.SPI_MOSI_PIN = LCD_DDR.SPI_CLK_PIN = 1;
	SBI  0x17,5
	SBI  0x17,3
	SBI  0x17,1
	SBI  0x17,2
	SBI  0x17,0
;        delay_ms(1);
	RCALL SUBOPT_0x5
	RCALL _delay_ms
;        SPCR = 0x50;
	LDI  R30,LOW(80)
	OUT  0xD,R30
;        LCD_PORT.LCD_RST_PIN = 0;       //дернули ресет
	CBI  0x18,0
;        delay_ms(10);
	LDI  R26,LOW(10)
	RCALL SUBOPT_0x6
	RCALL _delay_ms
;        LCD_PORT.LCD_RST_PIN = 1;
	SBI  0x18,0
;                            //Enable SPI port: No interrupt, MSBit first, Master mode, CPOL->0, CPHA->0, Clk/4
;
;        LCD_PORT.LCD_CE_PIN = 1;        //Disable LCD controller
	SBI  0x18,1
;
;        LcdSend( 0b00100001, LCD_CMD ); 						//LCD Extended Commands
	RCALL SUBOPT_0x7
;        LcdSend( 0b00000100+temp_control, LCD_CMD ); 					//Set Temp coefficent
	MOV  R30,R5
	SUBI R30,-LOW(4)
	RCALL SUBOPT_0x8
;        	#ifdef china
;        LcdSend( 0b00001000|SPI_invert<<3, LCD_CMD ); 					//порядок битов в SPI
;		#endif
;        LcdSend( 0b00010000+bias, LCD_CMD ); 						//LCD bias mode 1:48
	MOV  R30,R4
	SUBI R30,-LOW(16)
	RCALL SUBOPT_0x8
;        	#ifdef china
;        LcdSend( 0b01000000+shift, LCD_CMD ); 						//первая строка выше экрана, отображаем со второй
;		#endif
;	LcdSend( 0b10000000+Vop, LCD_CMD ); 						//Set LCD Vop (Contrast)
	MOV  R30,R7
	SUBI R30,-LOW(128)
	RCALL SUBOPT_0x8
;
;		#ifdef china
;	LcdSend( 0x20|x_mirror<<5|y_mirror<<4|power_down<<3, LCD_CMD );			//LCD Standard Commands
;        	#endif
;                #ifndef china
;        LcdSend( 0x20|power_down<<3|addressing<<2, LCD_CMD );				//LCD Standard Commands
	LDI  R26,0
	SBRC R2,0
	LDI  R26,1
	MOV  R30,R26
	LSL  R30
	LSL  R30
	LSL  R30
	ORI  R30,0x20
	MOV  R0,R30
	LDI  R26,0
	SBRC R2,1
	LDI  R26,1
	MOV  R30,R26
	LSL  R30
	LSL  R30
	OR   R30,R0
	RCALL SUBOPT_0x8
;                #endif
;        LcdSend( 0b00001000|((disp_config<<1|disp_config)&0b00000101), LCD_CMD ); 	//LCD mode
	MOV  R30,R6
	LSL  R30
	OR   R30,R6
	ANDI R30,LOW(0x5)
	ORI  R30,8
	RCALL SUBOPT_0x8
;        LcdClear();
	RCALL _LcdClear
;        }
	RET
;
;void LcdContrast (unsigned char contrast) 	//contrast -> Contrast value from 0x00 to 0x7F
;        {
_LcdContrast:
;        if (contrast > 0x7F) return;
	ST   -Y,R26
;	contrast -> Y+0
	LD   R26,Y
	CPI  R26,LOW(0x80)
	BRSH _0x208000B
;        LcdSend( 0x21, LCD_CMD );               //LCD Extended Commands
	RCALL SUBOPT_0x7
;        LcdSend( 0x80 | contrast, LCD_CMD );    //Set LCD Vop (Contrast)
	LD   R30,Y
	ORI  R30,0x80
	RCALL SUBOPT_0x8
;        LcdSend( 0x20, LCD_CMD );               //LCD Standard Commands,Horizontal addressing mode
	LDI  R30,LOW(32)
	RCALL SUBOPT_0x8
;        }
_0x208000B:
	ADIW R28,1
	RET
;
;void LcdMode (unsigned char mode) 		//режим дисплея: 0 - blank, 1 - all on, 2 - normal, 3 - inverse
;        {
;        if (mode > 3) return;
;	mode -> Y+0
;        LcdSend( 0b00001000|((mode<<1|mode)&0b00000101), LCD_CMD ); 	//LCD mode
;        }
;
;void LcdPwrMode (void) 				//инвертирует состояние вкл/выкл дисплея
;        {
;        power_down = ~power_down;
;        LcdSend( 0x20|power_down<<3, LCD_CMD );
;        }
;
;void LcdImage (flash unsigned char *imageData)	//вывод изображения
;        {
_LcdImage:
;        unsigned int i;
;
;        LcdSend(0x80, LCD_CMD);		//ставим указатель на 0,0
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x0
;	*imageData -> Y+2
;	i -> R16,R17
;        LcdSend(0x40, LCD_CMD);
;        for (i = 0; i < LCD_CACHE_SIZE; i++) LcdCache[i] = imageData[i];	//грузим данные
_0x2B:
	RCALL SUBOPT_0x1
	BRSH _0x2C
	MOVW R30,R16
	RCALL SUBOPT_0xA
	MOVW R0,R30
	MOVW R30,R16
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xC
	LPM  R30,Z
	MOVW R26,R0
	ST   X,R30
	RCALL SUBOPT_0x4
	RJMP _0x2B
_0x2C:
	RCALL __LOADLOCR2
	RJMP _0x2080006
;
;void LcdPixel (unsigned char x, unsigned char y, unsigned char mode)     //Displays a pixel at given absolute (x, y) location, mode -> Off, On or Xor
;        {
_LcdPixel:
;        int index;
;        unsigned char offset, data;
;
;        if ( x > LCD_X_RES ) return;	//если передали в функцию муть - выходим
	ST   -Y,R26
	RCALL __SAVELOCR4
;	x -> Y+6
;	y -> Y+5
;	mode -> Y+4
;	index -> R16,R17
;	offset -> R19
;	data -> R18
	LDD  R26,Y+6
	CPI  R26,LOW(0x55)
	BRSH _0x208000A
;        if ( y > LCD_Y_RES ) return;
	LDD  R26,Y+5
	CPI  R26,LOW(0x31)
	BRSH _0x208000A
;
;        index = (((int)(y)/8)*84)+x;    //считаем номер байта в массиве памяти дисплея
	RCALL SUBOPT_0xD
	LDI  R26,LOW(84)
	LDI  R27,HIGH(84)
	RCALL __MULW12
	MOVW R26,R30
	LDD  R30,Y+6
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0xC
	MOVW R16,R30
;        offset  = y-((y/8)*8);          //считаем номер бита в этом байте
	RCALL SUBOPT_0xD
	LSL  R30
	LSL  R30
	LSL  R30
	LDD  R26,Y+5
	SUB  R26,R30
	MOV  R19,R26
;
;        data = LcdCache[index];         //берем байт по наьденному индексу
	RCALL SUBOPT_0x2
	LD   R18,X
;
;        if ( mode == PIXEL_OFF ) data &= ( ~( 0x01 << offset ) );	//редактируем бит в этом байте
	LDD  R30,Y+4
	CPI  R30,0
	BRNE _0x2F
	RCALL SUBOPT_0xF
	COM  R30
	AND  R18,R30
;                else if ( mode == PIXEL_ON ) data |= ( 0x01 << offset );
	RJMP _0x30
_0x2F:
	LDD  R26,Y+4
	CPI  R26,LOW(0x1)
	BRNE _0x31
	RCALL SUBOPT_0xF
	OR   R18,R30
;                        else if ( mode  == PIXEL_XOR ) data ^= ( 0x01 << offset );
	RJMP _0x32
_0x31:
	LDD  R26,Y+4
	CPI  R26,LOW(0x2)
	BRNE _0x33
	RCALL SUBOPT_0xF
	EOR  R18,R30
;
;        LcdCache[index] = data;		//загружаем байт назад
_0x33:
_0x32:
_0x30:
	MOVW R30,R16
	RCALL SUBOPT_0xA
	ST   Z,R18
;        }
_0x208000A:
	RCALL __LOADLOCR4
	ADIW R28,7
	RET
;
;void LcdLine (int x1, int y1, int x2, int y2, unsigned char mode)  	//Draws a line between two points on the display - по Брезенхейму
;        {
_LcdLine:
;        signed int dy = 0;
;        signed int dx = 0;
;        signed int stepx = 0;
;        signed int stepy = 0;
;        signed int fraction = 0;
;
;        if (x1>LCD_X_RES || x2>LCD_X_RES || y1>LCD_Y_RES || y2>LCD_Y_RES) return;
	ST   -Y,R26
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	RCALL __SAVELOCR6
;	x1 -> Y+17
;	y1 -> Y+15
;	x2 -> Y+13
;	y2 -> Y+11
;	mode -> Y+10
;	dy -> R16,R17
;	dx -> R18,R19
;	stepx -> R20,R21
;	stepy -> Y+8
;	fraction -> Y+6
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	RCALL SUBOPT_0x10
	CPI  R26,LOW(0x55)
	LDI  R30,HIGH(0x55)
	CPC  R27,R30
	BRGE _0x35
	RCALL SUBOPT_0x11
	CPI  R26,LOW(0x55)
	LDI  R30,HIGH(0x55)
	CPC  R27,R30
	BRGE _0x35
	RCALL SUBOPT_0x12
	SBIW R26,49
	BRGE _0x35
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	SBIW R26,49
	BRLT _0x34
_0x35:
	RJMP _0x2080009
;
;        dy = y2 - y1;
_0x34:
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x14
	MOVW R16,R30
;        dx = x2 - x1;
	RCALL SUBOPT_0x10
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	RCALL SUBOPT_0x14
	MOVW R18,R30
;        if (dy < 0)
	TST  R17
	BRPL _0x37
;                {
;                dy = -dy;
	MOVW R30,R16
	RCALL __ANEGW1
	MOVW R16,R30
;                stepy = -1;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x9B
;                }
;                else stepy = 1;
_0x37:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
_0x9B:
	STD  Y+8,R30
	STD  Y+8+1,R31
;        if (dx < 0)
	TST  R19
	BRPL _0x39
;                {
;                dx = -dx;
	MOVW R30,R18
	RCALL __ANEGW1
	MOVW R18,R30
;                stepx = -1;
	__GETWRN 20,21,-1
;                }
;                else stepx = 1;
	RJMP _0x3A
_0x39:
	__GETWRN 20,21,1
;        dy <<= 1;
_0x3A:
	LSL  R16
	ROL  R17
;        dx <<= 1;
	LSL  R18
	ROL  R19
;        LcdPixel(x1,y1,mode);
	RCALL SUBOPT_0x15
;        if (dx > dy)
	__CPWRR 16,17,18,19
	BRGE _0x3B
;                {
;                fraction = dy - (dx >> 1);
	MOVW R30,R18
	ASR  R31
	ROR  R30
	MOVW R26,R30
	MOVW R30,R16
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x16
;                while (x1 != x2)
_0x3C:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	RCALL SUBOPT_0x10
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x3E
;                        {
;                        if (fraction >= 0)
	LDD  R26,Y+7
	TST  R26
	BRMI _0x3F
;                                {
;                                y1 += stepy;
	RCALL SUBOPT_0x17
;                                fraction -= dx;
	RCALL SUBOPT_0x18
	SUB  R30,R18
	SBC  R31,R19
	RCALL SUBOPT_0x16
;                                }
;                        x1 += stepx;
_0x3F:
	RCALL SUBOPT_0x19
;                        fraction += dy;
	MOVW R30,R16
	RCALL SUBOPT_0x1A
;                        LcdPixel(x1,y1,mode);
;                        }
	RJMP _0x3C
_0x3E:
;                }
;                else
	RJMP _0x40
_0x3B:
;                        {
;                        fraction = dx - (dy >> 1);
	MOVW R30,R16
	ASR  R31
	ROR  R30
	MOVW R26,R30
	MOVW R30,R18
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x16
;                        while (y1 != y2)
_0x41:
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x12
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x43
;                                {
;                                if (fraction >= 0)
	LDD  R26,Y+7
	TST  R26
	BRMI _0x44
;                                        {
;                                        x1 += stepx;
	RCALL SUBOPT_0x19
;                                        fraction -= dy;
	RCALL SUBOPT_0x18
	SUB  R30,R16
	SBC  R31,R17
	RCALL SUBOPT_0x16
;                                        }
;                                y1 += stepy;
_0x44:
	RCALL SUBOPT_0x17
;                                fraction += dx;
	MOVW R30,R18
	RCALL SUBOPT_0x1A
;                                LcdPixel(x1,y1,mode);
;                                }
	RJMP _0x41
_0x43:
;                        }
_0x40:
;        }
_0x2080009:
	RCALL __LOADLOCR6
	ADIW R28,19
	RET
;
;void LcdCircle(char x, char y, char radius, unsigned char mode)		//рисуем круг по координатам с радиусом - по Брезенхейму
;        {
;        signed char xc = 0;
;        signed char yc = 0;
;        signed char p = 0;
;
;        if (x>LCD_X_RES || y>LCD_Y_RES) return;
;	x -> Y+7
;	y -> Y+6
;	radius -> Y+5
;	mode -> Y+4
;	xc -> R17
;	yc -> R16
;	p -> R19
;
;        yc=radius;
;        p = 3 - (radius<<1);
;        while (xc <= yc)
;                {
;                LcdPixel(x + xc, y + yc, mode);
;                LcdPixel(x + xc, y - yc, mode);
;                LcdPixel(x - xc, y + yc, mode);
;                LcdPixel(x - xc, y - yc, mode);
;                LcdPixel(x + yc, y + xc, mode);
;                LcdPixel(x + yc, y - xc, mode);
;                LcdPixel(x - yc, y + xc, mode);
;                LcdPixel(x - yc, y - xc, mode);
;                if (p < 0) p += (xc++ << 2) + 6;
;                        else p += ((xc++ - yc--)<<2) + 10;
;                }
;        }
;
;void LcdBar(int x1, int y1, int x2, int y2, unsigned char persent)	//рисуем батарейку с заполнением в %
;        {
_LcdBar:
;        unsigned char horizon_line,horizon_line2,i;
;        if(persent>100)return;
	ST   -Y,R26
	RCALL __SAVELOCR4
;	x1 -> Y+11
;	y1 -> Y+9
;	x2 -> Y+7
;	y2 -> Y+5
;	persent -> Y+4
;	horizon_line -> R17
;	horizon_line2 -> R16
;	i -> R19
	LDD  R26,Y+4
	CPI  R26,LOW(0x65)
	BRSH _0x2080008
;        //LcdLine(x1,y2,x2,y2,1);  //down
;        //LcdLine(x2,y1,x2,y2,1);  //right
;	    //LcdLine(x1,y1,x1,y2,1);  //left
;	    //LcdLine(x1,y1,x2,y1,1);  //up
;
;
;        horizon_line=persent*(y2-y1)/100;
	LDD  R0,Y+4
	CLR  R1
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	RCALL SUBOPT_0x14
	MOVW R26,R0
	RCALL __MULW12
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21
	MOV  R17,R30
;        for(i=0;i<horizon_line;i++) LcdLine(x1,y2-i,x2,y2-i,1);
	LDI  R19,LOW(0)
_0x4F:
	CP   R19,R17
	BRSH _0x50
	RCALL SUBOPT_0x1B
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1B
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	RCALL SUBOPT_0x1C
	LDI  R26,LOW(1)
	RCALL _LcdLine
	SUBI R19,-1
	RJMP _0x4F
_0x50:
	LDD  R26,Y+9
	LDD  R30,Y+5
	SUB  R30,R26
	MOV  R16,R30
;        for(i=horizon_line2;i>horizon_line;i--) LcdLine(x1,y2+1-i,x2,y2+1-i,0);
	MOV  R19,R16
_0x52:
	CP   R17,R19
	BRSH _0x53
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x1D
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x1D
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	RCALL SUBOPT_0x1E
	LDI  R26,LOW(0)
	RCALL _LcdLine
	SUBI R19,1
	RJMP _0x52
_0x53:
_0x2080008:
	RCALL __LOADLOCR4
	ADIW R28,13
	RET
;
;void LcdGotoXYFont (unsigned char x, unsigned char y)   //Sets cursor location to xy location. Range: 1,1 .. 14,6
;        {
_LcdGotoXYFont:
;        if (x <= 14 && y<= 6) LcdCacheIdx = ( (int)(y) - 1 ) * 84 + ( (int)(x) - 1 ) * 6;
	ST   -Y,R26
;	x -> Y+1
;	y -> Y+0
	LDD  R26,Y+1
	CPI  R26,LOW(0xF)
	BRSH _0x55
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BRLO _0x56
_0x55:
	RJMP _0x54
_0x56:
	LD   R30,Y
	RCALL SUBOPT_0xE
	SBIW R30,1
	LDI  R26,LOW(84)
	LDI  R27,HIGH(84)
	RCALL __MULW12
	MOVW R22,R30
	LDD  R30,Y+1
	RCALL SUBOPT_0xE
	SBIW R30,1
	LDI  R26,LOW(6)
	LDI  R27,HIGH(6)
	RCALL __MULW12
	ADD  R30,R22
	ADC  R31,R23
	MOVW R8,R30
;        }
_0x54:
	RJMP _0x2080005
;
;void clean_lcd_buf (void)	//очистка текстового буфера
;	{
_clean_lcd_buf:
;	char i;
;
;	for (i=0; i<14; i++) lcd_buf[i] = 0;
	ST   -Y,R17
;	i -> R17
	LDI  R17,LOW(0)
_0x58:
	CPI  R17,14
	BRSH _0x59
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x21
	SUBI R17,-1
	RJMP _0x58
_0x59:
	LD   R17,Y+
	RET
;
;void CharPrint (int ch, unsigned int IconSize, flash unsigned char *CharData, unsigned int inv, unsigned int space)
;    {
_CharPrint:
;        unsigned char i;
;
;        for ( i = 0; i < IconSize; i++ )
	RCALL SUBOPT_0x9
	ST   -Y,R17
;	ch -> Y+9
;	IconSize -> Y+7
;	*CharData -> Y+5
;	inv -> Y+3
;	space -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x5B:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	RCALL SUBOPT_0x22
	BRSH _0x5C
;        {
;            LcdCache[LcdCacheIdx++] = inv ? ~(CharData[(ch*IconSize+i)]) : CharData[(ch*IconSize+i)];
	RCALL SUBOPT_0x23
	MOVW R22,R30
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	SBIW R30,0
	BREQ _0x5D
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x25
	COM  R30
	RJMP _0x5E
_0x5D:
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x25
_0x5E:
	MOVW R26,R22
	ST   X,R30
;        }
	SUBI R17,-1
	RJMP _0x5B
_0x5C:
;        if (space) LcdCache[LcdCacheIdx++] = 0x00;	//добавляем пробел между символами
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SBIW R30,0
	BREQ _0x60
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x21
;    }
_0x60:
	LDD  R17,Y+0
	ADIW R28,11
	RET
;
;void LcdChr (int ch)	//Displays a character at current cursor location and increment cursor location
; 	{
_LcdChr:
;     	CharPrint(ch,5,table,0,1);
	RCALL SUBOPT_0x26
;	ch -> Y+0
	RCALL SUBOPT_0x1D
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RCALL SUBOPT_0x1D
	LDI  R30,LOW(_table*2)
	LDI  R31,HIGH(_table*2)
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x5
	RCALL _CharPrint
; 	}
	RJMP _0x2080005
;
;void LcdString (unsigned char x, unsigned char y)	//Displays a string at current cursor location
;	{
_LcdString:
;	unsigned char i;
;
;	if (x > 14 && y > 6) return;
	ST   -Y,R26
	ST   -Y,R17
;	x -> Y+2
;	y -> Y+1
;	i -> R17
	LDD  R26,Y+2
	CPI  R26,LOW(0xF)
	BRLO _0x62
	LDD  R26,Y+1
	CPI  R26,LOW(0x7)
	BRSH _0x63
_0x62:
	RJMP _0x61
_0x63:
	RJMP _0x2080003
;	LcdGotoXYFont (x, y);
_0x61:
	RCALL SUBOPT_0x28
;	for ( i = 0; i < 15-x; i++ ) if (lcd_buf[i]) LcdChr (lcd_buf[i]);
_0x65:
	LDD  R30,Y+2
	RCALL SUBOPT_0xE
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	RCALL __SWAPW12
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x22
	BRGE _0x66
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x20
	LD   R30,Z
	CPI  R30,0
	BREQ _0x67
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x20
	LD   R26,Z
	RCALL SUBOPT_0x6
	RCALL _LcdChr
;	clean_lcd_buf();
_0x67:
	SUBI R17,-1
	RJMP _0x65
_0x66:
	RCALL _clean_lcd_buf
;	}
	RJMP _0x2080003
;
;void LcdChrBold (int ch)	//Displays a bold character at current cursor location and increment cursor location
; 	{
_LcdChrBold:
;     	unsigned char i;
;     	unsigned char a = 0, b = 0, c = 0;
;
;     	for ( i = 0; i < 5; i++ )
	RCALL SUBOPT_0x9
	RCALL __SAVELOCR4
;	ch -> Y+4
;	i -> R17
;	a -> R16
;	b -> R19
;	c -> R18
	LDI  R16,0
	LDI  R19,0
	LDI  R18,0
	LDI  R17,LOW(0)
_0x69:
	CPI  R17,5
	BRSH _0x6A
;     	        {
;     	        c = table[(ch*5+i)];		//выделяем столбец из символа
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDI  R26,LOW(5)
	LDI  R27,HIGH(5)
	RCALL __MULW12
	MOVW R26,R30
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0xC
	SUBI R30,LOW(-_table*2)
	SBCI R31,HIGH(-_table*2)
	LPM  R18,Z
;
;     	        b =  (c & 0x01) * 3;            //"растягиваем" столбец на два байта
	RCALL SUBOPT_0x29
	MOV  R19,R0
;              	b |= (c & 0x02) * 6;
	RCALL SUBOPT_0x2A
	OR   R19,R30
;              	b |= (c & 0x04) * 12;
	RCALL SUBOPT_0x2B
	OR   R19,R30
;              	b |= (c & 0x08) * 24;
	RCALL SUBOPT_0x2C
	OR   R19,R30
;
;              	c >>= 4;
	SWAP R18
	ANDI R18,0xF
;              	a =  (c & 0x01) * 3;
	RCALL SUBOPT_0x29
	MOV  R16,R0
;              	a |= (c & 0x02) * 6;
	RCALL SUBOPT_0x2A
	OR   R16,R30
;              	a |= (c & 0x04) * 12;
	RCALL SUBOPT_0x2B
	OR   R16,R30
;              	a |= (c & 0x08) * 24;
	RCALL SUBOPT_0x2C
	OR   R16,R30
;
;     	        LcdCache[LcdCacheIdx] = b;	//копируем байты в экранный буфер
	MOVW R30,R8
	RCALL SUBOPT_0xA
	ST   Z,R19
;     	        LcdCache[LcdCacheIdx+1] = b;    //дублируем для получения жирного шрифта
	MOVW R30,R8
	__ADDW1MN _LcdCache,1
	ST   Z,R19
;     	        LcdCache[LcdCacheIdx+84] = a;
	MOVW R30,R8
	__ADDW1MN _LcdCache,84
	ST   Z,R16
;     	        LcdCache[LcdCacheIdx+85] = a;
	MOVW R30,R8
	__ADDW1MN _LcdCache,85
	ST   Z,R16
;     	        LcdCacheIdx = LcdCacheIdx+2;
	MOVW R30,R8
	ADIW R30,2
	MOVW R8,R30
;     	        }
	SUBI R17,-1
	RJMP _0x69
_0x6A:
;
;     	LcdCache[LcdCacheIdx++] = 0x00;	//для пробела между символами
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x21
;     	LcdCache[LcdCacheIdx++] = 0x00;
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x21
; 	}
	RJMP _0x2080004
;
;void LcdStringBold (unsigned char x, unsigned char y)	//Displays a string at current cursor location
;	{
_LcdStringBold:
;	unsigned char i;
;
;	if (x > 13 && y > 5) return;
	ST   -Y,R26
	ST   -Y,R17
;	x -> Y+2
;	y -> Y+1
;	i -> R17
	LDD  R26,Y+2
	CPI  R26,LOW(0xE)
	BRLO _0x6C
	LDD  R26,Y+1
	CPI  R26,LOW(0x6)
	BRSH _0x6D
_0x6C:
	RJMP _0x6B
_0x6D:
	RJMP _0x2080003
;	LcdGotoXYFont (x, y);
_0x6B:
	RCALL SUBOPT_0x28
;	for ( i = 0; i < 14-x; i++ ) if (lcd_buf[i]) LcdChrBold (lcd_buf[i]);
_0x6F:
	LDD  R30,Y+2
	RCALL SUBOPT_0xE
	LDI  R26,LOW(14)
	LDI  R27,HIGH(14)
	RCALL __SWAPW12
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x22
	BRGE _0x70
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x20
	LD   R30,Z
	CPI  R30,0
	BREQ _0x71
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x20
	LD   R26,Z
	RCALL SUBOPT_0x6
	RCALL _LcdChrBold
;	clean_lcd_buf();
_0x71:
	SUBI R17,-1
	RJMP _0x6F
_0x70:
	RCALL _clean_lcd_buf
;	}
	RJMP _0x2080003
;
;void LcdChrBig (int ch)	//Displays a character at current cursor location and increment cursor location
; 	{
;     	unsigned char i;
;     	unsigned char a = 0, b = 0, c = 0;
;
;     	for ( i = 0; i < 5; i++ )
;	ch -> Y+4
;	i -> R17
;	a -> R16
;	b -> R19
;	c -> R18
;     	        {
;     	        c = table[(ch*5+i)];		//выделяем столбец из символа
;
;     	        b =  (c & 0x01) * 3;            //"растягиваем" столбец на два байта
;              	b |= (c & 0x02) * 6;
;              	b |= (c & 0x04) * 12;
;              	b |= (c & 0x08) * 24;
;
;              	c >>= 4;
;              	a =  (c & 0x01) * 3;
;              	a |= (c & 0x02) * 6;
;              	a |= (c & 0x04) * 12;
;              	a |= (c & 0x08) * 24;
;     	        LcdCache[LcdCacheIdx] = b;
;     	        LcdCache[LcdCacheIdx+84] = a;
;     	        LcdCacheIdx = LcdCacheIdx+1;
;     	        }
;
;     	LcdCache[LcdCacheIdx++] = 0x00;
;     	}
;
;void LcdStringBig (unsigned char x, unsigned char y)	//Displays a string at current cursor location
;	{
;	unsigned char i;
;
;	if (x > 14 && y > 5) return;
;	x -> Y+2
;	y -> Y+1
;	i -> R17
;	LcdGotoXYFont (x, y);
;	for ( i = 0; i < 15-x; i++ ) if (lcd_buf[i]) LcdChrBig (lcd_buf[i]);
;	clean_lcd_buf();
;	}
;
;
;//***************************************************
;//****************Прототипы функций******************
;//***************************************************
;void baseTemplate (unsigned int TankLevel, int EngineTemperature);
;//***************************************************
;#define IconSize 3   //не должен быть нулем! минимум 1
;#define TankCapacity 55 //объем бензобака
;#define MinEngineTemperature 0  //минимальная температура двигателя для отображения
;#define MaxEngineTemperature 150
;#define EngineTemperatureWarning 100
;#define MaxBaseTemperature 99
;#define MinBaseTemperature -50
;#define OutTemperatureWarning 3
;
;int _outTemperature,_internalTemperature,_engineTemperature;
;unsigned char outTempDevice=1, internalTempDevice=2, engineTempDevice=0;

	.DSEG
;
;// maximum number of DS1820 devices
;// connected to the 1 Wire bus
;#define MAX_DS18B20 8
;// number of DS1820 devices
;// connected to the 1 Wire bus
;unsigned char ds18b20_devices;
;// DS1820 devices ROM code storage area,
;// 9 bytes are used for each device
;// (see the w1_search function description in the help)
;unsigned char ds18b20_rom_codes[MAX_DS18B20][9];
;unsigned int _arrTemplate[];
;unsigned int _template;
;
;
;//ASCII
;flash char pic1[] =
;{
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0xFC,0x04,0x04,0x04,0xFC,
;0x08,0x08,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0xFC,
;0x04,0x04,0xFC,0x20,0x20,0x00,
;0x00,0xFF,0x00,0x00,0x00,0xFF,
;0x02,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x40,0x40,0x40,0xFF,
;0x00,0x00,0xFF,0x04,0x04,0x00,
;0x00,0xFF,0x00,0x00,0x00,0xFF,
;0x81,0x01,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x10,0x10,0x92,0xFF,
;0x00,0x00,0xFF,0x00,0x00,0x00,
;0x00,0x7F,0x40,0x40,0x40,0x7F,
;0x10,0x10,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x04,0x04,0x24,0xFF,
;0x00,0x00,0xFF,0x00,0x00,0x00,
;0x80,0xFF,0xF9,0xF9,0xF9,0xFF,
;0x90,0x22,0x3C,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x00,0x00,0x00,0x00,
;0x00,0x00,0x1C,0x3E,0x7F,0xF7,
;0x81,0xB7,0xFD,0x7F,0x3E,0x1C
;}; // FF
;
;
;flash char icon[] =
;{
;0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF, //test
;0xFF,0x81,0xFD,0x91,0xFD,0x81,0xB9,0xC5,0xC5,0xB9,0x81,0x85,0xFD,0x85,0x81,0xDD,0x81,0xFF,//hot
;0x00,0xFE,0x82,0x93,0x93,0x92,0x82,0x82,0x82,0x82,0x92,0xBB,0x93,0x82,0xFE,0x00,0x00,0x00,//bat
;0x00,0xFF,0x81,0xDD,0x81,0xFF,0x00,0x49,0x2A,0x1C,0x7F,0x1C,0x2A,0x49,0x00,0x00,0x00,0x00,//ace
;0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,//blank
;};
;
;void baseTemplate(unsigned int TankLevel, int EngineTemperature)
;{

	.CSEG
_baseTemplate:
;    float TemperatureProcent, TankProcent;
;
;    if (EngineTemperature > MaxEngineTemperature)   EngineTemperature =  MaxEngineTemperature;
	RCALL SUBOPT_0x9
	SBIW R28,8
;	TankLevel -> Y+10
;	EngineTemperature -> Y+8
;	TemperatureProcent -> Y+4
;	TankProcent -> Y+0
	RCALL SUBOPT_0x2D
	CPI  R26,LOW(0x97)
	LDI  R30,HIGH(0x97)
	CPC  R27,R30
	BRLT _0x7E
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	STD  Y+8,R30
	STD  Y+8+1,R31
;    if (EngineTemperature < MinEngineTemperature)   EngineTemperature =  MinEngineTemperature;
_0x7E:
	LDD  R26,Y+9
	TST  R26
	BRPL _0x7F
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
;    sprintf (lcd_buf, "%3u", EngineTemperature);
_0x7F:
	RCALL SUBOPT_0x2E
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0x1D
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	RCALL SUBOPT_0x2F
;    LcdString(12,1);
	LDI  R30,LOW(12)
	RCALL SUBOPT_0x3
	RCALL _LcdString
;    sprintf (lcd_buf, "%u", TankLevel);
	RCALL SUBOPT_0x2E
	__POINTW1FN _0x0,4
	RCALL SUBOPT_0x1D
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
;    LcdString(1,1);
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x3
	RCALL _LcdString
;    TemperatureProcent = (long)EngineTemperature*100/MaxEngineTemperature;
	RCALL SUBOPT_0x2D
	RCALL __CWD2
	RCALL SUBOPT_0x30
	__GETD1N 0x96
	RCALL __DIVD21
	RCALL __CDF1
	__PUTD1S 4
;    LcdBar(78, 10, 79, 39, TemperatureProcent);
	LDI  R30,LOW(78)
	LDI  R31,HIGH(78)
	RCALL SUBOPT_0x31
	LDI  R30,LOW(79)
	LDI  R31,HIGH(79)
	RCALL SUBOPT_0x1D
	LDI  R30,LOW(39)
	LDI  R31,HIGH(39)
	RCALL SUBOPT_0x1D
	__GETD1S 12
	RCALL __CFD1U
	MOV  R26,R30
	RCALL _LcdBar
;    TankProcent = (long)TankLevel*100/TankCapacity;
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CLR  R24
	CLR  R25
	RCALL SUBOPT_0x30
	__GETD1N 0x37
	RCALL __DIVD21
	RCALL __CDF1
	RCALL __PUTD1S0
;    LcdBar(2, 10, 4, 37, TankProcent);
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL SUBOPT_0x31
	RCALL SUBOPT_0x32
	LDI  R30,LOW(37)
	LDI  R31,HIGH(37)
	RCALL SUBOPT_0x1D
	__GETD1S 8
	RCALL __CFD1U
	MOV  R26,R30
	RCALL _LcdBar
;}
	ADIW R28,12
	RET
;
;void tempDeviceInit(void)
;{
_tempDeviceInit:
;    unsigned int i;
;
;    ds18b20_devices=w1_search(0xf0,ds18b20_rom_codes);
	RCALL __SAVELOCR2
;	i -> R16,R17
	LDI  R30,LOW(240)
	ST   -Y,R30
	LDI  R26,LOW(_ds18b20_rom_codes)
	LDI  R27,HIGH(_ds18b20_rom_codes)
	RCALL _w1_search
	STS  _ds18b20_devices,R30
;
;    for (i=0; i<ds18b20_devices; i++)
	__GETWRN 16,17,0
_0x81:
	LDS  R30,_ds18b20_devices
	MOVW R26,R16
	RCALL SUBOPT_0xE
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x82
;    {
;        ds18b20_init(&ds18b20_rom_codes[i][0],-30,125,DS18B20_9BIT_RES);
	__MULBNWRU 16,17,9
	RCALL SUBOPT_0x33
	RCALL SUBOPT_0x1D
	LDI  R30,LOW(226)
	ST   -Y,R30
	LDI  R30,LOW(125)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _ds18b20_init
;    }
	RCALL SUBOPT_0x4
	RJMP _0x81
_0x82:
;}
_0x2080007:
	RCALL __LOADLOCR2P
	RET
;
;void getTemperature(unsigned int devices)
;{
_getTemperature:
;
;    switch (devices)
	RCALL SUBOPT_0x26
;	devices -> Y+0
;    {
;        case 3:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x86
;            _internalTemperature =  ds18b20_temperature(&ds18b20_rom_codes[internalTempDevice][0]);
	LDS  R30,_internalTempDevice
	RCALL SUBOPT_0x34
	MOVW R12,R30
;        case 2:
	RJMP _0x87
_0x86:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x88
_0x87:
;            _outTemperature =  ds18b20_temperature(&ds18b20_rom_codes[outTempDevice][0]);
	LDS  R30,_outTempDevice
	RCALL SUBOPT_0x34
	MOVW R10,R30
;        case 1:
	RJMP _0x89
_0x88:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x85
_0x89:
;            _engineTemperature = ds18b20_temperature(&ds18b20_rom_codes[engineTempDevice][0]);
	LDS  R30,_engineTempDevice
	LDI  R26,LOW(9)
	MUL  R30,R26
	MOVW R30,R0
	RCALL SUBOPT_0x33
	MOVW R26,R30
	RCALL _ds18b20_temperature
	LDI  R26,LOW(__engineTemperature)
	LDI  R27,HIGH(__engineTemperature)
	RCALL __CFD1
	ST   X+,R30
	ST   X,R31
;    };
_0x85:
;}
	RJMP _0x2080005
;
;void iconView (int ch, unsigned int inv)
;{
_iconView:
;    CharPrint(ch,6*IconSize,icon,inv,0);
	RCALL SUBOPT_0x9
;	ch -> Y+2
;	inv -> Y+0
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x36
	RCALL _CharPrint
;}
_0x2080006:
	ADIW R28,4
	RET
;
;void iconClear (void)
;{
_iconClear:
;    LcdGotoXYFont(3,1);
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x3
	RCALL _LcdGotoXYFont
;    CharPrint(4,6*IconSize,icon,0,0);
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x37
;    CharPrint(4,6*IconSize,icon,0,0);
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x37
;    CharPrint(4,6*IconSize,icon,0,0);
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x27
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x6
	RCALL _CharPrint
;}
	RET
;
;int tempProcessing(int temperature)
;{
_tempProcessing:
;  if (temperature > MaxBaseTemperature) temperature = MaxBaseTemperature;
	RCALL SUBOPT_0x9
;	temperature -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRLT _0x8B
	LDI  R30,LOW(99)
	LDI  R31,HIGH(99)
	ST   Y,R30
	STD  Y+1,R31
;  if (temperature < MinBaseTemperature) temperature = MinBaseTemperature;
_0x8B:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0xFFCE)
	LDI  R30,HIGH(0xFFCE)
	CPC  R27,R30
	BRGE _0x8C
	LDI  R30,LOW(65486)
	LDI  R31,HIGH(65486)
	ST   Y,R30
	STD  Y+1,R31
;  return temperature;
_0x8C:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x2080005
;}
;
;void template(unsigned int numTemplate)
;{
_template:
;    int internalTemperature;
;    int outTemperature;
;
;    switch (numTemplate)
	RCALL SUBOPT_0x9
	RCALL __SAVELOCR4
;	numTemplate -> Y+4
;	internalTemperature -> R16,R17
;	outTemperature -> R18,R19
	LDD  R30,Y+4
	LDD  R31,Y+4+1
;    {
;        case 0: //temperature template
	SBIW R30,0
	BRNE _0x8F
;            internalTemperature = tempProcessing(_internalTemperature);
	MOVW R26,R12
	RCALL _tempProcessing
	MOVW R16,R30
;            outTemperature = tempProcessing(_outTemperature);
	MOVW R26,R10
	RCALL _tempProcessing
	MOVW R18,R30
;            LcdGotoXYFont(3,2);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _LcdGotoXYFont
;	        LcdChrBold(0x03);
	LDI  R26,LOW(3)
	RCALL SUBOPT_0x6
	RCALL _LcdChrBold
;            LcdGotoXYFont(3,4);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(4)
	RCALL _LcdGotoXYFont
;	        LcdChrBold(0x04);
	LDI  R26,LOW(4)
	RCALL SUBOPT_0x6
	RCALL _LcdChrBold
;            sprintf (lcd_buf, "%3i\x02", outTemperature);
	RCALL SUBOPT_0x2E
	__POINTW1FN _0x0,7
	RCALL SUBOPT_0x1D
	MOVW R30,R18
	RCALL SUBOPT_0x2F
;            LcdStringBold(5,2);
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _LcdStringBold
;            sprintf (lcd_buf, "%3i\x02", internalTemperature);
	RCALL SUBOPT_0x2E
	__POINTW1FN _0x0,7
	RCALL SUBOPT_0x1D
	MOVW R30,R16
	RCALL SUBOPT_0x2F
;            LcdStringBold(5,4);
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R26,LOW(4)
	RCALL _LcdStringBold
;            break;
;    }
_0x8F:
;}
	RJMP _0x2080004
;
;void setTemplate(unsigned int numTemplate)
;{
_setTemplate:
;    _template = numTemplate;
	RCALL SUBOPT_0x26
;	numTemplate -> Y+0
	STS  __template,R30
	STS  __template+1,R31
;    LcdClear();
	RCALL _LcdClear
;    LcdImage(pic1);
	LDI  R26,LOW(_pic1*2)
	LDI  R27,HIGH(_pic1*2)
	RCALL _LcdImage
;    //template(numTemplate);
;}
_0x2080005:
	ADIW R28,2
	RET
;
;void warning(void)
;{
_warning:
;  iconClear();
	RCALL _iconClear
;  if (_engineTemperature >= EngineTemperatureWarning)
	RCALL SUBOPT_0x38
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRLT _0x91
;  {
;    LcdGotoXYFont(3,1);
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x3
	RCALL _LcdGotoXYFont
;    iconView(1,0);
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0x36
	RCALL _iconView
;  }
;
;  if (_outTemperature <= OutTemperatureWarning)
_0x91:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R10
	CPC  R31,R11
	BRLT _0x92
;  {
;    LcdGotoXYFont(9,1);
	LDI  R30,LOW(9)
	RCALL SUBOPT_0x3
	RCALL _LcdGotoXYFont
;    iconView(3,0);
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0x36
	RCALL _iconView
;  }
;}
_0x92:
	RET
;
;void update(void)
;{
_update:
;    baseTemplate(43,_engineTemperature);
	LDI  R30,LOW(43)
	LDI  R31,HIGH(43)
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x38
	RCALL _baseTemplate
;    template(_template);
	LDS  R26,__template
	LDS  R27,__template+1
	RCALL _template
;    warning();
	RCALL _warning
;    LcdUpdate();
	RCALL _LcdUpdate
;}
	RET
;
;void test ()
;{
_test:
;
;    //getTemperature(ds18b20_devices);
;    //setTemplate(0);
;    //inv = !inv;
;    //LcdGotoXYFont(6,1);
;    //iconView(2,inv);
;
;
;
;
;    //sprintf (lcd_buf, "%i", -1);
;	//LcdString(3,6);
;}
	RET
;
;
;#define tempUpdateTime 5//в секундах
;
;unsigned int i;
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 002B {
_ext_int0_isr:
; 0000 002C // Place your code here
; 0000 002D 
; 0000 002E }
	RETI
;
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 0032 {
_ext_int1_isr:
; 0000 0033 // Place your code here
; 0000 0034 
; 0000 0035 }
	RETI
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0039 {
_timer0_ovf_isr:
; 0000 003A // Place your code here
; 0000 003B 
; 0000 003C }
	RETI
;
;// Timer1 output compare A interrupt service routine
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 0040 {
_timer1_compa_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0041 TCNT1H=0x00;
	RCALL SUBOPT_0x39
; 0000 0042 TCNT1L=0x00;
; 0000 0043 update();
	RCALL _update
; 0000 0044 i++;
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	RCALL SUBOPT_0x3A
; 0000 0045 
; 0000 0046     if (i >= tempUpdateTime*2)
	LDS  R26,_i
	LDS  R27,_i+1
	SBIW R26,10
	BRLO _0x93
; 0000 0047     {
; 0000 0048         i = 0;
	LDI  R30,LOW(0)
	STS  _i,R30
	STS  _i+1,R30
; 0000 0049         getTemperature(ds18b20_devices);
	LDS  R26,_ds18b20_devices
	CLR  R27
	RCALL _getTemperature
; 0000 004A     }
; 0000 004B }
_0x93:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;// Timer2 overflow interrupt service routine
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 004F {
_timer2_ovf_isr:
; 0000 0050 // Place your code here
; 0000 0051 
; 0000 0052 }
	RETI
;
;#define ADC_VREF_TYPE 0xC0
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0058 {
; 0000 0059 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
; 0000 005A // Delay needed for the stabilization of the ADC input voltage
; 0000 005B delay_us(10);
; 0000 005C // Start the AD conversion
; 0000 005D ADCSRA|=0x40;
; 0000 005E // Wait for the AD conversion to complete
; 0000 005F while ((ADCSRA & 0x10)==0);
; 0000 0060 ADCSRA|=0x10;
; 0000 0061 return ADCW;
; 0000 0062 }
;
;// Declare your global variables here
;
;void main(void)
; 0000 0067 {
_main:
; 0000 0068 // Declare your local variables here
; 0000 0069 
; 0000 006A // Input/Output Ports initialization
; 0000 006B // Port B initialization
; 0000 006C // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 006D // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 006E PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 006F DDRB=0x00;
	OUT  0x17,R30
; 0000 0070 
; 0000 0071 // Port C initialization
; 0000 0072 // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0073 // State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0074 PORTC=0x00;
	OUT  0x15,R30
; 0000 0075 DDRC=0x00;
	OUT  0x14,R30
; 0000 0076 
; 0000 0077 // Port D initialization
; 0000 0078 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0079 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 007A PORTD=0x00;
	OUT  0x12,R30
; 0000 007B DDRD=0x00;
	OUT  0x11,R30
; 0000 007C 
; 0000 007D // Timer/Counter 0 initialization
; 0000 007E // Clock source: System Clock
; 0000 007F // Clock value: 7,813 kHz
; 0000 0080 TCCR0=0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 0081 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0082 
; 0000 0083 // Timer/Counter 1 initialization
; 0000 0084 // Clock source: System Clock
; 0000 0085 // Clock value: 7,813 kHz
; 0000 0086 // Mode: Normal top=0xFFFF
; 0000 0087 // OC1A output: Discon.
; 0000 0088 // OC1B output: Discon.
; 0000 0089 // Noise Canceler: Off
; 0000 008A // Input Capture on Falling Edge
; 0000 008B // Timer1 Overflow Interrupt: Off
; 0000 008C // Input Capture Interrupt: Off
; 0000 008D // Compare A Match Interrupt: On
; 0000 008E // Compare B Match Interrupt: Off
; 0000 008F TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 0090 TCCR1B=0x05;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
; 0000 0091 TCNT1H=0x00;
	RCALL SUBOPT_0x39
; 0000 0092 TCNT1L=0x00;
; 0000 0093 ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 0094 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0095 OCR1AH=0x0F;
	LDI  R30,LOW(15)
	OUT  0x2B,R30
; 0000 0096 OCR1AL=0x42;
	LDI  R30,LOW(66)
	OUT  0x2A,R30
; 0000 0097 OCR1BH=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
; 0000 0098 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0099 
; 0000 009A // Timer/Counter 2 initialization
; 0000 009B // Clock source: System Clock
; 0000 009C // Clock value: 7,813 kHz
; 0000 009D // Mode: Normal top=0xFF
; 0000 009E // OC2 output: Disconnected
; 0000 009F ASSR=0x00;
	OUT  0x22,R30
; 0000 00A0 TCCR2=0x07;
	LDI  R30,LOW(7)
	OUT  0x25,R30
; 0000 00A1 TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 00A2 OCR2=0x00;
	OUT  0x23,R30
; 0000 00A3 
; 0000 00A4 // External Interrupt(s) initialization
; 0000 00A5 // INT0: On
; 0000 00A6 // INT0 Mode: Falling Edge
; 0000 00A7 // INT1: On
; 0000 00A8 // INT1 Mode: Rising Edge
; 0000 00A9 GICR|=0xC0;
	IN   R30,0x3B
	ORI  R30,LOW(0xC0)
	OUT  0x3B,R30
; 0000 00AA MCUCR=0x0E;
	LDI  R30,LOW(14)
	OUT  0x35,R30
; 0000 00AB GIFR=0xC0;
	LDI  R30,LOW(192)
	OUT  0x3A,R30
; 0000 00AC 
; 0000 00AD // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00AE TIMSK=0x51;
	LDI  R30,LOW(81)
	OUT  0x39,R30
; 0000 00AF 
; 0000 00B0 // USART initialization
; 0000 00B1 // USART disabled
; 0000 00B2 UCSRB=0x00;
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0000 00B3 
; 0000 00B4 // Analog Comparator initialization
; 0000 00B5 // Analog Comparator: Off
; 0000 00B6 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00B7 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00B8 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00B9 
; 0000 00BA // ADC initialization
; 0000 00BB // ADC Clock frequency: 1000,000 kHz
; 0000 00BC // ADC Voltage Reference: Int., cap. on AREF
; 0000 00BD ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(192)
	OUT  0x7,R30
; 0000 00BE ADCSRA=0x83;
	LDI  R30,LOW(131)
	OUT  0x6,R30
; 0000 00BF 
; 0000 00C0 // SPI initialization
; 0000 00C1 // SPI disabled
; 0000 00C2 SPCR=0x00;
	LDI  R30,LOW(0)
	OUT  0xD,R30
; 0000 00C3 
; 0000 00C4 // TWI initialization
; 0000 00C5 // TWI disabled
; 0000 00C6 TWCR=0x00;
	OUT  0x36,R30
; 0000 00C7 
; 0000 00C8 // 1 Wire Bus initialization
; 0000 00C9 // 1 Wire Data port: PORTC
; 0000 00CA // 1 Wire Data bit: 0
; 0000 00CB // Note: 1 Wire port settings are specified in the
; 0000 00CC // Project|Configure|C Compiler|Libraries|1 Wire menu.
; 0000 00CD w1_init();
	RCALL _w1_init
; 0000 00CE //ds18b20_init();
; 0000 00CF 
; 0000 00D0 LcdInit();
	RCALL _LcdInit
; 0000 00D1 LcdContrast(35);
	LDI  R26,LOW(35)
	RCALL _LcdContrast
; 0000 00D2 tempDeviceInit();
	RCALL _tempDeviceInit
; 0000 00D3 
; 0000 00D4 setTemplate(0);
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x6
	RCALL _setTemplate
; 0000 00D5 // Global enable interrupts
; 0000 00D6 #asm("sei")
	sei
; 0000 00D7 
; 0000 00D8 while (1)
_0x97:
; 0000 00D9       {
; 0000 00DA       // Place your code here
; 0000 00DB       test();
	RCALL _test
; 0000 00DC       }
	RJMP _0x97
; 0000 00DD }
_0x9A:
	RJMP _0x9A

	.CSEG
_ds18b20_select:
	RCALL SUBOPT_0x9
	ST   -Y,R17
	RCALL _w1_init
	CPI  R30,0
	BRNE _0x2000003
	LDI  R30,LOW(0)
	RJMP _0x2080003
_0x2000003:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SBIW R30,0
	BREQ _0x2000004
	LDI  R26,LOW(85)
	RCALL _w1_write
	LDI  R17,LOW(0)
_0x2000006:
	RCALL SUBOPT_0x3B
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R26,R30
	RCALL _w1_write
	SUBI R17,-LOW(1)
	CPI  R17,8
	BRLO _0x2000006
	RJMP _0x2000008
_0x2000004:
	LDI  R26,LOW(204)
	RCALL _w1_write
_0x2000008:
	LDI  R30,LOW(1)
	RJMP _0x2080003
_ds18b20_read_spd:
	RCALL SUBOPT_0x9
	RCALL __SAVELOCR4
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL SUBOPT_0x3C
	BRNE _0x2000009
	LDI  R30,LOW(0)
	RJMP _0x2080004
_0x2000009:
	LDI  R26,LOW(190)
	RCALL _w1_write
	LDI  R17,LOW(0)
	__POINTWRM 18,19,___ds18b20_scratch_pad
_0x200000B:
	PUSH R19
	PUSH R18
	__ADDWRN 18,19,1
	RCALL _w1_read
	POP  R26
	POP  R27
	ST   X,R30
	SUBI R17,-LOW(1)
	CPI  R17,9
	BRLO _0x200000B
	LDI  R30,LOW(___ds18b20_scratch_pad)
	LDI  R31,HIGH(___ds18b20_scratch_pad)
	RCALL SUBOPT_0x1D
	LDI  R26,LOW(9)
	RCALL _w1_dow_crc8
	RCALL __LNEGB1
_0x2080004:
	RCALL __LOADLOCR4
	ADIW R28,6
	RET
_ds18b20_temperature:
	RCALL SUBOPT_0x9
	ST   -Y,R17
	RCALL SUBOPT_0x3B
	RCALL _ds18b20_read_spd
	CPI  R30,0
	BRNE _0x200000D
	RCALL SUBOPT_0x3D
	RJMP _0x2080003
_0x200000D:
	__GETB1MN ___ds18b20_scratch_pad,4
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	ANDI R30,LOW(0x3)
	MOV  R17,R30
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x3C
	BRNE _0x200000E
	RCALL SUBOPT_0x3D
	RJMP _0x2080003
_0x200000E:
	LDI  R26,LOW(68)
	RCALL _w1_write
	MOV  R30,R17
	LDI  R26,LOW(_conv_delay_G100*2)
	LDI  R27,HIGH(_conv_delay_G100*2)
	RCALL SUBOPT_0x3E
	RCALL __GETW2PF
	RCALL _delay_ms
	RCALL SUBOPT_0x3B
	RCALL _ds18b20_read_spd
	CPI  R30,0
	BRNE _0x200000F
	RCALL SUBOPT_0x3D
	RJMP _0x2080003
_0x200000F:
	RCALL _w1_init
	MOV  R30,R17
	LDI  R26,LOW(_bit_mask_G100*2)
	LDI  R27,HIGH(_bit_mask_G100*2)
	RCALL SUBOPT_0x3E
	RCALL __GETW1PF
	LDS  R26,___ds18b20_scratch_pad
	LDS  R27,___ds18b20_scratch_pad+1
	AND  R30,R26
	AND  R31,R27
	RCALL __CWD1
	RCALL __CDF1
	__GETD2N 0x3D800000
	RCALL __MULF12
_0x2080003:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_ds18b20_init:
	ST   -Y,R26
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	RCALL SUBOPT_0x3C
	BRNE _0x2000010
	LDI  R30,LOW(0)
	RJMP _0x2080002
_0x2000010:
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	ORI  R30,LOW(0x1F)
	ST   Y,R30
	LDI  R26,LOW(78)
	RCALL _w1_write
	LDD  R26,Y+1
	RCALL _w1_write
	LDD  R26,Y+2
	RCALL _w1_write
	LD   R26,Y
	RCALL _w1_write
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	RCALL _ds18b20_read_spd
	CPI  R30,0
	BRNE _0x2000011
	LDI  R30,LOW(0)
	RJMP _0x2080002
_0x2000011:
	__GETB2MN ___ds18b20_scratch_pad,3
	LDD  R30,Y+2
	CP   R30,R26
	BRNE _0x2000013
	__GETB2MN ___ds18b20_scratch_pad,2
	LDD  R30,Y+1
	CP   R30,R26
	BRNE _0x2000013
	__GETB2MN ___ds18b20_scratch_pad,4
	LD   R30,Y
	CP   R30,R26
	BREQ _0x2000012
_0x2000013:
	LDI  R30,LOW(0)
	RJMP _0x2080002
_0x2000012:
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	RCALL SUBOPT_0x3C
	BRNE _0x2000015
	LDI  R30,LOW(0)
	RJMP _0x2080002
_0x2000015:
	LDI  R26,LOW(72)
	RCALL _w1_write
	LDI  R26,LOW(15)
	RCALL SUBOPT_0x6
	RCALL _delay_ms
	RCALL _w1_init
	RJMP _0x2080002
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G101:
	RCALL SUBOPT_0x9
	RCALL __SAVELOCR2
	RCALL SUBOPT_0xB
	ADIW R26,2
	RCALL __GETW1P
	SBIW R30,0
	BREQ _0x2020010
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0x3F
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020012
	__CPWRN 16,17,2
	BRLO _0x2020013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2020012:
	RCALL SUBOPT_0xB
	ADIW R26,2
	RCALL SUBOPT_0x3A
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	RCALL SUBOPT_0xB
	RCALL __GETW1P
	TST  R31
	BRMI _0x2020014
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0x3A
_0x2020014:
_0x2020013:
	RJMP _0x2020015
_0x2020010:
	RCALL SUBOPT_0xB
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2020015:
	RCALL __LOADLOCR2
_0x2080002:
	ADIW R28,5
	RET
__print_G101:
	RCALL SUBOPT_0x9
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2020018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x202001C
	CPI  R18,37
	BRNE _0x202001D
	LDI  R17,LOW(1)
	RJMP _0x202001E
_0x202001D:
	RCALL SUBOPT_0x40
_0x202001E:
	RJMP _0x202001B
_0x202001C:
	CPI  R30,LOW(0x1)
	BRNE _0x202001F
	CPI  R18,37
	BRNE _0x2020020
	RCALL SUBOPT_0x40
	RJMP _0x20200C9
_0x2020020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020021
	LDI  R16,LOW(1)
	RJMP _0x202001B
_0x2020021:
	CPI  R18,43
	BRNE _0x2020022
	LDI  R20,LOW(43)
	RJMP _0x202001B
_0x2020022:
	CPI  R18,32
	BRNE _0x2020023
	LDI  R20,LOW(32)
	RJMP _0x202001B
_0x2020023:
	RJMP _0x2020024
_0x202001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2020025
_0x2020024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020026
	ORI  R16,LOW(128)
	RJMP _0x202001B
_0x2020026:
	RJMP _0x2020027
_0x2020025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x202001B
_0x2020027:
	CPI  R18,48
	BRLO _0x202002A
	CPI  R18,58
	BRLO _0x202002B
_0x202002A:
	RJMP _0x2020029
_0x202002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202001B
_0x2020029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x202002F
	RCALL SUBOPT_0x41
	RCALL SUBOPT_0x42
	RCALL SUBOPT_0x41
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x43
	RJMP _0x2020030
_0x202002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2020032
	RCALL SUBOPT_0x44
	RCALL SUBOPT_0x45
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x46
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0x70)
	BRNE _0x2020035
	RCALL SUBOPT_0x44
	RCALL SUBOPT_0x45
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x46
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x64)
	BREQ _0x2020039
	CPI  R30,LOW(0x69)
	BRNE _0x202003A
_0x2020039:
	ORI  R16,LOW(4)
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x75)
	BRNE _0x202003C
_0x202003B:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	RCALL SUBOPT_0x16
	LDI  R17,LOW(5)
	RJMP _0x202003D
_0x202003C:
	CPI  R30,LOW(0x58)
	BRNE _0x202003F
	ORI  R16,LOW(8)
	RJMP _0x2020040
_0x202003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2020071
_0x2020040:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	RCALL SUBOPT_0x16
	LDI  R17,LOW(4)
_0x202003D:
	SBRS R16,2
	RJMP _0x2020042
	RCALL SUBOPT_0x44
	RCALL SUBOPT_0x45
	RCALL SUBOPT_0x47
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL __ANEGW1
	RCALL SUBOPT_0x47
	LDI  R20,LOW(45)
_0x2020043:
	CPI  R20,0
	BREQ _0x2020044
	SUBI R17,-LOW(1)
	RJMP _0x2020045
_0x2020044:
	ANDI R16,LOW(251)
_0x2020045:
	RJMP _0x2020046
_0x2020042:
	RCALL SUBOPT_0x44
	RCALL SUBOPT_0x45
	RCALL SUBOPT_0x47
_0x2020046:
_0x2020036:
	SBRC R16,0
	RJMP _0x2020047
_0x2020048:
	CP   R17,R21
	BRSH _0x202004A
	SBRS R16,7
	RJMP _0x202004B
	SBRS R16,2
	RJMP _0x202004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x202004D
_0x202004C:
	LDI  R18,LOW(48)
_0x202004D:
	RJMP _0x202004E
_0x202004B:
	LDI  R18,LOW(32)
_0x202004E:
	RCALL SUBOPT_0x40
	SUBI R21,LOW(1)
	RJMP _0x2020048
_0x202004A:
_0x2020047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x202004F
_0x2020050:
	CPI  R19,0
	BREQ _0x2020052
	SBRS R16,3
	RJMP _0x2020053
	RCALL SUBOPT_0x18
	LPM  R18,Z+
	RCALL SUBOPT_0x16
	RJMP _0x2020054
_0x2020053:
	RCALL SUBOPT_0x46
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2020054:
	RCALL SUBOPT_0x40
	CPI  R21,0
	BREQ _0x2020055
	SUBI R21,LOW(1)
_0x2020055:
	SUBI R19,LOW(1)
	RJMP _0x2020050
_0x2020052:
	RJMP _0x2020056
_0x202004F:
_0x2020058:
	LDI  R18,LOW(48)
	RCALL SUBOPT_0x18
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	RCALL SUBOPT_0x18
	ADIW R30,2
	RCALL SUBOPT_0x16
_0x202005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x202005C
	SUBI R18,-LOW(1)
	RCALL SUBOPT_0x2D
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x47
	RJMP _0x202005A
_0x202005C:
	CPI  R18,58
	BRLO _0x202005D
	SBRS R16,3
	RJMP _0x202005E
	SUBI R18,-LOW(7)
	RJMP _0x202005F
_0x202005E:
	SUBI R18,-LOW(39)
_0x202005F:
_0x202005D:
	SBRC R16,4
	RJMP _0x2020061
	CPI  R18,49
	BRSH _0x2020063
	RCALL SUBOPT_0x2D
	SBIW R26,1
	BRNE _0x2020062
_0x2020063:
	RJMP _0x20200CA
_0x2020062:
	CP   R21,R19
	BRLO _0x2020067
	SBRS R16,0
	RJMP _0x2020068
_0x2020067:
	RJMP _0x2020066
_0x2020068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2020069
	LDI  R18,LOW(48)
_0x20200CA:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x43
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x202006A:
_0x2020069:
_0x2020061:
	RCALL SUBOPT_0x40
	CPI  R21,0
	BREQ _0x202006C
	SUBI R21,LOW(1)
_0x202006C:
_0x2020066:
	SUBI R19,LOW(1)
	RCALL SUBOPT_0x2D
	SBIW R26,2
	BRLO _0x2020059
	RJMP _0x2020058
_0x2020059:
_0x2020056:
	SBRS R16,0
	RJMP _0x202006D
_0x202006E:
	CPI  R21,0
	BREQ _0x2020070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x43
	RJMP _0x202006E
_0x2020070:
_0x202006D:
_0x2020071:
_0x2020030:
_0x20200C9:
	LDI  R17,LOW(0)
_0x202001B:
	RJMP _0x2020016
_0x2020018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR4
	RCALL SUBOPT_0x48
	SBIW R30,0
	BRNE _0x2020072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080001
_0x2020072:
	MOVW R26,R28
	ADIW R26,6
	RCALL __ADDW2R15
	MOVW R16,R26
	RCALL SUBOPT_0x48
	RCALL SUBOPT_0x16
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x1D
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	RCALL SUBOPT_0x1D
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G101
	MOVW R18,R30
	RCALL SUBOPT_0x46
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2080001:
	RCALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET

	.CSEG

	.CSEG
_strlen:
	RCALL SUBOPT_0x9
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
	RCALL SUBOPT_0x9
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret

	.DSEG
___ds18b20_scratch_pad:
	.BYTE 0x9
_lcd_buf:
	.BYTE 0xE
_LcdCache:
	.BYTE 0x1F8
__engineTemperature:
	.BYTE 0x2
_outTempDevice:
	.BYTE 0x1
_internalTempDevice:
	.BYTE 0x1
_engineTempDevice:
	.BYTE 0x1
_ds18b20_devices:
	.BYTE 0x1
_ds18b20_rom_codes:
	.BYTE 0x48
__template:
	.BYTE 0x2
_i:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x0:
	RCALL __SAVELOCR2
	LDI  R30,LOW(128)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _LcdSend
	LDI  R30,LOW(64)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _LcdSend
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	__CPWRN 16,17,504
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(_LcdCache)
	LDI  R27,HIGH(_LcdCache)
	ADD  R26,R16
	ADC  R27,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	ST   -Y,R30
	LDI  R26,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	__ADDWRN 16,17,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(1)
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0x6:
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(33)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _LcdSend

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x8:
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _LcdSend

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x9:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA:
	SUBI R30,LOW(-_LcdCache)
	SBCI R31,HIGH(-_LcdCache)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xB:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xC:
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	LDD  R26,Y+5
	RCALL SUBOPT_0x6
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RCALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0xE:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF:
	MOV  R30,R19
	LDI  R26,LOW(1)
	RCALL __LSLB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x11:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	SUB  R30,R26
	SBC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x15:
	LDD  R30,Y+17
	ST   -Y,R30
	LDD  R30,Y+16
	ST   -Y,R30
	LDD  R26,Y+12
	RJMP _LcdPixel

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x16:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x17:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0xC
	STD  Y+15,R30
	STD  Y+15+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x19:
	MOVW R30,R20
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xC
	STD  Y+17,R30
	STD  Y+17+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1A:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x16
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1B:
	RCALL SUBOPT_0x13
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R19
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1C:
	SUB  R26,R30
	SBC  R27,R31
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 45 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x1D:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	ADIW R26,1
	MOV  R30,R19
	RCALL SUBOPT_0xE
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1F:
	MOV  R30,R17
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x20:
	SUBI R30,LOW(-_lcd_buf)
	SBCI R31,HIGH(-_lcd_buf)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	LDI  R26,LOW(0)
	STD  Z+0,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x22:
	MOV  R26,R17
	RCALL SUBOPT_0x6
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x23:
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	SBIW R30,1
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x24:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	RCALL __MULW12U
	MOVW R26,R30
	RJMP SUBOPT_0x1F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x25:
	RCALL SUBOPT_0xC
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	RCALL SUBOPT_0xC
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x26:
	RCALL SUBOPT_0x9
	LD   R30,Y
	LDD  R31,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x27:
	RCALL SUBOPT_0x1D
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x28:
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R26,Y+2
	RCALL _LcdGotoXYFont
	LDI  R17,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	MOV  R30,R18
	ANDI R30,LOW(0x1)
	LDI  R26,LOW(3)
	MULS R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2A:
	MOV  R30,R18
	ANDI R30,LOW(0x2)
	LDI  R26,LOW(6)
	MULS R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2B:
	MOV  R30,R18
	ANDI R30,LOW(0x4)
	LDI  R26,LOW(12)
	MULS R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2C:
	MOV  R30,R18
	ANDI R30,LOW(0x8)
	LDI  R26,LOW(24)
	MULS R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2D:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2E:
	LDI  R30,LOW(_lcd_buf)
	LDI  R31,HIGH(_lcd_buf)
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2F:
	RCALL __CWD1
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x30:
	__GETD1N 0x64
	RCALL __MULD12
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	RCALL SUBOPT_0x1D
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x32:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x33:
	SUBI R30,LOW(-_ds18b20_rom_codes)
	SBCI R31,HIGH(-_ds18b20_rom_codes)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x34:
	LDI  R26,LOW(9)
	MUL  R30,R26
	MOVW R30,R0
	RCALL SUBOPT_0x33
	MOVW R26,R30
	RCALL _ds18b20_temperature
	RCALL __CFD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x35:
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	RCALL SUBOPT_0x1D
	LDI  R30,LOW(_icon*2)
	LDI  R31,HIGH(_icon*2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x36:
	RCALL SUBOPT_0x1D
	LDI  R26,LOW(0)
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x6
	RCALL _CharPrint
	RJMP SUBOPT_0x32

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	LDS  R26,__engineTemperature
	LDS  R27,__engineTemperature+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	LDI  R30,LOW(0)
	OUT  0x2D,R30
	OUT  0x2C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3A:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	RCALL _ds18b20_select
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3D:
	__GETD1N 0xC61C3C00
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3E:
	RCALL SUBOPT_0xE
	LSL  R30
	ROL  R31
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3F:
	ADIW R26,4
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x40:
	ST   -Y,R18
	RCALL SUBOPT_0x11
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x41:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x42:
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x43:
	RCALL SUBOPT_0x11
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x44:
	RCALL SUBOPT_0x41
	RJMP SUBOPT_0x42

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x45:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RJMP SUBOPT_0x3F

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x46:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x47:
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x48:
	MOVW R26,R28
	ADIW R26,12
	RCALL __ADDW2R15
	RCALL __GETW1P
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

	.equ __w1_port=0x15
	.equ __w1_bit=0x00

_w1_init:
	clr  r30
	cbi  __w1_port,__w1_bit
	sbi  __w1_port-1,__w1_bit
	__DELAY_USW 0x3C0
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x25
	sbis __w1_port-2,__w1_bit
	ret
	__DELAY_USB 0xCB
	sbis __w1_port-2,__w1_bit
	ldi  r30,1
	__DELAY_USW 0x30C
	ret

__w1_read_bit:
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x5
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x1D
	clc
	sbic __w1_port-2,__w1_bit
	sec
	ror  r30
	__DELAY_USB 0xD5
	ret

__w1_write_bit:
	clt
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x5
	sbrc r23,0
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x23
	sbic __w1_port-2,__w1_bit
	rjmp __w1_write_bit0
	sbrs r23,0
	rjmp __w1_write_bit1
	ret
__w1_write_bit0:
	sbrs r23,0
	ret
__w1_write_bit1:
	__DELAY_USB 0xC8
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0xD
	set
	ret

_w1_read:
	ldi  r22,8
	__w1_read0:
	rcall __w1_read_bit
	dec  r22
	brne __w1_read0
	ret

_w1_write:
	mov  r23,r26
	ldi  r22,8
	clr  r30
__w1_write0:
	rcall __w1_write_bit
	brtc __w1_write1
	ror  r23
	dec  r22
	brne __w1_write0
	inc  r30
__w1_write1:
	ret

_w1_search:
	push r20
	push r21
	clr  r1
	clr  r20
__w1_search0:
	mov  r0,r1
	clr  r1
	rcall _w1_init
	tst  r30
	breq __w1_search7
	push r26
	ld   r26,y
	rcall _w1_write
	pop  r26
	ldi  r21,1
__w1_search1:
	cp   r21,r0
	brsh __w1_search6
	rcall __w1_read_bit
	sbrc r30,7
	rjmp __w1_search2
	rcall __w1_read_bit
	sbrc r30,7
	rjmp __w1_search3
	rcall __sel_bit
	and  r24,r25
	brne __w1_search3
	mov  r1,r21
	rjmp __w1_search3
__w1_search2:
	rcall __w1_read_bit
__w1_search3:
	rcall __sel_bit
	and  r24,r25
	ldi  r23,0
	breq __w1_search5
__w1_search4:
	ldi  r23,1
__w1_search5:
	rcall __w1_write_bit
	rjmp __w1_search13
__w1_search6:
	rcall __w1_read_bit
	sbrs r30,7
	rjmp __w1_search9
	rcall __w1_read_bit
	sbrs r30,7
	rjmp __w1_search8
__w1_search7:
	mov  r30,r20
	pop  r21
	pop  r20
	adiw r28,1
	ret
__w1_search8:
	set
	rcall __set_bit
	rjmp __w1_search4
__w1_search9:
	rcall __w1_read_bit
	sbrs r30,7
	rjmp __w1_search10
	rjmp __w1_search11
__w1_search10:
	cp   r21,r0
	breq __w1_search12
	mov  r1,r21
__w1_search11:
	clt
	rcall __set_bit
	clr  r23
	rcall __w1_write_bit
	rjmp __w1_search13
__w1_search12:
	set
	rcall __set_bit
	ldi  r23,1
	rcall __w1_write_bit
__w1_search13:
	inc  r21
	cpi  r21,65
	brlt __w1_search1
	rcall __w1_read_bit
	rol  r30
	rol  r30
	andi r30,1
	adiw r26,8
	st   x,r30
	sbiw r26,8
	inc  r20
	tst  r1
	breq __w1_search7
	ldi  r21,9
__w1_search14:
	ld   r30,x
	adiw r26,9
	st   x,r30
	sbiw r26,8
	dec  r21
	brne __w1_search14
	rjmp __w1_search0

__sel_bit:
	mov  r30,r21
	dec  r30
	mov  r22,r30
	lsr  r30
	lsr  r30
	lsr  r30
	clr  r31
	add  r30,r26
	adc  r31,r27
	ld   r24,z
	ldi  r25,1
	andi r22,7
__sel_bit0:
	breq __sel_bit1
	lsl  r25
	dec  r22
	rjmp __sel_bit0
__sel_bit1:
	ret

__set_bit:
	rcall __sel_bit
	brts __set_bit2
	com  r25
	and  r24,r25
	rjmp __set_bit3
__set_bit2:
	or   r24,r25
__set_bit3:
	st   z,r24
	ret

_w1_dow_crc8:
	clr  r30
	tst  r26
	breq __w1_dow_crc83
	mov  r24,r26
	ldi  r22,0x18
	ld   r26,y
	ldd  r27,y+1
__w1_dow_crc80:
	ldi  r25,8
	ld   r31,x+
__w1_dow_crc81:
	mov  r23,r31
	eor  r23,r30
	ror  r23
	brcc __w1_dow_crc82
	eor  r30,r22
__w1_dow_crc82:
	ror  r30
	lsr  r31
	dec  r25
	brne __w1_dow_crc81
	dec  r24
	brne __w1_dow_crc80
__w1_dow_crc83:
	adiw r28,2
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	RET

__LNEGB1:
	TST  R30
	LDI  R30,1
	BREQ __LNEGB1F
	CLR  R30
__LNEGB1F:
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__DIVD21:
	RCALL __CHKSIGND
	RCALL __DIVD21U
	BRTC __DIVD211
	RCALL __ANEGD1
__DIVD211:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETW2PF:
	LPM  R26,Z+
	LPM  R27,Z
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
