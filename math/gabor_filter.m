% Calculates the gabor filter of a given image
function [G] = gabor_filter(input_image, sigma)

% Initializing rows and columns
[r c] = size(input_image);		

% Filtering the data to even numbers
n_data = c;
if mod(n_data, 2) == 1
    n_data = n_data - 1;
end

% Variables needed to employ gabor's filter
log_gabor  = zeros(1, n_data);
final = zeros(r, n_data);

% Frequency radius [0, 0.5]
radius =  [0:fix(n_data / 2)] / fix(n_data / 2) / 2;
radius(1) = 1;

% Wave length size
wave_length = 8;

% Here, we actually build the filter
f_center = 1.0 / wave_length;
log_gabor(1:n_data / 2 + 1) = exp((-(log(radius / f_center)).^2) / (2 * log(sigma)^2));  
log_gabor(1) = 0;  
filter = log_gabor;
    
% Convoluting each row
for r = 1:r
    signal = input_image(r, 1:n_data);
    imagefft = fft(signal);
    final(r, :) = ifft(imagefft .* filter);
end
    
% Saving whole filter to returning variable
G = final;