n_people = 1;
n_session = 1;
n_samples = 1;

for p = 1:n_people
    for q = 1:n_session
        for r = 1:n_samples
        % Reading input image
        s = strcat('UBIRIS/', num2str(p), '/', num2str(p), '_', num2str(q), '_', num2str(r), '.jpg');
        I = imread(s);

        % Converting to grayscale and applying double format
        I = rgb2gray(I);
        I = im2double(I);
        original_I = I;

        % Input varibles (minimum and maximum radius)
        min_radius = 25;
        max_radius = 50;

        % Filling all empty spaces to allow easily detection
        I = imcomplement(imfill(imcomplement(I), 'holes'));  

        % Thresholding image elements
        [radius c] = size(I);
        [x, y] = find(I < 0.5);

        % Delete all non local minimum pixels, in order to converge faster
        for k = 1:size(x, 1)
            if (x(k) > min_radius) & (y(k) > max_radius) & (x(k) <= (radius - min_radius)) & (y(k)<(c - min_radius))
                % Checking neighbourhood of current pixel
                V = I((x(k) - 1):(x(k) + 1), (y(k) - 1):(y(k) + 1));
                min_pixel = min(min(V));
                if I(x(k), y(k)) ~= min_pixel
                    x(k) = 0;
                    y(k) = 0;
                end
            end
        end

        % Delete all border pixels and resize the elements matrix
        k = find((x <= min_radius) | (y <= min_radius) | (x > (radius - min_radius)) | (y > (c - min_radius)));
        x(k) = [];
        y(k) = [];  
        n = size(x, 1);

        % Finding all partial derivatives
        for k = 1:n
            [b, radius, blur] = partial_derivative(I, [x(k), y(k)], min_radius, max_radius, 'iris');
            max_b(x(k), y(k)) = b;
        end
        [x,y] = find(max_b == max(max(max_b)));

        % Finding iris' center and its radius
        center_iris = find_center(I, min_radius, max_radius, x, y, 'iris');

        % Finding pupil's center and its radius
        center_pupil = find_center(I, round(0.1 * radius), round(0.8 * radius), center_iris(1), center_iris(2), 'pupil');

        % Normalizing iris region
        norm_I = normalize_iris(original_I, center_pupil, center_iris, 31, 180);
        
        % Creating iris code
        iris_code = iris_coding(norm_I, 0.5);
        
        % Showing iris code
        imshow(iris_code);
        end
    end
end