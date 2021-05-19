*-----------------------------------------------------------
* Title      : Mapa Gráfico Sokoban (solo muros y personaje)
* Written by : Fulgencio
* Date       : 05/2021
* Description:
*-----------------------------------------------------------
DRKGRAY EQU $404040
RED     EQU $0000FF

ORIX EQU 100
ORIY EQU 100
SIZE EQU 40
*GAP  EQU 10

    ORG    $1000
START

    JSR PINTAMAPA
    SIMHALT

************SUB PINTAMAPA
PINTAMAPA
    MOVEM.L A1/D0-D2,-(A7)
    MOVE.L #MAPA1,A1
    MOVE.L #ORIX,D1
    MOVE.L #ORIY,D2     *X e Y en D1 y D2
BUCLE   
    MOVE.B (A1)+,D0
    CMP.B #0,D0
    BEQ NUEVAFILA
    CMP.B #'#',D0
    BNE NOMURO
    JSR GRIS
    JSR PINTAMURO 
NOMURO   
    CMP.B #'@',D0
    BNE NOPERS1
    JSR ROJO
    JSR PINTAMOZO
NOPERS1
    CMP.B #'+',D0
    BNE NOPERS2
    JSR ROJO
    JSR PINTAMOZO
NOPERS2
    *Aqui se pueden comprobar las demás cosas
    
    ADD.L #SIZE,D1  *Avanzamos coordenada X
    JMP BUCLE
       
NUEVAFILA
    
    ADD.L #SIZE,D2  *Avanzo coordenada Y (nueva fila)
    MOVE.L #ORIX,D1 *Repongo coordenada X inicial
    
    CMP.B #0,(A1)
    BNE BUCLE
    MOVEM.L (A7)+,A1/D0-D2
    RTS

*************SUB PINTAMURO
PINTAMURO   *Pinta un cuadrado de muro en X,Y indicado por D1 y D2
    MOVEM.L D0-D4,-(A7)
    MOVE.L D1,D3
    MOVE.L D2,D4
    ADD.L #SIZE,D3
    ADD.L #SIZE,D4
    MOVE.L #87,D0   *cuadrado
    TRAP #15
    MOVE.L #84,D0   *linea cruzada
    TRAP #15
    MOVEM.L (A7)+,D0-D4
    RTS
    
***********SUB PINTAMOZO
PINTAMOZO
    MOVEM.L D0-D4,-(A7)
    ADD.L #SIZE/4,D1        *mitad tamaño que el muro
    ADD.L #SIZE/4,D2        *quitamos 1/4 de cada lado
    MOVE.L D1,D3
    MOVE.L D2,D4
    ADD.L #SIZE/2,D3
    ADD.L #SIZE/2,D4
    MOVE.L #88,D0       *círculo
    TRAP #15
    MOVEM.L (A7)+,D0-D4
    RTS

**********SUBS COLORES    
GRIS
    MOVEM.L D0-D1,-(A7)
    MOVE.L #81,D0
    MOVE.L #DRKGRAY,D1
    TRAP #15
    MOVEM.L (A7)+,D0-D1
    RTS
    
ROJO
    MOVEM.L D0-D1,-(A7)
    MOVE.L #81,D0
    MOVE.L #RED,D1
    TRAP #15
    MOVEM.L (A7)+,D0-D1
    RTS
************    

* Put variables and constants here

MAPA1   DC.B '###### ',0  *# BORDE
        DC.B '#@   ##',0  *@ PERSONAJE
        DC.B '# $$  #',0  *$ CAJAS
        DC.B '# #  .#',0  *. DESTINO
        DC.B '#     #',0
        DC.B '#######',0,0

    END    START
