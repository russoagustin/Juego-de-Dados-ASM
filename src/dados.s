/*
    RECUPERACIÓN DE LABORATORIO 2025
    SISTEMAS CON MICROPROCESADORES Y MICROCONTROLADORES
    ALUMNO: RUSSO FRANCISCO AGUSTIN
*/

    .cpu cortex-m4          // Indica el procesador de destino
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"
    .include "configuraciones/rutinas.s"

/****************************************************************************/
/* Definiciones de macros                                                   */
/****************************************************************************/
    //DEFINICION DE SEGMENTOS---------------
    .equ SEG_GPIO, 2
    // SEGMENTO A
    .equ SEG_A_PORT, 4
    .equ SEG_A_PIN, 0
    .equ SEG_A_BIT, 0
    .equ SEG_A_MASK, (1 << SEG_A_BIT)
    .equ SEG_A_OFFSET, ( SEG_GPIO << 2)

    //----SEGMENTO B ----
    .equ SEG_B_PORT, 4
    .equ SEG_B_PIN, 1
    .equ SEG_B_BIT, 1
    .equ SEG_B_MASK, (1 << SEG_B_BIT)
    .equ SEG_B_OFFSET, ( SEG_GPIO << 2)

    //----SEGMENTO C----
    .equ SEG_C_PORT, 4
    .equ SEG_C_PIN, 2
    .equ SEG_C_BIT, 2
    .equ SEG_C_MASK, (1 << SEG_C_BIT)
    .equ SEG_C_OFFSET, ( SEG_GPIO << 2)

    //----SEGMENTO D----
    .equ SEG_D_PORT, 4
    .equ SEG_D_PIN, 3
    .equ SEG_D_BIT, 3
    .equ SEG_D_MASK, (1 << SEG_D_BIT)
    .equ SEG_D_OFFSET, ( SEG_GPIO << 2)

    //----SEGMENTO E----
    .equ SEG_E_PORT, 4
    .equ SEG_E_PIN, 4
    .equ SEG_E_BIT, 4
    .equ SEG_E_MASK, (1 << SEG_E_BIT)
    .equ SEG_E_OFFSET, ( SEG_GPIO << 2)

    // SEGMENTO F
    .equ SEG_F_PORT, 4
    .equ SEG_F_PIN, 5
    .equ SEG_F_BIT, 5
    .equ SEG_F_MASK, (1 << SEG_F_BIT)
    .equ SEG_F_OFFSET, ( SEG_GPIO << 2)

    // SEGMENTO G
    .equ SEG_G_PORT, 4
    .equ SEG_G_PIN, 6
    .equ SEG_G_BIT, 6
    .equ SEG_G_MASK, (1 << SEG_G_BIT)
    .equ SEG_G_OFFSET, ( SEG_GPIO << 2)

    .equ SEG_PORT, 4
    .equ SEG_N_OFFSET, (SEG_GPIO << 2)
    .equ SEG_N_MASK, ( SEG_A_MASK | SEG_B_MASK | SEG_C_MASK | SEG_D_MASK | SEG_E_MASK | SEG_F_MASK | SEG_G_MASK )

    // Recursos utilizados por el punto del display
    .equ LED_GPIO,      5
    .equ LED_BIT,       16
    .equ LED_PORT,      6
    .equ LED_PIN,       8
    .equ LED_MASK,      (1<<LED_BIT) 
    .equ LED_OFFSET,    (LED_GPIO << 2)

    // Recursos utilizados por la primera tecla
    .equ TEC_A_PORT, 3
    .equ TEC_A_PIN, 1
    .equ TEC_A_BIT, 8
    .equ TEC_A_MASK, (1 << TEC_A_BIT)

    .equ TEC_C_PORT, 3
    .equ TEC_C_PIN, 2
    .equ TEC_C_BIT, 9
    .equ TEC_C_MASK, (1 << TEC_C_BIT)

    
    .equ TEC_GPIO, 5
    .equ TEC_OFFSET, ( TEC_GPIO << 2)


    .equ NUM_DADO, 0
    .equ J1, 1          //RESULTADO OBTENIDO POR EL JUGADOR 1 AL DETENER EL DADO
    .equ J2, 2          //RESULTADO OBTENIDO POR EL JUGADOR 2 AL DETENER EL DADO
    .equ J1_FINAL,3     //RESULTADO FINAL AL SUMARLE NÚMERO ALEATORIO DEL CONTADOR
    .equ J2_FINAL,4     //RESULTADO FINAL AL SUMARLE NÚMERO ALEATORIO DEL CONTADOR
    .equ GANADOR,5      //CONTIENE EL NÚMERO DEL JUGADOR GANADOR
                        // 0 -> TODAVIA NO HAY GANADOR
                        // 1 -> GANA JUGADOR 1 | 2 -> GANA JUGADOR 2
                        // 3 -> EMPATE
                        

    .equ COUNT, 0       //MIENTRAS SEA MAYOR QUE 0  MUESTRA EL RESULTADO DE UN JUGADOR O EL GANADOR ESTE VALOR SE DECREMENTA EN CADA INTERRUPCIÓN DEL SYSTICK
    .equ PLAYER,1       //ULTIMO JUGADOR EN APRETAR EL BOTON
    .equ FINAL, 2       // 0 -> MUESTRA J1 | 1 -> MUESTRA J1_FINAL
    .equ SHOW_RESULT, 3 //CUANDO SEA 2 INDICA QUE YA LOS DOS JUGADORES TIRARON LOS DADOS Y SE PUEDE MOSTRAR EL RESULTADO

    .equ RESULT_TIME, 20    //CONSTANTE CON LA QUE SE CARGA COUNT EQUIVALE A UN TIEMPO DE 3.2 SEGUNDOS.
