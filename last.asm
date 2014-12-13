
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega16
;Program type             : Application
;Clock frequency          : 16,000000 MHz
;Memory model             : Small
;Optimize for             : Speed
;(s)printf features       : float, width, precision
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : No
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

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
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	.DEF _devices=R5
	.DEF _oper=R6
	.DEF _yes=R8
	.DEF _oboroty=R10
	.DEF _ob_y=R12
	.DEF __lcd_x=R4

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_compa_isr
	JMP  _timer1_compb_isr
	JMP  _timer1_ovf_isr
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_conv_delay_G101:
	.DB  0x64,0x0,0xC8,0x0,0x90,0x1,0x20,0x3
_bit_mask_G101:
	.DB  0xF8,0xFF,0xFC,0xFF,0xFE,0xFF,0xFF,0xFF

_0x3:
	.DB  0x2
_0x4:
	.DB  0x7
_0x5:
	.DB  0xE0,0x1,0xE0,0x1,0xE0,0x1,0xE0,0x1
	.DB  0xE0,0x1,0xE0,0x1,0xE0,0x1,0xE0,0x1
	.DB  0xE0,0x1,0xE0,0x1,0xE0,0x1,0xE0,0x1
	.DB  0xE0,0x1,0xE0,0x1,0xE0,0x1
_0x89:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
_0x0:
	.DB  0x20,0x20,0x25,0x64,0x78,0x0,0x25,0x64
	.DB  0x0,0x25,0x0,0x3C,0x32,0x20,0x33,0x3E
	.DB  0x20,0x34,0x7E,0x0,0xA5,0xB7,0xBC,0x2E
	.DB  0x20,0x25,0x64,0x0,0x25,0x20,0x0,0x3C
	.DB  0x20,0x32,0x20,0x20,0x33,0x20,0x3E,0x0
	.DB  0x20,0x20,0x20,0xF7,0x20,0x20,0x20,0x20
	.DB  0x0,0x25,0x64,0x27,0x0,0xFF,0x0,0x64
	.DB  0x65,0x76,0x69,0x63,0x65,0x3D,0x25,0x75
	.DB  0x0,0x72,0x65,0x61,0x64,0x69,0x6E,0x67
	.DB  0x0,0x48,0x65,0xBF,0x20,0xBF,0x65,0xBC
	.DB  0xBE,0xE3,0x61,0xBF,0xC0,0xB8,0xBA,0x6F
	.DB  0xB3,0x0,0x73,0x5F,0x6C,0x69,0x74,0x20
	.DB  0x40,0x20,0x20,0x75,0x6B,0x72,0x2E,0x6E
	.DB  0x65,0x74,0x0,0xA4,0x61,0xB3,0x65,0xE3
	.DB  0xB8,0x20,0x20,0x20,0x20,0x20,0xB2,0x61
	.DB  0xB9,0xBA,0x0,0x48,0x61,0xB2,0x65,0x70
	.DB  0xB8,0x20,0x20,0x31,0x30,0x30,0x30,0x6F
	.DB  0xB2,0x2F,0xBC,0x0,0x20,0x20,0x20,0x20
	.DB  0x20,0x3A,0x25,0x64,0x20,0x20,0x20,0x0
	.DB  0x25,0x64,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x41,0x56,0x52,0x3A,0x25,0x64,0x0
	.DB  0xAA,0xA9,0x4F,0xA4,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x42,0xBA,0xBB
	.DB  0x0,0xAA,0xA9,0x4F,0xA4,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x42,0xC3,0xBA
	.DB  0xBB,0x0,0xA8,0x70,0x6F,0xB4,0x70,0x65
	.DB  0xB3,0x20,0x63,0xB3,0x65,0xC0,0x65,0xB9
	.DB  0x2E,0x2E,0x0,0x20,0xA1,0x6F,0xBF,0x6F
	.DB  0xB3,0x6F,0x0,0x43,0xBD,0x61,0xC0,0x61
	.DB  0xBB,0x61,0x20,0x20,0xB7,0x61,0xB4,0xBB
	.DB  0x79,0xC1,0xB8,0x0,0xA9,0xB4,0xBB,0xC3
	.DB  0x20,0xBE,0x6F,0x20,0x79,0xBC,0x6F,0xBB
	.DB  0xC0,0x61,0xBD,0x2E,0x0,0x43,0xB2,0x70
	.DB  0x6F,0x63,0xC4,0x20,0x20,0x6F,0xB2,0x6F
	.DB  0x70,0x6F,0xBF,0xC3,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0xCE,0x3D,0x25,0x64,0x0,0x25
	.DB  0x20,0x20,0x0,0x20,0x20,0x20,0x20,0xB3
	.DB  0xC3,0xBA,0xBB,0x25,0x64,0x0
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x2040003:
	.DB  0x80,0xC0
_0x20C0060:
	.DB  0x1
_0x20C0000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  _sek
	.DW  _0x3*2

	.DW  0x01
	.DW  _kk
	.DW  _0x4*2

	.DW  0x1E
	.DW  _temp_ugly
	.DW  _0x5*2

	.DW  0x02
	.DW  _0x24
	.DW  _0x0*2+9

	.DW  0x09
	.DW  _0x24+2
	.DW  _0x0*2+11

	.DW  0x03
	.DW  _0x25
	.DW  _0x0*2+28

	.DW  0x09
	.DW  _0x25+3
	.DW  _0x0*2+31

	.DW  0x09
	.DW  _0x26
	.DW  _0x0*2+40

	.DW  0x08
	.DW  _0x2D
	.DW  _0x0*2+65

	.DW  0x11
	.DW  _0x2D+8
	.DW  _0x0*2+73

	.DW  0x11
	.DW  _0x2D+25
	.DW  _0x0*2+90

	.DW  0x10
	.DW  _0x2D+42
	.DW  _0x0*2+107

	.DW  0x11
	.DW  _0x2D+58
	.DW  _0x0*2+123

	.DW  0x11
	.DW  _0x2D+75
	.DW  _0x0*2+168

	.DW  0x11
	.DW  _0x2D+92
	.DW  _0x0*2+185

	.DW  0x11
	.DW  _0x2D+109
	.DW  _0x0*2+202

	.DW  0x08
	.DW  _0x2D+126
	.DW  _0x0*2+219

	.DW  0x11
	.DW  _0x2D+134
	.DW  _0x0*2+227

	.DW  0x11
	.DW  _0x2D+151
	.DW  _0x0*2+244

	.DW  0x11
	.DW  _0x2D+168
	.DW  _0x0*2+90

	.DW  0x10
	.DW  _0x2D+185
	.DW  _0x0*2+261

	.DW  0x04
	.DW  _0x2D+201
	.DW  _0x0*2+287

	.DW  0x08
	.DW  0x06
	.DW  _0x89*2

	.DW  0x02
	.DW  __base_y_G102
	.DW  _0x2040003*2

	.DW  0x01
	.DW  __seed_G106
	.DW  _0x20C0060*2

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

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;
;//
;//Warning: E:\Электроника\NEW_FUOZ\Новая папка\last.c(31): the 'double' data type will be supported only in the 'Professional' version, defaulting to 'float'
;//
;//
;//
;//    ПЕРЕКОМПИЛИРОВАТЬ В ПОЛНОЙ ВЕРСИИ
;//
;//
;//
;//
;
;
;
;
;/*****************************************************
;Date                : 16.03.2012
;Chip type           : ATmega16
;Program type        : Application
;Clock frequency     : 16,000000 MHz
;Memory model        : Small
;External SRAM size  : 0
;Data Stack size     : 256
;*****************************************************/
;
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <stdio.h>
;
;
;// 1 Wire Bus functions
;//#asm
;//   .equ __w1_port=0x1B ;PORTA
;//   .equ __w1_bit=2
;//#endasm
;//#include <1wire.h>
;#include <ds18b20.h>
;#include <alcd.h>
;
;unsigned char devices;
;unsigned char RomCode[2][9];
;
;
;char buffer[16];
;int oper=0,yes=0,oboroty=0,ob_y=0,uoz_i=0,zn1=0,zn2=0,sek=2,ob_min=0,temp1,temp2,temp_buf,i=0,kk=7;

	.DSEG
