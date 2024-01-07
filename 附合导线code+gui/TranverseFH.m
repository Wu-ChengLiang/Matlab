function [fbx,k,x,y] = TranverseFH(XB,YB,azi1,XC,YC,azi2,Ang,Dis)
 %% 解算附合导线
 % x,y 返回待定点坐标，fwj 平差后各边的方位角
 % fbx 返回角度闭合差,k全长相对闭合差
 % XB,YB,XC,YC 已知点坐标x
 % azi1和azi2已知起始边和终边方位角
 % Ang,Dis是观测的角度(弧度)和边长
%数据输入和处理
n=length(Ang);  %获得观测角个数  
[radangle]=dms_rad(Ang);% 角度转换为弧度
zb=sum(radangle);  %观测角之和
azi1=dms_rad(azi1);
azi2=dms_rad(azi2);
fb=zb-n*pi-azi2+azi1;    %计算角度闭合差
fb=rem(fb,2*pi); %取余数
fbx=round(fb*206264.80); %将角度闭合差换成秒

radangle=radangle-fb./n;
for i=1:n
    if i==1
        fwj(i) = azi1-pi+radangle(i);
    else
        fwj(i)=fwj(i-1)-pi+radangle(i);
    end
end
dx=cos(fwj(1:n-1)).*Dis;
dy=sin(fwj(1:n-1)).*Dis;
fx=sum(dx)+XB-XC;
fy=sum(dy)+YB-YC;
fs=sqrt(fx^2+fy^2);
Zd=sum(Dis);    
k=fix(Zd/fs);
dx=dx-(fx/Zd).*Dis;%坐标增量闭合差的分配
dy=dy-(fy/Zd).*Dis;
for i=1:n-1
    if i==1
        x(i)=XB+dx(i);
        y(i)=YB+dy(i);
    else
        x(i)=x(i-1)+dx(i);
        y(i)=y(i-1)+dy(i);
    end
end