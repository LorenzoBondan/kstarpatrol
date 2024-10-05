.model small

.stack 200H   ; define uma pilha de 512 bytes (200H)

.data

    ; Controles (Scan code)
    ; (codigos para utilizar com a int 16h 00h)
    ; Scan code table: https://www.win.tue.nl/~aeb/linux/kbd/scancodes-1.html
    upArrow equ 48h
    downArrow equ 50h
    accept equ 1Ch ; ENTER (enter is a reserved word)
    
    ; Codigos ASCII
    CR equ 13
    LF equ 10
    
    jogar db "JOGAR"
    sair db "SAIR"
    selectedOption db "[] "
    
    ;Sprites (n?o ser?o usados nesse trabalho)
    ;spaceshipSprite db 0,0,0Fh,0Fh,0Fh,0Fh,0Fh,0,0,0,0,0Fh,3,3,3,0,0,0,0,0,0Fh,3,3,0Fh,0,0,0,0,0,0,3,3,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0,0,3,0Fh,0Fh,0Fh,0Fh,1,1,0Fh,0Fh,0Fh,3,0Fh,0Fh,0Fh,0Fh,1,1,0Fh,0Fh,0Fh,3,3,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0,0,0Fh,3,3,0Fh,0,0,0,0,0,0,0,0Fh,3,3,3,0,0,0,0,0,0,0,0Fh,0Fh,0Fh,0Fh,0Fh,0,0,0    
    ;asteroidSprite db 0,0,7,7,7,7,7,7,0,0,0,7,7,8,8,8,7,7,7,0,7,7,8,8,8,8,7,7,7,7,7,8,8,8,8,7,7,7,8,7,7,8,8,8,7,7,7,8,8,7,7,8,8,7,7,7,8,8,8,7,7,7,7,7,7,8,8,8,8,7,7,7,7,8,8,8,8,8,7,7,0,7,7,7,8,8,8,7,7,0,0,0,7,7,7,7,7,7,0,0,0
    ;shieldSprite db 0,0,0,1,1,1,1,0,0,0,0,0,1,0Fh,0Fh,0Fh,0Fh,1,0,0,0,1,0Fh,1,1,1,1,0Fh,1,0,1,0Fh,1,1,1,1,1,1,0Fh,1,1,0Fh,3,3,3,3,3,3,0Fh,1,1,0Fh,3,3,3,3,3,3,0Fh,1,1,0Fh,0Fh,3,3,3,3,0Fh,0Fh,1,0,1,0Fh,0Fh,3,3,0Fh,0Fh,1,0,0,0,1,0Fh,0Fh,0Fh,0Fh,1,0,0,0,0,0,1,1,1,1,0,0,0
    ;healthSprite db 0,0,0,2,2,2,2,0,0,0,0,0,2,0Fh,0Fh,0Fh,0Fh,2,0,0,0,2,0Fh,0Fh,2,2,0Fh,0Fh,2,0,2,0Fh,0Fh,0Fh,2,2,0Fh,0Fh,0Fh,2,2,0Fh,2,2,2,2,2,2,0Fh,2,2,0Fh,2,2,2,2,2,2,0Fh,2,2,0Fh,0Fh,0Fh,2,2,0Fh,0Fh,0Fh,2,0,2,0Fh,0Fh,2,2,0Fh,0Fh,2,0,0,0,2,0Fh,0Fh,0Fh,0Fh,2,0,0,0,0,0,2,2,2,2,0,0,0    
             
    ;Locais de inicio de v?deo
    videoMemStart equ 0A000h
    uiRegionStart equ 57600
    uiHealthBarStart equ 59205
    uiTimeBarStart equ 59385
    
    ;UI widths
    healthBarWidth dw 130
    timeBarWidth dw 130
    
    screenWidth equ 320
    screenHeight equ 200
    
    ; Caractere de borda
    cornerTopLeft db 218 ; ?
    cornerTopRight db 191 ; ?
    cornerBottomLeft db 192 ; ?
    cornerBottomRight db 217 ; ?
    horizontalLine db 196 ; ?
    verticalLine db 179 ; ?
    
    ;UI colors
    uiBackgroundColor equ 7 
    uiHealthBarColor equ 4
    uiTimeBarColor equ 11 
    
    ;timer
    timer dw 1300
    timeBarScaleDecrement equ 1
    timeScaleIntervalCX equ 1h
    timeScaleIntervalDX equ 086A0h
    
    gameName db "  _  __   ___ _            ", CR, LF
             db " | |/ /__/ __| |_ __ _ _ _ ", CR, LF
             db " | ' <___\__ \  _/ _` | '_|", CR, LF
             db " |____\  |___/\__\__,_|_|  ", CR, LF
             db " | _ \__ _| |_ _ _ ___| |  ", CR, LF
             db " |  _/ _` |  _| '_/ _ \ |  ", CR, LF
             db " |_| \__,_|\__|_| \___/_|  ", CR, LF
             
