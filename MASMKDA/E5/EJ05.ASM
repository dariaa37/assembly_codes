; Nombre del programa               :EJ05.ASM
; Objetivo:
; Demostrar cómo se usan las instrucciones para movimiento de datos, cómo se usa la pila y cómo
; mueven e inicializan bloques de memoria. El programa crea una tabla de 26 bytes que se
; inicializa con una serie de X. Después llena la  tabla con las letras A a Z en minusculas. Lee de
; nuevo la tabla convirtiendo las letras a mayúsculas, y finalmente la despliega.

; Se necesita el MASM Versión 5.X o mayor.

; COMANDO DE ENSAMBLE : Masm EJ05.ASM;
; COMANDO DE ENLACE :   Link EJ05.OBJ;
; COMANDO DE EJECUCION : EJ05 [Enter]

; _______________________________________
; INCIA EL PROGRAMA, SE DEFINE EL MODELO DE MEMORIA Y SE INICIALIZA EL SEGMENTO DE DATOS QUE PERMITIRA EL ACCESO A LOS DATOS.
; USANDO LAS INSTRUCCIONES ‘PUSH’ Y ‘POP’ SE INICIALIZA EL REGISTRO ‘ES’. LA INSTRUCCIÓN MOV AH, 0 Y LA INT 16H LE INDICAN
; AL PROGRAMA QUE DEBE ESPERAR HASTA QUE EL USUARIO DIGITE UNA TECLA. LAS INSTRUCCIONES ANTERIORES FORMAN PARTE DE LAS
; INTERRUPCIONES DEL BIOS.
; _______________________________________

.MODEL SMALL                          ; Modelo de memoria
.CODE                                 ; Área de código
Empieza:                              ; Etiqueta de comienzo de programa
Mov Ax, @Data                         ; Permite el acceso a los datos inicializando el registro
Mov Ds, Ax                            ; DS con la dirección adecuada del segmento de datos
                                      ; (@Data). ES=DS se inicializa empujando el valor de
Push Ds                               ; DS a la pila y extrayéndolo en ES. Despliega el
Pop Es                                ; mensaje de bienvenida usando
Mov Dx, Offset Mensaje                ; la función 9 de la Int 21.
Mov Ah, 9
Int 21h
Mov Ah, 0                             ; Espera a que el usuario digite cualquier tecla usando
Int 16h                               ; la Int 16h del BIOS.
Lea Dx, Mensaje1                      ; Despliega el mensaje ‘Desplegando tabla original…’
Mov Ah, 9                             ; usando la instrucción LEA en lugar de OFFSET.
Int 21h

; _______________________________
; EL SIGUIENTE CODIGO AGREGA EL SIMBOLO ‘$’ AL FINAL DE LA ESTRUCTURA ‘TABLA’ PARA QUE MS-DOS PUEDA DESPLEGAR LA TABLA
; USANDO LA FUNCIÓN 9 DE LA INT 21H. USA LA INSTRUCCIÓN ‘STOSB’ PARA LOGRARLO. ESTA INSTRUCCIÓN ALMACENA EL CONTENIDO DEL REGISTRO
; ‘AL’ EN LA DIRECCION APUNTADA POR EL REGISTRO DI. EL PRIMER PASO ES MOVER AL REGISTRO ‘AL’ EL SIMBOLO ‘$’ Y CALCULAR LA DIRECCION DE
; ‘TABLA’. UNA VEZ OBTENIDA LA DIRECCION, SE LE SUMA LA CANTIDAD DE 25 PARA LLEGAR AL FINAL DE LA TABLA (DE 0 A 25 SON 26).
; ES AQUÍ DONDE SE ALMACENA EL SIMBOLO ‘$’.
; ____________________________________________

Mov Al, '$'                           ; Agrega a Tabla el símbolo ‘$’
Mov Di, Offset Tabla + 26             ; para que MS-DOS pueda ejecutar la
Stosb                                 ; función 9 de la Int 21h. Dicho
Mov Di, Offset Tabla_1 + 26           ; símbolo es generado también para
Stosb                                 ; Tabla_1.
                                      ; ____________________
                                      ; DESPLIEGA LA TABLA ORIGINAL INICIALIZADA CON UNA SERIE DE X.
                                      ; ____________________
Mov Ah, 9
Mov Dx, Offset Tabla                  ; Usa el comando Offset para desplegar la
Int 21h                               ; tabla original inicializada con una serie de ‘X’.
                                      ; ____________________________
                                      ; DESPLIEGA EL MENSAJE ‘INICIALIZANDO TABLA…’ Y ESPERA A QUE EL
                                      ; USUARIO OPRIMA CUALQUIER TECLA.
                                      ; ____________________________
