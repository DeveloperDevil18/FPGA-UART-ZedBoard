`timescale 1ns / 1ps

module uart_tx #(
    parameter CLKS_PER_BIT = 868
)(
    input  wire       clk,
    input  wire       rst,
    input  wire       tx_start,
    input  wire [7:0] tx_data,
    output reg        tx,
    output reg        tx_busy
);

    reg [15:0] clk_count;
    reg [2:0]  bit_index;
    reg [7:0]  data_reg;

    localparam IDLE  = 2'd0;
    localparam START = 2'd1;
    localparam DATA  = 2'd2;
    localparam STOP  = 2'd3;

    reg [1:0] state;

    always @(posedge clk) begin
        if (rst) begin
            state     <= IDLE;
            clk_count <= 16'd0;
            bit_index <= 3'd0;
            data_reg  <= 8'd0;
            tx        <= 1'b1;
            tx_busy   <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    tx        <= 1'b1;
                    tx_busy   <= 1'b0;
                    clk_count <= 16'd0;
                    bit_index <= 3'd0;
                    if (tx_start) begin
                        data_reg <= tx_data;
                        tx_busy  <= 1'b1;
                        state    <= START;
                    end
                end

                START: begin
                    tx <= 1'b0;
                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 1'b1;
                    end else begin
                        clk_count <= 16'd0;
                        state     <= DATA;
                    end
                end

                DATA: begin
                    tx <= data_reg[bit_index];
                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 1'b1;
                    end else begin
                        clk_count <= 16'd0;
                        if (bit_index < 3'd7) begin
                            bit_index <= bit_index + 1'b1;
                        end else begin
                            bit_index <= 3'd0;
                            state     <= STOP;
                        end
                    end
                end

                STOP: begin
                    tx <= 1'b1;
                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 1'b1;
                    end else begin
                        clk_count <= 16'd0;
                        tx_busy   <= 1'b0;
                        state     <= IDLE;
                    end
                end

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
