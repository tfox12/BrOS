org 0x7c00
;--------------------------------------------------;
; Set print information
;--------------------------------------------------;
mov ax, 0xb800
mov es, ax
mov ah, 0xff

call clear_screen

mov bx, 0
mov ax, 0x1120
call print_char_to_location

jmp $

;--------------------------------------------------;
; print_char_to_location
; IN:   
;   bl -> x_position
;   bh -> y_position
;   ax -> what to print
;--------------------------------------------------;    
print_char_to_location:

    push ax
    push bx

    mov cx, ax

    movzx ax, bh
    mov dx, 160 
    mul dx
    movzx bx, bl
    shl bx, 1

    mov di, 0
    add di, ax
    add di, bx

    mov ax, cx
    stosw

    pop bx
    pop ax

    ret

;--------------------------------------------------;    
; clear_screen
; IN:
;   ah -> background color
;--------------------------------------------------;    
clear_screen:
    
    mov al, 0x20

    mov bh, 0
    y_clear:
        cmp bh, 25
        je y_end

        mov bl, 0
        x_clear:
            cmp bl, 80
            je x_end
            call print_char_to_location
            add bl, 1
            jmp x_clear
        x_end:

        add bh, 1
        jmp y_clear
    y_end:

    ret

times 510-($-$$) db 0

db 0x55
db 0xAA
