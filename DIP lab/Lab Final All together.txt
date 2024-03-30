%MATLAB code for dilation,erosion,opening and closing of image
clc;
clear all;
close all;

f=(imread('image1.jpg'));
%f = rgb2gray(f);
subplot(2,3,1);
imshow(f);
title('Original image');

%initialization
[rows, cols] = size(f);
minFilteredImg = zeros(rows, cols);
maxFilteredImg = zeros(rows, cols);
medianFilteredImg = zeros(rows, cols);
averagedImg= zeros(rows, cols);
gaussianFilteredImg = zeros(rows, cols);
filterSize = 3;
floorFilter = floor(filterSize/2); %if filterSize= 3, floorFilter=1

%Gaussian Karnel Design
kernel_size = 3;
gausian_X=zeros(kernel_size,kernel_size);
gausian_Y=zeros(kernel_size,kernel_size);
r=-(kernel_size-1)/2;
for i=1:kernel_size
    gausian_X(1:kernel_size, i:i)=r;
    r=r+1 ;
end
r=-(kernel_size-1)/2;
for i=1:kernel_size
    gausian_Y(i:i,1:kernel_size)=r;
    r=r+1 ;
end
sigma=3;

% ker = ( 1/ (2*pi*Sig^2) ) * ((Gx^2/Gy^2) / (2*Sig^2))^exp
ker=-(power(gausian_X,2)+power(gausian_Y,2)) /(2*power(sigma,2));
ker=exp(ker);
ker=(1.0/(2*pi*power(sigma,2)))*ker;
ker= double(ker);


for i = 1:rows
    for j = 1:cols
        %get the neighbourhood of the image to apply filters
        neighborhood = f( max(1, i- floorFilter) : min(rows, i+ floorFilter), ...
                                 max(1, j- floorFilter):min(cols, j+ floorFilter));
        % Min filter: Computes the minimum value in the local neighborhood
        minFilteredImg(i, j) = min(neighborhood(:));
        % Max filter: Computes the maximum value in the local neighborhood
        maxFilteredImg(i, j) = max(neighborhood(:));
        % Median filter: Computes the median value in the local neighborhood
        medianFilteredImg(i, j) = median(neighborhood(:));
        % Average filter: Computes the average value in the local neighborhood
        averagedImg(i, j) = mean(neighborhood(:));
        % Gaussian filter: Applies a Gaussian smoothing filter
        % Convolution
        neighborhood = double(neighborhood);
        gaussianFilteredImg(i, j) = sum( ker(:) .* neighborhood(:) );
    end
end
% Laplacian filter: Enhances edges by highlighting intensity changes
laplacianFilter = [0 -1 0; -1 4 -1; 0 -1 0];
laplacianFilteredImg = conv2(f, laplacianFilter, 'same');

% Sobel filter: Computes the gradient magnitude to highlight edges
sobelFilterX = [-1 0 1; -2 0 2; -1 0 1];
sobelFilterY = [-1 -2 -1; 0 0 0; 1 2 1];

[rows, cols] = size(f);
gradientX = zeros(rows, cols);
gradientY = zeros(rows, cols);

% Convolution with Sobel filters
for i = 2:rows-1
    for j = 2:cols-1
        neighborhoodX = inputImg(i-1:i+1, j-1:j+1);
        neighborhoodY = inputImg(i-1:i+1, j-1:j+1);
        gradientX(i, j) = sum(neighborhoodX(:) .* sobelFilterX(:));
        gradientY(i, j) = sum(neighborhoodY(:) .* sobelFilterY(:));
    end
end
% Compute gradient magnitude
sobelFilteredImg = sqrt(gradientX.^2 + gradientY.^2);

% Salt and Pepper Noise: Adds salt and pepper noise to the image
[rows, cols] = size(f);
noisyImg = f;

% Generate random indices for salt and pepper
saltIndices = rand(rows, cols) < saltProb;
pepperIndices = rand(rows, cols) < pepperProb;

% Add salt noise
noisyImg(saltIndices) = 255;

% Add pepper noise
noisyImg(pepperIndices) = 0;

f = imbinarize(f);
subplot(2,3,2);
imshow(minFilteredImg);
title('MinFiltered image');

% 5th lecture
[x,y]=size(f);
p=zeros(x,y);
p2=zeros(x,y);
p12=zeros(x,y);
p13=zeros(x,y);

%Dilation
w=[1 1 1; 1 1 1; 1 1 1];
for s=2:x-1
    for t=2:y-1
        w1=[f(s-1,t-1)*w(1,1) f(s-1,t)*w(1,2) f(s-1,t+1)*w(1,3) f(s,t-1)*w(2,1) f(s,t)*w(2,2) f(s,t+1)*w(2,3) f(s+1,t-1)*w(3,1) f(s+1,t)*w(3,2) f(s+1,t+1)*w(3,3)];
        p(s,t)=max(w1);
    end
end
subplot(2,3,3);
imshow(p);
title('Dilated image');

%erosion
w=[1 1 1; 1 1 1; 1 1 1];
for s=2:x-1
    for t=2:y-1
        w12=[f(s-1,t-1)*w(1) f(s-1,t)*w(2) f(s-1,t+1)*w(3) f(s,t-1)*w(4) f(s,t)*w(5) f(s,t+1)*w(6) f(s+1,t-1)*w(7) f(s+1,t)*w(8) f(s+1,t+1)*w(9)];
        p2(s,t)=min(w12);
    end
end
subplot(2,3,4);
imshow(p2);
title('Eroded image');

%Opening of image
[m,n]=size(p2);
w=[1 1 1; 1 1 1; 1 1 1];
for s=2:m-1
    for t=2:n-1
        w13=[p2(s-1,t-1)*w(1) p2(s-1,t)*w(2) p2(s-1,t+1)*w(3) p2(s,t-1)*w(4) p2(s,t)*w(5) p2(s,t+1)*w(6) p2(s+1,t-1)*w(7) p2(s+1,t)*w(8) p2(s+1,t+1)*w(9)];
        p12(s,t)=max(w13);
    end
end
subplot(2,3,5);
imshow(p12);
title('opening of image');

%Closing of image

[r,c]=size(p);
w=[1 1 1; 1 1 1; 1 1 1];
for s=2:r-1
    for t=2:c-1
        w14=[p(s-1,t-1)*w(1) p(s-1,t)*w(2) p(s-1,t+1)*w(3) p(s,t-1)*w(4) p(s,t)*w(5) p(s,t+1)*w(6) p(s+1,t-1)*w(7) p(s+1,t)*w(8) p(s+1,t+1)*w(9)];
        p13(s,t)=min(w14);
    end
end
subplot(2,3,6);
imshow(p13);
title('Closing of image');




