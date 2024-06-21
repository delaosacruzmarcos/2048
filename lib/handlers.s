	.data
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

	; screens
	.global pause_menu
	.global start_menu
	.global win_block_menu
	.global clear_screen
	.global LOSE_end
	.global WIN_end
	.global game_board
	.global TIMESCORE_prompt
	.global SCORE
	.global SCORE_string
	.global TIME
	.global TIME_string
	.global END_status
	.global START_status
	.global PAUSED_status
	.global CHANGE_status

	.global time_position
	.global score_position

	.global WIN_BLOCK

 	.global clear_game

END_status:			.byte 0x00
PAUSED_status:		.byte 0x00
CHANGE_status:		.byte 0x00
START_status:		.byte 0x00


;;-----------------------------------------------------------;;
 	.text

 	.global UART0_Handler			; for keystrokes
 	.global Switch_Handler			; for button/switch press
 	.global Timer_Handler			; for timer

 	.global simple_read_character	; get keystroke w,a,s,d
 	.global read_from_push_btns		; read sw2-5
 	.global read_tiva_push_button	; read sw1
 	.global output_character
 	.global output_string
 	.global illuminate_RGB_LED
 	.global move_left
 	.global move_right
 	.global move_upward
 	.global move_downward
 	.global render_game_board
 	.global spawn_random_block
 	.global int2string

 	; Merge Pointers
	.global merge_A
	.global merge_B
	.global merge_C
	.global merge_D
	.global merge_E
	.global merge_F
	.global merge_G
	.global merge_H


ptr_to_pause_menu:			.word pause_menu
ptr_to_start_menu:			.word start_menu
ptr_to_change_win_menu:		.word win_block_menu
ptr_to_clear_screen:		.word clear_screen
ptr_to_game_board:			.word game_board
ptr_to_win:					.word WIN_end
ptr_to_lose:				.word LOSE_end
ptr_to_end_status:			.word END_status
ptr_to_start_status:		.word START_status
ptr_to_paused_status:		.word PAUSED_status
ptr_to_change_status:		.word CHANGE_status
ptr_to_timescore_prompt:	.word TIMESCORE_prompt

ptr_to_time_position:		.word time_position
ptr_to_score_position:		.word score_position

ptr_to_score:				.word SCORE
ptr_to_score_string:		.word SCORE_string
ptr_to_time:				.word TIME
ptr_to_time_string:			.word TIME_string

; ptr to winning value block
ptr_to_win_block: 	.word WIN_BLOCK


; Receive Interrupt Mask in UART Interrupt Mask Register
RXIM:		.equ 0x10
; Recieve Interrupt Clear in UART Interrupt Clear Register
RXIC:		.equ 0x10

; Interrupt clear register offsets
GPIOICR: 	.equ 0x41C
GPTMICR:	.equ 0x024
UARTICR:	.equ 0x044

; Tiva push button
SW1:		.equ 0x10
SW2:		.equ 0x1
SW3:		.equ 0x2
SW4:		.equ 0x4
SW5:		.equ 0x8

; Control keys
W:			.equ 0x77
A:			.equ 0x61
S:			.equ 0x73
D:			.equ 0x64

; RGB LED Color Encoding
RED:		.equ 0x2
PURPLE:		.equ 0x6
GREEN:		.equ 0x8
YELLOW:		.equ 0xA
CYAN:		.equ 0xC
WHITE:		.equ 0xE

; ptrs to meta data
ptr_to_merge_A:		.word merge_A
ptr_to_merge_B:		.word merge_B
ptr_to_merge_C:		.word merge_C
ptr_to_merge_D:		.word merge_D
ptr_to_merge_E:		.word merge_E
ptr_to_merge_F:		.word merge_F
ptr_to_merge_G:		.word merge_G
ptr_to_merge_H:		.word merge_H

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

