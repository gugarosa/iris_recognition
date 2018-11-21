% Finds the center points of a given image
% Note that we need some information prior to its use
% 'op' = 1 for iris and 'op' = 0 for pupil
function [center_points] = find_center(input_image, min_radius, max_radius, x, y, op)

% Rows and columns
r = size(input_image, 1);
c = size(input_image, 2);

% Radius
R = min_radius:max_radius;

% Maximum values of radius and blur
max_r = zeros(r, c);
max_b = zeros(r, c);

% Finding center points, depending on 'op' (iris or pupil)
for i = (x - 5):(x + 5)
    for j = (y - 5):(y + 5)
        [b, r, blur] = partial_derivative(input_image, [i, j], min_radius, max_radius, op);
        max_r(i, j) = r;
        max_b(i, j) = b;
    end
end

% Now, we output the results, the 'x' and 'y' of the center
% among with its radius
B = max(max(max_b));
[X, Y] = find(max_b == B);
radius = max_r(X, Y);
center_points = [X, Y, radius];     