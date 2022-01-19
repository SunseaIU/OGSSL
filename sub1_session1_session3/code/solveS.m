function [S_out] = solveS(S,Y_index)
[n,~] = size(S);
S_out = zeros(n,n);
    for i = 1:n
        for j = 1:n
            S_out(i,j) = S(Y_index(i),Y_index(j));
        end
    end
end
