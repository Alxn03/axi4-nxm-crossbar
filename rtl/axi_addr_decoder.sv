// Copyright (c) 2026 Allen Appukuttan

// Licensed under the MIT License. 
// See LICENSE in the project root for license information

module axi_addr_decoder #(

    parameter NUM_SLAVES        = 4     ,
    parameter ADDR_WIDTH        = 32    ,
    parameter BASE_ADDR_MASK    = 4     ,
    parameter SLAVE_SEL_BITS    = (NUM_SLAVES > 1) ? $clog2(NUM_SLAVES) : 1

)(
    input   logic   [ADDR_WIDTH-1:0]        i_axi_addr      ,
    output  logic   [SLAVE_SEL_BITS-1:0]    o_slave_sel     ,
    output  logic                           o_slave_hit     ,
    output  logic                           o_default_slave
);

    // Simple address decoder; Select MSB 4-bits to decode slave address
    always_comb begin
        o_slave_sel     = i_axi_addr[ADDR_WIDTH-1 -: BASE_ADDR_MASK]                                ;
        o_slave_hit     = (i_axi_addr[ADDR_WIDTH-1 -: BASE_ADDR_MASK]) < NUM_SLAVES ? 1'b1 : 1'b0   ;
        o_default_slave = ~o_slave_hit                                                              ;
    end

endmodule