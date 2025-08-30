# **FIR Filter Design Using Windowing Techniques**

---

## 📖 Project Overview

This project focuses on **designing and analyzing Finite Impulse Response (FIR) filters** using various **windowing and optimization techniques** in MATLAB. It demonstrates:

* Why **FIR filters** are preferred over ideal Infinite Impulse Response (IIR) filters.
* How **discrete-time signals** are used in digital systems to approximate continuous signals.
* Effects of different **window functions** (Rectangular, Triangular, Hanning, Hamming, Blackman, Kaiser) and **optimization methods** (Least Squares, Parks–McClellan, Multiband).
* **Time-domain and frequency-domain characteristics** of filtered signals.
* **Noise suppression** and **Signal-to-Noise Ratio (SNR) improvement**.

The project blends **theory and simulation**, highlighting the **practical trade-offs** in digital filter design.

---

## 🔬 Theoretical Background

### 1️⃣ Why FIR Filters?

* **IIR filters** ideally have infinite duration and sharp cut-offs, but they are **non-causal, unstable, and not feasible** in real-time implementations.
* **FIR filters** have **finite impulse responses**, are **always stable**, and can achieve **linear phase**.
* Windowing is applied to truncate the infinite ideal impulse response:

$$
h(n) = h_d(n) \cdot w(n)
$$

where

* \$h\_d(n)\$ = ideal impulse response
* \$w(n)\$ = window function

- Windowing reduces the **Gibbs phenomenon** (oscillations due to abrupt truncation).

---

### 2️⃣ Why Discrete Instead of Continuous?

* Computers cannot directly handle continuous signals → signals are **sampled** and represented in discrete-time.
* Discrete signals allow **FFT computation**, **filtering**, and **digital simulations**.
* To avoid aliasing, sampling must follow the **Nyquist criterion**.
* FIR filters are best suited for **discrete-time processing**.

---

### 3️⃣ Classical Window Functions

| Window          | Characteristics               | Time-domain Effect            | Frequency-domain Effect                   | Best For                               |
| --------------- | ----------------------------- | ----------------------------- | ----------------------------------------- | -------------------------------------- |
| **Rectangular** | Abrupt truncation             | Strong oscillations (ringing) | Narrow main lobe, very high side lobes    | Simple FIR, fast prototyping           |
| **Triangular**  | Linear tapering               | Reduced ripples               | Moderate main lobe, lower side lobes      | Moderate stopband requirements         |
| **Hanning**     | Cosine taper, smooth          | Gradual edges                 | Ripple envelope decreases linearly        | Spectral analysis, audio               |
| **Hamming**     | Cosine taper, constant ripple | Similar to Hanning            | Constant ripple, slightly wider main lobe | Audio, comms (stable stopband)         |
| **Blackman**    | Strong taper                  | Smoothest response            | Wide main lobe, very low side lobes       | High stopband attenuation applications |

---

#### 1️⃣ Rectangular Window

🌍 **Theory**
Simplest window → just truncates the ideal sinc response.
Narrowest main lobe but highest side lobes → poor stopband attenuation.

✅ **Advantages**

* Easy to implement.
* Sharp transition compared to tapered windows.

❌ **Disadvantages**

* Very poor stopband attenuation.
* Strong Gibbs ringing.

📌 **Applications**

* Quick prototyping.
* When transition width is critical but attenuation is not.

---

#### 2️⃣ Hamming Window

🌍 **Theory**
Raised cosine shape:

$$
w[n] = 0.54 - 0.46 \cos \left( \frac{2\pi n}{N-1} \right)
$$

✅ **Advantages**

* Good stopband attenuation (\~53 dB).
* Reduces ringing compared to Rectangular.

❌ **Disadvantages**

* Wider main lobe → slower transitions.
* Fixed trade-off, not tunable.

📌 **Applications**

* Speech and audio processing.
* Channel equalization.

---

#### 3️⃣ Hanning (Hann) Window

🌍 **Theory**
Similar raised cosine:

$$
w[n] = 0.5 - 0.5 \cos \left( \frac{2\pi n}{N-1} \right)
$$

✅ **Advantages**

* Smooth taper → low spectral leakage.
* Side lobes decay faster than Hamming.

❌ **Disadvantages**

* Wider main lobe → poor sharpness.
* Lower attenuation (\~31 dB).

📌 **Applications**

* Spectral analysis.
* Applications prioritizing smoothness.

---

#### 4️⃣ Blackman Window

🌍 **Theory**

$$
w[n] = 0.42 - 0.5 \cos \left( \frac{2\pi n}{N-1} \right) + 0.08 \cos \left( \frac{4\pi n}{N-1} \right)
$$

