`timescale 1ns / 1ps

module uart_tx_top(
    input  wire       clk,
    input  wire       btn,
    input  wire [7:0] sw,
    output wire       uart_tx,
    output wire [7:0] led
);

    wire tx_busy;

    assign led = sw;

    uart_tx #(
        .CLKS_PER_BIT(868)
    ) uart_tx_inst (
        .clk      (clk),
        .rst      (1'b0),
        .tx_start (btn),
        .tx_data  (sw),
        .tx       (uart_tx),
        .tx_busy  (tx_busy)
    );

endmodule