;int temp_ugly[15]={480,480,480,480,480,480,480,480,480,480,480,480,480,480,480};
;
;
;
;eeprom int temp_f,f,percent[4][8],prer_ugly[8];
;
;
;
;
;// скорость счета 16 000 000, размер таймера 256, т.е. в секунду он переполнится около 62500 раз
;// чтобы кол-во переполнений было точным (64 прер/мс), уменьшим размер таймера до 250, значит стартовать он должен с 5 (0x05)
;// максимальная скорость прохода модулятора 2.22 мс при 9000 об/мин. (120 градусов)
;// значит прерывание сработает 2.2*64=140.8 раз
;// а максимальное время прохода при 900 об/мин составит 22.2мс = 1420.8 раз
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 003F {

	.CSEG
_timer0_ovf_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0040 
; 0000 0041 // Reinitialize Timer 0 value
; 0000 0042 TCNT0=0x05;
	LDI  R30,LOW(5)
	OUT  0x32,R30
; 0000 0043 ////////////////////////////////////////////////////
; 0000 0044 //опрашиваем датчик 64 раза в 1 мс
; 0000 0045 
; 0000 0046 zn1=zn2;             // сохраняем предыдущее значение
	LDS  R30,_zn2
	LDS  R31,_zn2+1
	STS  _zn1,R30
	STS  _zn1+1,R31
; 0000 0047 zn2=PINA.6;          // считываем новое              //PIND.2 !!!
	LDI  R30,0
	SBIC 0x19,6
	LDI  R30,1
	LDI  R31,0
	STS  _zn2,R30
	STS  _zn2+1,R31
; 0000 0048 
; 0000 0049 //if(f==4)             // f=4 ФУОЗ отключен
; 0000 004A //   {
; 0000 004B //          PORTD.3=PINA.6;        //PORTD.6 = PIND.2 !!!
; 0000 004C //           if((zn1==0) && (zn2==1)) ob_min++;
; 0000 004D //   }
; 0000 004E //
; 0000 004F //else
; 0000 0050 //{
; 0000 0051    if(zn1==zn2)
	LDS  R26,_zn1
	LDS  R27,_zn1+1
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x6
; 0000 0052 
; 0000 0053       if(zn2==1)
	LDS  R26,_zn2
	LDS  R27,_zn2+1
	SBIW R26,1
	BRNE _0x7
; 0000 0054          if(yes<(prer_ugly[7]+prer_ugly[7])) yes++;
	__POINTW2MN _prer_ugly,14
	CALL __EEPROMRDW
	MOVW R0,R30
	ADD  R30,R0
	ADC  R31,R1
	CP   R8,R30
	CPC  R9,R31
	BRGE _0x8
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 0055          else PORTD.3=0;                                 //PORTD.6 !!!
	RJMP _0x9
_0x8:
	CBI  0x12,3
; 0000 0056       else
_0x9:
	RJMP _0xC
_0x7:
; 0000 0057          if(yes>0) yes--;
	CLR  R0
	CP   R0,R8
	CPC  R0,R9
	BRGE _0xD
	MOVW R30,R8
	SBIW R30,1
	MOVW R8,R30
; 0000 0058          else PORTD.3=0;        //PORTD.6 !!!
	RJMP _0xE
_0xD:
	CBI  0x12,3
; 0000 0059 
; 0000 005A     else
_0xE:
_0xC:
	RJMP _0x11
_0x6:
; 0000 005B 
; 0000 005C       if(yes==0) {PORTD.3=1; ob_min++;}   //PORTD.6 !!!
	MOV  R0,R8
	OR   R0,R9
	BRNE _0x12
	SBI  0x12,3
	LDI  R26,LOW(_ob_min)
	LDI  R27,HIGH(_ob_min)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 005D       else
	RJMP _0x15
_0x12:
; 0000 005E        {
; 0000 005F 
; 0000 0060         if(yes>prer_ugly[3])                   // дерево выбора оборотов
	__POINTW2MN _prer_ugly,6
	CALL __EEPROMRDW
	CP   R30,R8
	CPC  R31,R9
	BRGE _0x16
; 0000 0061            if(yes>prer_ugly[5])
	__POINTW2MN _prer_ugly,10
	CALL __EEPROMRDW
	CP   R30,R8
	CPC  R31,R9
	BRGE _0x17
; 0000 0062              if(yes>prer_ugly[6]) kk=7;
	__POINTW2MN _prer_ugly,12
	CALL __EEPROMRDW
	CP   R30,R8
	CPC  R31,R9
	BRGE _0x18
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	RJMP _0x84
; 0000 0063              else kk=6;
_0x18:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
_0x84:
	STS  _kk,R30
	STS  _kk+1,R31
; 0000 0064            else
	RJMP _0x1A
_0x17:
; 0000 0065              if(yes>prer_ugly[4]) kk=5;
	__POINTW2MN _prer_ugly,8
	CALL __EEPROMRDW
	CP   R30,R8
	CPC  R31,R9
	BRGE _0x1B
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RJMP _0x85
; 0000 0066              else kk=4;
_0x1B:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
_0x85:
	STS  _kk,R30
	STS  _kk+1,R31
; 0000 0067         else
_0x1A:
	RJMP _0x1D
_0x16:
; 0000 0068            if(yes>prer_ugly[1])
	__POINTW2MN _prer_ugly,2
	CALL __EEPROMRDW
	CP   R30,R8
	CPC  R31,R9
	BRGE _0x1E
; 0000 0069              if(yes>prer_ugly[2]) kk=3;
	__POINTW2MN _prer_ugly,4
	CALL __EEPROMRDW
	CP   R30,R8
	CPC  R31,R9
	BRGE _0x1F
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP _0x86
; 0000 006A              else kk=2;
_0x1F:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
_0x86:
	STS  _kk,R30
	STS  _kk+1,R31
; 0000 006B            else
	RJMP _0x21
_0x1E:
; 0000 006C              if(yes>prer_ugly[0]) kk=1;
	LDI  R26,LOW(_prer_ugly)
	LDI  R27,HIGH(_prer_ugly)
	CALL __EEPROMRDW
	CP   R30,R8
	CPC  R31,R9
	BRGE _0x22
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _kk,R30
	STS  _kk+1,R31
; 0000 006D              else kk=0;
	RJMP _0x23
_0x22:
	LDI  R30,LOW(0)
	STS  _kk,R30
	STS  _kk+1,R30
; 0000 006E 
; 0000 006F          ob_y=yes;
_0x23:
_0x21:
_0x1D:
	MOVW R12,R8
; 0000 0070          oper=yes-((yes*percent[f][kk])/100);
	LDI  R26,LOW(_f)
	LDI  R27,HIGH(_f)
	CALL __EEPROMRDW
	CALL __LSLW4
	SUBI R30,LOW(-_percent)
	SBCI R31,HIGH(-_percent)
	MOVW R26,R30
	LDS  R30,_kk
	LDS  R31,_kk+1
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	MOVW R26,R8
	CALL __MULW12
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	MOVW R26,R30
	MOVW R30,R8
	SUB  R30,R26
	SBC  R31,R27
	MOVW R6,R30
; 0000 0071          yes=oper;
	MOVW R8,R6
; 0000 0072          }
_0x15:
_0x11:
; 0000 0073 //}
; 0000 0074 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;// Timer 1 overflow interrupt service routine
;// 65536 - 62500 = 3036; 31250=
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0079 {
_timer1_ovf_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 007A TCNT1=34000;   //34000
	LDI  R30,LOW(34000)
	LDI  R31,HIGH(34000)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
; 0000 007B sek++;
	LDI  R26,LOW(_sek)
	LDI  R27,HIGH(_sek)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 007C }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;
;// Timer 1 output compare A interrupt service routine
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 0080 {
_timer1_compa_isr:
; 0000 0081 }
	RETI
;
;// Timer 1 output compare B interrupt service routine
;interrupt [TIM1_COMPB] void timer1_compb_isr(void)
; 0000 0085 {
_timer1_compb_isr:
; 0000 0086 }
	RETI
;
;
;void menu1(void)
; 0000 008A {
_menu1:
; 0000 008B         lcd_clear();
	CALL _lcd_clear
; 0000 008C         sprintf(buffer,"  %dx",uoz_i); //
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_uoz_i
	LDS  R31,_uoz_i+1
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 008D         lcd_puts(buffer);
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 008E         sprintf(buffer,"%d",percent[f][7-uoz_i]);
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,6
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_f)
	LDI  R27,HIGH(_f)
	CALL __EEPROMRDW
	CALL __LSLW4
	SUBI R30,LOW(-_percent)
	SBCI R31,HIGH(-_percent)
	MOVW R0,R30
	LDS  R26,_uoz_i
	LDS  R27,_uoz_i+1
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 008F         lcd_puts(buffer);
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 0090         lcd_puts("\x25");   // symbol %
	__POINTW1MN _0x24,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 0091         lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0092         lcd_puts("<2 3> 4\x7E");
	__POINTW1MN _0x24,2
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 0093 
; 0000 0094 
; 0000 0095         ////  sprintf(buffer,"%.0f\x27",UOZ_proc[8-uoz_i]); // вывод вещественного числа на экран
; 0000 0096 }
	RET

	.DSEG
_0x24:
	.BYTE 0xB
;
;void menu2(void)
; 0000 0099 {       lcd_gotoxy(0,0);

	.CSEG
_menu2:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 009A           //New:
; 0000 009B         sprintf(buffer,"\xA5\xB7\xBC. %d",percent[f][7-uoz_i]);
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,20
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_f)
	LDI  R27,HIGH(_f)
	CALL __EEPROMRDW
	CALL __LSLW4
	SUBI R30,LOW(-_percent)
	SBCI R31,HIGH(-_percent)
	MOVW R0,R30
	LDS  R26,_uoz_i
	LDS  R27,_uoz_i+1
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 009C         lcd_puts(buffer);
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 009D         lcd_puts("\x25 ");   // symbol %
	__POINTW1MN _0x25,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 009E         lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 009F         lcd_puts("< 2  3 >");
	__POINTW1MN _0x25,3
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 00A0         delay_ms(20);
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RJMP _0x20E000A
; 0000 00A1 
; 0000 00A2 }

	.DSEG
_0x25:
	.BYTE 0xC
;
;void menu_temp(void)
; 0000 00A5 {

	.CSEG
_menu_temp:
; 0000 00A6 
; 0000 00A7         lcd_puts("   \xF7    ");
	__POINTW1MN _0x26,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 00A8 
; 0000 00A9         if (temp1>1000)                   //если датчик 1 выдает больше 1000
	LDS  R26,_temp1
	LDS  R27,_temp1+1
	CPI  R26,LOW(0x3E9)
	LDI  R30,HIGH(0x3E9)
	CPC  R27,R30
	BRLT _0x27
; 0000 00AA           temp1=(-1)*(4096-temp1);        //отнимем от данных 4096 и ставим знак "минус"
	LDI  R30,LOW(4096)
	LDI  R31,HIGH(4096)
	SUB  R30,R26
	SBC  R31,R27
	LDI  R26,LOW(65535)
	LDI  R27,HIGH(65535)
	CALL __MULW12
	STS  _temp1,R30
	STS  _temp1+1,R31
; 0000 00AB 
; 0000 00AC 
; 0000 00AD         sprintf(buffer,"%d\x27",temp1);
_0x27:
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,49
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_temp1
	LDS  R31,_temp1+1
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 00AE         lcd_puts(buffer);
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 00AF 
; 0000 00B0 
; 0000 00B1 
; 0000 00B2         if (temp2>1000)                   //если датчик 2 выдает больше 1000
	LDS  R26,_temp2
	LDS  R27,_temp2+1
	CPI  R26,LOW(0x3E9)
	LDI  R30,HIGH(0x3E9)
	CPC  R27,R30
	BRLT _0x28
; 0000 00B3           temp2=(-1)*(4096-temp2);        //отнимем от данных 4096 и ставим знак "минус"
	LDI  R30,LOW(4096)
	LDI  R31,HIGH(4096)
	SUB  R30,R26
	SBC  R31,R27
	LDI  R26,LOW(65535)
	LDI  R27,HIGH(65535)
	CALL __MULW12
	STS  _temp2,R30
	STS  _temp2+1,R31
; 0000 00B4 
; 0000 00B5 
; 0000 00B6         lcd_gotoxy(5,1);
_0x28:
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 00B7         sprintf(buffer,"%d\x27",temp2);
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,49
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_temp2
	LDS  R31,_temp2+1
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 00B8         lcd_puts(buffer);
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 00B9 
; 0000 00BA         delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
_0x20E000A:
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 00BB 
; 0000 00BC }
	RET

	.DSEG
_0x26:
	.BYTE 0x9
;
;void default_set (void)
; 0000 00BF {

	.CSEG
_default_set:
; 0000 00C0 
; 0000 00C1  //таблица времени прохода шторки в прерываниях
; 0000 00C2 
; 0000 00C3  prer_ugly[0]=60;
	LDI  R26,LOW(_prer_ugly)
	LDI  R27,HIGH(_prer_ugly)
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL __EEPROMWRW
; 0000 00C4  prer_ugly[1]=69;
	__POINTW2MN _prer_ugly,2
	LDI  R30,LOW(69)
	LDI  R31,HIGH(69)
	CALL __EEPROMWRW
; 0000 00C5  prer_ugly[2]=80;
	__POINTW2MN _prer_ugly,4
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	CALL __EEPROMWRW
; 0000 00C6  prer_ugly[3]=96;
	__POINTW2MN _prer_ugly,6
	LDI  R30,LOW(96)
	LDI  R31,HIGH(96)
	CALL __EEPROMWRW
; 0000 00C7  prer_ugly[4]=120;
	__POINTW2MN _prer_ugly,8
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	CALL __EEPROMWRW
; 0000 00C8  prer_ugly[5]=160;
	__POINTW2MN _prer_ugly,10
	LDI  R30,LOW(160)
	LDI  R31,HIGH(160)
	CALL __EEPROMWRW
; 0000 00C9  prer_ugly[6]=240;
	__POINTW2MN _prer_ugly,12
	LDI  R30,LOW(240)
	LDI  R31,HIGH(240)
	CALL __EEPROMWRW
; 0000 00CA  prer_ugly[7]=480;
	__POINTW2MN _prer_ugly,14
	LDI  R30,LOW(480)
	LDI  R31,HIGH(480)
	CALL __EEPROMWRW
; 0000 00CB 
; 0000 00CC 
; 0000 00CD  // таблица процентов опережения
; 0000 00CE  percent[0][0]=98;  percent[1][0]=62;  percent[2][0]=58;   percent[3][0]=68;   // от 7000 до 8000 об/мин
	LDI  R26,LOW(_percent)
	LDI  R27,HIGH(_percent)
	LDI  R30,LOW(98)
	LDI  R31,HIGH(98)
	CALL __EEPROMWRW
	__POINTW2MN _percent,16
	LDI  R30,LOW(62)
	LDI  R31,HIGH(62)
	CALL __EEPROMWRW
	__POINTW2MN _percent,32
	LDI  R30,LOW(58)
	LDI  R31,HIGH(58)
	CALL __EEPROMWRW
	__POINTW2MN _percent,48
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	CALL __EEPROMWRW
; 0000 00CF  percent[0][1]=98;  percent[1][1]=60;  percent[2][1]=57;   percent[3][1]=68;   // от 6000 до 7000 об/мин
	__POINTW2MN _percent,2
	LDI  R30,LOW(98)
	LDI  R31,HIGH(98)
	CALL __EEPROMWRW
	__POINTW2MN _percent,18
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL __EEPROMWRW
	__POINTW2MN _percent,34
	LDI  R30,LOW(57)
	LDI  R31,HIGH(57)
	CALL __EEPROMWRW
	__POINTW2MN _percent,50
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	CALL __EEPROMWRW
; 0000 00D0  percent[0][2]=98;  percent[1][2]=59;  percent[2][2]=54;   percent[3][2]=65;   // от 5000 до 6000 об/мин
	__POINTW2MN _percent,4
	LDI  R30,LOW(98)
	LDI  R31,HIGH(98)
	CALL __EEPROMWRW
	__POINTW2MN _percent,20
	LDI  R30,LOW(59)
	LDI  R31,HIGH(59)
	CALL __EEPROMWRW
	__POINTW2MN _percent,36
	LDI  R30,LOW(54)
	LDI  R31,HIGH(54)
	CALL __EEPROMWRW
	__POINTW2MN _percent,52
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	CALL __EEPROMWRW
; 0000 00D1  percent[0][3]=98;  percent[1][3]=55;  percent[2][3]=52;   percent[3][3]=54;   // от 4000 до 5000 об/мин
	__POINTW2MN _percent,6
	LDI  R30,LOW(98)
	LDI  R31,HIGH(98)
	CALL __EEPROMWRW
	__POINTW2MN _percent,22
	LDI  R30,LOW(55)
	LDI  R31,HIGH(55)
	CALL __EEPROMWRW
	__POINTW2MN _percent,38
	LDI  R30,LOW(52)
	LDI  R31,HIGH(52)
	CALL __EEPROMWRW
	__POINTW2MN _percent,54
	LDI  R30,LOW(54)
	LDI  R31,HIGH(54)
	CALL __EEPROMWRW
; 0000 00D2  percent[0][4]=98;  percent[1][4]=50;  percent[2][4]=49;   percent[3][4]=49;   // от 3000 до 4000 об/мин
	__POINTW2MN _percent,8
	LDI  R30,LOW(98)
	LDI  R31,HIGH(98)
	CALL __EEPROMWRW
	__POINTW2MN _percent,24
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL __EEPROMWRW
	__POINTW2MN _percent,40
	LDI  R30,LOW(49)
	LDI  R31,HIGH(49)
	CALL __EEPROMWRW
	__POINTW2MN _percent,56
	CALL __EEPROMWRW
; 0000 00D3  percent[0][5]=98;  percent[1][5]=19;  percent[2][5]=48;   percent[3][5]=48;   // от 2000 до 3000 об/мин
	__POINTW2MN _percent,10
	LDI  R30,LOW(98)
	LDI  R31,HIGH(98)
	CALL __EEPROMWRW
	__POINTW2MN _percent,26
	LDI  R30,LOW(19)
	LDI  R31,HIGH(19)
	CALL __EEPROMWRW
	__POINTW2MN _percent,42
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	CALL __EEPROMWRW
	__POINTW2MN _percent,58
	CALL __EEPROMWRW
; 0000 00D4  percent[0][6]=98;  percent[1][6]=5;   percent[2][6]=18;   percent[3][6]=18;   // от 1000 до 2000 об/мин
	__POINTW2MN _percent,12
	LDI  R30,LOW(98)
	LDI  R31,HIGH(98)
	CALL __EEPROMWRW
	__POINTW2MN _percent,28
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EEPROMWRW
	__POINTW2MN _percent,44
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	CALL __EEPROMWRW
	__POINTW2MN _percent,60
	CALL __EEPROMWRW
; 0000 00D5  percent[0][7]=0;   percent[1][7]=0;   percent[2][7]=0;    percent[3][7]=0;    // от 0 до 1000 об/мин
	__POINTW2MN _percent,14
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EEPROMWRW
	__POINTW2MN _percent,30
	CALL __EEPROMWRW
	__POINTW2MN _percent,46
	CALL __EEPROMWRW
	__POINTW2MN _percent,62
	CALL __EEPROMWRW
; 0000 00D6                                                                                // послеждний столбец активируется при режиме "без ФУОЗ"
; 0000 00D7 
; 0000 00D8  f=0;
	LDI  R26,LOW(_f)
	LDI  R27,HIGH(_f)
	CALL __EEPROMWRW
; 0000 00D9  temp_f=4;
	LDI  R26,LOW(_temp_f)
	LDI  R27,HIGH(_temp_f)
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __EEPROMWRW
; 0000 00DA }
	RET
