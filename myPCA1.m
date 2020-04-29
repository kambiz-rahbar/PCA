clc
clear
close all

%% data

data = [2.5 2.4
    0.5 0.7
    2.2 2.9
    1.9 2.2
    3.1 3
    2.3 2.7
    2 1.6
    1 1.1
    1.5 1.6
    1.1 0.9];

%% step 1: calculate zero mean data

zero_mean_data = data - mean(data);

%% calculate covariance of data

data_cov = cov(zero_mean_data);

%% calculate eigenvectors of data covariance

[~, ~, eVec] = eig(data_cov); % eVec columns are the eigenvectors 

%% calculate PCA data

X_PCA = zero_mean_data * eVec;

%% recover original data from PCA data

X_hat = X_PCA * eVec;

rmse = rms(zero_mean_data(:) - X_hat(:));

%% data tables & plot

axis_data = [0 1
         1 0];
PCA_axis = axis_data * eVec;

disp(array2table(data_cov,'VariableNames',{'eig1','eig2'}));
disp(head(array2table([data zero_mean_data X_PCA X_hat],'VariableNames',{'X1','X2','zero_mean_X1','zero_mean_X2','X_PCA1','X_PCA2','X_hat1','X_hat2'})));


figure(1);
clf;

subplot(2,2,1);
hold on;
plot(zero_mean_data(:,2),zero_mean_data(:,1),'ok');
infiniLine([0 0], [0 1], 'Color', [1 0 0 1], 'LineWidth', 2);
infiniLine([0 0], [1 0], 'Color', [0 0 1 1], 'LineWidth', 2);
axis equal
grid minor;
title('zero mean data (X)')

subplot(2,2,2);
hold on;
plot(zero_mean_data(:,2),zero_mean_data(:,1),'ok');
infiniLine([0 0], PCA_axis(:,1)', 'Color', [1 0 0 1], 'LineWidth', 2);
infiniLine([0 0], PCA_axis(:,2)', 'Color', [0 0 1 1], 'LineWidth', 2);
axis equal
grid minor;
title('PCA axis')

subplot(2,2,3);
hold on;
plot(X_PCA(:,2),X_PCA(:,1),'ok');
infiniLine([0 0], [0 1], 'Color', [1 0 0 1], 'LineWidth', 2);
infiniLine([0 0], [1 0], 'Color', [0 0 1 1], 'LineWidth', 2);
axis equal
grid minor;
title('PCA data')

subplot(2,2,4);
hold on;
plot(X_hat(:,2),X_hat(:,1),'ok');
infiniLine([0 0], [0 1], 'Color', [1 0 0 1], 'LineWidth', 2);
infiniLine([0 0], [1 0], 'Color', [0 0 1 1], 'LineWidth', 2);
axis equal
grid minor;
title(sprintf('X-hat, rmse:%.2e',rmse))