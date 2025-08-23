# **FIR Filter Design Using Windowing Techniques**

---

## 📖 Project Overview

This project focuses on **designing and analyzing Finite Impulse Response (FIR) low-pass filters** using various **windowing techniques** in MATLAB. It demonstrates:

* Why **FIR filters** are preferred for practical implementation over ideal Infinite Impulse Response (IIR) filters.
* How **discrete-time signals** are used in computers to approximate continuous signals.
* Effects of different **window functions** (Rectangular, Triangular, Hanning, Hamming, Blackman) on filter performance.
* **Time-domain and frequency-domain characteristics** of filtered signals.
* Noise suppression and **Signal-to-Noise Ratio (SNR) improvement**.

The project blends **theory and simulation**, showing the **practical trade-offs** in filter design.

---

## 🔬 Theoretical Background

### 1️⃣ Why FIR Filters?

* **Ideal IIR filters** have infinite duration and sharp cut-offs, making them **non-causal and impossible to implement** in real-time systems.
* **FIR filters** have **finite impulse responses**, are inherently stable, and can achieve linear phase.
* **Windowing** is applied to approximate the infinite ideal response:

$$
h(n) = h_d(n) \cdot w(n)
$$

where $h_d(n)$ is the ideal impulse response and $w(n)$ is the window function.

* This method **reduces the Gibbs phenomenon**, which appears as oscillations in the stopband when truncating the ideal response.

---

### 2️⃣ Why Discrete Instead of Continuous?

* Computers **cannot handle continuous-time signals**, so signals are **sampled** and processed digitally.
* Discrete representation allows **FFT computation**, **filtering**, and **simulation**.
* Discretization introduces **sampling artifacts**, which must obey the **Nyquist criterion** to avoid aliasing.
* FIR filters operate on **discrete signals**, making them ideal for digital processing.

---

### 3️⃣ Window Functions and Their Effects

| Window          | Characteristics               | Time-domain Effect                      | Frequency-domain Effect                            | Best For                                                |
| --------------- | ----------------------------- | --------------------------------------- | -------------------------------------------------- | ------------------------------------------------------- |
| **Rectangular** | Abrupt truncation             | Strong oscillations in impulse response | Narrow main lobe, very high side lobes             | Simple FIR filters, low N                               |
| **Triangular**  | Linear tapering               | Reduced ripples                         | Moderate main lobe width, lower side lobes         | Moderate stopband requirements                          |
| **Hanning**     | Cosine taper, smooth          | Gradual edges                           | Ripple envelope decreases linearly                 | Smooth filtering, audio                                 |
| **Hamming**     | Cosine taper, constant ripple | Similar to Hanning                      | Constant ripple envelope, slightly wider main lobe | Audio, communications                                   |
| **Blackman**    | Strong taper                  | Smoothest response                      | Wide main lobe, very low side lobes                | High stopband attenuation, noise-sensitive applications |

* **Trade-off:** Narrow main lobe → better frequency resolution, low side lobe → better stopband attenuation. Choice depends on **application needs**.

---

### 4️⃣ Signal Filtering & Noise Handling

* Input signals often contain multiple frequencies:

$$
x[n] = \sin(\pi/8 \cdot n) + 2\sin(\pi/2 \cdot n)
$$

* FIR filters remove undesired high-frequency components.
* Filtering noisy signals shows **SNR improvement**, calculated as:



#### Input SNR
The input SNR measures the signal quality **before filtering**:

$$
\[
\mathbf{SNR_{in}} = 10 \cdot \log_{10} \left( \frac{\text{Power of clean signal}}{\text{Power of noise}} \right) 
= 10 \log_{10} \frac{\sum x[n]^2}{\sum \text{noise}[n]^2}
\]
$$

#### Output SNR
The output SNR measures the signal quality **after filtering**, indicating the effectiveness of noise suppression:

**Key Points:**
* **SNR\(_{in}\)** – Higher values indicate less noise in the input signal.
* **SNR\(_{out}\)** – Higher values indicate better noise reduction by the filter.
* Comparing SNR\(_{in}\) and SNR\(_{out}\) allows evaluation of **filter performance** across different window types (Rectangular, Triangular, Hanning, Hamming, Blackman).

