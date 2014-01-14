//  	Christopher Dorick
//		ECE 2504 Design project 2
//  	Fall 2012
//  
//  **************************************************
//  This file is the only Verilog file that you should modify.
//  It should be properly commented and formatted.
//  **************************************************
//  
//
//
//
//  The module your_ALU_mux should take the operands A, B and opcode 
//  from the memory in the top level entity, and apply them to the inputs of your ALU
//
//  It should also take the switches as input to control a 16-to-1 8-bit wide mux that
//  drives the LEDs.  
//  
//  Do not change the module declaration (next four lines)
module your_ALU_mux(your_out, operandA, operandB, opcode, switches, address);
	input [7:0] operandA, operandB, address;
	input [3:0] opcode, switches;
	output [7:0] your_out;
// Do not change the module declaration (from keyword module above to here)
	
	wire [15:0] last_four_ID_digits;
//  *******************************************************
//  You MUST change the assignment to last_four_ID_digits 
//  to the last four digits of your student ID in BCD.
	assign last_four_ID_digits = 16'h3938;
//  *******************************************************
	
// Declare any wires that you need here.
wire[7:0] reslt;  //going to go into the led's in the end
wire[3:0] stat; 

// Instantiate your ALU and mux.  Use wires to connect them together. 
ALU A(reslt, stat, operandA,operandB,opcode);

// The output of the mux is connected to the LEDs in the top-level entity
// The LED values as a function of the switches is defined in the project specification.
// This instantiation of the mux is just an example--it does NOT meet the project specification. 
// You will have to change the port connections to meet the specification.  But this example
// shows how to connect to constant values (i5 through i15), input ports of various bit 
//  widths (i1 through i4--opcode is only 4 bits wide, so it is padded with 0's), and internal wires (i0)
// Look at the file mux16_1_8bits.v for the port definition of the mux.
// 
//        ports:      output   select     i15    i14    i13    i12    i11   i10     i9     i8      i7           i6                  i5                  i4        i3       i2               i1                    i0
mux16_1_8bits MY_MUX(your_out, switches, 8'hE1, 8'hD2, 8'hC3, 8'hB4, 8'hA5, 8'h96, 8'h87, 8'h78, reslt, {4'b0000, opcode},  {4'b0000, stat[3:0]}, address, operandA,operandB, last_four_ID_digits[7:0], last_four_ID_digits[15:8]);


endmodule
// end of your_ALU_mux

module ALU(reslt,stat,operandA_1,operandB_1,opc_1);

//Declare your ports
	input[7:0] operandA_1,operandB_1;
	input[3:0] opc_1;
	output[3:0] stat;
	output[7:0] reslt;
	
// Declare any wires 
wire[7:0] A_wire, B_wire, A_not, B_not, resltwire, AandB, AorB, AxorB, ShiftL, ShiftR;
wire carryin_1, overflow, c_out;
					  
arithmetic A1(resltwire, c_out, overflow, A_wire, B_wire, carryin_1); //calls the Ripple adder function for arithmetic operations
// overflow only ever occurs with the arithmetic equations, never with the logical problems

