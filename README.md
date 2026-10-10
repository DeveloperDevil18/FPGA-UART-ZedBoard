# FPGA-to-FPGA UART Communication Using Verilog HDL

A hardware-verified UART serial communication project between two Digilent ZedBoard FPGA boards (Zynq-7000 XC7Z020), implemented in Verilog HDL using Xilinx Vivado.

## Project overview

- **Board 1:** UART transmitter
- **Board 2:** UART receiver
- **Clock:** 100 MHz PL clock
- **UART baud rate:** 115200
- **UART format:** 8 data bits, no parity, 1 stop bit (8N1)
- **Data width:** 8 bits
- **Interface:** Pmod JA1
- **Display:** Receiver's 8 user LEDs

The transmitter reads `SW[7:0]`, sends the selected byte when BTNC is pressed, and the receiver displays the received byte on its LEDs. The design was simulated in Vivado and tested on two physical ZedBoards.

> The transmitter's current top-level design uses BTNC directly as `tx_start`, so holding the button or button bounce can cause another transmission. A debounced one-shot button controller can be added as a future improvement.

## Repository structure

```text
FPGA_UART_ZedBoard_GitHub/
├── README.md
├── .gitignore
├── src/
│   ├── tx/
│   │   ├── uart_tx.v
│   │   └── uart_tx_top.v
│   └── rx/
│       ├── uart_rx.v
│       └── uart_rx_top.v
├── constraints/
│   ├── UART_TX_ZEDBOARD.xdc
│   └── UART_RX_ZEDBOARD.xdc
└── testbench/
    ├── tx/uart_tx_tb.v
    └── rx/uart_rx_tb.v
```

## Hardware connections

Connect the boards while powered off, then power them on.

| Transmitter board | Receiver board | Purpose |
|---|---|---|
| Pmod JA1 (TX) | Pmod JA1 (RX) | UART data |
| GND | GND | Common signal reference |

**Do not connect the 3.3 V pins between the boards.** Confirm the physical connector pin numbering from the ZedBoard silkscreen/manual before wiring.

## Requirements

- Two ZedBoard FPGA boards based on XC7Z020
- Xilinx Vivado with ZedBoard device support
- Two jumper wires for signal and common ground
- USB power/programming connections appropriate for the boards

## Create the transmitter project in Vivado

1. Open Vivado and select **Create Project**.
2. Name it `UART_TX_ZEDBOARD`.
3. Select **RTL Project** and enable **Do not specify sources at this time** if you prefer adding files in the next steps.
4. Select the exact ZedBoard target: `xc7z020clg484-1` (or the matching ZedBoard board preset if installed).
5. Add `src/tx/uart_tx.v` and `src/tx/uart_tx_top.v` as design sources.
6. Add `constraints/UART_TX_ZEDBOARD.xdc` as a constraints file.
7. Set `uart_tx_top` as the top module.
8. Run **Run Synthesis**, then **Run Implementation**, then **Generate Bitstream**.
9. Connect the transmitter ZedBoard and program it with the generated bitstream.

## Create the receiver project in Vivado

1. Create a separate RTL project named `UART_RX_ZEDBOARD`.
2. Select the same ZedBoard target (`xc7z020clg484-1`).
3. Add `src/rx/uart_rx.v` and `src/rx/uart_rx_top.v`.
4. Add `constraints/UART_RX_ZEDBOARD.xdc`.
5. Set `uart_rx_top` as the top module.
6. Run **Run Synthesis**, **Run Implementation**, and **Generate Bitstream**.
7. Program the second ZedBoard with the receiver bitstream.

## Simulate the designs

### TX simulation

1. Add `testbench/tx/uart_tx_tb.v` under **Simulation Sources** in the TX project.
2. Set `uart_tx_tb` as the simulation top.
3. Run **Run Simulation → Run Behavioral Simulation**.
4. Check that `uart_tx` idles high, goes low for the start bit, sends `0xA5` least-significant-bit first, and returns high for the stop bit.

### RX simulation

1. Add `testbench/rx/uart_rx_tb.v` under **Simulation Sources** in the RX project.
2. Set `uart_rx_tb` as the simulation top.
3. Run **Run Simulation → Run Behavioral Simulation**.
4. The received value should become `8'hA5`; the top-level LEDs reflect `rx_data`.

## Hardware test procedure

1. Program Board 1 with the TX bitstream and Board 2 with the RX bitstream.
2. Connect JA1-to-JA1 and GND-to-GND.
3. On Board 1, set switches `SW7..SW0` to `10100101` (`0xA5`).
4. Press and release **BTNC** on Board 2 to reset the receiver.
5. Press and release **BTNC** on Board 1 to transmit.
6. The receiver LEDs should display `10100101`.

Try other byte patterns such as `01010101` (`0x55`), `10101010` (`0xAA`), `11110000` (`0xF0`), and `00001111` (`0x0F`).

## Pin mapping

### Common signals

- PL clock: 100 MHz, package pin `Y9`
- BTNC: package pin `P16`
- Pmod JA1: package pin `Y11`
- User LEDs `LD0..LD7`: `T22, T21, U22, U21, V22, W22, U19, U14`
- Switches `SW0..SW7`: `F22, G22, H22, F21, H19, H18, H17, M15`

## Known notes

- The UART bit period is based on `CLKS_PER_BIT = 868`, approximating 115200 baud from 100 MHz.
- A Vivado `ZPS7-1` DRC warning about the PS7 block may appear in this PL-only design. The transmitter/receiver logic itself can synthesize without errors; check the messages in your specific Vivado version and ensure bitstream generation succeeds.
- The design is a simple single-byte demonstration, not a buffered or full-duplex UART system.
- The TX button input is not yet debounced or edge-detected.

## Future improvements

- Add button synchronization, debounce, and one-shot pulse generation.
- Add a `tx_busy` LED/status output.
- Add selectable baud rates and reset synchronization.
- Extend the design to repeated-byte transmission or bidirectional UART.

## License

Choose a license before publishing if you intend others to reuse this project (for example, MIT). Check the terms applicable to any vendor IP or board files you include. This repository contains project HDL, constraints, and testbenches, not vendor installation files.
