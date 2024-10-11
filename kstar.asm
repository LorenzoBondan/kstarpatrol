model small

.stack 200H   ; define uma pilha de 512 bytes (200H)

.data

    upArrow equ 48h
    downArrow equ 50h
    accept equ 1Ch ; ENTER
    
    ; Codigos ASCII
    CR equ 13
    LF equ 10
    
    jogar db "JOGAR"
    sair db "SAIR"
    
    screenWidth equ 320
    screenHeight equ 200
    
    ; Caractere de borda
    cornerTopLeft db 218 ; ?
    cornerTopRight db 191 ; ?
    cornerBottomLeft db 192 ; ?
    cornerBottomRight db 217 ; ?
    horizontalLine db 196 ; ?
    verticalLine db 179 ; ?
    
    ; Constantes de Posicoes de memoria 
    memoria_video equ 0A000h
    
    ; Defini??o do desenho da nave
    nave_principal      db 0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0 , 0 , 0 , 0 , 0 , 0  
                        db 0 , 0 ,0Fh,0Fh, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0  
                        db 0 , 0 ,0Fh,0Fh, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0  
                        db 0 , 0 ,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh, 0 , 0 , 0 , 0 , 0 , 0 , 0  
                        db 0 , 0 ,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh
                        db 0 , 0 ,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh, 0 , 0 , 0 , 0 , 0 , 0 , 0  
                        db 0 , 0 ,0Fh,0Fh, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0  
                        db 0 , 0 ,0Fh,0Fh, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0  
                        db 0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh, 0 , 0 , 0 , 0 , 0 , 0

    nave_inimiga        db 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 9 , 9 , 9 , 9 , 9
                        db 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 9 , 9 , 0 , 0 , 0
                        db 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0
                        db 0 , 0 , 0 , 0 , 9 , 9 , 9 , 9 , 9 , 9 , 0 , 0 , 0 , 0 , 0
                        db 9 , 9 , 9 , 9 , 9 , 9 , 9 , 9 , 9 , 9 , 9 , 9 , 9 , 0 , 0
                        db 0 , 0 , 0 , 0 , 9 , 9 , 9 , 9 , 9 , 9 , 0 , 0 , 0 , 0 , 0
                        db 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0
                        db 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 9 , 9 , 0 , 0 , 0
                        db 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 9 , 9 , 9 , 9 , 9

    tiro                db 0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh, 0 , 0 , 0 , 0 , 0 , 0 ,0
                        db 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0
                        db 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0
                        db 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0
                        db 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh
                        db 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0
                        db 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0
                        db 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0
                        db 0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh, 0 , 0 , 0 , 0 , 0 , 0 ,0 

    gameName db "         _  __   ___ _            ", CR, LF
             db "        | |/ /__/ __| |_ __ _ _ _ ", CR, LF
             db "        | ' <___\__ \  _/ _` | '_|", CR, LF
             db "        |____\  |___/\__\__,_|_|  ", CR, LF
             db "        | _ \__ _| |_ _ _ ___| |  ", CR, LF
             db "        |  _/ _` |  _| '_/ _ \ |  ", CR, LF
             db "        |_| \__,_|\__|_| \___/_|  ", CR, LF
             
          
.code

;-----------------------------------------------------------------------------------------------;
;                                                                                               ;
;  FUNCOES DE USO GERAL                                                                         ;
;                                                                                               ;
;-----------------------------------------------------------------------------------------------;

SET_VIDEO_MODE proc
    push ax
    mov ax, 13h ; 13h (modo de v?deo 320 x 200 ) 320 colunas e 200 linhas, cada pixel 1 byte, total de 64000 bytes
    int 10h
    pop ax
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
    int 10h
    
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
    mov dh, 23 ; Line to print
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

    ; Determina qual linha est? selecionada
    or bh, bh
    jz PRINT_OPTION_SELECTED_JOGAR
    
    ; Se n?o for "JOGAR", ? "SAIR"
    ; Sair selecionado (Configura a linha)
    mov dh, 22 ; Linha de "SAIR" selecionada
    mov al, 19 ; Linha de "JOGAR" n?o selecionada
    jmp PRINT_OPTION_SELECTED_PRINT

