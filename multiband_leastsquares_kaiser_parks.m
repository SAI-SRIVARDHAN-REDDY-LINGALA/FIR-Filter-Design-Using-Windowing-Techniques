clc; clear; close all;

%% Utility Function to Save Plots
function save_plot(fig, filename)
    saveas(fig, filename);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4. Multiband FIR Filter using Least Squares
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=255;
F=[0 0.25 0.3 0.5 0.55 0.62 0.65 0.75 0.8 1];
A=[0 0 1 1 0 0 1 1 0 0];
W=[1 1 10 1 3.16];
b=firls(N,F,A,W);

fig7 = figure; 
freqz(b,1);
title('Multiband FIR Filter (Least Squares)');
save_plot(fig7,'multiband_least_sq.png');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 5. Multiband FIR Filter using Parks–McClellan
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Fs=8000;
fo_rad=[0 0.25*pi 0.3*pi 0.5*pi 0.55*pi 0.62*pi 0.65*pi 0.75*pi 0.8*pi pi];
fo=fo_rad/pi;
ao=[0 0 1 1 0 0 1 1 0 0];
w=[1 1 10 1 3.16];
N=255;
b=firpm(N,fo,ao,w);

fig8 = figure; 
freqz(b,1,1024,'half');
title('Multiband FIR Filter (Parks–McClellan)');
save_plot(fig8,'multiband_parkm.png');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 6. Multiband FIR Filter using Manual Kaiser
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=255;
bands_rad=[0 0.25*pi 0.3*pi 0.5*pi 0.55*pi 0.62*pi 0.65*pi 0.75*pi 0.8*pi pi];
desired=[0 0 1 1 0 0 1 1 0 0];
attenuations=[20 0 35 0 25];  % per band
A=max(attenuations);

% Kaiser beta calculation
if A<=21
    beta=0;
elseif A<=50
    beta=0.5842*(A-21)^0.4+0.07886*(A-21);
else
    beta=0.1102*(A-8.7);
end

% Transition width and N estimation
transitions=diff(bands_rad);
delta_f=min(transitions);
N_est=ceil((A-8)/(2.285*delta_f));
if mod(N_est,2)~=0, N_est=N_est+1; end
N=max(N,N_est);
n=-(N/2):(N/2);

% Ideal impulse response (hd)
hd=zeros(size(n));
for k=1:2:length(bands_rad)-1
    if desired(k)==1
        wl=bands_rad(k); wh=bands_rad(k+1);
        temp=(sin(wh*n)./(pi*n)-sin(wl*n)./(pi*n));
        temp(n==0)=(wh-wl)/pi;  % handle n=0 separately
        hd=hd+temp;
    end
end

% Kaiser window
alpha=N/2; I0beta=besseli0(beta); w=zeros(size(n));
for i=1:length(n)
    arg=beta*sqrt(1-(n(i)/alpha)^2);
    w(i)=besseli0(arg)/I0beta;
end
b=hd.*w;

fig9 = figure;
[H,w_freq]=freqz(b,1,1024);
plot(w_freq,20*log10(abs(H)),'LineWidth',1.5);
xlabel('Frequency (rad/sample)'); ylabel('Magnitude (dB)');
title('Multiband FIR Filter (Manual Kaiser)'); grid on;
save_plot(fig9,'multiband_kaiser.png');

fig10 = figure;
stem(n,b,'filled');
title('Impulse Response (Kaiser Multiband)'); grid on;
save_plot(fig10,'kaiser_multiband_impulse_response.png');
