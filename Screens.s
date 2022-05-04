;;;----------------------------------------------------------------;;;
;;;------------------COLOR MAP/BLOCK DECLARATION-------------------;;;
;;;----------------------------------------------------------------;;;
; block color
; first line of block and its color
; move cursor
; next line of block and its color
; move cursor
; last line of block and its color
;
; +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+
; |     | |     | |     | |     | |     | |     | |     | |     | |     | |     | |     |
; |  2  | |  4  | |  8  | | 16  | | 32  | | 64  | | 128 | | 256 | | 512 | |1024 | |2048 |
; |     | |     | |     | |     | |     | |     | |     | |     | |     | |     | |     |
; +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+ +-----+

	.data
	.global start_menu
	.global pause_menu
	.global win_block_menu
	.global clear_screen
	.global WIN_end
	.global LOSE_end
	.global TIMESCORE_prompt
	.global time_position
	.global score_position


clear_screen:	.string 27,"[2J",27,"[1;1f", 0

time_position:	.string 27, "[1;23f", 0

score_position:	.string 27, "[1;8f", 0

TIMESCORE_prompt:	.string 27,"[1;1f",27,"[37mSCORE: ",27,"[1;17f",27,"[37mTIME: ",0xA,0xD,0x0

start_menu:	  .string 27,"[2J", 27,"[5;1f", 27,"[45m",27,"[37;1m+==============================+",0xA,0xD
		  							.string 27,"[37;1m+       WELCOME TO 2048        +",0xA,0xD
									.string 27,"[37;1m+                              +",0xA,0xD
									.string 27,"[37;1m+  SW1 - START GAME            +",0xA,0xD
									.string 27,"[37;1m+      - PAUSE GAME            +",0xA,0xD
									.string 27,"[37;1m+                              +",0xA,0xD
									.string 27,"[37;1m+  HOW TO PLAY:                +",0xA,0xD
									.string 27,"[37;1m+  USE W,A,S,D TO SLIDE BLOCKS +",0xA,0xD
									.string 27,"[37;1m+  COMBINE EQUAL BLOCKS        +",0xA,0xD
									.string 27,"[37;1m+                              +",0xA,0xD
									.string 27,"[37;1m+  made by Liam Mullen         +",0xA,0xD
									.string 27,"[37;1m+          Marcos DeLaOsaCruz  +",0xA,0xD
									.string 27,"[37;1m+          CSE379 Spring 2022  +",0xA,0xD
									.string 27,"[37;1m+==============================+",27, "[0m", 0

pause_menu:	   .string 27,"[2J",27,"[5;1f",27,"[45m",27,"[37;1m+==============================+", 0xA,0xD
									.string	27,"[37;1m+         GAME PAUSED          +", 0xA,0xD
									.string	27,"[37;1m+                              +", 0xA,0xD
									.string	27,"[37;1m+  SW2 - QUIT GAME             +", 0xA,0xD
									.string	27,"[37;1m+  SW3 - RESTART GAME          +", 0xA,0xD
									.string	27,"[37;1m+  SW4 - RESUME GAME           +", 0xA,0xD
									.string	27,"[37;1m+  SW5 - CHANGE WIN BLOCK      +", 0xA,0xD
									.string	27,"[37;1m+                              +", 0xA,0xD
									.string	27,"[37;1m+==============================+",27,"[0m",0

win_block_menu: .string 27,"[2J", 27,"[5;1f",27,"[45m",27,"[37;1m+==============================+",0xA,0xD
									.string	27,"[37;1m+       CHANGE WIN BLOCK       +",0xA,0xD
									.string	27,"[37;1m+                              +",0xA,0xD
									.string	27,"[37;1m+  SW1 - RETURN TO PAUSE MENU  +",0xA,0xD
									.string	27,"[37;1m+  SW2 - 2048                  +",0xA,0xD
									.string	27,"[37;1m+  SW3 - 1024                  +",0xA,0xD
									.string	27,"[37;1m+  SW4 - 512                   +",0xA,0xD
									.string	27,"[37;1m+  SW5 - 256                   +",0xA,0xD
									.string	27,"[37;1m+                              +",0xA,0xD
									.string	27,"[37;1m+==============================+",27,"[0m",0

WIN_end: 	   .string 27,"[2J", 27,"[5;1f",27,"[45m",27,"[37;1m+==============================+",0xA,0xD
									.string	27,"[37;1m+    !!!!!!!!!!!!!!!!!!!!!     +",0xA,0xD
									.string	27,"[37;1m+    !!!!!! YOU WON !!!!!!     +",0xA,0xD
									.string	27,"[37;1m+    !!!CONGLATURMATION!!!     +",0xA,0xD
									.string	27,"[37;1m+    !!!!!!!!!!!!!!!!!!!!!     +",0xA,0xD
									.string 27,"[37;1m+                              +",0xA,0xD
									.string	27,"[37;1m+  SW2 - QUIT GAME             +",0xA,0xD
									.string	27,"[37;1m+  SW3 - RESTART GAME          +",0xA,0xD
									.string	27,"[37;1m+                              +",0xA,0xD
									.string	27,"[37;1m+==============================+",27,"[0m",0

LOSE_end: 	   .string 27,"[2J", 27,"[5;1f",27,"[45m",27,"[37;1m+==============================+",0xA,0xD
									.string	27,"[37;1m+    !!!!!!!!!!!!!!!!!!!!!     +",0xA,0xD
									.string	27,"[37;1m+    !!!!!! YOU LOSE !!!!!     +",0xA,0xD
									.string	27,"[37;1m+    !!! WELCOME TO DIE !!     +",0xA,0xD
									.string	27,"[37;1m+    !!!!!!!!!!!!!!!!!!!!!     +",0xA,0xD
									.string	27,"[37;1m+                              +",0xA,0xD
									.string	27,"[37;1m+  SW2 - QUIT GAME             +",0xA,0xD
									.string	27,"[37;1m+  SW3 - RESTART GAME          +",0xA,0xD
									.string	27,"[37;1m+                              +",0xA,0xD
									.string	27,"[37;1m+==============================+",27,"[0m",0

.end
