clear all;
close all;

%% ========= task 1 ======

% 1. read audio
[audio, Fs] = audioread("song.wav");
m = audio(:,1); %get first channel only because its stero
m = reshape(m, 1, []); %reshape to ensure dimension correct

% 2. define time vector
audio_time = length(m)/Fs; % get numbers of seconds in the audio
time = linspace(0, audio_time, length(m));

% 3. analyse it
M = analyzeSignal(time, m, Fs, 'Analysis of Modulating Signal');

%% ========= task 2 ======
% 1. get helper variables
M_mag = abs(M);
mp = abs(min(m));

mue = 1; % mp/Ac
bandwidth = 5000; % approx from the plot
% 2. define carrier properties
Ac = mp / mue;
Fc = 2* bandwidth;
Wc = 2*pi*Fc;
% 3. define signals
c = cos(Wc .* time);
m_added = m + Ac; % intermidate value for later plotting
y = m_added .* c;
% 3.* plot steps
figure;
sgtitle("DSB-LC steps in Time domain");


subplot(4, 1, 1);
plot(time(1:1000), m(1:1000));
title("Modulating signal");

subplot(4, 1, 2);
plot(time(1:1000), m_added(1:1000));
title("m+Ac signal");

subplot(4, 1, 3);
plot(time(1:1000), c(1:1000));
title("cos(Wc t) signal");

subplot(4, 1, 4);
title("Modulated signal");
hold on;
plot(time(1:1000), y(1:1000));
%print envolope around modulted signal
plot(time(1:1000), m_added(1:1000), 'color', [0.5, 0.5, 0.5], 'LineStyle', '--');
plot(time(1:1000), m_added(1:1000)*-1, 'color', [0.5, 0.5, 0.5], 'LineStyle', '--');



% 4. analyse
Y = analyzeSignal(time, y, Fs, 'Analysis of Modulated Signal');

% 5. compare two signals in frequency domain
frequency = linspace(-Fs/2, Fs/2, length(M));

figure;
subplot(2, 1, 1);
sgtitle("Modulating vs Modulated in Frequency domain");

plot(frequency, M_mag);
title("Modulting");
xlabel("Frequency (Hz)");
ylabel("Amplitide");

subplot(2, 1, 2);
plot(frequency, abs(Y));
title("Modulted");
xlabel("Frequency (Hz)");
ylabel("Amplitide");


%% ========= task 3 ======
% 1. demodulate signal
x = y .* c;
x = lowpass(x, bandwidth ,Fs);
x = 2*x - Ac;
% 2. analyze it
X = analyzeSignal(time, x, Fs, 'Analysis of Demodulated Signal');
% 3. write to another file to hear it
audiowrite('output.wav',x,Fs);
