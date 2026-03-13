// Copyright (c) 2026 Allen Appukuttan

// Licensed under the MIT License. 
// See LICENSE in the project root for license information

module axi_addr_decoder_tb;

parameter NUM_SLAVES        = 4;
parameter ADDR_WIDTH        = 32;
parameter BASE_ADDR_MASK    = 4;
parameter SLAVE_SEL_BITS    = (NUM_SLAVES > 0) ? $clog2(NUM_SLAVES) : 1;    

logic   [ADDR_WIDTH-1:0]    tb_axi_addr;
logic   [SLAVE_SEL_BITS-1:0]tb_slave_sel;
logic                       tb_slave_hit;
logic                       tb_default_slave;

// DUT instatiation
axi_addr_decoder #(
    .NUM_SLAVES(NUM_SLAVES),
    .ADDR_WIDTH(ADDR_WIDTH),
    .BASE_ADDR_MASK(BASE_ADDR_MASK)
) DUT   
(
    .i_axi_addr(tb_axi_addr)            ,
    .o_slave_sel(tb_slave_sel)          ,
    .o_slave_hit(tb_slave_hit)          ,
    .o_default_slave(tb_default_slave)
);

// Random Stimulus
initial begin
    repeat(20) begin
        tb_axi_addr     = $urandom();
    end
end

// VCD dump generation
initial begin
    $dumpfile("axi_addr_decoder_tb.vcd");
    $dumpvars(0,axi_addr_decoder_tb);
end

endmodule
