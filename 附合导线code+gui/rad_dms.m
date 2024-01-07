function [dms]=rad_dms(rad)
    %%弧度转换为角度
    % dms为角度
    %  rad为弧度
     a=mod(rad,2*pi); %取余?
     d=rad2deg(a);    %得到度（浮点）
     d1=fix(d); 
     d2=(d-d1).*60;   %得到分
     f=fix(d2);
     f1=(d2-f).*60;   %得到秒
     dms=d1+f./100+f1./10000;