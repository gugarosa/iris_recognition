% Normalizes the iris to polar coordinates
function norm_img = normalize_iris(img, pupil, iris, radius, angle)

% 'x', 'y' and radius for pupil
x_p = pupil(1);
y_p = pupil(2);
r_p = pupil(3);

% 'x', 'y' and radius for iris
x_i = iris(1);
y_i = iris(2);
r_i = iris(3);

% Radius and angle
rho = radius;
theta = angle;
    
% Creating samples
angles = (0:pi / theta:pi - pi / theta) + pi / (2 * theta);
r = 0:1 / rho:1;
n_angles = length(angles);
    
% Putting pupil and iris points into the same line
x1 = ones(size(angles)) * x_i;
y1 = ones(size(angles)) * y_i;
x2 = x_i + 10 * sin(angles);
y2 = y_i + 10 * cos(angles);

% Getting derivative and slopes
dx = x2 - x1;
dy = y2 - y1;
slope = dy ./ dx;
intercept = y_i - x_i .* slope;

% We iterate through all possible angles
xout = zeros(n_angles,2);
yout = zeros(n_angles,2);
for i = 1:n_angles
    [xout(i,:),yout(i,:)] = linecirc(slope(i), intercept(i), x_p, y_p, r_p);
end

% Creating boundaries
x_right_iris = y_i + r_i * cos(angles);
y_right_iris = x_i + r_i * sin(angles);
x_left_iris = y_i - r_i * cos(angles);
y_left_iris = x_i - r_i * sin(angles);

% Creating samples at the radius position
xrt = (1 - r)' * xout(:, 1)' + r' * y_right_iris;
yrt = (1 - r)' * yout(:, 1)' + r' * x_right_iris;
xlt = (1 - r)' * xout(:, 2)' + r' * y_left_iris;
ylt = (1 - r)' * yout(:, 2)' + r' * x_left_iris;
    
% Creating normalized iris image
norm_img = vec2mat(interp2(double(img), [yrt(:);ylt(:)], [xrt(:);xlt(:)]), length(r))'; 