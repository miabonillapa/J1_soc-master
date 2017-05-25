module clockDivider ( clk, con_clock, reset);
output reg con_clock;
input clk ;
input reset;
	always @(posedge clk)
	begin
	if (~reset)
    	 con_clock <= 1'b0;

    else
	     con_clock <= ~ con_clock;	
	end
endmodule