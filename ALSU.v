
// ALSU

module ALSU(A,B,opcode,cin,serial_in,direction,red_op_A,red_op_B,bypass_A,bypass_B,clk,rst,out,leds);

parameter INPUT_PRIORITY = "A";
parameter FULL_ADDER = "ON";

input cin,serial_in,direction,red_op_A,red_op_B,bypass_A,bypass_B,clk,rst;
input wire[2:0] A,B,opcode;
output reg[5:0] out;
output reg[15:0] leds;
reg[2:0] A_FF,B_FF,opcode_FF;
reg cin_FF,serial_in_FF,direction_FF,red_op_A_FF,red_op_B_FF,bypass_A_FF,bypass_B_FF;




always @(posedge clk) begin

cin_FF<=cin;serial_in_FF<=serial_in;
		direction_FF<=direction;red_op_A_FF<=red_op_A;
		red_op_B_FF<=red_op_B;bypass_A_FF<=bypass_A;
		bypass_B_FF<=bypass_B;A_FF<=A;B_FF<=B;opcode_FF<=opcode;

end



/*main*/ always @(posedge clk or posedge rst) begin



  	if (rst) begin
	 out<=0;leds<=0; 
	 end

/*0*/ else begin
         
         

      if((red_op_A_FF || red_op_B_FF) && ~(opcode_FF[2]|opcode_FF[1])) begin
      	out<=0;
      	leds<=0;
       
     leds<=~leds;
      end
       else if((opcode_FF!=6) && (opcode_FF!=7) && bypass_A_FF && !bypass_B_FF) begin leds<=0;out<=A_FF; end
       else if((opcode_FF!=6) && (opcode_FF!=7) && !bypass_A_FF && bypass_B_FF) begin leds<=0;out<=B_FF; end
       else if((opcode_FF!=6) && (opcode_FF!=7) && bypass_A_FF && bypass_B_FF) begin
       	if(INPUT_PRIORITY=="A") begin leds<=0;out<=A_FF; end
       	else begin leds<=0;out<=B_FF; end
       end

  /*5*/    else begin 

		case(opcode_FF)

/*1*/	  0:begin
           leds<=0;
	/*2*/	if(red_op_A && !red_op_B) out<=&A_FF;
	        else if(!red_op_A && red_op_B) out<=&B_FF;
	        else if(red_op_A && red_op_B) begin
	        	if(INPUT_PRIORITY=="A") out<=&A_FF;
	        	else out<=&B_FF;
	      end
	      else out<=A_FF&B_FF;
/*1*/	end

/*4*/      1:begin
           leds<=0;

          	if(red_op_A && !red_op_B) out<=^A_FF;
	        else if(!red_op_A && red_op_B) out<=^B_FF;
	        else if(red_op_A && red_op_B) begin
	        	if(INPUT_PRIORITY=="A") out<=^A_FF;
	        	else out<=^B_FF;
	      end
	      else out<=A_FF^B_FF;
/*4*/      end

           2:begin
           leds<=0;

           	if(FULL_ADDER=="ON") out<=A_FF+B_FF+cin_FF;
           	else out<=A_FF+B_FF;
           end

           3: begin leds<=0;
                   out<=A_FF*B_FF; 
                    end
           4: begin
            leds<=0;

           if(direction) out<={serial_in_FF,out[5:1]};
           else out<={out[4:0],serial_in_FF};
           end
           5: begin
            leds<=0;

           if(direction_FF)
           out<={out[0],out[5:1]};
           else out<={out[4:0],out[5]};
           end
           default: begin
           	out<=0;
           	leds<=0;
           leds<=~leds;
           end

           endcase
           
    /*5*/      end

/*0*/ end
/*main*/ end
endmodule


module ALSU_tb();

reg clk,rst,red_op_A,red_op_B,bypass_A,bypass_B,cin,serial_in,direction;
reg[2:0] A,B,opcode;
wire[5:0] out;
wire[15:0] leds;

ALSU #(.INPUT_PRIORITY("A"),.FULL_ADDER("ON")) DUT(A,B,opcode,cin,serial_in,direction,red_op_A,red_op_B,bypass_A,bypass_B,clk,rst,out,leds);

integer i = 0;

initial begin
	clk=0;
	forever
	#1 clk=~clk;
end

initial begin
	rst=1;
	cin=0;serial_in=0;direction=0;red_op_A=0;red_op_B=0;bypass_A=0;bypass_B=0;A=0;B=0;opcode=0;
	#4
	rst=0;
	A=5;B=7;

	for(i=0;i<20;i=i+1) begin
	   @(negedge clk);
		opcode=$urandom_range(0,5); 
            /* random cases just to test out when both bypass equals to zero*/  if(i==1 || i==5 || i==9 || i==15) begin bypass_A=0;bypass_B=0; end 
                  else begin
		cin=$random;serial_in=$random;direction=$random;red_op_A=$random;red_op_B=$random;bypass_A=$random;bypass_B=$random;
                  end
	end


	opcode=$urandom_range(6,7);
	cin=1;serial_in=1;direction=1;red_op_A=1;red_op_B=1;bypass_A=1;bypass_B=1;
end
endmodule