✅ **Advantages**

* Excellent stopband attenuation (\~74 dB).
* Best classical window for leakage suppression.

❌ **Disadvantages**

* Very wide main lobe → requires large N.

📌 **Applications**

* High-quality audio filtering.
* Instrumentation (precision measurement).

---

### 4️⃣ Extended FIR Design Methods

#### 1️⃣ Kaiser Window Method

🌍 **Theory**
The Kaiser window is based on the **zeroth-order modified Bessel function of the first kind**.
Its equation is:

$$
w[n] = \frac{I_0\!\left( \beta \sqrt{1 - \left( \frac{2n}{N-1} - 1 \right)^2 } \right)}{I_0(\beta)}, \quad 0 \leq n \leq N-1
$$

where:

* \$I\_0(x)\$ = zeroth-order modified Bessel function,
* \$\beta\$ = parameter controlling main-lobe width and side-lobe attenuation,
* \$N\$ = filter length.

---

📐 **Filter Length (N) Approximation**

For specifications:

* Transition width = \$\Delta \omega\$,
* Stopband attenuation = \$A\$ (in dB),

The required length is:

$$
N \approx \frac{A - 8}{2.285 \, \Delta \omega}
$$

---

📐 **β Parameter Selection**

$$
\beta =
\begin{cases}
0 & , A \leq 21 \\
0.5842(A-21)^{0.4} + 0.07886(A-21) & , 21 < A < 50 \\
0.1102(A-8.7) & , A \geq 50
\end{cases}
$$

---

✅ **Advantages**

* Adjustable via β (unlike fixed windows).
* Works for all filter types (low-pass, band-pass, multiband).

❌ **Disadvantages**

* Slightly less optimal than Parks–McClellan.
* Requires pre-computation of \$N\$ and \$\beta\$.

📌 **Applications**

* Audio DSP, biomedical filtering, flexible applications.

---

#### 2️⃣ Least Squares Method

🌍 **Theory**
The **goal** is to minimize the **mean squared error (MSE)** between the desired frequency response \$H\_d(\omega)\$ and actual \$H(\omega)\$.

The error function is:

$$
E = \int_{-\pi}^{\pi} W(\omega) \, \left| H_d(\omega) - H(\omega) \right|^2 \, d\omega
$$

where:

* \$W(\omega)\$ = weighting function,
* \$H\_d(\omega)\$ = desired response,
* \$H(\omega)\$ = designed filter response.

By solving using **linear algebra (least squares fitting)**, the filter coefficients \$h\[n]\$ are obtained.

---

✅ **Advantages**

* Minimizes energy error (good smoothness).
* Works well for **multiband filters**.

❌ **Disadvantages**

* Does not control **maximum ripple** (worst-case error may be high).

📌 **Applications**

* Audio, speech, and biomedical signal filtering.

---

#### 3️⃣ Parks–McClellan Algorithm (Remez Exchange)

🌍 **Theory**
The Parks–McClellan algorithm designs FIR filters that are **optimal in the Chebyshev sense** → it minimizes the **maximum error** (minimax criterion).

The design seeks to minimize:

$$
E = \max_\omega \, \left| H_d(\omega) - H(\omega) \right|
$$

subject to the **equiripple property**, where ripples in passband and stopband are equal in magnitude.

---

📐 **Filter Response Formulation**

The FIR filter has response:

$$
H(\omega) = \sum_{n=0}^{N-1} h[n] \, e^{-j\omega n}
$$

The algorithm iteratively adjusts \$h\[n]\$ so that the error alternates in sign (Chebyshev alternation theorem).

---

📐 **Key Idea – Equiripple Error**

In passband (\$\omega \in \Omega\_p\$) and stopband (\$\omega \in \Omega\_s\$):

$$
|H_d(\omega) - H(\omega)| = \delta
$$

where \$\delta\$ is constant ripple magnitude.

Thus, the Parks–McClellan filter is **shortest-length FIR filter** that meets given:

* Passband ripple \$\delta\_p\$,
* Stopband ripple \$\delta\_s\$,
* Transition width.

---

✅ **Advantages**

* Optimal → requires smallest \$N\$ for given specs.
* Supports weighted designs (passband/stopband weights).

❌ **Disadvantages**

* Computationally heavy (iterative).
* Needs MATLAB/Python (not trivial by hand).

📌 **Applications**

* Communication channel filters.
* DSP requiring **tight specifications**.

---

#### 4️⃣ Multiband FIR Design (Generalized)

🌍 **Theory**
When multiple frequency regions must be handled:

**Ideal Impulse Response for Multiband Filter:**