;
;
;void main(void)
; 0000 00DE {
_main:
; 0000 00DF // Declare your local variables here
; 0000 00E0 
; 0000 00E1 
; 0000 00E2 PORTA=0xff;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
; 0000 00E3 DDRA=0x00;             // В новом, PORTA.6 - это вход инфракрасного датчика
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 00E4 
; 0000 00E5 PORTB=0x00;
	OUT  0x18,R30
; 0000 00E6 DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 00E7 
; 0000 00E8 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 00E9 DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 00EA 
; 0000 00EB PORTD=0b10110111;
	LDI  R30,LOW(183)
	OUT  0x12,R30
; 0000 00EC  DDRD=0b11001000;  //   старый :DDRD=0b11000000; !!!  В новом, PORTD.3 - это выход на зажигание.
	LDI  R30,LOW(200)
	OUT  0x11,R30
; 0000 00ED 
; 0000 00EE // Timer/Counter 0 initialization
; 0000 00EF // Clock source: System Clock
; 0000 00F0 // Clock value: 16000,000 kHz
; 0000 00F1 // Mode: Normal top=FFh
; 0000 00F2 // OC0 output: Disconnected
; 0000 00F3 TCCR0=0x01;
	LDI  R30,LOW(1)
	OUT  0x33,R30
; 0000 00F4 TCNT0=0x05;
	LDI  R30,LOW(5)
	OUT  0x32,R30
; 0000 00F5 OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 00F6 
; 0000 00F7 // Timer/Counter 1 initialization
; 0000 00F8 // Clock source: System Clock
; 0000 00F9 // Clock value: 62,500 kHz
; 0000 00FA // Mode: Normal top=0xFFFF
; 0000 00FB // OC1A output: Discon.
; 0000 00FC // OC1B output: Discon.
; 0000 00FD // Noise Canceler: Off
; 0000 00FE // Input Capture on Falling Edge
; 0000 00FF // Timer1 Overflow Interrupt: On
; 0000 0100 // Input Capture Interrupt: Off
; 0000 0101 // Compare A Match Interrupt: Off
; 0000 0102 // Compare B Match Interrupt: Off
; 0000 0103 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 0104 TCCR1B=0x04;
	LDI  R30,LOW(4)
	OUT  0x2E,R30
; 0000 0105 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0106 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0107 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0108 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0109 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 010A OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 010B OCR1BH=0x00;
	OUT  0x29,R30
; 0000 010C OCR1BL=0x00;
	OUT  0x28,R30
; 0000 010D 
; 0000 010E 
; 0000 010F // Timer/Counter 2 initialization
; 0000 0110 // Clock source: System Clock
; 0000 0111 // Clock value: Timer2 Stopped
; 0000 0112 // Mode: Normal top=0xFF
; 0000 0113 // OC2 output: Disconnected
; 0000 0114 ASSR=0x00;
	OUT  0x22,R30
; 0000 0115 TCCR2=0x00;
	OUT  0x25,R30
; 0000 0116 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0117 OCR2=0x00;
	OUT  0x23,R30
; 0000 0118 
; 0000 0119 
; 0000 011A // External Interrupt(s) initialization
; 0000 011B // INT0: On
; 0000 011C // INT0 Mode: Rising Edge
; 0000 011D // INT1: Off
; 0000 011E // INT2: Off
; 0000 011F //GICR|=0x40;         /* Регистр General Interrupt Control Register разрешает внешние прерывания
; 0000 0120 //                                      10 000000 - по выводу int1;
; 0000 0121 //                                      01 000000 - по выводу into;
; 0000 0122 //                                      11 000000 - по обоим выводам */
; 0000 0123 //
; 0000 0124 //MCUCR=0x03;          /* Регистр Micro Controller Unit Control Registr настраивает прерывание на срабатывание:
; 0000 0125 //                                           0000 10 00 - по спадающему фронту сигнала на выводе int1;
; 0000 0126 //                                           0000 11 00 - по нарастающему фронту сигнала на выводе int1;
; 0000 0127 //                                           0000 00 00 - по низкому уровню на выводе int1;
; 0000 0128 //                                           0000 01 00 - по любому изменению уровня на выводе int1 */
; 0000 0129 
; 0000 012A MCUCR=0x00;
	OUT  0x35,R30
; 0000 012B MCUCSR=0x00;
	OUT  0x34,R30
; 0000 012C 
; 0000 012D // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 012E TIMSK=0x1D;
	LDI  R30,LOW(29)
	OUT  0x39,R30
; 0000 012F // Analog Comparator initialization
; 0000 0130 // Analog Comparator: Off
; 0000 0131 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0132 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0133 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0134 
; 0000 0135 
; 0000 0136 
; 0000 0137 lcd_init(8);             // инициализация дисплея
	LDI  R30,LOW(8)
	ST   -Y,R30
	CALL _lcd_init
; 0000 0138 lcd_clear();
	CALL _lcd_clear
; 0000 0139 
; 0000 013A for(i=0;i<8;i++)
	LDI  R30,LOW(0)
	STS  _i,R30
	STS  _i+1,R30
_0x2A:
	LDS  R26,_i
	LDS  R27,_i+1
	SBIW R26,8
	BRGE _0x2B
; 0000 013B {
; 0000 013C lcd_gotoxy(i,0);
	LDS  R30,_i
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 013D lcd_putsf("\xFF");
	__POINTW1FN _0x0,53
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 013E lcd_gotoxy(i,1);
	LDS  R30,_i
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 013F lcd_putsf("\xFF");
	__POINTW1FN _0x0,53
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0140 delay_ms(40);
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0141 }
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RJMP _0x2A
_0x2B:
; 0000 0142 
; 0000 0143 lcd_clear();
	CALL _lcd_clear
; 0000 0144 
; 0000 0145 
; 0000 0146 /////////////////////// SOUND TA-TA....
; 0000 0147 //for(i=0;i<20;i++)
; 0000 0148 //{
; 0000 0149 //PORTD.6=1;
; 0000 014A //delay_ms(1);
; 0000 014B //PORTD.6=0;
; 0000 014C //delay_ms(1);
; 0000 014D //}
; 0000 014E //delay_ms(60);
; 0000 014F //
; 0000 0150 // for(i=0;i<20;i++)
; 0000 0151 //{
; 0000 0152 //PORTD.6=1;
; 0000 0153 //delay_ms(1);
; 0000 0154 //PORTD.6=0;
; 0000 0155 //delay_ms(1);
; 0000 0156 //}
; 0000 0157 
; 0000 0158   devices=w1_search(DS18B20_SEARCH_ROM_CMD, RomCode); //поиск датчиков на линии 1-wire
	LDI  R30,LOW(240)
	ST   -Y,R30
	LDI  R30,LOW(_RomCode)
	LDI  R31,HIGH(_RomCode)
	ST   -Y,R31
	ST   -Y,R30
	CALL _w1_search
	MOV  R5,R30
; 0000 0159 
; 0000 015A   if(devices)
	TST  R5
	BRNE PC+3
	JMP _0x2C
; 0000 015B   {
; 0000 015C ///////////////////////// показываем найденные устройства 1-wire
; 0000 015D     lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 015E     sprintf(buffer,"device=%u", devices); //выводим информацию о кол-ве датчиков
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,55
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R5
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 015F     lcd_puts(buffer);
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 0160     lcd_gotoxy( 0,1 );
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0161     lcd_puts("reading");
	__POINTW1MN _0x2D,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 0162     delay_ms(300);
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0163 
; 0000 0164     ds18b20_init(&RomCode[0][0], 50, 140, DS18B20_9BIT_RES); //инициализация первого датчика
	LDI  R30,LOW(_RomCode)
	LDI  R31,HIGH(_RomCode)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(50)
	ST   -Y,R30
	LDI  R30,LOW(140)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _ds18b20_init
; 0000 0165     ds18b20_init(&RomCode[1][0], 50, 140, DS18B20_9BIT_RES); //инициализация второго датчика
	__POINTW1MN _RomCode,9
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(50)
	ST   -Y,R30
	LDI  R30,LOW(140)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _ds18b20_init
; 0000 0166     lcd_clear();
	CALL _lcd_clear
; 0000 0167     temp1=ds18b20_temperature(&RomCode[0][0]);//чтение температуры 1 датчика
	LDI  R30,LOW(_RomCode)
	LDI  R31,HIGH(_RomCode)
	ST   -Y,R31
	ST   -Y,R30
	CALL _ds18b20_temperature
	LDI  R26,LOW(_temp1)
	LDI  R27,HIGH(_temp1)
	CALL __CFD1
	ST   X+,R30
	ST   X,R31
; 0000 0168     temp2=ds18b20_temperature(&RomCode[1][0]);//чтение температуры 1 датчика
	__POINTW1MN _RomCode,9
	ST   -Y,R31
	ST   -Y,R30
	CALL _ds18b20_temperature
	LDI  R26,LOW(_temp2)
	LDI  R27,HIGH(_temp2)
	CALL __CFD1
	ST   X+,R30
	ST   X,R31
; 0000 0169      menu_temp();
	RCALL _menu_temp
; 0000 016A      delay_ms(1500);
	LDI  R30,LOW(1500)
	LDI  R31,HIGH(1500)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 016B      lcd_clear();
	CALL _lcd_clear
; 0000 016C 
; 0000 016D      }
; 0000 016E  // else{ lcd_gotoxy(0,0); lcd_puts("NO TEMP.DEVICES"); delay_ms(1500);}
; 0000 016F                                   // Нет темп. датч.
; 0000 0170     else{ lcd_gotoxy(0,0); lcd_puts("\x48\x65\xBF \xBF\x65\xBC\xBE\xE3\x61\xBF\xC0\xB8\xBA\x6F\xB3"); delay_ms(1500);}
	RJMP _0x2E
_0x2C:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
	__POINTW1MN _0x2D,8
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
	LDI  R30,LOW(1500)
	LDI  R31,HIGH(1500)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
_0x2E:
; 0000 0171 
; 0000 0172 
; 0000 0173 
; 0000 0174 
; 0000 0175 #asm("sei")       // Global enable interrupts
	sei
; 0000 0176 TCNT1=0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
; 0000 0177 sek=0;
	STS  _sek,R30
	STS  _sek+1,R30
; 0000 0178              //калибровка модулятора
; 0000 0179 
; 0000 017A lcd_puts("s_lit \x40  ukr.net");
	__POINTW1MN _0x2D,25
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 017B delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 017C if(PINA.0==0)
	SBIC 0x19,0
	RJMP _0x2F
; 0000 017D       {
; 0000 017E        lcd_clear();
	CALL _lcd_clear
; 0000 017F         delay_ms(700);
	LDI  R30,LOW(700)
	LDI  R31,HIGH(700)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0180         // reset all settings
; 0000 0181         default_set();
	RCALL _default_set
; 0000 0182          i=0;
	LDI  R30,LOW(0)
	STS  _i,R30
	STS  _i+1,R30
; 0000 0183 
; 0000 0184         // режим Без ФУОЗ
; 0000 0185         f=f+temp_f;
	LDI  R26,LOW(_f)
	LDI  R27,HIGH(_f)
	CALL __EEPROMRDW
	MOVW R0,R30
	LDI  R26,LOW(_temp_f)
	LDI  R27,HIGH(_temp_f)
	CALL __EEPROMRDW
	ADD  R30,R0
	ADC  R31,R1
	LDI  R26,LOW(_f)
	LDI  R27,HIGH(_f)
	CALL __EEPROMWRW
; 0000 0186         temp_f=f-temp_f;
	LDI  R26,LOW(_f)
	LDI  R27,HIGH(_f)
	CALL __EEPROMRDW
	MOVW R0,R30
	LDI  R26,LOW(_temp_f)
	LDI  R27,HIGH(_temp_f)
	CALL __EEPROMRDW
	MOVW R26,R30
	MOVW R30,R0
	SUB  R30,R26
	SBC  R31,R27
	LDI  R26,LOW(_temp_f)
	LDI  R27,HIGH(_temp_f)
	CALL __EEPROMWRW
; 0000 0187         f=f-temp_f;
	LDI  R26,LOW(_f)
	LDI  R27,HIGH(_f)
	CALL __EEPROMRDW
	MOVW R0,R30
	LDI  R26,LOW(_temp_f)
	LDI  R27,HIGH(_temp_f)
	CALL __EEPROMRDW
	MOVW R26,R30
	MOVW R30,R0
	SUB  R30,R26
	SBC  R31,R27
	LDI  R26,LOW(_f)
	LDI  R27,HIGH(_f)
	CALL __EEPROMWRW
; 0000 0188 
; 0000 0189                                //заведи байк
; 0000 018A         lcd_clear(); lcd_puts("\xA4\x61\xB3\x65\xE3\xB8     \xB2\x61\xB9\xBA"); delay_ms(3000);
	CALL _lcd_clear
	__POINTW1MN _0x2D,42
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 018B 
; 0000 018C 
; 0000 018D 
; 0000 018E       // ждем, пока заведет
; 0000 018F        sek=0;
	LDI  R30,LOW(0)
	STS  _sek,R30
	STS  _sek+1,R30
; 0000 0190 
; 0000 0191        while(oboroty<800)
_0x30:
	LDI  R30,LOW(800)
	LDI  R31,HIGH(800)
	CP   R10,R30
	CPC  R11,R31
	BRGE _0x32
; 0000 0192          {
; 0000 0193          if(sek==1)
	LDS  R26,_sek
	LDS  R27,_sek+1
	SBIW R26,1
	BRNE _0x33
; 0000 0194             {
; 0000 0195              sek=0;
	LDI  R30,LOW(0)
	STS  _sek,R30
	STS  _sek+1,R30
; 0000 0196              oboroty=ob_min*60;
	LDS  R30,_ob_min
	LDS  R31,_ob_min+1
	LDI  R26,LOW(60)
	LDI  R27,HIGH(60)
	CALL __MULW12
	MOVW R10,R30
; 0000 0197              ob_min=0;
	LDI  R30,LOW(0)
	STS  _ob_min,R30
	STS  _ob_min+1,R30
; 0000 0198              }
; 0000 0199          } // завелся
_0x33:
	RJMP _0x30
_0x32:
; 0000 019A 
; 0000 019B                                //набери 1000 об/мин
; 0000 019C         lcd_clear(); lcd_puts("\x48\x61\xB2\x65\x70\xB8  1000\x6F\xB2\x2F\xBC"); delay_ms(3000);
	CALL _lcd_clear
	__POINTW1MN _0x2D,58
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 019D         lcd_clear();
	CALL _lcd_clear
; 0000 019E             sek=0;
	LDI  R30,LOW(0)
	STS  _sek,R30
	STS  _sek+1,R30
; 0000 019F             ob_min=0;
	STS  _ob_min,R30
	STS  _ob_min+1,R30
; 0000 01A0 
; 0000 01A1             // ждем пока наберет 1000 (+- 60) и продержит 2 сек.
; 0000 01A2 
; 0000 01A3        while(i<14)
_0x34:
	LDS  R26,_i
	LDS  R27,_i+1
	SBIW R26,14
	BRLT PC+3
	JMP _0x36
; 0000 01A4        {
; 0000 01A5 
; 0000 01A6             if(sek==1)
	LDS  R26,_sek
	LDS  R27,_sek+1
	SBIW R26,1
	BREQ PC+3
	JMP _0x37
; 0000 01A7               {
; 0000 01A8               sek=0;
	LDI  R30,LOW(0)
	STS  _sek,R30
	STS  _sek+1,R30
; 0000 01A9               oboroty=ob_min*60;
	LDS  R30,_ob_min
	LDS  R31,_ob_min+1
	LDI  R26,LOW(60)
	LDI  R27,HIGH(60)
	CALL __MULW12
	MOVW R10,R30
; 0000 01AA               ob_min=0;
	LDI  R30,LOW(0)
	STS  _ob_min,R30
	STS  _ob_min+1,R30
; 0000 01AB 
; 0000 01AC                if((oboroty>940)&&(oboroty<1060)) {temp_ugly[i]=ob_y; i++;}
	LDI  R30,LOW(940)
	LDI  R31,HIGH(940)
	CP   R30,R10
	CPC  R31,R11
	BRGE _0x39
	LDI  R30,LOW(1060)
	LDI  R31,HIGH(1060)
	CP   R10,R30
	CPC  R11,R31
	BRLT _0x3A
_0x39:
	RJMP _0x38
_0x3A:
	LDS  R30,_i
	LDS  R31,_i+1
	LDI  R26,LOW(_temp_ugly)
	LDI  R27,HIGH(_temp_ugly)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R12
	STD  Z+1,R13
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 01AD                 else i=0;
	RJMP _0x3B
_0x38:
	LDI  R30,LOW(0)
	STS  _i,R30
	STS  _i+1,R30
; 0000 01AE 
; 0000 01AF 
; 0000 01B0               lcd_gotoxy(0,0);
_0x3B:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 01B1               sprintf(buffer,"     :%d   ",15-i);  //wait
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,140
	ST   -Y,R31
	ST   -Y,R30
	LDS  R26,_i
	LDS  R27,_i+1
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	SUB  R30,R26
	SBC  R31,R27
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 01B2               lcd_puts(buffer);
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 01B3               lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 01B4               sprintf(buffer,"%d      ",oboroty);  //показывает обороты (тыс в мин)
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,152
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R10
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 01B5               lcd_puts(buffer);
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 01B6               delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 01B7               }
; 0000 01B8 
; 0000 01B9          } //продержал 2 сек
_0x37:
	RJMP _0x34
_0x36:
; 0000 01BA 
; 0000 01BB           //Done
; 0000 01BC         lcd_clear();
	CALL _lcd_clear
; 0000 01BD 
; 0000 01BE         for(i=0;i<14;i++)
	LDI  R30,LOW(0)
	STS  _i,R30
	STS  _i+1,R30
_0x3D:
	LDS  R26,_i
	LDS  R27,_i+1
	SBIW R26,14
	BRGE _0x3E
; 0000 01BF         temp_buf=temp_buf+temp_ugly[i];
	LDS  R30,_i
	LDS  R31,_i+1
	LDI  R26,LOW(_temp_ugly)
	LDI  R27,HIGH(_temp_ugly)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	LDS  R26,_temp_buf
	LDS  R27,_temp_buf+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _temp_buf,R30
	STS  _temp_buf+1,R31
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RJMP _0x3D
_0x3E:
; 0000 01C1 temp_buf=temp_buf/15;
	LDS  R26,_temp_buf
	LDS  R27,_temp_buf+1
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CALL __DIVW21
	STS  _temp_buf,R30
	STS  _temp_buf+1,R31
; 0000 01C2 
; 0000 01C3         sprintf(buffer,"AVR:%d",temp_buf);  //показывает проход шторки в прерываниях
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,161
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_temp_buf
	LDS  R31,_temp_buf+1
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 01C4         lcd_puts(buffer);
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 01C5 
; 0000 01C6         delay_ms(3000);
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 01C7 
; 0000 01C8         f=f+temp_f;
	LDI  R26,LOW(_f)
	LDI  R27,HIGH(_f)
	CALL __EEPROMRDW
	MOVW R0,R30
	LDI  R26,LOW(_temp_f)
	LDI  R27,HIGH(_temp_f)
	CALL __EEPROMRDW
	ADD  R30,R0
	ADC  R31,R1
	LDI  R26,LOW(_f)
	LDI  R27,HIGH(_f)
	CALL __EEPROMWRW
; 0000 01C9         temp_f=f-temp_f;
	LDI  R26,LOW(_f)
	LDI  R27,HIGH(_f)
	CALL __EEPROMRDW
	MOVW R0,R30
	LDI  R26,LOW(_temp_f)
	LDI  R27,HIGH(_temp_f)
	CALL __EEPROMRDW
	MOVW R26,R30
	MOVW R30,R0
	SUB  R30,R26
	SBC  R31,R27
	LDI  R26,LOW(_temp_f)
	LDI  R27,HIGH(_temp_f)
	CALL __EEPROMWRW
; 0000 01CA         f=f-temp_f;
	LDI  R26,LOW(_f)
	LDI  R27,HIGH(_f)
	CALL __EEPROMRDW
	MOVW R0,R30
	LDI  R26,LOW(_temp_f)
	LDI  R27,HIGH(_temp_f)
	CALL __EEPROMRDW
	MOVW R26,R30
	MOVW R30,R0
	SUB  R30,R26
	SBC  R31,R27
	LDI  R26,LOW(_f)
	LDI  R27,HIGH(_f)
	CALL __EEPROMWRW
; 0000 01CB         } // конец настройки
; 0000 01CC 
; 0000 01CD 
; 0000 01CE while (1)
_0x2F:
_0x3F:
; 0000 01CF       {
; 0000 01D0 
; 0000 01D1            // температура
; 0000 01D2         if(PINA.0==0)             // если нажата кнопка №1. Температура
	SBIC 0x19,0
	RJMP _0x42
; 0000 01D3             {
; 0000 01D4                 delay_ms(50);
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 01D5 
; 0000 01D6                lcd_clear();
	CALL _lcd_clear
; 0000 01D7 
; 0000 01D8              while(PINA.0==0)
_0x43:
	SBIC 0x19,0
	RJMP _0x45
; 0000 01D9                  {
; 0000 01DA                   if((sek>4)&&(oboroty<1100))
	LDS  R26,_sek
	LDS  R27,_sek+1
	SBIW R26,5
	BRLT _0x47
	LDI  R30,LOW(1100)
	LDI  R31,HIGH(1100)
	CP   R10,R30
	CPC  R11,R31
	BRLT _0x48
_0x47:
	RJMP _0x46
_0x48:
; 0000 01DB                   {
; 0000 01DC                   f=f+temp_f;
	LDI  R26,LOW(_f)
	LDI  R27,HIGH(_f)
	CALL __EEPROMRDW
	MOVW R0,R30
	LDI  R26,LOW(_temp_f)
	LDI  R27,HIGH(_temp_f)
	CALL __EEPROMRDW
	ADD  R30,R0
	ADC  R31,R1
	LDI  R26,LOW(_f)
	LDI  R27,HIGH(_f)
	CALL __EEPROMWRW
; 0000 01DD                   temp_f=f-temp_f;
	LDI  R26,LOW(_f)
	LDI  R27,HIGH(_f)
	CALL __EEPROMRDW
	MOVW R0,R30
	LDI  R26,LOW(_temp_f)
	LDI  R27,HIGH(_temp_f)
	CALL __EEPROMRDW
	MOVW R26,R30
	MOVW R30,R0
	SUB  R30,R26
	SBC  R31,R27
	LDI  R26,LOW(_temp_f)
	LDI  R27,HIGH(_temp_f)
	CALL __EEPROMWRW
; 0000 01DE                   f=f-temp_f;
	LDI  R26,LOW(_f)
	LDI  R27,HIGH(_f)
	CALL __EEPROMRDW
	MOVW R0,R30
	LDI  R26,LOW(_temp_f)
	LDI  R27,HIGH(_temp_f)
	CALL __EEPROMRDW
	MOVW R26,R30
	MOVW R30,R0
	SUB  R30,R26
	SBC  R31,R27
	LDI  R26,LOW(_f)
	LDI  R27,HIGH(_f)
	CALL __EEPROMWRW
; 0000 01DF 
; 0000 01E0 
; 0000 01E1                   if(f<4)
	LDI  R26,LOW(_f)
	LDI  R27,HIGH(_f)
	CALL __EEPROMRDW
	SBIW R30,4
	BRGE _0x49
; 0000 01E2                   //lcd_puts("FUOZ ON");
; 0000 01E3                   lcd_puts("\xAA\xA9\x4F\xA4         \x42\xBA\xBB");
	__POINTW1MN _0x2D,75
	RJMP _0x87
; 0000 01E4                   else
_0x49:
; 0000 01E5                   // lcd_puts("FUOZ OFF");
; 0000 01E6                   lcd_puts("\xAA\xA9\x4F\xA4        \x42\xC3\xBA\xBB");
	__POINTW1MN _0x2D,92
_0x87:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 01E7                   delay_ms(700);
	LDI  R30,LOW(700)
	LDI  R31,HIGH(700)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 01E8                   lcd_clear();}
	CALL _lcd_clear
; 0000 01E9                   }
_0x46:
	RJMP _0x43
_0x45:
; 0000 01EA 
; 0000 01EB                 if((sek<3)&&(oboroty<1400)) menu_temp();
	LDS  R26,_sek
	LDS  R27,_sek+1
	SBIW R26,3
	BRGE _0x4C
	LDI  R30,LOW(1400)
	LDI  R31,HIGH(1400)
	CP   R10,R30
	CPC  R11,R31
	BRLT _0x4D
_0x4C:
	RJMP _0x4B
_0x4D:
	RCALL _menu_temp
; 0000 01EC 
; 0000 01ED                  ob_min=0;
_0x4B:
	LDI  R30,LOW(0)
	STS  _ob_min,R30
	STS  _ob_min+1,R30
; 0000 01EE                  sek=0;
	STS  _sek,R30
	STS  _sek+1,R30
; 0000 01EF               }
; 0000 01F0 
; 0000 01F1 
; 0000 01F2              // прогрев свечей
; 0000 01F3          if(PINA.1==0)             // если кнопка нажата
_0x42:
	SBIC 0x19,1
	RJMP _0x4E
; 0000 01F4             {
; 0000 01F5             delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 01F6             if(oboroty==0)
	MOV  R0,R10
	OR   R0,R11
	BRNE _0x4F
; 0000 01F7             {
; 0000 01F8             #asm("cli");
	cli
; 0000 01F9             lcd_clear();
	CALL _lcd_clear
; 0000 01FA             //lcd_puts("Heating spark...");
; 0000 01FB             lcd_puts("\xA8\x70\x6F\xB4\x70\x65\xB3 \x63\xB3\x65\xC0\x65\xB9..");
	__POINTW1MN _0x2D,109
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 01FC             for(i=0;i<50;i++)
	LDI  R30,LOW(0)
	STS  _i,R30
	STS  _i+1,R30
_0x51:
	LDS  R26,_i
	LDS  R27,_i+1
	SBIW R26,50
	BRGE _0x52
; 0000 01FD               {
; 0000 01FE                PORTD.3=1;         //PORTD.6 !!!
	SBI  0x12,3
; 0000 01FF                delay_ms(25);
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0200                PORTD.3=0;         //PORTD.6 !!!
	CBI  0x12,3
; 0000 0201                delay_ms(7);
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0202                }
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RJMP _0x51
_0x52:
; 0000 0203             lcd_clear();
	CALL _lcd_clear
; 0000 0204             //lcd_puts("Finished");
; 0000 0205             lcd_puts(" \xA1\x6F\xBF\x6F\xB3\x6F");
	__POINTW1MN _0x2D,126
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 0206             delay_ms(250);
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0207             #asm("sei");
	sei
; 0000 0208             }
; 0000 0209 
; 0000 020A             else
	RJMP _0x57
_0x4F:
; 0000 020B             {
; 0000 020C              lcd_clear();
	CALL _lcd_clear
; 0000 020D              //lcd_puts("First      off");
; 0000 020E              lcd_puts("\x43\xBD\x61\xC0\x61\xBB\x61  \xB7\x61\xB4\xBB\x79\xC1\xB8");
	__POINTW1MN _0x2D,134
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 020F              delay_ms(300);
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0210              }
_0x57:
; 0000 0211             sek=0;
	LDI  R30,LOW(0)
	STS  _sek,R30
	STS  _sek+1,R30
; 0000 0212             ob_min=0;
	STS  _ob_min,R30
	STS  _ob_min+1,R30
; 0000 0213             }
; 0000 0214 
; 0000 0215              // просмотр каждого процента
; 0000 0216         if(PINA.2==0)             // если кнопка нажата
_0x4E:
	SBIC 0x19,2
	RJMP _0x58
; 0000 0217             {
; 0000 0218             delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0219             while(sek<5)
_0x59:
	LDS  R26,_sek
	LDS  R27,_sek+1
	SBIW R26,5
	BRLT PC+3
	JMP _0x5B
; 0000 021A             {
; 0000 021B             delay_ms(50);
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 021C             if(PINA.0==0) {delay_ms(50);sek=5;}
	SBIC 0x19,0
	RJMP _0x5C
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	STS  _sek,R30
	STS  _sek+1,R31
; 0000 021D             if(PINA.2==0) {delay_ms(100);sek=0;if(uoz_i==7) uoz_i=0;else uoz_i++;menu1();
_0x5C:
	SBIC 0x19,2
	RJMP _0x5D
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDI  R30,LOW(0)
	STS  _sek,R30
	STS  _sek+1,R30
	LDS  R26,_uoz_i
	LDS  R27,_uoz_i+1
	SBIW R26,7
	BRNE _0x5E
	STS  _uoz_i,R30
	STS  _uoz_i+1,R30
	RJMP _0x5F
_0x5E:
	LDI  R26,LOW(_uoz_i)
	LDI  R27,HIGH(_uoz_i)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x5F:
	RCALL _menu1
; 0000 021E              while(PINA.2==0)
_0x60:
	SBIC 0x19,2
	RJMP _0x62
; 0000 021F                  {
; 0000 0220                   if((sek>5) &&(oboroty<1100))
	LDS  R26,_sek
	LDS  R27,_sek+1
	SBIW R26,6
	BRLT _0x64
	LDI  R30,LOW(1100)
	LDI  R31,HIGH(1100)
	CP   R10,R30
	CPC  R11,R31
	BRLT _0x65
_0x64:
	RJMP _0x63
_0x65:
; 0000 0221                   {default_set();
	RCALL _default_set
; 0000 0222                   lcd_clear();
	CALL _lcd_clear
; 0000 0223                   //lcd_puts("DEFAULT  SETTING");
; 0000 0224                   lcd_puts("\xA9\xB4\xBB\xC3 \xBE\x6F \x79\xBC\x6F\xBB\xC0\x61\xBD.");
	__POINTW1MN _0x2D,151
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 0225                   delay_ms(500);sek=5;
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	STS  _sek,R30
	STS  _sek+1,R31
; 0000 0226                   lcd_clear();}
	CALL _lcd_clear
; 0000 0227                   }
_0x63:
	RJMP _0x60
_0x62:
; 0000 0228 
; 0000 0229             }
; 0000 022A             if(PINA.1==0) {delay_ms(100);sek=0;if(uoz_i==0) uoz_i=7;else uoz_i--;menu1();}
_0x5D:
	SBIC 0x19,1
	RJMP _0x66
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDI  R30,LOW(0)
	STS  _sek,R30
	STS  _sek+1,R30
	LDS  R30,_uoz_i
	LDS  R31,_uoz_i+1
	SBIW R30,0
	BRNE _0x67
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	STS  _uoz_i,R30
	STS  _uoz_i+1,R31
	RJMP _0x68
_0x67:
	LDI  R26,LOW(_uoz_i)
	LDI  R27,HIGH(_uoz_i)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x68:
	RCALL _menu1
; 0000 022B             if(PINA.3==0) {delay_ms(80);sek=0;menu2();sek=0;
_0x66:
	SBIC 0x19,3
	RJMP _0x69
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDI  R30,LOW(0)
	STS  _sek,R30
	STS  _sek+1,R30
	RCALL _menu2
	LDI  R30,LOW(0)
	STS  _sek,R30
	STS  _sek+1,R30
; 0000 022C 
; 0000 022D                                     while(sek<4)
_0x6A:
	LDS  R26,_sek
	LDS  R27,_sek+1
	SBIW R26,4
	BRLT PC+3
	JMP _0x6C
; 0000 022E                                     {
; 0000 022F                                     delay_ms(50);
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0230                                     if((PINA.2==0)&&(percent[f][7-uoz_i]<100)) {sek=0; percent[f][7-uoz_i]++;menu2();} //редактируем значение
	LDI  R26,0
	SBIC 0x19,2
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x6E
	LDI  R26,LOW(_f)
	LDI  R27,HIGH(_f)
	CALL __EEPROMRDW
	CALL __LSLW4
	SUBI R30,LOW(-_percent)
	SBCI R31,HIGH(-_percent)
	MOVW R0,R30
	LDS  R26,_uoz_i
	LDS  R27,_uoz_i+1
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BRLT _0x6F
_0x6E:
	RJMP _0x6D
_0x6F:
	LDI  R30,LOW(0)
	STS  _sek,R30
	STS  _sek+1,R30
	LDI  R26,LOW(_f)
	LDI  R27,HIGH(_f)
	CALL __EEPROMRDW
	CALL __LSLW4
	SUBI R30,LOW(-_percent)
	SBCI R31,HIGH(-_percent)
	MOVW R0,R30
	LDS  R26,_uoz_i
	LDS  R27,_uoz_i+1
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
	RCALL _menu2
; 0000 0231                                     if((PINA.1==0)&&(percent[f][7-uoz_i]>0))   {sek=0; percent[f][7-uoz_i]--;menu2();}
_0x6D:
	LDI  R26,0
	SBIC 0x19,1
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x71
	LDI  R26,LOW(_f)
	LDI  R27,HIGH(_f)
	CALL __EEPROMRDW
	CALL __LSLW4
	SUBI R30,LOW(-_percent)
	SBCI R31,HIGH(-_percent)
	MOVW R0,R30
	LDS  R26,_uoz_i
	LDS  R27,_uoz_i+1
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	MOVW R26,R30
	CALL __CPW02
	BRLT _0x72
_0x71:
	RJMP _0x70
_0x72:
	LDI  R30,LOW(0)
	STS  _sek,R30
	STS  _sek+1,R30
	LDI  R26,LOW(_f)
	LDI  R27,HIGH(_f)
	CALL __EEPROMRDW
	CALL __LSLW4
	SUBI R30,LOW(-_percent)
	SBCI R31,HIGH(-_percent)
	MOVW R0,R30
	LDS  R26,_uoz_i
	LDS  R27,_uoz_i+1
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
	RCALL _menu2
; 0000 0232                                     }
_0x70:
	RJMP _0x6A
_0x6C:
; 0000 0233                             }
; 0000 0234                    }
_0x69:
	RJMP _0x59
_0x5B:
; 0000 0235 
; 0000 0236             ob_min=0;
	LDI  R30,LOW(0)
	STS  _ob_min,R30
	STS  _ob_min+1,R30
; 0000 0237             sek=0;}
	STS  _sek,R30
	STS  _sek+1,R30
; 0000 0238 
; 0000 0239            // смена режима
; 0000 023A   if(PINA.3==0)             // если кнопка нажата
_0x58:
	SBIC 0x19,3
	RJMP _0x73
; 0000 023B             {
; 0000 023C              delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 023D 
; 0000 023E              while(PINA.3==0)
_0x74:
	SBIC 0x19,3
	RJMP _0x76
; 0000 023F                  {
; 0000 0240                   if(sek>4)
	LDS  R26,_sek
	LDS  R27,_sek+1
	SBIW R26,5
	BRLT _0x77
; 0000 0241                   {
; 0000 0242                   lcd_clear();
	CALL _lcd_clear
; 0000 0243                   lcd_puts("s_lit \x40  ukr.net");
	__POINTW1MN _0x2D,168
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 0244                   delay_ms(2000);
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0245                    lcd_clear();
	CALL _lcd_clear
; 0000 0246 
; 0000 0247                    }
; 0000 0248                   }
_0x77:
	RJMP _0x74
_0x76:
; 0000 0249             if(sek<2)
	LDS  R26,_sek
	LDS  R27,_sek+1
	SBIW R26,2
	BRGE _0x78
; 0000 024A             if((oboroty<1100))
	LDI  R30,LOW(1100)
	LDI  R31,HIGH(1100)
	CP   R10,R30
	CPC  R11,R31
	BRGE _0x79
; 0000 024B             {
; 0000 024C             if(f<3) f++;
	LDI  R26,LOW(_f)
	LDI  R27,HIGH(_f)
	CALL __EEPROMRDW
	SBIW R30,3
	BRGE _0x7A
	LDI  R26,LOW(_f)
	LDI  R27,HIGH(_f)
	CALL __EEPROMRDW
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
; 0000 024D             else f=0;
	RJMP _0x7B
_0x7A:
	LDI  R26,LOW(_f)
	LDI  R27,HIGH(_f)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EEPROMWRW
; 0000 024E             }
_0x7B:
; 0000 024F             else {
	RJMP _0x7C
_0x79:
; 0000 0250             sek=0;
	LDI  R30,LOW(0)
	STS  _sek,R30
	STS  _sek+1,R30
; 0000 0251             lcd_clear();
	CALL _lcd_clear
; 0000 0252             //////////Сбрось обороты
; 0000 0253             lcd_puts("\x43\xB2\x70\x6F\x63\xC4  \x6F\xB2\x6F\x70\x6F\xBF\xC3");
	__POINTW1MN _0x2D,185
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 0254             delay_ms(400);
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0255             }
_0x7C:
; 0000 0256 
; 0000 0257             ob_min=0;
_0x78:
	LDI  R30,LOW(0)
	STS  _ob_min,R30
	STS  _ob_min+1,R30
; 0000 0258             sek=0;
	STS  _sek,R30
	STS  _sek+1,R30
; 0000 0259             }
; 0000 025A 
; 0000 025B 
; 0000 025C /////////////////////// индикация по времени
; 0000 025D 
; 0000 025E if (sek>1)
_0x73:
	LDS  R26,_sek
	LDS  R27,_sek+1
	SBIW R26,2
	BRGE PC+3
	JMP _0x7D
; 0000 025F          {
; 0000 0260         sek=0;    // ob_min*30
	LDI  R30,LOW(0)
	STS  _sek,R30
	STS  _sek+1,R30
; 0000 0261         oboroty=ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min+ob_min;
	LDS  R30,_ob_min
	LDS  R31,_ob_min+1
	LSL  R30
	ROL  R31
	LDS  R26,_ob_min
	LDS  R27,_ob_min+1
	ADD  R30,R26
	ADC  R31,R27
	ADD  R30,R26
	ADC  R31,R27
	ADD  R30,R26
	ADC  R31,R27
	ADD  R30,R26
	ADC  R31,R27
	ADD  R30,R26
	ADC  R31,R27
	ADD  R30,R26
	ADC  R31,R27
	ADD  R30,R26
	ADC  R31,R27
	ADD  R30,R26
	ADC  R31,R27
	ADD  R30,R26
	ADC  R31,R27
	ADD  R30,R26
	ADC  R31,R27
	ADD  R30,R26
	ADC  R31,R27
	ADD  R30,R26
	ADC  R31,R27
	ADD  R30,R26
	ADC  R31,R27
	ADD  R30,R26
	ADC  R31,R27
	ADD  R30,R26
	ADC  R31,R27
	ADD  R30,R26
	ADC  R31,R27
	ADD  R30,R26
	ADC  R31,R27
	ADD  R30,R26
	ADC  R31,R27
	ADD  R30,R26
	ADC  R31,R27
	ADD  R30,R26
	ADC  R31,R27
	ADD  R30,R26
	ADC  R31,R27
	ADD  R30,R26
	ADC  R31,R27
	ADD  R30,R26
	ADC  R31,R27
	ADD  R30,R26
	ADC  R31,R27
	ADD  R30,R26
	ADC  R31,R27
	ADD  R30,R26
	ADC  R31,R27
	ADD  R30,R26
	ADC  R31,R27
	ADD  R30,R26
	ADC  R31,R27
	MOVW R10,R30
; 0000 0262         ob_min=0;
	LDI  R30,LOW(0)
	STS  _ob_min,R30
	STS  _ob_min+1,R30
; 0000 0263 
; 0000 0264 
; 0000 0265         temp_buf=ds18b20_temperature(&RomCode[0][0]);//чтение температуры 1 датчика
	LDI  R30,LOW(_RomCode)
	LDI  R31,HIGH(_RomCode)
	ST   -Y,R31
	ST   -Y,R30
	CALL _ds18b20_temperature
	LDI  R26,LOW(_temp_buf)
	LDI  R27,HIGH(_temp_buf)
	CALL __CFD1
	ST   X+,R30
	ST   X,R31
; 0000 0266         if(temp_buf>0) temp1=temp_buf;
	LDS  R26,_temp_buf
	LDS  R27,_temp_buf+1
	CALL __CPW02
	BRGE _0x7E
	LDS  R30,_temp_buf
	LDS  R31,_temp_buf+1
	STS  _temp1,R30
	STS  _temp1+1,R31
; 0000 0267 
; 0000 0268 
; 0000 0269         temp_buf=ds18b20_temperature(&RomCode[1][0]);//чтение температуры 2 датчика
_0x7E:
	__POINTW1MN _RomCode,9
	ST   -Y,R31
	ST   -Y,R30
	CALL _ds18b20_temperature
	LDI  R26,LOW(_temp_buf)
	LDI  R27,HIGH(_temp_buf)
	CALL __CFD1
	ST   X+,R30
	ST   X,R31
; 0000 026A         if(temp_buf>0) temp2=temp_buf;
	LDS  R26,_temp_buf
	LDS  R27,_temp_buf+1
	CALL __CPW02
	BRGE _0x7F
	LDS  R30,_temp_buf
	LDS  R31,_temp_buf+1
	STS  _temp2,R30
	STS  _temp2+1,R31
; 0000 026B 
; 0000 026C 
; 0000 026D         lcd_gotoxy(0,0);
_0x7F:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 026E         if(uoz_i>0) uoz_i--;
	LDS  R26,_uoz_i
	LDS  R27,_uoz_i+1
	CALL __CPW02
	BRGE _0x80
	LDI  R26,LOW(_uoz_i)
	LDI  R27,HIGH(_uoz_i)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 026F //        lcd_puts("O\xB2.  \xA9\xB4.");
; 0000 0270         if(f<4)
_0x80:
	LDI  R26,LOW(_f)
	LDI  R27,HIGH(_f)
	CALL __EEPROMRDW
	SBIW R30,4
	BRLT PC+3
	JMP _0x81
; 0000 0271         {
; 0000 0272 
; 0000 0273         /// показатели
; 0000 0274 
; 0000 0275 //        sprintf(buffer,"%d ",oboroty);  //показывает обороты (тыс в мин)
; 0000 0276 //        lcd_puts(buffer);
; 0000 0277 //        sprintf(buffer,"%d ",ob_y);  //показывает проход шторки в прерываниях
; 0000 0278 //        lcd_puts(buffer);
; 0000 0279 //        sprintf(buffer,"%d ",oper);  //показывает угол опережения в прерываниях
; 0000 027A //        lcd_puts(buffer);
; 0000 027B //        sprintf(buffer,"%d",percent[f][kk]);  //показывает угол опережения в %
; 0000 027C //        lcd_puts(buffer);
; 0000 027D //        lcd_puts("\x25   ");   // symbol %
; 0000 027E 
; 0000 027F         ////////////
; 0000 0280 
; 0000 0281 
; 0000 0282      /////// standard screen
; 0000 0283       sprintf(buffer,"     \xCE\x3D%d",f+1);  //первая строка (кк - показывает отрезок к которому относится прерывание)
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,277
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_f)
	LDI  R27,HIGH(_f)
	CALL __EEPROMRDW
	ADIW R30,1
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 0284       lcd_puts(buffer);
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 0285       sprintf(buffer," %d",kk);  //первая строка (кк - показывает отрезок к которому относится прерывание)
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,24
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_kk
	LDS  R31,_kk+1
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 0286       lcd_puts(buffer);
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 0287       lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0288       sprintf(buffer,"%d      ",oboroty);  //показывает обороты (тыс в мин)
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,152
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R10
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 0289       lcd_puts(buffer);
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 028A       lcd_gotoxy(5,1);
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 028B       sprintf(buffer,"%d",percent[f][kk]);  //показывает угол опережения в %
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,6
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_f)
	LDI  R27,HIGH(_f)
	CALL __EEPROMRDW
	CALL __LSLW4
	SUBI R30,LOW(-_percent)
	SBCI R31,HIGH(-_percent)
	MOVW R26,R30
	LDS  R30,_kk
	LDS  R31,_kk+1
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 028C       lcd_puts(buffer);
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 028D       lcd_puts("\x25  ");   // symbol %
	__POINTW1MN _0x2D,201
	RJMP _0x88
; 0000 028E       ///////////////////////
; 0000 028F 
; 0000 0290 
; 0000 0291 
; 0000 0292       //  sprintf(buffer,"%d ",ob_y);  //показывает проход шторки в прерываниях
; 0000 0293       //sprintf(buffer,"%d      ",ob_min*30);  //показывает обороты (тыс в мин)
; 0000 0294       //sprintf(buffer,"%d      ",ob_y);  //показывает проход шторки в прерываниях
; 0000 0295       // sprintf(buffer,"%d\x27",60*OC/ob_y);  //  показывает угол опережения  (в градусах)
; 0000 0296       // sprintf(buffer,"%d      ",OC);  //показывает угол опережения в прерываниях
; 0000 0297       // sprintf(buffer,"%d",45*percent[kk][f]/100);  //показывает угол опережения в градусах
; 0000 0298 
; 0000 0299       // lcd_puts("\x27");   // symbol '
; 0000 029A       // lcd_puts("\xDF");   // symbol `
; 0000 029B            }
; 0000 029C         else {   //отключен ФУОЗ, обороты считаются по факту
_0x81:
; 0000 029D          lcd_clear();
	CALL _lcd_clear
; 0000 029E          sprintf(buffer,"    \xB3\xC3\xBA\xBB%d",oboroty);  //показывает обороты (тыс в мин
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,291
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R10
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 029F          lcd_puts(buffer);
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
_0x88:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 02A0               }
; 0000 02A1 
; 0000 02A2          }
; 0000 02A3 
; 0000 02A4       };
_0x7D:
	RJMP _0x3F
