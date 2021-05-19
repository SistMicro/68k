*-----------------------------------------------------------
* Title      : Presentación Gráfica Sort-it (PINTARECIP)
* Written by : Fulgencio
* Date       : Mayo 2021
* Description: Representación gráfica de contenedores con bolas para el juego Sort-it
*              A partir de un mapa con números que indican los colores de las bolas
*              son representados gráficamente en Easy68k
*-----------------------------------------------------------
    ORG    $1000
BLACK equ $00000000 
MAROON equ $00000080 
GREEN equ $00008000 
OLIVE equ $00008080 
NAVY equ $00800000 
PURPLE equ $00800080 
TEAL equ $00808000 
GRAY equ $00808080 
RED equ $000000FF 
LIME equ $0000FF00 
YELLOW equ $0000FFFF 
BLUE equ $00FF0000 
FUCHSIA equ $00FF00FF 
AQUA equ $00FFFF00 
LTGRAY equ $00C0C0C0 
WHITE equ $00FFFFFF 
    
ORIX EQU 100
ORIY EQU 100
SIZE EQU 50
GAP  EQU 80
THICK EQU 10

HUECO EQU 0
ROJA  EQU 1
VERDE EQU 2
AMARILLA EQU 3
    
START:                  ; first instruction of program
    
    JSR PINTARECIP
    SIMHALT  

    
PINTARECIP
    MOVEM.L A1/D0-D2,-(A7)
    
    MOVE.L #MAPA,A1
    MOVE.L #ORIX,D1
    MOVE.L #ORIY,D2
    
BUCLEBOLA  
    MOVE.B (A1)+,D0  *TOMA BOLA
    CMP.B #10,D0
    BCC OTRORECIP
    
    JSR COLOR
    JSR BOLA

    ADD.L #SIZE,D2   *Avanza coordenada Y hacia abajo
    JMP BUCLEBOLA
    
OTRORECIP
    SUB.L #10,D0     *Obtiene el color de base del recipiente
    JSR COLOR
    JSR BASE         *Dibuja la base de color
    ADD.L #GAP,D1    *Avanza coordenada X a derecha
    MOVE.L #ORIY,D2  
    CMP.B #$FF,(A1)
    BNE BUCLEBOLA
    MOVEM.L A1/D1-D2,-(A7)
    RTS

COLOR
    MOVEM.L D0-D1/A0,-(A7)
    MOVE.L #COLORES,A0  *Utilizamos una tabla indexada con los colores
    LSL #2,D0           *índice x4 porque cada color es un LONG
    MOVE.L (A0,D0),D1   *coge el color de la tabla indexada COLORES
    MOVE.L #81,D0       *fill color
    TRAP #15
*    MOVE.L #80,D0      *pen color
*    TRAP #15
    MOVEM.L (A7)+,D0-D1/A0
    RTS
    
 
BOLA    MOVEM.L D0-D5,-(A7)
        *MOVE.L D0,D5    *salvamos color -poder evitar bolas negras-
        MOVE.L D1,D3    *Peparamos
        MOVE.L D2,D4
        ADD.L #SIZE,D4
        
        MOVE.L #84,D0   *primero línea
        TRAP #15        *linea vertical izquierda
        ADD.L #SIZE,D3
        *CMP.L #0,D5    *para evitar pintar bolas negras (dejar hueco)
        *BEQ NOCIRCULO
        MOVE.L #88,D0   *círculo
        TRAP #15        *bola
*NOCIRCULO       
        ADD.L #SIZE,D1
        MOVE.L #84,D0   *línea
        TRAP #15        *linea vertical derecha
        MOVEM.L (A7)+,D0-D5
        RTS

BASE    MOVEM.L D0-D4,-(A7)
        MOVE.L D1,D3
        MOVE.L D2,D4      
        ADD.L #SIZE,D3
        ADD.L #THICK,D4 *THICK es el grosor de la base
        MOVE.L #87,D0   *rectángulo
        TRAP #15
        MOVEM.L (A7)+,D0-D4
        RTS

   
* Put variables and constants here

COLORES DC.L BLACK,RED,GREEN,YELLOW   *0,1,2,3

MAPA DC.B 0,3,2,10
     DC.B 1,1,2,11
     DC.B 0,3,1,12
     DC.B 0,3,3,$FF     *$FF = fin de recipientes


    END    START        ; last line of source
