close all;
bitrate = 1e06;
Fc = 2.5e06;
Fs = 8 * bitrate;

M = 4; % Modulation order
k = log2(M); % Bits/symbol
n = 500; % Transmitted bits
sps = 8; % Samples per symbol
EbNo = 10; % Eb/No (dB)

span = 8; % Filter span in symbols
rolloff = 0.20; % Rolloff factor

txfilter = comm.RaisedCosineTransmitFilter('RolloffFactor',
rolloff, 'FilterSpanInSymbols', span, ...
  'OutputSamplesPerSymbol', sps);

rxfilter = comm.RaisedCosineReceiveFilter('RolloffFactor',
rolloff, 'FilterSpanInSymbols', span, ...
  'InputSamplesPerSymbol', sps, ...
  'DecimationFactor', sps, 'Gain', 2);

ri = comm.internal.RandomIntegerGenerator('SetSize', M, ...
  'SampleTime', 1 / bitrate, 'SamplesPerFrame', n);

tx_lo = dsp.SineWave(1, Fc, 0, 'ComplexOutput', true, ...
  'SampleRate', Fs, 'SamplesPerFrame', sps * n);

rx_lo = dsp.SineWave(1, Fc, 0, 'ComplexOutput', true, ...
  'SampleRate', Fs, 'SamplesPerFrame', sps * n);

filtDelay = (txfilter.FilterSpanInSymbols + ...
  rxfilter.FilterSpanInSymbols) / 2;
errorRate = comm.ErrorRate('ReceiveDelay', filtDelay);

delay = dsp.Delay(8);
evm = comm.EVM();

biterr = 0;
totalbits = 0;
rmsEVM = 0;
tx_scope = dsp.SpectrumAnalyzer('SpectrumType', "Power Density", ...
  'SampleRate', Fs, 'FrequencyResolutionMethod', ...
  "WindowLength", 'WindowLength', 800, ...
  'PlotAsTwoSidedSpectrum', false);

rx_scope = dsp.SpectrumAnalyzer('SpectrumType', "Power", ...
  'SampleRate', Fs, 'FrequencyResolutionMethod', ...
  "WindowLength", 'WindowLength', 1024);

txSigall = [];
rxSigall = [];

tx_const_diag = scatterplot(ri());
rx_const_diag = scatterplot(ri());

for idx = 1:20
  dataIn = ri();
  modSig = pskmod(dataIn, 4, pi / 4);
  txFilterSig = txfilter(modSig);
  tx_carrier = tx_lo();
  txSig = real(txFilterSig .* tx_carrier);
  txSigall = txSig;

  SNR = EbNo + 10 * log10(k) - 10 * log10(sps);
  noisySig = awgn(txSig, SNR, 'measured');

  rx_wave = conj(rx_lo());
  rxSig = noisySig .* rx_wave;
  rxSigall = rxSig;

  rxFilterSig = rxfilter(rxSig);

  dataOut = pskdemod(rxFilterSig, 4, pi / 4);

  errStat = errorRate(dataIn, dataOut);
  biterr = biterr + errStat(2);
  totalbits = totalbits + errStat(3);

  rmsEVM = (rmsEVM + evm(delay(modSig), rxFilterSig)) / 2;

  scatterplot(modSig, 1, 0, 'y.', tx_const_diag);
  scatterplot(rxFilterSig, 1, 0, 'y.', rx_const_diag);
  tx_scope(txSigall);
  rx_scope(rxSigall);
end

fprintf('\nBit Errors = %d', biterr);
fprintf('\nBits Transmitted = %d\n', totalbits);
fprintf('\nBER = %5.2e\n', biterr / totalbits);
fprintf('\nRMS EVM = %.2f %% \n', rmsEVM);

release(tx_scope);
release(rx_scope);