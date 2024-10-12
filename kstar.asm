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
    tempo db "TEMPO: "
    score db "SCORE: "
    
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
    posicao_atual_nave dw 0
    
    navePosX dw 0 ; Posi??o X inicial da nave
    navePosY dw 95 ; Posi??o Y inicial da nave
    
    naveInimigaPosX dw 305
    naveInimigaPosY dw 115
    
    nave_atual db 0 ; 0 para a nave aliada, 1 para a nave inimiga
    
    tempo_delay_tela_setor dw 4 ; 4 segundos 
    
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
    
    ; 7 x 36 = 252                   
    gameName db "         _  __   ___ _            ", CR, LF
             db "        | |/ /__/ __| |_ __ _ _ _ ", CR, LF
             db "        | ' <___\__ \  _/ _` | '_|", CR, LF
             db "        |____\  |___/\__\__,_|_|  ", CR, LF
             db "        | _ \__ _| |_ _ _ ___| |  ", CR, LF
             db "        |  _/ _` |  _| '_/ _ \ |  ", CR, LF
             db "        |_| \__,_|\__|_| \___/_|  ", CR, LF
    
    ; 5 x 41 = 205         
    setor_um db "   _____ ________________  ____     ___",CR,LF
             db "  / ___// ____/_  __/ __ \/ __ \   <  /",CR,LF
             db "  \__ \/ __/   / / / / / / /_/ /   / / ",CR,LF
             db " ___/ / /___  / / / /_/ / _, _/   / /  ",CR,LF
             db "/____/_____/ /_/  \____/_/ |_|   /_/   ",CR,LF  
             
    ; 5 x 43 = 215         
    setor_dois db "  _____ ________________  ____     ___  ",CR,LF
               db " / ___// ____/_  __/ __ \/ __ \   |__ \ ",CR,LF
               db " \__ \/ __/   / / / / / / /_/ /   __/ / ",CR,LF
               db "  _/ / /___  / / / /_/ / _, _/   / __/  ",CR,LF
               db "/____/_____//_/  \____/_/ |_|   /____/  ",CR,LF

    ; 5 x 43 = 215         
    setor_tres db "   _____ ________________  ____     _____",CR,LF
               db "  / ___// ____/_  __/ __ \/ __ \   |__  /",CR,LF
               db "  \__ \/ __/   / / / / / / /_/ /    /_ < ",CR,LF
               db " ___/ / /___  / / / /_/ / _, _/   ___/ / ",CR,LF
               db "/____/_____/ /_/  \____/_/ |_|   /____/  ",CR,LF
                                                             
    logo_perdeu db "        __   _____   ___ ___ ",CR,LF
                db "        \ \ / / _ \ / __| __|",CR,LF
                db "         \ V / (_) | (__| _| ",CR,LF
                db "          \_/ \___/ \___|___|",CR,LF
                db "      ___ ___ ___ ___  ___ _   _  _ ",CR,LF
                db "     | _ \ __| _ \   \| __| | | || |",CR,LF
                db "     |  _/ _||   / |) | _|| |_| ||_|",CR,LF
                db "     |_| |___|_|_\___/|___|\___/ (_)",CR,LF

    logo_venceu db "        __   _____   ___ ___ ",CR,LF
                db "        \ \ / / _ \ / __| __|",CR,LF
                db "         \ V / (_) | (__| _| ",CR,LF
                db "          \_/ \___/ \___|___|",CR,LF
                db "    __   _____ _  _  ___ ___ _   _ _",CR,LF
                db "    \ \ / / __| \| |/ __| __| | | | |",CR,LF
                db "     \ V /| _|| .` | (__| _|| |_| |_|",CR,LF
                db "      \_/ |___|_|\_|\___|___|\___/(_)",CR,LF
        
          
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
    mov cx, 252 ; Size of string printed
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

    ; Verifica se uma tecla foi pressionada (INT 16h, fun??o 01h)
    mov ah, 01h   
    int 16h     
    jz CONTINUE_MOVING  ; Se n?o houve tecla, continue o movimento das naves
    
    ; Pega a tecla pressionada (INT 16h, fun??o 00h)
    mov ah, 0
    int 16h
    
    ; Verifica se a tecla pressionada foi Enter (ASCII)
    cmp ah, accept 
    jz MENU_INICIAL_ACCEPT
    
    ; Verifica as setas (c?digos de scan de teclas especiais)
    cmp ah, upArrow 
    jz MENU_INICIAL_TOGGLE_OPTION
    cmp ah, downArrow
    jz MENU_INICIAL_TOGGLE_OPTION

