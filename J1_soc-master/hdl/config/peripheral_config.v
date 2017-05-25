module peripheral_config(clk1 , rst1 , d_in , cs , addr1 , rd , wr, data_out);

  input clk1;
  input rst1;
  input [15:0]d_in;
  input cs;
  input [3:0]addr1; // 4 LSB from j1_io_addr     /// Variables J1
  input rd;
  input wr;
  output reg [15:0]data_out;


  output p_clock;  //Pulso  ----- Variables capture
  output con_clock;
  output vsync;   //Posición
  output href;  //Posiciòn
  output enable;  
  output [7:0] p_data;
 
  input pixel_valid;
  input frame_done;
  input SIOC;
  input SIOD;
  output rst;

  output clk;                      // ---- Variables genram
  output [16: 0] addr;      //-- Direcciones
  output rw;                  //-- Modo lectura (0) o escritura (1)
  
  output en;                    // -- Control 
  output cen;                   // -- Contador enable
  input [23: 0] pixel_data;

  input reset;          // Variable auxiliar divisor

//------------------------------------ regs and wires-------------------------------

  reg [4:0] s;  //selector mux_4  and demux_4
  reg capture=1;
  wire [23: 0] pixel_rgb;  

  wire uart_busy;  // out_uart

//------------------------------------ regs and wires-------------------------------




always @(*) begin//----address_decoder------------------
case (addr1)
4'h0:begin s = (cs && wr) ? 6'b000001 : 6'b000000 ;end //Capture
4'h2:begin s = (cs && rd) ? 6'b000010 : 6'b000000 ;end //data_out[23:15]
4'h3:begin s = (cs && rd) ? 6'b000100 : 6'b000000 ;end //data_out[14:8]
4'h4:begin s = (cs && rd) ? 6'b001000 : 6'b000000 ;end //data_out[7:0]
4'h6:begin s = (cs && rd) ? 6'b010000 : 6'b000000 ;end //done

default:begin s=3'b000 ; end
endcase
end//-----------------address_decoder--------------------


always @(negedge clk) begin//-------------------- escritura de registros

capture    = (s[0]) ? d_in : capture; //Write Registers
end//------------------------------------------- escritura de registros 


always @(negedge clk) begin//-----------------------mux_4 :  multiplexa salidas del periferico
case (s[4:1])
6'b000001: data_out = pixel_rgb[23:16] ;
6'b000010: data_out = pixel_rgb[15:8] ;
6'b000100: data_out = pixel_rgb[7:0] ;
6'b001000: data_out[4] = frame_done;
default: data_out   = 0 ;
endcase
end//----------------------------------------------mux_4


  capture  cc(.p_clock(con_clock),
  				.vsync(vsync), 
  				.href(href), 
  				.enable(capture), 
  				.p_data(p_data),
  				.pixel_valid(pixel_valid), 
  				.pixel_data(pixel_data), 
  				.frame_done(frame_done),
          .SIOD(SIOD),
          .SIOC(SIOC),
          .rst(rst)
  		);

  genram rom1 (.clk(con_clock),
  		   .addr(addr),
  		   .rw(rw),
  		   .data_in(pixel_data),
  		   .en(en),
  		   .cen(cen),
  		   .data_out(pixel_rgb)
  		   );

  clockDivider cd(.con_clock(con_clock),
                .clk(clk1), 
                .reset(reset)
        );

endmodule