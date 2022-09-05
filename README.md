# CIDR

Aplicación para cálculo CIDR para las plataformas
 * Android
 * iOS
 * Windows
 * MacOS
 * Linux
## ¿Qué es CIDR?

CIDR es un estándar de red para la interpretación de direcciones IP. CIDR facilita el encaminamiento al permitir agrupar bloques de direcciones en una sola entrada de la tabla de rutas. Estos grupos, llamados comúnmente Bloques CIDR, comparten una misma secuencia inicial de bits en la representación binaria de sus direcciones IP.

Los bloques CIDR IPv4 se identifican usando una sintaxis similar a la de las direcciones IPv4: cuatro números decimales separados por puntos, seguidos de una barra de división y un número de 0 a 32; A.B.C.D/N.

Los primeros cuatro números decimales se interpretan como una dirección IPv4, y el número tras la barra es la longitud de prefijo, contando desde la izquierda, y representa el número de bits comunes a todas las direcciones incluidas en el bloque CIDR.

Decimos que una dirección IP está incluida en un bloque CIDR, y que encaja con el prefijo CIDR, si los N bits iniciales de la dirección y el prefijo son iguales. Por tanto, para entender CIDR es necesario visualizar la dirección IP en binario. Dado que la longitud de una dirección IPv4 es fija, de 32 bits, un prefijo CIDR de N-bits deja 32 − N {\displaystyle 32-N} 32-N bits sin encajar, y hay 2 ( 32 − N ) {\displaystyle 2^{(32-N)}} 2^{{(32-N)}} combinaciones posibles con los bits restantes. Esto quiere decir que 2 ( 32 − N ) {\displaystyle 2^{(32-N)}} 2^{{(32-N)}} direcciones IPv4 encajan en un prefijo CIDR de N-bits.

Nótese que los prefijos CIDR cortos (números cercanos a 0) permiten encajar un mayor número de direcciones IP, mientras que prefijos CIDR largos (números cercanos a 32) permiten encajar menos direcciones IP.

Una dirección IP puede encajar en varios prefijos CIDR de longitudes diferentes.

CIDR también se usa con direcciones IPv6, en las que la longitud del prefijo varia desde 0 a 128, debido a la mayor longitud de bit en las direcciones, con respecto a IPv4. En el caso de IPv6 se usa una sintaxis similar a la comentada: el prefijo se escribe como una dirección IPv6, seguida de una barra y el número de bits significativos. 