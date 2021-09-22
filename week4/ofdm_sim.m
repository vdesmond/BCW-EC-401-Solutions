M = 16; % Modulation order
k = log2(M); % Number of bits per symbol
n = 51200; % Number of data samples

data = randi([0 1], n, 1); % n samples

dataInput = reshape(data, length(data) / k, k);
dataSym = bi2de(dataInput);
dataMod = qammod(dataSym, M);

dataParallel = reshape(dataMod, 512, []); % Serial to parallel
dataOFDMmod = ifft(dataParallel, 512, 1);  % IFFT
txData = reshape(dataOFDMmod, [], 1);
dataChannel = awgn(txData, 18, 'measured'); % SNR = 18 dB
rxData = reshape(dataChannel, 512, []);
dataOFDMdemod = fft(rxData, 512, 1); % FFT
dataSerial = reshape(dataOFDMdemod, 1, []); % Parallel to Serial
scatterplot(dataSerial);
dataDemod = qamdemod(dataSerial, M)';

% calculate BER
recdataSym = de2bi(dataDemod);
recdata = reshape(recdataSym, [], 1);
[numerr, ber] = biterr(data, recdata);
fprintf("Bit Error Rate = %.6f\n", ber);

% Spectrum of Tx Signal
fs = 20000000;
[Pxx, W] = pwelch(txData', [], [], 4096, fs);
figure;
plot([-2048:2047] * fs / 4096, 10 * log10(fftshift(Pxx)), 'b');
grid;
hold on;
xlabel('Frequency (MHz)');
ylabel('Power Spectral Density');
hold off;
