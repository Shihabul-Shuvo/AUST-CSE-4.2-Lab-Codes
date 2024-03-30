% Read the image
img = imread('cameraman.png');

% Get total number of pixels
total_pixels = numel(img);

% Initialize arrays
intensity_counts = zeros(1, 256);
pdf = zeros(1, 256);
cdf = zeros(1, 256);

% Count pixels for each intensity level
for i = 1:size(img, 1)
    for j = 1:size(img, 2)
        intensity = img(i, j) + 1;
        intensity_counts(intensity) = intensity_counts(intensity) + 1;
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

% Equalize the image
equalized_img = zeros(size(img));
for i = 1:size(img, 1)
    for j = 1:size(img, 2)
        original_intensity = img(i, j) + 1;
        new_intensity = round((255 - 1) * cdf(original_intensity));
        equalized_img(i, j) = new_intensity - 1;
    end
end

% Display original and equalized images
subplot(2, 2, 1);
imshow(img);
title('Original Image');

subplot(2, 2, 2);
imshow(equalized_img);
title('Equalized Image');

% Generate and display original histogram
[original_counts, original_bins] = imhist(img);
subplot(2, 2, 3);
bar(original_bins, original_counts);
title('Original Histogram');

% Generate and display equalized histogram
[equalized_counts, equalized_bins] = imhist(equalized_img);
subplot(2, 2, 4);
bar(equalized_bins, equalized_counts);
title('Equalized Histogram');

title('Image Equalization');