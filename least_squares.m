b=firls(255,[0 0.25 0.3 1],[1 1 0 0]);

fig5 = figure; freqz(b,1);
title('Low-Pass FIR Filter (Least Squares)');
save_plot(fig5,'least_sq_lp_filter.png');

fig6 = figure; stem(b,'filled');
title('Impulse Response (Least Squares LPF)'); grid on;
save_plot(fig6,'least_sq_impulse_response.png');
