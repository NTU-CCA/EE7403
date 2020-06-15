a = '29_test.tif';
x = imread(a);   
c = rgb2gray(x);   %תΪ�Ҷ�ͼ

%c = x(:,:,3); %decide to work on green channel image

a = im2double(c);  %��һ����תΪ˫����
%subplot(221); 
imhist(c);
title('ͼƬ�ĻҶ�ͼ');
%subplot(222);
figure;
imshow(c,[]);  
title('ԭͼ');


k=0;
gray_all=0;                         %Ԥ��ͼ���ܻҶ�ֵΪ0
ICV_t=0; 

[M,N]=size(a);   
pixelall=M*N;             %      ���ظ���
  

for i=1:M
    for j=1:N
        gray_all = gray_all + a(i,j);
    end
end

ave = gray_all * 255 / pixelall;

% %tΪĳ����ֵ����ԭͼ���ΪA���֣�ÿ������ֵ>=t����B���֣�ÿ������ֵ<t��
% for t=0:255                      
%     A=0;    
%     B=0;                     
%     NA=0;                 
%     NB=0;                   
%     for i=1:M                  %����ԭͼ��ÿ�����صĻҶ�ֵ
%         for j=1:N
%             if (a(i,j)*255>=t)    %�ָ���Ҷ�ֵ��=t������
%                 NA=NA+1;  %�õ�A����������
%                 A=A+a(i,j);   %�õ�A�����ܻҶ�ֵ
%             elseif (a(i,j)*255<t) %�ָ���Ҷ�ֵ��t������
%                 NB=NB+1;  %�õ�B����������
%                 B=B+a(i,j);   %�õ�B�����ܻҶ�ֵ
%             end
%         end
%     end
%     PA=NA/pixelall;            %�õ�A��������������ͼ�������صı���
%     PB=NB/pixelall;            %�õ�B��������������ͼ�������صı���
%     A_ave=A*255/NA;          %�õ�A�����ܻҶ�ֵ��A���������صı���
%     B_ave=B*255/NB;          %�õ�B�����ܻҶ�ֵ��B���������صı���
%     ICV=PA*((A_ave-ave)^2)+PB*((B_ave-ave)^2);  %Otsu�㷨
%     if (ICV>ICV_t)                     %�����жϣ��õ���󷽲�
%         ICV_t=ICV;
%         k=t;                           %�õ���󷽲��������ֵ
%     end
% end

% mask ����λ
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


%tΪĳ����ֵ����ԭͼ���ΪA���֣�ÿ������ֵ>=t����B���֣�ÿ������ֵ<t��
for t=0:255                      
    A=0;    
    B=0;                     
    NA=0;                 
    NB=0;                   
    for i=1:M                  %����ԭͼ��ÿ�����صĻҶ�ֵ
        for j=1:N
            if (mask(i,j) == 1) % only eye
                if (a(i,j)*255>=t)    %�ָ���Ҷ�ֵ��=t������
                    NA=NA+1;  %�õ�A����������
                    A=A+a(i,j);   %�õ�A�����ܻҶ�ֵ
                elseif (a(i,j)*255<t) %�ָ���Ҷ�ֵ��t������
                    NB=NB+1;  %�õ�B����������
                    B=B+a(i,j);   %�õ�B�����ܻҶ�ֵ
                end
            end
        end
    end
    PA=NA/eyepixelall;            %�õ�A��������������ͼ�������صı���
    PB=NB/eyepixelall;            %�õ�B��������������ͼ�������صı���
    A_ave=A*255/NA;          %�õ�A�����ܻҶ�ֵ��A���������صı���
    B_ave=B*255/NB;          %�õ�B�����ܻҶ�ֵ��B���������صı���
    ICV=PA*((A_ave-eyeave)^2)+PB*((B_ave-eyeave)^2);  %Otsu�㷨
    if (ICV>ICV_t)                     %�����жϣ��õ���󷽲�
        ICV_t=ICV;
        k=t;                           %�õ���󷽲��������ֵ
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

%title('�ҵ�OTSU');
%��matlab�Դ�OTSU
%I=im2double(c);
%k1=graythresh(I);              %�õ�������ֵ
%J=im2bw(I,k1);                 %ת���ɶ�ֵͼ��kΪ�ָ���ֵ
%subplot(224);
%imshow(J);
%title('matlab�Դ�OTSU');