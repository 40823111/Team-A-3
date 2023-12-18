# Team-A-3

 成員介紹
- [x] 許耀中 M11203120<p>
- [x] 林倢顗 M11203601<p>
- [ ] 葉科銓 M11203435<p>
我們完整的程式 [final all programs](https://github.com/40823111/Team-A-3/blob/main/final%20all%20program)


![123](https://github.com/40823111/Team-A-3/blob/main/398933.gif)


## Task 1
這個是我們Task1 的程式碼 [GitHub Pages](https://github.com/40823111/Team-A-3/blob/main/Task%201)).

- [x] 完成了三個令牌和三個區塊按順序從 Feeder 到 Fixture 再到 Tray 的移動
- [x] 反向進行運動，從 Tray 直接到 Feeder。 （跳過夾具單元） 分數
- [x] 總時間（用時最短的隊伍獲勝）

<details>
<summary>Task 1的程式碼</summary>

```
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

```
</details>

## Task 2

這個是我們Task 2 的程式碼 [GitHub Pages](https://github.com/40823111/Team-A-3/blob/main/Task%202)

- [x] 交替堆疊令牌和區塊。 （五個代幣和五個區塊）分數
- [x] 總時間（用時最短的隊伍獲勝）

<details>
<summary>Task 2的程式碼</summary>


```
Integer Tokens
Integer Blocks
Integer Counter_Up
Integer Counters
Double TokenHeight
Double BlockHeight
Function test02

Motor On
Power High
Speed 100
Accel 100, 100
SpeedS 800
AccelS 7000
Tool 14

Tokens = 5
Blocks = 5
Counter_Up = 5
Counters = 0
TokenHeight = 6.0
BlockHeight = 6.0
Integer TokenID
Integer BlockID
Integer CounterID




Go Retract_Safe

For CounterID = Counter_Up To 0 Step -1
    Pick_Infeed_Block02()
    Alignment_Up02()
    Pick_Infeed_Token02()
    Alignment_Up02()
    Counter_Up = Counter_Up - 1
    Print "Placing Block in Tray. CounterID = ", CounterID
Next CounterID

Go Retract_Safe

Fend

Function Pick_Infeed_Token02
    'Pick Token from Infeed
    Print "Picking Token from Infeed. Token ID = ", Tokens
    Go Infeed_Token +Z(50 + (Tokens * TokenHeight)) CP
    Move Infeed_Token +Z(Tokens * TokenHeight)
    On 8
    Wait .2
    Move Infeed_Token +X(-1) +Z(50 + (Tokens * TokenHeight)) CP
    Tokens = Tokens - 1
Fend

Function Pick_Infeed_Block02
    'Pick Block from Infeed
    Print "Picking Block from Infeed. Block ID = ", Blocks
    Go Infeed_Block +Z(50 + (Blocks * BlockHeight)) CP
    Move Infeed_Block +Z(Blocks * BlockHeight)
    On 8
    Wait .2
    Move Infeed_Block +X(-1) +Y(1) +Z(50 + (Blocks * BlockHeight)) CP
    Blocks = Blocks - 1
Fend

Function Alignment_Up02
    'Alignment Up
    Print "Placing Block in Tray.  Counter_Up = ", Counter_Up
    Go Align_Block +Z(6 * Counters) +Z(20) CP
    Move Align_Block +Z(6 * Counters) +Z(0.5)
    Off 8
    Wait .2
    Move Align_Block +Z(6 * Counters) +Z(20) CP
    Counters = Counters + 1
Fend

</details>
```

</details>


## Task 3

這個是我們Task 3 的程式碼 [GitHub Pages](https://github.com/40823111/Team-A-3/blob/main/Task%203)

- [x] 在任務中加入挑戰任務。
- [x] 具有自行設計的夾具
- [x] 附 I/O 盒、HMI

<details>
<summary>Task 3的程式碼</summary>

 
```python
 Text that is a quote
1111111
 <p>11111<p>
 <p>1111<p>
><p>1111111<p>

</details>
```

</details>
