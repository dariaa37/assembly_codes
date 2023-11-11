; Nombre del programa	    :EJ00.ASM 
; Objetivo		            :El primer programa formal 
; 
; COMANDO DE ENSAMBLE	    :MASM EJ00.ASM
; COMANDO DE ENLACE	        :LINK EJ00.OBJ
; COMANDO DE EJECUCIÓN	    :EJ00 [Enter]
; 
.MODEL SMALL 		        ;Modelo de memoria
.CODE 			            ;Área de código
Empieza: 		            ;Etiqueta de comienzo de programa

; El programa NO HACE NADA. Al ser ejecutado simplemente regresa
; el control a MS-DOS.
    MOV AX, 4C00H 		        ;Regresa a MS-DOS por medio de la función 4C.
    INT 21H			            ;Interrupción 21H para regresar a MS-DOS.
    .STACK			            ;Se necesita una pila
    END Empieza 		        ;Fin del programa
