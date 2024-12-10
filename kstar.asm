model small

.stack 200H ; pilha de 512 bytes (200H)

.data
    upArrow equ 48h
    downArrow equ 50h
    accept equ 1Ch ; enter
    
    ; codigos ASCII
    CR equ 13
    LF equ 10
    
    jogar db "JOGAR"
    sair db "SAIR"
    tempo db "TEMPO: "
    score db "SCORE: "
    
    screenWidth equ 320
    screenHeight equ 200
    
    ; caracteres de borda
    cornerTopLeft db 218
    cornerTopRight db 191
    cornerBottomLeft db 192
    cornerBottomRight db 217
    horizontalLine db 196
    verticalLine db 179
    
    ; constantes de posicoes de memoria 
    memoria_video equ 0A000h
    posicao_atual_nave dw 0
    posicao_central_nave equ 30432 ; nave centralizada (coluna 32 linha 95) 95*320 + 32 = 30432
    
    posicao_atual_tiro dw 0,0
    coluna_atual_tiro dw 52
    contador_tiro dw 100 ; valor inicial do contador do tiro para controlar a velocidade do tiro
    
    navePosX dw 0 ; posicao X inicial da nave
    navePosY dw 95 ; posicao Y inicial da nave
    
    naveInimigaPosX dw 305 ; posicao X inicial da nave inimiga
    naveInimigaPosY dw 115 ; posicao Y inicial da nave inimiga
    
    nave_atual db 0 ; 0 para a nave aliada, 1 para a nave inimiga
    
    tempo_delay_tela_setor dw 4 ; 4 segundos 
    tempo_delay_tela_setor_parte_alta dw 003Dh ; parte alta de 4.000.000 microssegundos (4 segundos)
    tempo_delay_tela_setor_parte_baixa dw 0900h ; parte baixa de 4.000.000 microssegundos (4 segundos)
    tempo_restante dw 60 ; comeca com 60 segundos
    
    score_jogador dw 0
    
    ; para exibir tempo e score
    tempo_str db "00", 0
    score_jogador_str db "", 0
    
    delay_inimigos_setor_um dw 6000 ; 6 segundos -> 60s / 10 inimigos = 1 inimigo a cada 6 s
    contador_movimento_nave_inimiga dw 500  ; controla a frequencia de movimento da nave inimiga
    contador_velocidade_nave_inimiga dw 120 ; inicializa com um valor para ajustar a velocidade da nave
    
    quantidade_vidas dw 9
    setor_atual dw 1 ; setor atual do jogo, inicia no 1
  
    ; desenho da nave
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
    
   nave_principal_2      db 9,9,9,9,9,9,9,9,9,0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,9,9, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,9,9, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,9,9,9,9,9,9, 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,9,9,9,9,9,9,9,9,9,9,9,9,9
                         db 0 , 0 ,9,9,9,9,9,9, 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,9,9, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,9,9, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 9,9,9,9,9,9,9,9,9, 0 , 0 , 0 , 0 , 0 , 0
                         
   nave_principal_3      db 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,0Ah,0Ah, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,0Ah,0Ah, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah, 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
                         db 0 , 0 ,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah, 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,0Ah,0Ah, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,0Ah,0Ah, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah, 0 , 0 , 0 , 0 , 0 , 0
                         
   nave_principal_4      db 0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,0Ch,0Ch, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,0Ch,0Ch, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch, 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch
                         db 0 , 0 ,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch, 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,0Ch,0Ch, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,0Ch,0Ch, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch, 0 , 0 , 0 , 0 , 0 , 0
    
   nave_principal_5      db 0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,0Dh,0Dh, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,0Dh,0Dh, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh, 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh
                         db 0 , 0 ,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh, 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,0Dh,0Dh, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,0Dh,0Dh, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh,0Dh, 0 , 0 , 0 , 0 , 0 , 0                    
    
    nave_principal_6     db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,0Eh,0Eh, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,0Eh,0Eh, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh, 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
                         db 0 , 0 ,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh, 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,0Eh,0Eh, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,0Eh,0Eh, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh, 0 , 0 , 0 , 0 , 0 , 0
     
    nave_principal_7     db 7,7,7,7,7,7,7,7,7,0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,7,7, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,7,7, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,7,7,7,7,7,7, 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,7,7,7,7,7,7,7,7,7,7,7,7,7
                         db 0 , 0 ,7,7,7,7,7,7, 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,7,7, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,7,7, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 7,7,7,7,7,7,7,7,7, 0 , 0 , 0 , 0 , 0 , 0           
    
    nave_principal_8     db 5,5,5,5,5,5,5,5,5,0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,5,5, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,5,5, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,5,5,5,5,5,5, 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,5,5,5,5,5,5,5,5,5,5,5,5,5
                         db 0 , 0 ,5,5,5,5,5,5, 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,5,5, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,5,5, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 5,5,5,5,5,5,5,5,5, 0 , 0 , 0 , 0 , 0 , 0     
                    
    nave_principal_9     db 4,4,4,4,4,4,4,4,4,0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,4,4, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,4,4, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,4,4,4,4,4,4, 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,4,4,4,4,4,4,4,4,4,4,4,4,4
                         db 0 , 0 ,4,4,4,4,4,4, 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,4,4, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 0 , 0 ,4,4, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0  
                         db 4,4,4,4,4,4,4,4,4, 0 , 0 , 0 , 0 , 0 , 0      
                         
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
    
    ; 8 X 30 = 240
    logo_perdeu db "           __   _  _   _ ___  ",CR,LF  
                db "          / _| / \| \_/ | __| ",CR,LF
                db "         ( |_n| o | \_/ | _|  ",CR,LF 
                db "          \__/|_n_|_| |_|___| ",CR,LF
                db "           _  _ _ ___ ___     ",CR,LF
                db "          / \| | | __| o \    ",CR,LF
                db "         ( o ) V | _||   /    ",CR,LF
                db "          \_/ \_/|___|_|\\    ",CR,LF
                                      

    ; 4 x 41 = 164
    logo_venceu db "  ___  _   ___    _   ___ ___ _  _ ___  ",CR,LF
                db " | _ \/_\ | _ \  /_\ | _ ) __| \| / __| ",CR,LF
                db " |  _/ _ \|   / / _ \| _ \ _|| .` \__ \ ",CR,LF
                db " |_|/_/ \_\_|_\/_/ \_\___/___|_|\_|___/ ",CR,LF                                 

        
                ; 14 x 400
                superficie_montanha db 0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0
                db 0,0,0,0,0,6,6,6,0,0,6,6,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,6,6,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,6,6,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,6,6,0,0,0,0,0,6,0,0
                db 0,0,0,0,6,6,6,6,6,6,6,6,6,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,6,6,6,6,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,6,6,6,6,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,6,6,6,6,0,0,0,0,6,0,0
                db 0,0,0,6,6,6,6,6,6,6,6,6,6,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,6,6,0,0,0,0,0,0,0,0,0,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,6,6,6,6,6,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,6,6,0,0,0,0,0,0,0,0,0,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,6,6,6,6,6,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,6,6,0,0,0,0,0,0,0,0,0,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,6,6,6,6,6,0,0,0,0,6,0,0
                db 0,0,0,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,0,0,0,0,0,0,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,0,0,0,0,0,0,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,0,0,0,0,0,0,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,0
                db 0,0,0,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,6,6,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,6,6,6,6,0,0,0,0,0,0,0,0,6,6,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,6,6,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,6,6,6,6,0,0,0,0,0,0,0,0,6,6,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,6,6,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,6,6,6,6,0,0,0,0,0,0,0,0,6,6,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,0
                db 0,0,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,0,0,0,0,0,0,0,6,6,0,0,0,0,0,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,0,0,0,0,0,0,0,6,6,0,0,0,0,0,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0,0,0,0,0,0,0,0,6,6,0,0,0,0,0,0,0,6,6,0,0,0,0,0,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,6
                db 0,0,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,0,0,0,0,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,0,0,0,0,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,0,0,0,0,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,6
                db 0,0,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,0,0,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0,0,0,0,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,0,0,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0,0,0,0,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,0,0,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0,0,0,0,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,6,6,6,6
                db 0,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,0,0,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,0,0,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,0,0,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,6,6,6,6
                db 0,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,0BH,6,6,6,6,6,6,0,0,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,6,6,6,0BH,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,0BH,6,6,6,6,6,6,0,0,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,0BH,6,6,6,6,6,6,0,0,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,6,6,6,6
                db 0,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,6,6,6,6,6,6,6,0,0,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,6,6,6,6,6,6,6,0,0,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,6,6,6,6,6,6,6,0,0,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,6,6,6,6
                db 6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,6,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,6,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,6,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
                db 6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,0BH,0BH,0BH,0BH,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,0BH,0BH,0BH,0BH,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,0BH,0BH,0BH,0BH,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
                db 6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,6,6,0BH,0BH,0BH,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,0BH,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,6,6,0BH,0BH,0BH,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,0BH,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,6,6,0BH,0BH,0BH,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,0BH,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
                db 6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,6,6,6,6,6,0BH,0BH,6,0BH,6,0BH,6,6,6,6,6,0BH,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,6,6,6,6,6,0BH,0BH,6,0BH,6,0BH,6,6,6,6,6,0BH,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,6,6,6,6,6,0BH,0BH,6,0BH,6,0BH,6,6,6,6,6,0BH,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
                db 6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,6,6,6,6,6,6,6,0BH,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,6,6,6,6,6,6,6,0BH,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,6,6,6,6,6,6,6,0BH,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
                db 6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
                db 6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
                db 6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
    
