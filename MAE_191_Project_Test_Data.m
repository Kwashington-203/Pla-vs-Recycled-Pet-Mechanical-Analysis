%% Stress-Strain Curves of Dogbone Samples (PLA vs PET)

clear; clc; close all;

% Get the folder where this script is located
projectFolder = fileparts(mfilename('fullpath'));

% Define images folder path
imagesFolder = fullfile(projectFolder, 'images');

% Create images folder if it doesn't exist
if ~exist(imagesFolder, 'dir')
    mkdir(imagesFolder);
end

%% PET Dogbone Test 1
data = readtable('pet_dogbone_test_1.csv');
Displacement = data.Var3; % mm
Force = data.Var4; % N

A0_PET = 8.24 * 4.08; % Initial cross-sectional area of the gauge of the dogbone (mm^2)
L0_PET = 131.58; % Initial length of the gauge of the dogbone (mm)

PET_Stress_1 = Force(3:85) ./ A0_PET; % Engineering Stress (MPa)
PET_Strain_1 = Displacement(3:85) ./ L0_PET; % Engineering Strain (mm/mm)

x1 = PET_Strain_1(:);
y1 = PET_Stress_1(:);

elastic_region_1 = x1 <= 0.001;
if sum(elastic_region_1) < 5
    elastic_region_1 = false(size(x1));
    elastic_region_1(1:min(5,length(x1))) = true;
end

p1 = polyfit(x1(elastic_region_1), y1(elastic_region_1), 1);
E1 = p1(1);
offset_line_1 = E1 * (x1 - 0.002) + p1(2);

diff_1 = y1 - offset_line_1;
yield_idx_1 = find(diff_1(1:end-1).*diff_1(2:end) <= 0, 1, 'first');
if isempty(yield_idx_1)
    [~, yield_idx_1] = min(abs(diff_1));
end

yield_strain_1 = x1(yield_idx_1);
yield_strength_1 = y1(yield_idx_1);

[UTS_1, UTS_idx_1] = max(y1);

fig = figure;
fig.Position = [100, 100, 1000, 700];

tiledlayout(2,1,'Padding','compact','TileSpacing','compact');

figure(1)
subplot(2,1,1)
hold on
plot(x1, y1, 'LineWidth', 1.5, 'Color', 'b')
plot(x1, offset_line_1, '--', 'LineWidth', 1.2, 'Color', 'k')
plot(yield_strain_1, yield_strength_1, 'o', 'LineWidth', 1.5, 'Color', 'r')
plot(x1(UTS_idx_1), UTS_1, 'x', 'LineWidth', 1.5, 'Color', 'r')
ylabel('Engineering Stress (MPa)')
title('PET Stress-Strain (Test 1)', 'FontSize', 14)
legend('Stress-Strain', '0.2% Offset Line', ...
    sprintf('Yield Strength: %.2f MPa', yield_strength_1), ...
    sprintf('Ultimate Tensile Strength: %.2f MPa', UTS_1), ...
    'Location', 'southeast')
grid on
hold off


%% PET Dogbone Test 2
data2 = readtable('pet_dogbone_test_2.csv');
Displacement2 = data2.Var3; % mm
Force2 = data2.Var4; % N

PET_Stress_2 = Force2(3:85) ./ A0_PET; % Engineering Stress (MPa)
PET_Strain_2 = Displacement2(3:85) ./ L0_PET; % Engineering Strain (mm/mm)

x2 = PET_Strain_2(:);
y2 = PET_Stress_2(:);

elastic_region_2 = x2 <= 0.002;
if sum(elastic_region_2) < 5
    elastic_region_2 = false(size(x2));
    elastic_region_2(1:min(5,length(x2))) = true;
end

p2 = polyfit(x2(elastic_region_2), y2(elastic_region_2), 1);
E2 = p2(1);
offset_line_2 = E2 * (x2 - 0.002) + p2(2);

diff_2 = y2 - offset_line_2;
yield_idx_2 = find(diff_2(1:end-1).*diff_2(2:end) <= 0, 1, 'first');
if isempty(yield_idx_2)
    [~, yield_idx_2] = min(abs(diff_2));
end

yield_strain_2 = x2(yield_idx_2);
yield_strength_2 = y2(yield_idx_2);

[UTS_2, UTS_idx_2] = max(y2);

subplot(2,1,2)
hold on
plot(x2, y2, 'LineWidth', 1.5, 'Color', 'b')
plot(x2, offset_line_2, '--', 'LineWidth', 1.2, 'Color', 'k')
plot(yield_strain_2, yield_strength_2, 'o', 'LineWidth', 1.5, 'Color', 'r')
plot(x2(UTS_idx_2), UTS_2, 'x', 'LineWidth', 1.5, 'Color', 'r')
xlabel('Engineering Strain (mm/mm)')
ylabel('Engineering Stress (MPa)')
title('PET Stress-Strain (Test 1)', 'FontSize', 14)
legend('Stress-Strain', '0.2% Offset Line', ...
    sprintf('Yield Strength: %.2f MPa', yield_strength_2), ...
    sprintf('Ultimate Tensile Strength: %.2f MPa', UTS_2), ...
    'Location', 'southeast')
