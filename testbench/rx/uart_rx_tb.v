`timescale 1ns / 1ps

module uart_rx_tb;
    reg        clk;
    reg        btn;
    reg        uart_rx;
    wire [7:0] led;

    uart_rx_top uut (
        .clk     (clk),
        .btn     (btn),
        .uart_rx (uart_rx),
        .led     (led)
    );

    always #5 clk = ~clk;

    task send_bit;
        input bit_value;
        begin
            uart_rx = bit_value;
            #8680;
        end
    endtask

    task send_byte;
        input [7:0] data;
        integer i;
        begin
            send_bit(1'b0); // start bit
            for (i = 0; i < 8; i = i + 1)
                send_bit(data[i]); // LSB first
            send_bit(1'b1); // stop bit
        end
    endtask

    initial begin
        clk     = 1'b0;
        btn     = 1'b1;
        uart_rx = 1'b1; // UART idle

        #100;
        btn = 1'b0;

        #10000;
        send_byte(8'hA5);
        #10000;
        $finish;
    end
endmodule