; 0000 02A5 
; 0000 02A6     }
_0x83:
	RJMP _0x83

	.DSEG
_0x2D:
	.BYTE 0xCD
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G100:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2000014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2000014:
_0x2000013:
	RJMP _0x2000015
_0x2000010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20E0006
__ftoe_G100:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	CALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x2000019
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x2000000,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _strcpyf
	RJMP _0x20E0009
_0x2000019:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x2000018
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x2000000,1
	ST   -Y,R31
	ST   -Y,R30
	CALL _strcpyf
	RJMP _0x20E0009
_0x2000018:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x200001B
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x200001B:
	LDD  R17,Y+11
_0x200001C:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x200001E
	__GETD2S 4
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 4
	RJMP _0x200001C
_0x200001E:
	__GETD1S 12
	CALL __CPD10
	BRNE _0x200001F
	LDI  R19,LOW(0)
	__GETD2S 4
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 4
	RJMP _0x2000020
_0x200001F:
	LDD  R19,Y+11
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2000021
	__GETD2S 4
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 4
_0x2000022:
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	BRLO _0x2000024
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RJMP _0x2000022
_0x2000024:
	RJMP _0x2000025
_0x2000021:
_0x2000026:
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	BRSH _0x2000028
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,LOW(1)
	RJMP _0x2000026
