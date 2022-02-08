%%% Práctica : Filtrado de señales
clear all;
close all;

%% Paso 1 : Generación de la entrada en el dominio del tiempo

figure(1)

fs=48000 % Frecuencia de muestreo utilizada en el DVD en Hz.
T=1; %Duración de la señal en segundos
f=440; %Frecuencia de la señal senoidal
A=0.1; %Amplitud de la señal senoidal

t=1/fs:1/fs:T; %Vector eje tiempo
L=length(t) %Longitud del vector t. Comprobar que sea igual a fs*T
xdet=A*cos(2*pi*f*t); %Generación de x(t)

plot(t,xdet); %Dibujo de x(t)
axis([0 0.1 -0.5 0.5]) %Ajusta los ejes para la correcta visualización de x(t)
xlabel('Tiempo(seg)') %Etiquetado del eje horizontal (tiempo)
ylabel('Amplitud') %Etiquetado del eje vertical
title('Señal de entrada en el dominio del tiempo') %Etiquetad figura

sound(xdet,fs) %Permite escuchar x(t)

%% Paso 2 : Representación de la entrada en el dominio de la frecuencia

figure(2)

Xdef=fftshift(fft(xdet)); % Transformada de Fourier de xdet
f=-fs/2+fs/L:fs/L:fs/2; %Declaración del eje de frecuencias

plot(f,abs(Xdef)/max(abs(Xdef))); %Dibujo del módulo de Xdef
axis([-1000 1000 0 1.1]); %Ajuste de los ejes de la figura

%% Paso 3 : Obtención de la respuesta en frecuencia de un filtro ideal

figure(3)

flow=600; %Frecuencia de corte (Hz) del filtro paso bajo
Hdef=zeros(1,L/2);
Hdef(1:flow/fs*L)=ones(1,flow/fs*L);
Hdef=[fliplr(Hdef) Hdef];

plot(f,abs(Hdef));
axis([-1000 1000 0 1.1])

figure(4)

fhigh=600; %Frecuencia de corte (Hz) del filtro paso alto
Hdef=ones(1,L/2);
Hdef(1:fhigh/fs*L)=zeros(1,fhigh/fs*L);
Hdef=[fliplr(Hdef) Hdef];

plot(f,abs(Hdef));
axis([-1000 1000 0 1.1])

%% Paso 4 : Obtención de la señal de salida en el dominio de la frecuencia

figure(5)

Ydef=Xdef.*Hdef;
plot(f,abs(Ydef)/max(abs(Ydef)));
axis([-1000 1000 0 1.1])

%% Paso 5 : Obtención de la señal de salida en el dominio del tiempo

figure(6)

ydet=ifft(fftshift(Ydef)); %Cálculo de la transformada de Fourier inversa
ydet=real(ydet);

plot(t,ydet);
axis([0 0.1 -0.5 0.5])

pause; %Pausa previa a la audición de y(t). Pulse cualquier tecla para continuar
sound(ydet,fs);

%% Paso 6 : Ejecución e interpretación de los resultados
