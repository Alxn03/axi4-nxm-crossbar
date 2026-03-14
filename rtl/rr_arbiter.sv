
// Copyright (c) 2026 Allen Appukuttan

// Licensed under the MIT License. 
// See LICENSE in the project root for license information.

module rr_arbiter #(
    // No. of requests
    parameter NUM_REQ   = 4 ,
    parameter IDX_WIDTH = (NUM_REQ > 1) ? $clog2(NUM_REQ) : 1
)(
    input   logic   clk     ,
    input   logic   rstn    ,

    input   logic   [NUM_REQ-1:0]   i_req       ,
    input   logic                   i_update    ,
    output  logic   [NUM_REQ-1:0]   o_gnt       ,
    output  logic   [IDX_WIDTH-1:0] o_gnt_idx   
);
    
    // Mask to enforce next priority 
    logic   [NUM_REQ-1:0]   mask                    ;
    logic   [NUM_REQ-1:0]   next_mask               ;

    // Mask for fixed priority arbitration
    logic   [NUM_REQ-1:0]   higher_pri_req_masked   ;
    logic   [NUM_REQ-1:0]   higher_pri_req          ;

    // Signals for round robin arbitration
    logic   [NUM_REQ-1:0]   req_masked              ; 
    logic   [NUM_REQ-1:0]   gnt_masked              ; 
    logic   [NUM_REQ-1:0]   gnt_unmasked            ; 

    // Mask transition 
    always_ff@(posedge clk) begin
        if(!rstn) 
            mask        <= '1           ;
        else
            mask        <= next_mask    ;
    end

    // Next mask priority logic
    always_comb begin
        if(o_gnt == '0) begin
            next_mask   =  mask         ;
        end
        else if(i_update) begin
            next_mask   = '1            ;

            for(int i=0; i<NUM_REQ; i++) begin
               next_mask[i]     = 1'b0  ; 
               if(o_gnt[i]) break       ;
            end
        end
        else begin
            next_mask   = mask          ;
        end
    end

    // Masked request
    assign req_masked  = i_req & mask;

    // Simple masked fixed priority arbiter
    assign higher_pri_req_masked[0]             = 0 ;
    assign higher_pri_req_masked[NUM_REQ-1:1]   = higher_pri_req_masked[NUM_REQ-2:0] | req_masked[NUM_REQ-2:0];
    assign gnt_masked                           = ~higher_pri_req_masked & req_masked;

    // Simple unmasked fixed priority arbiter
    assign higher_pri_req[0]                    = 0 ;
    assign higher_pri_req[NUM_REQ-1:1]          = higher_pri_req[NUM_REQ-2:0] | i_req[NUM_REQ-2:0];
    assign gnt_unmasked                         = ~higher_pri_req & i_req;

    // Select round robin gnt_unmasked if req_masked = 0 else gnt_masked
    assign o_gnt    = (|req_masked) ? gnt_masked : gnt_unmasked;
    
    // Grant index generation
    always_comb begin
        o_gnt_idx   = '0;
        for(int i=0; i<NUM_REQ; i++) begin
            if(o_gnt[i]) begin  
                o_gnt_idx   = i;
                break;
            end
        end
    end

endmodule