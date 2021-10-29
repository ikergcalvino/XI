% Íker García Calviño
clear all;
close all;

fs = 48000; % Frecuencia de muestreo
T = 1; % Período

% Frecuencias
f1 = 150;
f2 = 2 * f1;
f3 = 3 * f1;
f4 = 4 * f1;

% Amplitudes
A1 = 1;
A2 = 1;
A3 = 1;
A4 = 1;

t = 1/fs : 1/fs : T; % Vector eje tiempo
L = length(t); % Longitud del vector

% Cálculo de los senos
x1 = A1 * cos(2 * pi * f1 * t);
x2 = A2 * cos(2 * pi * f2 * t);
x3 = A3 * cos(2 * pi * f3 * t);
x4 = A4 * cos(2 * pi * f4 * t);
xdet = x1 + x2 + x3 + x4;

%xdet = xdet + rand(1, L); % Añade ruido (ej.13, Oct 5)

% Transformada de Fourier de las señales
xf1 = fftshift(fft(x1));
xf2 = fftshift(fft(x2));
xf3 = fftshift(fft(x3));
xf4 = fftshift(fft(x4));
Xdef = fftshift(fft(xdet));

f = -fs/2 + fs/L : fs/L : fs/2; % Declaración del eje de frecuencias

flow = 200; % Frecuencia de corte (Hz) del filtro paso bajo
fhigh = 100; % Frecuencia de corte (Hz) del filtro paso alto

% Filtro paso bajo (low)
Hdef1 = zeros(1, L/2);
Hdef1(1 : flow/fs*L) = ones(1, flow/fs*L);
Hdef1 = [fliplr(Hdef1) Hdef1];

% Filtro paso bajo (high)
Hdef2 = zeros(1, L/2);
Hdef2(1 : fhigh/fs*L) = ones(1, fhigh/fs*L);
Hdef2 = [fliplr(Hdef2) Hdef2];

% Filtro paso alto
Hdef3 = ones(1, L/2);
Hdef3(1 : fhigh/fs*L) = zeros(1, fhigh/fs*L);
Hdef3 = [fliplr(Hdef3) Hdef3];

filtro = 0;

if filtro == 0
    Hdef = Hdef1; % Filtro paso bajo
elseif filtro == 1
    Hdef = Hdef2 - Hdef1; % Filtro paso banda
elseif filtro == 2
    Hdef = Hdef3; % Filtro paso alto
elseif filtro == 3
    Hdef = 1 - (Hdef2 - Hdef1); % Filtro banda eliminada
end

Ydef = Xdef .* Hdef; % Señal filtrada en frecuencia

ydet = ifft(fftshift(Ydef)); % Cálculo de la transformada de Fourier inversa
ydet = real(ydet); % Señal filtrada en tiempo

figure;

subplot(4, 1, 1);
plot(t, xdet);
axis([0 0.1 -0.5 0.5]);
title('Suma señales: x1 + x2 + x3 + x4'); % Señal de entrada en el dominio del tiempo
xlabel('Tiempo (seg)');
ylabel('Amplitud');

subplot(4, 1, 2);
plot(f, abs(Xdef)/max(abs(Xdef)));
axis([-1000 1000 0 1.1]);
title('TF + Filtro');
xlabel('Frecuencia (Hz)');
ylabel('Módulo');
hold on;
plot(f, abs(Hdef), 'g');

subplot(4, 1, 3);
plot(f, abs(Ydef)/max(abs(Ydef)));
axis([-1000 1000 0 1.1]);
title('Señal filtrada en frecuencia')
xlabel('Frecuencia (Hz)');
ylabel('Módulo');

subplot(4, 1, 4);
plot(t, ydet);
axis([0 0.1 -0.5 0.5]);
title('Señal filtrada en el tiempo');
xlabel('Tiempo(seg)');
ylabel('Amplitud');
