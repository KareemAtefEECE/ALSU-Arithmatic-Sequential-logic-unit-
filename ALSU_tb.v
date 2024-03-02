
// ALSU Testbench

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
            /* random cases just to test out when both bypass bits equals to zero*/  
            if(i==1 || i==5 || i==9 || i==15) begin bypass_A=0;bypass_B=0; end 
                  else begin
		cin=$random;serial_in=$random;direction=$random;red_op_A=$random;red_op_B=$random;bypass_A=$random;bypass_B=$random;
                  end
	end


	opcode=$urandom_range(6,7);
	cin=1;serial_in=1;direction=1;red_op_A=1;red_op_B=1;bypass_A=1;bypass_B=1;
end

endmodule