function[X]=get_X(B,a,b)

e2=sqrt(a^2-b^2)/b;
beita0=1-3/4*(e2^2)+45/64*e2^4-175/256*e2^6+11025/16384*e2^8
beita2=beita0-1
beita4=15/32*e2^4+175/384*e2^6+3675/8164*e2^8
beita6=-35/96*e2^6+735/2048*e2^8
beita8=315/1024*e2^8
c=a^2/b;
X=c*(beita0*B+(beita2*cos(B)+beita4*cos(B)^3+beita6*cos(B)^7)*sin(B));
end
%[X]=get_X(0.6571928776,6378137,6356752.3142) 
%format long g 切换输出