.code

;-----------------------------------------------------------------------------------------------;
;                                                                                               ;
;  FUNCOES DE USO GERAL                                                                         ;
;                                                                                               ;
;-----------------------------------------------------------------------------------------------;

SET_VIDEO_MODE proc
    push ax
    mov ax, 13h ; 13h (modo de video 320 x 200 ) 320 colunas e 200 linhas, cada pixel 1 byte, total de 64000 bytes
    int 10h
    pop ax
    ret
endp

; bp: endereco da memoria com texto a ser escrito
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

PRINT_GAME_NAME proc
    push bp
    push dx
    push cx
    push bx

    mov bp, offset gameName ; texto para printar
    mov dh, 0 ; linha para printar
    mov dl, 0 ; coluna para printar
    mov cx, 252 ; tamanho da string
    mov bl, 50 ; cor
    
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
    
    mov bp, offset jogar ; texto para printar
    mov dh, 20 ; linha para printar
    mov dl, 17 ; coluna para printar
    mov cx, 5 ; tamanho da string
    mov bl, 15 ; cor
    call PRINT_TEXT

    mov bp, offset sair ; texto para printar
    mov dh, 23 ; linha para printar
    mov dl, 17 ; coluna para printar
    mov cx, 4 ; tamanho da string
    mov bl, 15 ; cor
    call PRINT_TEXT
    
    pop bx
    pop cx
    pop dx
    pop bp
    
    ret
endp

; bh: opcao selecionada 
; zero: Jogar
; qualquer outra coisa: Sair
PRINT_OPTION_SELECTED proc
    push ax
    push bp
    push dx
    push cx
    push bx

    ; determina qual linha esta selecionada
    or bh, bh
    jz PRINT_OPTION_SELECTED_JOGAR
    
    ; se nao for "JOGAR", eh "SAIR"
    ; sair selecionado (configura a linha)
    mov dh, 22 ; linha de "SAIR" selecionada
    mov al, 19 ; linha de "JOGAR" nao selecionada
    jmp PRINT_OPTION_SELECTED_PRINT

PRINT_OPTION_SELECTED_JOGAR:
    ; jogar selecionado (configura a linha)
    mov dh, 19 ; linha de "JOGAR" selecionada
    mov al, 22 ; linha de "SAIR" nao selecionada  

PRINT_OPTION_SELECTED_PRINT:
    ; desenha a caixa de "JOGAR", define a cor dependendo se esta selecionado ou nao
    or bh, bh
    jz SELECTED_JOGAR
    ; nao selecionado
    mov bl, 0FH  ; branco para nao selecionado
    
    mov dh, 19 ; seta a posicao linha de jogar
    call DESENHAR_CAIXA
    jmp PRINT_OPTION_SELECTED_CONTINUE

SELECTED_JOGAR:
    mov bl, 0CH  ; vermelho para selecionado
    mov dh, 19 ; posicao da linha de jogar
    call DESENHAR_CAIXA

PRINT_OPTION_SELECTED_CONTINUE:

    ; desenha a caixa de "SAIR", define a cor dependendo se esta selecionado ou nao
    or bh, bh
    jnz SELECTED_SAIR
    ; "SAIR" nao esta selecionado
    mov bl, 0FH  ; branco para nao selecionado
    mov dh, 22 ; posicao da linha de sair
    call DESENHAR_CAIXA
    jmp PRINT_OPTION_SELECTED_FINISH

SELECTED_SAIR:
    mov bl, 0CH  ; vermelho para "SAIR" selecionado
    mov dh, 22 ; posicao da linha de sair
    call DESENHAR_CAIXA

