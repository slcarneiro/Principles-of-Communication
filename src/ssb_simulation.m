%=========================================================================%
% Script:      SSB Modulation and AWGN Channel Simulation
% Author:      Sérgio Luiz Carneiro Junior (UFES)
% Date:        June 2026
% Description: Simulates an analog communication system using Single 
%              Sideband (SSB) modulation over an AWGN channel, evaluating
%              the system's continuous waveform distortion via MSE.
%=========================================================================%

% Initialization
clc, clear, close all

% ===============  Simulation Data or Parameters  ========================%
snr = 11;  % Signal-to-Noise Ratio
% ========================================================================%

% ========== Part 1 - Audio Signal Reading ===============================%
[m, Fs] = audioread('data/BrazilianVoice.ogg'); % Loads the signal
m = m(:,1);    % Forces the signal to mono (in case it is stereo)
Fc = Fs/4;     % Modulation Center Frequency 
% ========================================================================%

% ----------------- Preliminary Calculations ------------------------------
dt = 1/Fs;                         % Sampling period                              
t = (0:dt:(length(m)-1)*dt).';     % Generates the time vector
% -------------------------------------------------------------------------

% ========== Part 2 - Modulates the Audio Signal =========================%
s = ssbmod(m,Fc,Fs);   % Modulates the Audio signal
% ========================================================================%

% ########## Part 3  - Noisy Channel ######################################
s_ruidoso = awgn(s,snr,'measured'); 
% #########################################################################

% ========== Part 4 - Demodulates the Audio Signal =======================%
 
s_r = ssbdemod(s_ruidoso,Fc,Fs);  % Now Demodulates the noisy signal
% ========================================================================%

% ---------- Audio Playback -----------------------------------------------
sound(m,Fs) % Pure input signal
pause(5)
sound(s_ruidoso,Fs) % Signal after the AWGN channel
pause(5)
sound(s_r,Fs) % Recovered signal
% -------------------------------------------------------------------------

% ----------- Mean Squared Error (MSE) Calculation ------------------------
MSE = mean((m - s_r).^2); % Calculates the Mean Squared Error
fprintf('System error: %f\n', MSE);
% -------------------------------------------------------------------------

% ======================== Graph Plotting ================================%
figure(1)         
subplot(2,1,1)
plot(t,m,'b'), grid, 
title ('Audio Signal'); xlabel('time [s]'), ylabel('ampl. [a.u.]')
axis tight
[M,mn,f,df] = Spectrum_Analyzer(m.',dt); % Determines the baseband spectrum
figure(2)
subplot(2,1,1), plot(f,10*log10(fftshift(abs(M))),'b'), grid
title ('Baseband Power Spectrum');
xlabel('Frequency [Hz]'), ylabel('PSD [dB/Hz]'), axis tight

% Plots the SSB Modulated signal in the time and frequency domains
figure(1)
subplot(2,1,2), plot(t,s,'g'), grid, title ('SSB Modulated Signal')
xlabel('time [s]'), ylabel('ampl. [a.u.]')
axis tight
figure(2)
[S_mod,s1,f_mod,df_mod] = Spectrum_Analyzer(s.',dt);  % Modulated spectrum
subplot(2,1,2), plot(f_mod,10*log10(fftshift(abs(S_mod))),'g'), grid
title ('Passband Power Spectrum (SSB)');
xlabel('Frequency [Hz]'), ylabel('PSD [dB/Hz]'), axis tight

% Plots the result of modulation with noise in time and frequency 
figure(3) 
subplot(2,1,1), plot(t,s,'g'), hold on
plot(t,s_ruidoso,'r--'), grid
legend ('Signal at Channel Input', 'Signal at Channel Output')
xlabel('time [s]'), ylabel('ampl. [a.u.]'), axis tight
[S_ruido,s_ruido,f_ruido,df_ruido] = Spectrum_Analyzer(s_ruidoso.',dt); 
subplot(2,1,2), plot(f_mod,10*log10(fftshift(abs(S_mod))),'g'), grid
hold on, plot(f_ruido,10*log10(fftshift(abs(S_ruido))),'r--')
title ('Power Spectrum of Signals at Channel Input and Output');
xlabel('Frequency [Hz]'), ylabel('PSD [dB/Hz]')
legend ('Signal at Channel Input', 'Signal at Channel Output')
axis tight

% Plots demodulated signals and compares with generated signals 
figure(4) 
plot(t,m), hold on
plot(t,s_r,'k--'), grid
xlabel('time [s]'), ylabel('ampl. [a.u.]'), axis tight
legend('generated Audio signal', 'received Audio signal')
figure(5)
[S1R] = Spectrum_Analyzer(s_r.',dt);   % Spectrum of the received signal
plot(f,10*log10(fftshift(abs(M)))), hold on
plot(f,10*log10(fftshift(abs(S1R))),'k--'), grid
title ('Baseband Power Spectrum (Comparison)');
xlabel('Frequency [Hz]'), ylabel('PSD [dB/Hz]'), axis tight 
legend('generated Audio signal', 'received Audio signal')
% ========================================================================%
