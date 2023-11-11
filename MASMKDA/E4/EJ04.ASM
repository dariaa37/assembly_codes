; Nombre del programa			:EJ04.ASM
; Objetivo						:Despliega el título del programa y los
; :números hexadecimales correspondientes
; :el 15 al 1 en forma de escalera

; COMANDO DE ENSAMBLE			:MASM EJ04.ASM
; COMANDO DE ENLACE				:LINK EJ04.OBJ
; COMANDO DE EJECUCIÓN			:EJ04 [Enter]

; ___________________________________________
; INICIA EL PROGRAMA, SE DEFINE EL MODELO DE
; MEMORIA A USAR Y EL SEGMENTO DE CODIGO
; ___________________________________________

.MODEL SMALL                      ; Modelo de memoria
.CODE                             ; Área de código

Empieza:                          ; Etiqueta de comienzo de programa

MOV AX, @Data                     ; Permite el acceso a los datos inicializando
MOV DS, Ax                        ; el registro DS con la dirección adecuada.
MOV DX, OFFSET Mensaje            ; Carga la dirección de mensaje a DX para
MOV AH, 9                         ; poder desplegarlo con la función 9 de la
INT 21H                           ; Int 21h (DS : DX contiene la dirección de la
                                  ; cadena que se desplegará).

MOV CX, 15                        ; contador de los números (van a ser 15).
MOV BX, OFFSET Tabla              ; permite el acceso a la tabla de equivalencias
                                  ; hexadecimales inicializando su dirección y
                                  ; apuntando al primer elemento,

ITERA:                            ; Etiqueta controladora de la iteraciones.
MOV AL, CL                        ; Pone en Al al número por traducir (empezando
XLAT                              ; desde 15) y lo traduce.
MOV DL, AL                        ; Prepara para desplegar el número usando la
MOV AH, 2                         ; función 2 de la Int 21h, Dl debe tener el carácter
INT 21H                           ; que se desplegará.
MOV DL, 10                        ; Salta una línea dando un efecto de escalera.
INT 21H                           ; De nuevo se usa la función 2.
LOOP ITERA                        ; Itera hasta llegar a 0 (de 15 a 0). El registro CX
                                  ; mantiene una cuenta activa de las veces que se ha

                                  ; iterado, y al completar un ciclo se decrementa en
                                  ; uno hasta llegar a cero.
MOV AX, 4C00H                     ; Regresa a MS-DOS por medio de la función 4c de

                                  ; la interrupción 21h.
INT 21H                           ; El código de regreso es 0 porque no hubo error.
                                  ; en caso de existir, se podría pasar un código
                                  ; diferente a 0 (ej. 4c01h)

                                  ; ___________________________________________
                                  ; INICIA SEGMENTO DE DATOS
                                  ; ___________________________________________
.DATA                             ; Segmento de datos

Mensaje DB 13,10,13,10
DB 'Desplegando los números haxadecimales del 15 al 1'
DB 13, 10, 13, 10, '$'            ; Cadena a desplegar

Tabla DB '0123456789ABCDEF'       ; Tabla de traducción
                                  ; _________________________________
                                  ; INICIA SEGMENTO DE PILA
                                  ; _________________________________
.STACK                            ; Se necesita una PILA
END Empieza                       ; Fin del programa