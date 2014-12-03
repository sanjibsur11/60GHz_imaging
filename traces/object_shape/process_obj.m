close all;
clear all;
clc;

w_object = csvread('rss_heatmap_w_pccabinet.dat');
wo_object = csvread('rss_heatmap_wo_pccabinet.dat');

figure(1);
colormap('Hot');
imagesc(w_object);

% wo_object = (0.05*rand(1)+0.8)*w_object;
% 
% [row col] = size(w_object);
% for i = 1:row
%     for j = 1:col
%         if (i >= 25 && i <= 40) && (j >= 15 && j <= 30)
%             wo_object(i, j) = 0.01*rand(1);
%         end
%     end
% end
 
figure(2);
colormap('Hot');
imagesc(wo_object);

% figure(3);
% colormap('Hot');
% imagesc(interp2((w_object - wo_object), 0));
% 
% figure(4);
% colormap('Hot');
% imagesc(interp2((w_object - wo_object).^2, 2));

[row col] = size(w_object);
weight = zeros(size(w_object));
for i = 2:row-1
    for j = 2:col-1
        weight(i, j) = ((w_object(i, j) - wo_object(i, j)) + ...
            (w_object(i - 1, j) - wo_object(i - 1, j)) + ...
            (w_object(i + 1, j) - wo_object(i + 1, j)) + ...
            (w_object(i, j - 1) - wo_object(i, j - 1)) + ...
            (w_object(i, j + 1) - wo_object(i, j + 1)) + ...
            (w_object(i - 1, j - 1) - wo_object(i - 1, j - 1)) + ...
            (w_object(i - 1, j + 1) - wo_object(i - 1, j + 1)) + ...
            (w_object(i + 1, j - 1) - wo_object(i + 1, j - 1)) + ...
            (w_object(i + 1, j + 1) - wo_object(i + 1, j + 1)))/10;
    end
end

figure(5);
colormap('Hot');
imagesc(interp2((w_object - wo_object).*weight, 0));