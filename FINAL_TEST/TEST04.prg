'變數們
Double TokenHeight 			'圓形厚度
Double BlockHeight 			'方形厚度

Integer Tokens 				'圓形數量
Integer Blocks 				'方形數量
Integer TokenID 			'圓形數量，用在FOR迴圈
Integer BlockID 			'方形數量，用在FOR迴圈

Integer Counters	 		'紀錄疊高次數
Integer Counter_Up  		'累加疊高次數
Integer CounterID  			'疊高次數，用在FOR迴圈
Integer Counter_mode3 		'紀錄按壓次數(疊高數量)，交換形狀後每次都歸0
Integer Counter_mode3_up	'在mode3模式中不斷累加紀錄

'確保在Do迴圈中只會執行一次
Integer Counter_task1
Integer Counter_task2
Integer Counter_task3
Integer Counter_task1ID
Integer Counter_task2ID
Integer Counter_task3ID

Integer InTokenCounter '用於判斷是否要跳出mode3選擇物件數量的模式

Function test04 '主程式
'基本手臂參數設定	
Motor On
Power High
Speed 100
Accel 100, 100
SpeedS 500
AccelS 2500
Tool 14
'物件高度參數設定
TokenHeight = 6.0
BlockHeight = 6.0

'初始位置安全點
Go Retract_Safe
'迴圈確保I/O可以不斷被讀取
	Do
		'MODE0 待機模式 按鈕狀態(00000)
		If Sw(0) = Off And Sw(1) = Off And Sw(2) = Off And Sw(3) = Off Then
			'Print " MODE0 "
			Counter_task1 = 0
			Counter_task2 = 0
			Counter_task3 = 0
	
		'MODE1 執行TASK1按鈕狀態(10000)
		ElseIf Sw(0) = On And Sw(1) = Off And Sw(2) = Off And Sw(3) = Off Then
			Print " MODE1 "
			For Counter_task1ID = Counter_task1 To 0 Step -1
				Counter_task1 = Counter_task1 - 1
				task1()
			Next Counter_task1ID
	
		'MODE2執行TASK2按鈕狀態(01000)
		ElseIf Sw(0) = Off And Sw(1) = On And Sw(2) = Off Then
			Print " MODE2 "
			For Counter_task2ID = Counter_task2 To 0 Step -1
				Counter_task2 = Counter_task2 - 1
				task2()
			Next Counter_task2ID
	
		'MODE3執行TASK3按鈕狀態(00100)
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

Function task1	'取物 對齊 放料
SpeedS 500
AccelS 4500

Tokens = 2
Blocks = 2

Go Retract_Safe
'圓形
For TokenID = Tokens To 0 Step -1
	Pick_Infeed_Token04() 	'圓形取料
	Alignment_Token04()		'圓形對齊
	Place_Tray_Token04()	'圓形放料
Next TokenID
'方形
For BlockID = Blocks To 0 Step -1
	Pick_Infeed_Block04()	'方形取料
	Alignment_Block04()		'方形對齊
	Place_Tray_Block04()	'方形放料
Next BlockID

Go Retract_Safe
	
Fend

Function task2 '疊高
SpeedS 800
AccelS 7000
'物件參數設定
Tokens = 5
Blocks = 5
Counter_Up = 5
Counters = 0

Go Retract_Safe

For CounterID = Counter_Up To 0 Step -1
	Pick_Infeed_Block04_2()	'取方形
	Alignment_Up04_2()		'放下疊高
	Pick_Infeed_Token04_2()	'取圓形
	Alignment_Up04_2()		'放下疊高
	Counter_Up = Counter_Up - 1
	Print "Placing Block in Tray. CounterID = ", CounterID
Next CounterID

Go Retract_Safe

Fend

Function task3	'隨機疊高
SpeedS 800
AccelS 7000
'基本物件參數設定
Tokens = 0
Blocks = 0
Counter_Up = Counter_mode3_up
Counters = 0
Counter_mode3 = 0

