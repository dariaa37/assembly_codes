; Nombre del programa : EJ07.ASM
; Objetivo : Realizar operaciones de suma, resta multiplicación división
; sobre dos cantidades enteras sin signo y no mayores que
; 65535.
; ***********************************************************
; COMANDO DE ENSAMBLE : Masm EJ07.ASM;
; COMANDO DE ENLACE : Link EJ07.OBJ;
; COMANDO DE EJECUCION : EJ07 [Enter]
; ********************************************** //fila 10
; NOTA : se procura usar SOLO las instrucciones que se han visto o explicado. El objetivo
; es educativo y NO de optimizar o eficientar. Por favor, NO SE DESESPERE
; y estúdielo.
; ***********************************************************
; Define el modelo de memoria
.MODEL SMALL
.Data
    ErrorCAP DB 0                     ; Bandera de error en la captura de las cantidades
    Cantidad DB 0                     ; La cantidad sobre la que se opera. Si es 0 se opera
                                    ; sobre la cantidad 1, si es 1 se opera sobre la
    ; fila 20
    ; cantidad 2.
    CantUnoR DW 0                     ; Variable que guarda la cantidad uno convertida a binario.
    CantDosR DW 0                     ; Variable que guarda la cantidad 2 convertida a binario.
    CantUnoN DB 6,0,6 DUP(?)          ; Variable que almacena la cantidad 1
    CantDosN DB 6,0,6 DUP(?)          ; Variable que almacena la cantidad 2
    Funcion DB 0                      ; Variable que guarda la función a realizar
 ; fila 27
    Resulta DB 13,10,13,10, 'El resultado es: $'
    ResultaR DB 11 DUP(?)
    Mensaje DB 'Bienvenidos a EJ07, que le permite realizar las'
        DB 13,10
        DB 'operaciones BASICAS de MULTIPLICACION, DIVISION, SUMA'
        DB 'y resta sobre dos cantidades enteras.'
        DB 13,10,13,10, '$'
    Pregunta DB 13,10,13,10,'DIGITE:',13,10,13,10
        DB '(1) para MULTIPLICAR.',13,10
        DB '(2) para DIVIDIR.',13,10
        DB '(3) para SUMAR.',13,10
        DB '(4) para RESTAR.',13,10
        DB '(5) para TERMINAR.',13,10,'$' ; fila 40
    Error DB 7,7,7,13,10,'Error: en la selección de las opciones.'
        DB 13,10,13,10,'$'
    Error1 DB 7,7,7,13,10,'ERROR : digito INVALIDO en CANTIDAD 1.'
        DB 13,10,13,10,'$'
    Error2 DB 7,7,7,13,10,'ERROR : digito INVALIDO en CANTIDAD 2.'
        DB 13,10,13,10,'$'
    Error3 DB 7,7,7,13,10,'ERROR : cantidad fuera de RANGO (65535).'
        DB ' !!! '
    ; ----------------------------
        DB 13,10,13,10,'$'                ; fila 50
    Error4 DB 7,7,7,13,10,'ERROR : intento de DIVISION por CERO.'
        DB 13,10,13,10,'$'
        ; MENSAJES DE CAPTURA DE CANTIDADES
    CantunoM DB 13,10,13,10, 'Digite primer cantidad(debe ser < a 65535)'
        DB ':$'
    CantdosM DB 13,10,13,10, 'Digite segunda cantidad (debe ser < a 65535)'
        DB ':$'
        Potencia DW 0001h, 000Ah, 0064h, 03E8h, 2710h
        PotenciaF DW $

.CODE                             ; Area de código
Empieza:                          ; Etiqueta de comienzo de programa //fila 60

Mov Ah,0Fh                        ; obtiene la modalidad de video actual
Int 10h
Mov Ah,0                          ; cambia la modalidad de video que se obtuvo
Int 10h
Mov Ax,@Data                      ; inicializa Ds con la direccionde @data
Mov Ds,Ax
Mov Dx,offset Mensaje             ; despliega el mensaje de bienvenida
Call Imprime
Mov Si,offset ResultaR            ; inicializa la variable ResultaR
Add Si, 11                        ; fila 70
Mov Al, '$'
Mov [Si],Al

