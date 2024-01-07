function [fbx,k,x,y] = TranverseFH(XB,YB,azi1,XC,YC,azi2,Ang,Dis)
 %% ���㸽�ϵ���
 % x,y ���ش��������꣬fwj ƽ�����ߵķ�λ��
 % fbx ���ؽǶȱպϲ�,kȫ����Ապϲ�
 % XB,YB,XC,YC ��֪������x
 % azi1��azi2��֪��ʼ�ߺ��ձ߷�λ��
 % Ang,Dis�ǹ۲�ĽǶ�(����)�ͱ߳�
%��������ʹ���
n=length(Ang);  %��ù۲�Ǹ���  
[radangle]=dms_rad(Ang);% �Ƕ�ת��Ϊ����
zb=sum(radangle);  %�۲��֮��
azi1=dms_rad(azi1);
azi2=dms_rad(azi2);
fb=zb-n*pi-azi2+azi1;    %����Ƕȱպϲ�
fb=rem(fb,2*pi); %ȡ����
fbx=round(fb*206264.80); %���Ƕȱպϲ����

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
dx=dx-(fx/Zd).*Dis;%���������պϲ�ķ���
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