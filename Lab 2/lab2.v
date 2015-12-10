module D_ff_Shifter(input clk, input load, input init_d , input shift_d, output reg q);
always @ (negedge clk)
begin
  if(load==1)
  q=init_d;
  else
  q=shift_d;
end
endmodule

module D_ff_cnt( input d,output reg q);
always@(d)
q=d;
endmodule

module counter(input clk, input load, output [2:0] cnt);
// On negedge clk, when load is 1, cnt is initialized with 4.
// On negedge clk, when load is 0, cnt is decremented by 1.
reg[2:0] count;
always @ (negedge clk)
	begin
		if(load==1)
			count=3'b100;

		if(load==0)
			count=count-1;
	end
D_ff_cnt df0 (count[0],cnt[0]);
D_ff_cnt df1 (count[1],cnt[1]);
D_ff_cnt df2 (count[2],cnt[2]);
endmodule

module rShiftReg(input clk, input load, input [3:0] multiplier, input [3:0] adderResult, output [8:0] Q);
D_ff_Shifter d0(clk, load, 1'b0, Q[1], Q[0]);
D_ff_Shifter d1(clk, load, multiplier[0], Q[2], Q[1]);
D_ff_Shifter d2(clk, load, multiplier[1], Q[3], Q[2]);
D_ff_Shifter d3(clk, load, multiplier[2], Q[4], Q[3]);
D_ff_Shifter d4(clk, load, multiplier[3], adderResult[0], Q[4]);
D_ff_Shifter d5(clk, load, 1'b0, adderResult[1], Q[5]);
D_ff_Shifter d6(clk, load, 1'b0, adderResult[2], Q[6]);
D_ff_Shifter d7(clk, load, 1'b0, adderResult[3], Q[7]);
D_ff_Shifter d8(clk, load, 1'b0, adderResult[3], Q[8]);
endmodule

module adder(input q1, input q0, input [3:0] A, input [3:0] multiplicand, output reg [3:0] adderOut);
always @ (q1 or q0 or A or multiplicand)
	begin
	if(q1==1 && q0==0)
	adderOut = A - multiplicand;
	else if(q1==0 && q0==1)
	adderOut = A + multiplicand;
	else
	adderOut = A;
	end
endmodule

module sExt(input [3:0] in, output reg [7:0] out);
always @ (in)
begin
	out[0]=in[0];
	out[1]=in[1];
	out[2]=in[2];
	out[3]=in[3];
	out[4]=in[3];
	out[5]=in[3];
	out[6]=in[3];
	out[7]=in[3];
end
endmodule

module alu( input select,input [2:0] cnt,input [7:0] in1,input [7:0] in2,output reg [7:0] aluOut);
//When cnt is 0 and select is 1 alu performs add operation(in1+in2).
//When cnt is 0 and select is 0 alu performs subtract operation(in1-in2).
always @ (select or cnt)
begin
	if(cnt==0 && select==1)
		aluOut=in1+in2;
	else if(cnt==0 && select==0)
		aluOut=in1-in2;
end
endmodule

module mulAddSub(input clk, input load, input select, input [3:0] multiplier, input [3:0] multiplicand, input [3:0] in3, output [7:0] aluOut);
wire[8:0] outrshft;
wire[7:0] outst;
wire[2:0] outcnt;
wire[3:0] outadder;
rShiftReg r1 (clk, load, multiplier, outadder, outrshft);
adder a1 (outrshft[1], outrshft[0], outrshft[8:5], multiplicand, outadder);
sExt s1 (in3, outst);
counter c1 (clk, load, outcnt);
alu al1 (select, outcnt, outrshft[8:1], outst, aluOut);
endmodule

module testMulAddSub;
// Inputs
reg clk,load,select;
reg [3:0] multiplier,multiplicand,in3;
// Outputs
wire [7:0] aluOut;
// Instantiate the Unit Under Test (UUT)
mulAddSub uut (
.clk(clk),
.load(load),
.select(select),
.multiplier(multiplier),
.multiplicand(multiplicand),
.in3(in3),
.aluOut(aluOut)
);
always #5 clk=~clk;
initial begin
//$monitor($time," %d * %d select( %b ) %d = %d ",multiplier,multiplicand,select,in3,aluOut);
// Initialize Inputs
//Case 1 : multiplier = 1 mulitplicand = 5 select = 1 (add) in3 = 5, (5 * 1 + 5 = 10)
clk = 0;
load = 1;
multiplier = 1;
multiplicand = 5;
in3 = 5;
select = 1;
#10 load = 0;
#40
//Case 2 : multiplier = -5 mulitplicand = 5 select = 1 (add) in3 = 5, (5 * (-5) + 5 = (-20))
load = 1;
multiplier = -5;
multiplicand = 5;
#7 select = 1; in3=5; //#10 select = 0; load=0;
#3 load=0;
#40
//Case 3 : multiplier = -5 mulitplicand = -7 select = 0 (sub) in3 = 5, ((-7) * (-5) - 5 = 30)
load = 1;
multiplier = -5;
multiplicand = -7;  
#7select = 0; in3=5;
#3 load=0;
#40
//Case 4 : multiplier = 6 mulitplicand = -6 select = 1 (add) in3 = -4, (6 * (-6) + (-4) = (-40))
load = 1;
multiplier = 6;
multiplicand = -6;
#7select = 1; in3=-4;
#3 load=0;
#50
$finish;
end
endmodule