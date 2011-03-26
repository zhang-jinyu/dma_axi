//---------------------------------------------------------
//-- File generated by RobustVerilog parser
//-- Version: 1.0
//-- Invoked Fri Mar 25 23:34:53 2011
//--
//-- Source file: dma_ch_reg_size.v
//---------------------------------------------------------


  
module dma_axi32_core0_ch_reg_size(clk,reset,update,start_addr,burst_max_size_reg,burst_max_size_other,allow_full_burst,allow_full_fifo,joint_flush,burst_max_size);

   parameter              MAX_BURST     = 1 ? 64 : 128; //16 strobes
   parameter              HALF_BYTES    = 32/2;
   parameter              LARGE_FIFO    = 32 > MAX_BURST;
   parameter              SMALL_FIFO    = 32 == 16;
   
   input                  clk;
   input              reset;

   input              update;

   input [32-1:0]      start_addr;
   input [7-1:0]      burst_max_size_reg;
   input [7-1:0]      burst_max_size_other;

   input              allow_full_burst;
   input              allow_full_fifo;
   input              joint_flush;
   output [7-1:0]      burst_max_size;

   
   
   wire [7-1:0]      burst_max_size_fifo;
   wire [7-1:0]      burst_max_size_pre;
   reg [7-1:0]      burst_max_size;

   
  
   
   assign              burst_max_size_fifo = 
                 allow_full_burst | LARGE_FIFO ? MAX_BURST  :
                 joint_flush & SMALL_FIFO      ? HALF_BYTES :
                 (burst_max_size_other > HALF_BYTES) & (burst_max_size_reg > HALF_BYTES) & (burst_max_size_other != burst_max_size_reg) 
                                                               ? HALF_BYTES :
                 allow_full_fifo               ? 32 : HALF_BYTES;
   
   
   prgen_min2 #(7) min2_max(
                   .a(burst_max_size_reg),
                   .b(burst_max_size_fifo),
                   .min(burst_max_size_pre)
                   );
   
   always @(posedge clk or posedge reset)
     if (reset)
       burst_max_size <= #1 {7{1'b0}};
     else if (update)
       burst_max_size <= #1 burst_max_size_pre > MAX_BURST ? MAX_BURST : burst_max_size_pre;

   
endmodule