.code

;-----------------------------------------------------------------------------------------------;
;                                                                                               ;
;  FUNCOES DE USO GERAL                                                                         ;
;                                                                                               ;
;-----------------------------------------------------------------------------------------------;

; Sem parametros
; Destroi ax
SET_VIDEO_MODE proc
    mov ax, 13h ; 13h (modo de v?deo 320 x 200 ) 320 colunas e 200 linhas, cada pixel 1 byte, total de 64000 bytes
    int 10h         
    ret
endp

; Parametros:
; bp: Rndere?o da mem?ria com texto a ser escrito
; dh: Linha
; dl: Coluna
; cx: Tamanho da string
; bl: Cor do texto
PRINT_TEXT proc
    push es
    push ax
    push bx
    push di
    push si
    push bp

    mov di, sp
      
    mov ax, ds    
    mov es, ax
    
    mov bh, 0
    
    mov ah, 13h
    mov al, 1
    int 10h ; Registers destroyed: AX, SP, BP, SI
    
    mov sp, di
    pop bp
    pop si
    pop di
    pop bx
    pop ax
    pop es
    ret
endp

;-----------------------------------------------------------------------------------------------;
;                                                                                               ;
;  FUNCOES DO MENU INICIAL                                                                      ;
;                                                                                               ;
;-----------------------------------------------------------------------------------------------;

; Sem parametros
PRINT_GAME_NAME proc
    
    push bp
    push dx
    push cx
    push bx

    mov bp, offset gameName ; Text to print
    mov dh, 0 ; Line to print
    mov dl, 0 ; Column to print
    mov cx, 574 ; Size of string printed
    mov bl, 50 ; Color
    
    call PRINT_TEXT
    
    pop bx
    pop cx
    pop dx
    pop bp
    ret
endp

; Sem parametros
PRINT_OPTIONS proc

    push bp
    push dx
    push cx
    push bx
    
    mov bp, offset jogar ; Text to print
    mov dh, 20 ; Line to print
    mov dl, 17 ; Column to print
    mov cx, 5 ; Size of string printed
    mov bl, 15 ; Color
    call PRINT_TEXT

    mov bp, offset sair ; Text to print
    mov dh, 22 ; Line to print
    mov dl, 17 ; Column to print
    mov cx, 4 ; Size of string printed
    mov bl, 15 ; Color
    call PRINT_TEXT
    
    pop bx
    pop cx
    pop dx
    pop bp
    
    ret
endp

; Parametros
; bh: opcao selecionada 
;   zero: Jogar
;   qualquer outra coisa: Sair
PRINT_OPTION_SELECTED proc
    push ax
    push bp
    push dx
    push cx
    push bx
    
    
    ; Determina qual linha esta selecionada
    or bh, bh
    jz PRINT_OPTION_SELECTED_JOGAR
    ; Sair selecionado (Configura a linha)
    mov dh, 22 ; Line to print selected
    mov al, 20 ; Line to print deselected
    jmp PRINT_OPTION_SELECTED_PRINT
    
PRINT_OPTION_SELECTED_JOGAR:
    ; Jogar Selecionado (Configura a linha)
    mov dh, 20 ; Line to print selected
    mov al, 22 ; Line to print deselected   
    
PRINT_OPTION_SELECTED_PRINT:
    ; Printar colchetes
    mov bp, offset selectedOption ; Text to print
    ;mov bp, offset cornerTopLeft ; Text to print
    mov dl, 15 ; Column to print
    mov bl, 15 ; Color
    mov cx, 1 ; Size of string printed
    call PRINT_TEXT
    mov dl, 23 ; Column to print
    inc bp ; Para printar o segundo caracter (])
    call PRINT_TEXT
    
    ; Remover colchetes anteriores
    inc bp ; Para printar o terceiro caracter ( )
    mov dl, 15
    mov dh, al
    call PRINT_TEXT
    mov dl, 23
    call PRINT_TEXT
    
    
    pop bx
    pop cx
    pop dx
    pop bp
    pop ax
    ret
endp

; Sem parametros
; Retorno
; bh 
;   zero: sair
;   um: jogar
; Destroi BX
MENU_INICIAL proc
    ; TODO: salvar contexto
    call PRINT_GAME_NAME  

    ;mov si, offset spaceshipSprite
    ;mov di, 40400
    ;call PRINT_SPRITE

    ;mov si, offset asteroidSprite
    ;add di, 50
    ;call PRINT_SPRITE
    
    ;mov si, offset healthSprite
    ;add di, 50
    ;call PRINT_SPRITE
    
    ;mov si, offset shieldSprite
    ;add di, 50
    ;call PRINT_SPRITE
    
    call PRINT_OPTIONS
    
    xor bh, bh ; Seta opcao para Jogar
    
    MENU_INICIAL_CONTROLE:
    call PRINT_OPTION_SELECTED
    mov ah, 00h   ; Input do teclado (considera as setas)
    int 16h
    
    ; Enter
    cmp ah, accept 
    jz MENU_INICIAL_ACCEPT
    
    ; Seta para cima ou para baixo
    cmp ah, upArrow 
    jz MENU_INICIAL_TOGGLE_OPTION
    cmp ah, downArrow
    jz MENU_INICIAL_TOGGLE_OPTION
    
    ; Qualquer outra tecla
    jmp MENU_INICIAL_CONTROLE
    
    ; Acao das setas
    MENU_INICIAL_TOGGLE_OPTION:
    not bh
    jmp MENU_INICIAL_CONTROLE
    
    ; Acao de aceitar
    MENU_INICIAL_ACCEPT:
    ret
