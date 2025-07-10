`timescale 1ns / 1ps

module fir_lowpass_parallel_tree_tb;

    parameter N = 37;
    reg clk, rst;
    reg signed [15:0] x_in;
    wire signed [37:0] y_out;

    reg signed [15:0] mem [0:999];
    integer i;
    integer f;

    // Clock 100MHz
    always #5 clk = ~clk;

    // G?n DUT
    fir_lowpass_parallel_tree #(
        .N(N)
    ) dut (
        .clk(clk),
        .rst(rst),
        .x_in(x_in),
        .y_out(y_out)
    );

    initial begin
        f = $fopen("E:/Vivado/Project/project_1/data/output_lpf_parallel_tree.txt", "w");

        clk = 0;
        rst = 1;
        x_in = 0;

        $readmemh("E:/Vivado/Project/project_1/data/ecg_data_hex.txt", mem);

        #20;
        rst = 0;

        for (i = 0; i < 1000 + N - 1; i = i + 1) begin
            if (i < 1000)
                x_in = mem[i];
            else
                x_in = 0;

            #10;

            if (i >= N - 1 && i < 1000 + N - 1)
                $fdisplay(f, "%0d", y_out);
        end

        $fclose(f);
        #100;
        $finish;
    end

endmodule

