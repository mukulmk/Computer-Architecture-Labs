module D_FF(input clk,input set,input reset,output reg Q);
always@(negedge clk)
begin
	if(reset==1'b1)
	Q=0;
else
	begin
	if(set)
	Q=1;
	end
end
endmodule

module decoder2to4(input [1:0] muxOut,output reg[3:0] decOut);
always@(muxOut)
	case(muxOut)
			2'b00: decOut=4'b0001; 
			2'b01: decOut=4'b0010;
			2'b10: decOut=4'b0100;
			2'b11: decOut=4'b1000;
	endcase
endmodule

module mux(input [1:0] LineIndex,input[1:0] LRUWay,input Hit,output reg [1:0] muxOut);
always @ (LineIndex or LRUWay or Hit)
	case(Hit)
	1'b0: muxOut=LineIndex;
	1'b1: muxOut=LRUWay;
	endcase
endmodule

module NxN_DFFs(input clk,input reset,input[3:0] decOut,output [3:0] NxNOut);
D_FF d0(clk, decOut[0], reset, NxNOut[0]);
D_FF d1(clk, decOut[1], reset, NxNOut[1]);
D_FF d2(clk, decOut[2], reset, NxNOut[2]);
D_FF d3(clk, decOut[3], reset, NxNOut[3]);
endmodule

module prio_Enc(input reset, input [3:0]NxNOut,output reg [1:0] LRUWay);
always @ (reset or NxNOut)
	case(NxNOut)
	4'b1110: LRUWay = 2'b00;
	4'b1101: LRUWay = 2'b01;
	4'b1011: LRUWay = 2'b10;
	4'b0111: LRUWay = 2'b11;
	endcase
endmodule

module LRU(input [1:0] LineIndex,input clk,input reset, input Hit , output [1:0] LRUWay, output [1:0] mOut, output [3:0] dOut, output [3:0] nOut);
mux m1(LRUWay, LineIndex, Hit, mOut);
decoder2to4 d1(mOut, dOut);
NxN_DFFs n1(clk, reset, dOut, nOut);
prio_Enc p1(reset, nOut, LRUWay);
endmodule

module testbench;
reg [1:0] LineIndex;
reg clk;
reg reset;
reg Hit;
wire [1:0] LRUWay;
wire [1:0] mOut;
wire [3:0] dOut, nOut;
LRU uut (.LineIndex(LineIndex), .clk(clk), .reset(reset), .Hit(Hit), .LRUWay(LRUWay), .mOut(mOut), .dOut(dOut),
.nOut(nOut) );
always
#5 clk=~clk;
initial 
begin
LineIndex = 0;
reset = 1;
Hit = 0;
clk = 0;
$monitor($time," Current_LRUWay=%d Hit=%d LineIndex=%d ",LRUWay,Hit,LineIndex);
#8 Hit=1;
#2 reset=0; LineIndex=3'd0;
#10 LineIndex=3'd1;
#10 LineIndex=3'd2;
#10 LineIndex=3'd3;
#10 Hit=0; LineIndex=3'd1;
#10 LineIndex=3'd0;
#10 LineIndex=3'd1;
#10 LineIndex=3'd2;
#10 LineIndex=3'd3;
#10 $finish;
end
endmodule