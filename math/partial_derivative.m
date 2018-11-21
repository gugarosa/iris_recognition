% Calculates the partial derivative of a given image
% Note that we need some information prior to its use
% 'op' = 1 for iris and 'op' = 0 for pupil
function [b, r, blur] = partial_derivative(input_image, center, min_radius, max_radius, op)

% We define R as the interval between minimum and maximum radius
R = min_radius:max_radius;

% Next, we gather its size
count = size(R, 2);

% Now, we compute the line integral for every step
for k = 1:count
    % Calling integral function
    [I(k)] = integral(input_image, center, R(k), op);
    % If it is zero, we apply an empty array
    if I(k) == 0
        I(k) = [];
    break;
    end
end

% Getting the actual derivative
D = diff(I);
D = [0 D];
f = ones(1, 7) / 7;

% We need to convolve it, so we can get the maximum blur
blur = convn(D, f, 'same');
blur = abs(blur);

% Storing variables for further return
[b, i] = max(blur);
r = R(i);
b = blur(i);