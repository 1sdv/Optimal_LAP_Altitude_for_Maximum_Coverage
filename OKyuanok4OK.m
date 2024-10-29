% 定义常数
nL = 0.1;
nN = 21;
A = nL - nN;
f = 2000000000; % MHz
c = 3 * 100000000; % 光速
B = 20 * log10(f) + 20 * log10(4 * pi / c) + nN;
PLmax_values = [105, 111, 114, 117, 120]; % dB
a = 9.61; % 越小越好
b = 0.16; % 越大越好

% 定义h的范围
h = 1:10000;

% 初始化用于存储最大R值和对应h值的数组
maxR_values = zeros(length(PLmax_values), 1);
h_values = zeros(length(PLmax_values), 1);

% 循环不同的PLmax值
for j = 1:length(PLmax_values)
    PLmax = PLmax_values(j);

    % 初始化R数组
    R = zeros(size(h));

    % 对每个h值计算R
    for i = 1:length(h)
        % 定义方程
        equation = @(R) PLmax- ((A / (1 + a * exp(-b * (rad2deg(atan(h(i)/R)) - a)))) + 10 * log10(h(i)^2 + R^2) + B);

        % 使用fsolve求解方程
        initial_guess = 100; % 初始猜测值
        options = optimset('Display', 'off'); % 关闭显示求解过程信息
        R(i) = fsolve(equation, initial_guess, options);
    end

    % 存储每个PLmax值下的最大R值和对应的h值
    [maxR, idx] = max(R);
    maxR_values(j) = maxR;
    h_values(j) = h(idx);

    % 绘制R-h曲线
    plot(h, R, 'DisplayName', sprintf('PLmax = %d dB', PLmax));
    hold on;
end

% 绘制连接最大R值的直线
plot(h_values, maxR_values, 'k--', 'LineWidth', 2, 'DisplayName', 'Max R Line');

% 设置图例和图表格式
legend('show');
xlabel('h');
ylabel('R');
title('R-h Relationship for Different PLmax Values');
grid on;

hold off;
