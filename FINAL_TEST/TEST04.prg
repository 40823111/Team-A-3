'�ܼƭ�
Double TokenHeight 			'��Ϋp��
Double BlockHeight 			'��Ϋp��

Integer Tokens 				'��μƶq
Integer Blocks 				'��μƶq
Integer TokenID 			'��μƶq�A�ΦbFOR�j��
Integer BlockID 			'��μƶq�A�ΦbFOR�j��

Integer Counters	 		'�����|������
Integer Counter_Up  		'�֥[�|������
Integer CounterID  			'�|�����ơA�ΦbFOR�j��
Integer Counter_mode3 		'������������(�|���ƶq)�A�洫�Ϊ���C�����k0
Integer Counter_mode3_up	'�bmode3�Ҧ������_�֥[����

'�T�O�bDo�j�餤�u�|����@��
Integer Counter_task1
Integer Counter_task2
Integer Counter_task3
Integer Counter_task1ID
Integer Counter_task2ID
Integer Counter_task3ID

Integer InTokenCounter '�Ω�P�_�O�_�n���Xmode3��ܪ���ƶq���Ҧ�

Function test04 '�D�{��
'�򥻤��u�ѼƳ]�w	
Motor On
Power High
Speed 100
Accel 100, 100
SpeedS 500
AccelS 2500
Tool 14
'���󰪫װѼƳ]�w
TokenHeight = 6.0
BlockHeight = 6.0

'��l��m�w���I
Go Retract_Safe
'�j��T�OI/O�i�H���_�QŪ��
	Do
		'MODE0 �ݾ��Ҧ� ���s���A(00000)
		If Sw(0) = Off And Sw(1) = Off And Sw(2) = Off And Sw(3) = Off Then
			'Print " MODE0 "
			Counter_task1 = 0
			Counter_task2 = 0
			Counter_task3 = 0
	
		'MODE1 ����TASK1���s���A(10000)
		ElseIf Sw(0) = On And Sw(1) = Off And Sw(2) = Off And Sw(3) = Off Then
			Print " MODE1 "
			For Counter_task1ID = Counter_task1 To 0 Step -1
				Counter_task1 = Counter_task1 - 1
				task1()
			Next Counter_task1ID
	
		'MODE2����TASK2���s���A(01000)
		ElseIf Sw(0) = Off And Sw(1) = On And Sw(2) = Off Then
			Print " MODE2 "
			For Counter_task2ID = Counter_task2 To 0 Step -1
				Counter_task2 = Counter_task2 - 1
				task2()
			Next Counter_task2ID
	
		'MODE3����TASK3���s���A(00100)
		ElseIf Sw(2) = On Then
			Print " MODE3 "
			For Counter_task3ID = Counter_task3 To 0 Step -1
				Counter_task3 = Counter_task3 - 1
				Do
					task3()
					If Sw(2) = Off Then
						Exit Do
					EndIf
				Loop
				
			Next Counter_task3ID
		EndIf
	Loop
Fend

Function task1	'���� ��� ���
SpeedS 500
AccelS 4500

Tokens = 2
Blocks = 2

Go Retract_Safe
'���
For TokenID = Tokens To 0 Step -1
	Pick_Infeed_Token04() 	'��Ψ���
	Alignment_Token04()		'��ι��
	Place_Tray_Token04()	'��Ω��
Next TokenID
'���
For BlockID = Blocks To 0 Step -1
	Pick_Infeed_Block04()	'��Ψ���
	Alignment_Block04()		'��ι��
	Place_Tray_Block04()	'��Ω��
Next BlockID

Go Retract_Safe
	
Fend

Function task2 '�|��
SpeedS 800
AccelS 7000
'����ѼƳ]�w
Tokens = 5
Blocks = 5
Counter_Up = 5
Counters = 0

Go Retract_Safe

For CounterID = Counter_Up To 0 Step -1
	Pick_Infeed_Block04_2()	'�����
	Alignment_Up04_2()		'��U�|��
	Pick_Infeed_Token04_2()	'�����
	Alignment_Up04_2()		'��U�|��
	Counter_Up = Counter_Up - 1
	Print "Placing Block in Tray. CounterID = ", CounterID