PRINT_OPTION_SELECTED_FINISH:

    ; reimprimir o texto dentro da caixa
    or bh, bh ; verifica qual opcao esta selecionada
    jz PRINT_OPTION_JOGAR

    ; "SAIR" esta selecionado
    mov bp, offset sair
    mov dh, 23
    mov dl, 17
    mov cx, 4
    mov bl, 0CH ; vermelho para "SAIR"
    call PRINT_TEXT

    ; "JOGAR" nao esta selecionado
    mov bp, offset jogar
    mov dh, 20
    mov dl, 17
    mov cx, 5
    mov bl, 0FH ; branco para "JOGAR"
    call PRINT_TEXT
    
    dec dh
    mov dh, 19 ; posicao da linha de jogar
    call DESENHAR_CAIXA

    jmp PRINT_OPTION_END
    
PRINT_OPTION_JOGAR:

    ; "JOGAR" esta selecionado
    mov bp, offset jogar
    mov dh, 20
    mov dl, 17
    mov cx, 5
    mov bl, 0CH ; vermelho para "JOGAR"
    call PRINT_TEXT

    ; "SAIR" nao esta selecionado
    mov bp, offset sair
    mov dh, 23
    mov dl, 17
    mov cx, 4
    mov bl, 0FH ; branco para "SAIR"
    call PRINT_TEXT

PRINT_OPTION_END:
    pop bx
    pop cx
    pop dx
    pop bp
    pop ax
    ret
endp

; recebe em dh a linha onde a caixa deve ser desenhada
DESENHAR_CAIXA proc
    push ax
    push bp
    push cx
    push dx

    ; printar inicio da caixa (canto superior esquerdo)
    mov bp, offset cornerTopLeft
    mov dl, 15 ; Coluna inicial
    mov cx, 1
    call PRINT_TEXT

    ; printar topo da caixa
    mov bp, offset horizontalLine
    mov cx, 1 
    mov dl, 16 
    call PRINT_TEXT
    
    ; printar topo da caixa
    mov bp, offset horizontalLine
    mov cx, 1 
    mov dl, 17 
    call PRINT_TEXT
    
    ; printar topo da caixa
    mov bp, offset horizontalLine
    mov cx, 1 
    mov dl, 18 
    call PRINT_TEXT
    
    ; printar topo da caixa
    mov bp, offset horizontalLine
    mov cx, 1 
    mov dl, 19 
    call PRINT_TEXT
    
    ; printar topo da caixa
    mov bp, offset horizontalLine
    mov cx, 1 
    mov dl, 20 
    call PRINT_TEXT
    
    ; printar topo da caixa
    mov bp, offset horizontalLine
    mov cx, 1 
    mov dl, 21 
    call PRINT_TEXT
    
    ; printar topo da caixa
    mov bp, offset horizontalLine
    mov cx, 1 
    mov dl, 22 
    call PRINT_TEXT

    ; printar canto superior direito da caixa
    mov bp, offset cornerTopRight
    mov dl, 23 ; Coluna final
    mov cx, 1
    call PRINT_TEXT

    ; printar laterais da caixa (paredes verticais)
    inc dh  ; Desce para a linha do meio da caixa
    mov bp, offset verticalLine
    mov dl, 15
    call PRINT_TEXT
    mov dl, 23
    call PRINT_TEXT

    ; Desce mais uma linha (base da caixa)
    inc dh
    ; printar canto inferior esquerdo da caixa
    mov bp, offset cornerBottomLeft
    mov dl, 15
    call PRINT_TEXT

    ; printar base da caixa
    mov bp, offset horizontalLine
    mov cx, 1
    mov dl, 16
    call PRINT_TEXT
    
    ; printar base da caixa
    mov bp, offset horizontalLine
    mov cx, 1
    mov dl, 17
    call PRINT_TEXT
    
    ; printar base da caixa
    mov bp, offset horizontalLine
    mov cx, 1
    mov dl, 18
    call PRINT_TEXT
    
    ; printar base da caixa
    mov bp, offset horizontalLine
    mov cx, 1
    mov dl, 19
    call PRINT_TEXT
    
    ; printar base da caixa
    mov bp, offset horizontalLine
    mov cx, 1
    mov dl, 20
    call PRINT_TEXT
    
    ; printar base da caixa
    mov bp, offset horizontalLine
    mov cx, 1
    mov dl, 21
    call PRINT_TEXT
    
    ; printar base da caixa
    mov bp, offset horizontalLine
    mov cx, 1
    mov dl, 22
    call PRINT_TEXT

    ; printar canto inferior direito da caixa
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

; zero: sair
; um: jogar
MENU_INICIAL proc

    xor bh, bh ; seta opcao para jogar inicialmente (0 = JOGAR, 1 = SAIR)
    
MENU_INICIAL_CONTROLE:
    call PRINT_OPTION_SELECTED

    ; verifica se uma tecla foi pressionada (INT 16h, funcao 01h)
    mov ah, 01h   
    int 16h     
    jz CONTINUE_MOVING  ; se nao houve tecla, continue o movimento das naves
    
    ; pega a tecla pressionada (INT 16h, funcao 00h)
    mov ah, 0
    int 16h
    
    ; verifica se a tecla pressionada foi enter
    cmp ah, accept 
    jz MENU_INICIAL_ACCEPT
    
    ; verifica as setas (codigos de scan de teclas especiais)
    cmp ah, upArrow 
    jz MENU_INICIAL_TOGGLE_OPTION
    cmp ah, downArrow
    jz MENU_INICIAL_TOGGLE_OPTION

CONTINUE_MOVING:
    
    call MOVIMENTO_GERAL
    jmp MENU_INICIAL_CONTROLE ; continua o loop do menu
    
; acao das setas
MENU_INICIAL_TOGGLE_OPTION:
    not bh ; inverte o valor de bh (0 para 1 ou 1 para 0)
    jmp MENU_INICIAL_CONTROLE
    
; acao de aceitar (enter foi pressionado)
MENU_INICIAL_ACCEPT:
    
    ret
endp

; procedimento para desenhar a nave em uma posicao passada em DI (di = Y * 320 + X) onde Y: A linha desejada e X: A coluna desejada.
; DI ja deve conter a posicao ao chamar esta funcao
DESENHA_NAVE proc
    
    mov si, offset nave_principal ; carrega o offset da nave
    call DESENHA_ELEMENTO ; chama a funcao que desenha na posicao definida
    ret
endp

; DI ja deve conter a posicao ao chamar esta funcao
DESENHA_NAVE_INIMIGA proc
    mov si, offset nave_inimiga ; carrega o offset da nave
    call DESENHA_ELEMENTO ; chama a funcao que desenha na posicao definida
    ret
endp

; SI: posicao do desenho na memoria
; DI: posicao do primeiro pixel do desenho no video (calculo do endereco de video)
DESENHA_ELEMENTO proc
    push dx
    push cx
    push di
    push si
    
    mov dx, 9 ; altura do desenho (9 linhas)