OTRA:
    Mov Dx,Offset Pregunta            ; despliega menu de opciones
    Call Imprime
    Call ObtenTecla                   ; espera a que el usuario seleccione la funcion por realizar (1 a 5)
    Cmp Al,49                         ; la selección del usuario es mayor o igual
    Jae SIGUE                         ; a 1?.
    Mov Dx,offset Error               ; No, despliega mensaje de error
    Call Imprime                      ; fila 80
    Jmp OTRA

SIGUE:
    Cmp Al,53                         ; la seleccion del usuario es menor o igual
    Jbe TODOBIEN                      ; a 5?.
    Mov Dx,Offset Error               ; no, despliega mensaje de error
    Call Imprime
    Jmp OTRA

TODOBIEN:
    Cmp Al,53
    Jnz CHECATODO                     ; fila 90
    Jmp OPCION3
; ----------------------------
CHECATODO:
    Mov Funcion,Al                    ; Guarda la función a realizar
                                  ; _________________________
                                  ; SE CAPTURAN LAS CANTIDADES Y SE GUARDAN EN SUS RESPECTIVAS
                                  ; VARIABLES PARA PODER TRABAJAR SOBRE ELLAS MAS ADELANTE. LA CAPTURA
                                  ; SE BASA EN LA FUNCIÓN 09 DE LA INT 21H. DICHA FUNCION ESTABLECE QUE EL
                                  ; REGISTRO AH CONTENGA 09 Y EL REGISTRO PAR DS : DX APUNTE A LA DIRECCION
                                  ; DE LA VARIABLE QUE ALMACENARA LA ESTRUCTURA DEL BUFFER, EL CUAL DEBE
;fila 100
; ESTAR CONSTRUIDO DE LA SIGUIENTE MANERA:

; BYTE 1 = CANTIDAD DE BYTES POR LEER
; BYTE 2 = (LLENADO POR MS-DOS) ES LA CANTIDAD DE BYTES REALMENTE LEIDOS.
; BYTE 3 = BUFFER DONDE SE ALMACENA EL RESULTADO; DEBE ENCONTRARSE
; INICIALIZANDO CON LA MISMA CANTIDAD DE BYTES ESPECIFICADOS POR EL BYTE 1.

; LAS CANTIDADES CAPTURADAS REPRESENTAN UNA CADENA QUE ES NECESARIO
; CONVERTIR EN BINARIO ANTES DE QUE SE PUEDA OPERAR SOBRE ELLA. MAS
; ADELANTE SERA EVIDENTE LO ANTERIOR.
; ____________________________________
; __________________________
; CAPTURA PRIMERA CANTIDAD.
; __________________________
CAPCANT01:
    Mov Dx,Offset CantUnoM            ; Mensaje de captura de cantidad 1
    Call Imprime
    Mov Ah,0Ah                        ; Captura la cantidad (hasta 8 digitos)
    Mov Dx,Offset CantUnoN
    Int 21h                           ; fila 120
    Mov ErrorCAP,0                    ; Supone que no hay errores y que se esta operando
    Mov Cantidad,0                    ; Sobre la cantidad 1.
    Call ConvNUM                      ; Convierte cantidad 1 a binario
    Cmp ErrorCAP,1                    ; ¿Hubo error?
    Jz CAPCANT01                      ; Si, regresa a la captura
    Mov CantUnoR,Bx                   ; Guarda resultado de conversión
                                  ; ______________________
                                  ; CAPTURA SEGUNDA CANTIDAD.
                                  ; ______________________
CAPCANT02:
    Mov ErrorCAP,0                    ; Supone que no hay error
    Mov Cantidad,1                    ; Indica a ConvNUM que es la segunda cantidad
    Mov Dx,Offset CantDosM            ; Mensaje sobre captura de cantidad 2
    Call Imprime
    Mov Ah,0Ah                        ; Captura la segunda cantidad
    Mov Dx,Offset CantDosN
    Int 21h
    ; ----------------------------
    Call ConvNUM                      ; Convierte cantidad 2 a binario
    Cmp ErrorCAP,1                    ; ¿Hay error? //fila 140
    Jz CAPCANT02                      ; Si, regresa a capturar la cantidad
    Mov CantDosR,Bx                   ; Guarda conversion de cantidad 2
                                    ; _____________________
                                    ; DESPUES DE CAPTURAR LAS DOS CANTIDADES SOBRE LAS CUALES SE VA A
                                    ; OPERAR, SE DEFINE CUAL ES LA FUNCION POR REALIZAR ( MULTIPLICACION,
                                    ; DIVISION, SUMA O RESTA).
                                    ; _____________________
    Mov Al,Funcion                    ; Funcion que selecciono el usuario
    Cmp Al, 31h                       ; ¿Es 1?
    Jne FUNCION2                      ; No.
    Call Multiplica                   ; Multiplica las dos cantidades
    Jmp OTRA
