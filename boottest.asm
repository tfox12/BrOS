org 0x7c00

;--------------------------------------------------;
; Set print information
;--------------------------------------------------;
mov ax, 0xb800
mov es, ax
mov ah, 0xff

call clear_screen

mov DWORD [cursor], 0
mov ax, 0x1120
call print_char_to_cursor

jmp $

;--------------------------------------------------;
; print_char_to_location
; IN:   
;   ah -> Forground and Bacground Color
;   al -> ascii character to print
;--------------------------------------------------;    
print_char_to_cursor:

    ; registers used must be stored before hand
    push ax
    push bx
    push cx
    push di

    mov bx, [cursor]                ; load cursor position
    mov cx, ax                      ; save ax

    ; calculate offset to write character
    movzx ax, bh    
    mov dx, 160 
    mul dx
    movzx bx, bl
    shl bx, 1

    ; put the offset into di
    mov di, 0
    add di, ax
    add di, bx

    ; write the character
    mov ax, cx
    stosw

    ; restore register state
    pop di
    pop cx
    pop bx
    pop ax

ret


;--------------------------------------------------;    
; advance_cursor
;   Will either move the cursor to the right 1,
;   or will move the the start of the next line
;--------------------------------------------------;
advance_cursor:

    ; save the state of the used registers
    push ax

    mov ax, [cursor]                ; load the cursor into ax
    cmp al, 79                      ; is the cursor on the 79th col
    je advance_cursor_next_line     ; if so we want to go to the next line
    add al, 1                       ; otherwise we up the column
    jmp advance_cursor_exit

advance_cursor_next_line:
    xor al, al                      ; reset column to 0
    add ah, 1                       ; increment the row

advance_cursor_exit:
    mov [cursor], ax                ; save the position

    ; revert back to previous state
    pop ax

ret

;--------------------------------------------------;    
; clear_screen
; IN:
;   ah -> background color
;--------------------------------------------------;    
clear_screen:
    
    mov ah, [background_color]      ; set the clear color
    mov al, 0x20                    ; the space character
    mov DWORD [cursor], 0            ; set the cursor to 0,0
    mov cx, 2000                    ; we wanna run 2000 times

clear_screen_loop:
    call print_char_to_cursor
    call advance_cursor
    loop clear_screen_loop

ret

;-------------------------------------------------;
; System Variables
;-------------------------------------------------;
cursor dw 0
background_color db 0xff

times 510-($-$$) db 0

db 0x55
db 0xAA
