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
    posicao_central_nave equ 30432 ; nave centralizada (coluna 32 linha 95)
    
    navePosX dw 0 ; Posi??o X inicial da nave
    navePosY dw 95 ; Posi??o Y inicial da nave
    
    naveInimigaPosX dw 305
    naveInimigaPosY dw 115
    
    nave_atual db 0 ; 0 para a nave aliada, 1 para a nave inimiga
    
    tempo_delay_tela_setor dw 4 ; 4 segundos 
    tempo_delay_tela_setor_parte_alta dw 003Dh  ; Parte alta de 4.000.000 microssegundos (4 segundos)
    tempo_delay_tela_setor_parte_baixa dw 0900h  ; Parte baixa de 4.000.000 microssegundos (4 segundos)
    tempo_restante dw 60        ; Come?amos com 60 segundos
    
    score_jogador dw 0
    
    ; Buffer para exibir o tempo
    tempo_str db "00", 0
    score_jogador_str db "", 0
    
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
    
   ;vidas
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
    
    ; 8 x 38 = 304
    logo_perdeu db "        __   _____   ___ ___ ",CR,LF
                db "        \ \ / / _ \ / __| __|",CR,LF
                db "         \ V / (_) | (__| _| ",CR,LF
                db "          \_/ \___/ \___|___|",CR,LF
                db "      ___ ___ ___ ___  ___ _   _  _ ",CR,LF
                db "     | _ \ __| _ \   \| __| | | || |",CR,LF
                db "     |  _/ _||   / |) | _|| |_| ||_|",CR,LF
                db "     |_| |___|_|_\___/|___|\___/ (_)",CR,LF

    ; 8 x 38 = 304
    logo_venceu db "        __   _____   ___ ___ ",CR,LF
                db "        \ \ / / _ \ / __| __|",CR,LF
                db "         \ V / (_) | (__| _| ",CR,LF
                db "          \_/ \___/ \___|___|",CR,LF
                db "    __   _____ _  _  ___ ___ _   _ _",CR,LF
                db "    \ \ / / __| \| |/ __| __| | | | |",CR,LF
                db "     \ V /| _|| .` | (__| _|| |_| |_|",CR,LF
                db "      \_/ |___|_|\_|\___|___|\___/(_)",CR,LF
        
                ; 14 x 400
                superficie_montanha db 0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0
                db 0,0,0,0,0,6,6,6,0,0,6,6,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,6,6,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,6,6,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,6,6,0,0,0,0,0,6,0,0
                db 0,0,0,0,6,6,6,6,6,6,6,6,6,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,6,6,6,6,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,6,6,6,6,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,6,6,6,6,0,0,0,0,6,0,0
                db 0,0,0,6,6,6,6,6,6,6,6,6,6,0BH,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,6,6,0,0,0,0,0,0,0,0,0,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,6,6,6,6,6,0BH,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,6,6,0,0,0,0,0,0,0,0,0,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,6,6,6,6,6,0BH,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,6,6,0,0,0,0,0,0,0,0,0,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,6,6,6,6,6,0BH,0,0,0,6,0,0
                db 0,0,0,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,6,6,6,6,6,0BH,0BH,0BH,0,0,0,0,0,0,0,0BH,0BH,6,6,6,0,0,0,0,0,0,0,0,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,6,6,6,6,6,0BH,0BH,0BH,0,0,0,0,0,0,0,0BH,0BH,6,6,6,0,0,0,0,0,0,0,0,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,6,6,6,6,6,0BH,0BH,0BH,0,0,0,0,0,0,0,0BH,0BH,6,6,6,0,0,0,0,0,0,0,0,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,0
                db 0,0,0,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,6,6,6,6,6,6,6,0BH,0BH,0BH,0,0,0,0,0,0BH,0BH,6,6,6,6,0,0,0BH,0,0,0,0BH,0,6,6,0BH,0,0,0,0,0,0,0,6,0,0,0,0,0,0,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,6,6,6,6,6,6,6,0BH,0BH,0BH,0,0,0,0,0,0BH,0BH,6,6,6,6,0,0,0BH,0,0,0,0BH,0,6,6,0BH,0,0,0,0,0,0,0,6,0,0,0,0,0,0,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,6,6,6,6,6,6,6,0BH,0BH,0BH,0,0,0,0,0,0BH,0BH,6,6,6,6,0,0,0BH,0,0,0,0BH,0,6,6,0BH,0,0,0,0,0,0,0,6,0,0,0,0,0,0,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,0
                db 0,0,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,0BH,0BH,0,0,0,0,0,6,6,0,0,0,0,0,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,0BH,0BH,0,0,0,0,0,6,6,0,0,0,0,0,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,0BH,0BH,0,0,0,0,0,6,6,0,0,0,0,0,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,6
                db 0,0,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,0,0,0,0,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,0,0,0,0,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,0,0,0,0,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,6,6,6
                db 0,0,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,0,0,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0,0,0,0,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,0,0,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0,0,0,0,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,0,0,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0,0,0,0,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,6,6,6,6
                db 0,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,6,6,6,6,6,0,0,0,0,0,0,0,0,0BH,0BH,6,6,6,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,0,0,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,6,6,6,6,6,0,0,0,0,0,0,0,0,0BH,0BH,6,6,6,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,0,0,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,6,6,6,6,6,0,0,0,0,0,0,0,0,0BH,0BH,6,6,6,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,0BH,0BH,0BH,0BH,0BH,6,6,6,6,6,6,0,0,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,6,6,6,6
                db 0,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,6,6,6,6,6,0BH,0BH,0,0,0BH,0,0,0BH,0BH,0BH,6,6,6,6,6,6,6,6,0BH,0,0,0,0BH,0BH,0,0BH,0,0,0,0BH,0,6,6,6,0,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,0BH,6,6,6,6,6,6,0,0,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,6,6,6,6,6,0BH,0BH,0,0,0BH,0,0,0BH,0BH,0BH,6,6,6,6,6,6,6,6,0BH,0,0,0,0BH,0BH,0,0BH,0,0,0,0BH,0,6,6,6,0,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,0BH,6,6,6,6,6,6,0,0,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,6,6,6,6,6,0BH,0BH,0,0,0BH,0,0,0BH,0BH,0BH,6,6,6,6,6,6,6,6,0BH,0,0,0,0BH,0BH,0,0BH,0,0,0,0BH,0,6,6,6,0,6,6,6,6,6,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,0BH,0BH,0BH,0BH,6,6,6,6,0BH,0BH,0BH,0BH,6,6,6,6,6,6,0,0,6,6,6,6,6,6,6,6,6,6,6,6,6,0BH,0BH,6,6,6,6
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


