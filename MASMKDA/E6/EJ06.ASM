; Nombre del programa : EJ06.ASM
; Objetivo : Captura dos cadenas y las compara, reportando si son iguales o no.
; La cantidad de caracteres a comparar está dada por los caracteres realmente leídos de la cadena 1.
; Es decir, para que se consideren iguales, las dos cadenas deben ser de la misma longitud.
; El programa distingue entre mayúsculas y minúsculas. La “A” es diferente de “a”. Con un poco más de
; creatividad, este programa se puede ampliar para que busque una cadena dentro de otra y reporte si existe o no.


; COMANDO DE ENSAMBLE : Masm EJ06.MASM;
; COMANDO DE ENLACE : Link EJ06.OBJ;
; COMANDO DE EJECUCION : EJ06 [Enter]


; NOTA : procure usar SOLO las instrucciones que se han visto o explicado.
; El procedimiento (objetivo) es con fines educativos y NO de optimización o
; eficiencia. Por favor, NO SE DESESPERE Y estúdielo.

.MODEL SMALL
.Data
 Cadena1 DB 15,0,15 DUP(?)           ; Variable que almacena cadena 1
 Cadena2 DB 15,0,15 DUP(?)           ; Variable que almacena cadena 2
 Mensaje DB 'Bienvenidos a EJ06. Programa ejemplo que compara'
 DB 'dos cadenas y reporta',13,10
 DB 'si son iguales o no. Para terminar digite FIN en'
 DB 'mayúsculas.'
 DB 13,10,'$'
 Error DB 7,7,7,13,10,'ERROR : cadenas son DIFERENTES!!!.'
 DB 13,10,13,10,'$'
 Error1 DB 7,7,7,13,10, 'ERROR: cadena no puede ser NULA!!!.'
 DB 13,10,13,10,'$'
 Final DB 'FIN'
 TodoBien DB 7,7,7,13,10,'cadenas son IGUALES.'
 DB 13,10,13,10,'$'
 CadUnoM DB 13,10,13,10, 'Digite primera CADENA: $'
 CadDosM DB 13,10,13,10,'Digite segunda CADENA: $'

.CODE                                ; Area de código
Empieza :                            ; Etiqueta de comienzo de programa
                                     ; ___________________________
                                     ; BORRA LA PANTALLA CAMBIANDO LA MODALIDAD DE VIDEO. ESTA FORMA DE
                                     ; BORRAR LA PANTALLA ES MUY PECULIAR Y SE CONSIDERA COMO UN “TRUCO”.
                                     ; SE BASA EN EL HECHO DE QUE AL CAMBIAR LA MODALIDAD DE VIDEO, EL
                                     ; PROPIO BIOS (HARDWARE) BORRA LA PANTALLA POR NOSOTROS.
                                     ; ES UN METODO BURDO PERO MUY EFICIENTE.
                                     ; __________________________________________

 Mov Ah, 0Fh                         ; Obtiene modalidad de video actual
 Int 10h
 Mov Ah, 0                           ; cambia a la modalidad de video que se obtuvo
 Int 10h
 mov Ax, @Data                       ; Inicializa DS con la dirección de @Data
 mov Ds, Ax
 mov Dx, Offset Mensaje              ; Despliega el mensaje de bienvenida
 Mov Ah, 9
 Int 21h
 Push Ds
 Pop Es                              ; ES=DS
                                     ; _____________________________
                                     ; SE CAPTURAN LAS CADENAS Y SE GUARDAN EN SUS RESPECTIVAS VARIABLES PARA PODER TRABAJAR CON ELLAS MAS ADELANTE.
                                     ; LA CAPTURA SE BASA EN LA FUNCION 09 DE LA INT 21H.
                                     ; DICHA FUNCION ESTABLECE QUE EL REGISTRO AH CONTENGA 09 Y EL REGISTRO PAR DS : DX APUNTE A LA DIRECCION DE LA
                                     ; VARIABLE QUE ALMACENARA LA ESTUCTURA DEL BUFFER. ESTE DEBE ESTAR CONSTRUIDO DE LA SIGUIENTE MANERA:

                                     ; BYTE 1 = CANTIDAD DE BYTES A LEER
                                     ; BYTE 2 = (LLENADO POR MS-DOS) ES LA CANTIDAD DE BYTES REALMENTE
                                     ; LEIDOS.
                                     ; BYTE 3 = BUFFER DONDE SE ALMACENA EL RESULTADO. DEBE ENCONTRARSE
                                     ; INICIALIZADO CON LA MISMA CANTIDAD DE BYTES ESPECIFICADOS
                                     ; POR EL BYTE 1.

                                     ; LAS CANTIDADES CAPTURADAS REPRESENTAN UNA CADENA QUE ES
                                     ; NECESARIO CONVERTIR A BINARIO ANTES DE PODER OPERAR SOBRE ELLA.
                                     ; MAS ADELANTE QUEDARA CLARO LO ANTERIOR.
                                     ; ________________________________________
                                     ; ______________________
                                     ; CAPTURA PRIMER CADENA
