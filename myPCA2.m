clc
clear
close all

rng(1);

%% data

data_X1 = normrnd(2,0.1,[50,1]);
data_X2 = normrnd(-2,0.1,[50,1]);
data_Y1 = normrnd(2,0.7,[50,1]);
data_Y2 = normrnd(-2,0.7,[50,1]);

data1 = [data_X1 data_Y1];
data2 = [data_X2 data_Y2];

data = [data1; data2];

theta = -20; % rotate angle
R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];

data = data * R;

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

zero_mean_data1 = data1 - mean(data);
zero_mean_data2 = data2 - mean(data);

X_PCA1 = zero_mean_data1 * eVec;
X_PCA2 = zero_mean_data2 * eVec;

X_hat1 = X_PCA1 * eVec;
X_hat2 = X_PCA2 * eVec;

axis_data = [0 1
         1 0];
PCA_axis = axis_data * eVec;

disp(array2table(data_cov,'VariableNames',{'eig1','eig2'}));
disp(head(array2table([data zero_mean_data X_PCA X_hat],'VariableNames',{'X1','X2','zero_mean_X1','zero_mean_X2','X_PCA1','X_PCA2','X_hat1','X_hat2'})));


figure(1);
clf;

subplot(2,2,1);
hold on;
plot(zero_mean_data1(:,2),zero_mean_data1(:,1),'or');
plot(zero_mean_data2(:,2),zero_mean_data2(:,1),'og');
infiniLine([0 0], [0 1], 'Color', [1 0 0 1], 'LineWidth', 2);
infiniLine([0 0], [1 0], 'Color', [0 0 1 1], 'LineWidth', 2);
axis equal
grid minor;
title('zero mean data (X)')

subplot(2,2,2);
hold on;
plot(zero_mean_data1(:,2),zero_mean_data1(:,1),'or');
plot(zero_mean_data2(:,2),zero_mean_data2(:,1),'og');
infiniLine([0 0], PCA_axis(:,1)', 'Color', [1 0 0 1], 'LineWidth', 2);
infiniLine([0 0], PCA_axis(:,2)', 'Color', [0 0 1 1], 'LineWidth', 2);
axis equal
grid minor;
title('PCA axis')

subplot(2,2,3);
hold on;
plot(X_PCA1(:,2),X_PCA1(:,1),'or');
plot(X_PCA2(:,2),X_PCA2(:,1),'og');
infiniLine([0 0], [0 1], 'Color', [1 0 0 1], 'LineWidth', 2);
infiniLine([0 0], [1 0], 'Color', [0 0 1 1], 'LineWidth', 2);
axis equal
grid minor;
title('PCA data')

subplot(2,2,4);
hold on;
plot(X_hat1(:,2),X_hat1(:,1),'or');
plot(X_hat2(:,2),X_hat2(:,1),'og');
infiniLine([0 0], [0 1], 'Color', [1 0 0 1], 'LineWidth', 2);
infiniLine([0 0], [1 0], 'Color', [0 0 1 1], 'LineWidth', 2);
axis equal
grid minor;
title(sprintf('X-hat, rmse:%.2e',rmse))