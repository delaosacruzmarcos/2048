
	.data

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

block0:		.string 27,"[40m",27,"[37m     ",27,"[1B",27,"[5D     ",27,"[1B", 27,"[5D     ",27,"[0m", 0x0
block2: 	.string 27,"[46m",27,"[37m     ",27,"[1B",27,"[5D",27,"[30m  2  ",27,"[1B", 27,"[5D",27,"[37m     ",27,"[0m", 0x0
block4: 	.string 27,"[45m",27,"[37m     ",27,"[1B",27,"[5D",27,"[37m  4  ",27,"[1B", 27,"[5D",27,"[37m     ",27,"[0m", 0x0
block8: 	.string 27,"[44m",27,"[37m     ",27,"[1B",27,"[5D",27,"[37m  8  ",27,"[1B", 27,"[5D",27,"[37m     ",27,"[0m", 0x0
block16: 	.string 27,"[43m",27,"[37m     ",27,"[1B",27,"[5D",27,"[30m 16  ",27,"[1B", 27,"[5D",27,"[37m     ",27,"[0m", 0x0
block32: 	.string 27,"[42m",27,"[37m     ",27,"[1B",27,"[5D",27,"[30m 32  ",27,"[1B", 27,"[5D",27,"[37m     ",27,"[0m", 0x0
block64: 	.string 27,"[45;1m",27,"[37m     ",27,"[1B",27,"[5D",27,"[37m 64  ",27,"[1B", 27,"[5D",27,"[37m     ",27,"[0m", 0x0
block128: 	.string 27,"[44;1m",27,"[37m     ",27,"[1B",27,"[5D",27,"[37m 128 ",27,"[1B", 27,"[5D",27,"[37m     ",27,"[0m", 0x0
block256: 	.string 27,"[43;1m",27,"[37m     ",27,"[1B",27,"[5D",27,"[37m 256 ",27,"[1B", 27,"[5D",27,"[37m     ",27,"[0m", 0x0
block512:	.string 27,"[42;1m",27,"[37m     ",27,"[1B",27,"[5D",27,"[37m 512 ",27,"[1B", 27,"[5D",27,"[37m     ",27,"[0m", 0x0
block1024: 	.string 27,"[41;1m",27,"[37m     ",27,"[1B",27,"[5D",27,"[37m1024 ",27,"[1B", 27,"[5D",27,"[37m     ",27,"[0m", 0x0
block2048: 	.string 27,"[40;1m",27,"[37m     ",27,"[1B",27,"[5D",27,"[37m2048 ",27,"[1B", 27,"[5D",27,"[37m     ",27,"[0m", 0x0

; size of game board is 4x4 blocks, with each block being 3x5
game_board:	.string 27, "[2;1f","+-----+-----+-----+-----+", 0xA, 0xD
			.string "|     |     |     |     |", 0xA, 0xD
			.string "|     |     |     |     |", 0xA, 0xD
			.string "|     |     |     |     |", 0xA, 0xD
			.string "+-----+-----+-----+-----+", 0xA, 0xD
			.string "|     |     |     |     |", 0xA, 0xD
			.string "|     |     |     |     |", 0xA, 0xD
			.string "|     |     |     |     |", 0xA, 0xD
			.string "+-----+-----+-----+-----+", 0xA, 0xD
			.string "|     |     |     |     |", 0xA, 0xD
			.string "|     |     |     |     |", 0xA, 0xD
			.string "|     |     |     |     |", 0xA, 0xD
			.string "+-----+-----+-----+-----+", 0xA, 0xD
			.string "|     |     |     |     |", 0xA, 0xD
			.string "|     |     |     |     |", 0xA, 0xD
			.string "|     |     |     |     |", 0xA, 0xD
			.string "+-----+-----+-----+-----+", 0x0

;Cursor Movements
position_SQ0:	.string 27, "[3;2f",0
position_SQ1:	.string 27, "[3;8f",0
position_SQ2:	.string 27, "[3;14f",0
position_SQ3:	.string 27, "[3;20f",0

position_SQ4:	.string 27, "[7;2f",0
position_SQ5:	.string 27, "[7;8f",0
position_SQ6:	.string 27, "[7;14f",0
position_SQ7:	.string 27, "[7;20f",0

position_SQ8:	.string 27, "[11;2f",0
position_SQ9:	.string 27, "[11;8f",0
position_SQ10:	.string 27, "[11;14f",0
position_SQ11:	.string 27, "[11;20f",0

position_SQ12:	.string 27, "[15;2f",0
position_SQ13:	.string 27, "[15;8f",0
position_SQ14:	.string 27, "[15;14f",0
position_SQ15:	.string 27, "[15;20f",0


.end
