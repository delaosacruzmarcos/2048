	.data
	.global notIntError

notIntError: .string "Error, string Not an integer",0

	.text
 	.global uart_init
 	.global uart_interrupt_init
 	.global GPIO_init
 	.global gpio_interrupt_init
 	.global timer_interrupt_init
 	.global modulus
	.global output_character
	.global output_string
 	.global read_character
 	.global simple_read_character
 	.global read_string
 	.global read_from_push_btns
 	.global read_tiva_push_button
	.global read_keypad
 	.global illuminate_RGB_LED
 	.global illuminate_LEDs
 	.global int2string
	.global string2int
	.global merge


ptr_to_notInt: .word notIntError





; GPIO_INIT offset values
DIR:	.equ 0x400
DEN: 	.equ 0x51C
DATA: 	.equ 0x3FC
PUR:	.equ 0x510

;RGB LED colors
RED: 	.equ 0x2
BLUE:	.equ 0x4
PURPLE: .equ 0x6
GREEN:	.equ 0x8
YELLOW: .equ 0xA
CYAN:	.equ 0xC
WHITE: 	.equ 0xE

; UART_INIT offset values
E_UART_CLK:			.equ 0xE608
P_UART_CLK:			.equ 0xE618
UART_CTRL:			.equ 0xC030
UART_IBRD:			.equ 0xC024
UART_FBRD:			.equ 0xC028
SYS_CLK:			.equ 0xCFC8
BWL_SB_NP: 			.equ 0xC02C
DIG_PORTS:			.equ 0x451C
ALT_FUNCT:			.equ 0x4420
UART_PORT_CONFIG:	.equ 0x452C

U0FR: 				.equ 0x18 ; UART0 Flag Register
TxFF: 				.equ 0x20
RxFE: 				.equ 0x10

; GPIO INTERRUPT CONFIG
GPIOF:		.equ 0x40000000
GPIOD:		.equ 0x8
GPIOIS: 	.equ 0x404
GPIOIBE: 	.equ 0x408
GPIOEV: 	.equ 0x40C
GPIOIM: 	.equ 0x410

; UART INTERRUPT CONFIG
UARTIM:		.equ 0x038
UART0:		.equ 0x20

; TIMER INTERRUPT CONFIG
GPTMCFG:	.equ 0x000
GPTMTAMR:	.equ 0x004
RCGCTIMER:	.equ 0x604
GPTMTAILR:	.equ 0x028
GPTMCTL:	.equ 0x00C
GPTMIMR:	.equ 0x018

; Interrupt 0-31 Set Enable Register
EN0: 		.equ 0x100

; Receive Interrupt Mask in UART Interrupt Mask Register
RXIM:		.equ 0x10



;--------------------------;
; initialize the user UART for use

uart_init:
	PUSH {r1-r3, lr}	; preserve regs on stack

	MOV R2, #0x0		; clear R2 just to be sure
	MOVT R2, #0x400F	; base address

	; Provide clock to UART0
	; 0x400FE618 = 1
	MOV R3, #P_UART_CLK

	LDR R1, [R2, R3]
	ORR R1, R1, #0x1
	STR R1, [R2, R3]

	; Enable clock to UART0
	; 0x400FE608 = 1
	MOV R3, #E_UART_CLK
	LDR R1, [R2, R3]
	ORR R1, R1, #0x1
	STR R1, [R2, R3]

	MOV R2, #0x0
	MOVT R2, #0x4000	; base address


	; Disable UART0 Control
	; 0x4000C030 = 0
	MOV R1, #0
	MOV R3, #UART_CTRL
	STR R1, [R2, R3]


	; Set UART0_IBRD_R for 115,200 baud
	; 0x4000C024 = 8
	MOV R1, #8
	MOV R3, #UART_IBRD
	STR R1, [R2, R3]


	; Set UART0_FBRD_R for 115,200 baud
	; 0x4000C028 = 44
	MOV R1, #44
	MOV R3, #UART_FBRD
	STR R1, [R2, R3]


	; Use System Clock
	; 0x4000CFC8 = 0
	MOV R1, #0
	MOV R3, #SYS_CLK
	STR R1, [R2, R3]


	; Use 8-bit word length, 1 stop bit, no parity
	; 0x4000C02C = 0x60
	MOV R1, #0x60
	MOV R3, #BWL_SB_NP
	STR R1, [R2, R3]


	; Enable UART0 Control
	; 0x4000C030 = 0x301
	MOV R1, #0x301
	MOV R3, #UART_CTRL
	STR R1, [R2, R3]


	; Make PA0 and PA1 as Digital Ports
	; 0x4000451C |= 0x03
	MOV R3, #DIG_PORTS

	LDR R1, [R2, R3]
	ORR R1, R1, #0x03
	STR R1, [R2, R3]

	; Change PA0,PA1 to Use an Alternate Function
	; 0x40004420 |= 0x03
	MOV R3, #ALT_FUNCT

	LDR R1, [R2, R3]
	ORR R1, R1, #0x03
	STR R1, [R2, R3]


	; Configure PA0 and PA1 for UART
	; 0x4000452C |= 0x11
	MOV R3, #UART_PORT_CONFIG

	LDR R1, [R2, R3]
	ORR R1, R1, #0x11
	STR R1, [R2, R3]


	POP {r1-r3, lr}  ; restore stack
	MOV pc, lr


