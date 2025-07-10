import numpy as np
from scipy.signal import firwin

# ==== Thông số thiết kế ====
num_taps = 37             # Số hệ số (lẻ để đối xứng)
fs = 256                   # Tần số lấy mẫu (Hz)
low_cutoff = 0.7           # Tần số cắt dưới (Hz)
high_cutoff = 45.0         # Tần số cắt trên (Hz)

# ==== Thiết kế bộ lọc FIR thông dải ====
coeffs = firwin(num_taps, [low_cutoff, high_cutoff], pass_zero=False, fs=fs)

# ==== Chuyển sang Q16.14 (16-bit signed) ====
coeffs_fixed = np.round(coeffs * (2**14)).astype(np.int16)

# ==== Ghi file HEX: unsigned 16-bit 2's complement ====
with open(r"E:/ModelSim/Parallel_FIR/coeffs/bandpass_coeffs.hex", "w") as f_hex:
    for val in coeffs_fixed.astype(np.int32):  # tránh lỗi overflow
        if val < 0:
            val = (1 << 16) + val
        f_hex.write("{:04X}\n".format(val))

print("✅ Đã tạo thành công:")
print("  - bandpass_coeffs.hex (hex Q1.15)")