;______________________
CAPCAD01:
 Mov Dx, Offset CadUnom              ; Mensaje de captura de cadena 1
 Mov Ah, 9
 Int 21h
 Mov Ah, 0Ah                         ; Captura la cantidad (hasta 15 bytes)
 Mov Dx, Offset Cadena1
 Push Dx                             ; Guarda dirección de variable
 Int 21h
 Pop Dx
Inc Dx                               ; Obtiene cantidad de bytes realmente leídos
                                     ; que se encuentra en el byte 1 del buffer
 Mov Si, Dx
 Cmp Byte ptr [Si], 0                ; ¿Es 0?
 Jnz CAPCAD02                        ; No, asi que prosigue
 Mov Dx, Offset Error1               ; Despliega mensaje de error y captura la
 Mov Ah, 9                           ; cadena de nuevo
 Int 21h
 Jmp CAPCAD01
 ; __________________________
 ; PRIMERO COMPRUEBA SE LA CADENA 1 TIENE LA CADENA “FIN” QUE
 ; ESPECIFICA TERMINAR ESTE PROGRAMA. SI LO ANTERIOR ES VERDADERO EL
 ; PROGRAMA TERMINA, DE LO CONTRARIO CAPTURA LA SEGUNDA CADENA Y
 ; PROSIGUE. “FIN” DEBE ESTAR EN MAYUSCULAS.
 ; __________________________
CAPCAD02:
 Inc Dx                              ; Primer byte del buffer de CADENA 1
 Mov Cx, 3                           ; Vamos a revisar 3 bytes
 Mov Si, Dx                          ; Cadena capturada
 Mov Di, Offset Final                ; Mensaje de final
 Repe Cmpsb                          ; ¿Digitaron "fin"?
 Jcxz TERMINA                        ; Si; así que termina este programa

CAPCAD03:
 Mov Dx, Offset CadDosM              ; Mensaje de captura de cadena 2
 Mov Ah,9
 Int 21h
 Mov Ah, 0Ah                         ; Captura la segunda cadena
 Mov Dx, Offset Cadena2
 Push Dx                             ; Guarda dirección de variable
 Int 21h
 Pop Dx
 Inc Dx                              ; Obtiene cantidad de bytes realmente leidos
                                     ; que se encuentra en el byte 1 del buffer
 Mov Si, Dx
 Cmp Byte ptr [Si], 0                ; ¿Es 0?
 Jnz CAPCAD04                        ; No, asi que prosigue
 Mov Dx, Offset Error1               ; Despliega mensaje de error y captura la
 Mov Ah, 9                           ; cadena de nuevo
 Int 21h
 Jmp CAPCAD03
 ; _____________________
 ; YA SE TIENEN LA DOS CADENAS CAPTURADAS, AHORA PROCEDEMOS A
 ; COMPARARLAS Y DESPLEGAR EL MENSAJE ADECUADO.
 ; _____________________
CAPCAD04:
 Xor Ch, Ch                          ; Ch = 0 por si acaso.
 Mov Si, Offset Cadena1 + 1          ; Bytes realmente leídos de CADENA 1
 Mov Cl, byte ptr [Si]               ; Cx tiene bytes leídos de cadena 1
 Inc Cl                              ; Ajusta CL debido a la naturaleza de la instrucción
                                     ; de comparación, y a manera en que se comporta
                                     ; la función 9 de la INT 21H
 Inc Si                              ; Regresa a direccion de cadena 1
 Mov Di, Offset Cadena2 + 2          ; Direccion de cadena 2
 Cld
 Repe Cmpsb                          ; Compara cadenas
 Jcxz CAPCAD05                       ; ¿Son iguales?
 Mov Dx, Offset Error                ; No, despliega mensaje
 Mov Ah, 9
 Int 21h
 Jmp CAPCAD01
CAPCAD05:
 Mov Dx, offset todobien             ; Cadenas son iguales
 Mov Ah, 9
 Int 21h
 Jmp CAPCAD01
 ; _________________________
 ; TERMINA EL PROGRAMA
 ; _________________________
TERMINA:
 Mov Ax, 4C00h
 Int 21h                             ; Termina el programa sin errores.

 .STACK
 End Empieza

