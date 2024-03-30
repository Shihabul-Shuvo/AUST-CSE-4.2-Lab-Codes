input_image = imread('image1.jpg');

laplacianfilteredImage = applyLaplacianFilter(input_image);
laplacianEnhancedImage = double(input_image) - laplacianfilteredImage;
sobelFilteredImage = applySobelFilter(input_image);

averageMaskSize = 5;
averagedImage = applyAverageFilter(sobelFilteredImage, averageMaskSize);

productOfImages = double(laplacianEnhancedImage) .* double(averagedImage);

sumOfImages = double(input_image) + double(productOfImages);

gamma = 0.5;
c=1;
powerTransformedImage = c * double(input_image).^gamma;

% Display images
subplot(2, 4, 1);
imshow(input_image);
title('Figure a');

subplot(2, 4, 2);
imshow(laplacianfilteredImage, []);
title('Figure b');

subplot(2, 4, 3);
imshow(laplacianEnhancedImage, []);
title('Figure c');

subplot(2, 4, 4);
imshow(sobelFilteredImage, []);
title('Figure d');

subplot(2, 4, 5);
imshow(averagedImage, []);
title('Figure e');

subplot(2, 4, 6);
imshow(productOfImages, []);
title('Figure f');

subplot(2, 4, 7);
imshow(sumOfImages, []);
title('Figure g');

subplot(2, 4, 8);
imshow(powerTransformedImage, []);
title('Figure h');

%Implemented funcitons 
function laplacianfilteredImage = applyLaplacianFilter(filterImage)
    [rows, cols, ~] = size(filterImage);
    laplacianFilter = [0 1 0; 1 -4 1; 0 1 0];
    filterImage = double(filterImage);
    laplacianfilteredImage = zeros(rows, cols);

    for i = 2:rows-1
        for j = 2:cols-1
            neighborhood = filterImage(i-1:i+1, j-1:j+1);
            laplacianfilteredImage(i, j) = sum(sum(neighborhood .* laplacianFilter));
        end
    end
end

function sobelFilteredImage = applySobelFilter(inputImage)
    sobelFilterX = [-1 0 1; -2 0 2; -1 0 1];
    sobelFilterY = [-1 -2 -1; 0 0 0; 1 2 1];

    gradientX = imfilter(double(inputImage), sobelFilterX);
    gradientY = imfilter(double(inputImage), sobelFilterY);
    sobelFilteredImage = sqrt(gradientX.^2 + gradientY.^2);
end

function averagedImage = applyAverageFilter(inputImage, n)
    averageFilterMask = ones(n) / n^2;
    averagedImage = imfilter(double(inputImage), averageFilterMask);
end


