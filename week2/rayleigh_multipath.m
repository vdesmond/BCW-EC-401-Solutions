f_c = 1e3;
time_1 = (linspace (0, 10, 1000));
signal_in = sin (2 * pi * f_c * time_1);
subplot(3, 2, 1);

plot (time_1, signal_in, "b"); %blue=signal_in
grid on;
xlabel('Time'); 
ylabel('Amplitude');
title("Sine Wave Input");
sgtitle("Rayleigh fading channel simulation");

for ii = 1:5
    tau = round(100 * rand(1, 1) + 1); % variable delay(phase shift)
    g1 = 1; %fixed gain
    g2 = (0.6 * rand(1, 1) + rand(1, 1)); %variable gain or attenuation
    
    signal_out = g1 * signal_in + g2 * ...
        [zeros(1, tau) signal_in(1:end - tau)];
    
    subplot(3, 2, ii + 1);
    plot (time_1, (signal_out), "r") %red=signal_out
    xlabel("Time"); ylabel("Amplitude");
    title(sprintf("tau = %f, g2 = %f",tau,g2));
    
end