PRINT_OPTION_SELECTED_JOGAR:
    ; Jogar Selecionado (Configura a linha)
    mov dh, 19 ; Linha de "JOGAR" selecionada
    mov al, 22 ; Linha de "SAIR" n?o selecionada  

PRINT_OPTION_SELECTED_PRINT:
    ; Desenha a caixa de "JOGAR", define a cor dependendo se est? selecionado ou n?o
    or bh, bh
    jz SELECTED_JOGAR
    ; N?o selecionado
    mov bl, 0FH  ; Branco para n?o selecionado
    
    mov dh, 19 ; seta a posi??o linha de jogar
    call DESENHAR_CAIXA
    jmp PRINT_OPTION_SELECTED_CONTINUE

SELECTED_JOGAR:
    mov bl, 0CH  ; Vermelho para selecionado
    mov dh, 19 ; posi??o da linha de jogar
    call DESENHAR_CAIXA

PRINT_OPTION_SELECTED_CONTINUE:

    ; Desenha a caixa de "SAIR", define a cor dependendo se est? selecionado ou n?o
    or bh, bh
    jnz SELECTED_SAIR
    ; "SAIR" n?o est? selecionado
    mov bl, 0FH  ; Branco para n?o selecionado
    mov dh, 22 ; posi??o da linha de sair
    call DESENHAR_CAIXA
    jmp PRINT_OPTION_SELECTED_FINISH

SELECTED_SAIR:
    mov bl, 0CH  ; Vermelho para "SAIR" selecionado
    mov dh, 22 ; posi??o da linha de sair
    call DESENHAR_CAIXA

PRINT_OPTION_SELECTED_FINISH:

    ; Reimprimir o texto dentro da caixa
    ; Verifica qual op??o est? selecionada
    or bh, bh
    jz PRINT_OPTION_JOGAR

    ; "SAIR" est? selecionado
    mov bp, offset sair
    mov dh, 23
    mov dl, 17
    mov cx, 4
    mov bl, 0CH ; Vermelho para "SAIR"
    call PRINT_TEXT

    ; "JOGAR" n?o est? selecionado
    mov bp, offset jogar
    mov dh, 20
    mov dl, 17
    mov cx, 5
    mov bl, 0FH ; Branco para "JOGAR"
    call PRINT_TEXT
    
    dec dh ; adicionei isso aqui
    mov dh, 19 ; posi??o da linha de jogar
    call DESENHAR_CAIXA ; e isso aqui

    jmp PRINT_OPTION_END
    
PRINT_OPTION_JOGAR:

    ; "JOGAR" est? selecionado
    mov bp, offset jogar
    mov dh, 20
    mov dl, 17
    mov cx, 5
    mov bl, 0CH ; Vermelho para "JOGAR"
    call PRINT_TEXT

    ; "SAIR" n?o est? selecionado
    mov bp, offset sair
    mov dh, 23
    mov dl, 17
    mov cx, 4
    mov bl, 0FH ; Branco para "SAIR"
    call PRINT_TEXT

PRINT_OPTION_END:
    pop bx
    pop cx
    pop dx
    pop bp
    pop ax
    ret
endp