_0x2000028:
	__GETD2S 4
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 4
_0x2000025:
	__GETD1S 12
	__GETD2N 0x3F000000
	CALL __ADDF12
	__PUTD1S 12
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	BRLO _0x2000029
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
_0x2000029:
_0x2000020:
	LDI  R17,LOW(0)
_0x200002A:
	LDD  R30,Y+11
	CP   R30,R17
	BRSH PC+3
	JMP _0x200002C
	__GETD2S 4
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__GETD2N 0x3F000000
	CALL __ADDF12
	CALL __PUTPARD1
	CALL _floor
	__PUTD1S 4
	__GETD2S 12
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2S 4
	CALL __MULF12
	__GETD2S 12
	CALL __SWAPD12
	CALL __SUBF12
	__PUTD1S 12
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BREQ _0x200002D
	RJMP _0x200002A
_0x200002D:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x200002A
_0x200002C:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x200002E
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x200010E
_0x200002E:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x200010E:
	ST   X,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20E0009:
	CALL __LOADLOCR4
	ADIW R28,16
	RET
__print_G100:
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000030:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2000032
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2000036
	CPI  R18,37
	BRNE _0x2000037
	LDI  R17,LOW(1)
	RJMP _0x2000038
_0x2000037:
	ST   -Y,R18
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
_0x2000038:
	RJMP _0x2000035
