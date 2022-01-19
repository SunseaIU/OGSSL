function [X,X_l,Y_l,X_u,Y_u,Y_index] = process_4(X_src,Y_src,X_tar,Y_tar)
% =========================================================================
% process_4 is the fourth process method
% the data is processed as follows:
% 1: de_means respectively
%
% Input:
% X_src: l*d source data feature
% Y_src: l*1 source data label
% X_tar: u*d target data feature
% Y_tar: u*1 target data label
%
% Output:
% X: n*d processed data feature
% X_l: l*d processed source data feature
% Y_l: l*c processed source data label
% X_u: u*d processed target data feature
% Y_u: u*c processed target data label
% Y_index: the index of sort data
% =========================================================================

% Y: 0,1,2,3 to 1,2,3,4
% sort data respectively
Y_src = Y_src + 1;
[Y_sort,index] = sort(Y_src);
X_sort = X_src(index,:);
X_src = X_sort;
Y_src = Y_sort;
[n_l,~] = size(X_src);

Y_tar = Y_tar + 1;
[Y_sort,index] = sort(Y_tar);
X_sort = X_tar(index,:);
X_tar = X_sort;
Y_tar = Y_sort;
[n_u,~] = size(X_tar);

% de_means respectively
X_src = X_src - repmat(mean(X_src,1),[n_l,1]);
X_tar = X_tar - repmat(mean(X_tar,1),[n_u,1]);
X = [X_src;X_tar];

X_l = X_src;
X_u = X_tar;
Y_l = Y_src;
Y_u = Y_tar;

Y = [Y_l;Y_u];
[~,Y_index] = sort(Y);

% Y: n*1 to n*c
Y_l = LabelConvert(Y_l);