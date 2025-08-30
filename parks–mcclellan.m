[n,fo,ao,w]=firpmord([1500 2000],[1 0],[0.001 0.01],8000);
b=firpm(n,fo,ao,w);

fig3 = figure; freqz(b,1,[],8000);
title('Low-Pass FIR Filter (Parks–McClellan)');
save_plot(fig3,'park_mcClellan_lp_filter.png');

fig4 = figure; stem(b,'filled'); 
title('Impulse Response (Parks–McClellan LPF)'); grid on;
save_plot(fig4,'park_mcClellan_impulse_response.png');