CONTINUE_MOVING:
    
    call MOVIMENTO_GERAL
    
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

MOVIMENTO_GERAL proc
    ; Chama a movimenta??o de acordo com a nave atual
    cmp nave_atual, 0
    je MOVIMENTO_NAVE_ALIADA ; Se for a nave aliada, chama seu movimento

    mov di, 96*320 + 0
    call REMOVE_DESENHO
    call MOVIMENTO_NAVE_INIMIGA ; Caso contr?rio, chama o movimento da nave inimiga

    ; Verifica se a posi??o atual da nave inimiga ? 0
    cmp naveInimigaPosX, 0
    je ZERAR_NAVES ; Se a nave inimiga chegar no 0, vai zerar as posi??es das naves
    
    jmp FIM ; Caso contr?rio, finaliza a execu??o da rotina

ZERAR_NAVES:
    mov navePosX, 0 ; Reseta a posi??o X da nave aliada
    mov navePosY, 95 ; Reseta a posi??o Y da nave aliada
    mov naveInimigaPosX, 305 ; Reseta a posi??o X da nave inimiga
    mov naveInimigaPosY, 115 ; Reseta a posi??o Y da nave inimiga
    
    mov di, 115*320 + 0
    call REMOVE_DESENHO
    
FIM:
    ; Alterna entre as naves
    xor nave_atual, 1 ; Alterna a nave atual entre 0 e 1
    ret
endp


MOVIMENTO_NAVE_ALIADA proc
    push ax
    push bx
    push cx
    push dx

    ; Inicializa as posi??es da nave
    mov ax, navePosX
    mov bx, navePosY

MOVIMENTO_LOOP_ALIADA:
    ; Verifica se a posi??o da nave est? dentro dos limites
    cmp ax, 319 ; Verifica o limite direito (319)
    
    jle MOVE_RIGHT

    ; Se a nave aliada atingir o limite direito
    mov nave_atual, 1 ; Indica que a pr?xima nave a mover ? a inimiga
    jmp FIM_PROC_ALIADA ; Termina a rotina da nave aliada

MOVE_RIGHT:
    ; Remover a nave da posi??o atual antes de incrementar ax
    mov di, bx        ; Posi??o Y
    shl di, 8         ; Desloca para 16 bits
    mov dx, bx        ; Posi??o Y
    shl dx, 6         ; Desloca para 64 bits
    add di, dx        ; Adiciona deslocamento Y
    add di, ax        ; Adiciona a posi??o X
    call REMOVE_DESENHO  ; Remove a nave da posi??o atual

    ; Incrementar ax para mover a nave para a direita
    inc ax

    ; Atualizar a posi??o da nave
    mov navePosX, ax
    mov navePosY, bx
    
    ; Desenhar a nave na nova posi??o
    mov di, bx        ; Posi??o Y
    shl di, 8         ; Desloca para 16 bits
    mov dx, bx        ; Posi??o Y
    shl dx, 6         ; Desloca para 64 bits
    add di, dx        ; Adiciona deslocamento Y
    add di, ax        ; Adiciona a posi??o X
    call DESENHA_NAVE  ; Desenha a nave na nova posi??o

    ; Chamar a rotina de delay
    call DELAY 

FIM_PROC_ALIADA:
    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp


MOVIMENTO_NAVE_INIMIGA proc
    push ax
    push bx
    push cx
    push dx

    ; Inicializa as posi??es da nave
    mov ax, naveInimigaPosX
    mov bx, naveInimigaPosY

