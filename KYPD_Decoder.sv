`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Hawker
// 
// Create Date: 10/16/2017 04:54:14 PM
// Design Name: DmodKYPD Decoder
// Module Name: KYPD_Decoder
// Target Devices: Nexys 4 DDR, Basys 3
// Tool Versions: Vivado 2017.3
// Description: A simple decoder designed to interface with the Digilent PmodKYPD
//              peripheral module. It cycles through the columns and determines
//              which buttons, if any, are pushed down. It then returns the
//              respective hexadecimal value for the button being pushed down. Due
//              to the nature of the design, the module cannot detect simultaneous
//              button presses although the board supports it.
// INPUTS:  clk         - A 100 MHz clock signal provided by the FPGA board. In
//                        theory, a slower clock should work, but is not ideal for
//                        this design.
//                        WIDTH: [0:0]
// INOUTS:  PMOD        - The bidirectional bus for interfacing with the decoder.
//                        Specifically, the rows [1:4] are pins [10:7] and the
//                        columns [1:4] are pins [4:1]. All pins here are low
//                        asserted.
//                        WIDTH: [7:0]
// OUTPUTS: decodeOut   - The decoder output. This is a 4-bit hexadecimal value as
//                        there are 16 buttons on the keypad. The output is high
//                        asserted in binary.
//                        WIDTH: [3:0]
// 
// Dependencies: 100 MHz Clock, 7-segment displays
// 
// Revision: 1.00
// Revision 1.00 - File completed
// Revision 0.01 - File Created
// Additional Comments: To implement a decoder which can detect simultanious
//                      button presses, you just need to compare which rows are
//                      low with respect to which colums are low. If you detect
//                      individual bits and then assert different signals for each
//                      button, you can build a module that detects each button at
//                      the same time.
//////////////////////////////////////////////////////////////////////////////////


module KYPD_Decoder(PMOD, clk, decodeOut);
    // I/O Declarations
    output reg [3:0] decodeOut;
    inout [7:0] PMOD;
    input clk;
    
    // Variable declarations
    wire [3:0] row;
    wire redClk;
    reg [3:0] col;
    reg [15:0] clkCnt;
    
    // Handle the bidirectional bus and distinguish which is the row, and which
    // is the columns
    assign PMOD[3:0] = col;
    assign row = PMOD[7:4];
    
    // Start by reducing the clock to around 1.535 kHz
    always_ff @ (posedge clk) begin
        clkCnt++;
    end
    
    assign redClk = clkCnt[15];
    
    // Now, handle the logic to determine the column we're reading from
    initial begin
        col <= 4'b0111;
    end
    
    always_ff @ (posedge redClk) begin
        if (col == 4'b0111)
            col <= 4'b1011;
        else if (col == 4'b1011)
            col <= 4'b1101;
        else if (col == 4'b1101)
            col <= 4'b1110;
        else if (col == 4'b1110)
            col <= 4'b0111;
        else
            col <= 4'b0111;    
    end
    
    // Finally, read the row to determine the number that we're
    // reading in from
    always_ff @ (posedge redClk) begin
        if (col == 4'b0111) begin       // LL Column, column 1
            if (row == 4'b0111)
                decodeOut <= 4'h1;
            else if (row == 4'b1011)
                decodeOut <= 4'h4;
            else if (row == 4'b1101)
                decodeOut <= 4'h7;
            else if (row == 4'b1110)
                decodeOut <= 4'h0;
        end
        else if (col == 4'b1011) begin  // LC Column, column 2
            if (row == 4'b0111)
                decodeOut <= 4'h2;
            else if (row == 4'b1011)
                decodeOut <= 4'h5;
            else if (row == 4'b1101)
                decodeOut <= 4'h8;
            else if (row == 4'b1110)
                decodeOut <= 4'hF;
        end
        else if (col == 4'b1101) begin  // RC Column, column 3
            if (row == 4'b0111)
                decodeOut <= 4'h3;
            else if (row == 4'b1011)
                decodeOut <= 4'h6;
            else if (row == 4'b1101)
                decodeOut <= 4'h9;
            else if (row == 4'b1110)
                decodeOut <= 4'hE;
        end
        else if (col == 4'b1110) begin  // RR Column, column 4
            if (row == 4'b0111)
                decodeOut <= 4'hA;
            else if (row == 4'b1011)
                decodeOut <= 4'hB;
            else if (row == 4'b1101)
                decodeOut <= 4'hC;
            else if (row == 4'b1110)
                decodeOut <= 4'hD;
        end
    end
    
endmodule
