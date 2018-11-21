% Calculates the line integral of a image, given its center and radius
function [I] = integral(input_image, center, radius, op)

% Number of points
n = 600;

% Number of angles
theta = (2 * pi) / n;

% Rows and columns
r = size(input_image, 1);
c = size(input_image, 2);

% Actual angle
angle = theta:theta:2*pi;

% Position indexes
x = center(1) - radius * sin(angle);
y = center(2) + radius * cos(angle);

% If L = 0, it means that the circle does not fit the image
if (any(x >= r) | any(y >= c) | any(x <= 1) | any(y <= 1))
    I = 0;
    return
end

% Here is the actual computing for the line integral
% We need to check if 'op' is for iris
if(strcmp(op, 'iris') == 1)
    s = 0;
    for i = 1:round((n / 8))
        sum = input_image(round(x(i)), round(y(i)));
        s = s + sum;
    end
    for i = (round(3 * n / 8)) + 1:round((5 * n / 8))
        sum = input_image(round(x(i)), round(y(i)));
        s = s + sum;
    end
    for i = round((7 * n / 8)) + 1:(n)
        sum = input_image(round(x(i)), round(y(i)));
        s = s + sum;
    end
    I = (2 * s) / n;
end

% Or, if 'op' is for the pupil
if (strcmp(op, 'pupil') == 1)
    s = 0;
    for i = 1:n
        sum = input_image(round(x(i)), round(y(i)));
        s = s + sum;
    end
    I = s / n;
end