`timescale 1ns / 1ps

module uart_rx_top(
    input  wire       clk,
    input  wire       btn,
    input  wire       uart_rx,
    output wire [7:0] led
);

    wire [7:0] rx_data;
    wire       rx_valid;

    uart_rx #(
        .CLKS_PER_BIT(868)
    ) uart_rx_inst (
        .clk      (clk),
        .rst      (btn),
        .rx       (uart_rx),
        .rx_data  (rx_data),
        .rx_valid (rx_valid)
    );

    assign led = rx_data;

endmodule
