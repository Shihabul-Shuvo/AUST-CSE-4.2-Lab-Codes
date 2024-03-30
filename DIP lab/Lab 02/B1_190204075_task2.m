img = imread('input.jpg');
gray = rgb2gray(img);


[rows, cols] = size(gray);


bit_planes = zeros(rows, cols, 8);
for i = 1:8
    bit_planes(:, :, i) = bitshift(gray, -i + 8);
end

X = 2.^(0:7);

bit_plane_images = zeros(rows, cols, 8);
for i = 1:8
    bit_plane_images(:, :, i) = bitand(gray, X(i));
end

figure;
for i = 1:8
    subplot(2, 4, i);
    imshow(bit_plane_images(:, :, i));
    title(['Bit plane ', num2str(i)]);
end