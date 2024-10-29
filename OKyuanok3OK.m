%clear ;
% 定义常数
f = 2000000000; % MHz
c = 3 * 100000000; % 光速
PLmax = 110; % dB
G=10^(110/10); %%转为数值

% 定义a和b的值对应不同的环境
a_b_values = [4.88, 0.43; 9.61, 0.16; 12.08, 0.11; 27.23, 0.08];
environments = {'Suburban', 'Urban', 'Dense Urban', 'Highrise Urban'};

% 定义nL和nN的值及其对应的环境名称
nL_nN_pairs = [0.1, 21; 1.0, 20; 1.6, 23; 2.3, 34];

% 定义h的范围
h = 1:4500;

% 对每一对nL和nN计算R
for j = 1:size(nL_nN_pairs, 1)
    nL = nL_nN_pairs(j, 1);
    nN = nL_nN_pairs(j, 2);
    A = nL - nN;
    B = 20 * log10(f) + 20 * log10(4 * pi / c) + nN;

    % 从数组中选取相应的a和b值
    a = a_b_values(j, 1);
    b = a_b_values(j, 2);

    R = zeros(size(h));
    for i = 1:length(h)
        % 定义方程
        equation = @(R)  PLmax- ((A / (1 + a * exp(-b * (rad2deg(atan(h(i)/R)) - a)))) + 10 * log10(h(i)^2 + R^2) + B);
        
        % 使用fsolve求解方程
        initial_guess = 100; % 初始猜测值
        options = optimset('Display', 'off'); % 关闭显示求解过程信息
        R(i) = fsolve(equation, initial_guess, options);
    end
    
    % 绘制图形
    plot(h, R, 'DisplayName', environments{j});
    hold on;

    % 找到最大值并标注
    [maxR, idx] = max(R);
    plot(h(idx), maxR, 'o', 'HandleVisibility', 'off'); % 添加点
    text(h(idx), maxR, sprintf('Max: %.2f', maxR), 'VerticalAlignment', 'bottom', 'HandleVisibility', 'off'); % 添加标注
end

% 设置图形属性
xlabel('h');
ylabel('R');
title('R-h');
legend('show');
grid on;
hold off;
