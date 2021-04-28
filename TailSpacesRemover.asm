; ���i����쪨� �.�., �I-191
; ���I��� 5
; ��������: ��楤�� ������ � ��ࠬ��� ����� sz-�浪�1.
; 			� �쮬� � ��������i�� ���i���� �᫮ 墮�⮢�� �஡i�i�.
;			����i� � ��㣨� �冷�2 �冷�1 ��� 墮�⮢�� �஡i�i�,
;			१���� ஡�� ������� �� ��࠭i.

include \masm32\include\masm32rt.inc

; ���⨯� ��楤��
StdOut proto :DWORD
StdIn proto :DWORD, :DWORD
CutTailSpaces proto :DWORD
CopyStrings proto: DWORD

; ᥪ�i� ����� �ணࠬ�
.data
introString db "Tail Spaces Remover. 2021. Veligorskyi B.O., KI-191.", 0
enterString db "����i�� �冷� (string1): ", 0
noTailString db "�冷� ��� 墮�⮢�� �஡i�i� (string2): ", 0
Crlf db 13, 10, 0
maxLength dd 78
string1 db 60 dup(0)
string2 db 60 dup(0)

; ᥪ�i� ���� �ணࠬ�
.code
start:

invoke StdOut, ADDR introString			; i��ଠ�i� �� ஧஡����
invoke StdOut, ADDR Crlf				; ����i� �� ����� �冷�
invoke StdOut, ADDR enterString			; "����i�� �冷�:"
invoke StdIn, ADDR string1, maxLength	; �������� �浪� �����㢠祬
invoke CutTailSpaces, ADDR string1		; ����祭�� 墮�⮢�� �஡i�i� � �浪�
invoke CopyStrings, ADDR string1		; ���i��� �浪�
invoke StdOut, ADDR noTailString		; "�冷� ��� 墮�⮢�� �஡i�i�:"
inkey ADDR string2
inkey "����i�� ���-�� ������ ��� ��室� � �ணࠬ�"
invoke ExitProcess, 0

; ��楤�� CutTailSpaces - ����祭�� 墮�⮢�� �஡i�i� � ��������� �浪�
CutTailSpaces PROC sz :DWORD
	mov EBX, sz
	mov byte ptr [EBX+EAX], 0	; ���-���� � �i���� string1
	mov ECX, EAX
	; �㪠� ��⠭�i� ���஡i�쭨� ᨬ���
	JCXZ stop
	@@:
		cmp byte ptr [EBX], " "
		jz m1
		mov EDX, EBX 	; � (EDX) ��������� ���� ��⠭�쮣� ���஡i�쭮�� ᨬ����
		m1: inc EBX
	loopne @B
	stop:
	mov byte ptr [EDX+1], 0		; ������ 墮�⮢i �஡i��
	ret
CutTailSpaces endp

; ��楤�� CopyStrings - ���i��� �浪� ��� 墮�⮢�� �஡i�i� (string1) � ����� (string2)
CopyStrings PROC sz :DWORD
	mov EBX, sz
	sub EDX, EBX	; �i��⠭� �?� ���訬 ᨬ����� i ��⠭�i� ���஡i�쭨�
	mov ECX, EDX 	; ��ࠬ��� 横��
	lea EDX, string2
	mov byte ptr [EDX+ECX+1], 0		; ���-���� � �i���� string2
	; ���i�� ᨬ���� �i string1 � string2
	@@:
		mov AH, [EBX+ECX]
		mov byte ptr [EDX+ECX], AH
		cmp ECX, 0
		dec ECX
		jnl @B
	ret
CopyStrings endp

end start