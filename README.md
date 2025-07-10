# FIR Filter for ECG Signal

This project presents the design and implementation of a digital Finite Impulse Response (FIR) filter specialized for ECG (Electrocardiogram) signal processing. The filter is built using Verilog HDL and is intended for FPGA synthesis and simulation. Its primary purpose is to remove common types of noise such as baseline drift and high-frequency interference while preserving key features of the ECG waveform, including P, QRS, and T waves.

## Features

- Implementation of both low-pass and band-pass FIR filters
- Designed using the window method for coefficient generation
- Fully written in Verilog HDL
- Includes testbenches for waveform-level simulation
- Compatible with FPGA development tools such as Quartus II, ModelSim, and Vivado
- Accepts external ECG sample data for realistic testing

## Directory Structure

fir-filter-ecg/
├── src/ # Verilog source files for FIR filters
│ ├── bpf.v # Band-pass filter module
│ └── lpf.v # Low-pass filter module
├── testbench/ # Testbenches for simulation
│ ├── bpf_tb.v
│ └── lpf_tb.v
├── ecg_data/ # Sample ECG signal data in hex format
│ └── ecg_data_hex.txt
├── docs/ # Design documents or system diagrams (optional)
└── README.md # Project overview and usage guide

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/tangthuc/fir-filter-for-ecg-signal.git
cd fir-filter-for-ecg-signal
```
   
2. Open the project in your preferred HDL simulation/synthesis tool:

- Add the Verilog files from src/

- Add testbenches from testbench/

- Include ecg_data/ecg_data_hex.txt in your testbench if required

3. Run simulation:

- Observe input/output waveforms of the FIR filter modules

- Verify ECG waveform smoothing and noise reduction behavior
4. (Optional): Use MATLAB or Python to regenerate FIR coefficients for different cutoff frequencies or filter orders, then integrate them back into the Verilog modules.

Tools & Technologies
- Verilog HDL

- Quartus II / Vivado / ModelSim (for simulation & synthesis)

- Python / MATLAB (optional for coefficient generation or waveform comparison)

Applications
- Biomedical signal processing

- FPGA-based ECG monitoring systems

- Hardware-oriented digital filter design

- Educational and research purposes

Author
Tang Thuc
Digital IC Design Enthusiast | FPGA Developer
GitHub: [@tangthuc](https://github.com/tangthuc)

License
This project is licensed under the MIT License.

