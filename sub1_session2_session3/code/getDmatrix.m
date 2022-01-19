function [D] = getDmatrix(X)
% =========================================================================
% calculate the distance matrix
% d_ij = || x_i - x_j ||_2^2
% =========================================================================
D = pdist2(X,X,'squaredeuclidean');
