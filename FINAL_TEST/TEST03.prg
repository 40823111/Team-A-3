Integer Tokens
Integer Blocks
Double TokenHeight
Double BlockHeight
Function test03

Motor On
Power High
Speed 30
Accel 30, 30
SpeedS 500
AccelS 2500
Tool 14

Tokens = 1
Blocks = 1
TokenHeight = 6.0
BlockHeight = 6.0
Integer TokenID
Integer BlockID
Integer Counter
Counter = 0

Go Retract_Safe -X(20)

Do
	Counter = 0
	grab()
	If Sw(0) = On And Sw(1) = Off And Sw(2) = Off Then
		Go Infeed_Token
		grab()
		If Sw(0) = Off Then
			Go Infeed_Token +Z(100) CP
			Go Retract_Safe
			EndIf
	ElseIf Sw(1) = On And Sw(0) = Off And Sw(2) = Off Then
		Go Infeed_Block
		grab()
		If Sw(1) = Off Then
			Go Infeed_Block +Z(100) CP
			Go Retract_Safe
		EndIf
	ElseIf Sw(2) = On And Sw(0) = Off And Sw(1) = Off Then
		For TokenID = Tokens To 0 Step -1
			Go Align_Token +Z(30) CP
			Tokens = Tokens - 1
		Next TokenID
		Go Align_Token
		grab()
		If Sw(2) = Off And Sw(0) = Off And Sw(1) = Off Then
			grab()
			Go Align_Token +Z(20) CP
			Go Retract_Safe
		EndIf
	ElseIf Sw(3) = On And Sw(0) = Off And Sw(1) = Off Then
		For BlockID = Blocks To 0 Step -1
			Go Align_Block +Z(30) CP
			Blocks = Blocks - 1
		Next BlockID
		Go Align_Block
		grab()
		If Sw(3) = Off And Sw(0) = Off And Sw(1) = Off Then
			grab()
			Go Align_Block +Z(20) CP
			Go Retract_Safe
			Blocks = 1
		EndIf
	EndIf
	
Loop

Fend

Function grab
	If Sw(4) = On Then
		On 8
	ElseIf Sw(4) = Off Then
		Off 8
	EndIf
Fend


