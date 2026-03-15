// Copyright (c) 2026 Allen Appukuttan

// Licensed under the MIT License. 
// See LICENSE in the project root for license information.

module axi_sync_fifo #(

    parameter DATA_WIDTH = 32,
    parameter DEPTH      = 8

)(
    input   logic   clk     ,
    input   logic   rstn    ,

    input   logic                       wr_en   ,
    input   logic   [DATA_WIDTH-1:0]    wr_data ,
    input   logic                       rd_en   ,
    
    output  logic   [DATA_WIDTH-1:0]    rd_data ,

    output  logic                       full,
    output  logic                       empty
);

    // pointer width; extra bit for 'full' condition calculation
    localparam PTR_WIDTH = $clog2(DEPTH);

    // fifo memory register
    logic   [DATA_WIDTH-1:0]    fifo_mem [DEPTH-1:0];

    // write and read pointers
    logic   [PTR_WIDTH:0]       wr_ptr, rd_ptr;

    // write dataflow
    always_ff@(posedge clk) begin
        if(!rstn) begin
            wr_ptr  <= '0;
        end
        else begin
            if(wr_en & !full) begin
                fifo_mem[wr_ptr[PTR_WIDTH-1:0]] <= wr_data      ;
                wr_ptr                          <= wr_ptr + 1   ;
            end
        end
    end

    // read dataflow
    always_ff@(posedge clk) begin
        if(!rstn) begin
            rd_data     <= '0;
            rd_ptr      <= '0;
        end
        else begin
            if(rd_en & !empty) begin
                rd_data <= fifo_mem[rd_ptr[PTR_WIDTH-1:0]] ;
                rd_ptr  <= rd_ptr + 1       ;
            end
        end
    end

    assign full     = ({~wr_ptr[PTR_WIDTH],wr_ptr[PTR_WIDTH-1:0]} == {rd_ptr[PTR_WIDTH:0]}) ;
    assign empty    = (wr_ptr == rd_ptr)                                                    ;   

endmodule
