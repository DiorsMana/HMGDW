function d = cosine_distance(a, b)
% a, b: two matrices. Each column is a data vector
% d: distance matrix of a and b

if (size(a, 1) == 1)
    a = [a; zeros(1, size(a, 2))];
    b = [b; zeros(1, size(b, 2))];
end

norm_a = sqrt(sum(a.*a));
norm_b = sqrt(sum(b.*b));
dot_product = a' * b;
d = 1 - (dot_product ./ (norm_a' * norm_b));

d = real(d);
d = max(d, 0);
d = d - diag(diag(d)); % Force 0 on the diagonal
