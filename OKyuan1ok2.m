% 给定矩阵 C
C1 = [9.34e-1 2.30e-1 -2.25e-3 1.86e-5;
     1.97e-2 2.44e-3 6.58e-6 0;
    -1.24e-4 -3.34e-6 0 0;
     2.73e-7 0 0 0];

% 定义变化范围
alpha_beta_values = 50:5:250;
gamma_values = 0:5:50;

% 初始化结果矩阵
z_values1 = zeros(length(alpha_beta_values), length(gamma_values));

% 计算 z
for alpha_beta_index = 1:length(alpha_beta_values)
    for gamma_index = 1:length(gamma_values)
        alpha_beta = alpha_beta_values(alpha_beta_index);
        gamma = gamma_values(gamma_index);
        
        % 计算 z
        z_values1(alpha_beta_index, gamma_index) = sum(sum(C1 .* (alpha_beta).^((0:3)' * ones(1, 4)) .* gamma.^(0:3)));
    end
end

% 三维图像呈现
figure;
surf(gamma_values, alpha_beta_values, z_values1);
xlabel('\gamma');
ylabel('\alpha \beta');
zlabel('parameter a');
title('S 曲线参数 3D 拟合');
grid on;

% 在原图像上用点突出显示特定的点（浅蓝色）
hold on;

highlight_points_alpha_beta = 50:10:250;
highlight_points_gamma = 0:10:50;

[X, Y] = meshgrid(highlight_points_gamma, highlight_points_alpha_beta);
Z = interp2(gamma_values, alpha_beta_values, z_values1, X, Y);

scatter3(X(:), Y(:), Z(:), 'MarkerEdgeColor', [0.5 0.5 1], 'MarkerFaceColor', [0.5 0.5 1]);

hold off;
