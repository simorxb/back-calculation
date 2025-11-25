%% Plot results
figure('Color', 'k');

% First subplot: Speed
ax1 = subplot(3,1,1);
hold on;
for i = 1:length(configs)
    plot(results(i).v.Time, results(i).v.Data, 'LineWidth', 2, 'DisplayName', configs{i}.name, "Color", configs{i}.color);
end
plot(results(1).r.Time, results(1).r.Data, '--', 'LineWidth', 2, 'DisplayName', 'Setpoint', "Color", "#D95319");
legend('TextColor', 'w', 'Color', 'k', 'EdgeColor', ...
    [0.5 0.5 0.5], 'LineWidth', 1, 'FontSize', 10, 'Location', 'best');
hold off;
grid on;
ylabel('Speed (m/s)');
ax1.Color = 'k';
ax1.GridColor = 'w';
ax1.GridAlpha = 0.3;
ax1.XColor = 'w';
ax1.YColor = 'w';

% Second subplot: Force (saturated)
ax2 = subplot(3,1,2);
hold on;
for i = 1:length(configs)
    plot(results(i).F.Time, results(i).F.Data, 'LineWidth', 2, 'DisplayName', configs{i}.name, "Color", configs{i}.color);
end
legend('TextColor', 'w', 'Color', 'k', 'EdgeColor', ...
    [0.5 0.5 0.5], 'LineWidth', 1, 'FontSize', 10, 'Location', 'best');
hold off;
grid on;
ylabel('Force (N)');
ax2.Color = 'k';
ax2.GridColor = 'w';
ax2.GridAlpha = 0.3;
ax2.XColor = 'w';
ax2.YColor = 'w';

% Third subplot: F_c (non-saturated force)
ax3 = subplot(3,1,3);
hold on;
for i = 1:length(configs)
    plot(results(i).F_c.Time, results(i).F_c.Data, 'LineWidth', 2, 'DisplayName', configs{i}.name, "Color", configs{i}.color);
end
legend('TextColor', 'w', 'Color', 'k', 'EdgeColor', ...
    [0.5 0.5 0.5], 'LineWidth', 1, 'FontSize', 10, 'Location', 'best');
hold off;
grid on;
ylabel('Non-saturated Force (N)');
xlabel('Time (s)');
ax3.Color = 'k';
ax3.GridColor = 'w';
ax3.GridAlpha = 0.3;
ax3.XColor = 'w';
ax3.YColor = 'w';

