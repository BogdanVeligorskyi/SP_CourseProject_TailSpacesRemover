include \masm32\include\masm32rt.inc

;прототипи процедур
StdOut proto :DWORD
StdIn proto :DWORD, :DWORD
CutTailSpaces proto :DWORD
CopyStrings proto: DWORD
PreparingProc proto: DWORD

; db (1 Byte) = BYTE
; dw (2 Bytes) = WORD
; dd (4 Bytes) = DWORD

.data ;секцiя даних програми
introString db "Tail Spaces Remover. 2021. Veligorskyi B.O., KI-191.", 0
enterString db "Введiть рядок (string1): ", 0
noTailString db "Рядок бех хвостових пробiлiв (string2): ", 0
zeroByte db "0-байт", 0
Crlf db 13, 10, 0
enteredBytes dd ?
maxLength dd 78
string1 db 60 dup(0)
string2 db 60 dup(0)

.code ;секцiя коду програми
start:

invoke StdOut, ADDR introString			;?нформац?я про розробника
invoke StdOut, ADDR Crlf				;перех?д на новий рядок
invoke StdOut, ADDR enterString			;"Введ?ть рядок:"
invoke StdIn, ADDR string1, maxLength	;введення рядка користувачем
invoke PreparingProc, ADDR string1		;
invoke CutTailSpaces, ADDR string1		;вилучення хвостових проб?л?в з рядка
invoke CopyStrings, ADDR string1		;коп?ювання рядка
invoke StdOut, ADDR noTailString		;"Рядок без хвостових проб?л?в:"
inkey ADDR string2
inkey "Натиснiть будь-яку кнопку для виходу з програми"
invoke ExitProcess, 0

;процедура CutTailSpaces - вилучення хвостових проб?л?в з введеного рядка
CutTailSpaces PROC sz :DWORD
	mov ECX, enteredBytes
	JCXZ stop
	@@:
		cmp byte ptr [EBX], " "
		jz m1
		mov EDX, EBX ;сюди запишеться адреса останнього непроб?льного символу
		m1: inc EBX
	loopne @B
	stop:
	mov byte ptr [EBX+1], 0
	ret
CutTailSpaces endp

;процедура CopyStrings - коп?ювання рядка без хвостових пробiлiв (string1) у новий (string2)
CopyStrings PROC sz :DWORD
	lea EBX, string1
	sub EDX, EBX
	mov ECX, EDX ;параметр циклу
	lea EDX, string2
	JCXZ stop1
	@@:
		dec ECX
		mov AX, [EBX+ECX]
		mov word ptr [EDX+ECX], AX
		cmp ECX, 0
	jnz @B
	stop1:
	ret
CopyStrings endp

PreparingProc PROC sz:DWORD
	lea EBX, string1
	mov byte ptr [EBX+EAX], 13
	mov byte ptr [EBX+EAX+1], 10
	mov byte ptr [EBX+EAX+2], 0
	mov enteredBytes, EAX
	ret
PreparingProc endp

end start