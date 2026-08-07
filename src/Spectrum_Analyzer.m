function [Signal_ff, signal_tf, f, df] = Spectrum_Analyzer(signal, ts) 
fs = 1/ts;               % Sampling rate
ni = length(signal);     % Input signal length
nf = 2^(nextpow2(ni));   % New signal length

% The transform via FFT
Signal_ff = fft(signal, nf); 
Signal_ff = Signal_ff / fs; 

% The new signal in the time domain
signal_tf = [signal, zeros(1, nf - ni)];

% Frequency resolution
df = fs / nf;

% Frequency vector
f = (0:df:df*(length(signal_tf)-1)) - fs/2;
