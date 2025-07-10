from scipy.signal import firwin
import numpy as np

# 1. Cài đặt thông số lọc
fs = 256
cutoff = 45
numtaps = 37

# 2. Thiết kế FIR LPF
lpf_coeffs = firwin(numtaps, cutoff, fs=fs, pass_zero=True)

# 3. Chuyển sang Q16.14 (1 dấu, 1 nguyên, 14 phân số)
q_format = 2**14
q14_coeffs = np.round(lpf_coeffs * q_format).astype(np.int16)

# 4. Xuất file .hex (dùng cho Verilog $readmemh)
with open(r"E:\ModelSim\FIR\coeffs\lpf_coeffs.hex", "w") as f:
    for coeff in q14_coeffs:
        hex_val = format(int(coeff) & 0xFFFF, '04x')  # Two's complement
        f.write(hex_val + '\n')

print("✅ Đã tạo hệ số LPF Q16.14 thành công!")
