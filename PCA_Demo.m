clear
clc

I = imread('peppers.png');
if size(I,3)>1
    I = rgb2gray(I);
end

I = double(I);
mean_I = mean(I);
adj_I = I - mean_I;

[coeff,score] = pca(adj_I);

SelFirstnPrincComp = 100;

reconst_I = score(:,1:SelFirstnPrincComp) * coeff(:,1:SelFirstnPrincComp)';
reconst_I=(reconst_I+mean_I);

figure(1);
subplot(1,2,1); imshow(I,[]); title(sprintf('There are totally %d principle components.', size(score,2)));
subplot(1,2,2); imshow(reconst_I,[]); title(sprintf('reconstruction with first %d principle components.',SelFirstnPrincComp));