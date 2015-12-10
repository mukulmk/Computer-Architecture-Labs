module D_ff( input clk, input reset, input regWrite, input decOut1b , input d, output reg q);
	always @ (negedge clk)
	begin
		if(reset==1)
			q=0;
		else
			if(regWrite == 1 && decOut1b==1)
			begin
				q=d;
			end
	end
endmodule

module register16bit( input clk, input reset, input regWrite, input decOut1b, input [15:0] writeData, output [15:0] outR );
	D_ff d0 (clk, reset, regWrite, decOut1b, writeData[0], outR[0]);
	D_ff d1 (clk, reset, regWrite, decOut1b, writeData[1], outR[1]);
	D_ff d2 (clk, reset, regWrite, decOut1b, writeData[2], outR[2]);
	D_ff d3 (clk, reset, regWrite, decOut1b, writeData[3], outR[3]);
	D_ff d4 (clk, reset, regWrite, decOut1b, writeData[4], outR[4]);
	D_ff d5 (clk, reset, regWrite, decOut1b, writeData[5], outR[5]);
	D_ff d6 (clk, reset, regWrite, decOut1b, writeData[6], outR[6]);
	D_ff d7 (clk, reset, regWrite, decOut1b, writeData[7], outR[7]);
	D_ff d8 (clk, reset, regWrite, decOut1b, writeData[8], outR[8]);
	D_ff d9 (clk, reset, regWrite, decOut1b, writeData[9], outR[9]);
	D_ff d10 (clk, reset, regWrite, decOut1b, writeData[10], outR[10]);
	D_ff d11 (clk, reset, regWrite, decOut1b, writeData[11], outR[11]);
	D_ff d12 (clk, reset, regWrite, decOut1b, writeData[12], outR[12]);
	D_ff d13 (clk, reset, regWrite, decOut1b, writeData[13], outR[13]);
	D_ff d14 (clk, reset, regWrite, decOut1b, writeData[14], outR[14]);
	D_ff d15 (clk, reset, regWrite, decOut1b, writeData[15], outR[15]);
endmodule

module registerSet( input clk, input reset, input regWrite, input [15:0] decOut, input [15:0] writeData, output [15:0] outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7,outR8,outR9,outR10,outR11,outR12,outR13,outR14,outR15 );
	register16bit rs0 (clk, reset, regWrite, decOut[0], writeData, outR0);
	register16bit rs1 (clk, reset, regWrite, decOut[1], writeData, outR1);
	register16bit rs2 (clk, reset, regWrite, decOut[2], writeData, outR2);
	register16bit rs3 (clk, reset, regWrite, decOut[3], writeData, outR3);
	register16bit rs4 (clk, reset, regWrite, decOut[4], writeData, outR4);
	register16bit rs5 (clk, reset, regWrite, decOut[5], writeData, outR5);
	register16bit rs6 (clk, reset, regWrite, decOut[6], writeData, outR6);
	register16bit rs7 (clk, reset, regWrite, decOut[7], writeData, outR7);
	register16bit rs8 (clk, reset, regWrite, decOut[8], writeData, outR8);
	register16bit rs9 (clk, reset, regWrite, decOut[9], writeData, outR9);
	register16bit rs10 (clk, reset, regWrite, decOut[10], writeData, outR10);
	register16bit rs11 (clk, reset, regWrite, decOut[11], writeData, outR11);
	register16bit rs12 (clk, reset, regWrite, decOut[12], writeData, outR12);
	register16bit rs13 (clk, reset, regWrite, decOut[13], writeData, outR13);
	register16bit rs14 (clk, reset, regWrite, decOut[14], writeData, outR14);
	register16bit rs15 (clk, reset, regWrite, decOut[15], writeData, outR15);
endmodule

module decoder( input [3:0] destReg, output reg [15:0] decOut);
always @ (destReg)
	case(destReg)
	4'b0000: decOut=16'b0000000000000001;
	4'b0001: decOut=16'b0000000000000010;
	4'b0010: decOut=16'b0000000000000100;
	4'b0011: decOut=16'b0000000000001000;
	4'b0100: decOut=16'b0000000000010000;
	4'b0101: decOut=16'b0000000000100000;
	4'b0110: decOut=16'b0000000001000000;
	4'b0111: decOut=16'b0000000010000000;
	4'b1000: decOut=16'b0000000100000000;
	4'b1001: decOut=16'b0000001000000000;
	4'b1010: decOut=16'b0000010000000000;
	4'b1011: decOut=16'b0000100000000000;
	4'b1100: decOut=16'b0001000000000000;
	4'b1101: decOut=16'b0010000000000000;
	4'b1110: decOut=16'b0100000000000000;
	4'b1111: decOut=16'b1000000000000000;
	endcase
