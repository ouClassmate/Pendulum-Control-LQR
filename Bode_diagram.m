% 画出内环（带控制器）开环传递函数的奈奎斯特图、伯德图
clear
clc
% f1 = 1500*[5 1];%分子
f1 = [0 100];%分子
f2 = [1.33 0.0031];%分子
% f3 = [100 1];%分母
f3 = [0 1];%分母
f4 = [1 0.27 -19.6 -3.984];%分母
%conv的用处是把他们求成多项式的形式
num = conv(f1,f2);%求多项式
den = conv(f3,f4);%求多项式
sys = tf(num,den)
%画出所有参数
figure(1)
margin(sys);
% grid on;
%不画，直接给参数赋值出来
%[Gm,Pm,Wcg,Wcp] = margin(sys);%Gm幅值裕度 Pm相角裕度 Wcg穿越频率 Wcp剪切频率
figure(2)
nyquist(sys);  % 画奈奎斯特图
% grid on;