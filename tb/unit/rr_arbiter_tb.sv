// Copyright (c) 2026 Allen Appukuttan

// Licensed under the MIT License. 
// See LICENSE in the project root for license information

module rr_arbiter_tb;

parameter NUM_REQ = 4;

logic   clk,
logic   rstn,

logic   [NUM_REQ-1:0]   tb_req;
logic   [NUM_REQ-1:0]   tb_gnt;

// Scoreboard signals
logic   exp_gnt;
logic   priority_ptr; 

// DUT Instantiation
rr_arbiter #(

    .NUM_REQ(NUM_REQ)

) rr_arbiter_DUT
(
    .clk(clk)   ,
    .rstn(rstn) ,

    .req(tb_req),
    .gnt(tb_gnt)
);


// Clock generation
initial begin
    clk     = 0;
    forever #5 clk = ~clk;
end

// Monitor
initial begin
    $monitor("Time:%0t | req=%0b, gnt=%0b",$time, tb_req, tb_gnt);
end

// Scoreboard

// Stimulus
initial begin

    apply_reset;
    #10;

    tb_req      = '0;
    // Test 1: Check proper gnt generation 
    $display("START: Test 1 - gnt generation");
    repeat(16) begin
        @(posedge clk);
        tb_req  = tb_req + 1; 
    end
    $display("END: Test 1 Complete");

    #20;

    // Test 2: Check priority pointer transition 
    $display("START: Test 2 - Check priority pointer transistion");
    repeat(16) begin
        @(posedge clk);
        tb_req  = '1111;
    end
    $display("END: Test 2 Complete");

    #20;

    // Test 3: Check mask generation for consecutive requests
    $display("START: Test 3 - Mask gneeration for consecutive requests");
    repeat(4) begin
        @(posedge clk);
        tb_req  = 1;
    end
    $display("END: Test 3 Complete");

    #20;

    // Test 4: Random Stimulus
    $display("START: Test 4 - Random Stimulus");
    repeat(10) begin
        @(posedge clk);
        tb_req = $urandom_range(0,(2**NUM_REQ)-1);
    end
    $display("END: Test 4 Complete");

    $20;

    $finish;

end

//VCD generation
initial begin
    $dumpfile("rr_arbiter_tb.vcd");
    $dumpvars(0,rr_arbiter_tb);
end

// Task to apply reset
task apply_reset;

    req     = '0;
    rstn    = 0;

    #20;

    rstn    = 1;

endtask

endmodule