endmodule

module mux16to1( input [15:0] outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7,outR8,outR9,outR10,outR11,outR12,outR13,outR14,outR15, input [3:0] Sel, output reg [15:0] outBus );
always @ (outR0 or outR1 or outR2 or outR3 or outR4 or outR5 or outR6 or outR7 or outR8 or outR9 or outR10 or outR11 or outR12 or outR13 or outR14 or outR15 or Sel)
	case(Sel)
	4'b0000: outBus=outR0;
	4'b0001: outBus=outR1;
	4'b0010: outBus=outR2;
	4'b0011: outBus=outR3;
	4'b0100: outBus=outR4;
	4'b0101: outBus=outR5;
	4'b0110: outBus=outR6;
	4'b0111: outBus=outR7;
	4'b1000: outBus=outR8;
	4'b1001: outBus=outR9;
	4'b1010: outBus=outR10;
	4'b1011: outBus=outR11;
	4'b1100: outBus=outR12;
	4'b1101: outBus=outR13;
	4'b1110: outBus=outR14;
	4'b1111: outBus=outR15;
	endcase
endmodule

module mux2to1( input [3:0] rd1, input [3:0] rd2, input Sel, output reg [3:0] desReg );
always @ (rd1 or rd2 or Sel)
	case(Sel)
	1'b0: desReg=rd1;
	1'b1: desReg=rd2;
	endcase
endmodule

module registerFile(input clk, input reset, input regWrite, input [3:0] rs, input [3:0] rt, input [3:0] rd1, input [3:0] rd2, input [15:0] writeData, input select, output [15:0] outR0, output [15:0] outR1, output [15:0] outR2);
wire [3:0] outmux1, outmux2;
wire [15:0] outdec;
wire [15:0] outregset0, outregset1, outregset2, outregset3, outregset4, outregset5, outregset6, outregset7, outregset8, outregset9, outregset10, outregset11, outregset12, outregset13, outregset14, outregset15;
mux2to1 m0 (rd2, rd1, select, outmux1);
mux2to1 m1 (rd1, rd2, select, outmux2);
decoder de0 (outmux1, outdec);
registerSet regs1 (clk, reset, regWrite, outdec, writeData, outregset0, outregset1, outregset2, outregset3, outregset4, outregset5, outregset6, outregset7, outregset8, outregset9, outregset10, outregset11, outregset12, outregset13, outregset14, outregset15);
mux16to1 m2 (outregset0, outregset1, outregset2, outregset3, outregset4, outregset5, outregset6, outregset7, outregset8, outregset9, outregset10, outregset11, outregset12, outregset13, outregset14, outregset15, rs, outR0);
mux16to1 m3 (outregset0, outregset1, outregset2, outregset3, outregset4, outregset5, outregset6, outregset7, outregset8, outregset9, outregset10, outregset11, outregset12, outregset13, outregset14, outregset15, rt, outR1);
mux16to1 m4 (outregset0, outregset1, outregset2, outregset3, outregset4, outregset5, outregset6, outregset7, outregset8, outregset9, outregset10, outregset11, outregset12, outregset13, outregset14, outregset15, outmux2, outR2);
endmodule

module test_registerFile( );
//inputs
reg clk,reset,regWrite,select;
reg [3:0] rs,rt,rd1,rd2;
reg [15:0] writeData;
//outputs
wire [15:0] outR0;
wire [15:0] outR1;
wire [15:0] outR2;
registerFile uut(clk,reset,regWrite,rs,rt,rd1,rd2,writeData,select,outR0,outR1,outR2);
always begin #5 clk=~clk; end
initial
begin
clk=0; reset=1; rs=4'd0; rt=4'd1; rd1=4'd10; rd2=4'd2;
#5 reset=0; select=1; regWrite=1; rd1=4'd1; writeData=16'd1;
#10 rd1=4'd3; writeData=16'd3;
#10 rd1=4'd5; writeData=16'd5;
#10 rd1=4'd7; writeData=16'd7;
#10 rd1=4'd9; writeData=16'd9;
#10 select=0; rd2=4'd2;writeData=16'd2;
#10 rd2=4'd4;writeData=16'd4;
#10 rd2=4'd6;writeData=16'd6;
#10 rd2=4'd8;writeData=16'd8;
#10 rd2=4'd10;writeData=16'd10;
#10 regWrite=0; select=1; rs=4'd0; rd1=4'd1; rd1=4'd3; rd2=4'd2;
#10 rs=4'd3;rt=4'd4;rd1=4'd6; rd2=4'd5;
#10 select=0; rs=4'd6;rt=4'd7;rd1=4'd8; rd2=4'd9;
#10 $finish;
end
endmodule
	
		




	