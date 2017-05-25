  
module peripheral_config_TB;

  reg clk1;
  reg rst1;
  reg [15:0]d_in;
  reg cs;
  reg [3:0]addr1; // 4 LSB from j1_io_addr
  reg rd;
  reg wr;
  wire [15:0]data_out;


  wire p_clock;  //Pulso  ----- Variables capture
  wire vsync;   //Posición
  wire href;  //Posiciòn
  wire enable;  
 
  reg pixel_valid;
  reg frame_done;
  reg SIOC;
  reg SIOD;
  wire rst;

  reg clkm;                      // ---- Variables genram
  wire [16: 0] addr;      //-- Direcciones
  wire rw=0;                  //-- Modo lectura (0) o escritura (1)
  
  wire en;                    // -- Control 
  wire cen;                   // -- Contador enable
  reg [23: 0] pixel_data;

  reg reset;          // Variable auxiliar divisor

  wire capture=0;
  wire done=0;

  peripheral_config uut (.clk1(clkm) , .rst1(rst1) , .d_in(d_in) , .cs(cs) , .addr1(addr1) , .rd(rd) , .wr(wr), .data_out(data_out) );

  initial begin  // Initialize Inputs
      clkm = 0; rst1 = 1; 
      #10 rst1 = 0; 
    
      d_in = 1; addr1 = 1; cs=1; rd=0; wr=1;
   end
   always #1 clkm= ~clkm;

   initial begin: TEST_CASE
     $dumpfile("peripheral_config_TB.vcd");
     $dumpvars(-1, uut);
    #(200) $finish;
  end 
endmodule 