DESENHA_ELEMENTO_LOOP:
    mov cx, 15 ; largura do desenho (15 colunas)
    rep movsb ; move 15 bytes de SI para DI (desenha uma linha)
    dec dx ; decrementa o contador de linhas
    add di, 305 ; pula para a proxima coluna (320 - 15 = 305)
    cmp dx, 0 ; verifica se ja desenhou todas as linhas
    jnz DESENHA_ELEMENTO_LOOP ; continua ate desenhar todas as linhas
    
    pop si
    pop di
    pop cx
    pop dx
    ret
endp

DESENHA_ELEMENTOS_MENU proc
    call PRINT_GAME_NAME  
    call PRINT_OPTIONS
    
    ; configurar a posicao da nave
    mov di, 95*320 + 0 ; posicao inicial da nave
    call DESENHA_NAVE ; desenha a nave nessa posicao
    
    mov di, 115*320 + 305
    call DESENHA_NAVE_INIMIGA

    ret
endp

; funcao para remover um desenho da tela
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

; funcao para pintar toda a tela de preto (limpar)
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
    ; Chama a movimentacao de acordo com a nave atual
    cmp nave_atual, 0
    je MOVIMENTO_NAVE_ALIADA ; se for a nave aliada, chama seu movimento

    mov di, 96*320 + 0
    call REMOVE_DESENHO
    call MOVIMENTO_NAVE_INIMIGA ; caso contrario, chama o movimento da nave inimiga

    cmp naveInimigaPosX, 0 ; verifica se a posicao atual da nave inimiga eh 0
    je ZERAR_NAVES ; se a nave inimiga chegar no 0, vai zerar as posicoes das naves
    
    jmp FIM ; caso contrario, finaliza a execucao da rotina

ZERAR_NAVES:
    mov navePosX, 0 ; reseta a posicao X da nave aliada
    mov navePosY, 95 ; reseta a posicao Y da nave aliada
    mov naveInimigaPosX, 305 ; reseta a posicao X da nave inimiga
    mov naveInimigaPosY, 115 ; reseta a posicao Y da nave inimiga
    
    mov di, 115*320 + 0
    call REMOVE_DESENHO
    
FIM:
    xor nave_atual, 1 ; alterna a nave atual entre 0 e 1
    ret
endp

MOVIMENTO_NAVE_ALIADA proc
    push ax
    push bx
    push cx
    push dx

    ; inicializa as posicoes da nave
    mov ax, navePosX
    mov bx, navePosY

MOVIMENTO_LOOP_ALIADA:
    ; verifica se a posicao da nave esta dentro dos limites
    cmp ax, 319 ; verifica o limite direito (319)
    
    jle MOVE_RIGHT

    ; se a nave aliada atingir o limite direito
    mov nave_atual, 1 ; indica que a proxima nave a mover eh a inimiga
    jmp FIM_PROC_ALIADA ; termina a rotina da nave aliada

MOVE_RIGHT:
    ; remover a nave da posicao atual antes de incrementar ax
    mov di, bx ; posicao Y
    shl di, 8 ; desloca para 16 bits
    mov dx, bx ; posicao Y
    shl dx, 6 ; desloca para 64 bits
    add di, dx ; adiciona deslocamento Y
    add di, ax ; adiciona a posicao X
    call REMOVE_DESENHO ; remove a nave da posicao atual

    inc ax ; incrementar ax para mover a nave para a direita

    ; atualizar a posicao da nave
    mov navePosX, ax
    mov navePosY, bx
    
    ; desenhar a nave na nova posicao
    mov di, bx ; posicao Y
    shl di, 8 ; Desloca para 16 bits
    mov dx, bx ; posicao Y
    shl dx, 6 ; desloca para 64 bits
    add di, dx ; adiciona deslocamento Y
    add di, ax ; adiciona a posicao X
    call DESENHA_NAVE ; desenha a nave na nova posicao

    call DELAY ; chamar a rotina de delay

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

    ; inicializa as posicoes da nave
    mov ax, naveInimigaPosX
    mov bx, naveInimigaPosY

MOVIMENTO_LOOP_INIMIGA:
    ; verifica se a posicao da nave esta dentro dos limites
    cmp ax, 0 ; verifica o limite esquerdo
    
    jge MOVE_LEFT

    ; se a nave inimiga atingir o limite esquerdo
    mov nave_atual, 0 ; indica que a proxima nave a mover eh a aliada
    jmp FIM_PROC_INIMIGA ; termina a rotina da nave inimiga

MOVE_LEFT:
    ; remove a nave da posicao anterior
    mov di, bx ; posicao Y
    shl di, 8 ; desloca para a posicao de 16 bits
    mov dx, bx ; posicao Y
    shl dx, 6 ; desloca para 64 bits (cada linha tem 320 pixels)
    add di, dx ; adiciona o deslocamento da posicao Y
    add di, ax ; adiciona a posicao X
    call REMOVE_DESENHO ; remove a nave da posicao anterior
    
    ; Mover a nave para a esquerda
    dec ax ; decrementa a posicao X da nave

    ; atualiza as variaveis de posicao
    mov naveInimigaPosX, ax
    mov naveInimigaPosY, bx

    ; desenha a nave na nova posicao
    mov di, bx ; posicao Y
    shl di, 8 ; desloca para a posicao de 16 bits
    mov dx, bx ; posicao Y
    shl dx, 6 ; desloca para 64 bits (cada linha tem 320 pixels)
    add di, dx ; adiciona o deslocamento da posicao Y
    add di, ax ; adiciona a posicao X
    call DESENHA_NAVE_INIMIGA ; desenha a nave na nova posicao

    call DELAY ; chama a rotina de delay

FIM_PROC_INIMIGA: 
    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp

; rotina de delay
DELAY proc
    mov cx, 0FFFFh   ; valor para criar o delay
DELAY_LOOP:
    loop DELAY_LOOP  ; loop para introduzir o delay
    ret
endp

DELAY_TELA_SETOR proc ; 4 segundos
    push cx
    push dx

    mov cx, [tempo_delay_tela_setor_parte_alta]  ; parte alta de 4.000.000 microssegundos (4 segundos)
    mov dx, [tempo_delay_tela_setor_parte_baixa]  ; parte baixa de 4.000.000 microssegundos (4 segundos)
    
    mov ah, 86h ; funcao de delay do BIOS
    int 15h ; chama interrupcao para aguardar o tempo especificado
    
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

    mov bp, offset setor_um ; texto para printar
    mov dh, 9 ; linha para printar
    mov dl, 0 ; coluna para printar
    mov cx, 205 ; tamanho da string
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