/****************************************************************************/
/* Vector de interrupciones                                                 */
/****************************************************************************/
    .section .isr           // Define una seccion especial para el vector
    .word   stack           //  0: Initial stack pointer value
    .word   reset+1         //  1: Initial program counter value
    .word   handler+1       //  2: Non mascarable interrupt service routine
    .word   handler+1       //  3: Hard fault system trap service routine
    .word   handler+1       //  4: Memory manager system trap service routine
    .word   handler+1       //  5: Bus fault system trap service routine
    .word   handler+1       //  6: Usage fault system tram service routine
    .word   0               //  7: Reserved entry
    .word   0               //  8: Reserved entry
    .word   0               //  9: Reserved entry
    .word   0               // 10: Reserved entry
    .word   handler+1       // 11: System service call trap service routine
    .word   0               // 12: Reserved entry
    .word   0               // 13: Reserved entry
    .word   handler+1       // 14: Pending service system trap service routine
    .word   systick_isr+1       // 15: System tick service routine
    .word   handler+1       // 16: IRQ 0: DAC service routine
    .word   handler+1       // 17: IRQ 1: M0APP service routine
    .word   handler+1       // 18: IRQ 2: DMA service routine
    .word   0               // 19: Reserved entry
    .word   handler+1       // 20: IRQ 4: FLASHEEPROM service routine
    .word   handler+1       // 21: IRQ 5: ETHERNET service routine
    .word   handler+1       // 22: IRQ 6: SDIO service routine
    .word   handler+1       // 23: IRQ 7: LCD service routine
    .word   handler+1       // 24: IRQ 8: USB0 service routine
    .word   handler+1       // 25: IRQ 9: USB1 service routine
    .word   handler+1       // 26: IRQ 10: SCT service routine
    .word   handler+1       // 27: IRQ 11: RTIMER service routine
    .word   handler+1       // 28: IRQ 12: TIMER0 service routine
    .word   handler+1       // 29: IRQ 13: TIMER1 service routine
    .word   handler+1     // 30: IRQ 14: TIMER2 service routine
    .word   handler+1       // 31: IRQ 15: TIMER3 service routine
    .word   handler+1       // 32: IRQ 16: MCPWM service routine
    .word   handler+1       // 33: IRQ 17: ADC0 service routine
    .word   handler+1       // 34: IRQ 18: I2C0 service routine
    .word   handler+1       // 35: IRQ 19: I2C1 service routine
    .word   handler+1       // 36: IRQ 20: SPI service routine
    .word   handler+1       // 37: IRQ 21: ADC1 service routine
    .word   handler+1       // 38: IRQ 22: SSP0 service routine
    .word   handler+1       // 39: IRQ 23: SSP1 service routine
    .word   handler+1       // 40: IRQ 24: USART0 service routine
    .word   handler+1       // 41: IRQ 25: UART1 service routine
    .word   handler+1       // 42: IRQ 26: USART2 service routine
    .word   handler+1       // 43: IRQ 27: USART3 service routine
    .word   handler+1       // 44: IRQ 28: I2S0 service routine
    .word   handler+1       // 45: IRQ 29: I2S1 service routine
    .word   handler+1       // 46: IRQ 30: SPIFI service routine
    .word   handler+1       // 47: IRQ 31: SGPIO service routine
    .word   handler+1       // 48: IRQ 32: PIN_INT0 service routine
    .word   handler+1       // 49: IRQ 33: PIN_INT1 service routine
    .word   handler+1       // 50: IRQ 34: PIN_INT2 service routine
    .word   handler+1       // 51: IRQ 35: PIN_INT3 service routine
    .word   handler+1       // 52: IRQ 36: PIN_INT4 service routine
    .word   handler+1       // 53: IRQ 37: PIN_INT5 service routine
    .word   handler+1       // 54: IRQ 38: PIN_INT6 service routine
    .word   handler+1       // 55: IRQ 39: PIN_INT7 service routine
    .word   handler+1       // 56: IRQ 40: GINT0 service routine
    .word   handler+1       // 56: IRQ 40: GINT1 service routine