DELAY_TELA_SETOR proc ; 4 SEGUNDOS
    push cx
    push dx

    mov cx, [tempo_delay_tela_setor_parte_alta]  ; Parte alta de 4.000.000 microssegundos (4 segundos)
    mov dx, [tempo_delay_tela_setor_parte_baixa]  ; Parte baixa de 4.000.000 microssegundos (4 segundos)
    
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

PRINT_VOCE_PERDEU proc
    
    push bp
    push dx
    push cx
    push bx

    mov bp, offset logo_perdeu ; Text to print
    mov dh, 9 ; Line to print
    mov dl, 0 ; Column to print
    mov cx, 304 ; Size of string printed
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

CHAMAR_VOCE_PERDEU proc

    call LIMPAR_TELA
    call PRINT_VOCE_PERDEU
    ret
endp

PRINT_TEMPO_E_SCORE proc
    push bp
    push dx
    push cx
    push bx
    
    ; Imprime o t?tulo "SCORE"
    mov bp, offset score ; Text to print
    mov dh, 0 ; Line to print
    mov dl, 0 ; Column to print
    mov cx, 6 ; Size of string printed
    mov bl, 15 ; Color
    call PRINT_TEXT
    
    ; Converte o valor do score em string antes de imprimir
    call CONVERTER_SCORE_PARA_STR
    
    ; Imprime o valor do score
    mov bp, offset score_jogador_str ; String do score a ser impressa
    mov dh, 0        ; Linha 0
    mov dl, 7        ; Coluna 7
    mov cx, 5        ; Tamanho da string "00000"
    mov bl, 2       ; Cor do texto
    call PRINT_TEXT

    ; Imprime o t?tulo "TEMPO"
    mov bp, offset tempo ; Text to print
    mov dh, 0 ; Line to print
    mov dl, 70 ; Column to print
    mov cx, 6 ; Size of string printed
    mov bl, 15 ; Color
    call PRINT_TEXT
    
    ; Atualiza e imprime o valor do tempo restante
    call CONVERTER_TEMPO_PARA_STR ; Converte o valor de 'tempo_restante' em uma string

    mov bp, offset tempo_str ; Text to print
    mov dh, 0               ; Line to print
    mov dl, 78              ; Column to print (ao lado de "TEMPO: ")
    mov cx, 2               ; Size of string (2 caracteres para o tempo)
    mov bl, 2              ; Color
    call PRINT_TEXT
    
    pop bx
    pop cx
    pop dx
    pop bp
    
    ret
endp

