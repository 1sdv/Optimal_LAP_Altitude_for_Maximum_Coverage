% 给定参数
h_TX = 4000; %LAP高度为0-4公里
h_RX = 0;

% 定义参数组合
parameter_sets = [
    struct('name', 'Suburban', 'alpha', 0.1, 'beta', 0.000750, 'gamma',8),
    struct('name', 'Urban', 'alpha', 0.3, 'beta', 0.000500, 'gamma', 15),
    struct('name', 'Dense Urban', 'alpha', 0.5, 'beta', 0.000300, 'gamma', 20),
    struct('name', 'Highrise Urban', 'alpha', 0.5, 'beta', 0.000300, 'gamma', 50)
];

% 绘制图像
figure;
hold on;

for set_idx = 1:size(parameter_sets, 1)
    name = parameter_sets(set_idx).name;
    alpha = parameter_sets(set_idx).alpha;
    beta = parameter_sets(set_idx).beta;
    gamma = parameter_sets(set_idx).gamma;

    % 计算 m 和 r
    theta = deg2rad(1:1:89);%%%
   
    r = h_TX ./ tan(theta);%%￥￥tan(theta)的值
    
    m = floor(r * sqrt(alpha * beta) - 1);

    % 计算 P(LoS) 对于不同的角度
    P_LoS = zeros(size(r));

    for i = 1:length(r)
        P_LoS(i) = prod(1 - exp(-(h_TX - ((0:m(i)) + 0.5) * (h_TX - h_RX) / (m(i) + 1)).^2 / (2 * gamma^2)));
    end

    % 绘制当前参数组合的图像
    plot(rad2deg(theta), P_LoS, 'LineWidth', 2, 'DisplayName', name);
end

hold off;
xlabel('\theta (degrees)');
ylabel('P(LoS)');
title('Probability of Line of Sight (LoS) vs. Angle \theta');
legend('show');
grid on;
