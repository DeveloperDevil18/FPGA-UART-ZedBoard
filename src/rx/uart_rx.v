`timescale 1ns / 1ps

module uart_rx #(
    parameter CLKS_PER_BIT = 868
)(
    input  wire       clk,
    input  wire       rst,
    input  wire       rx,
    output reg [7:0]  rx_data,
    output reg        rx_valid
);

    reg rx_sync_1;
    reg rx_sync_2;

    always @(posedge clk) begin
        if (rst) begin
            rx_sync_1 <= 1'b1;
            rx_sync_2 <= 1'b1;
        end else begin
            rx_sync_1 <= rx;
            rx_sync_2 <= rx_sync_1;
        end
    end

    localparam IDLE  = 2'd0;
    localparam START = 2'd1;
    localparam DATA  = 2'd2;
    localparam STOP  = 2'd3;

    reg [1:0] state;
    reg [15:0] clk_count;
    reg [2:0] bit_index;
    reg [7:0] data_reg;

    always @(posedge clk) begin
        if (rst) begin
            state     <= IDLE;
            clk_count <= 16'd0;
            bit_index <= 3'd0;
            data_reg  <= 8'd0;
            rx_data   <= 8'd0;
            rx_valid  <= 1'b0;
        end else begin
            rx_valid <= 1'b0;

            case (state)
                IDLE: begin
                    clk_count <= 16'd0;
                    bit_index <= 3'd0;
                    if (rx_sync_2 == 1'b0)
                        state <= START;
                end

                START: begin
                    if (clk_count < (CLKS_PER_BIT / 2) - 1) begin
                        clk_count <= clk_count + 1'b1;
                    end else begin
                        clk_count <= 16'd0;
                        if (rx_sync_2 == 1'b0)
                            state <= DATA;
                        else
                            state <= IDLE;
                    end
                end

                DATA: begin
                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 1'b1;
                    end else begin
                        clk_count <= 16'd0;
                        data_reg[bit_index] <= rx_sync_2;
                        if (bit_index < 3'd7) begin
                            bit_index <= bit_index + 1'b1;
                        end else begin
                            bit_index <= 3'd0;
                            state <= STOP;
                        end
                    end
                end

                STOP: begin
                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 1'b1;
                    end else begin
                        clk_count <= 16'd0;
                        if (rx_sync_2 == 1'b1) begin
                            rx_data  <= data_reg;
                            rx_valid <= 1'b1;
                        end
                        state <= IDLE;
                    end
                end

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