_0x2000036:
	CPI  R30,LOW(0x1)
	BRNE _0x2000039
	CPI  R18,37
	BRNE _0x200003A
	ST   -Y,R18
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	RJMP _0x200010F
_0x200003A:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x200003B
	LDI  R16,LOW(1)
	RJMP _0x2000035
_0x200003B:
	CPI  R18,43
	BRNE _0x200003C
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x2000035
_0x200003C:
	CPI  R18,32
	BRNE _0x200003D
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x2000035
_0x200003D:
	RJMP _0x200003E
_0x2000039:
	CPI  R30,LOW(0x2)
	BRNE _0x200003F
_0x200003E:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000040
	ORI  R16,LOW(128)
	RJMP _0x2000035
_0x2000040:
	RJMP _0x2000041
_0x200003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2000042
_0x2000041:
	CPI  R18,48
	BRLO _0x2000044
	CPI  R18,58
	BRLO _0x2000045
_0x2000044:
	RJMP _0x2000043
_0x2000045:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2000035
_0x2000043:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x2000046
	LDI  R17,LOW(4)
	RJMP _0x2000035
_0x2000046:
	RJMP _0x2000047
_0x2000042:
	CPI  R30,LOW(0x4)
	BRNE _0x2000049
	CPI  R18,48
	BRLO _0x200004B
	CPI  R18,58
	BRLO _0x200004C
