a = '29_test.tif';
x = imread(a);   
c = rgb2gray(x);   %转为灰度图

%c = x(:,:,3); %decide to work on green channel image

a = im2double(c);  %归一化并转为双精度
%subplot(221); 
imhist(c);
title('图片的灰度图');
%subplot(222);
figure;
imshow(c,[]);  
title('原图');


k=0;
gray_all=0;                         %预设图像总灰度值为0
ICV_t=0; 

[M,N]=size(a);   
pixelall=M*N;             %      像素个数
  

for i=1:M
    for j=1:N
        gray_all = gray_all + a(i,j);
    end
end

ave = gray_all * 255 / pixelall;

% %t为某个阈值，把原图像分为A部分（每个像素值>=t）与B部分（每个像素值<t）
% for t=0:255                      
%     A=0;    
%     B=0;                     
%     NA=0;                 
%     NB=0;                   
%     for i=1:M                  %遍历原图像每个像素的灰度值
%         for j=1:N
%             if (a(i,j)*255>=t)    %分割出灰度值》=t的像素
%                 NA=NA+1;  %得到A部分总像素
%                 A=A+a(i,j);   %得到A部分总灰度值
%             elseif (a(i,j)*255<t) %分割出灰度值《t的像素
%                 NB=NB+1;  %得到B部分总像素
%                 B=B+a(i,j);   %得到B部分总灰度值
%             end
%         end
%     end
%     PA=NA/pixelall;            %得到A部分像素总数与图像总像素的比列
%     PB=NB/pixelall;            %得到B部分像素总数与图像总像素的比列
%     A_ave=A*255/NA;          %得到A部分总灰度值与A部分总像素的比例
%     B_ave=B*255/NB;          %得到B部分总灰度值与B部分总像素的比例
%     ICV=PA*((A_ave-ave)^2)+PB*((B_ave-ave)^2);  %Otsu算法
%     if (ICV>ICV_t)                     %不断判断，得到最大方差
%         ICV_t=ICV;
%         k=t;                           %得到最大方差的最优阈值
%     end
% end

% mask 眼球部位
mask = c;
for i=1:M   
    for j=1:N   
        if mask(i,j)>=29   
            mask(i,j)=1;   
        else   
            mask(i,j)=0;   
        end   
    end   
end



eyepixelall = sum(sum(mask));
mask_a = a.* double(mask);
eye_gray_all = sum(sum(mask_a));
eyeave = eye_gray_all * 255 / eyepixelall;


%t为某个阈值，把原图像分为A部分（每个像素值>=t）与B部分（每个像素值<t）
for t=0:255                      
    A=0;    
    B=0;                     
    NA=0;                 
    NB=0;                   
    for i=1:M                  %遍历原图像每个像素的灰度值
        for j=1:N
            if (mask(i,j) == 1) % only eye
                if (a(i,j)*255>=t)    %分割出灰度值》=t的像素
                    NA=NA+1;  %得到A部分总像素
                    A=A+a(i,j);   %得到A部分总灰度值
                elseif (a(i,j)*255<t) %分割出灰度值《t的像素
                    NB=NB+1;  %得到B部分总像素
                    B=B+a(i,j);   %得到B部分总灰度值
                end
            end
        end
    end
    PA=NA/eyepixelall;            %得到A部分像素总数与图像总像素的比列
    PB=NB/eyepixelall;            %得到B部分像素总数与图像总像素的比列
    A_ave=A*255/NA;          %得到A部分总灰度值与A部分总像素的比例
    B_ave=B*255/NB;          %得到B部分总灰度值与B部分总像素的比例
    ICV=PA*((A_ave-eyeave)^2)+PB*((B_ave-eyeave)^2);  %Otsu算法
    if (ICV>ICV_t)                     %不断判断，得到最大方差
        ICV_t=ICV;
        k=t;                           %得到最大方差的最优阈值
    end
end

figure;
c = c .* mask;
imhist(c);

%k = 75;
%k = 73; 
c(find(c > k)) = 0;
c(find(c > 0)) = 255;
c = c .* mask;

%subplot(223);
figure(9);
imshow(c,[]);

%title('我的OTSU');
%用matlab自带OTSU
%I=im2double(c);
%k1=graythresh(I);              %得到最优阈值
%J=im2bw(I,k1);                 %转换成二值图，k为分割阈值
%subplot(224);
%imshow(J);
%title('matlab自带OTSU');