PRINT_SETOR_DOIS proc
    push bp
    push dx
    push cx
    push bx

    mov bp, offset setor_dois ; texto para printar
    mov dh, 9 ; linha para printar
    mov dl, 0 ; coluna para printar
    mov cx, 205 ; tamanho da string
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

PRINT_SETOR_TRES proc
    push bp
    push dx
    push cx
    push bx

    mov bp, offset setor_tres ; texto para printar
    mov dh, 9 ; linha para printar
    mov dl, 0 ; coluna para printar
    mov cx, 205 ; tamanho da string
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

CHAMAR_SETOR_DOIS proc
    call LIMPAR_TELA
    call PRINT_SETOR_DOIS
    CALL LIMPAR_TELA
    CALL COMECAR_JOGO
    ret
endp

CHAMAR_SETOR_TRES proc
    call LIMPAR_TELA
    call PRINT_SETOR_TRES
    CALL LIMPAR_TELA
    CALL COMECAR_JOGO
    ret
endp

PRINT_VOCE_PERDEU proc
    push bp
    push dx
    push cx
    push bx

    mov bp, offset logo_perdeu ; texto para printar
    mov dh, 9 ; linha para printar
    mov dl, 0 ; coluna para printar
    mov cx, 250 ; tamanho da string
    mov bl, 4 ; Color
    
    call PRINT_TEXT
    
    CALL DELAY_TELA_SETOR
    
    pop bx
    pop cx
    pop dx
    pop bp
    ret
    ret
endp

PRINT_VOCE_GANHOU proc
    push bp
    push dx
    push cx
    push bx

    mov bp, offset logo_venceu; texto para printar
    mov dh, 9 ; linha para printar
    mov dl, 0 ; coluna para printar
    mov cx, 164 ; tamanho da string
    mov bl, 2 ; Color
    call PRINT_TEXT
    
    ; imprime o titulo "SCORE"
    mov bp, offset score ; texto para printar
    mov dh, 17 ; linha para printar
    mov dl, 2 ; coluna para printar
    mov cx, 6 ; tamanho da string
    mov bl, 15 ; Color
    call PRINT_TEXT
    
    ; converte o valor do score em string antes de imprimir
    call CONVERTER_SCORE_PARA_STR
    
    ; imprime o valor do score
    mov bp, offset score_jogador_str ; string do score a ser impressa
    mov dh, 17 ; linha 17
    mov dl, 10 ; coluna 10
    mov cx, 5 ; tamanho da string "00000"
    mov bl, 15 ; cor do texto
    call PRINT_TEXT
    
    CALL DELAY_TELA_SETOR
    
    pop bx
    pop cx
    pop dx
    pop bp
    ret
    ret
endp

CHAMAR_VOCE_PERDEU proc
    call LIMPAR_TELA
    call PRINT_VOCE_PERDEU
    ret
endp

CHAMAR_VOCE_GANHOU proc
    call LIMPAR_TELA
    call PRINT_VOCE_GANHOU
    call SAIR_JOGO_PROC
    ret
endp

PRINT_TEMPO_E_SCORE proc
    push bp
    push dx
    push cx
    push bx
    
    ; imprime o titulo "SCORE"
    mov bp, offset score ; texto para printar
    mov dh, 0 ; linha para printar
    mov dl, 0 ; coluna para printar
    mov cx, 6 ; tamanho da string
    mov bl, 15 ; Color
    call PRINT_TEXT
    
    ; converte o valor do score em string antes de imprimir
    call CONVERTER_SCORE_PARA_STR
    
    ; imprime o valor do score
    mov bp, offset score_jogador_str ; string do score a ser impressa
    mov dh, 0 ; linha 0
    mov dl, 7 ; coluna 7
    mov cx, 5 ; tamanho da string "00000"
    mov bl, 2 ; cor do texto
    call PRINT_TEXT

    ; imprime o titulo "TEMPO"
    mov bp, offset tempo ; texto para printar
    mov dh, 0 ; linha para printar
    mov dl, 70 ; coluna para printar
    mov cx, 6 ; tamanho da string
    mov bl, 15 ; Color
    call PRINT_TEXT
    
    ; atualiza e imprime o valor do tempo restante
    call CONVERTER_TEMPO_PARA_STR ; converte o valor de 'tempo_restante' em uma string

    mov bp, offset tempo_str ; texto para printar
    mov dh, 0 ; linha para printar
    mov dl, 78 ; coluna para printar (ao lado de "TEMPO: ")
    mov cx, 2 ; tamanho da string (2 caracteres para o tempo)
    mov bl, 2 ; cor
    call PRINT_TEXT
    
    pop bx
    pop cx
    pop dx
    pop bp
    ret
endp

; converte o valor de 'tempo_restante' para string e armazena em 'tempo_str'
CONVERTER_TEMPO_PARA_STR proc
    push ax
    push bx
    push cx
    push dx

    mov ax, [tempo_restante]  ; pega o valor do tempo restante
    mov bx, 10 ; divisor para converter o numero para decimal

    ; primeiro digito
    xor dx, dx ; limpa dx
    div bx ; ax / 10, resto em dx
    add dl, '0' ; converte para caractere ASCII
    mov [tempo_str+1], dl ; armazena o segundo digito

    ; segundo digito
    mov ax, [tempo_restante] ; pega o valor do tempo restante
    xor dx, dx ; limpa dx
    div bx ; AX / 10, resto em dx
    add al, '0' ; converte para caractere ASCII
    mov [tempo_str], al ; armazena o primeiro digito

    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp

; decrementa o tempo restante
DECREMENTAR_TEMPO proc
    push ax
    push bx
    push cx
    push dx

    mov ax, [tempo_restante]
    cmp ax, 0 ; verifica se ja chegou a zero
    je FIM_DO_TEMPO ; se sim, pula para o fim
    dec ax ; caso contrario, decrementa o tempo
    mov [tempo_restante], ax ; atualiza a variavel

FIM_DO_TEMPO:
    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp

DELAY_1_SEGUNDO proc
    push cx
    push dx

    mov cx, 000Fh  ; parte alta de 1.000.000 microssegundos (1 segundo)
    mov dx, 4240h  ; parte baixa de 1.000.000 microssegundos (1 segundo)
    
    mov ah, 86h ; funcao de delay do BIOS
    int 15h ; chama interrupcao para aguardar o tempo especificado
    
    pop dx
    pop cx
    ret
endp

