% 输入标签向量N*1
% 输出标签矩阵N*C
function [label_out]=LabelConvert(label_in)
N = size(label_in,1);
clu = size(unique(label_in),1);
label_out = zeros(N,clu);
for k=1:N
    label_out(k,label_in(k,1))=1;
end