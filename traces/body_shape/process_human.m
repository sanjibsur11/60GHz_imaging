close all;
clear all;
clc;

absorber = csvread('rss_heatmap_absorber.dat');

figure(1);
colormap('Hot');
imagesc(absorber);
caxis([0 1]);

head = csvread('rss_heatmap_head.dat');

figure(2);
colormap('Hot');
imagesc(head);
caxis([0 1]);

hand = csvread('rss_heatmap_hand.dat');

figure(3);
colormap('Hot');
imagesc(hand);

body = csvread('rss_heatmap_body.dat');

figure(4);
colormap('Hot');
imagesc(interp2(body, 4));