; converte o valor de 'score_jogador' para string e armazena em 'score_jogador_str'
CONVERTER_SCORE_PARA_STR proc
    push ax
    push bx
    push cx
    push dx

    mov ax, [score_jogador] ; pega o valor do score do jogador
    mov bx, 10 ; divisor para converter o numero para decimal

    ; converte o score para 5 digitos

    ; primeiro digito (mais a direita)
    xor dx, dx ; limpa dx
    div bx ; ax / 10, resto em dx
    add dl, '0' ; converte o resto (digito) para ASCII
    mov [score_jogador_str+4], dl ; armazena o ultimo digito (posicao 5 da string)

    ; segundo digito
    xor dx, dx
    div bx ; ax / 10 novamente
    add dl, '0'
    mov [score_jogador_str+3], dl ; armazena o quarto digito (posicao 4)

    ; terceiro digito
    xor dx, dx
    div bx
    add dl, '0'
    mov [score_jogador_str+2], dl ; armazena o terceiro digito (posicao 3)

    ; quarto digito
    xor dx, dx
    div bx
    add dl, '0'
    mov [score_jogador_str+1], dl ; armazena o segundo digito (posicao 2)

    ; quinto digito (mais a esquerda)
    xor dx, dx
    div bx
    add dl, '0'
    mov [score_jogador_str], dl ; armazena o primeiro digito (posicao 1)

    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp

POSICIONA_NAVES_INICIO_DO_JOGO proc
    ; configurar a posicao da nave
    mov si, offset nave_principal
    mov di, 95*320 + 32 ; posicao inicial da nave
    call DESENHA_ELEMENTO ; desenha a nave nessa posicao

    mov si, offset nave_principal_2
    mov di, 20*320 + 0
    call DESENHA_ELEMENTO
    
    mov si, offset nave_principal_3
    mov di, 40*320 + 0
    call DESENHA_ELEMENTO
    
    mov si, offset nave_principal_4
    mov di, 60*320 + 0
    call DESENHA_ELEMENTO
    
    mov si, offset nave_principal_5
    mov di, 80*320 + 0 
    call DESENHA_ELEMENTO
    
    mov si, offset nave_principal_6
    mov di, 100*320 + 0
    call DESENHA_ELEMENTO
    
    mov si, offset nave_principal_7
    mov di, 120*320 + 0 
    call DESENHA_ELEMENTO 
    
    mov si, offset nave_principal_8
    mov di, 140*320 + 0 
    call DESENHA_ELEMENTO
    
    mov si, offset nave_principal_9
    mov di, 160*320 + 0 
    call DESENHA_ELEMENTO 
    
    mov si, offset superficie_montanha
    mov di, 180*320 + 0
    call DESENHA_MONTANHAS
    
    ret
endp

DESENHA_MONTANHAS proc
    push dx
    push cx
    push di
    push si
    
    mov dx, 20 ; altura do desenho (20 linhas)
DESENHA_MONTANHAS_LOOP:
    mov cx, 320 ; largura do desenho (320 colunas)
    rep movsb ; move 15 bytes de SI para DI (desenha uma linha)
    dec dx ; decrementa o contador de linhas
    add di, 0 ; pula para a proxima coluna (320 - 20 = 300)
    cmp dx, 0 ; verifica se ja desenhou todas as linhas
    jnz DESENHA_MONTANHAS_LOOP ; continua ate desenhar todas as linhas
    
    pop si
    pop di
    pop cx
    pop dx
    ret
endp

; ler os direcionais do teclado
; retorna o caractere em AL
LER_KEY proc
    mov ah, 01h
    int 16h
    ret
endp

; funcao para mover a nave para cima
MOVE_NAVE_CIMA proc
    push ax
    push bx
    push cx
    push si
    push di
    mov bx, posicao_atual_nave
   
    mov ax, memoria_video
    mov ds, ax
   
    mov dx, 11
    mov si, bx
    mov di, bx
    sub di, 320
    push di
MOVE_NAVE_CIMA_LOOP:
    mov cx, 15
    rep movsb
    dec dx
    add di, 305
    add si, 305
    cmp dx, 0
    jnz MOVE_NAVE_CIMA_LOOP
    pop di
    mov bx, di
   
    mov ax, @data
    mov ds, ax
   
    mov posicao_atual_nave, bx
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    ret
endp
   
; funcao para mover a nave para baixo
MOVE_NAVE_BAIXO proc
    push ax
    push bx
    push cx
    push si
    push di
    mov bx, posicao_atual_nave
    mov ax, memoria_video
    mov ds, ax
   
    mov dx, 11
    mov si, bx
    mov di, bx
    add di, 320
    push di
    add di, 2560 ; inicio da ultima linha da nave
    add si, 2560 ; inicio da linha de baixo da nave
MOVE_NAVE_BAIXO_LOOP:
    mov cx, 15
    rep movsb
    dec dx
    sub di, 335
    sub si, 335
    cmp dx, 0
    jnz MOVE_NAVE_BAIXO_LOOP
    pop di
    mov bx, di
    mov ax, @data
    mov ds, ax
    mov posicao_atual_nave, bx
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    ret
endp
   
;funcao para checar a tecla digitada e direcionar a nave para as proc equivalente
; para cima, baixo e barra de espaco para atirar
CHECA_MOVIMENTO_NAVE proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    
    mov ah, 01h
    int 16h
    jz FIM_MOVIMENTO_NAVE
    call LER_KEY
   
    ; compara se o usuario apertou a seta para baixo
    cmp ah, downArrow
    jz MOVER_PARA_BAIXO
    ; compara se o usuario apertou a seta para cima
    cmp ah, upArrow
    jz MOVER_PARA_CIMA
    ; compara se o usuario apertou a barra de espaco
    cmp al, 32
    jz ATIRAR
    jmp FIM_MOVIMENTO_NAVE
   
MOVER_PARA_CIMA:
    
    cmp posicao_atual_nave, 6432 ; linha 20 da coluna 32
    jz FIM_MOVIMENTO_NAVE
    call MOVE_NAVE_CIMA
    jmp FIM_MOVIMENTO_NAVE
   
MOVER_PARA_BAIXO:
    cmp posicao_atual_nave, 51232 ; linha 160 da coluna 32
    jz FIM_MOVIMENTO_NAVE
    call MOVE_NAVE_BAIXO
    jmp FIM_MOVIMENTO_NAVE
   
ATIRAR:
    cmp posicao_atual_tiro, 0
    jnz FIM_MOVIMENTO_NAVE
   
    call CRIA_TIRO
   
FIM_MOVIMENTO_NAVE:
    call CLEAR_KEYBOARD_BUFFER
    
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp

; limpa o buffer do teclado
CLEAR_KEYBOARD_BUFFER proc
    mov ah, 01h 
    int 16h       

    jz BufferCleared  
    mov ah, 00h   
    int 16h       

    jmp CLEAR_KEYBOARD_BUFFER

BufferCleared:
    ret
endp