DESENHAR_CAIXA proc
    ; Recebe em `dh` a linha onde a caixa deve ser desenhada
    push ax
    push bp
    push cx
    push dx

    ; Printar in?cio da caixa (canto superior esquerdo)
    mov bp, offset cornerTopLeft
    mov dl, 15 ; Coluna inicial
    mov cx, 1
    call PRINT_TEXT

    ; Printar topo da caixa
    mov bp, offset horizontalLine
    mov cx, 1 
    mov dl, 16 
    call PRINT_TEXT
    
    ; Printar topo da caixa
    mov bp, offset horizontalLine
    mov cx, 1 
    mov dl, 17 
    call PRINT_TEXT
    
    ; Printar topo da caixa
    mov bp, offset horizontalLine
    mov cx, 1 
    mov dl, 18 
    call PRINT_TEXT
    
    ; Printar topo da caixa
    mov bp, offset horizontalLine
    mov cx, 1 
    mov dl, 19 
    call PRINT_TEXT
    
    ; Printar topo da caixa
    mov bp, offset horizontalLine
    mov cx, 1 
    mov dl, 20 
    call PRINT_TEXT
    
    ; Printar topo da caixa
    mov bp, offset horizontalLine
    mov cx, 1 
    mov dl, 21 
    call PRINT_TEXT
    
    ; Printar topo da caixa
    mov bp, offset horizontalLine
    mov cx, 1 
    mov dl, 22 
    call PRINT_TEXT

    ; Printar canto superior direito da caixa
    mov bp, offset cornerTopRight
    mov dl, 23 ; Coluna final
    mov cx, 1
    call PRINT_TEXT

    ; Printar laterais da caixa (paredes verticais)
    inc dh  ; Desce para a linha do meio da caixa
    mov bp, offset verticalLine
    mov dl, 15
    call PRINT_TEXT
    mov dl, 23
    call PRINT_TEXT

    ; Desce mais uma linha (base da caixa)
    inc dh
    ; Printar canto inferior esquerdo da caixa
    mov bp, offset cornerBottomLeft
    mov dl, 15
    call PRINT_TEXT

    ; Printar base da caixa
    mov bp, offset horizontalLine
    mov cx, 1
    mov dl, 16
    call PRINT_TEXT
    
    ; Printar base da caixa
    mov bp, offset horizontalLine
    mov cx, 1
    mov dl, 17
    call PRINT_TEXT
    
    ; Printar base da caixa
    mov bp, offset horizontalLine
    mov cx, 1
    mov dl, 18
    call PRINT_TEXT
    
    ; Printar base da caixa
    mov bp, offset horizontalLine
    mov cx, 1
    mov dl, 19
    call PRINT_TEXT
    
    ; Printar base da caixa
    mov bp, offset horizontalLine
    mov cx, 1
    mov dl, 20
    call PRINT_TEXT
    
    ; Printar base da caixa
    mov bp, offset horizontalLine
    mov cx, 1
    mov dl, 21
    call PRINT_TEXT
    
    ; Printar base da caixa
    mov bp, offset horizontalLine
    mov cx, 1
    mov dl, 22
    call PRINT_TEXT

    ; Printar canto inferior direito da caixa
    mov bp, offset cornerBottomRight
    mov dl, 23
    mov cx, 1
    call PRINT_TEXT

    pop dx
    pop cx
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

    
    
    xor bh, bh ; Seta opcao para Jogar inicialmente (0 = JOGAR, 1 = SAIR)
    
MENU_INICIAL_CONTROLE:
    call PRINT_OPTION_SELECTED
    
    mov ah, 0   ; Chama a fun??o de input do teclado (INT 16h)
    int 16h     ; -----> Captura a tecla pressionada (isso aqui t? dando problema, algumas fun??es ex: REMOVE_DESENHO n?o funcionam ap?s isso)

    ; Verifica se a tecla pressionada foi Enter (ASCII)
    cmp ah, accept 
    jz MENU_INICIAL_ACCEPT
    
    ; Verifica as setas (c?digos de scan de teclas especiais)
    cmp ah, upArrow 
    jz MENU_INICIAL_TOGGLE_OPTION
    cmp ah, downArrow
    jz MENU_INICIAL_TOGGLE_OPTION

    ; Continua o loop do menu
    jmp MENU_INICIAL_CONTROLE
    