;;;------------------------------------------------------------------------------;;;
;;;----------------------------INTERRUPT HANDLERS--------------------------------;;;
;;;------------------------------------------------------------------------------;;;
Switch_Handler:

	PUSH {r0-r11, lr}

	;;;-------------------------------------------------------------;;;
	; Clear the Interrupt via the GPIO Interrupt Clear Register

	; port F
	MOV R0, #0x5000
	MOVT R0, #0x4002

	LDR R1, [R0, #GPIOICR]
	ORR R1, #SW1
	STR R1, [R0, #GPIOICR]

	; port D
	MOV R0, #0x7000
	MOVT R0, #0x4000

	LDR R1, [R0, #GPIOICR]
	ORR R1, #SW2
	ORR R1, #SW3
	ORR R1, #SW4
	ORR R1, #SW5
	STR R1, [R0, #GPIOICR]

	;;;-------------------------------------------------------------;;;
	; check which switch was pressed

	BL read_tiva_push_button
	CMP R0, #0x0
	BEQ SW1_pressed

	BL read_from_push_btns
	CMP R0, #0x8
	BEQ SW2_pressed
	CMP R0, #0x4
	BEQ SW3_pressed
	CMP R0, #0x2
	BEQ SW4_pressed
	CMP R0, #0x1
	BEQ SW5_pressed


;;-------------------------------------------------------------;;
; If playing game, pause the game
; If already paused, this has no effect
; if in change win menu, go back to pause menu
; If game end, this has no effect
SW1_pressed:

	;check if game in end status
	LDR R1, ptr_to_end_status
	LDRB R1, [R1]
	; if game ended, do nothing
	CMP R1, #1
	BEQ switch_end

	;check if game started
	LDR R1, ptr_to_start_status
	LDRB R1, [R1]
	; if game not started, start it
	CMP R1, #0
	BEQ sw1_start

	;check menu status
	LDR R1, ptr_to_paused_status
	LDRB R1, [R1]
	; if not paused, just pause
	CMP R1, #0
	BEQ sw1_pause

	; already paused, check win
	LDR R1, ptr_to_change_status
	LDRB R1, [R1]
	CMP R1, #1
	BEQ sw1_change_win

	; if paused, and not in change win menu, sw1 does nothing
	B switch_end

sw1_start:

	BL clear_game

	LDR R0, ptr_to_clear_screen
	BL output_string
	LDR R0, ptr_to_timescore_prompt
	BL output_string
	LDR R0, ptr_to_game_board
	BL output_string

	; spawn one block
	BL spawn_random_block

	;set started status
	LDR R1, ptr_to_start_status
	MOV R0, #0x1
	STRB R0, [R1]

	; set in game RGB LED
	LDR R1, ptr_to_win_block
	LDR R1, [R1]
	CMP R1, #2048
	IT EQ
	MOVEQ R0, #YELLOW
	CMP R1, #1024
	IT EQ
	MOVEQ R0, #PURPLE
	CMP R1, #512
	IT EQ
	MOVEQ R0, #WHITE
	CMP R1, #256
	IT EQ
	MOVEQ R0, #CYAN

	BL illuminate_RGB_LED

	; enable timer
	MOV R0, #0x0000
	MOVT R0, #0x4003
	LDR R1, [R0, #0xC]
	ORR R1, #0x1
	STR R1, [R0, #0xC]

	; spawn second block after timer has started in order to get new seed
	BL spawn_random_block

	BL render_game_board

	B switch_end

sw1_pause:
	;set pause status
	LDR R1, ptr_to_paused_status
	MOV R0, #0x1
	STRB R0, [R1]

	; disable timer
	MOV R0, #0x0000
	MOVT R0, #0x4003
	LDR R1, [R0, #0xC]
	BIC R1, #0x1
	STR R1, [R0, #0xC]

	; display pause menu
	LDR R0, ptr_to_pause_menu
	BL output_string

	; rgb is off when game is paused
	MOV R0, #0x0
	BL illuminate_RGB_LED
	;;
	B switch_end


sw1_change_win:

	; if in change win val menu, go back to pause menu
	LDR R1, ptr_to_change_status
	MOV R0, #0
	STRB R0, [R1]

	; redisplay pause screen
	B sw1_pause

;;----------------------------------------------------------;;



;;-------------------------------------------------------------;;
; If playing game, do nothing
; If paused, quit/end game
; If change win menu, update win block to 2048
SW2_pressed:

	;check end status
	LDR R1, ptr_to_end_status
	LDRB R1, [R1]
	; if end status, quit game/return to start menu
	CMP R1, #1
	BEQ sw2_quit

	;check started status
	LDR R1, ptr_to_start_status
	LDRB R1, [R1]
	; if not started, do nothing
	CMP R1, #0
	BEQ switch_end

	;check pause status
	LDR R1, ptr_to_paused_status
	LDRB R1, [R1]
	; if not paused, do nothing
	CMP R1, #0
	BEQ switch_end

	; if paused, check win
	LDR R1, ptr_to_change_status
	LDRB R1, [R1]
	; if in change win, update block to 2048
	CMP R1, #1
	BEQ sw2_change_win

	; if paused, and not in change win menu, sw2 quits game
	B sw2_quit


sw2_quit:

	; zero the timer, score, and game board
	BL clear_game

	; clear statuses
	MOV R1, #0
	LDR R0, ptr_to_start_status
	STRB R1, [R0]
	LDR R0, ptr_to_end_status
	STRB R1, [R0]
	LDR R0, ptr_to_paused_status
	STRB R1, [R0]

	; display start menu
	LDR R0, ptr_to_start_menu
	BL output_string

	B switch_end

sw2_change_win:

	; update win block to 2048
	LDR R1, ptr_to_win_block
	MOV R0, #2048
	STRH R0, [R1]

	; exit change win menu
	LDR R1, ptr_to_change_status
	MOV R0, #0
	STRB R0, [R1]

	; redisplay pause menu
	B sw1_pause

;;-------------------------------------------------------------;;



;;-------------------------------------------------------------;;
; If playing game, do nothing
; If paused, restart game
; If change win menu, update win block to 1024
SW3_pressed:

	; check end status
	LDR R1, ptr_to_end_status
	LDRB R1, [R1]
	; if end, restart game
	CMP R1, #1
	BEQ sw3_restart

	;check started status
	LDR R1, ptr_to_start_status
	LDRB R1, [R1]
	; if not started, do nothing
	CMP R1, #0
	BEQ switch_end

	;check pause status
	LDR R1, ptr_to_paused_status
	LDRB R1, [R1]
	; if not paused, do nothing
	CMP R1, #0
	BEQ switch_end

	; if paused, check win
	LDR R1, ptr_to_change_status
	LDRB R1, [R1]

	; if in change win, update block to 1024
	CMP R1, #1
	BEQ sw3_change_win

	; if paused, and not in change win menu, sw3 restarts game
	B sw3_restart


sw3_restart:

	; zero the timer, score, and game board
	BL clear_game

	MOV R1, #0
	LDR R0, ptr_to_end_status
	STRB R1, [R0]
	LDR R0, ptr_to_paused_status
	STRB R1, [R0]

	; display start menu
	B sw1_start


sw3_change_win:

	LDR R1, ptr_to_win_block
	MOV R0, #1024
	STRH R0, [R1]

	; exit change win menu
	LDR R1, ptr_to_change_status
	MOV R0, #0
	STRB R0, [R1]

	; redisplay pause menu
	B sw1_pause

;;-------------------------------------------------------------;;



;;-------------------------------------------------------------;;
; If playing game, do nothing
; If paused, resume game
; If change win menu, update win block to 512
SW4_pressed:

	; check end status
	LDR R1, ptr_to_end_status
	LDRB R1, [R1]
	; if end, do nothing
	CMP R1, #1
	BEQ switch_end

	;check started status
	LDR R1, ptr_to_start_status
	LDRB R1, [R1]
	; if not started, do nothing
	CMP R1, #0
	BEQ switch_end

	;check pause status
	LDR R1, ptr_to_paused_status
	LDRB R1, [R1]
	; if not paused, do nothing
	CMP R1, #0
	BEQ switch_end

	; if paused, check win
	LDR R1, ptr_to_change_status
	LDRB R1, [R1]

	; if in change win, update block to 512
	CMP R1, #1
	BEQ sw4_change_win

	; if paused, and not in change win menu, sw2 quits game
	B sw4_resume

sw4_resume:
	; clear pause menu
	LDR R0, ptr_to_clear_screen
	BL output_string

	; rerender current board,time,score
	LDR R0, ptr_to_timescore_prompt
	BL output_string

	LDR R0, ptr_to_game_board
	BL output_string

	BL render_game_board

	; clear paused flag
	LDR R0, ptr_to_paused_status
	MOV R1, #0
	STRB R1, [R0]

	; set in game RGB LED
	LDR R1, ptr_to_win_block
	LDR R1, [R1]
	CMP R1, #2048
	IT EQ
	MOVEQ R0, #YELLOW
	CMP R1, #1024
	IT EQ
	MOVEQ R0, #PURPLE
	CMP R1, #512
	IT EQ
	MOVEQ R0, #WHITE
	CMP R1, #256
	IT EQ
	MOVEQ R0, #CYAN

	BL illuminate_RGB_LED

	; re-enable timer
	MOV R0, #0x0000
	MOVT R0, #0x4003
	LDR R1, [R0, #0xC]
	ORR R1, #0x1
	STR R1, [R0, #0xC]

	;;
	B switch_end

sw4_change_win:

	; update win block to 512
	LDR R1, ptr_to_win_block
	MOV R0, #512
	STRH R0, [R1]

	; exit change win menu
	LDR R1, ptr_to_change_status
	MOV R0, #0
	STRB R0, [R1]

	; redisplay pause menu
	B sw1_pause
;;-------------------------------------------------------------;;


;;-------------------------------------------------------------;;
; If playing game, do nothing
; If paused, go to change win menu
; If change win menu, update win block to 256
SW5_pressed:

	; check end status
	LDR R1, ptr_to_end_status
	LDRB R1, [R1]
	; if end, do nothing
	CMP R1, #1
	BEQ switch_end


	;check started status
	LDR R1, ptr_to_start_status
	LDRB R1, [R1]
	; if not started, do nothing
	CMP R1, #0
	BEQ switch_end

	;check pause status
	LDR R1, ptr_to_paused_status
	LDRB R1, [R1]
	; if not paused, do nothing
	CMP R1, #0
	BEQ switch_end

	; if paused, check win
	LDR R1, ptr_to_change_status
	LDRB R2, [R1]
	; if in change win, update block to 256
	CMP R2, #1
	BEQ sw5_change_win

	; else, go to change win menu
sw5_change_menu:
	MOV R2, #1
	STRB R2, [R1]

	; display change win menu
	LDR R0, ptr_to_change_win_menu
	BL output_string

	B switch_end

sw5_change_win:

	; update win block to 256
	LDR R1, ptr_to_win_block
	MOV R0, #256
	STRH R0, [R1]

	; exit change win menu
	LDR R1, ptr_to_change_status
	MOV R0, #0
	STRB R0, [R1]

	; redisplay pause menu
	B sw1_pause

;;-------------------------------------------------------------;;
;; endpoint for all 5 switches after handling
switch_end:
	POP {r0-r11, lr}
 	BX lr ; Return
;;;------------------------------------------------------------------------------;;;



;;;------------------------------------------------------------------------------;;;
;;;------------------------------------------------------------------------------;;;
UART0_Handler:
	PUSH {r0-r11, lr}

	; UART data register
	MOV R0, #0xC000
	MOVT R0, #0x4000

 	;Set the bit 4 (RXIC) in the UART Interrupt Clear Register (UARTICR)
	LDR R1, [R0, #UARTICR]
	ORR R1, #RXIC
	STR R1, [R0, #UARTICR]


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GAME STATUS CHECKS ;

	; check end status
	LDR R1, ptr_to_end_status
	LDRB R1, [R1]
	; if end, do nothing
	CMP R1, #1
	BEQ uart_ignore

	;check started status
	LDR R1, ptr_to_start_status
	LDRB R1, [R1]
	; if not started, do nothing
	CMP R1, #0
	BEQ uart_ignore

	;check pause status
	LDR R1, ptr_to_paused_status
	LDRB R1, [R1]
	; if paused, do nothing
	CMP R1, #1
	BEQ uart_ignore

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; BLOCK MOVEMENT ;

	;move accum
	MOV R8, #0
complete_movement_poll:

	; check if accum == 4
	CMP R8, #4
	BEQ clear_merges

render_movement:

	;read keypress
	BL simple_read_character
	CMP R0, #W
	BEQ W_pressed
	CMP R0, #A
	BEQ A_pressed
	CMP R0, #S
	BEQ S_pressed
	CMP R0, #D
	BEQ D_pressed

	B uart_end

W_pressed:
	BL move_upward
	BL render_game_board
	B increment_accumulator

A_pressed:
	BL move_left
	BL render_game_board
	B increment_accumulator

S_pressed:
	BL move_downward
	BL render_game_board
	B increment_accumulator

D_pressed:
	BL move_right
	BL render_game_board
	B increment_accumulator

increment_accumulator:
	ADD R8, #1
	B complete_movement_poll



clear_merges:

	; clear merge pointers
	LDR R0, ptr_to_merge_A
	LDR R1, ptr_to_merge_B
	LDR R2, ptr_to_merge_C
	LDR R3, ptr_to_merge_D
	LDR R4, ptr_to_merge_E
	LDR R5, ptr_to_merge_F
	LDR R6, ptr_to_merge_G
	LDR R7, ptr_to_merge_H

	STMDB SP!, {R0-R7}

	MOV R1, #0
	MOV R2, #1

clear_poll:
	LDMIA SP!, {R0}
	STRB R1, [R0]

	; if iterated all merges
	CMP R2, #8
	IT NE
	ADDNE R2, #1
	BNE clear_poll

	; prep SQs for win check
	LDR R0, ptr_to_SQ0
	LDR R1, ptr_to_SQ1
	LDR R2, ptr_to_SQ2
	LDR R3, ptr_to_SQ3
	STMDB SP!, {R0-R3}

	LDR R0, ptr_to_SQ4
	LDR R1, ptr_to_SQ5
	LDR R2, ptr_to_SQ6
	LDR R3, ptr_to_SQ7
	STMDB SP!, {R0-R3}

	LDR R0, ptr_to_SQ8
	LDR R1, ptr_to_SQ9
	LDR R2, ptr_to_SQ10
	LDR R3, ptr_to_SQ11
	STMDB SP!, {R0-R3}

	LDR R0, ptr_to_SQ12
	LDR R1, ptr_to_SQ13
	LDR R2, ptr_to_SQ14
	LDR R3, ptr_to_SQ15
	STMDB SP!, {R0-R3}

	; incrementer
	MOV R2, #1
	; win block value
	LDR R1, ptr_to_win_block
	LDRH R1, [R1]

	; board fill increment
	MOV R7, #0

check_win_poll:

	; POP value of SQ
	LDMIA SP!, {R0}
	LDR R0, [R0]

	; count how many non-zero blocks
	CMP R0, #0
	IT NE
	ADDNE R7, #1

	; if current SQ = win block
	CMP R0, R1
	BEQ WIN

	; if all blocks are filled, lose
	CMP R7, #16
	BEQ LOSE

	; if iterated all SQs
	CMP R2, #16
	IT NE
	ADDNE R2, #1

	BNE check_win_poll

;;-------------------------------------------------------------;;
;; endpoint for UART after handling
uart_end:

	BL spawn_random_block
	BL render_game_board

uart_ignore:
	POP {r0-r11, lr}
	BX lr



WIN:
	; Display win screen
	LDR R0, ptr_to_win
	BL output_string

	MOV R0, #GREEN
	BL illuminate_RGB_LED

; pop the remaining SQs from the stack
clean_stack:
	CMP R7, #16
	ITTT NE
	LDMIANE SP!, {R0}	; lmao
	ADDNE R7, #1
	BNE clean_stack
	B game_end

LOSE:

	; Display lose screen
	LDR R0, ptr_to_lose
	BL output_string

	MOV R0, #RED
	BL illuminate_RGB_LED

game_end:
	; disable timer
	MOV R0, #0x0000
	MOVT R0, #0x4003
	LDR R1, [R0, #0xC]
	BIC R1, #0x1
	STR R1, [R0, #0xC]

	; set End game status
	MOV R1, #1
	LDR R0, ptr_to_end_status
	STRB R1, [R0]

	; clear in game statuses
	MOV R1, #0
	LDR R0, ptr_to_paused_status
	STRB R1, [R0]
	LDR R0, ptr_to_start_status
	STRB R1, [R0]
	LDR R0, ptr_to_change_status
	STRB R1, [R0]

	POP {r0-r11, lr}
	BX lr

;;;------------------------------------------------------------------------------;;;
Timer_Handler:
	PUSH {r0-r11, lr}

	; set TATOCINT to clear interrupt
	MOV R0, #0x0000
	MOVT R0, #0x4003
	LDR R1, [R0, #GPTMICR]
	ORR R1, #0x1
	STR R1, [R0, #GPTMICR]

	; increment timer
	LDR R0, ptr_to_time
	LDR R1, [R0]
	ADD R1, #1
	STR R1, [R0]

	; re-print time and score at header
	;---;
	LDR R0, ptr_to_score
	LDR R0, [R0]
	LDR R1, ptr_to_score_string

	BL int2string

	LDR R0, ptr_to_score_position
	BL output_string
	LDR R0, ptr_to_score_string
	BL output_string

	;---;
	LDR R0, ptr_to_time
	LDR R0, [R0]
	LDR R1, ptr_to_time_string

	BL int2string

	LDR R0, ptr_to_time_position
	BL output_string
	LDR R0, ptr_to_time_string
	BL output_string

timer_end:
	POP {r0-r11, lr}
 	BX lr ; Return

;;;------------------------------------------------------------------------------;;;
; END OF FILE ;
.end
