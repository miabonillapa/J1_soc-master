( Hardware port assignments )

h# FF00 constant mult_a  \ no cambiar estos tres
h# FF02 constant mult_b  \ hacen parte de otras
h# FF04 constant mult_p  \ definiciones

\ memory map config:
h# 6700 constant config_capture	
h# 6702 constant config_dataout_high
h# 6704 constant config_dataout_mid
h# 6706 constant config_dataout_low
h# 6708 constant config_done

\ memory map uart:
h# 6900 constant uart_busy    \ para lectura de uart (uart_busy)
h# 6902 constant uart_data    \ escritura de datos que van a la uart
h# 6904 constant led     \ led-independiente , se lo deja dentro del mapa de memoria de la uart



