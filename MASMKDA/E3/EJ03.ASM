; Nombre del programa	:EJ03.ASM
; Objetivo		        :Desplegar una cadena

; COMANDO DE ENSAMBLE	:MASM EJ03.ASM
; COMANDO DE ENLACE	    :LINK EJ03.OBJ
; COMANDO DE EJECUCIÓN	:EJ03 [Enter]

; Define el modelo de memoria

CODE SEGMENT PUBLIC 'CODE'
ORG 100H
ASSUME CS : CODE, ES : CODE, DS : CODE, SS : CODE

Empieza:               ; Etiqueta de comienzo de programa

JMP Codigo

Mensaje DB 'Hola, qué tal! $'

Codigo:
    MOV DX, offset Mensaje ; Dirección de mensaje
    MOV AH,9               ; en Dx para poder desplegarlo
    INT 21H                ; a través de la Int 21 del MS-DOS
    MOV AX,4C00            ; Regresa a MS-DOS por medio de la
    INT 21H                ; Función 4C

CODE ENDS
END Empieza            ; Fin del programa