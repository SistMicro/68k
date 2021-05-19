*-----------------------------------------------------------
* Title      : INPUT7SEG -  Toma un número escrito desde teclado apareciendo
*                           dinámicamente por los visualizadores 7 segmentos 
*                           y devolviendo el valor del mismo en D1 calculado
*                           mediante algoritmo de Horner
* Written by : Fulgencio
* Date       :
* Description:
*-----------------------------------------------------------
SEG EQU $E0000E     * último display 7SEG
ENTER EQU $0D
    ORG    $1000
START
    
    CLR.L SEG-2     *Así en tamaño .L los borra de 2 en 2
    CLR.L SEG-6
    CLR.L SEG-10
    CLR.L SEG-14

    JSR INPUT7SEG
    
***** Comprobación   
    JSR NEWLINE
    MOVE.L #3,D0    *Prueba de adquisición correcta del número (unsigned)
    TRAP #15
    SIMHALT
    
    
INPUT7SEG
    
    MOVEM.L A1-A2/D0/D2,-(A7)

**** Constantes y variables
    CLR.L D2        *D2 para sumar cifras con sus pesos
    MOVE.L #TABLA,A0
    MOVE.L #SEG,A1  *A1 apunta al dígito usado más significativo
    MOVE.L A1,A2    *A2 se usa para recorrer y desplazar los dígitos en 7 segmentos

**** Llamadas auxiliares   
    JSR ECHOOFF
    
OTRO    
    MOVE.L #5,D0
    TRAP #15
    CMP.B #ENTER,D1
    BEQ FULL        *Termina con ENTER
    CMP.B #'9',D1
    BHI OTRO
    CMP.B #'0',D1
    BCS OTRO
    MOVE.L #6,D0
    TRAP #15        *Generamos el eco pero solo cuando sean cifras numéricas
   
    SUB.L #2,A1     *Se va a ocupar un nuevo digito más significativo. Los dígitos van en direcciones pares
    MOVE.L A1,A2
    
BUCDESP    
    CMP.L #SEG,A2   *Si ha llegado al final
    BEQ FINDESPL
    MOVE.B 2(A2),(A2)   *Desplaza dígito hacia la izquierda
    ADD.L #2,A2         *Apunta al dígito de la derecha
    JMP BUCDESP
    
FINDESPL    
    SUB.L #'0',D1      *De ASCII a Entero
    MOVE.B (A0,D1),SEG

MULT_D2X10
*******ALTERNATIVA PARTICULAR PARA MULTIPLICAR x10 en LONG sin MULU
   MOVE.L D2,D3    *Copiamos a D3 el valor a multiplicar
   LSL.L #3,D3     *3 desplazamientos es multiplicar x8
   ADD.L D2,D2     *Multiplica x2
   ADD.L D3,D2     *x8+x2 = x10
   ADD.L D1,D2     *Añade la nueva cifra
*******


*******ALGORITMO para multiplicar .W x .L = .L 
*    CMP.L #$10000,D2    
*    BHI DOSWORDS    *SI sobrepasa .W hay que dividir en 2 .W
*    MULU #10,D2     *MULU es .W x .W = .L   
*    ADD.L D1,D2     *Añade la nueva cifra con peso 1
*    JMP FINHORNER
*    
*DOSWORDS
*    CLR.L D3
*    SWAP D2         
*    MOVE.W D2,D3    *Palabra alta de D2 pasa a palabra baja D3 (baja peso para multiplicar)
*    
*    CLR.W D2        *Borramos palabra alta
*    SWAP D2
*    MULU #10,D2
*    MULU #10,D3   *
*    SWAP D3         *Recuperamos su peso original subiendolo a palabra alta
*    ADD.L D3,D2     *Fusionamos contribución de ambas multiplicaciones sumando los resultados
*    ADD.L D1,D2     *Añadimos la nueva cifra
*FINHORNER
**********   

    CMP.L #SEG-16,A1   *Comprueba si se han llenado las 8 cifras
    BEQ FULL           *Finaliza por desbordamiento de capacidad   
    JMP OTRO

FULL
    MOVE.L D2,D1       *Salida en D1
    MOVEM.L (A7)+,A1-A2/D0/D2
    RTS
        
    SIMHALT             ; halt simulator

ECHOOFF
    MOVEM.L D0-D1,-(A7)
    MOVE.L #12,D0
    MOVE.L #0,D1
    TRAP #15
    MOVEM.L (A7)+,D0-D1
    RTS

NEWLINE
    MOVEM.L D0/A1,-(A7)
    MOVE.L #14,D0
    MOVE.L #CRLF,A1
    TRAP #15
    MOVEM.L (A7)+,D0/A1
    RTS
  
     ORG $2000

CRLF    DC.B $0A,$0D,0
    
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
