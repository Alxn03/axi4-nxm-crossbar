# AXI4 Parametrizable Crossbar Interconnect

SystemVerilog implementation of a fully AXI4-compliant NxM crossbar
NoC interconnect with parametric topology, round-robin arbitration,
and per-slave write data tracking.

## Status
- [ ] Phase 1: axi4_master_if(skid_buffer)

## Parameters
| Parameter | Default | Range | Description |
|---|---|---|---|
| NUM_MASTERS | 4 | 1-8 | Number of AXI4 master ports |
| NUM_SLAVES | 4 | 1-8 | Number of AXI4 slave ports |
| DATA_WIDTH | 32 | 32,64,128 | Data bus width in bits |
| ADDR_WIDTH | 32 | 32,64 | Address bus width in bits |
| ID_WIDTH | 4 | 1-8 | Per-master transaction ID width |

## Tools
- HDL: SystemVerilog
- Protocol: ARM AXI4 (IHI0022E)

## Results

## References
- ARM IHI0022E — AMBA AXI and ACE Protocol Specification
- Alex Forencich verilog-axi: github.com/alexforencich/verilog-axi
- ZipCPU AXI4 Blog: zipcpu.com
