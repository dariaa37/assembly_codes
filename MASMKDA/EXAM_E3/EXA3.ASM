; Nombre del programa : EXA3.ASM
; Objetivo: Elaborar programa en ensamblador usando macros que presente 3 opciones:
; Opción 1. Solicite una hora y devuelva minutos y segundos
; Opción 2. Solicite minutos y devuelva horas
; Opción 3. Salir
; ***********************************************************
; COMANDO DE ENSAMBLE : Masm EXA3.ASM;
; COMANDO DE ENLACE : Link EXA3.OBJ;
; COMANDO DE EJECUCION : EXA3 [Enter]
; ***********************************************************

.MODEL SMALL                                ; Define el modelo de memoria
INCLUDE MACROS.LIB                          ; Incluye la libreria de macros
.Data                                       ; Segmento de datos

                                            ; Mensajes
    Mensaje DB 'Bienvenidos al examen del EQUIPO 3'
        DB 13,10
        DB '**** Conversor de tiempo ****'
        DB 'Horas, minutos y segundos'
        DB 13,10,13,10, '$'

    Pregunta DB 13,10,13,10,'DIGITE:',13,10,13,10
        DB '(1) para convertir HORAS a MINUTOS y SEGUNDOS.',13,10
        DB '(2) para convertir MINUTOS a HORAS.',13,10
        DB '(3) para TERMINAR.',13,10,'$'   ; fila 40

    Error DB 7,7,7,13,10,'Error: en la selección de las opciones.'
        DB 13,10,13,10,'$'
    Error1 DB 7,7,7,13,10,'ERROR : digito INVALIDO en CANTIDAD 1.'
        DB 13,10,13,10,'$'
    Error2 DB 7,7,7,13,10,'ERROR : cantidad fuera de RANGO (65535).'
        DB ' !!! '
        DB 13,10,13,10,'$'                  ; fila 50
    Error3 DB 7,7,7,13,10,'ERROR : intento de DIVISION por CERO.'
        DB 13,10,13,10,'$'

        ; DATOS INGRESADOS POR EL USUARIO
    ms DB 3CH
    CantHoras DB 13,10,13,10, 'Digite la cantidad de HORAS (< a 65535)'
        DB ':  $'
    CantMinutos DB 13,10,13,10, 'Digite la cantidad de MINUTOS(< a 65535)'
        DB ':  $'
    Resulta1 DB 13,10,13,10, 'MINUTOS:  $'
    Resulta2 DB 13,10,13,10, 'SEGUNDOS: $'
    Resulta3 DB 13,10,13,10, 'HORAS: $'
    ResultaR DB 11 DUP(?)
    ErrorCAP DB 0                           ; Bandera de error en la captura de las cantidades
    Cantidad DB 0                           ; La cantidad sobre la que se opera. Si es 0 se opera
                                            ; sobre la cantidad 1, si es 1 se opera sobre la
                                            ; fila 20
                                            ; cantidad 2.

    CantMin DW 0                           ; Variable que guarda la cantidad 2 convertida a binario.
                                            ; ------------------
    CantR DW 0                              ; Variable que guarda la cantidad uno convertida a binario.
    CantN DB 6,0,6 DUP(?)                   ; Variable que almacena la cantidad 1
    Funcion DB 0                            ; Variable que guarda la función a realizar
                                            ; fila 27

    Potencia DW 0001h, 000Ah, 0064h, 03E8h, 2710h
    PotenciaF DW $

.CODE                                       ; Area de código
Empieza:                                    ; Etiqueta de comienzo de programa //fila 60

ModalidadVideo
    Mov Ax, @Data
    Mov Ds, Ax                       ; Inicializa el programa
Imprime Mensaje                             ; Imprime el mensaje de bienvenida