$$
\[
\mathbf{SNR_{out}} = 10 \cdot \log_{10} \left( \frac{\text{Power of filtered signal}}{\text{Power of residual noise}} \right) 
= 10 \log_{10} \frac{\sum y[n]^2}{\sum \left( y_\text{noisy}[n] - y[n] \right)^2 }
\]
$$

* Observations reveal **window effectiveness in noise suppression**.

---

## 🧪 Experiments & Observations

### 1️⃣ Time-Domain Effects

* **Rectangular:** Oscillatory response, abrupt edges.
* **Triangular:** Reduced oscillations, smoother edges.
* **Hanning & Hamming:** Smooth, well-tapered impulse response.
* **Blackman:** Smoothest, lowest oscillations.

### 2️⃣ Frequency-Domain Effects

* **Rectangular:** Narrow main lobe, **highest side lobes** → poor stopband attenuation.
* **Triangular:** Lower side lobes, moderate transition width.
* **Hanning:** Ripple decreases linearly, good compromise.
* **Hamming:** Constant ripple envelope, slightly wider main lobe.
* **Blackman:** **Lowest side lobes**, wide main lobe → excellent for noise rejection.

### 3️⃣ Noise Filtering & SNR

| Window      | Input SNR (dB) | Output SNR (dB) | Observation                                        |
| ----------- | -------------- | --------------- | -------------------------------------------------- |
| Rectangular | \~10           | Moderate        | Side lobes leak energy, moderate noise reduction   |
| Triangular  | \~10           | Slightly higher | Smooth, reduced ripple                             |
| Hanning     | \~10           | Higher          | Better noise suppression                           |
| Hamming     | \~10           | Higher          | Constant ripple, stable output                     |
| Blackman    | \~10           | Highest         | Maximum stopband attenuation, best noise rejection |

### 4️⃣ Filter Length (N) Effect

* Increasing N → **sharper transition**, better frequency selectivity.
* Very high N → performance **saturates**, diminishing returns.

---

## 💻 Code Structure

```
├── FIR_Rectangular.m
├── FIR_Triangular.m
├── FIR_Hanning.m
├── FIR_Hamming.m
├── FIR_Blackman.m
└── README.md
```

* Each script generates:

  * Impulse response plots
  * Filtered signal plots (time-domain)
  * Frequency spectra (FFT)
  * Noise filtering analysis and SNR computation

---

## ⚡ Key Learnings & Insights

* FIR filters are **stable, causal, and implementable**, unlike ideal IIR filters.
* Discrete-time processing allows **digital computation** of continuous signals.
* Window choice affects **ripple, stopband attenuation, and transition width**:

  * **Blackman → best for stopband**
  * **Hamming → balanced, constant ripple**
  * **Triangular → moderate smoothing**
  * **Rectangular → simplest, but poor stopband**
* **Trade-offs:** Sharp cutoff vs side lobe level; longer N improves selectivity.

---

## 🎯 Applications

* **Digital audio processing** – noise reduction, smooth filtering.
* **Communication systems** – channel selection, stopband filtering.
* **Instrumentation** – smoothing sensor data, eliminating high-frequency noise.
* **Signal analysis & synthesis** – harmonic analysis, waveform shaping.

---

## 📌 Final Comparison

| Window      | Main Lobe Width | Side Lobe Level | Transition Sharpness | Stopband Attenuation | Best Use                                  |
| ----------- | --------------- | --------------- | -------------------- | -------------------- | ----------------------------------------- |
| Rectangular | Narrow          | Very High       | Moderate             | Poor                 | Simple FIR                                |
| Triangular  | Moderate        | Lower           | Moderate             | Moderate             | General-purpose                           |
| Hanning     | Wider           | Low             | Smooth               | Good                 | Audio filtering                           |
| Hamming     | Slightly wider  | Low             | Smooth               | Good                 | Audio & communications                    |
| Blackman    | Widest          | Very Low        | Smooth               | Excellent            | Noise-sensitive, high-attenuation filters |


