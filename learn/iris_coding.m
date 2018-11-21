% Calculates the iris code from an input image and a gabor filter
function [iris_code] = iris_coding(input_image, sigma)

% Convolving input image with gabor filter
[G] = gabor_filter(input_image, sigma);

% Initializing iris code
iris_code = zeros(size(input_image,1), size(input_image,2)*2);

% Phase quantization
G1 = real(G) > 0;
G2 = imag(G) > 0;

% Creating iris code
for i = 1:size(input_image,1)
    for j = 1:size(input_image,2)
        iris_code(i, 2 * j - 1) = G1(i, j);
        iris_code(i, 2 * j) = G2(i, j);
    end
end