assign reslt =  (opc_1 == 1'b0) ? resltwire: //assigns the result value from Ripple adder or other opcode functions
					 (opc_1 == 4'b1000) ? AandB:
					 (opc_1 == 4'b1001) ? AorB:
					 (opc_1 == 4'b1010) ? A_not:
					 (opc_1 == 4'b1011) ? AxorB:
					 (opc_1 == 4'b1100) ? ShiftL:
					 (opc_1 == 4'b1101) ? ShiftR:
					  resltwire == 0;//catch/assigns the result to zero if opcode is not used

//statusbits designation:					  
assign stat[3] = (opc_1 == 1'b0) ? overflow: 
						0; //catch/assigns the overflow status bit from the Ripple adder to the 4 status bits

assign stat[2] = (opc_1 == 4'b1101) ? 0: //assigns the zero status bit
					  (opc_1 == 4'b1100) ? 0: 
					  (reslt == 8'b00000000) ? 1: // if all 8 binary digits are 0, then 1
						0;//catch/rest of default to zero

assign stat[1] = (opc_1 == 1'b0) ? c_out: 
						0; //catch/assigns carryout status bit from arithmetic function

assign stat[0] = (opc_1 == 4'b1100) ? 0: 
					  (opc_1 == 4'b1101) ? 0: 
					  (reslt[7] == 1'b1) ? 1:
						0; //catch/assigns the negative status bit by checking if MSB result is 1


//bit breakdwon of assigning A_not the not of operandA_1:
not(A_not[0], operandA_1[0]); 
not(A_not[1], operandA_1[1]);
not(A_not[2], operandA_1[2]);
not(A_not[3], operandA_1[3]);
not(A_not[4], operandA_1[4]);
not(A_not[5], operandA_1[5]);
not(A_not[6], operandA_1[6]);
not(A_not[7], operandA_1[7]);

//bit breakdown of assigning B_not the not of operandB_1:
not(B_not[0], operandB_1[0]); 
not(B_not[1], operandB_1[1]);
not(B_not[2], operandB_1[2]);
not(B_not[3], operandB_1[3]);
not(B_not[4], operandB_1[4]);
not(B_not[5], operandB_1[5]);
not(B_not[6], operandB_1[6]);
not(B_not[7], operandB_1[7]);

//bit breakdown of assigning AandB the AND function of operandA_1 and operandB_1:
and(AandB[0], operandA_1[0],operandB_1[0]); 
and(AandB[1], operandA_1[1],operandB_1[1]);
and(AandB[2], operandA_1[2],operandB_1[2]);
and(AandB[3], operandA_1[3],operandB_1[3]);
and(AandB[4], operandA_1[4],operandB_1[4]);
and(AandB[5], operandA_1[5],operandB_1[5]);
and(AandB[6], operandA_1[6],operandB_1[6]);
and(AandB[7], operandA_1[7],operandB_1[7]);

//bit breakdown of assigning AorB the OR function of operandA and operandB:
or(AorB[0],operandA_1[0],operandB_1[0]); 
or(AorB[1],operandA_1[1],operandB_1[1]);
or(AorB[2],operandA_1[2],operandB_1[2]);
or(AorB[3],operandA_1[3],operandB_1[3]);
or(AorB[4],operandA_1[4],operandB_1[4]);
or(AorB[5],operandA_1[5],operandB_1[5]);
or(AorB[6],operandA_1[6],operandB_1[6]);
or(AorB[7],operandA_1[7],operandB_1[7]);

//bit breakdown of assigning AxorB the XOR function of operandA and operandB:
xor(AxorB[0],operandA_1[0],operandB_1[0]); 
xor(AxorB[1],operandA_1[1],operandB_1[1]);
xor(AxorB[2],operandA_1[2],operandB_1[2]);
xor(AxorB[3],operandA_1[3],operandB_1[3]);
xor(AxorB[4],operandA_1[4],operandB_1[4]);
xor(AxorB[5],operandA_1[5],operandB_1[5]);
xor(AxorB[6],operandA_1[6],operandB_1[6]);
xor(AxorB[7],operandA_1[7],operandB_1[7]);

//assigns inputs A and B for the carry adders:
assign B_wire =(opc_1 == 4'b0001) ? B_not: //assigns B_not to subtraction opcode,
					(opc_1 == 4'b0010) ? 0: //operations where OperandB_1 is not needed
					(opc_1 == 4'b0011) ? 0: 
					(opc_1 == 4'b0100) ? 0: 
						operandB_1;  //catch/assigns operand B
assign A_wire =(opc_1 == 4'b0100) ? A_not: //assigns A_not to opcodes that need A_not 
					(opc_1 == 4'b1010) ? A_not: 
						operandA_1; //catch/assigns operand A

//shift operations:
//Logical Shift Left (ShiftL):
assign ShiftL[7] = operandA_1[6];
assign ShiftL[6] = operandA_1[5];
assign ShiftL[5] = operandA_1[4];//throws away leftmost bit and shifts
assign ShiftL[4] = operandA_1[3];
assign ShiftL[3] = operandA_1[2];
assign ShiftL[2] = operandA_1[1];
assign ShiftL[1] = operandA_1[0];
assign ShiftL[0] = 0; //shifts to zero b/c nowhere else to shift to.

//Logical Shift Right (ShiftR):
assign ShiftR[0] = operandA_1[1];
assign ShiftR[1] = operandA_1[2];
assign ShiftR[2] = operandA_1[3];//throws away rightmost bit and shifts
assign ShiftR[3] = operandA_1[4];
assign ShiftR[4] = operandA_1[5];
assign ShiftR[5] = operandA_1[6];
assign ShiftR[6] = operandA_1[7];
assign ShiftR[7] = 0; //shifts to zero b/c nowhere else to shift to.

//carryin's from opcodes assigned:
assign carryin_1 =(opc_1 == 4'b0000) ? 0:
						(opc_1 == 4'b0001) ? 1:
						(opc_1 == 4'b0010) ? 1:
						(opc_1 == 4'b0011) ? 0:
						(opc_1 == 4'b0100) ? 1:
						0; //defualt/catch to zero
endmodule
// end of ALU

// Add any other modules that you need after this point.

module arithmetic(S,c_out,ofV,C,D,c_in);
	
	input[7:0] C,D;
	input c_in;
	output[7:0] S;
	output c_out,ofV;
	
	assign {c_out, S} = C+D+c_in;

	assign ofV = {1'b0,S[7] == {C[7]+D[7]}} ? 0: 1;
	//defines what overflow is and how to achieve it
endmodule	