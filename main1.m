clc
clear all
close all
% Este programa trata una señal de encefalograma
%@author Jhon Anderson Galeano Santillana &
%Juan Jose Orozco Vanegas
% Materia: DSP
%Profesor Mateo Escobar
%******************************************************************

[file,path]= uigetfile('*.bin','Load');
filename=sprintf('%s%s', path, file);
h=fopen(filename,'r');
x=fread(h,inf,'float');
fclose(h);

%******************************************************************

%******************************************************************
%se extraen los canales por cada columna y en las filas 
%cada una de las muestras

cont=0;
Matrix(7680,25)=ones;

for i=1:7680
    for j =1:25
        Matrix(i,j) = x(j+cont);
    end
    cont = cont + 25;
end

%Se extraen los canales 7 y 9
%y se representan de 9 a 10
%segundos 512[mues/seg] entonces 10s 
%son 512*10, y así se puede aplicar una regla de tres

Mcanal7 = Matrix(:,7);
Mcanal9 = Matrix(:,9);
subplot(2,1,1)
plot(Mcanal7(4608:5120))
xlabel("muestras")
ylabel("unidades arbitrarias")
legend("Canal 7 de 9-10seg")
subplot(2,1,2)
plot(Mcanal9(4608:5120))
xlabel("muestras")
ylabel("unidades arbitrarias")
legend("Canal 9 de 9-10seg")
%******************************************************************


%************************************************************************
%
figure
[Pxx f]=periodogram(Mcanal9,rectwin(7680),512/0.125,512,'psd');
plot(f,Pxx)
xlabel("Frecuencia")
ylabel("Potencia")
legend("densidad espectral del canal 9")
axis([0 50 0 28])
figure
[Pxx1 f1]=periodogram(Mcanal7,rectwin(7680),512/0.125,512,'psd');
plot(f1,Pxx1)
xlabel("Frecuencia")
ylabel("Potencia")
legend("densidad espectral del canal 7")
axis([0 50 0 15])
%**********************************************************

%***********************************************************
Mtcan(1:7680,1) = Matrix(:,7);
Mtcan(7681:15360,1) = Matrix(:,9);
[Pxx2 f2]=periodogram(Mtcan,rectwin(15360),512/0.125,512,'psd');
Mcom = [Pxx2 f2];
for i=1:length(Mcom)
    if(f2(i)<=3.5)&&(0.5<=f2(i))
        Delta(i-4)=Mcom(i,1);
    end
    if(f2(i)>3.5)&&(f2(i)<=7)
        Theta(i-29)=Mcom(i,1);
    end
    if(f2(i)>7)&&(f2(i)<=14)
        Alfa(i-57)=Mcom(i,1);
    end
    if(f2(i)>14)&&(f2(i)<=21)
        Beta1(i-113)=Mcom(i,1);
    end
    if(f2(i)>21)&&(f2(i)<=30)
        Beta2(i-169)=Mcom(i,1);
    end
end
sumTotal=sum(Mcom(:,1));
porDelta=sum(Delta)/sumTotal;
porTheta=sum(Theta)/sumTotal;
porAlfa=sum(Alfa)/sumTotal;
porBeta1=sum(Beta1)/sumTotal;
porBeta2=sum(Beta2)/sumTotal;
figure
plot(f2,Pxx2)
xlabel("Frecuencia")
ylabel("Potencia")
legend("densidad espectral de los dos canales" + ...
    "Delta"+porDelta + ...
    "Theta"+porTheta + ...
    "Alfa"+porAlfa + ...
    "Beta1"+porBeta1 + ...
    "Beta2"+porBeta2)
axis([0 50 0 28])
%************************************************************************

%*************Pwelch****************************************
[Pxx3, f3]=pwelch(Mtcan,hamming(1024),512,512/0.125,512,'psd');
Mcom = [Pxx3 f3];
for i=1:length(Mcom)
    if(f3(i)<=3.5)&&(0.5<=f3(i))
        Delta(i-4)=Mcom(i,1);
    end
    if(f3(i)>3.5)&&(f3(i)<=7)
        Theta(i-29)=Mcom(i,1);
    end
    if(f3(i)>7)&&(f3(i)<=14)
        Alfa(i-57)=Mcom(i,1);
    end
    if(f3(i)>14)&&(f3(i)<=21)
        Beta1(i-113)=Mcom(i,1);
    end
    if(f3(i)>21)&&(f3(i)<=30)
        Beta2(i-169)=Mcom(i,1);
    end
end
sumTotal=sum(Mcom(:,1));
porDelta=sum(Delta)/sumTotal;
porTheta=sum(Theta)/sumTotal;
porAlfa=sum(Alfa)/sumTotal;
porBeta1=sum(Beta1)/sumTotal;
porBeta2=sum(Beta2)/sumTotal;
figure
plot(f3,Pxx3)
title("Pwelch")
xlabel("Frecuencia")
ylabel("Potencia")
legend("densidad espectral de los dos canales" + ...
    "Delta"+porDelta + ...
    "Theta"+porTheta + ...
    "Alfa"+porAlfa + ...
    "Beta1"+porBeta1 + ...
    "Beta2"+porBeta2)
axis([0 50 0 28])
%************************************************************************

%************************************************************************
Z=[std(Matrix(:,1:5));std(Matrix(:,6:10));std(Matrix(:,11:15));std(Matrix(:,16:20));std(Matrix(:,21:25))]';
figure
mappa(Z,'mapa')
%************************************************************************

%************************************************************************
%
for i = 1:5
    for j= 1:5
        d=Matrix(:,j+(i-1)*5);
        [Zd(i,j),Zt(i,j),Za(i,j),Zb1(i,j),Zb2(i,j),Zu(i,j)]=rel_pot(d);
    end
end
figure
mappa(Zd,'delta');
figure
mappa(Zt,'teta');
figure
mappa(Za,'alfa');
figure
mappa(Zb1,'beta 1');
figure
mappa(Zb2,'beta 2');
