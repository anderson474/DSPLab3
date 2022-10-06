function [Pd,Pt,Pa,Pb1,Pb2,Pu] = rel_pot(x);

%	x	segnale di ingresso;

  w1=boxcar(4096);
  [Pxx,f]=periodogram(x,rectwin(7680),512/0.125,512,'psd');
  %Pxx=Pxx*norm(w1)^2/sum(w1)^2;
  %Pxx=Pxx/length(Pxx);

  f1=0.5;
  f2=3.5;
  Pd=sum(Pxx(find(f==f1):find(f==f2)))/sum(Pxx);
  f1=3.625;
  f2=7;
  Pt=sum(Pxx(find(f==f1):find(f==f2)))/sum(Pxx);
  f1=7.125;
  f2=14;
  Pa=sum(Pxx(find(f==f1):find(f==f2)))/sum(Pxx);
  f1=14.125;
  f2=21;
  Pb1=sum(Pxx(find(f==f1):find(f==f2)))/sum(Pxx);
  f1=21.125;
  f2=30;
  Pb2=sum(Pxx(find(f==f1):find(f==f2)))/sum(Pxx);
  f1=30.125;
  f2=2049;
  Pu=sum(Pxx(find(f==f1):find(f==f2)))/sum(Pxx);
end