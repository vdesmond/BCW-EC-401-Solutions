N = 10 ^ 6;
min_dB = -5;
max_dB = 40;

% Transmitter
ip = rand(1, N) > 0.5;
s = 2 * ip - 1; % BPSK modulation 0 -> -1; 1 -> 0
Eb_N0_dB = (min_dB:max_dB);
nErr = zeros(1,max_dB-min_dB);

for ii = 1:length(Eb_N0_dB)
    % white gaussian noise, 0dB variance
    n = sqrt(1/2) * (randn(1, N) + 1i * randn(1, N));
    % Rayleigh channel
    h = 1 / sqrt(2) * (randn(1, N) + 1i * randn(1, N));
    y = h.*s + 10^(-Eb_N0_dB(ii)/20)*n;
 
    % equalization
    yHat = y ./ h;
 
    % Receiver
    ipHat = real(yHat) > 0;
    nErr(ii) = size(find([ip-ipHat]), 2);
end

% simulated ber
simBer = nErr / N;
theoryBerAWGN = 0.5 * erfc(sqrt(10 .^ (Eb_N0_dB / 10)));
% theoretical ber
EbN0Lin = 10 .^ (Eb_N0_dB / 10);
theoryBer = 0.5 .* (1 - sqrt(EbN0Lin ./ (EbN0Lin + 1)));

% plot
figure(1)
semilogy(Eb_N0_dB,theoryBerAWGN,'rs--','LineWidth',2);
hold on
semilogy(Eb_N0_dB,theoryBer,'go-.','LineWidth',2);
semilogy(Eb_N0_dB,simBer,'bx:','LineWidth',2);
axis([min_dB max_dB 10^-5 0.5])
grid on
legend('AWGN - Theory','Rayleigh - Theory', 'Rayleigh - Simulation');
xlabel('Eb/No (dB)');
ylabel('Bit Error Rate');
title('BER for BPSK modulation in Rayleigh channel');