_0x200004B:
	RJMP _0x200004A
_0x200004C:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x2000035
_0x200004A:
_0x2000047:
	CPI  R18,108
	BRNE _0x200004D
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x2000035
_0x200004D:
	RJMP _0x200004E
_0x2000049:
	CPI  R30,LOW(0x5)
	BREQ PC+3
	JMP _0x2000035
_0x200004E:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2000053
	__GETW1SX 90
	SBIW R30,4
	__PUTW1SX 90
	LDD  R26,Z+4
	ST   -Y,R26
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	RJMP _0x2000054
_0x2000053:
	CPI  R30,LOW(0x45)
	BREQ _0x2000057
	CPI  R30,LOW(0x65)
	BRNE _0x2000058
_0x2000057:
	RJMP _0x2000059
_0x2000058:
	CPI  R30,LOW(0x66)
	BREQ PC+3
	JMP _0x200005A
_0x2000059:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	__GETW2SX 90
	CALL __GETD1P
	__PUTD1S 10
	__GETW1SX 90
	SBIW R30,4
	__PUTW1SX 90
	LDD  R26,Y+13
	TST  R26
	BRMI _0x200005B
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x200005D
	RJMP _0x200005E
_0x200005B:
	__GETD1S 10
	CALL __ANEGF1
	__PUTD1S 10
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x200005D:
	SBRS R16,7
	RJMP _0x200005F
	LDD  R30,Y+21
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	RJMP _0x2000060
_0x200005F:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2000060:
_0x200005E:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x2000062
	__GETD1S 10
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R30,Y+19
	LDD  R31,Y+19+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _ftoa
	RJMP _0x2000063
_0x2000062:
	__GETD1S 10
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL __ftoe_G100
_0x2000063:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000064
_0x200005A:
	CPI  R30,LOW(0x73)
	BRNE _0x2000066
	__GETW1SX 90
	SBIW R30,4
	__PUTW1SX 90
	__GETW2SX 90
	ADIW R26,4
	CALL __GETW1P
	STD  Y+14,R30
	STD  Y+14+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000067
_0x2000066:
	CPI  R30,LOW(0x70)
	BRNE _0x2000069
	__GETW1SX 90
	SBIW R30,4
	__PUTW1SX 90
	__GETW2SX 90
	ADIW R26,4
	CALL __GETW1P
	STD  Y+14,R30
	STD  Y+14+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000067:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x200006B
	CP   R20,R17
	BRLO _0x200006C
_0x200006B:
	RJMP _0x200006A
_0x200006C:
	MOV  R17,R20
_0x200006A:
_0x2000064:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x200006D
_0x2000069:
	CPI  R30,LOW(0x64)
	BREQ _0x2000070
	CPI  R30,LOW(0x69)
	BRNE _0x2000071
_0x2000070:
	ORI  R16,LOW(4)
	RJMP _0x2000072
_0x2000071:
	CPI  R30,LOW(0x75)
	BRNE _0x2000073
_0x2000072:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2000074
	__GETD1N 0x3B9ACA00
	__PUTD1S 16
	LDI  R17,LOW(10)
	RJMP _0x2000075
_0x2000074:
	__GETD1N 0x2710
	__PUTD1S 16
	LDI  R17,LOW(5)
	RJMP _0x2000075
_0x2000073:
	CPI  R30,LOW(0x58)
	BRNE _0x2000077
	ORI  R16,LOW(8)
	RJMP _0x2000078
_0x2000077:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x20000B6
_0x2000078:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x200007A
	__GETD1N 0x10000000
	__PUTD1S 16
	LDI  R17,LOW(8)
	RJMP _0x2000075
_0x200007A:
	__GETD1N 0x1000
	__PUTD1S 16
	LDI  R17,LOW(4)
_0x2000075:
	CPI  R20,0
	BREQ _0x200007B
	ANDI R16,LOW(127)
	RJMP _0x200007C
_0x200007B:
	LDI  R20,LOW(1)
_0x200007C:
	SBRS R16,1
	RJMP _0x200007D
	__GETW1SX 90
	SBIW R30,4
	__PUTW1SX 90
	__GETW2SX 90
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x2000110
_0x200007D:
	SBRS R16,2
	RJMP _0x200007F
	__GETW1SX 90
	SBIW R30,4
	__PUTW1SX 90
	__GETW2SX 90
	ADIW R26,4
	CALL __GETW1P
	CALL __CWD1
	RJMP _0x2000110
_0x200007F:
	__GETW1SX 90
	SBIW R30,4
	__PUTW1SX 90
	__GETW2SX 90
	ADIW R26,4
	CALL __GETW1P
	CLR  R22
	CLR  R23
_0x2000110:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2000081
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2000082
	__GETD1S 10
	CALL __ANEGD1
	__PUTD1S 10
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2000082:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x2000083
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x2000084
_0x2000083:
	ANDI R16,LOW(251)
_0x2000084:
_0x2000081:
	MOV  R19,R20
_0x200006D:
	SBRC R16,0
	RJMP _0x2000085
_0x2000086:
	CP   R17,R21
	BRSH _0x2000089
	CP   R19,R21
	BRLO _0x200008A
_0x2000089:
	RJMP _0x2000088
_0x200008A:
	SBRS R16,7
	RJMP _0x200008B
	SBRS R16,2
	RJMP _0x200008C
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x200008D
_0x200008C:
	LDI  R18,LOW(48)
_0x200008D:
	RJMP _0x200008E
_0x200008B:
	LDI  R18,LOW(32)
_0x200008E:
	ST   -Y,R18
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	SUBI R21,LOW(1)
	RJMP _0x2000086
_0x2000088:
_0x2000085:
_0x200008F:
	CP   R17,R20
	BRSH _0x2000091
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2000092
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW1SX 87
	ST   -Y,R31
	ST   -Y,R30
	__GETW1SX 91
	ICALL
	CPI  R21,0
	BREQ _0x2000093
	SUBI R21,LOW(1)
_0x2000093:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2000092:
	LDI  R30,LOW(48)
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	CPI  R21,0
	BREQ _0x2000094
	SUBI R21,LOW(1)
_0x2000094:
	SUBI R20,LOW(1)
	RJMP _0x200008F
_0x2000091:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2000095
_0x2000096:
	CPI  R19,0
	BREQ _0x2000098
	SBRS R16,3
	RJMP _0x2000099
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x200009A
_0x2000099:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x200009A:
	ST   -Y,R18
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	CPI  R21,0
	BREQ _0x200009B
	SUBI R21,LOW(1)
_0x200009B:
	SUBI R19,LOW(1)
	RJMP _0x2000096
_0x2000098:
	RJMP _0x200009C
_0x2000095:
_0x200009E:
	__GETD1S 16
	__GETD2S 10
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20000A0
	SBRS R16,3
	RJMP _0x20000A1
	SUBI R18,-LOW(55)
	RJMP _0x20000A2
_0x20000A1:
	SUBI R18,-LOW(87)
_0x20000A2:
	RJMP _0x20000A3
_0x20000A0:
	SUBI R18,-LOW(48)
_0x20000A3:
	SBRC R16,4
	RJMP _0x20000A5
	CPI  R18,49
	BRSH _0x20000A7
	__GETD2S 16
	__CPD2N 0x1
	BRNE _0x20000A6
_0x20000A7:
	RJMP _0x20000A9
_0x20000A6:
	CP   R20,R19
	BRSH _0x2000111
	CP   R21,R19
	BRLO _0x20000AC
	SBRS R16,0
	RJMP _0x20000AD
_0x20000AC:
	RJMP _0x20000AB
_0x20000AD:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20000AE
_0x2000111:
	LDI  R18,LOW(48)
_0x20000A9:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20000AF
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW1SX 87
	ST   -Y,R31
	ST   -Y,R30
	__GETW1SX 91
	ICALL
	CPI  R21,0
	BREQ _0x20000B0
	SUBI R21,LOW(1)
_0x20000B0:
_0x20000AF:
_0x20000AE:
_0x20000A5:
	ST   -Y,R18
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	CPI  R21,0
	BREQ _0x20000B1
	SUBI R21,LOW(1)
_0x20000B1:
_0x20000AB:
	SUBI R19,LOW(1)
	__GETD1S 16
	__GETD2S 10
	CALL __MODD21U
	__PUTD1S 10
	LDD  R30,Y+20
	__GETD2S 16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	__PUTD1S 16
	CALL __CPD10
	BREQ _0x200009F
	RJMP _0x200009E
_0x200009F:
_0x200009C:
	SBRS R16,0
	RJMP _0x20000B2
_0x20000B3:
	CPI  R21,0
	BREQ _0x20000B5
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	RJMP _0x20000B3
_0x20000B5:
_0x20000B2:
_0x20000B6:
_0x2000054:
_0x200010F:
	LDI  R17,LOW(0)
_0x2000035:
	RJMP _0x2000030
_0x2000032:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	SBIW R30,0
	BRNE _0x20000B7
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20E0008
_0x20000B7:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20E0008:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET

	.CSEG
