Function TCPIPdemo
String reply$

Print "Opening port as server..."
OpenNet #201 As Server

Print "waiting for NET..."
WaitNet #201

Do
Print "Sending data to host 2"
Print #201, "Data from host 1"
Input #201, reply$
Print "Received reply: ", reply$
Loop
Fend
