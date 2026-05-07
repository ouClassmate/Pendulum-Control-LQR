clear
clc
%% 初始化参数
M = 1;  % 小车质量（kg）
m = 0.5;  % 摆杆质量（kg）
l = 0.5;   % 转动关节到摆杆质心的长度（m）
b1 = 0.3;  % 小车移动阻尼
b2 = 0;   % 摆杆转动阻尼
I = (m*l^2) / 3;   % 摆杆转动惯量
g = 9.8;  % 重力加速度
Cd = 1.2;   % 阻力系数
rho = 1.293;   % 空气密度（kg/m3）
A0 = 0.032;    % 直立状态的特征面积，假设摆杆是0.032m*0.032m*1m的立方体木杆，密度为500kg/m3
theta0 = 5 * pi/180;   % 摆杆初始角度（rad）
theta_d = 0 * pi/180;   % 摆杆目标角度（rad）
x_d = 0;    % 目标位置
%% 初始化无量纲化参数
T_NX = diag([0.85 0.33 1 0.33]);   % X无量纲化
T_NF = 0.02;  % F无量纲化
%% 初始化LQR参数
A_N = [0 3 0 0;
       5.96 0 0 -1.2;
       0 0 0 3;
       0.85 0 0 -0.81];
B_N = [0; 66.5; 0; 44.5];
Q = diag([4 1 4 1]);
R = 0.25;
[K, S, P] = lqr(A_N, B_N, Q, R);
%% 运行仿真获取数据
% simout = sim("pendulum_simplePID", 2);  % 参数为模型名和仿真时间
% simout = sim("pendulum_friction_PID", 2);  % 参数为模型名和仿真时间
simout = sim("pendulum_LQR", 10);  % 参数为模型名和仿真时间
t = simout.theta.time;
theta = simout.theta.data;  % 摆杆角度
x = simout.x.data;   % 滑块位移
%% 倒立摆动画演示
im = cell(length(t), 1);
h = figure(1);
for k = 1:length(t)
    bot_x = x(k); bot_y = 0;                           % 杆底坐标
    top_x = x(k) - 2*l*sin(theta(k)); top_y = 2*l*cos(theta(k)); % 杆顶坐标
    plot(bot_x, bot_y, 'o', 'LineWidth', 1.5); hold on;
    plot([bot_x, top_x], [bot_y, top_y], 'LineWidth', 2); 
    hold off;
    axis equal; 
    axis([-1, 1, -0.10, 1.2]); grid on;
    title('Pendulum Animation')
    drawnow;
    frame = getframe(h);      % 记录该帧
    im{k} = frame2im(frame);
    % pause(0.01);
end
%% GIF图片制作
filename = 'pendulum_animation.gif';
for idx = 1:length(t)
    [A, map] = rgb2ind(im{idx}, 256);
    if idx == 1
        imwrite(A, map, filename, 'gif', 'LoopCount', Inf, 'DelayTime', 1.00);
    else
        imwrite(A, map, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.01);
    end
end