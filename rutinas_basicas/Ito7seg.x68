*-----------------------------------------------------------
* Title      : Representa Nº en 7 SEGMENTOS máx(655359)
* Written by : Fulgencio
* Date       : 
* Description: Representa Nº en decimal hasta 6 dígitos 7 seg.
*              La limitación viene dada porque el cociente de
*              la división entera no puede superar un .W
*-----------------------------------------------------------

SEG EQU $E0000E * último display 7SEG

    ORG    $1000
START

    CLR.L SEG-2     *Así en tamaño .L los borra de 2 en 2
    CLR.L SEG-6
    CLR.L SEG-10
    CLR.L SEG-14

    MOVE.L #TABLA,A0    * Tabla de conversión 7 segmentos
    MOVE.L #654321,D1   * Nº a representar
    MOVE.L #SEG,A1      * A1 apunta al display de la derecha



CIFRAS
    DIVU #10,D1
    SWAP D1                 * El resto=cifra lo paso a la palabra baja .W
    MOVE.B (A0,D1.W),(A1)   * Utilizo D1.W (solo palabra baja) como índice
    SUB.L #2,A1             * pasa al display anterior
    CLR.W D1                * elimino resto
    SWAP D1                 * devuelvo el cociente a la palabra baja
    BNE CIFRAS *Mientras cociente no llegue a 0

    SIMHALT

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