Mov Ah, 9
Mov Dx, Offset Mensaje2               ; Usa el comando Offset para desplegar el mensaje
Int 21h                               ; sobre inicialización de la tabla.
Mov Ah, 0
Int 16h
; ________________________________
; INICIALIZA LA TABLA CON EL ALFABETO. CARGA EN EL REGISTRO “AL” LA
; PRIMERA LETRA QUE ES “a”. EL REGISTRO CX TIENE LA LONGITUD DE LA
; TABLA. SE ITERA HASTA LLENAR LA TABLA CON EL ALFABETO EN MINUSCULAS
; ________________________________
Mov Cx, 26                            ; Longitud de la tabla.
Mov Al, 61h                           ; la letra ‘a’ (61H en ASCII)
Lea Di, Tabla                         ; Dirección de la tabla. Puesto que la operación es destino se
Cld                                   ; usa DI.
InicializaTabla:
Stosb                                 ; Almacena el contenido de Al en la dirección apuntada por
Inc Al                                ; DI.
Loop InicializaTabla                  ; Repite hasta que Cx sea 0.
Lea Dx, Mensaje3                      ; Despliega mensaje3 mediante la instrucción LEA en
Mov Ah, 9                             ; lugar de OFFSET, usando la misma función 9 de la
Int 21h                               ; Int 21h.
Mov Ah, 0                             ; Espera a que el usuario digite cualquier tecla
Int 16h                               ; usando la Int 16h del BIOS.
Mov Ah, 9
Mov Dx, Offset Tabla                  ; Usa el comando Offset para desplegar la
Int 21h                               ; tabla inicializada con minúsculas.
                                      ; _____________________________
                                      ; LEE LA TABLA DE NUEVO, CONVIERTE MINUSCULAS A MAYUSCULAS,
                                      ; ALMACENA EL RESULTADO EN TABLA_1 Y LA DESPLIEGA.
                                      ; _____________________________
Mov Si, Offset Tabla                  ; Dirección de la tabla original (fuente).
Mov Di, Offset Tabla_1                ; Dirección de la tabla (destino).
Mov Cx, 26                            ; Longitud de la tabla.
Cld                                   ; Lee hacia delante.
LeeTabla:
Lodsb                                 ; Carga en Al el contenido de DS : SI.
And Al, 5fh                           ; Convierte en mayúsculas.
Stosb                                 ; Guarda de nuevo en ES : DI.
Loop LeeTabla                         ; Itera hasta que Cx sea 0.
Lea Si, Tabla                         ; Dirección de Tabla (fuente).
Lea Di, Tabla_1                       ; Dirección de Tabla_1 (destino).
Mov Cx, 26                            ; Longitud de la(s) Tabla(s).
Cld
REP Movsb                             ; Mueve el bloque de DS : SI a ES : DI.
Mov Dx, Offset Mensaje4               ; Despliega mensaje4 usando la función
Int 21h                               ; 9 de la interrupción 21h.
Mov Ah, 9
Lea Dx, Tabla_1                       ; Despliega la tabla traducida a
Int 21h                               ; mayúsculas.
                                      ; ____________________________________
                                      ; EL PROGRAMA TERMINA USANDO LA FUNCION 4C DE LA INT 21H. NO HAY
                                      ; ERROR ASE QUE EL CODIGO DE RETORNO ES 00.
                                      ; ____________________________________
Mov Ax, 4c00h                         ; Regresa a MS-DOS mediante la función 4c. El
Int 21h                               ; código de regreso es 0 porque no hubo error. En caso
                                      ; de existir alguno se podría pasar un código diferente
                                      ; de 0 (por ej. 4c01h).
                                      ; _______________________
                                      ; INICIA SEGMENTO DE DATOS
                                      ; _______________________
.DATA                                ; Segmento de datos
Mensaje Db 13, 10
DB 'Bienvenidos al programa EJ05 !. En este programa se demostrará el uso '
DB 'del' , 13, 10
DB 'movimiento de BLOQUES de memoria, así como otro tipo de instrucciones '
DB 'contenidas en este capitulo. Favor de OPRIMIR cualquier TECLA cuando se '
DB 'encuentre listo. $'

Mensaje1 DB 13, 10, 13, 10
DB 'Desplegando Tabla ORIGINAL inicializada con XXXX…'
DB 13, 10, 13, 10, '$'

Mensaje2 DB 13, 10, 13, 10
DB 'INICIALIZANDO LA TABLA ORIGINAL CON EL ALFABETO'
DB 'COMPLETO EN MINUSCULAS.',13,10
DB 'FAVOR DE OPRIMIR CUALQUIER TECLA PARA CONTINUAR!!!$'
Mensaje3 DB 13,10,13,10
DB 'TABLA INICIALIZADA. FAVOR DE OPRIMIR'
DB 'CUALQUIER TECLA PARA DESPLEGARLA...'
DB 13,10,'$'
Mensaje4 DB 13,10,13,10
DB 'DESPLEGANDO TABLA DEL ALFABETO EN MAYUSCULAS'
DB 13,10,13,10,'$'
Tabla DB 26 DUP('X')
Tabla_1 DB 26 DUP(?)
; _______________________
; INICIA SEGMENTO DE PILA
;_______________________
.STACK                                ; Se necesita una pila
END EMPIEZA                           ; Fin del programa
