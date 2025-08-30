Fs = 1000; Fc = 150; delta_f = 50; A = 60; 
wc = 2*pi*Fc/Fs; df = delta_f/Fs;

if A > 50
    beta = 0.1102 * (A - 8.7);
elseif A >= 21
    beta = 0.5842*(A - 21)^0.4 + 0.07886*(A - 21);
else
    beta = 0;
end

N = ceil((A-8)/(2.285*2*pi*df));
if mod(N,2)==0, N=N+1; end
n = 0:N-1; alpha = (N-1)/2;

% Kaiser window
w = zeros(1,N);
for i=1:N
    ratio=(n(i)-alpha)/alpha;
    arg=beta*sqrt(1-ratio^2);
    w(i)=besseli0_custom(arg)/besseli0_custom(beta);
end

m = n-alpha;
hd = (wc/pi)*sinc((wc/pi)*m);
h = hd.*w;

[H,f]=freqz(h,1,512,Fs);

fig1 = figure;
plot(f,20*log10(abs(H)));
title('Low-Pass FIR Filter (Manual Kaiser)');
xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)'); grid on;
save_plot(fig1,'kaiser_lp_filter.png');

fig2 = figure;
stem(m,h,'filled');
title('Impulse Response (Kaiser LPF)'); xlabel('n'); ylabel('h[n]'); grid on;
save_plot(fig2,'kaiser_impulse_response.png');
