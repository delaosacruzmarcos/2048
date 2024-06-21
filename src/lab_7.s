	.data

	; screens
	.global pause_menu
	.global start_menu
	.global win_block_menu
	.global clear_screen
	.global LOSE_end
	.global WIN_end

	; game components
	.global block0
	.global block2
	.global block4
	.global block8
	.global block16
	.global block32
	.global block64
	.global block128
	.global block256
	.global block512
	.global block1024
	.global block2048
	.global game_board

	; value of each tile in grid
	.global SQ0
	.global SQ1
	.global SQ2
	.global SQ3
	.global SQ4
	.global SQ5
	.global SQ6
	.global SQ7
	.global SQ8
	.global SQ9
	.global SQ10
	.global SQ11
	.global SQ12
	.global SQ13
	.global SQ14
	.global SQ15

	; ansi position of each tile in grid
	.global position_SQ0
	.global position_SQ1
	.global position_SQ2
	.global position_SQ3
	.global position_SQ4
	.global position_SQ5
	.global position_SQ6
	.global position_SQ7
	.global position_SQ8
	.global position_SQ9
	.global position_SQ10
	.global position_SQ11
	.global position_SQ12
	.global position_SQ13
	.global position_SQ14
	.global position_SQ15

	; Merge flags (meta data based on SQ's)
	.global merge_A
	.global merge_B
	.global merge_C
	.global merge_D
	.global merge_E
	.global merge_F
	.global merge_G
	.global merge_H

	; meta
	.global TIMESCORE_prompt
	.global SCORE
	.global SCORE_string
	.global TIME
	.global TIME_string
	;.global END_status
	;.global PAUSED_status
	;.global CHANGE_status
	.global WIN_BLOCK
	.global position


; track time and score for current game
SCORE:				.word 0x00000000
SCORE_string:		.string "    ",0

TIME:				.word 0x00000000
TIME_string:		.string "    ",0

; flags for checking in progress/ended
;END_status:			.byte 0x00
;PAUSED_status:		.byte 0x00
;CHANGE_status:		.byte 0x00
START_status:		.byte 0x00

;Winning value block - default 2048
WIN_BLOCK: .half 2048

;Data corresponding to square values
SQ0:	.word 0x00
SQ1:	.word 0x00
SQ2:	.word 0x00
SQ3:	.word 0x00

SQ4:	.word 0x00
SQ5:	.word 0x00
SQ6:	.word 0x00
SQ7:	.word 0x00

SQ8:	.word 0x00
SQ9:	.word 0x00
SQ10:	.word 0x00
SQ11:	.word 0x00

SQ12:	.word 0x00
SQ13:	.word 0x00
SQ14:	.word 0x00
SQ15:	.word 0x00

; Merge Pointers
merge_A:		.word 0x00000000
merge_B:		.word 0x00000000
merge_C:		.word 0x00000000
merge_D:		.word 0x00000000
merge_E:		.word 0x00000000
merge_F:		.word 0x00000000
merge_G:		.word 0x00000000
merge_H:		.word 0x00000000


;;-----------------------------------------------------------;;
 	.text

 	.global uart_init
 	.global GPIO_init

 	.global uart_interrupt_init
 	.global gpio_interrupt_init
 	.global timer_interrupt_init

 	.global UART0_Handler			; for keystrokes
 	.global Switch_Handler			; for button/switch press
 	.global Timer_Handler			; for timer

 	.global simple_read_character	; get keystroke w,a,s,d
 	.global read_from_push_btns		; read sw2-5
 	.global read_tiva_push_button	; read sw1
 	.global output_character
 	.global output_string
 	.global int2string				; to print current score and time
 	.global illuminate_RGB_LED
	.global modulus					; r0 % r1
 	.global lab7					; main

	;Movement Subroutines
 	.global move_left
 	.global move_right
 	.global move_upward
 	.global move_downward
 	.global shift_ptrs
 	.global move_ptrs
 	.global merge_ptrs
 	.global merge
 	.global clear_merge_ptrs

 	; game mechanics
 	.global clear_game
	.global random_generator				; RNG
	.global spawn_random_block
	.global render_game_board

	.global time_position
	.global score_position

ptr_to_pause_menu:			.word pause_menu
ptr_to_start_menu:			.word start_menu
ptr_to_change_win_menu:		.word win_block_menu
ptr_to_clear_screen:		.word clear_screen
ptr_to_game_board:			.word game_board
ptr_to_win:					.word WIN_end
ptr_to_lose:				.word LOSE_end
;ptr_to_end_status:			.word END_status
;ptr_to_paused_status:		.word PAUSED_status
;ptr_to_change_status:		.word CHANGE_status
ptr_to_start_status:		.word START_status
ptr_to_timescore_prompt:	.word TIMESCORE_prompt

ptr_to_score_position:		.word score_position
ptr_to_time_position:		.word time_position

ptr_to_score:				.word SCORE
ptr_to_score_string:		.word SCORE_string
ptr_to_time:				.word TIME
ptr_to_time_string:			.word TIME_string

ptr_to_block0:				.word block0
ptr_to_block2:				.word block2
ptr_to_block4:				.word block4
ptr_to_block8:				.word block8
ptr_to_block16:				.word block16
ptr_to_block32:				.word block32
ptr_to_block64:				.word block64
ptr_to_block128:			.word block128
ptr_to_block256:			.word block256
ptr_to_block512:			.word block512
ptr_to_block1024:			.word block1024
ptr_to_block2048:			.word block2048

;ptrs to abstraction layer
ptr_to_SQ0: 				.word SQ0
ptr_to_SQ1: 				.word SQ1
ptr_to_SQ2: 				.word SQ2
ptr_to_SQ3: 				.word SQ3

ptr_to_SQ4: 				.word SQ4
ptr_to_SQ5: 				.word SQ5
ptr_to_SQ6: 				.word SQ6
ptr_to_SQ7: 				.word SQ7

ptr_to_SQ8:					.word SQ8
ptr_to_SQ9:					.word SQ9
ptr_to_SQ10: 				.word SQ10
ptr_to_SQ11: 				.word SQ11

ptr_to_SQ12: 				.word SQ12
ptr_to_SQ13: 				.word SQ13
ptr_to_SQ14: 				.word SQ14
ptr_to_SQ15: 				.word SQ15

;ptrs to meta data
ptr_to_merge_A:		.word merge_A
ptr_to_merge_B:		.word merge_B
ptr_to_merge_C:		.word merge_C
ptr_to_merge_D:		.word merge_D
ptr_to_merge_E:		.word merge_E
ptr_to_merge_F:		.word merge_F
ptr_to_merge_G:		.word merge_G
ptr_to_merge_H:		.word merge_H

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ptr_to_position_SQ0: 		.word position_SQ0
ptr_to_position_SQ1: 		.word position_SQ1
ptr_to_position_SQ2: 		.word position_SQ2
ptr_to_position_SQ3: 		.word position_SQ3

ptr_to_position_SQ4: 		.word position_SQ4
ptr_to_position_SQ5: 		.word position_SQ5
ptr_to_position_SQ6: 		.word position_SQ6
ptr_to_position_SQ7: 		.word position_SQ7

ptr_to_position_SQ8:		.word position_SQ8
ptr_to_position_SQ9:		.word position_SQ9
ptr_to_position_SQ10: 		.word position_SQ10
ptr_to_position_SQ11: 		.word position_SQ11

ptr_to_position_SQ12: 		.word position_SQ12
ptr_to_position_SQ13: 		.word position_SQ13
ptr_to_position_SQ14: 		.word position_SQ14
ptr_to_position_SQ15: 		.word position_SQ15

; ptr to winning value block
ptr_to_win_block: .word WIN_BLOCK


;;;------------------------------------------------------------------------------;;;
;;;------------------------------------------------------------------------------;;;
lab7:
	PUSH {lr}

	;;; INITIALIZATION ;;;
	bl uart_init
	bl GPIO_init
	bl uart_interrupt_init
	bl gpio_interrupt_init
	bl timer_interrupt_init
	;;;;;;;;;;;;;;;;;;;;;;;

	;; clear terminal display
	LDR R0, ptr_to_clear_screen
	BL output_string

	;; reset game stats/trackers
	BL clear_game

	;; display starting screen
	LDR R0, ptr_to_start_menu
	BL output_string

; infinite loop for thread mode
l:
	b l

	MOV pc, lr
;;;--------------------------------------------------------------------------;;;
;;;--------------------------------------------------------------------------;;;


clear_game:
	PUSH {r0-r2, lr}

	MOV R0, #0

	; new timer
	LDR R1, ptr_to_time
	STR R0, [R1]
	; new score
	LDR R1, ptr_to_score
	STR R0, [R1]
	; clear SQ's values
	LDR R2, ptr_to_SQ0
	STRH R0, [R2]
	LDR R2, ptr_to_SQ1
	STRH R0, [R2]
	LDR R2, ptr_to_SQ2
	STRH R0, [R2]
	LDR R2, ptr_to_SQ3
	STRH R0, [R2]
	LDR R2, ptr_to_SQ4
	STRH R0, [R2]
	LDR R2, ptr_to_SQ5
	STRH R0, [R2]
	LDR R2, ptr_to_SQ6
	STRH R0, [R2]
	LDR R2, ptr_to_SQ7
	STRH R0, [R2]
	LDR R2, ptr_to_SQ8
	STRH R0, [R2]
	LDR R2, ptr_to_SQ9
	STRH R0, [R2]
	LDR R2, ptr_to_SQ10
	STRH R0, [R2]
	LDR R2, ptr_to_SQ11
	STRH R0, [R2]
	LDR R2, ptr_to_SQ12
	STRH R0, [R2]
	LDR R2, ptr_to_SQ13
	STRH R0, [R2]
	LDR R2, ptr_to_SQ14
	STRH R0, [R2]
	LDR R2, ptr_to_SQ15
	STRH R0, [R2]
	; clean up any merge pointers
	LDR R2, ptr_to_merge_A
	STR R0, [R2]
	LDR R2, ptr_to_merge_B
	STR R0, [R2]
	LDR R2, ptr_to_merge_C
	STR R0, [R2]
	LDR R2, ptr_to_merge_D
	STR R0, [R2]
	LDR R2, ptr_to_merge_E
	STR R0, [R2]
	LDR R2, ptr_to_merge_F
	STR R0, [R2]
	LDR R2, ptr_to_merge_G
	STR R0, [R2]
	LDR R2, ptr_to_merge_H
	STR R0, [R2]

	POP {r0-r2, lr}
	MOV pc, lr



;;;------------------------------------------------------------------------------;;;
;;;----------------------------RANDON NUMBER GENERATOR---------------------------;;;
;;;------------------------------------------------------------------------------;;;
; Takes in initial arguments in R0
; Returns resulting pseudo-random number mod 16 in R0
; Returns 2 or 4 w prob of 10/16 , 6/16 ~~~ 37.5:62.5
random_generator:
	PUSH{lr}

	; get timer value
	MOV R0, #0x0000
	MOVT R0, #0x4003
	; GPTMTAV
	LDR R0, [R0, #0x050]

	; x ^= x rot> 13
	ROR R1, R0, #13
	EOR R1, R0

	; x ^= x>>17
	LSR R2, R1, #17
	EOR R2, R1

	; x = x%r1
	MOV R0, R2
	MOV R1, #16
	BL modulus

	; if x <= 6, return 4
	; else,		 return 2
	CMP R0, #6
	ITE LT
	MOVLT R1, #4
	MOVGE R1, #2


	POP{lr}
	MOV pc, lr
;;;------------------------------------------------------------------------------;;;



;;;------------------------------------------------------------------------------;;;
;;;------------------------------BLOCK MOVEMENTS---------------------------------;;;
;;;------------------------------------------------------------------------------;;;
;;;		HIEARCHY OF SUBROUTINES
; Refering to the order of subroutine calls LOG -> BRANCH -> TWIG -> LEAF
; ### Notice all LOG level subroutines will need to be called four times for
; for one complete movement (reset the A-H) ptrs between movements
;;;----ROOT-----;;;
;Interact with the timer to display the movement of the squares across the gameboard
;;; movement_left
;;; movement_right
;;; movement_down
;;; movement_up
;;;-----LOG-----;;;
;Process one call of the merge sweeping merge algorithm, must be called 4 times for complete movement
;;; move_left
;;; move_right
;;; move_down
;;; move_up
;;;----BRANCH---;;;
;Optimize out cases of Zero's being moved around
;;; shift_ptrs
;;;----TWIG-----;;;
;Deals with capped merges to prevent over merging
;;; merge_ptrs
;;; move_ptrs
;;;----LEAF-----;;;
; Simply merges two values
;;; merge

;;;-----------------------------LOG LEVEL--------------------------------;;;
;----------movement_left-------------;
; shifts enire board left one square
; must be called 4 times for complete left shift
move_left:
	PUSH {R4-R11, lr}
;---------First Two Blocks-----------;
	;Set up R0-R3 for the First row
	LDR R0, ptr_to_SQ0
	LDR R1, ptr_to_SQ1
	LDR R2, ptr_to_merge_A
	LDR R3, ptr_to_merge_B
	BL shift_ptrs
	;Set up R0-R3 for the Second row
	LDR R0, ptr_to_SQ4
	LDR R1, ptr_to_SQ5
	LDR R2, ptr_to_merge_C
	LDR R3, ptr_to_merge_D
	BL shift_ptrs
	;Set up R0-R3 for the Third row
	LDR R0, ptr_to_SQ8
	LDR R1, ptr_to_SQ9
	LDR R2, ptr_to_merge_E
	LDR R3, ptr_to_merge_F
	BL shift_ptrs
	;Set up R0-R3 for the Fourth row
	LDR R0, ptr_to_SQ12
	LDR R1, ptr_to_SQ13
	LDR R2, ptr_to_merge_G
	LDR R3, ptr_to_merge_H
	BL shift_ptrs

;---------Second Two Blocks----------;
	;Set up R0-R3 for the First row
	LDR R0, ptr_to_SQ1
	LDR R1, ptr_to_SQ2
	LDR R2, ptr_to_merge_A
	LDR R3, ptr_to_merge_B
	BL shift_ptrs
	;Set up R0-R3 for the Second row
	LDR R0, ptr_to_SQ5
	LDR R1, ptr_to_SQ6
	LDR R2, ptr_to_merge_C
	LDR R3, ptr_to_merge_D
	BL shift_ptrs
	;Set up R0-R3 for the Third row
	LDR R0, ptr_to_SQ9
	LDR R1, ptr_to_SQ10
	LDR R2, ptr_to_merge_E
	LDR R3, ptr_to_merge_F
	BL shift_ptrs
	;Set up R0-R3 for the Fourth row
	LDR R0, ptr_to_SQ13
	LDR R1, ptr_to_SQ14
	LDR R2, ptr_to_merge_G
	LDR R3, ptr_to_merge_H
	BL shift_ptrs

;---------Third Two Blocks-----------;
	;Set up R0-R3 for the First row
	LDR R0, ptr_to_SQ2
	LDR R1, ptr_to_SQ3
	LDR R2, ptr_to_merge_A
	LDR R3, ptr_to_merge_B
	BL shift_ptrs
	;Set up R0-R3 for the Second row
	LDR R0, ptr_to_SQ6
	LDR R1, ptr_to_SQ7
	LDR R2, ptr_to_merge_C
	LDR R3, ptr_to_merge_D
	BL shift_ptrs
	;Set up R0-R3 for the Third row
	LDR R0, ptr_to_SQ10
	LDR R1, ptr_to_SQ11
	LDR R2, ptr_to_merge_E
	LDR R3, ptr_to_merge_F
	BL shift_ptrs
	;Set up R0-R3 for the Fourth row
	LDR R0, ptr_to_SQ14
	LDR R1, ptr_to_SQ15
	LDR R2, ptr_to_merge_G
	LDR R3, ptr_to_merge_H
	BL shift_ptrs

;-----End of Move Left-----;
	POP {R4-R11, lr}
	MOV pc,lr


;----------movement_right-------------;
; shifts enire board right one square
; must be called 4 times for complete right shift
move_right:
	PUSH {R4-R11, lr}
;---------First Two Blocks-----------;
	;Set up R0-R3 for the First row
	LDR R0, ptr_to_SQ3
	LDR R1, ptr_to_SQ2
	LDR R2, ptr_to_merge_A
	LDR R3, ptr_to_merge_B
	BL shift_ptrs
	;Set up R0-R3 for the Second row
	LDR R0, ptr_to_SQ7
	LDR R1, ptr_to_SQ6
	LDR R2, ptr_to_merge_C
	LDR R3, ptr_to_merge_D
	BL shift_ptrs
	;Set up R0-R3 for the Third row
	LDR R0, ptr_to_SQ11
	LDR R1, ptr_to_SQ10
	LDR R2, ptr_to_merge_E
	LDR R3, ptr_to_merge_F
	BL shift_ptrs
	;Set up R0-R3 for the Fourth row
	LDR R0, ptr_to_SQ15
	LDR R1, ptr_to_SQ14
	LDR R2, ptr_to_merge_G
	LDR R3, ptr_to_merge_H
	BL shift_ptrs

;---------Second Two Blocks-----------;
	;Set up R0-R3 for the First row
	LDR R0, ptr_to_SQ2
	LDR R1, ptr_to_SQ1
	LDR R2, ptr_to_merge_A
	LDR R3, ptr_to_merge_B
	BL shift_ptrs
	;Set up R0-R3 for the Second row
	LDR R0, ptr_to_SQ6
	LDR R1, ptr_to_SQ5
	LDR R2, ptr_to_merge_C
	LDR R3, ptr_to_merge_D
	BL shift_ptrs
	;Set up R0-R3 for the Third row
	LDR R0, ptr_to_SQ10
	LDR R1, ptr_to_SQ9
	LDR R2, ptr_to_merge_E
	LDR R3, ptr_to_merge_F
	BL shift_ptrs
	;Set up R0-R3 for the Fourth row
	LDR R0, ptr_to_SQ14
	LDR R1, ptr_to_SQ13
	LDR R2, ptr_to_merge_G
	LDR R3, ptr_to_merge_H
	BL shift_ptrs

;---------Third Two Blocks-----------;
	;Set up R0-R3 for the First row
	LDR R0, ptr_to_SQ1
	LDR R1, ptr_to_SQ0
	LDR R2, ptr_to_merge_A
	LDR R3, ptr_to_merge_B
	BL shift_ptrs
	;Set up R0-R3 for the Second row
	LDR R0, ptr_to_SQ5
	LDR R1, ptr_to_SQ4
	LDR R2, ptr_to_merge_C
	LDR R3, ptr_to_merge_D
	BL shift_ptrs
	;Set up R0-R3 for the Third row
	LDR R0, ptr_to_SQ9
	LDR R1, ptr_to_SQ8
	LDR R2, ptr_to_merge_E
	LDR R3, ptr_to_merge_F
	BL shift_ptrs
	;Set up R0-R3 for the Fourth row
	LDR R0, ptr_to_SQ13
	LDR R1, ptr_to_SQ12
	LDR R2, ptr_to_merge_G
	LDR R3, ptr_to_merge_H
	BL shift_ptrs

;-----End of Move Right-----;
	POP {R4-R11, lr}
	MOV pc,lr

;----------movement_upward-------------;
; shifts enire board up one square
; must be called 4 times for complete upwards shift
move_upward:
	PUSH {R4-R11, lr}

;---------First Two Blocks-----------;
	;Set up R0-R3 for the First Column
	LDR R0, ptr_to_SQ0
	LDR R1, ptr_to_SQ4
	LDR R2, ptr_to_merge_A
	LDR R3, ptr_to_merge_B
	BL shift_ptrs
	;Set up R0-R3 for the Second Column
	LDR R0, ptr_to_SQ1
	LDR R1, ptr_to_SQ5
	LDR R2, ptr_to_merge_C
	LDR R3, ptr_to_merge_D
	BL shift_ptrs
	;Set up R0-R3 for the Third Column
	LDR R0, ptr_to_SQ2
	LDR R1, ptr_to_SQ6
	LDR R2, ptr_to_merge_E
	LDR R3, ptr_to_merge_F
	BL shift_ptrs
	;Set up R0-R3 for the Fourth Column
	LDR R0, ptr_to_SQ3
	LDR R1, ptr_to_SQ7
	LDR R2, ptr_to_merge_G
	LDR R3, ptr_to_merge_H
	BL shift_ptrs
;---------Second Two Blocks-----------;
	;Set up R0-R3 for the First Column
	LDR R0, ptr_to_SQ4
	LDR R1, ptr_to_SQ8
	LDR R2, ptr_to_merge_A
	LDR R3, ptr_to_merge_B
	BL shift_ptrs
	;Set up R0-R3 for the Second Column
	LDR R0, ptr_to_SQ5
	LDR R1, ptr_to_SQ9
	LDR R2, ptr_to_merge_C
	LDR R3, ptr_to_merge_D
	BL shift_ptrs
	;Set up R0-R3 for the Third Column
	LDR R0, ptr_to_SQ6
	LDR R1, ptr_to_SQ10
	LDR R2, ptr_to_merge_E
	LDR R3, ptr_to_merge_F
	BL shift_ptrs
	;Set up R0-R3 for the Fourth Column
	LDR R0, ptr_to_SQ7
	LDR R1, ptr_to_SQ11
	LDR R2, ptr_to_merge_G
	LDR R3, ptr_to_merge_H
	BL shift_ptrs
;---------Third Two Blocks-----------;
	;Set up R0-R3 for the First Column
	LDR R0, ptr_to_SQ8
	LDR R1, ptr_to_SQ12
	LDR R2, ptr_to_merge_A
	LDR R3, ptr_to_merge_B
	BL shift_ptrs
	;Set up R0-R3 for the Second Column
	LDR R0, ptr_to_SQ9
	LDR R1, ptr_to_SQ13
	LDR R2, ptr_to_merge_C
	LDR R3, ptr_to_merge_D
	BL shift_ptrs
	;Set up R0-R3 for the Third Column
	LDR R0, ptr_to_SQ10
	LDR R1, ptr_to_SQ14
	LDR R2, ptr_to_merge_E
	LDR R3, ptr_to_merge_F
	BL shift_ptrs
	;Set up R0-R3 for the Fourth Column
	LDR R0, ptr_to_SQ11
	LDR R1, ptr_to_SQ15
	LDR R2, ptr_to_merge_G
	LDR R3, ptr_to_merge_H
	BL shift_ptrs

;-----End of Move Up-----;
	POP {R4-R11, lr}
	MOV pc,lr

;----------movement_downward-------------;
; shifts enire board down one square
; must be called 4 times for complete downwards shift
move_downward:
	PUSH {R4-R11, lr}
;---------First Two Blocks-----------;
	;Set up R0-R3 for the First Column
	LDR R0, ptr_to_SQ12
	LDR R1, ptr_to_SQ8
	LDR R2, ptr_to_merge_A
	LDR R3, ptr_to_merge_B
	BL shift_ptrs
	;Set up R0-R3 for the Second Column
	LDR R0, ptr_to_SQ13
	LDR R1, ptr_to_SQ9
	LDR R2, ptr_to_merge_C
	LDR R3, ptr_to_merge_D
	BL shift_ptrs
	;Set up R0-R3 for the Third Column
	LDR R0, ptr_to_SQ14
	LDR R1, ptr_to_SQ10
	LDR R2, ptr_to_merge_E
	LDR R3, ptr_to_merge_F
	BL shift_ptrs
	;Set up R0-R3 for the Fourth Column
	LDR R0, ptr_to_SQ15
	LDR R1, ptr_to_SQ11
	LDR R2, ptr_to_merge_G
	LDR R3, ptr_to_merge_H
	BL shift_ptrs

;---------Second Two Blocks-----------;
	;Set up R0-R3 for the First Column
	LDR R0, ptr_to_SQ8
	LDR R1, ptr_to_SQ4
	LDR R2, ptr_to_merge_A
	LDR R3, ptr_to_merge_B
	BL shift_ptrs
	;Set up R0-R3 for the Second Column
	LDR R0, ptr_to_SQ9
	LDR R1, ptr_to_SQ5
	LDR R2, ptr_to_merge_C
	LDR R3, ptr_to_merge_D
	BL shift_ptrs
	;Set up R0-R3 for the Third Column
	LDR R0, ptr_to_SQ10
	LDR R1, ptr_to_SQ6
	LDR R2, ptr_to_merge_E
	LDR R3, ptr_to_merge_F
	BL shift_ptrs
	;Set up R0-R3 for the Fourth Column
	LDR R0, ptr_to_SQ11
	LDR R1, ptr_to_SQ7
	LDR R2, ptr_to_merge_G
	LDR R3, ptr_to_merge_H
	BL shift_ptrs

;---------Third Two Blocks-----------;
	;Set up R0-R3 for the First Column
	LDR R0, ptr_to_SQ4
	LDR R1, ptr_to_SQ0
	LDR R2, ptr_to_merge_A
	LDR R3, ptr_to_merge_B
	BL shift_ptrs
	;Set up R0-R3 for the Second Column
	LDR R0, ptr_to_SQ5
	LDR R1, ptr_to_SQ1
	LDR R2, ptr_to_merge_C
	LDR R3, ptr_to_merge_D
	BL shift_ptrs
	;Set up R0-R3 for the Third Column
	LDR R0, ptr_to_SQ6
	LDR R1, ptr_to_SQ2
	LDR R2, ptr_to_merge_E
	LDR R3, ptr_to_merge_F
	BL shift_ptrs
	;Set up R0-R3 for the Fourth Column
	LDR R0, ptr_to_SQ7
	LDR R1, ptr_to_SQ3
	LDR R2, ptr_to_merge_G
	LDR R3, ptr_to_merge_H
	BL shift_ptrs

;-----End of Move Up-----;
	POP {R4-R11, lr}
	MOV pc,lr

;;;---------------------------BRANCH LEVEL--------------------------------;;;
;----------shift_ptrs--------------------;
; Parameters (pass in)
; R0 holds ptr_to_SQX
; R1 holds ptr_to_SQY
; R2 holds ptr_to_@	(A,C,E,G)
; R3 holds ptr_to_% (B,D,F,H)
shift_ptrs:
	PUSH {R4-R11, lr}
	;2A Determine if SQX holds Zero
	LDR R4, [R0] ;Get value of SQX
	CMP R4, #0x0 ;Compare
	BEQ SP_move_ptrs

	;2B Determine if SQY holds Zero
	LDR R4, [R1] ;Get value of SQY
	CMP R4, #0x0	 ;Compare
	BEQ SP_move_ptrs

SP_merge_ptrs:;Jump to merge_ptrs (no zero present)
	BL merge_ptrs
	B SP_end

SP_move_ptrs: ;Jump to move_ptrs (one zero present)
	BL move_ptrs
	B SP_end

SP_end: ;Ending shift_ptrs
	POP {R4-R11, lr}
	MOV pc, lr

;;;----------------------------TWIG LEVEL---------------------------------;;;
;----------merge_ptrs--------------------;
; Parameters (pass in)
; R0 holds ptr_to_SQX
; R1 holds ptr_to_SQY
; R2 holds ptr_to_@	(A,C,E,G)
; R3 holds ptr_to_% (B,D,F,H)
merge_ptrs:
	PUSH {R4-R11, lr}
	;3 Check that SQX != @
	LDR R4, [R2] ;Load the value of ptr_to_@
	CMP R4, R0
	BEQ MRP_end ;4B no merge

	;3 Check that SQX != %
	LDR R4, [R3] ;Load the value of ptr_to_%
	CMP R4, R1
	BEQ MRP_end ;4B no merge

	;4A Check if @ is null
	LDR R4, [R2]

	CMP R4, #0x0
	ITE NE
	STRNE R0, [R3] ;5A Set @ = SQX (first capped merge of row)
	STREQ R0, [R2] ;5B Set % = SQX (Second capped merge of row)

	;6 set up and execute the merge
	MOV R10, R0	;Preserve ptr_to_SQX
	MOV R11, R1	;Preserve ptr_to_SQY
	LDR R0, [R10] ;Load value at ptr_to_SQX
	LDR R1, [R11] ;Load value at ptr_to_SQY

	BL merge

	STR R0, [R10] ;Store merged value in SQX into SQX
	STR R1, [R11] ;Store merged value in SQY into SQY

	; update score tracking
	LDR R3, ptr_to_score
	LDR R4, [R3]
	ADD R4, R0
	ADD R4, R1
	STR R4, [R3]


MRP_end:
	POP {R4-R11, lr}
	MOV pc, lr

;----------move_ptrs--------------------;
; Parameters (pass in)
; R0 holds ptr_to_SQX
; R1 holds ptr_to_SQY
; R2 holds ptr_to_@	(A,C,E,G)
; R3 holds ptr_to_% (B,D,F,H)
move_ptrs:
	PUSH {R4-R11, lr}

	;3A Check SQY != @
	CMP R1, R2
	BEQ MVP_move_capped_ptr_0 ;@

	;3B Check SQY != B
	CMP R1, R3
	BEQ MVP_move_capped_ptr_1 ;%

MVP_merge:
	;Merge Set up
	MOV R10, R0 ;Preserve ptr_to_SQX
	MOV R11, R1 ;Preserve ptr_to_SQY

	LDR R0, [R10] ;Get the value at R10
	LDR R1, [R11] ;Get the value at R11

	BL merge

	STR R0, [R10] ;Store merged value in SQX into SQX
	STR R1, [R11] ;Store merged value in SQY into SQY
	B MVP_end ; Done with move


MVP_move_capped_ptr_0: ;4A SQY is pointed to by @
	LDR R0, [R2] ;Update @ to point to SQX (SQ in the direction of the move)
	B MVP_merge

MVP_move_capped_ptr_1: ;4A SQY is pointed to by %
	LDR R0, [R3] ;Update % to point ot SQX (SQ in the direction of the move)
	B MVP_merge

MVP_end:
	POP {R4-R11, lr}
	MOV pc, lr




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
spawn_random_block:
	PUSH {r0-r3, lr}

get_random:
	; seed in R0
	BL random_generator

get_position:
	CMP R0, #0x0
	ITT EQ
	LDREQ R0, ptr_to_position_SQ0
	LDREQ R2, ptr_to_SQ0
	BEQ get_block_value
	CMP R0, #0x1
	ITT EQ
	LDREQ R0, ptr_to_position_SQ1
	LDREQ R2, ptr_to_SQ1
	BEQ get_block_value
	CMP R0, #0x2
	ITT EQ
	LDREQ R0, ptr_to_position_SQ2
	LDREQ R2, ptr_to_SQ2
	BEQ get_block_value
	CMP R0, #0x3
	ITT EQ
	LDREQ R0, ptr_to_position_SQ3
	LDREQ R2, ptr_to_SQ3
	BEQ get_block_value
	CMP R0, #0x4
	ITT EQ
	LDREQ R0, ptr_to_position_SQ4
	LDREQ R2, ptr_to_SQ4
	BEQ get_block_value
	CMP R0, #0x5
	ITT EQ
	LDREQ R0, ptr_to_position_SQ5
	LDREQ R2, ptr_to_SQ5
	BEQ get_block_value
	CMP R0, #0x6
	ITT EQ
	LDREQ R0, ptr_to_position_SQ6
	LDREQ R2, ptr_to_SQ6
	BEQ get_block_value
	CMP R0, #0x7
	ITT EQ
	LDREQ R0, ptr_to_position_SQ7
	LDREQ R2, ptr_to_SQ7
	BEQ get_block_value
	CMP R0, #0x8
	ITT EQ
	LDREQ R0, ptr_to_position_SQ8
	LDREQ R2, ptr_to_SQ8
	BEQ get_block_value
	CMP R0, #0x9
	ITT EQ
	LDREQ R0, ptr_to_position_SQ9
	LDREQ R2, ptr_to_SQ9
	BEQ get_block_value
	CMP R0, #0xA
	ITT EQ
	LDREQ R0, ptr_to_position_SQ10
	LDREQ R2, ptr_to_SQ10
	BEQ get_block_value
	CMP R0, #0xB
	ITT EQ
	LDREQ R0, ptr_to_position_SQ11
	LDREQ R2, ptr_to_SQ11
	BEQ get_block_value
	CMP R0, #0xC
	ITT EQ
	LDREQ R0, ptr_to_position_SQ12
	LDREQ R2, ptr_to_SQ12
	BEQ get_block_value
	CMP R0, #0xD
	ITT EQ
	LDREQ R0, ptr_to_position_SQ13
	LDREQ R2, ptr_to_SQ13
	BEQ get_block_value
	CMP R0, #0xE
	ITT EQ
	LDREQ R0, ptr_to_position_SQ14
	LDREQ R2, ptr_to_SQ14
	BEQ get_block_value
	CMP R0, #0xF
	ITT EQ
	LDREQ R0, ptr_to_position_SQ15
	LDREQ R2, ptr_to_SQ15
	BEQ get_block_value

get_block_value:

	; if position already occupied, reroll
	LDR R3, [R2]
	CMP R3, #0
	BNE get_random

	; go to board position
	;BL output_string

	;CMP R1, #0x2
	;ITE EQ
	;LDREQ R0, ptr_to_block2
	;LDRNE R0, ptr_to_block4

	;update tracking
	STR R1, [R2]

	; render block
	;BL output_string

	POP {r0-r3, lr}
	MOV pc, lr

;--------------Clear Merge Ptrs----------------;
; Subroutine that clears all the merge ptrs (writes them to zero)
; Should be called after each movement call (Root Level)
clear_merge_ptrs:

	PUSH {R0-R11,lr}
	;Setting the zero
	MOV R1, #0x0

	LDR R0, ptr_to_merge_A
	STR R1, [R0]	;merge_A

	LDR R0, ptr_to_merge_B
	STR R1, [R0]	;merge_B

	LDR R0, ptr_to_merge_C
	STR R1, [R0]	;merge_C

	LDR R0, ptr_to_merge_D
	STR R1, [R0]	;merge_D

	LDR R0, ptr_to_merge_E
	STR R1, [R0]	;merge_E

	LDR R0, ptr_to_merge_F
	STR R1, [R0]	;merge_F

	LDR R0, ptr_to_merge_G
	STR R1, [R0]	;merge_G

	LDR R0, ptr_to_merge_H
	STR R1, [R0]	;merge_H

	POP {R0-R11,lr}
	MOV pc, lr
;;;------------------------------------------------------------------------------;;;
;;;----------------------------RENDER GAME BOARD---------------------------------;;;
;;;------------------------------------------------------------------------------;;;
;;;	Takes the SQ0-SQ15 ptrs from memory and renders their associated block values
;;; to putty in the order they are defined

render_game_board:
	PUSH {R0-R11, lr}

	; Order of ptrs after the loading phase
	;------Stack-------
	; SQ15
	; SQ14
	; SQ13
	; SQ12
	; SQ11
	; SQ10
	; SQ9
	; SQ8
	; SQ7
	; SQ6
	; SQ5
	; SQ4
	; SQ3
	; SQ2
	; SQ1
	; SQ0

;;;---------------------Loading Phase------------------------;;;
;;; (hint)
	; POP is actually LDM SP! <Register List>
	;PUSH is actually STMDB SP! <Register List>

	;Load Row 4 (12,13,14,15)
	LDR R0, ptr_to_SQ12
	LDR R1, ptr_to_SQ13
	LDR R2, ptr_to_SQ14
	LDR R3, ptr_to_SQ15
	;push to stack
	STMDB SP!, {R0-R3}

	;Load Row 3 (8,9,10,11)
	LDR R0, ptr_to_SQ8
	LDR R1, ptr_to_SQ9
	LDR R2, ptr_to_SQ10
	LDR R3, ptr_to_SQ11
	;push to stack
	STMDB SP!, {R0-R3}

	;Load Row 2 (4,5,6,7)
	LDR R0, ptr_to_SQ4
	LDR R1, ptr_to_SQ5
	LDR R2, ptr_to_SQ6
	LDR R3, ptr_to_SQ7
	;push to stack
	STMDB SP!, {R0-R3}

	;Load Row 1 (0,1,2,3)
	LDR R0, ptr_to_SQ0
	LDR R1, ptr_to_SQ1
	LDR R2, ptr_to_SQ2
	LDR R3, ptr_to_SQ3
	;push to stack
	STMDB SP!, {R0-R3}

	;At this point the pointers are all loaded onto the stack
	;Using R1 for the rows value

	MOV R2, #0x0 ;start i

RGB_Loop:
	; R0 ~ location of cursor
	; R1 ~ Value of the SQ
	; R2 ~ counter

	;Checking if loop complete
	CMP R2, #0x10
	BEQ RGB_end

	;Loading the value (0-2048) from the last pop into R1
	LDMIA SP!, {R0}
	LDR R1, [R0]

	;Assigning position
	CMP R2, #0x0
	IT EQ
	LDREQ R0, ptr_to_position_SQ0
	BEQ RGB_Compare

	CMP R2, #0x1
	IT EQ
	LDREQ R0, ptr_to_position_SQ1
	BEQ RGB_Compare

	CMP R2, #0x2
	IT EQ
	LDREQ R0, ptr_to_position_SQ2
	BEQ RGB_Compare

	CMP R2, #0x3
	IT EQ
	LDREQ R0, ptr_to_position_SQ3
	BEQ RGB_Compare

	CMP R2, #0x4
	IT EQ
	LDREQ R0, ptr_to_position_SQ4
	BEQ RGB_Compare

	CMP R2, #0x5
	IT EQ
	LDREQ R0, ptr_to_position_SQ5
	BEQ RGB_Compare

	CMP R2, #0x6
	IT EQ
	LDREQ R0, ptr_to_position_SQ6
	BEQ RGB_Compare

	CMP R2, #0x7
	IT EQ
	LDREQ R0, ptr_to_position_SQ7
	BEQ RGB_Compare

	CMP R2, #0x8
	IT EQ
	LDREQ R0, ptr_to_position_SQ8
	BEQ RGB_Compare

	CMP R2, #0x9
	IT EQ
	LDREQ R0, ptr_to_position_SQ9
	BEQ RGB_Compare

	CMP R2, #0xA
	IT EQ
	LDREQ R0, ptr_to_position_SQ10
	BEQ RGB_Compare

	CMP R2, #0xB
	IT EQ
	LDREQ R0, ptr_to_position_SQ11
	BEQ RGB_Compare

	CMP R2, #0xC
	IT EQ
	LDREQ R0, ptr_to_position_SQ12
	BEQ RGB_Compare

	CMP R2, #0xD
	IT EQ
	LDREQ R0, ptr_to_position_SQ13
	BEQ RGB_Compare

	CMP R2, #0xE
	IT EQ
	LDREQ R0, ptr_to_position_SQ14
	BEQ RGB_Compare

	CMP R2, #0xF
	IT EQ
	LDREQ R0, ptr_to_position_SQ15
	BEQ RGB_Compare


;;;---------------------Determine Number------------------------;;;
;;; Based off the number loaded into R1, generated from the stack pop
;;; determine the block to print corresponding to the R1 value
RGB_Compare:
	CMP R1, #0x2
	BEQ Render2

	CMP R1, #0x4
	BEQ Render4

	CMP R1, #0x8
	BEQ Render8

	CMP R1, #0x10
	BEQ Render16

	CMP R1, #0x20
	BEQ Render32

	CMP R1, #0x40
	BEQ Render64

	CMP R1, #0x80
	BEQ Render128

	CMP R1, #0x100
	BEQ Render256

	CMP R1, #0x200
	BEQ Render512

	CMP R1, #0x400
	BEQ Render1024

	CMP R1, #0x800
	BEQ Render2048

;;;-------Additional functionality-------;;;
	;In case there is a zero (TODO)
	B Render0

;;;---------------------Rendering phase------------------------;;;
;;; Rendering via string and dox value
;;; R0 is the cursor move, while R1 is the block print
Render0:
	BL output_string ;Move Cursor
	LDR R0, ptr_to_block0 ;print the current block
	BL output_string
	ADD R2, R2, #0x1	;Increment the counter
	B RGB_Loop

Render2:
	BL output_string ;Move cursor
	LDR R0, ptr_to_block2 ;print the current block
	BL output_string
	ADD R2, R2, #0x1 ; Increment the counter
	B RGB_Loop

Render4:
	BL output_string ;Move cursor
	LDR R0, ptr_to_block4;print the current block
	BL output_string
	ADD R2, R2, #0x1 ; Increment the counter
	B RGB_Loop
Render8:
	BL output_string ;Move cursor
	LDR R0, ptr_to_block8 ;print the current block
	BL output_string
	ADD R2, R2, #0x1 ; Increment the counter
	B RGB_Loop
Render16:
	BL output_string ;Move cursor
	LDR R0, ptr_to_block16 ;print the current block
	BL output_string
	ADD R2, R2, #0x1 ; Increment the counter
	B RGB_Loop
Render32:
	BL output_string ;Move cursor
	LDR R0, ptr_to_block32 ;print the current block
	BL output_string
	ADD R2, R2, #0x1 ; Increment the counter
	B RGB_Loop
Render64:
	BL output_string ;Move cursor
	LDR R0, ptr_to_block64 ;print the current block
	BL output_string
	ADD R2, R2, #0x1 ; Increment the counter
	B RGB_Loop
Render128:
	BL output_string ;Move cursor
	LDR R0, ptr_to_block128 ;print the current block
	BL output_string
	ADD R2, R2, #0x1 ; Increment the counter
	B RGB_Loop
Render256:
	BL output_string ;Move cursor
	LDR R0, ptr_to_block256 ;print the current block
	BL output_string
	ADD R2, R2, #0x1 ; Increment the counter
	B RGB_Loop
Render512:
	BL output_string ;Move cursor
	LDR R0, ptr_to_block512 ;print the current block
	BL output_string
	ADD R2, R2, #0x1 ; Increment the counter
	B RGB_Loop
Render1024:
	BL output_string ;Move cursor
	LDR R0, ptr_to_block1024 ;print the current block
	BL output_string
	ADD R2, R2, #0x1 ; Increment the counter
	B RGB_Loop
Render2048:
	BL output_string ;Move cursor
	LDR R0, ptr_to_block2048 ;print the current block
	BL output_string
	ADD R2, R2, #0x1 ; Increment the counter
	B RGB_Loop

;;;---------------------End Render------------------------;;;
;;; Only be accessed when R2 = #0x10
RGB_end:
	POP {r0-r11, lr}
	MOV pc, lr


.end