endp

;-----------------------------------------------------------------------------------------------;
;                                                                                               ;
;  FUNCOES DO JOGO                                                                              ;
;                                                                                               ;
;-----------------------------------------------------------------------------------------------;

; Proc para escrever uma barra na UI
; Recebe altura em DX
; Recebe em DI o Endere?o de inicio
; Recebe a largura da barra em CX
; Recebe em AL a cor
PRINT_UI_BAR proc
    push di
    push dx

    LOOP_UI_BAR:
        push cx
        rep stosb
        pop cx
        add di, screenWidth
        sub di, cx
        dec dx
        cmp dx, bx
        jne LOOP_UI_BAR
        
    pop dx
    pop di
    ret
endp

PRINT_UI proc
   
    mov di, uiRegionStart   ; Starting offset in video memory

    ; Fill the row with pixels
    xor bx, bx
    mov dx, 20
    LOOP_UI_BACKGROUND:
        mov al, uiBackgroundColor   ; Set the pixel color
        mov cx, screenWidth         ; Number of pixels in a row
        rep stosb                   ; Repeat the store operation to write pixels
        dec dx
        cmp dx, bx
        jne LOOP_UI_BACKGROUND
    
    mov dx, 10
    mov di, uiHealthBarStart
    mov al, uiHealthBarColor
    mov cx, healthBarWidth
 
    call PRINT_UI_BAR
        
    mov dx, 10
    mov di, uiTimeBarStart
    mov al, uiTimeBarColor
    mov cx, timeBarWidth
    
    call PRINT_UI_BAR

    ret
endp

;Bloqueia a execu??o do programa na quantidade definida
;na constante timeScaleInterval
BLOCK_GAME_EXECUTION proc
    push cx

    push dx
    
    mov ah, 86h
    mov cx, timeScaleIntervalCX
    mov dx, timeScaleIntervalDX
    int 15h
    
    pop dx
    pop cx
    ret
endp

GAME_TIMER proc
    push ax
    push dx
    push cx
    
    mov ax, timer
    sub ax, timeBarScaleDecrement
    mov timer, ax

    xor dx, dx  ; Clear DX
    mov cx, 10  ; Divisor
    div cx      ; Divide AX by 10, result in AX, remainder in DX

    mov timeBarWidth, ax
    
    ; Clear the remaining time bar space with the background color
    mov dx, 10
    mov di, uiTimeBarStart
    mov al, uiBackgroundColor
    mov cx, 130  ; Use the constant for the width
    call PRINT_UI_BAR
    
    mov dx, 10
    mov di, uiTimeBarStart
    mov al, uiTimeBarColor
    mov cx, timeBarWidth  ; Use the constant for the width
    call PRINT_UI_BAR

    cmp cx, 0
    jne SKIP_END_CONDITION
    MOV SI, 1
    
    
    SKIP_END_CONDITION:
        pop cx
        pop dx
        pop ax
    ret
endp

;Recebe sprite em SI
;DI recebe a posi??o do primeiro pixel do sprite
PRINT_SPRITE proc
        push dx
        push cx
        push di
        push si

        mov dx, 10
        PRINT_SPRITE_LOOP:
            mov cx, 10
            rep movsb 
            dec dx
            add di, 310
            cmp dx, 0
            jnz PRINT_SPRITE_LOOP
         
        pop si
        pop di
        pop cx
        pop dx
    ret
endp

MAIN_GAME_LOOP proc
    
    xor SI, SI
    MAIN_LOOP:
    
        call GAME_TIMER
        call BLOCK_GAME_EXECUTION
    
        cmp SI, 1
        jne MAIN_LOOP
    ret
endp
    
    
INICIO:

    mov ax, @data
    mov ds, ax
    mov ax, videoMemStart
    mov es, ax
    
    call SET_VIDEO_MODE

    call MENU_INICIAL
    
    or bh, bh ; Verifica opcao selecionada (se deve sair do jogo)
    jnz SAIR_JOGO
    
    ; Jogo
    call PRINT_UI
    call MAIN_GAME_LOOP

    SAIR_JOGO:
    mov ax, 4Ch     ; Function to terminate the program
    int 21h         ; Execute
    
end INICIO