CONVERTER_TEMPO_PARA_STR proc
    ; Converte o valor de 'tempo_restante' para string e armazena em 'tempo_str'
    push ax
    push bx
    push cx
    push dx

    mov ax, [tempo_restante]  ; Pega o valor do tempo restante
    mov bx, 10                ; Divisor para converter o n?mero para decimal

    ; Primeiro d?gito
    xor dx, dx                ; Limpa DX
    div bx                    ; AX / 10, resto em DX
    add dl, '0'               ; Converte para caractere ASCII
    mov [tempo_str+1], dl     ; Armazena o segundo d?gito

    ; Segundo d?gito
    mov ax, [tempo_restante]  ; Pega o valor do tempo restante
    xor dx, dx                ; Limpa DX
    div bx                    ; AX / 10, resto em DX
    add al, '0'               ; Converte para caractere ASCII
    mov [tempo_str], al       ; Armazena o primeiro d?gito

    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp

DECREMENTAR_TEMPO proc
    ; Decrementa o tempo restante
    push ax
    push bx
    push cx
    push dx

    mov ax, [tempo_restante]
    cmp ax, 0                 ; Verifica se j? chegou a zero
    je FIM_DO_TEMPO           ; Se sim, pula para o fim
    dec ax                    ; Caso contr?rio, decrementa o tempo
    mov [tempo_restante], ax   ; Atualiza a vari?vel

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

    mov cx, 000Fh  ; Parte alta de 1.000.000 microssegundos (1 segundo)
    mov dx, 4240h  ; Parte baixa de 1.000.000 microssegundos (1 segundo)
    
    mov ah, 86h    ; Fun??o de delay do BIOS
    int 15h        ; Chama interrup??o para aguardar o tempo especificado
    
    pop dx
    pop cx
    ret
endp

CONVERTER_SCORE_PARA_STR proc
    ; Converte o valor de 'score_jogador' para string e armazena em 'score_jogador_str'
    push ax
    push bx
    push cx
    push dx

    mov ax, [score_jogador]   ; Pega o valor do score do jogador
    mov bx, 10                ; Divisor para converter o n?mero para decimal

    ; Converte o score para 5 d?gitos

    ; Primeiro d?gito (mais ? direita)
    xor dx, dx                ; Limpa DX
    div bx                    ; AX / 10, resto em DX
    add dl, '0'               ; Converte o resto (d?gito) para ASCII
    mov [score_jogador_str+4], dl ; Armazena o ?ltimo d?gito (posi??o 5 da string)

    ; Segundo d?gito
    xor dx, dx
    div bx                    ; AX / 10 novamente
    add dl, '0'
    mov [score_jogador_str+3], dl ; Armazena o quarto d?gito (posi??o 4)

    ; Terceiro d?gito
    xor dx, dx
    div bx
    add dl, '0'
    mov [score_jogador_str+2], dl ; Armazena o terceiro d?gito (posi??o 3)

    ; Quarto d?gito
    xor dx, dx
    div bx
    add dl, '0'
    mov [score_jogador_str+1], dl ; Armazena o segundo d?gito (posi??o 2)

    ; Quinto d?gito (mais ? esquerda)
    xor dx, dx
    div bx
    add dl, '0'
    mov [score_jogador_str], dl   ; Armazena o primeiro d?gito (posi??o 1)

    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp


POSICIONA_NAVES_INICIO_DO_JOGO proc

    ; Configurar a posi??o da nave
    mov si, offset nave_principal
    mov di, 95*320 + 32       ; Posi??o inicial da nave
    call DESENHA_ELEMENTO            ; Desenha a nave nessa posi??o

    mov si, offset nave_principal_2
    mov di, 20*320 + 0       ; Posi??o inicial da nave
    call DESENHA_ELEMENTO            ; Desenha a nave nessa posi??o
    
    mov si, offset nave_principal_3
    mov di, 40*320 + 0       ; Posi??o inicial da nave
    call DESENHA_ELEMENTO            ; Desenha a nave nessa posi??o
    
    mov si, offset nave_principal_4
    mov di, 60*320 + 0       ; Posi??o inicial da nave
    call DESENHA_ELEMENTO            ; Desenha a nave nessa posi??o
    
    mov si, offset nave_principal_5
    mov di, 80*320 + 0       ; Posi??o inicial da nave
    call DESENHA_ELEMENTO            ; Desenha a nave nessa posi??o
    
    mov si, offset nave_principal_6
    mov di, 100*320 + 0       ; Posi??o inicial da nave
    call DESENHA_ELEMENTO            ; Desenha a nave nessa posi??o
    
    mov si, offset nave_principal_7
    mov di, 120*320 + 0       ; Posi??o inicial da nave
    call DESENHA_ELEMENTO            ; Desenha a nave nessa posi??o
    
    mov si, offset nave_principal_8
    mov di, 140*320 + 0       ; Posi??o inicial da nave
    call DESENHA_ELEMENTO            ; Desenha a nave nessa posi??o
    
    mov si, offset nave_principal_9
    mov di, 160*320 + 0       ; Posi??o inicial da nave
    call DESENHA_ELEMENTO            ; Desenha a nave nessa posi??o
    
    mov si, offset superficie_montanha
    mov di, 180*320 + 0
    call DESENHA_MONTANHAS
    
    ret
