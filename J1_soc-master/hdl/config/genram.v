module genram(clk, addr, rw, data_in, data_out, en, cen);

               //-- Puertos
         input clk;                      //-- Señal de reloj global
         input [16: 0] addr;      //-- Direcciones
         input rw;                  //-- Modo lectura (0) o escritura (1)
         input [23: 0] data_in;   //-- Dato de entrada
         input en;                    // -- Control 
         input cen;                   // -- Contador enable
         output reg [23: 0] data_out; //-- Dato a escribir
          

//-- Parametro: Nombre del fichero con el contenido de la RAM
parameter ROMFILE = "datos.list";

  //-- Memoria
  reg [7:0] ramR [0:102399];
  reg [7:0] ramG [0:102399];
  reg [7:0] ramB [0:102399]; 

    //-- Lectura de la memoria
    always @(posedge en) begin

      if (rw == 0)
      data_out[7:0] <= ramR[addr];
      data_out[15:8] <= ramG[addr];
      data_out[23:16] <= ramB[addr];
    end

    //-- Escritura en la memoria
    always @(posedge en) begin
      if (rw == 1) begin
        
          ramR[addr] <= data_in [7:0];
          ramG[addr] <= data_in [15:8];
          ramB[addr] <= data_in [23:16];
      end
    end

endmodule