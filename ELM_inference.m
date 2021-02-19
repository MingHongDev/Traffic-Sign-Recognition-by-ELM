function  Predicted_class=ELM_inference(P,Weight)

load(Weight);
NumberofData=size(P,2);

tempH=InputWeight*P;%train data 與 隨機輸入權重 相乘
clear P;                                            %   Release input of training data (清除 train data)
ind=ones(1,NumberofData);%建立 (大小為 1 x train data 數量) 全為1的行向量
BiasMatrix=BiasofHiddenNeurons(:,ind);              %   Extend the bias matrix BiasofHiddenNeurons to match the demention of H
tempH=tempH+BiasMatrix;% x ˙ w + b

%%%%%%%%%%% Calculate hidden neuron output matrix H
switch lower(ActivationFunction)
    case {'sig','sigmoid'}
        %%%%%%%% Sigmoid 
        H = 1 ./ (1 + exp(-tempH));
    case {'sin','sine'}
        %%%%%%%% Sine
        H = sin(tempH);    
    case {'hardlim'}
        %%%%%%%% Hard Limit
        H = double(hardlim(tempH));
    case {'tribas'}
        %%%%%%%% Triangular basis function
        H = tribas(tempH);
    case {'radbas'}
        %%%%%%%% Radial basis function
        H = radbas(tempH);
        %%%%%%%% More activation functions can be added here                
end
clear tempH;                                        %   Release the temparary array for calculation of hidden neuron output matrix H


Y=(H' * OutputWeight)'; 

Predicted_class=zeros(1,NumberofData);
for i=1:NumberofData
    [~,Predicted_class(1,i)]=max(Y(:,i));
end
Predicted_class=Predicted_class-1;
end