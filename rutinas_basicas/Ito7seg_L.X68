*-----------------------------------------------------------
* Title      : Representa Nº en 7 SEGMENTOS máx(99999999)
* Written by : Fulgencio
* Date       : 
* Description: Representa Nº en decimal hasta 8 dígitos 7 seg.
*              La limitación de que el cociente de la división 
*              entera no pueda superar un .W se evita partiendo 
*              el número en dos partes, con una división previa 
*              por el valor 10000
*-----------------------------------------------------------

SEG EQU $E0000E     * último display 7SEG

    ORG    $1000
START
    
    CLR.L SEG-2     *Así en tamaño .L los borra de 2 en 2
    CLR.L SEG-6
    CLR.L SEG-10
    CLR.L SEG-14

***** Entrada
    MOVE.L #87651234,D1   * Nº a representar
***** Llamada a la funcion
    JSR TO7SEG
    SIMHALT


TO7SEG
    MOVEM.L A0-A1/D1-D2,-(A7)
***** Contantes
    MOVE.L #TABLA,A0    * Tabla de conversión 7 segmentos
    MOVE.L #SEG,A1      * A1 apunta al display de más a la derecha (primero en llenar)
    CLR.L D2            * Lo usaremos de apoyo para partir el número cuando sea necesario
***** Verificación límites
    CMP.L #655360,D1    * (Máximo número)+1 que permite la división por 10 con resultado .W
    BCS PASO2           * Directamente al paso 2 porque no hace falta partir el número
PASO1
    DIVU #10000,D1      * Dividimos por 10000 para partir el número en 2 partes (cociente y resto)
    MOVE.W D1,D2        * Guardamos cociente (parte más significativa) en D2
    CLR.W D1            * y lo eliminamos de D1
    SWAP D1             * Cogemos solo el resto para descomponerlo en cifras
    JSR CIFRAS
    MOVE.L D2,D1        * Cogemos ahora el cociente (más significativo) y lo desocomponemos en cifras
PASO2
    JSR CIFRAS
    MOVEM.L (A7)+,A0-A1/D1-D2
    RTS
    

CIFRAS
    DIVU #10,D1
    SWAP D1                 * El resto=cifra lo paso a la palabra baja .W
    MOVE.B (A0,D1.W),(A1)   * Utilizo D1.W (solo palabra baja) como índice
    SUB.L #2,A1             * pasa al display anterior
    CMP.L #SEG-16,A1        * Si se acaban 
    BEQ OVER
    CLR.W D1                * elimino resto
    SWAP D1                 * devuelvo el cociente a la palabra baja
    BNE CIFRAS *Mientras cociente no llegue a 0
OVER
    RTS


     ORG $2000
     
TABLA    *    %HGFEDCBA
        DC.B  %00111111  DIGITO 0
        DC.B  %00000110  DIGITO 1
        DC.B  %01011011  DIGITO 2
        DC.B  %01001111  DIGITO 3
        DC.B  %01100110  DIGITO 4
        DC.B  %01101101  DIGITO 5
        DC.B  %01111101  DIGITO 6
        DC.B  %00000111  DIGITO 7
        DC.B  %01111111  DIGITO 8
        DC.B  %01101111  DIGITO 9
APAGA   DC.B  %00000000  APAGADO
    END    START

*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
