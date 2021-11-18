`timescale 1ns/100ps
`define CYCLE       10.0     // CLK period.
`define HCYCLE      (`CYCLE/2)
`define MAX_CYCLE   10000000
`define RST_DELAY   2


`ifdef tb1
    `define INFILE "./PATTERN/indata1.dat"
    `define OPFILE "./PATTERN/opmode1.dat"
    `define GOLDEN "./PATTERN/golden1.dat"
`elsif tb2
    `define INFILE "./PATTERN/indata2.dat"
    `define OPFILE "./PATTERN/opmode2.dat"
    `define GOLDEN "./PATTERN/golden2.dat"
`elsif tb3
    `define INFILE "./PATTERN/indata3.dat"
    `define OPFILE "./PATTERN/opmode3.dat"
    `define GOLDEN "./PATTERN/golden3.dat"
`else
    `define INFILE "../00_TESTBED/PATTERN/indata0.dat"
    `define OPFILE "../00_TESTBED/PATTERN/opmode0.dat"
    `define GOLDEN "../00_TESTBED/PATTERN/golden0.dat"
`endif

`define SDFFILE "ipdc_syn.sdf"  // Modify your sdf file name


module testbed;

reg clk, rst_n;
wire        i_op_valid;
wire [ 3:0] i_op_mode;
wire        o_op_ready;
wire        i_in_valid;
wire [23:0] i_in_data;
wire        o_in_ready;
wire        o_out_valid;
wire [23:0] o_out_data;

reg [23:0] indata_mem [ 255:0];
reg [ 3:0] opmode_mem [ 63:0];
reg [23:0] golden_mem [1023:0];


// ==============================================
// TODO: Declare regs and wires you need
// ==============================================


// For gate-level simulation only
`ifdef SDF
    initial $sdf_annotate(`SDFFILE, u_ipdc);
    initial #1 $display("SDF File %s were used for this simulation.", `SDFFILE);
`endif

// Write out waveform file
initial begin
  $fsdbDumpfile("ipdc.fsdb");
  $fsdbDumpvars(3, "+mda");
end


ipdc u_ipdc (
	.i_clk(clk),
	.i_rst_n(rst_n),
	.i_op_valid(i_op_valid),
	.i_op_mode(i_op_mode),
    .o_op_ready(o_op_ready),
	.i_in_valid(i_in_valid),
	.i_in_data(i_in_data),
	.o_in_ready(o_in_ready),
	.o_out_valid(o_out_valid),
	.o_out_data(o_out_data)
);

// Read in test pattern and golden pattern
initial $readmemb(`INFILE, indata_mem);
initial $readmemb(`OPFILE, opmode_mem);
initial $readmemb(`GOLDEN, golden_mem);

// Clock generation
initial clk = 1'b0;
always begin #(`CYCLE/2) clk = ~clk; end

// Reset generation
initial begin
    rst_n = 1; # (               0.25 * `CYCLE);
    rst_n = 0; # ((`RST_DELAY - 0.25) * `CYCLE);
    rst_n = 1; # (         `MAX_CYCLE * `CYCLE);
    $display("Error! Runtime exceeded!");
    $finish;
end

// ==============================================
// TODO: Check pattern after process finish
// ==============================================

//tb0
initial 
begin
    golden_index = 0;
    i_op_valid = 1'b0;
    i_op_mode = 4'b0;
    i_in_valid = 1'b0;
    i_in_data = 24'b0;
    #(`CYCLE);
    
end

endmodule