endp

; Fun??o para desenhar objetos
; SI: Posi??o do desenho na mem?ria
; DI: Posi??o do primeiro pixel do desenho no v?deo (c?lculo do endere?o de v?deo)
DESENHA_MONTANHAS proc
    push dx
    push cx
    push di
    push si
    
    mov dx, 20                  ; Altura do desenho (9 linhas)
DESENHA_MONTANHAS_LOOP:
    mov cx, 320                  ; Largura do desenho (15 colunas)
    rep movsb                   ; Move 15 bytes de SI para DI (desenha uma linha)
    dec dx                      ; Decrementa o contador de linhas
    add di, 0                ; Pula para a pr?xima coluna (320 - 20 = 300)
    cmp dx, 0                   ; Verifica se j? desenhou todas as linhas
    jnz DESENHA_MONTANHAS_LOOP   ; Continua at? desenhar todas as linhas
    
    pop si
    pop di
    pop cx
    pop dx
    ret
endp

;;;;;;;;;;; movimento


; Ler os direcionais do teclado
; retorna o caractere em AL
LER_KEY proc
    ;mov AH, 0
    mov ah, 01h
    int 16h
    ret
endp

; Funcao destinada a mover a nave para cima --------> talvez tenha que mexer nos valores, pois o tamanho da nossa nave eh diferente
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
   
;Funcao destinada a mover a nave para baixo --------> talvez tenha que mexer nos valores, pois o tamanho da nossa nave eh diferente
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
    add di, 2560                 ; inicio da ultima linha da nave
    add si, 2560                 ; inicio da linha de baixo da nave
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
   
   
;Funcao destinada a checar a tecla digitada e direcionar a nave para as proc de mover
; para cima, baixo e checa a barra de espaco para atirar
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
   
    ; Compara se o usuario apertou a arrow down
    cmp ah, downArrow
    jz MOVER_PARA_BAIXO
    ; Compara se o usuario apertou a arrow up
    cmp ah, upArrow
    jz MOVER_PARA_CIMA
    ; Compara se o usuario apertou a barra de espaco
    ;cmp al, 32
    ;jz ATIRAR
    jmp FIM_MOVIMENTO_NAVE
   
MOVER_PARA_CIMA:
    
    cmp posicao_atual_nave, 474 ; linha 1
    jz FIM_MOVIMENTO_NAVE
    call MOVE_NAVE_CIMA
    jmp FIM_MOVIMENTO_NAVE
   
   
MOVER_PARA_BAIXO:
    cmp posicao_atual_nave, 54234 ; linha 169
    jz FIM_MOVIMENTO_NAVE
    call MOVE_NAVE_BAIXO
    jmp FIM_MOVIMENTO_NAVE
   
;ATIRAR:
    ;cmp posicao_atual_tiro, 0
    ;jnz FIM_MOVIMENTO_NAVE
   
    ;call CRIA_TIRO
   
   
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


;;;;;;;;;;;;;;;;;;;;;;

COMECAR_JOGO proc
    
    ; Loop principal do jogo com cron?metro de 60 segundos
    mov [tempo_restante], 60   ; Reinicia o tempo a 60 segundos
    
    call POSICIONA_NAVES_INICIO_DO_JOGO
    
    mov bx, posicao_central_nave
    mov posicao_atual_nave, bx
    
COMECAR_JOGO_LOOP:
    
    call PRINT_TEMPO_E_SCORE   ; Atualiza a tela com o tempo e score
    
    ; Verifica e executa o movimento da nave
    call CHECA_MOVIMENTO_NAVE
    
    call DELAY_1_SEGUNDO       ; Aguarda 1 segundo
    call DECREMENTAR_TEMPO     ; Decrementa o tempo
    mov ax, [tempo_restante]
    cmp ax, 0                  ; Verifica se o tempo acabou
    jne COMECAR_JOGO_LOOP      ; Continua se o tempo n?o chegou a zero

    call CHAMAR_VOCE_PERDEU

    ret
endp

;Limpa o buffer do teclado
CLEAR_KEYBOARD_BUFFER proc
    mov ah, 01h 
    int 16h       

    jz BufferCleared  
    mov ah, 00h   
    int 16h       

    jmp CLEAR_KEYBOARD_BUFFER

BufferCleared:
    ret
CLEAR_KEYBOARD_BUFFER endp

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