;---------------------------------;
;---------------------------------;
; initialize GPIO pins
;
; SW1 = F4 => input
; RGB = F1-3 => output
; SW2-5 = D0-3 => input

GPIO_init:
     PUSH {r1-r7, lr}


    ; SYSCTL_RCGC_UARG
	; provide clock to uart0 (done before in uart_init but redundancy is good)
    MOV R2, #0x0000
    MOVT R2, #0x400F

    MOV R3, #P_UART_CLK

    LDR R1, [R2, R3]
    ORR R1, #0x1
    STR R1, [R2, R3]


    ; SYSCTL_RCGC_GPIO
    ; enable GPIO clock for port F, D
    MOV R3, #E_UART_CLK

    LDR R1, [R2, R3]
    ORR R1, #0x28
    STR R1, [R2, R3]


    ; set pin directions
    ; GPIODIR
    ; port F
    MOV R2, #0x5000
    MOVT R2, #0x4002

	; rgb output 1,2,3
	; sw1 input 4
    LDRB R1, [R2, #DIR]
    ORR R1, #0x0E
    BIC R1, #0x10
    STRB R1, [R2, #DIR]

    ; set each pin as digital i/o
    LDRB R1, [R2, #DEN]
    ORR R1, #0x1E
    STRB R1, [R2, #DEN]
    ; configure pullup resistor for sw1
    LDRB R1, [R2, #PUR]
    ORR R1, #0x10
    STRB R1, [R2, #PUR]


    ; port D
    MOV R2, #0x7000
    MOVT R2, #0x4000

	; sw2-5 input D0-3
    LDRB R1, [R2, #DIR]
    BIC R1, #0xF
    STRB R1, [R2, #DIR]

    ; set each pin as digital i/o
    LDRB R1, [R2, #DEN]
    ORR R1, #0x0F
    STRB R1, [R2, #DEN]
    ; configure pullup resistor
    ;LDRB R1, [R2, #PUR]
    ;ORR R1, #0x0F
    ;STRB R1, [R2, #PUR]

    POP {r1-r7, lr}
    MOV pc, lr

;;;------------------------------------------------------------------------------;;;
;;;---------------------------INTERRUPT INTIALIZATION----------------------------;;;
;;;------------------------------------------------------------------------------;;;

uart_interrupt_init:

	; UART0 base address
	MOV R0, #0xC000
	MOVT R0, #0x4000

	; set RXIM in UARTIM
	LDR R1, [R0, #UARTIM]
	ORR R1, #RXIM
	STR R1, [R0, #UARTIM]

	; allow UART to interrupt processor
	MOV R0, #0xE000
	MOVT R0, #0xE000

	; set bit 5 (uart0) in nvic
	LDR R1, [R0, #EN0]
	ORR R1, #UART0
	STR R1, [R0, #EN0]

	MOV pc, lr

;;;------------------------------------------------------------------------------;;;
gpio_interrupt_init:

	; port F
	MOV R0, #0x5000
	MOVT R0, #0x4002

	; port D
	MOV R2, #0x7000
	MOVT R2, #0x4000

	; bit 4: SW1
	MOV R3, #0x10
	; bit 0-3; SW2-5
	MOV R4, #0x0F

	; edge< / level sensitive
	LDRB R1, [R0, #GPIOIS]
	BIC R1, R3
	STRB R1, [R0, #GPIOIS]
	; edge< / level sensitive
	LDRB R1, [R2, #GPIOIS]
	BIC R1, R4
	STRB R1, [R2, #GPIOIS]


	; Both / single< edge trigger
	LDRB R1, [R0, #GPIOIBE]
	BIC R1, R3
	STRB R1, [R0, #GPIOIBE]
	; Both / single< edge trigger
	LDRB R1, [R2, #GPIOIBE]
	BIC R1, R4
	STRB R1, [R2, #GPIOIBE]


	; Rising< / Falling edge
	LDRB R1, [R0, #GPIOEV]
	ORR R1, R3
	STRB R1, [R0, #GPIOEV]
	; Rising< / Falling edge
	LDRB R1, [R2, #GPIOEV]
	ORR R1, R4
	STRB R1, [R2, #GPIOEV]


	; mask / unmask<
	LDRB R1, [R0, #GPIOIM]
	ORR R1, R3
	STRB R1, [R0, #GPIOIM]
	; mask / unmask<
	LDRB R1, [R2, #GPIOIM]
	ORR R1, R4
	STRB R1, [R2, #GPIOIM]


	; allow GPIO port D,F to interrupt processor
	MOV R0, #0xE000
	MOVT R0, #0xE000

	LDR R1, [R0, #EN0]
	ORR R1, #GPIOF
	ORR R1, #GPIOD
	STR R1, [R0, #EN0]


	MOV pc, lr

;;;------------------------------------------------------------------------------;;;
timer_interrupt_init:

	PUSH{R0-R2, lr}

	; connect clock to timer
	MOV R0, #0xE000
	MOVT R0, #0x400F

	LDR R1, [R0, #RCGCTIMER]
	ORR R1, #0x1
	STR R1, [R0, #RCGCTIMER]

	; common base address
	MOV R0, #0x0000
	MOVT R0, #0x4003

	; disable timer
	LDR R1, [R0, #GPTMCTL]
	BIC R1, #0x1
	STR R1, [R0, #GPTMCTL]

	; put timer in 32 bit mode
	LDR R1, [R0, #GPTMCFG]
	BIC R1, #0x1
	STR R1, [R0, #GPTMCFG]

	; put timer in periodic mode
	LDR R1, [R0, #GPTMTAMR]
	BIC R1, #0x3			; safety from being in capture mode
	ORR R1, #0x2
	STR R1, [R0, #GPTMTAMR]

	; set interval period
	; 2ticks per clock @ 16MHz = 32MHz
	; 32,000,000 = 0x01E84800
	MOV R1, #0x4800
	MOVT R1, #0x01E8
	STR R1, [R0, #GPTMTAILR]

	; enable timer to interrupt processor
	LDR R1, [R0, #GPTMIMR]
	ORR R1, #0x1
	STR R1, [R0, #GPTMIMR]

	; config processor to allow interruptions from timer
	MOV R0, #0xE000
	MOVT R0, #0xE000

	LDR R1, [R0, #EN0]
	ORR R1, R1, #(1 << 19)  ;set bit 19
	STR R1, [R0, #EN0]

	; re-enable timer
	;MOV R0, #0x0000
	;MOVT R0, #0x4003

	;LDR R1, [R0, #GPTMCTL]
	;ORR R1, #0x1
	;STR R1, [R0, #GPTMCTL]

	POP{R0-R2, lr}
	MOV pc, lr


;------------------------------------------------;
; modulus
; Takes  R0 % R1 -> R0, R1 unchanged
; EXAMPLE modulus input (R0: 6, R1: 4), output (R0: 2, R1: 4)

modulus:
	PUSH {R2-R11, lr}

	UDIV R3, R0, R1 ;div to get quotient
	MUL R3, R3, R1	;Need for computing remainder
	SUB R0, R0, R3	;the mod (remainder)

	POP {R2-R11, lr}
	MOV pc, lr


;----------------------------------------------;
; Transmits a character to PuTTy via the UART.
output_character:
	PUSH {r1-r3, lr} ; Store register lr on stack

 	;Loading the Address of the data register into r1
	MOV r1, #0xC000 ;Load lower portion
	MOVT r1, #0x4000 ; Load upper

; while TxFF = 1: poll
Loop:
	LDRB r2, [r1, #U0FR] ;Get the flag register value
	AND r3, r2, #TxFF
	CMP r3, #0x20
	BEQ Loop

Complete:

	STRB r0, [r1] ;Storing back into the data register

	POP {r1-r3, lr}
	mov pc, lr

;------------------------------------;
; displays a null-terminated string in PuTTy.

output_string:
	PUSH {R1-R2, lr} ; Store register lr on stack

	; memory offset
	MOV R1, #0

OS_loop:

	; Load ASCII byte from memory
	LDRB R2, [R0, R1]

	; Check if NULL terminator
	CMP R2, #0
	BEQ OS_end

	; Increment memory offset
	ADD R1, R1, #0x1

	; Print Character
	PUSH {R0}
	MOV R0, R2
	BL output_character
	POP {R0}

	B OS_loop

OS_end:

	; print newline
	;PUSH {R0}
	;MOV R0, #0xA
	;BL output_character
	;MOV R0, #0xD
	;BL output_character
	;POP {R0}

	POP {R1-R2, lr}
	mov pc, lr

;--------------------------------------;
; reads and returns a character from PuTTy via the UART

read_character:
	PUSH {R1-R3, lr} ; Store register lr on stack

	; data register
	MOV R1, #0xC000
	MOVT R1, #0x4000

; while RxFE = 1: loop
POLL:
	LDRB R2, [R1, #U0FR]

	AND R2, R2, #RxFE

	CMP R2, #RxFE
	BEQ POLL

	; load from data register
	LDRB R3, [R1]
	MOV R0, R3


	POP {R1-R3, lr}
	mov pc, lr

;----------------------------------------------------;
simple_read_character:
    PUSH {R1-R2, lr} ; Store register lr on stack

    ; data register
    MOV R1, #0xC000
    MOVT R1, #0x4000

    ; load from data register
    LDRB R2, [R1]
    MOV R0, R2

     ; Restore and return
    POP {R1-R2, lr}
    MOV PC,LR

;----------------------------------------------------;
; reads a string entered in PuTTy and stores it as a
; null-terminated string in memory

read_string:
	PUSH {R1-R2, lr} ; Store register lr on stack

	MOV R1, #0	; memory offset

RS_loop:

	; Read character from PuTTy/UART and store in R2
	PUSH {R0}
	BL read_character
	MOV R2, R0
	POP {R0}

	; Check if Carriage Return
	CMP R2, #13
	BEQ RS_end

	; Store char byte in memory
	STRB R2, [R0, R1]

	; Increment memory offset
	ADD R1, R1, #0x1

	B RS_loop

RS_end:
	; store NULL byte at end
	MOV R2, #0x00
	STRB R2, [R0, R1]

	POP {R1-R2, lr}
	mov pc, lr


;----------------------------------------------------;
; merges the values of R0, and R1 into R0
; Sets R1 -> zero in the case of a merge, keeps it if not
merge:
	PUSH {R2-R11}

	CMP R0, R1	;Determine if mergeable
	BEQ m_equal

	CMP R0, #0x0 ;Determine if R0 is zero
	BEQ m_equal ;Keep merging

	CMP R1, #0x0 ;Determine if R1 is zero
	BEQ m_equal ;Keep merging


	B m_end		;Not mergeable end

m_equal:

	ADD R0, R0, R1	;Combine
	MOV R1, #0x0	; Reset R1 -> zero
	MOVT R1, #0x0

	; check if any of the blocks merged, if: set flag


m_end:
	POP {R2-R11}
	MOV pc, lr

;------------------------------------------;
; retuns 4-bit pattern of button presses in R0
read_from_push_btns:
    PUSH {r1, lr} ; Store register lr on stack

    ; port D
    MOV R1, #0x7000
    MOVT R1, #0x4000

    LDRB R0, [R1, #DATA] ;loading the byte

	;isolate Pins 0-3
    AND R0, #0x0F

    POP {r1, lr}
    MOV pc, lr

;---------------------------------------------;
; reads the value from switch 1 (SW1) on the
; Tiva board to determine if the button is being pressed
; returned in r0
read_tiva_push_button:
	PUSH {r1, lr}

	; port F
	; base address
	MOV R0, #0x5000
	MOVT R0, #0x4002

	LDRB R1, [R0, #DATA]

	; isolate Pin F4
	AND R1, R1, #0x10
	LSR R0, R1, #4

 	POP {r1, lr}
 	MOV pc, lr

;------------------------------------------------;
; reads a keypress on the keypad, and returns the value
; corresponding to the key that was pressed

read_keypad:
     PUSH {R1-R3, lr} ; Store register lr on stack

    ;Base Address Port D (send out)
    MOV R0, #0x7000
    MOVT R0, #0x4000

    ;Base Address Port A (receive)
    MOV R1, #0x4000
    MOVT R1, #0x4000

RK_poll:

	;----first row-----;
    MOV R3, #0x01
	STRB R3, [R0, #DATA]

    LDRB R3, [R1, #DATA]
    LSR R3, #0x2		; isolate A2-5
    LSL R3, #0x2

    CMP R3, #0x04 		; 1st col
    BEQ RK_F_A2
    CMP R3, #0x08 		; 2nd col
	BEQ RK_F_A3
	CMP R3, #0x10 		; 3rd col
	BEQ RK_F_A4
	CMP R3, #0x20 		; 4th col
	BEQ RK_F_A5

	;----second row-----;
	MOV R3, #0x02
	STRB R3, [R0, #DATA]

    LDRB R3, [R1, #DATA]
    LSR R3, #0x2		; isolate A2-5
    LSL R3, #0x2

    CMP R3, #0x04 		; 1st col
    BEQ RK_S_A2
	CMP R3, #0x08 		; 2nd col
	BEQ RK_S_A3
	CMP R3, #0x10 		; 3rd col
	BEQ RK_S_A4
	CMP R3, #0x20 		; 4th col
	BEQ RK_S_A5

	;----third row-----;
	MOV R3, #0x04
	STRB R3, [R0, #DATA]

    LDRB R3, [R1, #DATA]
    LSR R3, #0x2		; isolate A2-5
    LSL R3, #0x2

    CMP R3, #0x04 		; 1st col
    BEQ RK_T_A2
	CMP R3, #0x08 		; 2nd col
	BEQ RK_T_A3
	CMP R3, #0x10 		; 3rd col
	BEQ RK_T_A4
	CMP R3, #0x20 		; 4th col
	BEQ RK_T_A5

	;----fourth row-----;
	MOV R3, #0x08
	STRB R3, [R0, #DATA]

    LDRB R3, [R1, #DATA]
    LSR R3, #0x2		; isolate A2-5
    LSL R3, #0x2

    CMP R3, #0x04 		; 1st col
    BEQ RK_A_A2
	CMP R3, #0x08 		; 2nd col
	BEQ RK_A_A3
	CMP R3, #0x10 		; 3rd col
	BEQ RK_A_A4
	CMP R3, #0x20 		; 4th col
	BEQ RK_A_A5

	B RK_poll

RK_F_A2:
    MOV R0, #0x31 ;1
    B RK_end
RK_F_A3:
    MOV R0, #0x32 ;2
    B RK_end
RK_F_A4:
    MOV R0, #0x33 ;3
    B RK_end
RK_F_A5:
    MOV R0, #0x41 ;A
    B RK_end
;-------------------;
RK_S_A2:
    MOV R0, #0x34 ;4
    B RK_end
RK_S_A3:
    MOV R0, #0x35 ;5
    B RK_end
RK_S_A4:
    MOV R0, #0x36 ;6
    B RK_end
RK_S_A5:
    MOV R0, #0x42 ;B
    B RK_end
;-------------------;
RK_T_A2:
    MOV R0, #0x37 ;7
    B RK_end
RK_T_A3:
    MOV R0, #0x38 ;8
    B RK_end
RK_T_A4:
    MOV R0, #0x39 ;9
    B RK_end
RK_T_A5:
    MOV R0, #0x43 ;C
    B RK_end
;-------------------;
RK_A_A2:
    MOV R0, #0x2A ;*
    B RK_end
RK_A_A3:
    MOV R0, #0x30 ;0
    B RK_end
RK_A_A4:
    MOV R0, #0x23 ;#
    B RK_end
RK_A_A5:
    MOV R0, #0x44 ;D
    B RK_end
;-------------------;

RK_end:
     POP {R1-R3, lr}
     MOV pc, lr


;-----------------------------------------;
; RGB LED colors
; The color to be displayed is passed into R0.
;
; RED		0x2
; BLUE		0x4
; PURPLE	0x6
; GREEN		0x8
; YELLOW	0xA
; CYAN		0xC
; WHITE		0xE

illuminate_RGB_LED:
 	PUSH {lr}

	; port F
	MOV R1, #0x5000
	MOVT R1, #0x4002

	; store color in data section of port
	STRB R0, [R1, #DATA]

 	POP {lr}
 	MOV pc, lr

;-----------------------------------------;
; r0 between 0-F
; 4 bit pattern indicates which LEDs to light

illuminate_LEDs:
 	PUSH {lr} ; Store register lr on stack

 	; port B
 	MOV R1, #0x5000
 	MOVT R1, #0x4000

	MOV R0, #0xC
 	STRB R0, [R1, #DATA]

 	POP {lr}
 	MOV pc, lr







;==================================================;
int2string:
	PUSH {R0-R3, R10, lr} ; Store register lr on stack

	MOV R2, #0	 ; memory offset
	MOV R10, #10 ; divisor for modulo

	; R2 = digit count (for memory offset)
	PUSH {R0} ; protect R0 for digit count
dig_count:
	CMP R0, #0
	BEQ next
	ADD R2, R2, #1
	UDIV R0, R0, R10
	B dig_count

next:
	POP {R0} ; restore original R0

	; store bytes from right to left (LSB to MSB), starting with NULL byte
	MOV R3, #0x00
	STRB R3, [R1, R2]

i2s_iter:

	CMP R0, #0
	BEQ i2s_end

	; isolate lowest digit
	UDIV R3, R0, R10
	MUL R3, R3, R10
	SUB R3, R0, R3

	; convert from integer to ASCII hex
	ADD R3, R3, #0x30

	; decrement offset
	SUB R2, R2, #1

	; store ASCII char in memory
	STRB R3, [R1, R2]

	; shift to right to get next digit
	UDIV R0, R0, R10

	B i2s_iter

i2s_end:
	; restore stack
	POP {R0-R3, R10, lr}
	mov pc, lr

;------------------------------------------------;
; string2int
; takes in the base address of a string and returns the integer representation in R0
; we assume that )0 contains the base address of the string

string2int: ;We assume that r0 contains the base address of the string
	PUSH {R1-R5, lr} ; Store register lr on stack

	MOV R1, #0 	; Memory Offset
	MOV R2, #10 ; Stores multiplier for exponentiation (base 10)
	MOV R4, #1 	; This stores the current value 1,10,100,1000...
	MOV R5, #0 	; R5 holds the running total

digit_count:
	LDRB R3, [R0, R1] ;Get character of string
	CMP R3, #0x0 ; Check for NULL byte

	BEQ pre_loop
	ADD R1, R1, #1 ;Increment Offset
	B digit_count

pre_loop:
	SUB R1, R1, #1 ; Decrement Offset for 0 indexing

SI_Loop: ; Just do the exponent in the loop

	LDRB R3, [R0, R1] ; Get right-most character of string

	CMP R3, #0 ; Check for NULL byte
	BEQ SI_end

	CMP R3, #0x39 ;Checking that that it's an int
	BGT NotAInt
	CMP R3, #0x29
	BLE NotAInt

	SUB R3, R3, #0x30 ;get the actual integer

	MUL R3, R3, R4 ;Integer with correct base
	ADD R5, R5, R3 ;Add to the current Integer

	MUL R4, R2, R4 ;This holds the multiple 1,10,100,1000...

	SUB R1, R1, #1 ; Decrement memory offset
	B SI_Loop

;This section prints that the user entered string is not an integer
NotAInt:

	; print error message
	LDR R0, ptr_to_notInt
	BL output_string

	; fix registers
	POP {R1-R5, lr}
	;Must move the pc!
     MOV pc, lr
; for NULL byte
SI_end:
	MOV R0, R5
	POP {R1-R5, lr}
     MOV pc, lr
.end

