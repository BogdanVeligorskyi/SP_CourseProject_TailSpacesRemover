include \masm32\include\masm32rt.inc

;���⨯� ��楤��
StdOut proto :DWORD
StdIn proto :DWORD, :DWORD
CutTailSpaces proto :DWORD
CopyStrings proto: DWORD

; db (1 Byte) = BYTE
; dw (2 Bytes) = WORD
; dd (4 butes) = DWORD

.data ;ᥪ�i� ����� �ணࠬ�
introString db "Tail Spaces Remover. 2021. Veligorskyi B.O., KI-191.", 0
enterString db "����i�� �冷� (string1): ", 0
noTailString db "�冷� ��� 墮�⮢�� �஡i�i� (string2): ", 0
zeroByte db "0-����", 0
Crlf db 13, 10, 0
enteredBytes dd ?
maxLength dd 78
string1 db 60 dup(0)
string2 db 60 dup(0)

.code ;ᥪ�i� ���� �ணࠬ�
start:

invoke StdOut, ADDR introString
invoke StdOut, ADDR Crlf
invoke StdOut, ADDR enterString
invoke StdIn, ADDR string1, maxLength
;invoke StdOut, ADDR zeroByte

lea EBX, string1
mov byte ptr [EBX+EAX], 13
mov byte ptr [EBX+EAX+1], 10
mov byte ptr [EBX+EAX+2], 0
mov enteredBytes, EAX
invoke CutTailSpaces, ADDR string1
invoke CopyStrings, ADDR string1
invoke StdOut, ADDR noTailString
invoke StdOut, ADDR string2
invoke StdOut, ADDR zeroByte
invoke StdOut, ADDR Crlf

inkey "����i�� ������"
invoke ExitProcess, 0

;��楤�� CutTailSpaces - ����祭�� 墮�⮢�� �஡?�?� � ��������� �浪�
CutTailSpaces PROC sz :DWORD
	mov ECX, enteredBytes
	JCXZ stop
	@@:
		cmp byte ptr [EBX], " "
		jz m1
		mov EDX, EBX ;� ��������� ���� ��⠭�쮣� ���஡?�쭮�� ᨬ����
		m1: inc EBX
	loopne @B
	stop:
	mov byte ptr [EBX+1], 0
	ret
CutTailSpaces endp

;��楤�� CopyStrings - ���?��� �浪� ��� 墮�⮢�� �஡?�?� (string1) � ����� (string2)
CopyStrings PROC sz :DWORD
	lea EBX, string1
	sub EDX, EBX
	mov ECX, EDX ;��ࠬ��� 横��
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

end start