//VARIABLES
    .section .data
    variables:
        .byte 1,0,0,0,0,0         // ARREGLO DONDE EL PRIMER ELEMENTO ES EL NUMERO DEL DADO
                            // EL SEGUNDO ES EL RESULTADO DEL J1 Y EL SIGUIENTE DEL J2.    
    control_data:
        .byte 0,0,0,0


//MAIN
    .global reset
    .section .text
.func main
    reset:
    CPSID I // Se deshabilitan globalmente las interrupciones
    // Mueve el vector de interrupciones al principio de la segunda RAM
    LDR R1,=VTOR
    LDR R0,=#0x10080000
    STR R0,[R1]

    MOV R0,#5
    MSR BASEPRI, R0

    BL inicializar_seg      //configuro los displays
    BL inicializar_teclas   //configuro los botones
    BL inicializar_timer0    //configuro el timer en free running
    BL inicializar_systick  //configuro el systick para actualizar los displays
    CPSIE I // Se habilitan globalmente las interrupciones
    
lazo: 
    LDR R6,=control_data
    LDRB R7,[R6,#SHOW_RESULT]
    CMP R7,#2
    BEQ resultado
//-----POLLING PARA SABER SI SE PRESIONÓ UN BOTON----

    LDR R1,=GPIO_PIN0
    LDR R0,[R1,#TEC_OFFSET]
    TST R0,#TEC_A_MASK
    BEQ tecla_c

    LDR R4,=variables
    LDRB R5,[R4,#J1]
    CMP R5,#0
    BGT tecla_c

    MOV R3,#1
    BL obtener_valor_dado
    BL obtener_valor_final

    B lazo

    tecla_c:
    TST R0,#TEC_C_MASK
    BEQ lazo

    LDRB R5,[R4,#J2]
    CMP R5,#0
    BGT lazo

    MOV R3,#2
    BL obtener_valor_dado
    BL obtener_valor_final
//--------------------------------------------------
    B lazo

    resultado:
    LDR R7,=RESULT_TIME
    STRB R7,[R6,#COUNT]
    MOV R7,#0
    STRB R7,[R6,#SHOW_RESULT]
    BL obtener_ganador

    B lazo
.pool
.endfunc

/*Recibe en registro R3 el jugador el cual se quiere obtener el valor del dado */
.func obtener_valor_dado
obtener_valor_dado:
    CPSID I
    LDR R0,=variables
    LDRB R1,[R0]
    STRB R1,[R0,R3]             //GUARDO EL VALOR DEL DADO EN EL ESPACIO CORRESPONDIENTE AL JUGADOR.

    LDR R0,=control_data
    LDR R1,=RESULT_TIME
    STRB R1,[R0,#COUNT]
    STRB R3,[R0,#PLAYER]       //GUARDO EN VARIABLE GLOBAL CUAL FUE EL ÚLTIMO JUGADOR EN PRESIONAR EL BOTON.

    CPSIE I // Se habilitan globalmente las interrupciones
    BX LR
.pool
.endfunc


/*
    Subrutina que calcula el valor final de la jugada de un jugador 
    a través del valor del contador.
    realiza la cuenta (DADO + TC -1) MOD 6 + 1
 */
.func obtener_valor_final
obtener_valor_final:
    PUSH {R4,LR}
    LDR R0,=TIMER0_BASE
    LDR R1,[R0,#TC]     //OBTENGO EL VALOR ACTUAL DEL TIMER COUNTER
    AND R1,#0x07        //ENMASCARO PARA OBTENER LOS TRES PRIMEROS BITS


    LDR R0,=variables
    LDRB R2,[R0,R3]         //RESULTADO DE TIRAR EL DADO DEL ULTIMO EN PRESIONAR EL BOTON

    ADD R2, R1              //AL RESULTADO DEL DADO LE SUMO EL TIMER
    SUB R2,#1               //RESTO 1 (R2 = DADO + TIMER - 1)

    MOV R1,#6               //PONGO 6 EN EL REGISTRO R1.
    UDIV R3,R2,R1           // R3 = DADO + TIMER / 6
    MUL R4,R3,R1            // R4 = R3 * R1
    SUB R2,R2,R4            // R2 = (DADO + TIMER - 1) mod 6.
    ADD R2,#1               // SUMO 1 PARA OBTENER EL RESULTADO FINAL.

    LDR R1,=control_data
    LDRB R4,[R1,#PLAYER]     //OBTENGO EL JUGADOR ACTUAL
    ADD R4,#2
    STRB R2,[R0,R4]
   
    POP {R4,PC}
.pool
.endfunc

.func obtener_ganador
obtener_ganador:
    LDR R0,=variables
    LDRB R1,[R0,#J1_FINAL]
    LDRB R2,[R0,#J2_FINAL]
    CMP R1,R2
    BEQ empate

    ITE GT
    MOVGT R3,#1
    MOVLE R3,#2

    STRB R3,[R0,#GANADOR]
    BX LR

    empate:
    MOV R3,#3
    STRB R3,[R0,#GANADOR]
.pool
.endfunc

.func actualizar_pantalla
actualizar_pantalla:
    PUSH {R4,R5,LR}

    LDR R0,=control_data
    LDRB R1,[R0,#COUNT]    //OBTENGO EL VALOR DEL CONTADOR. SI ES MAYOR QUE 0 SIGNIFICA QUE DEBO MOSTRAR EL NUM DADO OBTENIDO POR UN JUGADOR
    CMP R1,#0
    BGT mostrar_resultados

    //MOSTRAR NUMS DEL 1 AL 6
    BL mostrar_dado

    LDR R4,=control_data
    LDRB R5,[R4,#FINAL]
    CMP R5,#0
    BEQ seguir

    LDRB R5,[R4,#PLAYER]    //OBTENGO PLAYER ACTUAL
    ADD R5,#2
    LDRB R5,[R0,R5]     //NÚMERO FINAL DEL PLAYER ACTUAL
    CMP R5,R2           //COMPARO CON EL NÚMERO ACTUAL DEL DADO.
    ITT EQ
    LDREQ R5,=RESULT_TIME
    STRBEQ R5,[R4,#COUNT] //AUMENTO EL CONTADOR PARA MOSTRAR EL RESULTADO

    seguir:
    BL girar_dado
    POP {R4,R5,PC}

    // MOSTRAR NUM DE DADO OBTENIDO POR EL JUGADOR
    mostrar_resultados:

    LDR R0,=control_data
    LDR R3,=variables
    LDRB R4,[R3,#GANADOR]   //verifica si ya hay un ganador
    CMP R4, #0
    BGT ganador

    LDRB R1,[R0,#FINAL]  //controla si se debe mostrar el resultado final o el del dado
    CMP R1,#0
    BGT mostrar_final   //si la variable FINAL es mayor que 1 se muestra final

    LDRB R1,[R0,#PLAYER]    
    ADD R3,R1           //Obtengo la dirección de memoria del dato correspondiente al PLAYER actual
    BL mostrar_jugador  //muestro el dado obtenido por el player.
    POP {R4,R5,PC}

    mostrar_final:
    LDRB R1,[R0,#PLAYER]    //OBTENGO EL PLAYER ACTUAL
    ADD R1,#2               
    ADD R3,R1               //DIR DEL DATO
    BL mostrar_resultado_final
    POP {R4,R5,PC}

    ganador:
    BL mostrar_ganador
    POP {R4,R5,PC}
.pool
.endfunc

.func mostrar_dado
mostrar_dado:
    LDR R0,=variables
    LDR R1,=tabla
    LDRB R2,[R0]         //OBTENGO EL VALOR DEL DADO ACTUAL
    LDRB R3,[R1,R2]      //OBTENGO EL VALOR EN 7 SEGMENTOS

    LDR R1,=GPIO_PIN0
    STR R3,[R1,#SEG_N_OFFSET]  //ENCIENDO LOS SEGMENTOS
    BX LR
.pool
.endfunc

.func girar_dado
girar_dado:
    LDR R0,=variables
    LDR R1,=tabla
    LDRB R2,[R0,#NUM_DADO]         //OBTENGO EL VALOR DEL DADO ACTUAL
    ADD R2,#1
    CMP R2,#6
    IT GT
    MOVGT R2,#1
    STRB R2,[R0,#NUM_DADO]
    BX LR
.pool
.endfunc

/**
  RECIBE EN R3 LA DIRECCIÓN DE MEMORIA DEL DATO QUE DEBE MOSTRAR. POR 3 SEGUNDOS
  */
.func mostrar_jugador
mostrar_jugador:
    PUSH {LR}
    LDR R0,=control_data
    LDRB R1,[R0,#COUNT]         //OBTENGO EL VALOR DEL CONTADOR
    SUB R1,#1
    STRB R1,[R0,#COUNT]         //DECREMENTO Y GUARDO EL VALOR
    CMP R1,#0
    BEQ final                   //SI ES LA ULTIMA ITERACIÓN VA A FINAL

    LDR R0,=variables
    LDR R1,=tabla
    LDRB R2,[R3]            //OBTENGO EL VALOR DEL DATO A MOSTRAR.
    LDRB R2,[R1,R2]             //OBTENGO EL VALOR EN 7 SEGMENTOS
    LDR R0,=GPIO_PIN0
    STR R2,[R0,#SEG_N_OFFSET]   //ENCIENDO LOS SEGMENTOS
    POP {PC}

    final:
    LDR R0,=control_data
    MOV R1,#1
    STRB R1,[R0,#FINAL] //ACTUALIZA FINAL PARA QUE AHORA MUESTRE EL RESULTADO FINAL
    POP {PC}
.pool
.endfunc

.func mostrar_resultado_final
mostrar_resultado_final:
    PUSH {LR}
    LDR R0,=control_data
    LDRB R1,[R0,#COUNT]         //OBTENGO EL VALOR DEL CONTADOR
    SUB R1,#1
    STRB R1,[R0,#COUNT]         //DECREMENTO Y GUARDO EL VALOR
    CMP R1,#0
    BEQ final_ 

    LDR R0,=variables
    LDR R1,=tabla
    LDRB R2,[R3]            //OBTENGO EL VALOR DEL DATO A MOSTRAR.
    LDRB R2,[R1,R2]             //OBTENGO EL VALOR EN 7 SEGMENTOS
    LDR R0,=GPIO_NOT0
    STR R2,[R0,#SEG_N_OFFSET]   //ENCIENDO LOS SEGMENTOS
    POP {PC}

    final_:
    LDR R0,=control_data
    MOV R1,#0
    STRB R1,[R0,#FINAL] //ACTUALIZA FINAL
    LDRB R1,[R0,#SHOW_RESULT]
    ADD R1, #1
    STRB R1,[R0,#SHOW_RESULT]
    POP {PC}

.pool
.endfunc

.func mostrar_ganador
mostrar_ganador:
    PUSH {LR}
    LDR R0,=control_data
    LDRB R1,[R0,#COUNT]         //OBTENGO EL VALOR DEL CONTADOR
    SUB R1,#1
    STRB R1,[R0,#COUNT]         //DECREMENTO Y GUARDO EL VALOR
    CMP R1,#0
    BEQ final__ 

    LDR R0,=variables
    LDR R1,=tabla
    LDRB R2,[R0,#GANADOR]        //OBTENGO EL VALOR DEL DATO A MOSTRAR.
    CMP R2,#3
    ITE EQ
    MOVEQ R2,#0x79              //CASO DE EMPATE MUESTRO - - - - 
    LDRBNE R2,[R1,R2]             //OBTENGO EL VALOR EN 7 SEGMENTOS

    LDR R0,=GPIO_PIN0
    STR R2,[R0,#SEG_N_OFFSET]   //ENCIENDO LOS SEGMENTOS
    LDR R0,=GPIO_NOT0
    LDR R2,=LED_MASK
    STR R2,[R0,#LED_OFFSET]   //ENCIENDO LOS SEGMENTOS
    POP {PC}

    final__:
    BL reiniciar_variables

    LDR R0,=GPIO_CLR0
    LDR R2,=LED_MASK            //APAGO EL PUNTO DE LOS DISPLAYS      
    STR R2,[R0,#LED_OFFSET]

    POP {PC}
.pool
.endfunc

.func reiniciar_variables
reiniciar_variables:
    LDR R0,=control_data
    MOV R1,#0
    STRB R1,[R0,#COUNT] 
    STRB R1,[R0,#PLAYER]
    STRB R1,[R0,#FINAL]
    STRB R1,[R0,#SHOW_RESULT]
    
    LDR R0,=variables
    STRB R1,[R0,#J1]
    STRB R1,[R0,#J2]
    STRB R1,[R0,#J1_FINAL]
    STRB R1,[R0,#J2_FINAL]
    STRB R1,[R0,#GANADOR]

    BX LR
.pool
.endfunc

.func inicializar_seg
inicializar_seg:
    LDR R1,=SCU_BASE
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(4 * (32 * SEG_PORT + SEG_A_PIN))]
    STR R0,[R1,#(4 * (32 * SEG_PORT + SEG_B_PIN))]
    STR R0,[R1,#(4 * (32 * SEG_PORT + SEG_C_PIN))]
    STR R0,[R1,#(4 * (32 * SEG_PORT + SEG_D_PIN))]
    STR R0,[R1,#(4 * (32 * SEG_PORT + SEG_E_PIN))]
    STR R0,[R1,#(4 * (32 * SEG_PORT + SEG_F_PIN))]
    STR R0,[R1,#(4 * (32 * SEG_PORT + SEG_G_PIN))]

    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)
    STR R0,[R1,#(LED_PORT << 7 | LED_PIN << 2)]
    
    //APAGO TODOS LOS SEGMENTOS Y EL PUNTO.
    LDR R1,=GPIO_CLR0
    LDR R0,=SEG_N_MASK
    STR R0,[R1,#SEG_N_OFFSET]
    LDR R0,=LED_MASK
    STR R0,[R1,#LED_OFFSET]

    LDR R1,=GPIO_DIR0 //REGISTRO PARA DEFINIR ENTRADAS Y SALIDAS.
    // Configura los bits gpio de los segmentos como salidas
    LDR R0,[R1,#SEG_N_OFFSET]
    ORR R0,#SEG_N_MASK
    STR R0,[R1,#SEG_N_OFFSET]

    LDR R0,[R1,#LED_OFFSET]
    ORR R0,#LED_MASK
    STR R0,[R1,#LED_OFFSET]

    BX LR
.pool
.endfunc

.func inicializar_teclas
inicializar_teclas:
    LDR R1,=SCU_BASE
    MOV R0,#(SCU_MODE_PULLUP | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS |SCU_MODE_FUNC4)

    STR R0,[R1,#(4*(32 * TEC_A_PORT + TEC_A_PIN))]
    STR R0,[R1,#(4*(32 * TEC_C_PORT + TEC_C_PIN))]

    LDR R1,=GPIO_DIR0 //REGISTRO PARA DEFINIR ENTRADAS Y SALIDAS.
    // Configura los bits gpio de los botones como entradas\
    LDR R0,[R1,#TEC_OFFSET]
    BIC R0,#(TEC_C_MASK | TEC_A_MASK)
    STR R0,[R1,#TEC_OFFSET]
    
    BX LR
.pool
.endfunc

.func inicializar_timer0
inicializar_timer0:
    LDR R0,=#TIMER0_BASE    //APUNTA AL TIMER 0
    MOV R1,#0x00            
    STR R1,[R0,#CTCR]       //CONFIGURO PARA FUNCIONAR CON EL RELOJ INTERNO

    STR R1,[R0,#MCR]        //SIN INT. POR MATCH

    STR R1,[R0,#PR]         //PRESCALER EN 0X00.

    MOV R1,#0x01
    STR R1,[R0,#TCR]        //EMPIEZA LA CUENTA
.pool
.endfunc

.func inicializar_systick
inicializar_systick:
    // Se sonfigura prioridad de la interrupcion
    LDR R1,=SHPR3 // Se apunta al registro de prioridades
    LDR R0,[R1] // Se cargan las prioridades actuales
    MOV R2,#3 // Se fija la prioridad en 3
    BFI R0,R2,#29,#3 // Se inserta el valor en el campo
    STR R0,[R1] // Se actualizan las prioridades

    // Se habilita el SysTick con el reloj del nucleo   
    LDR R1,=SYST_CSR
    MOV R0,#0x00
    STR R0,[R1] // Se quita el bit ENABLE

    // SE CONFIGURA PARA UN PERIODO DE 0.16s
    LDR R1,=SYST_RVR
    LDR R0,=#(12800000)
    STR R0,[R1] // Se especifica el valor de RELOAD
    // Se inicializa el valor actual del contador
    LDR R1,=SYST_CVR
    MOV R0,#0
    // Escribir cualquier valor limpia el contador
    STR R0,[R1] // Se limpia COUNTER y flag COUNT
    // Se habilita el SysTick con el reloj del nucleo
    LDR R1,=SYST_CSR
    MOV R0,#0x07
    STR R0,[R1] // Se fijan ENABLE, TICKINT y CLOCK_SRC

    BX LR // Se retorna al programa principal
.pool
.endfunc

.func systick_isr
systick_isr:
    PUSH {LR}
    BL actualizar_pantalla
    POP {PC}
.pool
.endfunc


.func handler    
handler:
    LDR R0,=set_led_1       // Apuntar al incio de una subrutina lejana
    BLX R0                  // Llamar a la rutina para encender el led rojo
    B handler               // Lazo infinito para detener la ejecucion
.pool                   // Almacenar las constantes de codigo
.endfunc

//TABLA DE CONVERSIÓN A 7 SEGMENTOS 
.pool
tabla:
    .byte 0x3F,0x06,0x5b,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x67