MOVIMENTO_LOOP_INIMIGA:
    ; Verifica se a posi??o da nave est? dentro dos limites
    cmp ax, 0     ; Verifica o limite esquerdo (0 - 15 largura da nave)
    
    jge MOVE_LEFT

    ; Se a nave inimiga atingir o limite esquerdo
    mov nave_atual, 0 ; Indica que a pr?xima nave a mover ? a aliada
    jmp FIM_PROC_INIMIGA ; Termina a rotina da nave inimiga

MOVE_LEFT:
    ; Remove a nave da posi??o anterior
    mov di, bx      ; Posi??o Y
    shl di, 8      ; Desloca para a posi??o de 16 bits
    mov dx, bx      ; Posi??o Y
    shl dx, 6      ; Desloca para 64 bits (cada linha tem 320 pixels)
    add di, dx      ; Adiciona o deslocamento da posi??o Y
    add di, ax      ; Adiciona a posi??o X
    call REMOVE_DESENHO ; Remove a nave da posi??o anterior
    
    ; Mover a nave para a esquerda
    dec ax          ; Decrementa a posi??o X da nave

    ; Atualiza as vari?veis de posi??o
    mov naveInimigaPosX, ax
    mov naveInimigaPosY, bx

    ; Desenha a nave na nova posi??o
    mov di, bx      ; Posi??o Y
    shl di, 8      ; Desloca para a posi??o de 16 bits
    mov dx, bx      ; Posi??o Y
    shl dx, 6      ; Desloca para 64 bits (cada linha tem 320 pixels)
    add di, dx      ; Adiciona o deslocamento da posi??o Y
    add di, ax      ; Adiciona a posi??o X
    call DESENHA_NAVE_INIMIGA ; Desenha a nave na nova posi??o

    ; Chama a rotina de delay
    call DELAY

FIM_PROC_INIMIGA: 
    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp


; Rotina de delay
DELAY proc
    mov cx, 0FFFFh   ; Valor para criar o delay
DELAY_LOOP:
    loop DELAY_LOOP  ; Loop para introduzir o delay
    ret
endp


DELAY_TELA_SETOR proc
    push cx
    push dx

    mov cx, 003Dh  ; Parte alta de 4.000.000 microssegundos (4 segundos)
    mov dx, 0900h  ; Parte baixa de 4.000.000 microssegundos (4 segundos)
    
    mov ah, 86h    ; Fun??o de delay do BIOS
    int 15h        ; Chama interrup??o para aguardar o tempo especificado
    
    pop dx
    pop cx
    ret
endp

;-----------------------------------------------------------------------------------------------;
;                                                                                               ;
;  FUNCOES DO JOGO                                                                              ;
;                                                                                               ;
;-----------------------------------------------------------------------------------------------;

PRINT_SETOR_UM proc
    
    push bp
    push dx
    push cx
    push bx

    mov bp, offset setor_um ; Text to print
    mov dh, 9 ; Line to print
    mov dl, 0 ; Column to print
    mov cx, 205 ; Size of string printed
    mov bl, 5 ; Color
    
    call PRINT_TEXT
    
    CALL DELAY_TELA_SETOR
    
    pop bx
    pop cx
    pop dx
    pop bp
    ret
    ret
endp

CHAMAR_SETOR_UM proc

    call LIMPAR_TELA
    call PRINT_SETOR_UM
    CALL LIMPAR_TELA
    
    CALL COMECAR_JOGO
    ret
endp

PRINT_TEMPO_E_SCORE proc
    push bp
    push dx
    push cx
    push bx
    
    mov bp, offset score ; Text to print
    mov dh, 0 ; Line to print
    mov dl, 0 ; Column to print
    mov cx, 7 ; Size of string printed
    mov bl, 15 ; Color
    call PRINT_TEXT

    mov bp, offset tempo ; Text to print
    mov dh, 0 ; Line to print
    mov dl, 70 ; Column to print
    mov cx, 7 ; Size of string printed
    mov bl, 15 ; Color
    call PRINT_TEXT
    
    pop bx
    pop cx
    pop dx
    pop bp
    
    ret
endp

COMECAR_JOGO proc
    
    CALL PRINT_TEMPO_E_SCORE
    
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
    
    call CHAMAR_SETOR_UM

    SAIR_JOGO:
    mov ah, 4Ch     ; Function to terminate the program
    int 21h         ; Execute
    
end INICIO