FUNCION2:
    Cmp Al,32h                        ; ¿Es 2?
    Jne FUNCION3                      ; No.
    Call Divide                       ; Divide las dos cantidades
    Jmp OTRA
FUNCION3:
    Cmp Al,33h                        ; ¿Es 3?
    Jne FUNCION4                      ; No. //fila 160
    Call Suma                         ; Suma las dos cantidades
    Jmp OTRA
FUNCION4:
    Cmp Al,34h                        ; ¿Es 4?
    Jne OPCION3                      ; No.
    Call Resta                        ; Resta las dos cantidades
    jmp OTRA
OPCION5:                            ; TERMINA EL PROGRAMA
Mov Ax,4C00h                      ; Termina el programa sin errores
Int 21h
; *******************************************************
; RUTINAS DE SOPORTE
; *******************************************************
; __________________
; Rutina : Multiplica
; ------------------------------
; Propósito : Multiplica dos números enteros sin signo
; Parámetros : En el registro AX el multiplicando y en BX el multiplicador ;fila 180
; Regresa : El resultado en el registro par DX : AX, que es desplegado en la pantalla.
; __________________
Multiplica Proc Near
    Xor Dx,Dx                         ; Dx- 0 por si acaso
    Mov Ax,CantUnoR                   ; Primera cantidad (multiplicando)
    Mov Bx,3CH                         ; Segunda cantidad(multiplicador)
    Mul Bx                            ; Multiplica
    Call ConvASCII                    ; Convierte en ASCII
    Mov Dx,Offset Resulta             ; Prepara para desplegar la cadena del resultado
    Call Imprime
    Mov Dx,Offset ResultaR            ; Despliega el resultado.
    Call Imprime
    Ret
Multiplica Endp
; __________________________
; Rutina : Divide
; Propósito : Divide dos números enteros sin signo
; Parámetros : En el registro AX el dividendo y en BX el divisor
; Regresa : El resultado en el registro par DX : AX, que es desplegado en la pantalla.
; __________________________ //fila 200
Divide Proc Near
    Mov Ax,CantUnoR                   ; Carga la cantidad 1(dividiendo)
    Mov Bx,CantDosR                   ; Carga la cantidad 2(divisor)
    Cmp Bx,0                          ; Revisa si el divisor es 0 para evitar un error de división
    ; entre cero
    Jnz DIVIDE01
    Mov Cantidad,3                    ; Hubo error, asi que despliego el mensaje y salta
    Call HuboERROR
    Ret
DIVIDE01:
    Div Bx                            ; Divide
    Xor Dx,Dx                         ; Dx - 0. No se usa el residuo para simplificar las
    ; operaciones
    Call ConvASCII                    ; Convierte en ASCII
    Mov Dx,Offset Resulta             ; Despliega la cadena del resultado
    Call Imprime
    Mov Dx,Offset ResultaR            ; Despliega el resultado
    Call Imprime
    Ret
Divide Endp
; ___________________________
; Rutina : Suma
; ------------------------------
; Propósito ; Suma dos números enteros sin signo
; Parámetros : En el registro AX el primer número y en BX el segundo
; Regresa : El resultado en el registro par DX : AX, que es desplegado en la pantalla.
; ___________________________
Suma Proc Near
    Xor Dx,Dx                         ; Dx - 0 por si acaso existe acarreo
    Mov Ax,CantUnoR                   ; Primera cantidad //fila 230
    Mov Bx,CantDosR                   ; Segunda cantidad
    Add Ax,Bx                         ; Las suma
    Jnc SUMACONV                      ; ¿Hubo acarreo?
    Adc Dx,0                          ; Si
