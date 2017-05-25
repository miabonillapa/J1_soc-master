module capture ( rst, p_clock, vsync, href, enable,
					 p_data, pixel_data, pixel_valid,
					 frame_done, SIOD, SIOC);

	input rst;   // Reset camara
	// input power;  // Encendido camara
	input vsync;   //Posición
	input href;	//Posiciòn
	input enable;	
	input p_clock;
	input [7:0] p_data; 	//Información byte
	output reg [23:0] pixel_data; //Byte de salida
	output reg pixel_valid;
	output reg frame_done;
	output reg SIOD;
	output reg SIOC;
	reg contador;
	reg contframe = 0;
	reg [7:0] y;
	reg [7:0] cb;
	reg [7:0] cr; 


	reg [1:0] FSM = 0;  //Maquina de Estados


	localparam WAIT=0; 	//Esperar
	localparam SAVE=1;	//Capturar

	// if(power) begin

		always @(posedge p_clock) begin

			if (rst) begin
				pixel_data <= 8'b00000000;
				pixel_valid  <= 0;
		 		frame_done <= 0;
		 		SIOC <= 0;
		 		SIOD <= 0;

		 	end

			else if (enable) begin 

				case(FSM) 

					WAIT: begin
								FSM <= (!vsync) ? SAVE : WAIT;
				   				frame_done <= 0; 
					   	end
							
					SAVE: begin	
							FSM <= vsync ? WAIT : SAVE;
				  			frame_done <= vsync ? 1 : 0;
				 			pixel_valid <= href ? 1 : 0; 

				 			if(href && frame_done == 0) begin

				 				if (contador==0) begin
					 				y[7:0] <= p_data;					 				
					 				contador = contador +1;
				 				end

				 				else if (contador==1) begin
					 				cb[7:0] <= p_data;
					 				contador = contador +1;
				 				end

				 				else if (contador==2) begin
					 				cr[7:0] <= p_data;

					 				pixel_data[7:0] <= (1.164)*(y - 16) + (1.596)*(cr - 128);
					 				pixel_data[15:8] <= (1.164)*(y - 16) - (0.813)*(cr - 128) - (0.392)*(cb - 128);
					 				pixel_data[23:16] <= (1.164)*(y - 16) + (2.017)*(cb - 128);

					 				contador = 0;
				 				end

				 			end 	
				  			
						end


				endcase	

				always @(posedge vsync) begin

					if(contframe == 102399)
					contframe = contframe+1;
					else begin
						frame_done=1;
					end

				end
		
			end	
		end
	//end
	
	
endmodule