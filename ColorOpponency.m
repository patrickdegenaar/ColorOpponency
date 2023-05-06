% clear everything
clc; clear; close all;

% read in image
colorImage = imread('Aodhan.png');

% resize image to working size;
colorImage = imresize(colorImage, [512 512]);

% separate the color channels;
redImage    = colorImage(:,:,1); %red
greenImage  = colorImage(:,:,2); %green
blueImage   = colorImage(:,:,3); %blue
yellowImage = (double(redImage) + double(greenImage))/2; % yellow

%--------------------------------------------------------------------------
% create gaussian Kernels
%--------------------------------------------------------------------------
bigGaussian     = gaussianGenerator(128, 64);   % initiate gaussian

kernelCentre    = imresize(bigGaussian, [7, 7]); %resize to centre kernel
kernelCentre    = kernelCentre/sum(sum(kernelCentre)); %Normalise

kernelSurround  = imresize(bigGaussian, [15, 15]); %resize to centre kernel
kernelSurround  = kernelSurround/sum(sum(kernelSurround)); %Normalise

% check Laplacian
kernelLaplacian = zeros(15);
kernelLaplacian(5:11,5:11) = kernelCentre;
kernelLaplacian = kernelLaplacian - kernelSurround;

%--------------------------------------------------------------------------
% create receptive fields
%--------------------------------------------------------------------------
redCentre       = conv2(redImage, kernelCentre, 'same');
redSurround     = conv2(redImage, kernelSurround, 'same');

greenCentre     = conv2(greenImage, kernelCentre, 'same');
greenSurround   = conv2(greenImage, kernelSurround, 'same');

blueCentre      = conv2(blueImage, kernelCentre, 'same');
yellowSurround  = conv2(yellowImage, kernelSurround, 'same');

%--------------------------------------------------------------------------
% create opponency
%--------------------------------------------------------------------------

redONCentre     = redCentre    - greenSurround;
redOFFCentre    = -redCentre   + greenSurround;
greenONCentre   = greenCentre  -  redSurround;
greenOFFCentre  = -greenCentre +  redSurround;
blueONCentre    = blueCentre   - yellowSurround;
blueOFFCentre   = -blueCentre  + yellowSurround;

%--------------------------------------------------------------------------
% threshold above zero
%--------------------------------------------------------------------------

redONCentre     = redONCentre .* double(redONCentre>0);
redOFFCentre    = redOFFCentre .* double(redOFFCentre>0);
greenONCentre   = greenONCentre .* double(greenONCentre>0);
greenOFFCentre  = greenOFFCentre .* double(greenOFFCentre>0);
blueONCentre    = blueONCentre .* double(blueONCentre>0);
blueOFFCentre   = blueOFFCentre .* double(blueOFFCentre>0);

%--------------------------------------------------------------------------
% convert to integer and equalise
%--------------------------------------------------------------------------

redONCentre     = uint8(redONCentre);
redOFFCentre    = uint8(redOFFCentre);
greenONCentre   = uint8(greenONCentre);
greenOFFCentre  = uint8(greenOFFCentre);
blueONCentre    = uint8(blueONCentre);
blueOFFCentre   = uint8(blueOFFCentre);

redONCentre     = redONCentre - min(min(redONCentre));
redOFFCentre    = redOFFCentre - min(min(redOFFCentre));
greenONCentre   = greenONCentre - min(min(greenONCentre));
greenOFFCentre  = greenOFFCentre - min(min(greenOFFCentre));
blueONCentre    = blueONCentre - min(min(blueONCentre));
blueOFFCentre   = blueOFFCentre - min(min(blueOFFCentre));

redONCentre     = double(redONCentre);
redOFFCentre    = double(redOFFCentre);
greenONCentre   = double(greenONCentre);
greenOFFCentre  = double(greenOFFCentre);
blueONCentre    = double(blueONCentre);
blueOFFCentre   = double(blueOFFCentre);

redONCentre     = uint8(redONCentre   *255/max(max(redONCentre)));
redOFFCentre    = uint8(redOFFCentre  *255/max(max(redOFFCentre)));
greenONCentre   = uint8(greenONCentre *255/max(max(greenONCentre)));
greenOFFCentre  = uint8(greenOFFCentre*255/max(max(greenOFFCentre)));
blueONCentre    = uint8(blueONCentre  *255/max(max(blueONCentre)));
blueOFFCentre   = uint8(blueOFFCentre *255/max(max(blueOFFCentre)));

%--------------------------------------------------------------------------
% Plot images
%--------------------------------------------------------------------------

% plot the original images
figure;
subplot(3,2,1)
imagesc(colorImage);
subplot(3,2,3)
imagesc(redImage); title('red'); colormap(gray);
subplot(3,2,4)
imagesc(greenImage); title('green'); colormap(gray);
subplot(3,2,5)
imagesc(blueImage); title('blue');colormap(gray);
subplot(3,2,6)
imagesc(yellowImage); title('yellow'); colormap(gray);

% Plot the kernels
figure; 
subplot(2,2,1);
imagesc(bigGaussian); title('big gaussian');
subplot(2,2,2);
imagesc(kernelCentre); title('kernelCentre');
subplot(2,2,3);
imagesc(kernelSurround); title('kernelSurround');
subplot(2,2,4);
imagesc(kernelLaplacian); title('kernelLaplacian');

% Plot the kernels
figure; 
subplot(2,3,1);
imagesc(redONCentre); title('redONCentre');colormap(gray);
subplot(2,3,2);
imagesc(redOFFCentre); title('redOFFCentre');colormap(gray);
subplot(2,3,3);
imagesc(greenONCentre); title('greenONCentre');colormap(gray);
subplot(2,3,4);
imagesc(greenOFFCentre); title('greenOFFCentre');colormap(gray);
subplot(2,3,5);
imagesc(blueONCentre); title('blueONCentre');colormap(gray);
subplot(2,3,6);
imagesc(blueOFFCentre); title('blueOFFCentre');colormap(gray);

%--------------------------------------------------------------------------
% Save images
%--------------------------------------------------------------------------

imwrite(redONCentre, 'redONCentre.jpg');
imwrite(redOFFCentre, 'redOFFCentre.jpg');
imwrite(greenONCentre, 'greenONCentre.jpg');
imwrite(greenOFFCentre, 'greenOFFCentre.jpg');
imwrite(blueONCentre, 'blueONCentre.jpg');
imwrite(blueOFFCentre, 'blueOFFCentre.jpg');
