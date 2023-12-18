Integer Tokens
Integer Blocks
Double TokenHeight
Double BlockHeight
Function test01

Motor On
Power High
Speed 100
Accel 100, 100
SpeedS 500
AccelS 4500
Tool 14

Tokens = 2
Blocks = 2
TokenHeight = 6.0
BlockHeight = 6.0
Integer TokenID
Integer BlockID


Go Retract_Safe

For TokenID = Tokens To 0 Step -1
	Pick_Infeed_Token01()
	Alignment_Token01()
	Place_Tray_Token01()
Next TokenID

For BlockID = Blocks To 0 Step -1
	Pick_Infeed_Block01()
	Alignment_Block01()
	Place_Tray_Block01()
Next BlockID

Go Retract_Safe

Fend

Function Pick_Infeed_Token01
	'Pick Token from Infeed
	Go Infeed_Token +Z(100) CP
	On 9
	Wait .3
	Off 9
	Print "Picking Token from Infeed. Token ID = ", Tokens
    Go Infeed_Token +Z(60 + (Tokens * TokenHeight)) CP
    Move Infeed_Token +Z(Tokens * TokenHeight)
	On 8
	Wait .3
    Move Infeed_Token +X(-1) +Z(50 + (Tokens * TokenHeight)) CP
	'Tokens = Tokens - 1
Fend

Function Pick_Infeed_Block01
	'Pick Block from Infeed
	On 9
	Wait .3
	Off 9
	Print "Picking Block from Infeed. Block ID = ", Blocks
    Go Infeed_Block +Z(60 + (Blocks * BlockHeight)) CP
    Move Infeed_Block +Z(Blocks * BlockHeight)
	On 8
	Wait .3
    Move Infeed_Block +X(-1) +Y(1) +Z(50 + (Blocks * BlockHeight)) CP
	'Blocks = Blocks - 1
Fend

Function Alignment_Token01
	'Alignment Token
	Print "Aligning Token. Token ID = ", Tokens
    Go Align_Token +Z(20) CP
    Move Align_Token
	Off 8
    Move Align_Token +X(5)
    Move Align_Token +X(5) +Z(5) CP
    Go Align_Token +Z(5) CP
    Move Align_Token
	On 8
	Wait .3
    Move Align_Token +Z(20) CP
Fend

Function Alignment_Block01
	'Alignment Block
	Print "Aligning Block. Block ID = ", Blocks
    Go Align_Block +Z(20) CP
    Move Align_Block
	Off 8
    Move Align_Block +Y(-5)
	On 10
	Wait .5
	Off 10
    Go Align_Block +Z(5) CP
    Move Align_Block
	On 8
	Wait .3
    Move Align_Block +Z(20) CP
Fend

Function Place_Tray_Token01
	'Tray Token
	Print "Placing Token in Tray. Tray Position ID = ", Tokens
	Go Tray_Token +X(-1) +X(-30. * Tokens) +Y(-0. * Tokens) +Z(20) CP
	Move Tray_Token +X(-1) +X(-30. * Tokens) +Y(-0. * Tokens)
	Off 8
	Wait .3
	Move Tray_Token +X(-1) +X(-30. * Tokens) +Y(-0. * Tokens) +Z(50) CP
	Tokens = Tokens - 1
Fend

Function Place_Tray_Block01
	'Tray Block
	Print "Placing Block in Tray. Block Position ID = ", Blocks
	Go Tray_Block +X(-30.3 * Blocks) +Y(-0.2 * Blocks) +Z(20) CP
	Move Tray_Block +X(-30.3 * Blocks) +Y(-0.2 * Blocks)
	Off 8
	Wait .3
    Move Tray_Block +X(-30.3 * Blocks) +Y(-0.2 * Blocks) +Z(50) CP
	Blocks = Blocks - 1
Fend

