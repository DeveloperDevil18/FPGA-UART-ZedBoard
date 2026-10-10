## 100 MHz PL Clock
set_property PACKAGE_PIN Y9 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk [get_ports clk]

## BTNC - RESET
set_property PACKAGE_PIN P16 [get_ports btn]
set_property IOSTANDARD LVCMOS33 [get_ports btn]

## UART RX, Pmod JA1
set_property PACKAGE_PIN Y11 [get_ports uart_rx]
set_property IOSTANDARD LVCMOS33 [get_ports uart_rx]

## LEDs
set_property PACKAGE_PIN T22 [get_ports {led[0]}]
set_property PACKAGE_PIN T21 [get_ports {led[1]}]
set_property PACKAGE_PIN U22 [get_ports {led[2]}]
set_property PACKAGE_PIN U21 [get_ports {led[3]}]
set_property PACKAGE_PIN V22 [get_ports {led[4]}]
set_property PACKAGE_PIN W22 [get_ports {led[5]}]
set_property PACKAGE_PIN U19 [get_ports {led[6]}]
set_property PACKAGE_PIN U14 [get_ports {led[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]
