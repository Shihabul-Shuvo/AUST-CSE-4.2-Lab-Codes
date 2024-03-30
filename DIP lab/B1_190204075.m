
image = imread('input.png');

[height, width, ~] = size(image);
image_flipped = zeros(size(image), 'uint8');
for i = 1:height
    image_flipped(i, :, :) = image(height - i + 1, :, :);
end

[height, ~, ~] = size(image_flipped);


new_height = 2* height;

% Create a new image to merge the two vertically mirrored images
merged_image = zeros(new_height, size(image, 2), size(image, 3), 'uint8');

% Copy image1 to the top part of the merged image
merged_image(1:height, :, :) = image;

% Copy vertically flipped image2 to the bottom part of the merged image
merged_image((height + 1):new_height, :, :) = image_flipped;

% Display the merged image
imshow(merged_image);
imwrite(merged_image,'output.png');