; Acao das setas
MENU_INICIAL_TOGGLE_OPTION:
    not bh                ; Inverte o valor de bh (0 para 1 ou 1 para 0)
    jmp MENU_INICIAL_CONTROLE
    
; Acao de aceitar (Enter foi pressionado)
MENU_INICIAL_ACCEPT:
    
    ret
endp

; Procedimento para desenhar a nave em uma posi??o passada em DI (di = Y * 320 + X) onde Y: A linha desejada e X: A coluna desejada.
DESENHA_NAVE proc
    ; DI j? deve conter a posi??o ao chamar esta fun??o
    mov si, offset nave_principal   ; Carrega o offset da nave
    call DESENHA_ELEMENTO         ; Chama a fun??o que desenha na posi??o definida
    ret
endp

DESENHA_NAVE_INIMIGA proc
    ; DI j? deve conter a posi??o ao chamar esta fun??o
    mov si, offset nave_inimiga   ; Carrega o offset da nave
    call DESENHA_ELEMENTO         ; Chama a fun??o que desenha na posi??o definida
    ret
endp

; Fun??o para desenhar objetos
; SI: Posi??o do desenho na mem?ria
; DI: Posi??o do primeiro pixel do desenho no v?deo (c?lculo do endere?o de v?deo)
DESENHA_ELEMENTO proc
    push dx
    push cx
    push di
    push si
    
    mov dx, 9                  ; Altura do desenho (9 linhas)
DESENHA_ELEMENTO_LOOP:
    mov cx, 15                  ; Largura do desenho (15 colunas)
    rep movsb                   ; Move 15 bytes de SI para DI (desenha uma linha)
    dec dx                      ; Decrementa o contador de linhas
    add di, 305                 ; Pula para a pr?xima coluna (320 - 15 = 305)
    cmp dx, 0                   ; Verifica se j? desenhou todas as linhas
    jnz DESENHA_ELEMENTO_LOOP   ; Continua at? desenhar todas as linhas
    
    pop si
    pop di
    pop cx
    pop dx
    ret
endp

DESENHA_ELEMENTOS_MENU proc

    call PRINT_GAME_NAME  
    call PRINT_OPTIONS
    
    ; Configurar a posi??o da nave
    mov di, 95*320 + 0       ; Posi??o inicial da nave
    call DESENHA_NAVE            ; Desenha a nave nessa posi??o
    
    mov di, 115*320 + 305
    call DESENHA_NAVE_INIMIGA

    ret
endp

; Funcao para remover um desenho da tela
;DI recebe a posicao do primeiro pixel do desenho
REMOVE_DESENHO proc
    push ax
    push dx
    push cx
    push di
    push si
    
    mov dx, 9
    mov al, 0
REMOVE_DESENHO_LOOP:
    mov cx, 15
    rep stosb
    dec dx
    add di, 305
    cmp dx, 0
    jnz REMOVE_DESENHO_LOOP
    
    pop si
    pop di
    pop cx
    pop dx
    pop ax
    ret
endp

; Funcao para pintar toda a tela de preto (limpar)
LIMPAR_TELA proc
    push ax
    push cx
    push dx
    
    mov di, 0
    mov al, 0
    mov cx, 64000
    rep stosb
    
    pop dx  
    pop cx
    pop ax
    ret
    
endp
    
INICIO:

    mov ax, @data
    mov ds, ax
    mov ax, memoria_video
    mov es, ax
    
    call SET_VIDEO_MODE
    
    call DESENHA_ELEMENTOS_MENU
    call MENU_INICIAL
    
    or bh, bh ; Verifica opcao selecionada (se deve sair do jogo)
    jnz SAIR_JOGO
    
    call LIMPAR_TELA

    SAIR_JOGO:
    mov ah, 4Ch     ; Function to terminate the program
    int 21h         ; Execute
    
end INICIO