InTokenCounter = 0	'判斷是否該跳出Do迴圈
Go Retract_Safe
Do
	If Sw(0) = On Then 'Token按鈕狀態(10100)
		Print " Token"
		Do
			If Sw(3) = On Then 'Counter按鈕狀態(10110)
				Wait .5
				Counter_mode3 = Counter_mode3 + 1
				Print "Counter_mode3 = ", Counter_mode3
			ElseIf Sw(4) = On Then 'start按鈕狀態(10101)
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
	'Block按鈕狀態(01100)**************************************************************	
	ElseIf Sw(1) = On Then
		Print " Block"
		Do
			'Counter按鈕狀態(01110)****************************************************
			If Sw(3) = On Then
				Wait .5
				Counter_mode3 = Counter_mode3 + 1
				Print "Counter_mode3 = ", Counter_mode3
			'start按鈕狀態(01101)******************************************************	
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
'圓形取料******************************************************************************
Function Pick_Infeed_Token04
	'Pick Token from Infeed
	Go Infeed_Token +Z(100) CP 	'去圓形取料點的上方10公分
	On 9 						'氣壓缸推，理齊物料
	Wait .3
	Off 9						'氣壓缸放開
	Print "Picking Token from Infeed. Token ID = ", Tokens
    Go Infeed_Token +Z(60 + (Tokens * TokenHeight)) CP 	'去圓形取料點的上方6公分
    Move Infeed_Token +Z(Tokens * TokenHeight) 			'下去取料
	On 8 '吸嘴開
	Wait .3
    Move Infeed_Token +X(-1) +Z(60 + (Tokens * TokenHeight)) CP
	   '回去圓形取料點的上方6公分，且往後一點，避免物件與旁邊摩擦到
Fend
'方形取料******************************************************************************
Function Pick_Infeed_Block04
	'Pick Block from Infeed
	On 9 		'氣壓缸推，理齊物料
	Wait .3
	Off 9		'氣壓缸放開
	Print "Picking Block from Infeed. Block ID = ", Blocks
    Go Infeed_Block +Z(60 + (Blocks * BlockHeight)) CP 	'去方形取料點的上方6公分
    Move Infeed_Block +Z(Blocks * BlockHeight) 			'下去取料
	On 8  '吸嘴開
	Wait .3
    Move Infeed_Block +X(-1) +Y(1) +Z(60 + (Blocks * BlockHeight)) CP
	   '回去方形取料點的上方6公分，且往後往旁邊一點，避免物件與旁邊摩擦到
Fend
'對齊圓形******************************************************************************
Function Alignment_Token04
	'Alignment Token
	Print "Aligning Token. Token ID = ", Tokens
    Go Align_Token +Z(20) CP 		'去圓形對齊點上方2公分
    Move Align_Token				'放下圓形
	Off 8
    Move Align_Token +X(5) 			'將圓形往前推對齊
    Move Align_Token +X(5) +Z(5) CP '抬高離開一點
    Go Align_Token +Z(5) CP			'回到圓形對齊點上方0.5公分
    Move Align_Token				'到圓形對齊點吸取
	On 8
	Wait .3
    Move Align_Token +Z(20) CP 		'抬高到圓形對齊點上方2公分
Fend

Function Alignment_Block04
	'Alignment Block
	Print "Aligning Block. Block ID = ", Blocks
    Go Align_Block +Z(20) CP		'去方形對齊點上方2公分
    Move Align_Block				'放下方形
	Off 8
    Move Align_Block +Y(-5)			'將方形往左推對齊
	On 10 							'推氣壓缸讓方形對齊
	Wait .3
    Go Align_Block +Z(5) CP			'回到方形對齊點上方0.5公分
    Move Align_Block				'到方形對齊點吸取
	On 8
	Wait .3
	Off 10							'收回氣壓缸讓避免摩擦引響吸取
    Move Align_Block +Z(20) CP		'抬高到方形對齊點上方2公分
    
Fend

Function Place_Tray_Token04	'放置圓形物件
	'Tray Token
	Print "Placing Token in Tray. Tray Position ID = ", Tokens
	Go Tray_Token +X(-1) +X(-30. * Tokens) +Y(-0. * Tokens) +Z(20) CP
	Move Tray_Token +X(-1) +X(-30. * Tokens) +Y(-0. * Tokens)
	Off 8
	Wait .3
	Move Tray_Token +X(-1) +X(-30. * Tokens) +Y(-0. * Tokens) +Z(50) CP
	Tokens = Tokens - 1
Fend

Function Place_Tray_Block04 '放置方形物件
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

Function Alignment_Up04_2 '放置疊高
	'Alignment Up
	Print "Placing Block in Tray.  Counter_Up = ", Counter_Up
	Go Align_Block +Z(BlockHeight * Counters) +Z(20) CP
	Move Align_Block +Z(BlockHeight * Counters) +Z(0.5)
	Off 8
	Wait .2
    Move Align_Block +Z(6 * Counters) +Z(20) CP
	Counters = Counters + 1 '疊高數量+1
Fend


