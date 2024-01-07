function [x,y]=BL2xy(B,L,L0,n)
%l0是中央经线，B是大地纬度，L是大地经度

switch n
 case(1)%WGS84
    a=6378137.0;
    b=6356752.3142;
 case(2)%IUGG75
    a=6378140.0;
    b=6356755.2881;
 case(3)%CGCS2000椭球坐标系,在作业中采用
    a=6378137.0;
    b=6536752.3141;
end

B=dms_rad(B);
L=dms_rad(L);
L0=dms_rad(L0);
X=get_X(B,a,b);
e1=sqrt(a^2-b^2)/a; %计算第一偏心率
N=a/sqrt(1-e1^2*sin(B)^2);
l=L-L0;%计算出距离中央经线的距离
t=tan(B);
e2=sqrt(a^2-b^2)/b;%计算第二偏心率
ita=e2*cos(B);
x=X+N/2*sin(B)*cos(B)^2+...
    N/24*sin(B)*cos(B)^3*(5-t^2+9*ita^2+ita^4)*l^4 ...%注意等式和...中有空格
+N/720*sin(B)*cos(B)^5*(61-58*t^2+t^4)*l^6;

y=N*cos(B)*l+N/6*cos(B)^3*(1-t^2+ita^2)*l^3 ...
    +N/120*cos(B)^5*(5-18*t^2+t^4+14*ita^2-58*t^2*ita^2)*l^5;

end