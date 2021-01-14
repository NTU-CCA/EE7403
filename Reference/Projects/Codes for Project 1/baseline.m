% A very simple baseline Matlab program for retinal vessel detection/ segmentation coded by Jiang Xudong
x = imread('29_test.tif'); %load the color image
figure(1); imshow(x); %display the color image
% figure(2); imshow(x(:,:,1)); %display one channel the color image
% figure(3); imshow(x(:,:,2)); %display one channel the color image
% figure(4); imshow(x(:,:,3)); %display one channel the color image
% xs = rgb2gray(x); %convert the color image into gray image
% figure(5); imshow(xs);
xg = x(:,:,2); %decide to work on green channel image
%xg=rgb2gray(x);


figure(5); imshow(xg);
%Segment the image area
xt = xg;
m1 = mean(mean(xt));
xt(find(xt>m1)) = m1;
%figure(6); imshow(xt, []);
m2 = mean(mean(xt));
xt(find(xt>m2)) = m2;
%figure(7); imshow(xt, []);
m3 = mean(mean(xt));
xt(find(xt<m3)) = 0;
xt(find(xt>=m3)) = 1;
figure(8); imshow(xt, []);
imshow(xt*255)
n = sum(sum(xt));

%Segment the vessel
xin = xg.*xt;
xout = xin;
m1 = sum(sum(xout))/n;
xout(find(xout>m1)) = m1;
m2 = sum(sum(xout))/n;
xout(find(xout>m2)) = m2;
m3 = sum(sum(xout))/n;
xout(find(xout>m3)) = 0;
xout(find(xout>0)) = 255;
figure(9); imshow(xout, []);
imwrite(xout,'29_trainingmap.tif','tiff')

%load the vessel ground truth
%truth = imread('24_manual1.gif');
%figure(10); imshow(truth, []);
%Evaluate the segmentation accuracy
%[h,w] = size(xout);
%tst = zeros(h,w);
%tst(find(xout==truth))=1;
%figure(11); imshow(tst, []);
%accuracy = 100*sum(sum(tst))/(h*w)