grid on
hold off

exportgraphics(fig, fullfile(imagesFolder, 'PET_Stress_Strain.png'), 'Resolution', 300);
%% PLA Dogbone Test 1
data3 = readtable('pla_dogbone_test_1.csv');
Displacement3 = data3.Var3; % mm
Force3 = data3.Var4; % N

A0_PLA = 110 - (1 - 0.15)*20; % Initial cross-sectional area of the gauge of the dogbone (mm^2)
L0_PLA = 6 * 10; % Initial length of the gauge of the dogbone (mm)

PLA_Stress_1 = Force3(3:106) ./ A0_PLA; % Engineering Stress (MPa)
PLA_Strain_1 = Displacement3(3:106) ./ L0_PLA; % Engineering Strain (mm/mm)

x3 = PLA_Strain_1(:);
y3 = PLA_Stress_1(:);

elastic_region_3 = x3 <= 0.002;
if sum(elastic_region_3) < 5
    elastic_region_3 = false(size(x3));
    elastic_region_3(1:min(5,length(x3))) = true;
end

p3 = polyfit(x3(elastic_region_3), y3(elastic_region_3), 1);
E3 = p3(1);
offset_line_3 = E3 * (x3 - 0.002) + p3(2);

diff_3 = y3 - offset_line_3;
yield_idx_3 = find(diff_3(1:end-1).*diff_3(2:end) <= 0, 1, 'first');
if isempty(yield_idx_3)
    [~, yield_idx_3] = min(abs(diff_3));
end

yield_strain_3 = x3(yield_idx_3);
yield_strength_3 = y3(yield_idx_3);

[UTS_3, UTS_idx_3] = max(y3);

fig2 = figure;
fig2.Position = [100, 100, 1000, 700];

tiledlayout(2,1,'Padding','compact','TileSpacing','compact');

figure(2)
subplot(2,1,1)
hold on
plot(x3, y3, 'LineWidth', 1.5, 'Color', 'b')
plot(x3, offset_line_3, '--', 'LineWidth', 1.2, 'Color', 'k')
plot(yield_strain_3, yield_strength_3, 'o', 'LineWidth', 1.5, 'Color', 'r')
plot(x3(UTS_idx_3), UTS_3, 'x', 'LineWidth', 1.5, 'Color', 'r')
ylabel('Engineering Stress (MPa)')
title('PLA Stress-Strain (Test 1)', 'FontSize', 14)
legend('Stress-Strain', '0.2% Offset Line', ...
    sprintf('Yield Strength: %.2f MPa', yield_strength_3), ...
    sprintf('Ultimate Tensile Strength: %.2f MPa', UTS_3), ...
    'Location', 'southeast')
grid on
hold off


%% PLA Dogbone Test 2
data4 = readtable('pla_dogbone_test_2.csv');
Displacement4 = data4.Var3; % mm
Force4 = data4.Var4; % N

PLA_Stress_2 = Force4(3:72) ./ A0_PLA; % Engineering Stress (MPa)
PLA_Strain_2 = Displacement4(3:72) ./ L0_PLA; % Engineering Strain (mm/mm)

x4 = PLA_Strain_2(:);
y4 = PLA_Stress_2(:);

elastic_region_4 = x4 <= 0.002;
if sum(elastic_region_4) < 5
    elastic_region_4 = false(size(x4));
    elastic_region_4(1:min(5,length(x4))) = true;
end

p4 = polyfit(x4(elastic_region_4), y4(elastic_region_4), 1);
E4 = p4(1);
offset_line_4 = E4 * (x4 - 0.002) + p4(2);

diff_4 = y4 - offset_line_4;
yield_idx_4 = find(diff_4(1:end-1).*diff_4(2:end) <= 0, 1, 'first');
if isempty(yield_idx_4)
    [~, yield_idx_4] = min(abs(diff_4));
end

yield_strain_4 = x4(yield_idx_4);
yield_strength_4 = y4(yield_idx_4);

[UTS_4, UTS_idx_4] = max(y4);

subplot(2,1,2)
hold on
plot(x4, y4, 'LineWidth', 1.5, 'Color', 'b')
plot(x4, offset_line_4, '--', 'LineWidth', 1.2, 'Color', 'k')
plot(yield_strain_4, yield_strength_4, 'o', 'LineWidth', 1.5, 'Color', 'r')
plot(x4(UTS_idx_4), UTS_4, 'x', 'LineWidth', 1.5, 'Color', 'r')
xlabel('Engineering Strain (mm/mm)')
ylabel('Engineering Stress (MPa)')
title('PLA Stress-Strain (Test 2)', 'FontSize', 14)
legend('Stress-Strain', '0.2% Offset Line', ...
    sprintf('Yield Strength: %.2f MPa', yield_strength_4), ...
    sprintf('Ultimate Tensile Strength: %.2f MPa', UTS_4), ...
    'Location', 'southeast')
grid on
hold off

exportgraphics(fig2, fullfile(imagesFolder, 'PLA_Stress_Strain.png'), 'Resolution', 300);
