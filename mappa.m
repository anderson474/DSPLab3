function mappa(Z,titolo);

  x=[-2,-1,0,1,2];
  y=[-4,-2,0,2,4];
  [xi,yi]=meshgrid(-2:0.1:2,-4:0.1:4);
  ZI=interp2(x,y,Z,xi,yi,'cubic');
  pcolor(xi,yi,ZI);
  shading interp;
  hold on
  contour(xi,yi,ZI,12,'k');
  hold off
  colormap(hot(32));
  title(titolo);

end
