// Copyright (c) 2026 Allen Appukuttan

// Licensed under the MIT License. 
// See LICENSE in the project root for license information

module wd_tracker #(

    parameter NUM_MASTERS       = 4,
    parameter NUM_SLAVES        = 4,
    parameter MAX_OUTSTANDING   = 1,
    parameter SLAVE_SEL_BITS    = (NUM_SLAVES > 0) ? $clog2(NUM_SLAVES) : 1  

)(
    input   logic   clk     ,
    input   logic   rstn    ,

    input   logic   [SLAVE_SEL_BITS-1:0]    i_aw_slave_sel  ,
    input   logic                           i_aw_valid      ,
    input   logic                           i_w_valid       ,
    output  logic   [SLAVE_SEL_BITS-1:0]    o_w_slave_sel   ,
    output  logic                           o_w_slave_valid ,

    output  logic                           o_wd_full       ,
    output  logic                           o_wd_empty

);

    // FIFO buffer instantiation
    axi_sync_fifo #(
        .DATA_WIDTH(SLAVE_SEL_BITS),
        .DEPTH(MAX_OUTSTANDING)
    ) axi_sync_fifo_wd (
        .clk    (clk)           ,
        .rstn   (rstn)          ,
        .wr_en  (i_aw_valid)    ,
        .wr_data(i_aw_slave_sel),
        .rd_en  (i_w_valid)     ,
        .rd_data(o_w_slave_sel) ,
        .full   (o_wd_full)     ,
        .empty  (o_wd_empty)
    );

    assign o_w_slave_valid  = ~o_wd_empty;

endmodule