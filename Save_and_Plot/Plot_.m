clear
clc
%% This script is for plotting only
% Load data
res1 = load('Result/result1.mat');
res2 = load('Result/result2.mat');
res3 = load('Result/result3.mat');
res4 = load('Result/result4.mat');
res5 = load('Result/result5.mat');
res6 = load('Result/result6.mat');
res7 = load('Result/result7.mat');
res8 = load('Result/result8.mat');
res9 = load('Result/result9.mat');
res10 = load('Result/result10.mat');

%% Plot
% plot(res1.tout, res1.Pos_N_S.Data(:,3))
% hold on
% plot(res2.tout, res2.Pos_N_S.Data(:,3))
% hold on
% plot(res3.tout, res3.Pos_N_S.Data(:,3))
% hold on
% plot(res4.tout, res4.Pos_N_S.Data(:,3))
% hold on
% plot(res5.tout, res5.Pos_N_S.Data(:,3))
% hold on
% plot(res6.tout, res6.Pos_N_S.Data(:,3))
% hold on
% plot(res7.tout, res7.Pos_N_S.Data(:,3))
% hold on
% plot(res8.tout, res8.Pos_N_S.Data(:,3))
% hold on
% plot(res9.tout, res9.Pos_N_S.Data(:,3))
% hold on
% plot(res10.tout, res10.Pos_N_S.Data(:,3))
% hold on

% plot(res1.tout, res1.Velo_B_S.Data(:,3))
% hold on
% plot(res2.tout, res2.Velo_B_S.Data(:,3))
% hold on
% plot(res3.tout, res3.Velo_B_S.Data(:,3))
% hold on
% plot(res4.tout, res4.Velo_B_S.Data(:,3))
% hold on
% plot(res5.tout, res5.Velo_B_S.Data(:,3))
% hold on
% plot(res6.tout, res6.Velo_B_S.Data(:,3))
% hold on
% plot(res7.tout, res7.Velo_B_S.Data(:,3))
% hold on
% plot(res8.tout, res8.Velo_B_S.Data(:,3))
% hold on
% plot(res9.tout, res9.Velo_B_S.Data(:,3))
% hold on
% plot(res10.tout, res10.Velo_B_S.Data(:,3))
% hold on

plot(res1.tout(1:1001), res1.Acc_B_S.Data(1:1001,3))
hold on
plot(res2.tout(1:1001), res2.Acc_B_S.Data(1:1001,3))
hold on
plot(res3.tout(1:1001), res3.Acc_B_S.Data(1:1001,3))
hold on
plot(res4.tout(1:1001), res4.Acc_B_S.Data(1:1001,3))
hold on
plot(res5.tout(1:1001), res5.Acc_B_S.Data(1:1001,3))
hold on
% plot(res6.tout, res6.Acc_B_S.Data(:,3))
% hold on
% plot(res7.tout, res7.Acc_B_S.Data(:,3))
% hold on
% plot(res8.tout, res8.Acc_B_S.Data(:,3))
% hold on
% plot(res9.tout, res9.Acc_B_S.Data(:,3))
% hold on
% plot(res10.tout, res10.Acc_B_S.Data(:,3))
% hold on


grid on
% legend('Test 1', 'Test 2', 'Test 3', 'Test 4', 'Test 5', 'Test 6', 'Test 7', 'Test 8', 'Test 9', 'Test 10')
legend('Test 1', 'Test 2', 'Test 3', 'Test 4', 'Test 5')
% legend('Test 6', 'Test 7', 'Test 8', 'Test 9', 'Test 10')
xlabel('Time [second]')
% ylabel('Water Depth [meter]')
% ylabel('Velocity [m/s]')
ylabel('Acceleration [m/s2]')
% title('Displacement plot for a submerged sphere')
% title('Velocity plot for a submerged sphere')
title('Acceleration plot for a submerged sphere')

