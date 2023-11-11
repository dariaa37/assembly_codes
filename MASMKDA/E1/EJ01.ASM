; Nombre del programa		:EJ01.ASM 
; Objetivo			        :Programa sin DIRECTIVAS SIMPLIFICADAS
; 
; COMANDO DE ENSAMBLE		:MASM EJ01.ASM
; COMANDO DE ENLACE		    :LINK EJ01.OBJ
; COMANDO DE EJECUCIÓN		:EJ01 [Enter]
; 
; La siguiente línea especifica el segmento que contendrá 
; el bloque de código

CODE SEGMENT PUBLIC 'CODE'	;Segmento de código

; La siguiente línea le indica al ensamblador el nombre del segmento que cada 
; registro de segmentos debe direccionar

ASSUME CS: CODE, DS: CODE, ES: CODE, SS: STACK
ORG 0100        ;#######

; Empieza el código
Empieza:        ;#######
    MOV AX, 4C00H
    INT	21H

; La siguiente línea le indica al ensamblador que termina el segmento de un código
;'CODE'
CODE ENDS
; El segmento STACK es el área que usará la pila
STACK SEGMENT PARA STACK 'STACK'
    DW 64 DUP (?)
STACK ENDS
; Se cierra el bloque de código, termina el programa
END Empieza 		;Fin del programa

