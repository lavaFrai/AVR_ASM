/*
 * Assembler.asm
 *
 *  Created: 14.06.2021 12:06:11
 *   Author: lava_frai
 */ 


 ; = Start             macro.inc ===========================================================================


 
 ; = End             macro.inc =============================================================================


 ; RAM =====================================================================================================
 .DSEG                                                                                      ;    ??????? ???



 ; FLASH ===================================================================================================
 .CSEG                                                                                      ;   ??????? ????
	.ORG $000        ; (RESET) 
		JMP   Reset
	.ORG $002
		RETI             ; (INT0) External Interrupt Request 0
	.ORG $004
		RETI             ; (INT1) External Interrupt Request 1
	.ORG $006
		RETI		    ; (TIMER2 COMP) Timer/Counter2 Compare Match
	.ORG $008
		RETI             ; (TIMER2 OVF) Timer/Counter2 Overflow
	.ORG $00A
		RETI		    ; (TIMER1 CAPT) Timer/Counter1 Capture Event
	.ORG $00C
		RETI             ; (TIMER1 COMPA) Timer/Counter1 Compare Match A
	.ORG $00E
		RETI             ; (TIMER1 COMPB) Timer/Counter1 Compare Match B
	.ORG $010
		RETI             ; (TIMER1 OVF) Timer/Counter1 Overflow
	.ORG $012
		RETI             ; (TIMER0 OVF) Timer/Counter0 Overflow
	.ORG $014
		RETI             ; (SPI,STC) Serial Transfer Complete
	.ORG $016
		RETI		     ; (USART,RXC) USART, Rx Complete
	.ORG $018
		RETI             ; (USART,UDRE) USART Data Register Empty
	.ORG $01A
		RETI             ; (USART,TXC) USART, Tx Complete
	.ORG $01C
		RETI		    ; (ADC) ADC Conversion Complete
	.ORG $01E
		RETI             ; (EE_RDY) EEPROM Ready
	.ORG $020
		RETI             ; (ANA_COMP) Analog Comparator
	.ORG $022
		RETI             ; (TWI) 2-wire Serial Interface
	.ORG $024
		RETI             ; (INT2) External Interrupt Request 2
	.ORG $026
		RETI             ; (TIMER0 COMP) Timer/Counter0 Compare Match
	.ORG $028
		RETI             ; (SPM_RDY) Store Program Memory Ready
	.ORG   INT_VECTORS_SIZE      	; ????? ??????? ??????????


	Reset:
		LDI R16,Low(RAMEND)	; ????????????? ?????
		OUT SPL,R16
		LDI R16,High(RAMEND)
		OUT SPH,R16

		SEI ; ????????? ??????????

		JMP Setup

	Setup:
		
		LDI R16,0b11111111
		LDI R17,0b00000000
		OUT DDRB,R17
		SBI DDRB,5
		CBI DDRB,4
		SBI PORTB,4

		JMP Loop

	Loop:
		
		; SBI PORTB,5
		; CALL SLEEP_1s
		
		; CBI PORTB,5
		; CALL SLEEP_1s

		SBIS PINB,4
			SBI PORTB,5
		SBIC PINB,4
			CBI PORTB,5

		JMP Loop

	SLEEP_1s:
		    ldi  r18, 41
			ldi  r19, 150
			ldi  r20, 128
		L1: dec  r20
			brne L1
			dec  r19
			brne L1
			dec  r18
			brne L1
			RET
