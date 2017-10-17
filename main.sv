`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Hawker
// 
// Create Date: 10/16/2017 04:44:14 PM
// Design Name: KYPD_Decoder
// Module Name: main
// Project Name: KYPD_Decoder
// Target Devices: Nexys 4 DDR, Basys 3
// Tool Versions: 2017.3
// Description: A top-level module designed to interface and demo the Digilent
//              PmodKYPD peripheral module. All it does is provides a way to
//              connect to the board and also to display the decoded values for
//              each key press on the 7-segment displays.
// INPUTS:  clk100MHz - The on-board 100 MHz clock used in the design.
//                      WIDTH (all): [0:0]
// INOUTS:  JA        - The bidirectional PMOD header on the FPGA board.  The KYPD
//                      device is connected here. The PmodKYPD device provides and
//                      takes low-asserted signals.
//                      WIDTH (all): [7:0]
// OUTPUTS: an        - The anode signals to turn on or off individual 7-segment
//                      displays. As each device varies with the number of displays
//                      it has, the I/O is changed with define statements. These
//                      are low asserted.
//                      WIDTH (Nexys 4 DDR): [7:0], WIDTH (Basys 3): [3:0]
//          seg       - The cathode signals shared between each 7-segment display.
//                      These control the individual segments of each display and
//                      are low asserted.
//                      WIDTH (all): [6:0]
//          dp        - The shared decimal point cathode signal for all displays.
//                      It is low asserted.
//                      WIDTH (all): [0:0]
// DEFINE             - Controls which device the design is to be synthesized for.
//                      The appropriate constraints file(s) must also be selected as
//                      active with the other constraints file(s) being disabled.
//                      Variables: NEXYS_4_DDR, BASYS_3
// 
// Dependencies: 100 MHz Clock, 7-segment displays
// 
// Revision: 1.00
// Revision 1.00 - File completed
// Revision 0.01 - File Created
// Additional Comments: You need at least 1 seven-segment display to be able to
//                      use this. It is also only a demo module just to demo an
//                      interface with the Digilent PmodKYPD device.
//////////////////////////////////////////////////////////////////////////////////
`define NEXYS_4_DDR

module main(an, seg, dp, JA, clk100MHz);

    // Define the I/O based on which device we are synthesizing for
    // Presently the Basys 3 and the Nexys 4 DDR are supported. Other
    // devices can be added here with respective `ifdef blocks.
    `ifdef NEXYS_4_DDR
        output [7:0] an;
        output [6:0] seg;
        output dp;
        inout [7:0] JA;
        input clk100MHz;
        
        // Signify that we are only using the right most display
        assign an = 8'b1111_1110;
    `endif /* NEXYS_4_DDR */
    
    `ifdef BASYS_3
        output [3:0] an;
        output [6:0] seg;
        output dp;
        inout [7:0] JA;
        input clk100MHz;
        
        // Signify that we are only using the right most display
        assign an = 4'b1110;
    `endif /* BASYS_3 */
    
    wire[3:0] hexOut;
    
    KYPD_Decoder dec0(.decodeOut(hexOut), .PMOD(JA), .clk(clk100MHz));
    
    sevenSegmentHex disp0(.segData({dp, seg}), .number(hexOut));

endmodule
