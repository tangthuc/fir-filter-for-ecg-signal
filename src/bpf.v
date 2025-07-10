`timescale 1ns / 1ps

module fir_bandpass_parallel_tree #(
    parameter N = 37,
    parameter COEFF_WIDTH = 16,
    parameter DATA_WIDTH = 16
)(
    input clk,
    input rst,
    input signed [DATA_WIDTH-1:0] x_in,
    output reg signed [DATA_WIDTH+COEFF_WIDTH+5:0] y_out
);

    // H? s? Q16.14
    reg signed [COEFF_WIDTH-1:0] coeffs [0:N-1];
    initial $readmemh("E:/ModelSim/Parallel_FIR/coeffs/bandpass_coeffs.hex", coeffs);

    // Shift register ch?a N m?u ??u v�o
    reg signed [DATA_WIDTH-1:0] x [0:N-1];
    integer i;

    // Pipeline multiply
    reg signed [DATA_WIDTH+COEFF_WIDTH-1:0] mult [0:N-1];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < N; i = i + 1) begin
                x[i] <= 0;
                mult[i] <= 0;
            end
        end else begin
            for (i = N-1; i > 0; i = i - 1)
                x[i] <= x[i-1];
            x[0] <= x_in;

            for (i = 0; i < N; i = i + 1)
                mult[i] <= x[i] * coeffs[i];
        end
    end

    // Tree c?ng 6 t?ng pipeline
    reg signed [DATA_WIDTH+COEFF_WIDTH+1:0] sum1 [0:18];
    reg signed [DATA_WIDTH+COEFF_WIDTH+2:0] sum2 [0:9];
    reg signed [DATA_WIDTH+COEFF_WIDTH+3:0] sum3 [0:4];
    reg signed [DATA_WIDTH+COEFF_WIDTH+4:0] sum4 [0:2];
    reg signed [DATA_WIDTH+COEFF_WIDTH+5:0] sum5 [0:1];
    reg signed [DATA_WIDTH+COEFF_WIDTH+6:0] sum6;

    // T?ng 1: 37 -> 19
    always @(posedge clk) begin
        for (i = 0; i < 18; i = i + 1)
            sum1[i] <= mult[2*i] + mult[2*i+1];
        sum1[18] <= mult[36];
    end

    // T?ng 2: 19 -> 10
    always @(posedge clk) begin
        for (i = 0; i < 9; i = i + 1)
            sum2[i] <= sum1[2*i] + sum1[2*i+1];
        sum2[9] <= sum1[18];
    end

    // T?ng 3: 10 -> 5
    always @(posedge clk) begin
        for (i = 0; i < 5; i = i + 1)
            sum3[i] <= sum2[2*i] + sum2[2*i+1];
    end

    // T?ng 4: 5 -> 3
    always @(posedge clk) begin
        sum4[0] <= sum3[0] + sum3[1];
        sum4[1] <= sum3[2] + sum3[3];
        sum4[2] <= sum3[4];
    end

    // T?ng 5: 3 -> 2
    always @(posedge clk) begin
        sum5[0] <= sum4[0] + sum4[1];
        sum5[1] <= sum4[2];
    end

    // T?ng 6: 2 -> 1 (cu?i c�ng)
    always @(posedge clk)
        sum6 <= sum5[0] + sum5[1];

    // D?ch v? ?�ng Q16.14 v� xu?t ra
    always @(posedge clk)
        y_out <= sum6 >>> 14;

endmodule