$$
h_d[n] = \sum_{k=1}^M \frac{\sin(\omega_{h,k} n) - \sin(\omega_{l,k} n)}{\pi n}
$$

where each band \$k\$ spans \$(\omega\_{l,k}, \omega\_{h,k})\$.

Then apply window (e.g., Kaiser):

$$
h[n] = h_d[n] \cdot w[n]
$$

---

📌 **Applications**

* Audio equalizers (bass/mid/treble).
* Multi-channel comms.
* EEG/ECG band separation.
---

## 5️⃣ Signal Filtering & Noise Handling

* Input signal example:

$$
x[n] = \sin\left(\tfrac{\pi}{8}n\right) + 2\sin\left(\tfrac{\pi}{2}n\right)
$$

* FIR filters suppress unwanted components.
* **SNR improvement** is measured:

**Input SNR:**

$$
SNR_{in} = 10 \log_{10} \left( \frac{\sum x[n]^2}{\sum noise[n]^2} \right)
$$

**Output SNR:**

$$
SNR_{out} = 10 \log_{10} \left( \frac{\sum y[n]^2}{\sum (y_{noisy}[n]-y[n])^2} \right)
$$

---

## 🧪 Experiments & Observations

### 1️⃣ Time-Domain

* Rectangular → oscillatory.
* Triangular → smoother.
* Hanning & Hamming → well-tapered.
* Blackman → smoothest.
* Kaiser → tunable.

### 2️⃣ Frequency-Domain

* Rectangular → sharp transition, poor attenuation.
* Hamming/Hanning → balanced trade-off.
* Blackman → best attenuation.
* Kaiser → tunable sharpness.
* LS → smooth but ripple uncontrolled.
* Parks–McClellan → equiripple, optimal.
* Multiband → handles multiple passbands.

### 3️⃣ Noise Filtering

| Method/Window   | Output SNR | Notes                     |
| --------------- | ---------- | ------------------------- |
| Rectangular     | Moderate   | Leakage due to side lobes |
| Hamming/Hanning | High       | Good suppression          |
| Blackman        | Highest    | Best fixed window         |
| Kaiser          | Tunable    | Adjustable suppression    |
| Least Squares   | High       | Smooth output             |
| Parks–McClellan | Very High  | Most efficient            |
| Multiband       | App-based  | Depends on target bands   |

---

## 💻 Code Structure

```
├── FIR_Rectangular.m
├── FIR_Triangular.m
├── FIR_Hanning.m
├── FIR_Hamming.m
├── FIR_Blackman.m
├── FIR_Kaiser.m
├── least_squares.m
├── parks_mcclellan.m
├── multiband_designs.m
└── README.md
```

Each script generates:

* Impulse response plots
* Time-domain filtered signals
* Frequency spectra (FFT)
* Noise filtering + SNR analysis

---

## ⚡ Key Insights

* FIR filters are **stable, causal, and implementable**.
* Discrete-time processing enables **digital computation**.
* Window selection affects **transition sharpness vs. stopband attenuation**.
* **Kaiser** → tunable trade-off.
* **Least Squares** → smoothness.
* **Parks–McClellan** → optimal, shortest filter.
* **Multiband** → real-world separation of frequencies.

---

## 🎯 Applications

* Digital audio (noise reduction, EQ).
* Communication systems (channel filtering).
* Sensor instrumentation (noise suppression).
* Signal analysis (harmonics, shaping).
* Biomedical (ECG/EEG filtering).

---


## 📌 Final Comparison 
| **Method / Window** | **Ripple Control**  | **Stopband Attenuation** | **Filter Length Efficiency** | **Best Use**                              |
| ------------------- | ------------------- | ------------------------ | ---------------------------- | ----------------------------------------- |
| **Rectangular**     | None                | Poor                     | Short                        | Quick, simple FIR filters                 |
| **Hanning**         | Linear decay        | Good                     | Longer than Rectangular      | Audio processing, spectral analysis       |
| **Hamming**         | Constant ripple     | Good                     | Moderate                     | Audio, communication systems              |
| **Blackman**        | Strong taper        | Excellent                | Requires larger $N$          | Noise-sensitive applications              |
| **Kaiser**          | Tunable via $\beta$ | Tunable                  | Approx. $N$ depends on specs | Flexible DSP applications                 |
| **Least Squares**   | Average error       | Moderate                 | Variable                     | When minimizing overall error is priority |
| **Parks–McClellan** | Strict (Chebyshev)  | High                     | Very efficient               | Optimal equiripple filters                |
| **Multiband**       | Depends on design   | Application-specific     | Variable                     | Equalizers, biomedical, comms             |

---

