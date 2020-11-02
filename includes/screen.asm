; AL: Character
; BL: Color
printchar:
	pusha
	cmp al, 13
	je .carriage_return
	
	cmp al, 10
	je .line_feed
	
	; Print character
	mov ah, 09h
	mov bh, 0
	mov cx, 1
	int 10h

	popa
	ret
	
	.carriage_return:
		; Get cursor position
		mov ah, 03h
		mov bh, 0
		int 10h
		
		; Set cursor position to column 0
		mov dl, 0
		mov ah, 02h
		popa
		ret
	
	.line_feed:
		mov ah, 03h
		mov bh, 0
		int 10h
		cmp dh, 25
		je .line_feed_scroll
		
	.line_feed_continue:
		inc dh
		mov ah, 02h
		int 10h
		popa
		ret
		
	.line_feed_scroll:
		pusha
		mov ah, 06h
		mov al, 1
		mov bl, 07h
		mov ch, 0
		mov cl, 0
		mov dh, 25
		mov dl, 80
		int 10h
		popa
		jmp .line_feed_continue
