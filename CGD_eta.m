function [A, out_beta] = CGD(W, I, para)

alpha = para.beta/(para.mu + sum(para.beta));
D = cellfun(@(x)( 1./sqrt(sum(x, 2)) ), W, 'UniformOutput', false);
D = cellfun(@(x)( x*x' ), D, 'UniformOutput', false);
[X, Y, V] = cellfun(@(x)(find(x)), W, 'UniformOutput', false);


S = cellfun(@(x,y)(x.*y), W, D, 'UniformOutput', false);

eta=ones(1,length(W))/length(W);

A = I;
A_eta=zeros(size(I));
A_eta = single(A_eta);
A_tmp = zeros([size(I), length(W)], 'like', A);
for ii = 1:para.max_iter_alternating
    % update A by diffusion
    tmp = zeros(para.max_iter_diffusion, 1, 'single');
    for iter = 1:para.max_iter_diffusion
        %         tic;
        for v = 1:length(W)
            A_tmp(:, :, v) = alpha(v)*(S{v}*A*S{v}');
        end
        %         toc;
        A_U=sum(A_tmp,3);
     
     for v = 1:length(W)
        US = A_U - A_tmp(:, :, v);
        distUS = norm(US, 'fro')^2;
        if distUS == 0
            distUS = eps;
        end;
        eta(v) = 0.5/sqrt(distUS);
     end;
     
     total=sum(eta);
     for v = 1:length(W)
         
       eta(v)=eta(v)/total*0.1*length(W)+0.9;%0.1,0.9
     end;
        
     for v = 1:length(W)
       A_eta=A_tmp(:, :, v)*eta(v)+A_eta;
     end;
        A_new = A_eta + (1-sum(alpha))*I;
    %    A_new = sum(A_tmp, 3) + (1-sum(alpha))*I;
        A = A_new;
    end
    % update beta
    H = zeros(length(W), 1, 'single');
    for v = 1:length(W)
        H(v) = bs_compute_H(A, D{v}, X{v}, Y{v}, V{v});
    end
    para.lambda = 19;
    para.beta = coordinate_descent_beta(para.beta, H, para.lambda);
    alpha = para.beta/(para.mu + sum(para.beta));
end
A = single(A);
out_beta = para.beta;
end

function beta_new = coordinate_descent_beta(beta, H, lambda)
beta_new = beta;
for iter = 1:20
    for ii = 1:length(beta)
        for jj = ii+1:length(beta)
            beta_new(ii) = ( beta(ii)+beta(jj) )/2 + 0.5*( H(jj)-H(ii) )/lambda;
            beta_new(jj) = beta(ii)+beta(jj)-beta_new(ii);
            if beta_new(ii) < 0
                beta_new(ii) = 0;
                beta_new(jj) = beta(ii)+beta(jj);
            end
            if beta_new(jj) < 0
                beta_new(jj) = 0;
                beta_new(ii) = beta(ii)+beta(jj);
            end
            beta = beta_new;
        end
    end
end
end