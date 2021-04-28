; Велiгорський Б.О., КI-191
; ВАРIАНТ 5
; ЗАВДАННЯ: Процедура одержує як параметр адресу sz-рядка1.
; 			У ньому є заздалегiдь невiдоме число хвостових пробiлiв.
;			Скопiювати в другий рядок2 рядок1 без хвостових пробiлiв,
;			результат роботи показати на екранi.

include \masm32\include\masm32rt.inc

; прототипи процедур
StdOut proto :DWORD
StdIn proto :DWORD, :DWORD
CutTailSpaces proto :DWORD
CopyStrings proto: DWORD

; секцiя даних програми
.data
introString db "Tail Spaces Remover. 2021. Veligorskyi B.O., KI-191.", 0
enterString db "Введiть рядок (string1): ", 0
noTailString db "Рядок бех хвостових пробiлiв (string2): ", 0
Crlf db 13, 10, 0
maxLength dd 78
string1 db 60 dup(0)
string2 db 60 dup(0)

; секцiя коду програми
.code
start:

invoke StdOut, ADDR introString			; iнформацiя про розробника
invoke StdOut, ADDR Crlf				; перехiд на новий рядок
invoke StdOut, ADDR enterString			; "Введiть рядок:"
invoke StdIn, ADDR string1, maxLength	; введення рядка користувачем
invoke CutTailSpaces, ADDR string1		; вилучення хвостових пробiлiв з рядка
invoke CopyStrings, ADDR string1		; копiювання рядка
invoke StdOut, ADDR noTailString		; "Рядок без хвостових пробiлiв:"
inkey ADDR string2
inkey "Натиснiть будь-яку кнопку для виходу з програми"
invoke ExitProcess, 0

; процедура CutTailSpaces - вилучення хвостових пробiлiв з введеного рядка
CutTailSpaces PROC sz :DWORD
	mov EBX, sz
	mov byte ptr [EBX+EAX], 0	; нуль-байт у кiнець string1
	mov ECX, EAX
	; шукаємо останнiй непробiльний символ
	JCXZ stop
	@@:
		cmp byte ptr [EBX], " "
		jz m1
		mov EDX, EBX 	; сюди (EDX) запишеться адреса останнього непробiльного символу
		m1: inc EBX
	loopne @B
	stop:
	mov byte ptr [EDX+1], 0		; вилучаємо хвостовi пробiли
	ret
CutTailSpaces endp

; процедура CopyStrings - копiювання рядка без хвостових пробiлiв (string1) у новий (string2)
CopyStrings PROC sz :DWORD
	mov EBX, sz
	sub EDX, EBX	; вiдстань м?ж першим символом i останнiм непробiльним
	mov ECX, EDX 	; параметр циклу
	lea EDX, string2
	mov byte ptr [EDX+ECX+1], 0		; нуль-байт у кiнець string2
	; копiюємо символи зi string1 у string2
	@@:
		mov AH, [EBX+ECX]
		mov byte ptr [EDX+ECX], AH
		cmp ECX, 0
		dec ECX
		jnl @B
	ret
CopyStrings endp

end start