    N = 513;
    n = (0:1:N-1); %Defining the number of samples for the input signal
    k = (N-1)/2;
    
    wc = pi/4;
    hd = zeros(1,N); %preallocating the size of hd
    
    for i = 0:k-1
        hd(i+1) = sin(wc*(i-k))/(pi*(i-k));
    end
    
    hd(k+1) = wc/pi;
    
    for i = k+1:(N-1)
        hd(i+1) = sin(wc*(i-k))/(pi*(i-k));
    end
    
    figure(1)
    subplot(1,2,1)
    plot(n,hd);  %plot for the input signal
    title('Input Function');
    xlabel('n');
    ylabel('Sinc(n)');
    
    w = ones(1,N); %rectangular window function
    
    subplot(1,2,2)
    plot(n,w); %plot for the window function
    title('Rectangular Window Function');
    xlabel('n');
    ylabel('w(n)');
    
    h = hd.*w;  %computing the multiplication of input and the window
    
    figure(2);
    plot(n,h); %time domain plot of ouput
    
    W = -pi:0.01:pi;
    
    figure(3);
    freqz(h,1,W);  %plot of the output spectra
    title("Rectangular Bode Plot for N = " + N);
    
    % Following is the second part involving filtering of the given signal
    
    k = 10000;
    n1 = 0:k; %samples for the function to be inputted
    
    x = sin (pi/8*n1) + 2*sin(pi/2*n1); %input function x with two frequencies
    y = filtfilt(h, 1, x); %filtered function
    
    
    X = fftshift(fft(x,N)); %computing the fourier transform of the input x
    Y = fftshift(fft(y,N)); %computing the fourier transform of the filtered output y
    
    
    
    figure(4);
    subplot(421)
    plot(n1(1:250),x(1:250));
    title('Time domain plot of x')
    xlabel('t');
    ylabel('x(t)');
    
    subplot(422)
    plot(2/(N-1)*(-(N-1)/2:(N-1)/2),abs(X)/N);
    title('Fourier Spectra of x')
    xlabel('f(normalized by pi)');
    ylabel('X(f)');
    
    subplot(423)
    plot(n1(1:250),y(1:250));
    title('Time domain plot of y')
    xlabel('t');
    ylabel('y(t)');
    
    subplot(424)
    plot(2/(N-1)*(-(N-1)/2:(N-1)/2),abs(Y)/N);
    title('Fourier Spectra of y')
    xlabel('f(normalized by pi)');
    ylabel('X(f)');
    
    noise = randn(1,k+1);
    
    xn = x + noise;
    Xn = fftshift(fft(xn,N));
    
    yn = filtfilt(h, 1, xn);
    Yn = fftshift(fft(yn,N));
    
    
    subplot(425)
    plot(n1(1:250),xn(1:250));
    title('Time domain plot of noisy signal xn')
    xlabel('t');
    ylabel('xn(t)');
    
    subplot(426)
    plot(2/(N-1)*(-(N-1)/2:(N-1)/2),abs(Xn)/N);
    title('Fourier Spectra of xn')
    xlabel('f(normalized by pi)');
    ylabel('Xn(f)');
    
    subplot(427)
    plot(n1(1:250),yn(1:250));
    title('Time domain plot of filtered output yn')
    xlabel('t');
    ylabel('yn(t)');
    
    subplot(428)
    plot(2/(N-1)*(-(N-1)/2:(N-1)/2),abs(Yn)/N);
    title('Fourier Spectra of yn')
    xlabel('f(normalized by pi)');
    ylabel('Yn(f)');
    
    
    sgtitle("Rectangular window N = " + N);
    
    
    input_snr=10*log(sumsqr(x)/sumsqr(noise));
    output_snr=10*log(sumsqr(y)/abs(sumsqr(yn-y)));