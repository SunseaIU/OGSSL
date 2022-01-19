clear ;close all;clc;

% load data 
train_path = '../data/s1_session1.mat';
load(train_path);
X_src = fea;
Y_src = label;
clear fea label;
test_path = '../data/s1_session2.mat';
load(test_path);
X_tar = fea;
Y_tar = label;

% process data
% You can select process method by change 'process_param' to 1,2,3,4
% Default select the first process method
process_param = 1;
[X,X_l,Y_l,X_u,Y_u,Y_index] = process_data(X_src,Y_src,X_tar,Y_tar,process_param);

% main program
[Max_acc,Bestalpha,Bestbeta,Bestgamma,BestF_U,BestS,BestW,Y_predict,BestIter] = OGSSL(X,X_l,Y_l,X_u,Y_u,Y_index);

% save result
result_struct = struct('Bestalpha',Bestalpha,'Bestbeta',Bestbeta,'Bestgamma',Bestgamma,'BestF_U',BestF_U,'BestS',BestS,'BestW',BestW,'Y_predict',Y_predict,'BestIter',BestIter);
save_path = ['../result/process_',num2str(process_param)];
save(save_path,'Max_acc','result_struct')
