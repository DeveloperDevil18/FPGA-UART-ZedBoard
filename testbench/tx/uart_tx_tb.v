`timescale 1ns / 1ps

module uart_tx_tb;
    reg        clk;
    reg        btn;
    reg [7:0]  sw;
    wire       uart_tx;
    wire [7:0] led;

    uart_tx_top uut (
        .clk     (clk),
        .btn     (btn),
        .sw      (sw),
        .uart_tx (uart_tx),
        .led     (led)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        btn = 1'b0;
        sw  = 8'b00000000;

        #100;
        sw = 8'b10100101;  // test byte 0xA5
        #100;
        btn = 1'b1;
        #20;
        btn = 1'b0;
        #100220;
        $finish;
    end
endmodule