CRIA_TIRO proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov si, offset posicao_atual_tiro ; configura o endereco onde a posicao do tiro sera armazenada

    ; obtem a posicao atual da nave
    mov ax, posicao_atual_nave  ; ax contem a posicao completa da nave (linha e coluna)

    ; calcula a posicao de coluna do tiro
    add ax, 20 ; define a coluna do tiro como uma posicao a direita da nave
    mov [si], ax ; armazena a nova posicao inicial do tiro

    ; configura a posicao de video para desenhar o tiro
    mov di, ax ; di aponta para a posicao na memoria de video
    mov si, offset tiro ; carrega o endereco do desenho do tiro
    call DESENHA_ELEMENTO ; chama a funcao para desenhar o tiro na posicao calculada

    mov ax, @data ; restaura o segmento de dados padrao
    mov ds, ax

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp
    
REMOVER_TIRO proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov si, offset posicao_atual_tiro ; obtem a posicao atual do tiro
    mov ax, [si] ; pega a posicao completa do tiro (linha e coluna)
    
    ; se a posicao for zero, significa que nao ha tiro na tela
    cmp ax, 0
    jz FIM_REMOVER_TIRO

    ; configura o endereco de video e apaga o desenho do tiro
    mov di, ax ; posicao na memoria de video
    call REMOVE_DESENHO

FIM_REMOVER_TIRO:
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp

MOVER_TIRO proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    ; verifica se o tiro esta ativo (posicao diferente de 0)
    mov si, offset posicao_atual_tiro
    mov ax, [si]
    cmp ax, 0
    je FIM_MOVER_TIRO ; se posicao_atual_tiro eh 0, nao ha tiro ativo -> sair da funcao

    ; verifica o contador de movimento do tiro
    mov ax, [contador_tiro]
    dec ax
    mov [contador_tiro], ax
    cmp ax, 0
    jnz FIM_MOVER_TIRO ; se o contador nao chegou a zero, nao move o tiro neste ciclo

    ; reseta o contador de tiro para o valor inicial
    mov [contador_tiro], 100 ; velocidade do tiro

    ; obtem a posicao atual do tiro
    mov ax, [si]

    cmp coluna_atual_tiro, 304 ; verifica se o tiro atingiu o limite da tela (coluna 319 - 15 = 304)
    jge APAGAR_TIRO ; se o tiro esta na coluna 304 ou mais, remova-o

MOVE_TIRO: 
    call REMOVER_TIRO ; apagar o tiro da posicao atual

    ; atualizar a posicao do tiro
    inc word ptr [si] ; move o tiro para a direita (incrementa a coluna)

    ; desenhar o tiro na nova posicao
    mov ax, [si]
    mov di, ax
    mov si, offset tiro
    call DESENHA_ELEMENTO
    
    inc coluna_atual_tiro

    jmp FIM_MOVER_TIRO

APAGAR_TIRO:
    
    call REMOVER_TIRO
    mov posicao_atual_tiro, 0  ; resetar a posicao do tiro para 0, indicando que ele esta inativo
    mov coluna_atual_tiro, 52

FIM_MOVER_TIRO:
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp
    
; ------ inimigos ------

; Movimenta a nave inimiga na direcao correta com um contador de velocidade
MOVIMENTO_GERAL_INIMIGO proc
    ; diminui o contador de velocidade da nave
    dec [contador_velocidade_nave_inimiga]
    jnz FIM_MOVIMENTO_GERAL_INIMIGO ; se nao chegou a zero, aguarda mais um ciclo

    ; reseta o contador de velocidade para atrasar o proximo movimento
    mov [contador_velocidade_nave_inimiga], 120 ; velocidade da nave

    call MOVIMENTO_NAVE_INIMIGA_JOGO ; chama a movimentacao de acordo com a nave atual

    ; verifica se a posicao atual da nave inimiga eh 0
    cmp [naveInimigaPosX], 45 ; ultima coluna nave inimiga
    je ZERAR_NAVES_INIMIGAS ; se a nave inimiga chegar no 0, zera as posicoes das naves

    jmp FIM_MOVIMENTO_GERAL_INIMIGO

ZERAR_NAVES_INIMIGAS:
    ; reseta a posicao inicial da nave inimiga na extremidade direita
    mov [naveInimigaPosX], 305
    mov [naveInimigaPosY], 115

    ; remove a nave da tela em sua ultima posicao
    mov di, 115*320 + 45 ; ultima coluna nave inimiga
    call REMOVE_DESENHO
    
    ; verifica se a quantidade de naves ainda eh maior que 0
    jmp FIM_MOVIMENTO_GERAL_INIMIGO

FIM_MOVIMENTO_GERAL_INIMIGO:
    ret
endp

MOVIMENTO_NAVE_INIMIGA_JOGO proc
    push ax
    push bx
    push cx
    push dx

    ; inicializa as posicoes da nave
    mov ax, [naveInimigaPosX]
    mov bx, [naveInimigaPosY]

MOVIMENTO_LOOP_INIMIGA_JOGO:
    ; verifica se a posicao da nave esta dentro dos limites
    cmp ax, 0 ; verifica o limite esquerdo
    
    jge MOVE_LEFT_JOGO

    ; se a nave inimiga atingir o limite esquerdo
    jmp FIM_PROC_INIMIGA_JOGO ; termina a rotina da nave inimiga

MOVE_LEFT_JOGO:
    ; remove a nave da posicao anterior
    mov di, bx ; posicao Y
    shl di, 8 ; desloca para a posicao de 16 bits
    mov dx, bx ; posicao Y
    shl dx, 6 ; desloca para 64 bits (cada linha tem 320 pixels)
    add di, dx ; adiciona o deslocamento da posicao Y
    add di, ax ; adiciona a posicao X
    call REMOVE_DESENHO ; remove a nave da posicao anterior
    
    ; mover a nave para a esquerda
    dec ax ; decrementa a posicao X da nave

    ; atualiza as variaveis de posicao
    mov [naveInimigaPosX], ax
    mov [naveInimigaPosY], bx

    ; desenha a nave na nova posicao
    mov di, bx ; posicao Y
    shl di, 8 ; desloca para a posicao de 16 bits
    mov dx, bx ; posicao Y
    shl dx, 6 ; desloca para 64 bits (cada linha tem 320 pixels)
    add di, dx ; adiciona o deslocamento da posicao Y
    add di, ax ; adiciona a posicao X
    call DESENHA_NAVE_INIMIGA ; desenha a nave na nova posicao

FIM_PROC_INIMIGA_JOGO: 
    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp

; funcao que plota um objeto na extrema direita da tela
; si: recebe o offset do desenho
PRINTA_OBJETO_DIREITA proc
    push ax
    push cx
    push si
    push di
    push bx
    
    xor bx, bx
    xor dx, dx
    call GERA_NUMERO_ALEATORIO
    mov bx, 150
    div bx
    cmp dx, 11
    ja PLOTAR_DESENHO
    mov dx, 12
    cmp dx, 145
    jb PLOTAR_DESENHO
    mov dx, 144
    