Next CounterID

Go Retract_Safe

Fend

Function task3	'�H���|��
SpeedS 800
AccelS 7000
'�򥻪���ѼƳ]�w
Tokens = 0
Blocks = 0
Counter_Up = Counter_mode3_up
Counters = 0
Counter_mode3 = 0

InTokenCounter = 0	'�P�_�O�_�Ӹ��XDo�j��
Go Retract_Safe
Do
	If Sw(0) = On Then 'Token���s���A(10100)
		Print " Token"
		Do
			If Sw(3) = On Then 'Counter���s���A(10110)
				Wait .5
				Counter_mode3 = Counter_mode3 + 1
				Print "Counter_mode3 = ", Counter_mode3
			ElseIf Sw(4) = On Then 'start���s���A(10101)
				Tokens = Counter_mode3 - 1
				Counter_Up = Counter_mode3_up + Counter_mode3 - 1
				For CounterID = Counter_Up To 0 Step -1
					Pick_Infeed_Token04_2()
					Alignment_Up04_2()
					Counter_Up = Counter_Up - 1
					Print "Placing Block in Tray. CounterID = ", CounterID
				Next CounterID
				Counter_mode3 = 0
				InTokenCounter = 1
				
			EndIf
			If InTokenCounter = 1 Or Sw(2) = Off Then
				Exit Do
			EndIf
		Loop
	'Block���s���A(01100)**************************************************************	
	ElseIf Sw(1) = On Then
		Print " Block"
		Do
			'Counter���s���A(01110)****************************************************
			If Sw(3) = On Then
				Wait .5
				Counter_mode3 = Counter_mode3 + 1
				Print "Counter_mode3 = ", Counter_mode3
			'start���s���A(01101)******************************************************	
			ElseIf Sw(4) = On Then
				Blocks = Counter_mode3 - 1
				Counter_Up = Counter_mode3_up + Counter_mode3 - 1
				For CounterID = Counter_Up To 0 Step -1
					Pick_Infeed_Block04_2()
					Alignment_Up04_2()
					Counter_Up = Counter_Up - 1
					Print "Placing Block in Tray. CounterID = ", CounterID
				Next CounterID
				Counter_mode3 = 0
				InTokenCounter = 1
			EndIf
			If InTokenCounter = 1 Or Sw(2) = Off Then
				Exit Do
			EndIf
	    Loop
	EndIf
		If Sw(2) = Off Then
			Exit Do
		EndIf
Loop

Go Retract_Safe

Fend
'��Ψ���******************************************************************************
Function Pick_Infeed_Token04
	'Pick Token from Infeed
	Go Infeed_Token +Z(100) CP 	'�h��Ψ����I���W��10����
	On 9 						'���������A�z������
	Wait .3
	Off 9						'��������}
	Print "Picking Token from Infeed. Token ID = ", Tokens
    Go Infeed_Token +Z(60 + (Tokens * TokenHeight)) CP 	'�h��Ψ����I���W��6����
    Move Infeed_Token +Z(Tokens * TokenHeight) 			'�U�h����
	On 8 '�l�L�}
	Wait .3
    Move Infeed_Token +X(-1) +Z(60 + (Tokens * TokenHeight)) CP
	   '�^�h��Ψ����I���W��6�����A�B����@�I�A�קK����P���伯����
Fend
'��Ψ���******************************************************************************
Function Pick_Infeed_Block04
	'Pick Block from Infeed
	On 9 		'���������A�z������
	Wait .3
	Off 9		'��������}
	Print "Picking Block from Infeed. Block ID = ", Blocks
    Go Infeed_Block +Z(60 + (Blocks * BlockHeight)) CP 	'�h��Ψ����I���W��6����
    Move Infeed_Block +Z(Blocks * BlockHeight) 			'�U�h����
	On 8  '�l�L�}
	Wait .3
    Move Infeed_Block +X(-1) +Y(1) +Z(60 + (Blocks * BlockHeight)) CP
	   '�^�h��Ψ����I���W��6�����A�B���᩹����@�I�A�קK����P���伯����
