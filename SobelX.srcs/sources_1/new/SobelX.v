`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2020 06:27:42 PM
// Design Name: 
// Module Name: SobelX
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SobelX(
    input clk,
    input en,
    input [31:0] stream_input,
    output [31:0] stream_output
    );

parameter WIDTH = 695; 
reg signed [31:0] x [2*WIDTH+2:0];  // shift-register sliding buffer
reg signed [31:0] acc;
reg signed [31:0] y;  // 32-bit output pixel
integer i;

initial 
    begin
    for (i = 0; i < (2*WIDTH+2); i=i+1)
        x[i] = 0; // initialize all buffer pixels to 0
    end

always @(posedge clk) begin
    if (en) begin
        // Move the stream_input pixel into the line buffer
        x[0] <= $signed(stream_input);
         
        // Apply the sobel filter (x-dir)
        acc <= x[0]-x[2]+(x[695]-x[695+2])*2+x[2*695]-x[2*695+2];
        
        // Get a grayscale average
        y <= acc / 8 + 128;   

        // Shift each pixel value in the buffer 1 index to the left
        for(i = (2*WIDTH+2); i > 0; i=i-1)
            begin
            x[i] = x[i - 1];            
            end
        end 
    end

assign stream_output = y; 

endmodule