SUMACONV:
    Call ConvASCII                    ; Convierte resultado en ASCII
    Mov Dx,Offset Resulta             ; Despliega cadena del resultado
    Call Imprime
    Mov Dx,Offset ResultaR            ; Despliega el resultado
    Call Imprime
    Ret
Suma Endp
; _________________
; Rutina : Resta
; Propósito : Resta dos números enteros sin signo
; Parámetros : En el registro AX el primer número y en BX el segundo
; Regresa : El resultado en el registro par DX : AX. Que es desplegado en la pantalla.
; __________________
Resta Proc Near
    Xor Dx,Dx                         ; Dx =0 si acaso existe acarreo
    Mov Ax,CantUnoR                   ; Primera cantidad
    Mov Bx,CantDosR                   ; Segunda cantidad
    Sub Ax,Bx                         ; Resta cantidades
    Jnc RESTACONV                     ; ¿Hubo acarreo?
    Sbb Dx,0                          ; Si
RESTACONV:
    Call ConvASCII                    ; Convierte en ASCII
    Mov Dx,Offset Resulta             ; Despliega cadena del resultado //fila 260
    Call Imprime
    Mov Dx,Offset ResultaR            ; Despliega el resultado
    Call Imprime
    Ret
Resta Endp
; _________________
; Rutina : Imprime
; ----------------------------------
; Propósito : Despliega una cadena
; Parámetros : El registro DX contiene el desplazamiento de la cadena
; Regresa : Nada
; __________________
Imprime Proc Near
    Mov Ah,9                          ; prepara para desplegar la cadena a través de la
    int 21h
    Ret
Imprime Endp
; _________________
; Rutina : ObténTecla
; Propósito : Espera a que el usuario digite una tecla
; Parámetros : Ninguno
; Regresa : En el registro AL el código ASCII de la tecla
; __________________
ObtenTecla Proc Near
    Mov Ah,0                          ; Lee una tecla del teclado a través de la INT 16h
    Int 16h
    Ret
ObtenTecla Endp
; _________________
; Rutina : ConvNUM //fila 290
; Propósito : Convertir una cadena en un entero largo
; Parámetros : La longitud de la cadena y la dirección de la misma, y se pasan a la pila.
; Regresa : En el registro par BX la cadena convertida en un entero
; __________________
ConvNUM Proc Near
    Mov Dx,0Ah                        ; Multiplicador es 10
    Cmp Cantidad,0                    ; ¿Es la cantidad 1?
    Jnz CONVNUM01                     ; No, asi que es la cantidad 2
    Mov Di,Offset CantUnoN + 1        ; Bytes leidos de la cantidad 1
    Mov Cx,[Di]                       ; fila 300
    Mov SI,Offset CantUnoN + 2        ; La cantidad 1
    Jmp CONVNUM02
CONVNUM01:
    Mov Di,Offset CantDosN + 1        ; Bytes leidos de la cantidad 2
    Mov Cx,[Di]
    Mov Si,Offset CantDosN + 2        ; La cantidad 2
CONVNUM02:
    Xor Ch,Ch                         ; Ch=0
    Mov Di,Offset Potencia            ; Direccion de la tabla de potencias
    Dec Si                            ; Posicion si en el primer byte de la cadena capturada
    Add Si,Cx                         ; le suma el desplazamiento de bytes leidos.
                                    ; -------------------------------------
    Xor Bx,Bx
    Std                               ; para que podamos posicionarnos en el final de la misma
                                  ; (apunta al último digito capturado). Bx = 0 y lee la cadena en
; forma inversa; es decir, de atrás hacia adelante.
CONVNUM03:
    Lodsb                             ; Levanta un byte del numero (esta instruccion indica que el registro
    ; al sera cargado con el contenido de la direccion apuntada por ds:si)
    Cmp Al,"0"                        ; ¿Es menor que 0?(entonces no es un digito valido)
    Jb CONVNUM04                      ; Si, despliega el mensaje de error y termina
    Cmp Al,"9"                        ; ¿Es mayor que 9?(entonces no es un digito valido)
    Ja CONVNUM04                      ; Si, despliega el error y salta
    Sub Al,30h                        ; Convierte el digito de ASCII a binario
    Cbw                               ; Convierte a palabra
    Mov Dx,[Di]                       ; Obtiene la potencia de 10 que sera usada para
    Mul Dx                            ; Multiplicar, multiplica numero y lo suma
    Jc CONVNUM05
    Add Bx,Ax                         ; Si hay acarreo la cantidad es >65535
    Jc CONVNUM05
    Add Di,2                          ; Va a la siguiente potencia de 10
    Loop CONVNUM03                    ; Itera hasta que CX sea = 0 //fila 330
    Jmp CONVNUM06