Fend
'������******************************************************************************
Function Alignment_Token04
	'Alignment Token
	Print "Aligning Token. Token ID = ", Tokens
    Go Align_Token +Z(20) CP 		'�h��ι���I�W��2����
    Move Align_Token				'��U���
	Off 8
    Move Align_Token +X(5) 			'�N��Ω��e�����
    Move Align_Token +X(5) +Z(5) CP '�ﰪ���}�@�I
    Go Align_Token +Z(5) CP			'�^���ι���I�W��0.5����
    Move Align_Token				'���ι���I�l��
	On 8
	Wait .3
    Move Align_Token +Z(20) CP 		'�ﰪ���ι���I�W��2����
Fend

Function Alignment_Block04
	'Alignment Block
	Print "Aligning Block. Block ID = ", Blocks
    Go Align_Block +Z(20) CP		'�h��ι���I�W��2����
    Move Align_Block				'��U���
	Off 8
    Move Align_Block +Y(-5)			'�N��Ω��������
	On 10 							'������������ι��
	Wait .3
    Go Align_Block +Z(5) CP			'�^���ι���I�W��0.5����
    Move Align_Block				'���ι���I�l��
	On 8
	Wait .3
	Off 10							'���^���������קK�������T�l��
    Move Align_Block +Z(20) CP		'�ﰪ���ι���I�W��2����
    
Fend

Function Place_Tray_Token04	'��m��Ϊ���
	'Tray Token
	Print "Placing Token in Tray. Tray Position ID = ", Tokens
	Go Tray_Token +X(-1) +X(-30. * Tokens) +Y(-0. * Tokens) +Z(20) CP
	Move Tray_Token +X(-1) +X(-30. * Tokens) +Y(-0. * Tokens)
	Off 8
	Wait .3
	Move Tray_Token +X(-1) +X(-30. * Tokens) +Y(-0. * Tokens) +Z(50) CP
	Tokens = Tokens - 1
Fend

Function Place_Tray_Block04 '��m��Ϊ���
	'Tray Block
	Print "Placing Block in Tray. Block Position ID = ", Blocks
	Go Tray_Block +X(-29.8 * Blocks) +Y(-0. * Blocks) +Z(20) CP
	Move Tray_Block +X(-29.8 * Blocks) +Y(-0. * Blocks) -Z(1) CP
	Off 8
	Wait .3
    Move Tray_Block +X(-29.8 * Blocks) +Y(-0. * Blocks) +Z(50) CP
	Blocks = Blocks - 1
Fend

Function Pick_Infeed_Token04_2
	'Pick Token from Infeed
	Print "Picking Token from Infeed. Token ID = ", Tokens
    Go Infeed_Token +Z(50 + (Tokens * TokenHeight)) CP
    Move Infeed_Token +Z(Tokens * TokenHeight)
	On 8
	Wait .2
    Move Infeed_Token +X(-1) +Z(50 + (Tokens * TokenHeight)) CP
	Tokens = Tokens - 1
Fend

Function Pick_Infeed_Block04_2
	'Pick Block from Infeed
	Print "Picking Block from Infeed. Block ID = ", Blocks
    Go Infeed_Block +Z(50 + (Blocks * BlockHeight)) CP
    Move Infeed_Block +Z(Blocks * BlockHeight)
	On 8
	Wait .2
    Move Infeed_Block +X(-1) +Y(1) +Z(50 + (Blocks * BlockHeight)) CP
	Blocks = Blocks - 1
Fend

Function Alignment_Up04_2 '��m�|��
	'Alignment Up
	Print "Placing Block in Tray.  Counter_Up = ", Counter_Up
	Go Align_Block +Z(BlockHeight * Counters) +Z(20) CP
	Move Align_Block +Z(BlockHeight * Counters) +Z(0.5)
	Off 8
	Wait .2
    Move Align_Block +Z(6 * Counters) +Z(20) CP
	Counters = Counters + 1 '�|���ƶq+1
Fend