PLOTAR_DESENHO:
    cmp dx, 0
    je FIM_PRINTA_OBJETO_DIREITA
    mov ax, dx ; retorno da linha em DX

    ; salva a posicao Y da nave inimiga
    mov [naveInimigaPosY], dx ; guarda a linha (posicao Y) em naveInimigaPosY
    mov bx, 305 ; coluna inicial (posicao X) para nave na ultima coluna
    mov [naveInimigaPosX], bx ; guarda a posicao X inicial da nave

    ; calcula o endereco de tela da posicao inicial
    push dx
    mov bx, 320 ; linha * 320
    mul bx
    add ax, [naveInimigaPosX] ; adiciona coluna inicial (posicao X)
    xor di, di
    mov di, ax
    pop dx
    call DESENHA_ELEMENTO
FIM_PRINTA_OBJETO_DIREITA:
    pop bx
    pop di
    pop si
    pop cx
    pop ax
    ret
endp
    
; funcao que gera um numero aleatorio
GERA_NUMERO_ALEATORIO proc
    push dx
    mov ah, 2Ch ; hora da bios
    int 21h
    mov ax, dx ; move para ax os ms retornados da interrupcao em dl
    pop dx
    ret
endp

REMOVER_NAVE_INIMIGA proc
    ; pega as posicoes da nave para remove-la
    mov ax, [naveInimigaPosX] ; pega a posicao X da nave inimiga
    mov bx, [naveInimigaPosY] ; pega a posicao Y da nave inimiga

    ; calcula o endereco de tela para a posicao atual (X, Y)
    mov di, bx ; posicoes Y
    shl di, 8 ; desloca para a posicao de 16 bits
    mov dx, bx ; posicoes Y
    shl dx, 6 ; desloca para 64 bits (cada linha tem 320 pixels)
    add di, dx ; adiciona o deslocamento de Y
    add di, ax ; adiciona a posicao X
    call REMOVE_DESENHO ; remove a nave da tela
    ret
endp

BLOQUEIA_EXECUCAO_PROGRAMA proc
    push cx
    push dx
    push ax
    
    mov ah, 86h
    xor cx, cx
    mov dx, 0c350h ; 50 ms
    int 15h
    
    pop ax
    pop dx
    pop cx
    ret
endp

; funcao principal de inicializacao do jogo
COMECAR_JOGO proc
    mov [tempo_restante], 60 ; reinicia o tempo a 60 segundos
    mov cx, 7000 ; contador de 1 segundo

    mov [contador_tiro], 100 ; inicializa o contador de tiro
    mov [contador_movimento_nave_inimiga], 500 ; inicializa o contador da nave inimiga
    mov [contador_velocidade_nave_inimiga], 120 ; inicializa o contador de velocidade da nave

    call POSICIONA_NAVES_INICIO_DO_JOGO
    mov bx, posicao_central_nave
    mov posicao_atual_nave, bx
    
COMECAR_JOGO_LOOP:
    call PRINT_TEMPO_E_SCORE ; atualiza o tempo e score na tela

    call CHECA_MOVIMENTO_NAVE ; verifica e executa o movimento da nave do jogador (input do teclado)

    call MOVER_TIRO ; Movimenta o tiro

    ; verifica a posicao da nave inimiga antes de desenhar ou mover
    cmp [naveInimigaPosX], 46 ; verifica se a nave esta na extremidade esquerda (ultima coluna nave inimiga + 1)
    je NOVA_NAVE ; se chegou a 0, desenha uma nova nave

    ; caso contrario, move a nave existente
    call MOVIMENTO_GERAL_INIMIGO
    jmp CONTINUAR_LOOP ; pula para continuar o loop principal

NOVA_NAVE:
    ; caso contrario, pegar a posicao atual da nave inimiga e remover ela
    call REMOVER_NAVE_INIMIGA
    add score_jogador, 100
    
    ; plota uma nova nave
    mov si, offset nave_inimiga
    call PRINTA_OBJETO_DIREITA ; desenha uma nova nave
    
    jmp CONTINUAR_LOOP ; continua o loop principal
    
CONTINUAR_LOOP:
    dec cx ; reduz o contador de ciclos para o tempo
    jnz CONTINUA_JOGO ; Se cx nao chegou a zero, continua o jogo sem atualizar o tempo

    ; reseta o contador de ciclos e decrementa o tempo do jogo
    mov cx, 7000 ; reinicia o contador (~1 segundo)
    call DECREMENTAR_TEMPO ; decrementa o tempo do jogo

    ; verifica se o tempo acabou
    mov ax, [tempo_restante]
    cmp ax, 0
    jne CONTINUA_JOGO

    ; caso o tempo tenha acabado, chama o proximo setor
    cmp [setor_atual], 1
    je IR_PARA_SETOR_DOIS
    
    cmp [setor_atual], 2
    je IR_PARA_SETOR_TRES
    
    cmp [setor_atual], 3
    je FIM_DO_JOGO
   
CONTINUA_JOGO:
    jmp COMECAR_JOGO_LOOP ; volta para o inicio do loop principal

IR_PARA_SETOR_DOIS:
    call BLOQUEIA_EXECUCAO_PROGRAMA
    inc setor_atual
    
    ; incrementa o score com base nas vidas restantes (score += vidas * 1000)
    mov ax, quantidade_vidas
    mov cx, 10
    mul cx
    mov cx, 100
    mul cx
    add ax, score_jogador
    mov score_jogador, ax
    
    call CHAMAR_SETOR_DOIS
    
IR_PARA_SETOR_TRES:
    call BLOQUEIA_EXECUCAO_PROGRAMA
    inc setor_atual
    
    ; incrementa o score com base nas vidas restantes (score += vidas * 2000)
    mov ax, quantidade_vidas
    mov cx, 20
    mul cx
    mov cx, 100
    mul cx
    add ax, score_jogador
    mov score_jogador, ax
    
    call CHAMAR_SETOR_TRES
    
FIM_DO_JOGO:
    call BLOQUEIA_EXECUCAO_PROGRAMA
    call CHAMAR_VOCE_GANHOU
    ret
endp

SAIR_JOGO_PROC proc
    mov ah, 4Ch ; funcao para terminar
    int 21h
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
    
    or bh, bh ; verifica opcao selecionada
    jnz SAIR_JOGO
    
    ;call CHAMAR_SETOR_UM
    call PRINT_VOCE_GANHOU
SAIR_JOGO:
    call SAIR_JOGO_PROC  
end INICIO