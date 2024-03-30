% Compute no. of pixels for each gray level intensity
I=imread('cameraman.png');

[r1,c1] = size(I);
total_pixels = r1*c1;

% Initialize arrays
intensity_counts = zeros(1, 256);
pdf = zeros(1, 256);
cdf = zeros(1, 256);

% Compute no. of pixels for each gray level intensity
for i=1:r1
    for j=1:c1
        temp = I(i,j)+1;
        intensity_counts(temp) = intensity_counts(temp)+1;
    end
end

% Compute Probability Distribution Function (PDF)
for i = 1:256
    pdf(i) = intensity_counts(i) / total_pixels;
end

% Compute Cumulative Distribution Function (CDF)
cdf(1) = pdf(1);
for i = 2:256
    cdf(i) = cdf(i - 1) + pdf(i);
end

%Multiply each CDF by L-1
cdf_l = cdf*255;

% Round CDF
cdf_round = round(cdf_l);

% Equalize the image
equalized_img = uint8(zeros(size(I)));
for i =1:row
    for j =1:col
        temp= I(i,j)+1;
        equalized_img(i,j) = cdf_round(temp);
    end
end

% Display original and equalized images
figure;
subplot(2,2,1);
imshow(I);
title('Original Image');

subplot(2,2,3);
imshow(equalized_img);
title('Equalized Image');

% Display original histogram and equalized images histogram
subplot(2,2,2);
bar(X);
title('Original Histogram');
xlabel('Intensity Level');
ylabel('Frequency');


subplot(2,2,4);
bar(img_new);
title('Equalized Histogram');
xlabel('Intensity Level');
ylabel('Frequency');

title('Image Equalization');



