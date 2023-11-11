; Nombre del programa		        :EJ02.ASM
; Objetivo			                :Desplegar una cadena

; COMANDO DE ENSAMBLE		        :MASM EJ02.ASM
; COMANDO DE ENLACE		            :LINK EJ02.OBJ
; COMANDO DE EJECUCIÓN		        :EJ02 [Enter]

; Define el modelo de memoria

.MODEL SMALL                         ; Modelo de memoria
.CODE                                ; Área de código

Empieza:                             ; Etiqueta de comienzo de programa
mov Ax, @Data                        ; Inicializa DS con la
mov Ds, Ax                           ; dirección de @Data
mov Ah, 9                            ; en Dx para poder desplegarlo
Int 21h                              ; a través de la Int 21 de MS-DOS
mov ax, 4c00h                        ; Regresa a MS-DOS por medio de la
Int 21h                              ; función 4C
.DATA                                ; Segmento de datos
Mensaje DB 'Hola Mundo soy Karla!.$' ; Cadena a desplegar
.STACK                               ; Se necesita una pila

END Empieza                          ; Fin del programa

