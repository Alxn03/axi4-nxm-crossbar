// Copyright (c) 2026 Allen Appukuttan

// Licensed under the MIT License. 
// See LICENSE in the project root for license information.

module skid_buffer #(

    // Width of buffer register
    parameter BUF_WIDTH = 32
)(
    input   logic                   clk,
    input   logic                   rstn,

    // Skid Buffer Signals
    // Input payload data 
    output  logic                   o_ready,
    input   logic                   i_valid,
    input   logic [BUF_WIDTH-1:0]   i_data,

    // Output buffer payload
    input   logic                   i_ready, 
    output  logic                   o_valid,
    output  logic [BUF_WIDTH-1:0]   o_data

);

    // State Definition
    typedef enum logic {EMPTY=1'b0, FULL=1'b1} state_t;
    state_t state;

    // Pipeline register 
    logic [BUF_WIDTH-1:0]   data_reg, skid_reg;
    logic                   valid_reg;
    // Indicates if skid buffer is full 
    logic                   skid_full;

    // Skid Buffer Logic
    // Sequential Write  and Combinatorial Read
    always_ff@(posedge clk) begin
        if(!rstn) begin        
            state       <= EMPTY;
            skid_reg    <= '0;
            skid_full   <= '0;
            data_reg    <= '0;
            valid_reg   <= '0;
        end
        else begin

            case(state)
                // State where data can be forwarded or stored in a buffer
                EMPTY: begin
                    // If downstream is ready 
                    // forward incoming data and valid 
                    if(i_ready) begin
                        data_reg    <= i_data;
                        valid_reg   <= i_valid;
                        skid_full   <= 1'b0;
                        state       <= EMPTY;
                    end
                    // If downstream is not ready but i_valid = 1
                    // Store the input data in skid buffer register
                    // Hold valid_reg: valid_reg <= valid_reg until handshake
                    else if(i_valid) begin
                        skid_reg    <= i_data;
                        skid_full   <= 1'b1;
                        state       <= FULL;
                    end
                    // Else hold valid_reg
                    else begin
                        state       <= EMPTY;
                    end
                end
                // State where skid buffer is full
                FULL: begin
                    // When downstream is ready and input data is valid simultaneously
                    // Read output data from skid buffer and write input data to skid buffer
                    if(i_ready && i_valid) begin
                        data_reg    <= skid_reg;
                        valid_reg   <= 1'b1;
                        skid_reg    <= i_data;
                        skid_full   <= 1'b1;
                        state       <= FULL;
                   end
                   // When only downstream is ready and no input data
                   // Read output data from skid buffer and move to EMPTY
                   else if(i_ready) begin
                        data_reg    <= skid_reg;
                        valid_reg   <= 1'b1;
                        skid_full   <= 1'b0;
                        state       <= EMPTY;
                   end
                   // If downstream is not ready, hold valid reg until handshake
                   else begin
                        skid_full   <= 1'b1;
                        state       <= FULL;
                   end
               end
            endcase
        end
    end

    // Combinatorial outputs
    assign o_data   = data_reg;
    assign o_valid  = valid_reg;
    assign o_ready  = !skid_full || i_ready;

endmodule