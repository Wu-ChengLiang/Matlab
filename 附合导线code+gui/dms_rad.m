function [rad] = dms_rad(dms)%角度转弧度
d=fix(dms);%取整得到度
f1=(dms-d).*100;
f1=roundn(f1,-10);
f=fix(f1);%取整得到分
m=(f1-f).*100;%取整得到秒
f=f./60;
m=m./3600;
r=(d+f+m)./180;
rad=r.*pi;
end