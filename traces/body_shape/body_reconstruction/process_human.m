close all;
clear all;
clc;

absorber = csvread('rss_heatmap_absorber.dat');
% 
figure(1);
colormap('Hot');
imagesc(absorber);
caxis([0 1]);

head = csvread('rss_heatmap_head.dat');
% head = head(3:end-4, 6:end-1);
head = head(8:end, 6:end-1);
% head = head(1:end-8, 6:end-1);

figure(2);
colormap('Hot');
imagesc(interp2(head, 0));

hand = csvread('rss_heatmap_hand.dat');
hand = hand(1:20, :);

figure(3);
colormap('Hot');
imagesc(interp2(hand, 0));
caxis([0 1]);

body = csvread('rss_heatmap_body.dat');

% figure(4);
% colormap('Hot');
% imagesc(interp2(body, 0));

%% Concatenating and processing body parts
head = [absorber(1:size(head, 1), 1:8) head absorber(1:size(head, 1), end-7:end)];
head_body = [head; body];

w_full_human = csvread('rss_heatmap_w_human.dat');

seg = w_full_human(30:33, 39:50);
seg = [absorber(1:size(seg, 1), 1:11) seg absorber(1:size(seg, 1), end-1:end)];
head_body = [head_body; seg];
head_body(34:37, 11) = head_body(30:33, 12);

hand_seg = hand(10:18, 13:end-1);
seg = [absorber(1:15, 1:size(hand_seg, 2)); absorber(1:5, 1:size(hand_seg, 2)); hand_seg; absorber(end-7:end, 1:size(hand_seg, 2))];
head_body = [head_body seg];
seg = [absorber(1:15, 1:size(hand_seg, 2)); absorber(1:7, 1:size(hand_seg, 2)); hand_seg; absorber(end-5:end, 1:size(hand_seg, 2))];
head_body = [head_body seg];

hand_seg = fliplr(hand_seg);
seg = [absorber(1:15, 1:size(hand_seg, 2)); absorber(1:5, 1:size(hand_seg, 2)); hand_seg; absorber(end-7:end, 1:size(hand_seg, 2))];
head_body = [seg head_body];
seg = [absorber(1:15, 1:size(hand_seg, 2)); absorber(1:7, 1:size(hand_seg, 2)); hand_seg; absorber(end-5:end, 1:size(hand_seg, 2))];
head_body = [seg head_body];

head_body = [head_body(1:10, :); head_body(13:end, :)];
head_body = [[absorber(1:1, 1:15) absorber(1:1, 1:15) absorber(1:1, 1:3)]; head_body];

figure(5);
colormap('Hot');
imagesc(interp2(head_body, 0));
caxis([0 1]);