_ds18b20_select:
	ST   -Y,R17
	CALL _w1_init
	CPI  R30,0
	BRNE _0x2020003
	LDI  R30,LOW(0)
	RJMP _0x20E0005
_0x2020003:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SBIW R30,0
	BREQ _0x2020004
	LDI  R30,LOW(85)
	ST   -Y,R30
	CALL _w1_write
	LDI  R17,LOW(0)
_0x2020006:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	ST   -Y,R30
	CALL _w1_write
	SUBI R17,-LOW(1)
	CPI  R17,8
	BRLO _0x2020006
	RJMP _0x2020008
_0x2020004:
	LDI  R30,LOW(204)
	ST   -Y,R30
	CALL _w1_write
_0x2020008:
	LDI  R30,LOW(1)
	RJMP _0x20E0005
_ds18b20_read_spd:
	CALL __SAVELOCR4
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ds18b20_select
	CPI  R30,0
	BRNE _0x2020009
	LDI  R30,LOW(0)
	RJMP _0x20E0007
_0x2020009:
	LDI  R30,LOW(190)
	ST   -Y,R30
	CALL _w1_write
	LDI  R17,LOW(0)
	__POINTWRM 18,19,___ds18b20_scratch_pad
_0x202000B:
	PUSH R19
	PUSH R18
	__ADDWRN 18,19,1
	CALL _w1_read
	POP  R26
	POP  R27
	ST   X,R30
	SUBI R17,-LOW(1)
	CPI  R17,9
	BRLO _0x202000B
	LDI  R30,LOW(___ds18b20_scratch_pad)
	LDI  R31,HIGH(___ds18b20_scratch_pad)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(9)
	ST   -Y,R30
	CALL _w1_dow_crc8
	CALL __LNEGB1
_0x20E0007:
	CALL __LOADLOCR4
	ADIW R28,6
	RET
_ds18b20_temperature:
	ST   -Y,R17
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ds18b20_read_spd
	CPI  R30,0
	BRNE _0x202000D
	__GETD1N 0xC61C3C00
	RJMP _0x20E0005
_0x202000D:
	__GETB1MN ___ds18b20_scratch_pad,4
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	ANDI R30,LOW(0x3)
	MOV  R17,R30
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ds18b20_select
	CPI  R30,0
	BRNE _0x202000E
	__GETD1N 0xC61C3C00
	RJMP _0x20E0005
_0x202000E:
	LDI  R30,LOW(68)
	ST   -Y,R30
	CALL _w1_write
	MOV  R30,R17
	LDI  R26,LOW(_conv_delay_G101*2)
	LDI  R27,HIGH(_conv_delay_G101*2)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	CALL __GETW1PF
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ds18b20_read_spd
	CPI  R30,0
	BRNE _0x202000F
	__GETD1N 0xC61C3C00
	RJMP _0x20E0005
_0x202000F:
	CALL _w1_init
	MOV  R30,R17
	LDI  R26,LOW(_bit_mask_G101*2)
	LDI  R27,HIGH(_bit_mask_G101*2)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	CALL __GETW1PF
	LDS  R26,___ds18b20_scratch_pad
	LDS  R27,___ds18b20_scratch_pad+1
	AND  R30,R26
	AND  R31,R27
	CALL __CWD1
	CALL __CDF1
	__GETD2N 0x3D800000
	CALL __MULF12
	RJMP _0x20E0005
_ds18b20_init:
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ds18b20_select
	CPI  R30,0
	BRNE _0x2020010
	LDI  R30,LOW(0)
	RJMP _0x20E0006
_0x2020010:
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	ORI  R30,LOW(0x1F)
	ST   Y,R30
	LDI  R30,LOW(78)
	ST   -Y,R30
	CALL _w1_write
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _w1_write
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _w1_write
	LD   R30,Y
	ST   -Y,R30
	CALL _w1_write
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ds18b20_read_spd
	CPI  R30,0
	BRNE _0x2020011
	LDI  R30,LOW(0)
	RJMP _0x20E0006
_0x2020011:
	__GETB2MN ___ds18b20_scratch_pad,3
	LDD  R30,Y+2
	CP   R30,R26
	BRNE _0x2020013
	__GETB2MN ___ds18b20_scratch_pad,2
	LDD  R30,Y+1
	CP   R30,R26
	BRNE _0x2020013
	__GETB2MN ___ds18b20_scratch_pad,4
	LD   R30,Y
	CP   R30,R26
	BREQ _0x2020012
_0x2020013:
	LDI  R30,LOW(0)
	RJMP _0x20E0006
_0x2020012:
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ds18b20_select
	CPI  R30,0
	BRNE _0x2020015
	LDI  R30,LOW(0)
	RJMP _0x20E0006
_0x2020015:
	LDI  R30,LOW(72)
	ST   -Y,R30
	CALL _w1_write
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	CALL _w1_init
_0x20E0006:
	ADIW R28,5
	RET
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G102:
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2040004
	SBI  0x18,3
	RJMP _0x2040005
_0x2040004:
	CBI  0x18,3
_0x2040005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2040006
	SBI  0x18,4
	RJMP _0x2040007
_0x2040006:
	CBI  0x18,4
_0x2040007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2040008
	SBI  0x18,5
	RJMP _0x2040009
_0x2040008:
	CBI  0x18,5
_0x2040009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x204000A
	SBI  0x18,6
	RJMP _0x204000B
_0x204000A:
	CBI  0x18,6
_0x204000B:
	__DELAY_USB 11
	SBI  0x18,2
	__DELAY_USB 27
	CBI  0x18,2
	__DELAY_USB 27
	RJMP _0x20E0004
__lcd_write_data:
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G102
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G102
	__DELAY_USW 200
	RJMP _0x20E0004
_lcd_gotoxy:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G102)
	SBCI R31,HIGH(-__base_y_G102)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	RCALL __lcd_write_data
	LDD  R4,Y+1
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	MOV  R4,R30
	RET
_lcd_putchar:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2040011
	LDS  R30,__lcd_maxx
	CP   R4,R30
	BRLO _0x2040010
_0x2040011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	ST   -Y,R30
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2040013
	RJMP _0x20E0004
_0x2040013:
_0x2040010:
	INC  R4
	SBI  0x18,0
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_data
	CBI  0x18,0
	RJMP _0x20E0004
_lcd_puts:
	ST   -Y,R17
_0x2040014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2040016
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2040014
_0x2040016:
	RJMP _0x20E0005
_lcd_putsf:
	ST   -Y,R17
_0x2040017:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2040019
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2040017
_0x2040019:
_0x20E0005:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_init:
	SBI  0x17,3
	SBI  0x17,4
	SBI  0x17,5
	SBI  0x17,6
	SBI  0x17,2
	SBI  0x17,0
	SBI  0x17,1
	CBI  0x18,2
	CBI  0x18,0
	CBI  0x18,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G102,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G102,3
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDI  R30,LOW(48)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G102
	__DELAY_USW 400
	LDI  R30,LOW(48)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G102
	__DELAY_USW 400
	LDI  R30,LOW(48)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G102
	__DELAY_USW 400
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G102
	__DELAY_USW 400
	LDI  R30,LOW(40)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(133)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20E0004:
	ADIW R28,1
	RET

	.CSEG

	.CSEG
_strcpyf:
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
_strlen:
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

	.CSEG
_ftrunc:
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
_floor:
	CALL __GETD1S0
	CALL __PUTPARD1
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL __GETD1S0
	RJMP _0x20E0003
__floor1:
    brtc __floor0
	CALL __GETD1S0
	__GETD2N 0x3F800000
	CALL __SUBF12
_0x20E0003:
	ADIW R28,4
	RET

	.CSEG
_ftoa:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x20C000D
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x20C0000,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _strcpyf
	RJMP _0x20E0002
_0x20C000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x20C000C
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x20C0000,1
	ST   -Y,R31
	ST   -Y,R30
	CALL _strcpyf
	RJMP _0x20E0002
_0x20C000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x20C000F
	__GETD1S 9
	CALL __ANEGF1
	__PUTD1S 9
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	LDI  R30,LOW(45)
	ST   X,R30
_0x20C000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x20C0010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x20C0010:
	LDD  R17,Y+8
_0x20C0011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20C0013
	__GETD2S 2
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 2
	RJMP _0x20C0011
_0x20C0013:
	__GETD1S 2
	__GETD2S 9
	CALL __ADDF12
	__PUTD1S 9
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	__PUTD1S 2
_0x20C0014:
	__GETD1S 2
	__GETD2S 9
	CALL __CMPF12
	BRLO _0x20C0016
	__GETD2S 2
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 2
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x20C0017
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x20C0000,5
	ST   -Y,R31
	ST   -Y,R30
	CALL _strcpyf
	RJMP _0x20E0002
_0x20C0017:
	RJMP _0x20C0014
_0x20C0016:
	CPI  R17,0
	BRNE _0x20C0018
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x20C0019
_0x20C0018:
_0x20C001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BRNE PC+3
	JMP _0x20C001C
	__GETD2S 2
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__GETD2N 0x3F000000
	CALL __ADDF12
	CALL __PUTPARD1
	CALL _floor
	__PUTD1S 2
	__GETD2S 9
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	__GETD2S 2
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL __MULF12
	__GETD2S 9
	CALL __SWAPD12
	CALL __SUBF12
	__PUTD1S 9
	RJMP _0x20C001A
_0x20C001C:
_0x20C0019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20E0001
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	LDI  R30,LOW(46)
	ST   X,R30
_0x20C001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x20C0020
	__GETD2S 9
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 9
	CALL __CFD1U
	MOV  R16,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	__GETD2S 9
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL __SWAPD12
	CALL __SUBF12
	__PUTD1S 9
	RJMP _0x20C001E
_0x20C0020:
_0x20E0001:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20E0002:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET

	.DSEG

	.CSEG

	.DSEG
___ds18b20_scratch_pad:
	.BYTE 0x9
_RomCode:
	.BYTE 0x12
_buffer:
	.BYTE 0x10
_uoz_i:
	.BYTE 0x2
_zn1:
	.BYTE 0x2
_zn2:
	.BYTE 0x2
_sek:
	.BYTE 0x2
_ob_min:
	.BYTE 0x2
_temp1:
	.BYTE 0x2
_temp2:
	.BYTE 0x2
_temp_buf:
	.BYTE 0x2
_i:
	.BYTE 0x2
_kk:
	.BYTE 0x2
_temp_ugly:
	.BYTE 0x1E

	.ESEG
_temp_f:
	.BYTE 0x2
_f:
	.BYTE 0x2
_percent:
	.BYTE 0x40
_prer_ugly:
	.BYTE 0x10

	.DSEG
__base_y_G102:
	.BYTE 0x4
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
__seed_G106:
	.BYTE 0x4

	.CSEG

	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

	.equ __w1_port=0x1B
	.equ __w1_bit=0x05

_w1_init:
	clr  r30
	cbi  __w1_port,__w1_bit
	sbi  __w1_port-1,__w1_bit
	__DELAY_USW 0x780
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x4B
	sbis __w1_port-2,__w1_bit
	ret
	__DELAY_USW 0x130
	sbis __w1_port-2,__w1_bit
	ldi  r30,1
	__DELAY_USW 0x618
	ret

__w1_read_bit:
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0xB
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x3B
	clc
	sbic __w1_port-2,__w1_bit
	sec
	ror  r30
	__DELAY_USW 0x140
	ret

__w1_write_bit:
	clt
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0xB
	sbrc r23,0
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x45
	sbic __w1_port-2,__w1_bit
	rjmp __w1_write_bit0
	sbrs r23,0
	rjmp __w1_write_bit1
	ret
__w1_write_bit0:
	sbrs r23,0
	ret
__w1_write_bit1:
	__DELAY_USW 0x12C
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x1B
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
	ldi  r22,8
	ld   r23,y+
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
	ld   r26,y
	ldd  r27,y+1
__w1_search0:
	mov  r0,r1
	clr  r1
	rcall _w1_init
	tst  r30
	breq __w1_search7
	ldd  r30,y+2
	st   -y,r30
	rcall _w1_write
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
	adiw r28,3
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
	ld   r24,y
	tst  r24
	breq __w1_dow_crc83
	ldi  r22,0x18
	ldd  r26,y+1
	ldd  r27,y+2
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
	adiw r28,3
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

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

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

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

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

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

__LSLW4:
	LSL  R30
	ROL  R31
__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
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

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
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

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
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

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
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

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
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

;END OF CODE MARKER
__END_OF_CODE:
