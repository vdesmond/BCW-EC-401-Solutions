bw = 20; % (in MHz)
Fs = 30.72; % (in Hz)
fftSize = 2048;
num_data_samples = 4800;
M = 16; % Modulation order
k = log2(M); % bits per sym

inputData = randi([0 1], num_data_samples, 1);
% reshape into k bit matrix and then convert to decimal values
inputDataMat = reshape(inputData, length(inputData) / k, k);
inputSym = bi2de(inputDataMat);
modData = qammod(inputSym, M); % M-QAM modulation

dataParallel = reshape(modData, 1200, []); % Serial to Parallel data
scfdmaData = fft(dataParallel, 1200, 1); % apply DFT spread

% map the Modulation symbols(1200) to IFFT input (2048)
ifftOFDM = [(0); modData(1:600); zeros(847, 1); modData(601:1200)];
ifftSCFDMA = [[0]; scfdmaData(1:600); zeros(847, 1); scfdmaData(601:1200)];

% Apply IFFT
dataSCFDMA = ifft(ifftSCFDMA, fftSize, 1);
dataOFDM = ifft(ifftOFDM, fftSize, 1);

% PAPR
paprSCFDMA = max((abs(dataSCFDMA)).^2) / mean((abs(dataSCFDMA)).^2);
paprOFDM = max((abs(dataOFDM)).^2) / mean((abs(dataOFDM)).^2);

fprintf("PAPR (SC-FDMA) = %.6f\n", paprSCFDMA);
fprintf("PAPR (OFDM) = %.6f\n", paprOFDM);
