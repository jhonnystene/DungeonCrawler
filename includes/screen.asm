default_color	db 07h

; AL: Character
printchar:
	pusha
	mov bl, [default_color]
	call printchar_color
	popa
	ret

; AL: Character
; BL: Color
printchar_color:
	pusha
	
	; Carriage return?
	cmp al, 13
	je .carriage_return
	
	; Line feed?
	cmp al, 10
	je .line_feed
	
	; Backspace?
	cmp al, 8
	je .backspace
	
	; Print character
	mov ah, 09h
	mov bh, 0
	mov cx, 1
	int 10h
	
	; Get cursor position
	mov ah, 03h
	int 10h
	inc dl
	
	; Do we need to end the line?
	cmp dl, 80
	je .newline

	jmp .finish
	
	.backspace:
		mov ah, 03h
		mov bh, 0
		int 10h
		
		dec dl
		mov ah, 02h
		int 10h
		mov al, ' '
		call printchar
		mov ah, 03h
		mov bh, 0
		int 10h
		
		dec dl
		mov ah, 02h
		int 10h
		popa
		ret
	
	.finish:
		mov ah, 02h
		mov bh, 0
		int 10h
		popa
		ret
	
	.newline:
		mov ah, 03h
		mov bh, 0
		int 10h
		
		mov dl, 0
		inc dh
		cmp dh, 25
		je .scroll
		jmp .finish
	
	.carriage_return:
		; Get cursor position
		mov ah, 03h
		mov bh, 0
		int 10h
		
		; Set cursor position to column 0
		mov dl, 0
		jmp .finish
	
	.line_feed:
		mov ah, 03h
		mov bh, 0
		int 10h
		cmp dh, 25
		je .scroll
		
	.line_feed_continue:
		inc dh
		jmp .finish
		
	.scroll:
		pusha
		mov ah, 06h
		mov al, 1
		mov bl, [default_color]
		mov ch, 0
		mov cl, 0
		mov dh, 25
		mov dl, 80
		int 10h
		popa
		inc dh
		jmp .finish

; SI: String
; BL: Color
printstring_color:
	pusha
	
	.loop:
		lodsb
		cmp al, 0
		je .done
		call printchar_color
		jmp .loop
	
	.done:
		popa
		ret

; SI: String
printstring:
	pusha
	mov bl, [default_color]
	call printstring_color
	popa
	ret

clearscreen:
	pusha
	mov ah, 06h
	mov al, 0
	mov bl, [default_color]
	mov ch, 0
	mov cl, 0
	mov dh, 25
	mov dl, 80
	int 10h
	
	mov ah, 02h
	mov bh, 0
	mov dx, 0
	int 10h
	popa
	ret
	
; Inputs: AL - Byte
print2hex:
	pusha
	push ax
	shr ax, 4
	call .printone
	pop ax
	call .printone
	popa
	ret
	
	.printone:
		pusha
		and ax, 0Fh
		cmp ax, 9
		jle .format
		add ax, 'A'-'9'-1
	
	.format:
		add ax, '0'
		call printchar
		popa
		ret

; Inputs: AX - 2 bytes
print4hex:
	pusha
	mov bx, ax
	mov al, bh
	call print2hex
	mov al, bl
	call print2hex
	popa
	ret
	
newline:
	pusha
	mov al, 13
	call printchar
	mov al, 10
	call printchar
	popa
	ret
