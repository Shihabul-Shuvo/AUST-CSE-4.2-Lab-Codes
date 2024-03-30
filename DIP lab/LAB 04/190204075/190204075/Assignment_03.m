I=imread('input.jpg');
input_img = I;
I=imnoise(I,'Gaussian',0.04,0.003);

I=double(I);
[row,col]=size(I);
kernel_size=11;

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

r=(kernel_size-1)/2;
new_img=zeros(row+kernel_size-1, col+kernel_size-1);
new_img( r+1:row+r, r+1:col+r)=I(1:row,1:col);
[new_img_row, new_img_col]=size(new_img);
outputImage=zeros(row,col);

for i=1:new_img_row-kernel_size+1
    for j=1:new_img_col-kernel_size+1
       data= new_img(i:i+kernel_size-1, j:j+kernel_size-1 ).*ker;
       data=sum(data(:));
       outputImage(i, j)=data;
    end
end

outputImage=uint8(outputImage);
imwrite(outputImage, 'output.jpg');

subplot(1,2,1),imshow(input_img),title("Orginal Image");
subplot(1,2,2),imshow(outputImage),title("Gaussian Filtered Image");
