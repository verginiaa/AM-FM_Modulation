%-------------------------------------------------clear--------------------------------------------------------------------
clc;
close all;
clear all;
%-------------------------------------------------read file--------------------------------------------------------------------
FILE = 'eric.wav';
fc = 100000;

modulation_index = 0.5;
[yt, fs]= audioread(FILE);
fs_res = 5*fc;
f_filter = 4000;
%-------------------------------------------------plotting--------------------------------------------------------------------
xt = linspace(0,length(yt)/fs,length(yt));
%plot_signal(xt,yt,'Message in time domain','time','Value');
%-------------------------------------------------message in frequency domain--------------------------------------------------------------------
yf = fftshift(fft(yt));
xf = linspace(-fs/2,fs/2,length(yf));
%-------------------------------------------------plotting--------------------------------------------------------------------
%plot_signal(xf,real(yf),'Message in frequency domain','Frequency','Value');
%-------------------------------------------------filter--------------------------------------------------------------------
filter = generate_filter(length(yf),xf,f_filter);
yf_filtered = filter.*yf;
%-------------------------------------------------plotting--------------------------------------------------------------------
% plot_signal(xf,real(filter),'Filter','Frequency','Value');
% plot_signal(xf,real(yf_filtered),'Filtered message in frequency domain','Frequency', 'Value');
%-------------------------------------------------back to time domain--------------------------------------------------------------------
yt_filtered= real(ifft(ifftshift(yf_filtered)));
%-------------------------------------------------sound--------------------------------------------------------------------
% sound(yt_filtered,fs);
%-------------------------------------------------plotting--------------------------------------------------------------------
xt = linspace(0,length(yt_filtered)/fs, length(yt_filtered));
% plot_signal(xt, yt_filtered, 'Filtered message in time domain','Time','Value');
%-------------------------------------------------resmple--------------------------------------------------------------------
yt_resampled = resample(yt_filtered,fs_res,fs);
%-------------------------------------------------carrier signal--------------------------------------------------------------------
t = linspace(0,length(yt_resampled)/fs_res, length(yt_resampled)); %(x2-x1)/(n-1) = 1/5*fc, linspace(x1,x2,n)
carrier = cos(2*pi*fc*t).';
carriersin = sin(2*pi*fc*t).';
yt_carrier=carrier;
yf_carrier=fftshift(fft(yt_carrier));
xt_carrier=t;
xf_carrier=linspace(-fc/2,fc/2,length(yt_carrier));
%------------------------------------------------FM Modulation------------------------------------------------------------------------
A = 2;
% kf = 160*pi;
% message_int =  kf*1.e-4*cumsum(yt_resampled);
% yt_modulated = A.*carrier-A.*message_int;
% yf_modulated = fftshift(fft(yt_modulated));
% xf = linspace(-fc/2,fc/2, length(yf_modulated));
% plot_signal(xf,yf_modulated,'','','');
% 
y = fmmod(yt_resampled,fc,fs_res,1050);
yf_mod = fftshift(fft(y));
xf = linspace(-fc/2,fc/2, length(yf_mod));
plot_signal(xf,yf_mod,'','','');


kf = 160*pi;
m_int = kf*1.e-4*cumsum(yt_resampled).'; % Integrating Msg
fm = A.*cos(2*fc*pi*t + m_int); % fm = cos(2*pi*fc*t + integral(msg))
% yt_modulated = A.*carrier-A.*m_int.*carriersin;
yf_modulated = fftshift(fft(fm));
 xf = linspace(-fc/2,fc/2, length(fm));
 plot_signal(xf,abs(fm),'','','');















