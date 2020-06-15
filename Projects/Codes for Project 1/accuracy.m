%load the vessel ground truth
truth = imread('Ground-truth.png');
xout = imread('VesselNet.png');
%figure(10); imshow(truth, []);
%Evaluate the segmentation accuracy
[h,w] = size(xout);
tst = zeros(h,w);
tst(find(xout==truth))=1;
figure(11); imshow(tst, []);

a = find(tst==1);
a;