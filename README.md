# Juego-de-Dados-ASM
Recuperación Integral de laboratorio de la asignatura Sistema con Microprocesadores y Microcontroladores
## Ejercicios a resolver
- Se debe implementar un juego para dos jugadores donde cada uno lanza un dado virtual una única vez. Gana el jugador que obtenga el número mas alto.
- Diseñar un programa que muestre en un display una cuenta ascendente cíclica de 1 a 6. Esta cuenta debe repetirse continuamente y completarse en 1 segundo o menos. Todos los displays deben mostrar el mismo número simultaneamente.
- La tecla Aceptar corresponderá al Jugador 1. Cuando la presione, el número mostrado en los
displays quedará fijo por un tiempo definido (entre 3 y 6 segundos) y se registrará como su
resultado en el dado. La tecla Cancelar corresponderá al Jugador 2. Cuando la presione, el
número mostrado en los displays también quedará fijo (por 3 a 6 segundos) y se registrará
como su resultado.
- Una vez que ambos jugadores hayan realizado su tirada, los displays mostrarán el número
del jugador que ganó (1 o 2). Además, se encenderá un punto en el display para indicar
que el valor mostrado corresponde al número del jugador y no a una tirada del dado.
- Para hacer la tirada más impredecible, se utilizarán los 3 bits menos significativos de un
contador de ejecución libre (Free Running Counter) a alta frecuencia. Cuando un jugador
presione su botón, se tomará el número en el que se detuvo el dado y se le sumará el valor
obtenido de los 3 bits del contador (un número entre 0 y 7). El dado continuará girando
normalmente hasta alcanzar este nuevo valor, momento en el que se detendrá y mostrará
el resultado final del jugador. Si la suma excede 6, se ajustará dentro del rango de valores
posibles del dado (1-6).
- Una vez mostrado el jugador que gano, el juego se reinicia automáticamente y comienza de
nuevo a la espera de la presión del botón de ambos jugadores.

## Configuración de botones y displays
| Dispositivo  | Terminal | Función     |
|:------------:|:--------:|:-----------:|
| ACEPTAR      | P3_1       | 4:GPIO5[8]      |
| CANCELAR     | P3_2       | 4:GPIO5[9]|
|         | | |
| SEG_A |P4_0| 0:GPIO2[0]|
| SEG_B |P4_1| 0:GPIO2[1]|
| SEG_C |P4_2| 0:GPIO2[2]|
| SEG_D |P4_3| 0:GPIO2[3]|
| SEG_E |P4_4| 0:GPIO2[4]|
| SEG_F |P4_5| 0:GPIO2[5]|
| SEG_G |P4_6| 0:GPIO2[6]|
| SEG_DP |P6_8| 4:GPIO5[16]|
---
 Para compilar un proyecto se debe definir el nombre del archivo con la ruta en el archivo proyecto.mk y despues utilizar el comando 'make'