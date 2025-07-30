`timescale 1ns / 1ps

module fir_bandpass_parallel_tree_unrolled (
    input clk,
    input rst,
    input signed [15:0] x_in,
    output reg signed [37+16+5:0] y_out
);

    // Tham s?
    parameter N = 37;
    localparam COEFF_WIDTH = 16;
    localparam DATA_WIDTH = 16;

    // Coefficients Q16.14
    reg signed [COEFF_WIDTH-1:0] coeffs [0:N-1];
    initial $readmemh("E:/ModelSim/Parallel_FIR/coeffs/bandpass_coeffs.hex", coeffs);

    // Shift register & multipliers
    reg signed [DATA_WIDTH-1:0] x[0:N-1];
    reg signed [DATA_WIDTH+COEFF_WIDTH-1:0] mult[0:N-1];

    // Tree pipeline registers
    reg signed [DATA_WIDTH+COEFF_WIDTH+1:0] sum1 [0:18];    // 19
    reg signed [DATA_WIDTH+COEFF_WIDTH+2:0] sum2 [0:9];     // 10
    reg signed [DATA_WIDTH+COEFF_WIDTH+3:0] sum3 [0:4];     // 5
    reg signed [DATA_WIDTH+COEFF_WIDTH+4:0] sum4 [0:2];     // 3
    reg signed [DATA_WIDTH+COEFF_WIDTH+5:0] sum5 [0:1];     // 2
    reg signed [DATA_WIDTH+COEFF_WIDTH+6:0] sum6;           // 1

    // Shift register and multiply
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x[0] <= 0;  x[1] <= 0;  x[2] <= 0;  x[3] <= 0;  x[4] <= 0;
            x[5] <= 0;  x[6] <= 0;  x[7] <= 0;  x[8] <= 0;  x[9] <= 0;
            x[10] <= 0; x[11] <= 0; x[12] <= 0; x[13] <= 0; x[14] <= 0;
            x[15] <= 0; x[16] <= 0; x[17] <= 0; x[18] <= 0; x[19] <= 0;
            x[20] <= 0; x[21] <= 0; x[22] <= 0; x[23] <= 0; x[24] <= 0;
            x[25] <= 0; x[26] <= 0; x[27] <= 0; x[28] <= 0; x[29] <= 0;
            x[30] <= 0; x[31] <= 0; x[32] <= 0; x[33] <= 0; x[34] <= 0;
            x[35] <= 0; x[36] <= 0;

            mult[0] <= 0;  mult[1] <= 0;  mult[2] <= 0;  mult[3] <= 0;
            mult[4] <= 0;  mult[5] <= 0;  mult[6] <= 0;  mult[7] <= 0;
            mult[8] <= 0;  mult[9] <= 0;  mult[10] <= 0; mult[11] <= 0;
            mult[12] <= 0; mult[13] <= 0; mult[14] <= 0; mult[15] <= 0;
            mult[16] <= 0; mult[17] <= 0; mult[18] <= 0; mult[19] <= 0;
            mult[20] <= 0; mult[21] <= 0; mult[22] <= 0; mult[23] <= 0;
            mult[24] <= 0; mult[25] <= 0; mult[26] <= 0; mult[27] <= 0;
            mult[28] <= 0; mult[29] <= 0; mult[30] <= 0; mult[31] <= 0;
            mult[32] <= 0; mult[33] <= 0; mult[34] <= 0; mult[35] <= 0;
            mult[36] <= 0;
        end else begin
            x[36] <= x[35]; x[35] <= x[34]; x[34] <= x[33]; x[33] <= x[32];
            x[32] <= x[31]; x[31] <= x[30]; x[30] <= x[29]; x[29] <= x[28];
            x[28] <= x[27]; x[27] <= x[26]; x[26] <= x[25]; x[25] <= x[24];
            x[24] <= x[23]; x[23] <= x[22]; x[22] <= x[21]; x[21] <= x[20];
            x[20] <= x[19]; x[19] <= x[18]; x[18] <= x[17]; x[17] <= x[16];
            x[16] <= x[15]; x[15] <= x[14]; x[14] <= x[13]; x[13] <= x[12];
            x[12] <= x[11]; x[11] <= x[10]; x[10] <= x[9];  x[9]  <= x[8];
            x[8]  <= x[7];  x[7]  <= x[6];  x[6]  <= x[5];  x[5]  <= x[4];
            x[4]  <= x[3];  x[3]  <= x[2];  x[2]  <= x[1];  x[1]  <= x[0];
            x[0]  <= x_in;

            mult[0]  <= x[0]  * coeffs[0];   mult[1]  <= x[1]  * coeffs[1];
            mult[2]  <= x[2]  * coeffs[2];   mult[3]  <= x[3]  * coeffs[3];
            mult[4]  <= x[4]  * coeffs[4];   mult[5]  <= x[5]  * coeffs[5];
            mult[6]  <= x[6]  * coeffs[6];   mult[7]  <= x[7]  * coeffs[7];
            mult[8]  <= x[8]  * coeffs[8];   mult[9]  <= x[9]  * coeffs[9];
            mult[10] <= x[10] * coeffs[10];  mult[11] <= x[11] * coeffs[11];
            mult[12] <= x[12] * coeffs[12];  mult[13] <= x[13] * coeffs[13];
            mult[14] <= x[14] * coeffs[14];  mult[15] <= x[15] * coeffs[15];
            mult[16] <= x[16] * coeffs[16];  mult[17] <= x[17] * coeffs[17];
            mult[18] <= x[18] * coeffs[18];  mult[19] <= x[19] * coeffs[19];
            mult[20] <= x[20] * coeffs[20];  mult[21] <= x[21] * coeffs[21];
            mult[22] <= x[22] * coeffs[22];  mult[23] <= x[23] * coeffs[23];
            mult[24] <= x[24] * coeffs[24];  mult[25] <= x[25] * coeffs[25];
            mult[26] <= x[26] * coeffs[26];  mult[27] <= x[27] * coeffs[27];
            mult[28] <= x[28] * coeffs[28];  mult[29] <= x[29] * coeffs[29];
            mult[30] <= x[30] * coeffs[30];  mult[31] <= x[31] * coeffs[31];
            mult[32] <= x[32] * coeffs[32];  mult[33] <= x[33] * coeffs[33];
            mult[34] <= x[34] * coeffs[34];  mult[35] <= x[35] * coeffs[35];
            mult[36] <= x[36] * coeffs[36];
        end
    end

    // Layer 1: 37 -> 19
    always @(posedge clk) begin
        sum1[0]  <= mult[0] + mult[1];
        sum1[1]  <= mult[2] + mult[3];
        sum1[2]  <= mult[4] + mult[5];
        sum1[3]  <= mult[6] + mult[7];
        sum1[4]  <= mult[8] + mult[9];
        sum1[5]  <= mult[10] + mult[11];
        sum1[6]  <= mult[12] + mult[13];
        sum1[7]  <= mult[14] + mult[15];
        sum1[8]  <= mult[16] + mult[17];
        sum1[9]  <= mult[18] + mult[19];
        sum1[10] <= mult[20] + mult[21];
        sum1[11] <= mult[22] + mult[23];
        sum1[12] <= mult[24] + mult[25];
        sum1[13] <= mult[26] + mult[27];
        sum1[14] <= mult[28] + mult[29];
        sum1[15] <= mult[30] + mult[31];
        sum1[16] <= mult[32] + mult[33];
        sum1[17] <= mult[34] + mult[35];
        sum1[18] <= mult[36];
    end

    // Layer 2: 19 -> 10
    always @(posedge clk) begin
        sum2[0] <= sum1[0] + sum1[1];
        sum2[1] <= sum1[2] + sum1[3];
        sum2[2] <= sum1[4] + sum1[5];
        sum2[3] <= sum1[6] + sum1[7];
        sum2[4] <= sum1[8] + sum1[9];
        sum2[5] <= sum1[10] + sum1[11];
        sum2[6] <= sum1[12] + sum1[13];
        sum2[7] <= sum1[14] + sum1[15];
        sum2[8] <= sum1[16] + sum1[17];
        sum2[9] <= sum1[18];
    end

    // Layer 3: 10 -> 5
    always @(posedge clk) begin
        sum3[0] <= sum2[0] + sum2[1];
        sum3[1] <= sum2[2] + sum2[3];
        sum3[2] <= sum2[4] + sum2[5];
        sum3[3] <= sum2[6] + sum2[7];
        sum3[4] <= sum2[8] + sum2[9];
    end

    // Layer 4: 5 -> 3
    always @(posedge clk) begin
        sum4[0] <= sum3[0] + sum3[1];
        sum4[1] <= sum3[2] + sum3[3];
        sum4[2] <= sum3[4];
    end

    // Layer 5: 3 -> 2
    always @(posedge clk) begin
        sum5[0] <= sum4[0] + sum4[1];
        sum5[1] <= sum4[2];
    end

    // Layer 6: 2 -> 1
    always @(posedge clk) begin
        sum6 <= sum5[0] + sum5[1];
    end

    // Final output (Q16.14 >> 14)
    always @(posedge clk) begin
        y_out <= sum6 >>> 14;
    end

endmodule

