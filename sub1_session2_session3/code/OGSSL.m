function [Max_acc,Bestalpha,Bestbeta,Bestgamma,BestF_U,BestS,BestW,Y_predict,BestIter] = SPGO(X,X_l,Y_l,X_u,Y_u,Y_index)
% =========================================================================
% SPGO implements the Algorithm 1
%
% Input:
% X: n*d is the all data, which include source data and target data.
% X_l: l*d is the labeled data feature
% Y_l: l*c is the labeled data ground truth
% X_u: u*d is the unlabeled data feature
% Y_u: u*c is the unlabeled data ground truth
%
% Output:
% Max_acc: is the accuracy of emotion recognition by use SPGO model.
% Bestalpha: is the value of parameter alpha at maximum accuracy.
% Bestbeta: is the value of parameter beta at maximum accuracy.
% Bestgamma: is the value of parameter gamma at maximum accuracy.
% BestF_U: is the prediction accuracy for each class  
% BestS: is the adjacency matrix of adaptive graph
% BestW: is the projection matrix, which can be adjusted by set param 'm'
% Y_predict: is the prediction of unlabeled data
% BestIter: is the value of Iter at maximum accuracy.
%
% =========================================================================

%% Prepare data
% matrix parameters 
[n,d] = size(X);
[l,d] = size(X_l);
[l,c] = size(Y_l);
[u,d] = size(X_u);

D_X = getDmatrix(X);
%% SPGO model
% set the parameter selection range to {2^-10, 2^-8,¡­,2^10}
alphanums = [-10,-8,-6,-4,-2,0,2,4,6,8,10];
betanums = [-10,-8,-6,-4,-2,0,2,4,6,8,10];
gammanums = [-10,-8,-6,-4,-2,0,2,4,6,8,10];
% set the feature dimension after projection
% Default is 50, it can be set 10,20,30,50,100,200
m = 50;
% Default MaxIteration is 50;
MaxIteration = 50;
epsilon = 1e-5;     
Max_acc = 0;

for alpha_index = 1:length(alphanums)
    for beta_index = 1:length(betanums)
        for gamma_index = 1:length(gammanums)  
            alpha = 2^alphanums(alpha_index);
            beta = 2^betanums(beta_index);
            gamma = 2^gammanums(gamma_index);
            fprintf('alpha: %.4f  beta: %.4f  gamma: %.4f£¬the best acc: %.4f \n',alpha,beta,gamma,Max_acc);
            % step1: Init S    
            for i = 1:n
                S(i,:) = EProjSimplex_new((-1/(2*alpha))*D_X(i,:));
            end
          
            % step2: Init F¡¢Q ¡¢S_t
            F = ones(u,c)/c;
            F = [Y_l;F];
            Q = eye(d);
            H = eye(n) - ones(n)/n;
            S_t = X'*H*X;
           %% Loop Iteration
            for iter = 1:MaxIteration
              
                % step3: Update L_s
                S = (S+S')/2;
                D_s = diag(sum(S)); 
                L_s = D_s - S;

                % step4: Update F 
                for i = l+1:n
                    sumf_j = sum(F.* S(i,:)');
                    sumf_j = (sumf_j - S(i,i)*F(i,:));
                    F(i,:) = EProjSimplex_new(sumf_j);                  
                end

                % step5: Update W
                solve_W = S_t\(X'*L_s*X + beta * Q);
                [eig_V,eig_E] = eig(solve_W);
                [~,index] = sort(diag(eig_E));
                V_sort = eig_V(:,index);
                W = V_sort(:,1:m);

                % step6: Update Q
                temp = 2*(sum(W.*W,2)+epsilon).^0.5;
                Q = diag(1./temp);

                % step7: Update S
                WX = X*W;
                D_WX = getDmatrix(WX);
                D_F = getDmatrix(F);
                D_W = D_WX + gamma*D_F;
                for i = 1:n
                    S(i,:) = EProjSimplex_new((-1/(2*alpha))*D_W(i,:));
                end
       
                
                % calculate the accuracy
                F_U = F(l+1:n,:);
                [~,Max_index] = max(F_U,[],2);
                acc = length(find(Max_index==Y_u))/u;

                if(acc > Max_acc)
                    Max_acc = acc;
                    Bestalpha = alpha;
                    Bestbeta = beta;
                    Bestgamma = gamma;
                    BestF_U = F_U;
                    BestS = solveS(S,Y_index);
                    BestW = W;
                    Y_predict = Max_index;
                    BestIter = iter;
                end
            end
         end
    end
end


