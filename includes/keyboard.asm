waitkey:
	pusha
	mov ax, 0
	mov ah, 10h
	int 16h
	
	mov [.buffer], ax
	popa
	mov ax, [.buffer]
	ret
	
	.buffer db 0

; AX: Buffer Length
; BX: Buffer Location
getstring:
	pusha
	mov cx, ax
	mov dx, 0
	
	.loop:
		call waitkey
		
		cmp al, 13
		je .done
		
		cmp al, 8
		je .backspace
		
		call printchar
		mov [bx], ax
		inc bx
		dec cx
		inc dx
		cmp cx, 1
		je .done
		jmp .loop
		
	.backspace:
		cmp dx, 0
		je .loop
	
		dec dx
		dec bx
		mov byte [bx], 0
		inc cx
		mov al, 8
		call printchar
		jmp .loop
		
	.done:
		mov byte [bx], 0
		mov al, 13
		call printchar
		mov al, 10
		call printchar
		popa
		ret
