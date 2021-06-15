/*
 * Assembler.asm
 *
 *  Created: 14.06.2021 12:06:11
 *   Author: Alexey
 */ 


 ; = Start             macro.inc ===========================================================================

	.macro UOUT        
   		.if	@0 < 0x40
      		OUT	@0,@1
		.else
      		STS	@0,@1
   		.endif
   		.endm

	.equ LED = 1
	.equ BUTTON = 3
	.equ MAXMODE = 2
 
 ; = End             macro.inc =============================================================================


 ; RAM =====================================================================================================
 .DSEG                                                                                      ;    Сегмент ОЗУ



 ; FLASH ===================================================================================================
 .CSEG                                                                                      ;   Сегмент кода
	.ORG $000		; (RESET) 
		RJMP Reset
	.ORG $002		; External Interrupt Request 0
		RETI
	.ORG $004		; Pin Change Interrupt Request 0
		RETI
	.ORG $006		; Timer/Counter Overflow
		RETI
	.ORG $008		; EEPROM Ready
		RETI
	.ORG $010		; Analog Comparator
		RETI
	.ORG $012		; Timer/Counter Compare Match A
		RETI
	.ORG $014		; Timer/Counter Compare Match B
		RETI
	.ORG $016		; Watchdog Time-out
		RETI
	.ORG $018		; ADC Conversion Complete
		RETI

	Reset:
		LDI R16,Low(RAMEND)	; Инициализация стека
		OUT SPL,R16
		; LDI R16,High(RAMEND)
		; OUT SPH,R16
		LDI r16,0
		SEI ; Разрешаем прерывания

		RJMP Setup

	Setup:
		
		CBI DDRB,BUTTON
		SBI DDRB,LED
		SBI PORTB,BUTTON
		; SBI DDRB,4

		LDI r17,1

		RJMP Loop


	Loop:
		
		/*
		SBI PORTB,LED
		CALL SLEEP_1s
		CBI PORTB,LED
		CALL SLEEP_1s
		*/

		SBIS PINB,BUTTON
			RCALL ON_PRESSED
		SBIC PINB,BUTTON
			CLT


		CPI r17,0
		BRNE L2
			RCALL OFF
		L2:

		CPI r17,1
		BRNE L3
			RCALL ON
		L3:


		RJMP Loop



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


	ON_PRESSED:

		BRTS L4
			INC r17
		L4:

		SET

		CPI r17,MAXMODE
		BRNE L5
			LDI r17,0
		L5:

		RET

	OFF:
		CBI PORTB,LED
		RET

	ON:
		SBI PORTB,LED
		RET