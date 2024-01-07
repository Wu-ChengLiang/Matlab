# Matlab 
matlab开发文档
一. 开发环境及工具
硬件运行环境为本试验所用的计算机设备，CPU为Inter(R)Xeno(R) Gold 5218 CPU @ 2.3GHz，GPU为NVIDIA GeForce RTX 4060。
开发环境基于Windows 11操作系统，matlab R2022a。
二. 程序的功能作简要介绍
1、程序的功能作简要介绍
本次《测绘程序设计》期末考核要求同学们进行“附合导线近似平差”和“高斯正算”两个程序的编写，以检验其对测绘知识和程序设计的掌握程度。
首先，要完成这个任务，需要理解并掌握附合导线近似平差和高斯正算的基本原理，以及相关的数学模型。然后，根据给定的数据和条件，进行程序设计和编码。
在程序设计中，本程序努力做到以下几点：
1.正确性：程序应能正确完成计算任务，得出正确的结果。
2.完整性：程序应结构完整，包括合理的函数设计、语句调用等。
3.规范性：程序命名、注释、变量和函数命名等应符合规范。
4.优化性：程序应简洁易读，有良好的可读性和可维护性。
附合导线
附合导线是指连接两个已知控制点的一种导线，通常用于测量和计算两点之间的距离、角度和坐标。在附合导线程序中，需要输入导线的起点和终点的坐标以及观测的边长和角度，程序会根据这些数据计算出导线的长度、方位角、高程等信息，并输出相应的结果。附合导线程序的功能还包括对导线进行平差处理，消除误差，提高测量精度。
高斯正算
高斯正算是一种用于计算坐标正反算的方法，即根据已知点的坐标和方位角计算出待测点的坐标。在高斯正算程序中，用户需要输入已知点和待测点的坐标以及方位角等信息，程序会根据高斯投影的原理和公式，计算出待测点的坐标，并输出结果。高斯正算程序还可以进行坐标转换和地图投影等操作，是测量学中常用的工具之一。
三. 编写目的
- 期末考核共包含两道题目，即“附合导线近似平差”和“高斯正算”程序设计
- 提高程序编写水平
- 练习开发文档编写
四. 算法设计思路（函数模块）
附合导线
function附合计算代码块
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
gui代码块
function pushbutton1_Callback(hObject, eventdata, handles)
%pushbutton1代表是"计算"，有关计算的代码都在此按钮下面
str=get(handles.edit1,'string');
X1=str2num(str);
str=get(handles.edit2,'string')
Y1=str2num(str);
str=get(handles.edit3,'string')
X2=str2num(str);
str=get(handles.edit4,'string')
Y2=str2num(str);
str=get(handles.edit5,'string')
azi1=str2num(str);
str=get(handles.edit6,'string')
azi2=str2num(str);
%输入角度和距离
str=get(handles.edit9,'string')
Ang=str2num(str);
str=get(handles.edit13,'string')
Dis=str2num(str);
[fbx,k,x,y]=TranverseFH(X1,Y1,azi1,X2,Y2,azi2,Ang',Dis')
str1=sprintf('%8.8f',fbx)
set(handles.edit14,'string',str1);
str1=sprintf('%8.8f',k)
set(handles.edit15,'string',str1);
strx=[];
for i=1:size(x:2)
    str1=sprintf('%i','%.3f','%.3f\n',i,x(i),y(i));
    strx=[strx str1];
end
set(handles.edit17,'string',strx)
高斯正算
get_X模块
这个模块用B,a,b求解X
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
function 坐标转化模块
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
    b=6356752.3141;
end
B=dms_rad(B);
L=dms_rad(L);
L0=dms_rad(L0);
X=get_X(B,a,b);
e1=sqrt(a^2-b^2)/a; %第一偏心率
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

高斯正算输入数据
[x,y]=BL2xy(37.3915,111.5654,114,3)

七. 主要变量说明表
附合导线近似平差程序【函数 TranverseFH】主要变量说明表
变量名输入/输出类型说明fbx输出数值角度闭合差，单位换算为秒k输出数值全长相对闭合差（可能是近似值）的整数部分x输出数组待定点的 X 坐标数组y输出数组待定点的 Y 坐标数组XB, YB输入数值已知起始点的 X 和 Y 坐标XC, YC输入数值已知终点的 X 和 Y 坐标azi1输入数值已知起始边的方位角（度或弧度），函数内部转换为弧度azi2输入数值已知终边的方位角（度或弧度），函数内部转换为弧度Ang输入数组观测的角度数组（假设输入为度，函数内部转换为弧度）Dis输入数组观测的边长数组n内部变量数值观测角的个数，通过length(Ang)计算得出radangle内部变量数组将观测的角度数组从度转换为弧度后的数组zb内部变量数值观测角之和（弧度）fb内部变量数值计算出的角度闭合差（弧度），并取2π的余数标准化fwj内部变量数组平差后各边的方位角数组（弧度）dx, dy内部变量数组根据平差后的方位角和边长计算出的坐标增量数组fx, fy内部变量数值坐标增量的闭合差在 X 和 Y 方向上的分量fs内部变量数值坐标增量闭合差的长度（直线距离）Zd内部变量数值所有观测边长的总和
高斯正算程序【函数BL2xy】主要变量说明表
变量名输入/输出类型说明x, y输出数值投影后的平面直角坐标系的 X 和 Y 坐标B输入数值大地纬度，函数内部将其从度转换为弧度L输入数值大地经度，函数内部将其从度转换为弧度L0输入数值中央经线，函数内部将其从度转换为弧度n输入数值椭球模型选择参数，用于选择不同的椭球体参数 a 和 ba内部变量数值椭球体的长半轴长度，根据 n 的值选择不同的数值b内部变量数值椭球体的短半轴长度，根据 n 的值选择不同的数值e1内部变量数值第一偏心率，根据 a 和 b 计算得出N内部变量数值卯酉圈曲率半径，根据 B、a 和 e1 计算得出l内部变量数值经度差，即大地经度 L 与中央经线 L0 的差值（弧度）t内部变量数值正切值 tan(B) 的简写，用于后续计算e2内部变量数值第二偏心率，根据 a 和 b 计算得出ita内部变量数值由 e2 和 B 计算得出的中间变量，用于后续计算X内部变量数值由纬度 B、a 和 b 通过get_X函数计算得出的中间值
注意：dms_rad 函数是将角度从度分秒格式转换为弧度的辅助函数
八. 难点预估
1字体不居中
解决方案：将fontunits修改为normalization，然后将fontsize修改为0.7
2坐标位数过少的问题
str1=sprintf('%8.8f',x)
set(handles.edit5,'string',str1);
str1=sprintf('%8.8f',y) %把位数修改到8位
set(handles.edit6,'string',str1);