OTRA:
    InicializaVariable ResultaR             ; Inserta el caracter $ en la variable ResultaR
    Imprime Pregunta
    ObtenTecla                              ; espera a que el usuario seleccione la funcion por realizar (1 a 5)
    Cmp Al,49                               ; la selección del usuario es mayor o igual
    Jae SIGUE                               ; a 1?.
    Imprime Error                           ; No, despliega mensaje de error
    Jmp OTRA

SIGUE:
    Cmp Al,53                               ; la seleccion del usuario es menor o igual
    Jbe TODOBIEN                            ; a 5?.
    Imprime Error                           ; no, despliega mensaje de error
    Jmp OTRA

TODOBIEN:
    Cmp Al,53
    Jnz CHECATODO                           ; fila 90
    Jmp Opcion3                             ; Si, termina el programa
    ; ----------------------------
CHECATODO:
    Mov Funcion,Al                          ; Guarda la función a realizar

; OPCIONES    ---------------------------------------------------------------------
    Cmp Funcion, 31h                             ; ¿Es 1?
    Jne OPCION2                             ; No.
    Imprime CantHoras
    Call Captura
    Call HorasAMS                           ; Multiplica las dos cantidades 
    Jmp OTRA
OPCION2:
    Cmp Funcion,32h                              ; ¿Es 2?
    Jne OPCION3                             ; No.
    Imprime CantMinutos
    Call Captura 
    Call MinutosAH                          ; Divide las dos cantidades
    Jmp OTRA
OPCION3:                                    ; TERMINA EL PROGRAMA
    TerminarPrograma

HorasAMS Proc Near
    InicializaVariable ResultaR             ; Inserta el caracter $ en la variable ResultaR
    Multiplicar CantR
    MOV CantMin, AX                         ; Guarda el resultado de la multiplicación para obtener los segundos
    Call ConvASCII                          ; Convierte en ASCII
    Imprime Resulta1                        ; Prepara para desplegar la cadena del resultado
    Imprime ResultaR                        ; Despliega el resultado de las MINUTOS

    InicializaVariable ResultaR             ; Inserta el caracter $ en la variable ResultaR

    Multiplicar CantMin
    Call ConvASCII
    Imprime Resulta2                        ; Prepara para desplegar la cadena del resultado
    Imprime ResultaR                        ; Despliega el resultado de los SEGUNDOS
    Ret
HorasAMS Endp

MinutosAH Proc Near
    InicializaVariable ResultaR             ; Inserta el caracter $ en la variable ResultaR
    Dividir CantR
    Call ConvASCII                          ; Convierte en ASCII
    Imprime Resulta3                        ; Despliega la cadena del resultado
    Imprime ResultaR                        ; Despliega el resultado
    Ret
MinutosAH Endp

; PROCEDURES ---------------------------------------------------------------------
Captura PROC Near
CAPCANT:                                    ; Captura una cantidad (minutos o horas)
    Mov Ah,0Ah                        ; Captura la cantidad (hasta 8 digitos)
    Mov Dx,Offset CantN
    Int 21h                           ; fila 120
    Mov ErrorCAP,0                    ; Supone que no hay errores y que se esta operando
    Call ConvNUM                      ; Convierte cantidad 1 a binario
    Cmp ErrorCAP,1                    ; ¿Hubo error?
    Jz CAPCANT                      ; Si, regresa a la captura
    Mov CantR,Bx                   ; Guarda resultado de conversión
Captura Endp

ConvNUM Proc Near
    Mov Dx, 0Ah                      ; Multiplicador es 10
    Mov Di, Offset CantN + 1         ; Bytes leídos de la cantidad 1
    Mov Cx, [Di]                     ; fila 300
    Mov Si, Offset CantN + 2         ; La cantidad 1
    Jmp CONVNUM02

CONVNUM02:
    Xor Ch, Ch                       ; Ch=0
    Mov Di, Offset Potencia          ; Dirección de la tabla de potencias
    Dec Si                            ; Posición si en el primer byte de la cadena capturada
    Add Si, Cx                        ; Le suma el desplazamiento de bytes leídos.

    Xor Bx, Bx
    Std                               ; Limpiamos el indicador de dirección