CONVNUM04:
    Call HuboERROR                    ; Algo ocurrió, despliega mensaje y salta
    Jmp CONVNUM06
CONVNUM05:
    Mov Cantidad,2
    Call HuboERROR
CONVNUM06:
    Cld
    Ret
ConvNUM Endp


; _________________
; Rutina : ConvASCII
; Propósito : Convertir un valor binario en ASCII
; Parámetros : El registro par DX : AX
; Regresa : Nada, pero almacena el resultado en el buffer ResultaR
;fila 390
; __________________
ConvASCII Proc Near
    Push Dx
    Push Ax                           ; Guarda el resultado
    Mov Si,Offset ResultaR            ; Inicializa la variable resultarllenandola
    Mov CX,10                         ; Con asteriscos
    Mov Al,'*'
; --------------------------------------
CONVASCII01:
    Mov [Si],Al                       ; fila 400
    Inc Si
    Loop CONVASCII01
    Pop Ax
    Pop Dx
    Mov Bx,Ax                         ; Palabra baja de la cantidad
    Mov Ax,Dx                         ; Palabra alta de la cantidad
    Mov Si,Offset ResultaR            ; Cadena donde se guardara el resultado
    Add Si,11
    Mov Cx,10                         ; Divisor =10
OBTENDIGITO:
    Dec Si
    Xor Dx,Dx                         ; Dx contendra el residuo
    Div Cx                            ; Divide la palabra alta (Ax)
    Mov Di,Ax                         ; Guarda cociente (Ax)
    Mov Ax,Bx                         ; Ax = palabra baja (Bx)
    Div Cx                            ; Dx tenia un residuo de la division anterior
    Mov Bx,Ax                         ; Guarda el cociente
    Mov Ax,Di                         ; Regresa la palabra alta
    Add Dl,30h                        ; Convierte residuo en ASCII
    Mov [Si],Dl                       ; Lo almacena
    Or Ax,Ax                          ; ¿Palabra alta es 0?
    Jnz OBTENDIGITO                   ; No, sigue procesando ERROOOOOOOOOOOOR
    Or Bx,Bx                          ; ¿Palabra baja es 0?
    Jnz OBTENDIGITO                   ; No, sigue procesando
    Ret
ConvASCII Endp
; _________________
; Rutina : HuboERROR
; Propósito : Desplegar el mensaje de error adecuado.
; Parámetros : Nada
; Regresa : Nada
; __________________
HuboERROR Proc Near
    Cmp Cantidad,0                    ; ¿Es la cantidad 1?
    Jnz HUBOERROR02                   ; No
    Mov Dx, Offset Error1
    Call Imprime
    Mov ErrorCAP,1                    ; Enciende la bandera de error
    Jmp HUBOERROR05
HUBOERROR02:
    Cmp Cantidad,1                    ; ¿Es la cantidad 2?
    Jnz HUBOERROR03                   ; No
                                    ; ------------------------------------------
    Mov Dx,Offset Error2
    Call Imprime
    Mov ErrorCAP,1
    Jmp HUBOERROR05
HUBOERROR03:
    Cmp Cantidad,2                    ; ¿Cantidad capturada esta fuera de rango?
    Jnz HUBOERROR04                   ; No /fila 450
    Mov Dx,Offset Error3
    Call Imprime
    Mov ErrorCAP,1
    Jmp HUBOERROR05
HUBOERROR04:
    Mov Dx,Offset Error4              ; Error de intento de division por cero
    Call Imprime
    Mov ErrorCAP,1
HUBOERROR05:
    Ret
HuboERROR Endp
    .STACK
    End Empieza                       ; fila 463