CONVNUM03:
    Lodsb                             ; Levanta un byte del número
    Cmp Al, "0"                       ; ¿Es menor que '0'? (entonces no es un dígito válido)
    Jb CONVNUM04                      ; Si, despliega el mensaje de error y termina
    Cmp Al, "9"                       ; ¿Es mayor que '9'? (entonces no es un dígito válido)
    Ja CONVNUM04                      ; Si, despliega el error y salta
    Sub Al, 30h                       ; Convierte el dígito de ASCII a binario
    Cbw                               ; Convierte a palabra
    Mov Dx, [Di]                      ; Obtiene la potencia de 10 que será usada para
    Mul Dx                            ; Multiplicar, multiplica número y lo suma
    Jc CONVNUM05
    Add Bx, Ax                        ; Si hay acarreo la cantidad es >65535
    Jc CONVNUM05
    Add Di, 2                         ; Va a la siguiente potencia de 10
    Loop CONVNUM03                    ; Itera hasta que CX sea = 0 //fila 330
    Jmp CONVNUM06

CONVNUM04:
    Call HuboERROR                    ; Algo ocurrió, despliega mensaje y salta
    Jmp CONVNUM06

CONVNUM05:
    Mov Cantidad, 2
    Call HuboERROR

CONVNUM06:
    Cld
    Ret
ConvNUM Endp


ConvASCII Proc Near
    Push Dx
    Push Ax                                 ; Guarda el resultado
    Mov Si,Offset ResultaR                  ; Inicializa la variable resultarllenandola
    Mov CX,10                               ; Con asteriscos
    Mov Al,'*'

CONVASCII01:
    Mov [Si],Al                             ; fila 400
    Inc Si
    Loop CONVASCII01
    Pop Ax
    Pop Dx
    Mov Bx,Ax                               ; Palabra baja de la cantidad
    Mov Ax,Dx                               ; Palabra alta de la cantidad
    Mov Si,Offset ResultaR                  ; Cadena donde se guardara el resultado
    Add Si,11
    Mov Cx,10                               ; Divisor =10
OBTENDIGITO:
    Dec Si
    Xor Dx,Dx                               ; Dx contendra el residuo
    Div Cx                                  ; Divide la palabra alta (Ax)
    Mov Di,Ax                               ; Guarda cociente (Ax)
    Mov Ax,Bx                               ; Ax = palabra baja (Bx)
    Div Cx                                  ; Dx tenia un residuo de la division anterior
    Mov Bx,Ax                               ; Guarda el cociente
    Mov Ax,Di                               ; Regresa la palabra alta
    Add Dl,30h                              ; Convierte residuo en ASCII
    Mov [Si],Dl                             ; Lo almacena
    Or Ax,Ax                                ; ¿Palabra alta es 0?
    Jnz OBTENDIGITO                         ; No, sigue procesando ERROOOOOOOOOOOOR
    Or Bx,Bx                                ; ¿Palabra baja es 0?
    Jnz OBTENDIGITO                         ; No, sigue procesando
    Ret
ConvASCII Endp

HuboERROR Proc Near
    Cmp Cantidad,0                          ; ¿Es la cantidad 1?
    Jnz HUBOERROR02                         ; No
    Imprime Error1
    Mov ErrorCAP,1                          ; Enciende la bandera de error
    Jmp HUBOERROR04
HUBOERROR02:
    Cmp Cantidad,1                          ; ¿Cantidad capturada esta fuera de rango?
    Jnz HUBOERROR03                         ; No /fila 450
    Imprime Error2
    Mov ErrorCAP,1
    Jmp HUBOERROR04
HUBOERROR03:
    Imprime Error3
    Mov ErrorCAP,1
HUBOERROR04:
    Ret
HuboERROR Endp

    .STACK
    End Empieza                             ; fila 463