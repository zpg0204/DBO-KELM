
function fitness = fun_KELM_CV(x,inputn_train,outputn_train);

Regularization_coefficient = x(1);
Kernel_para = x(2);
Kernel_type = 'rbf';

% 交叉验证
cv=2;
disp(['开启 KELM   ', num2str(cv),'交叉验证啦']);
indices = crossvalind('Kfold',length(inputn_train),cv);
for i = 1:cv
    testa = (indices == i); traina = ~testa;
    p_cv_train=inputn_train(:,traina);
    t_cv_train=outputn_train(:,traina);
    p_cv_valid=inputn_train(:,testa);
    t_cv_valid=outputn_train(:,testa);
    
    [train_simu,OutputWeight] = kelmTrain(p_cv_train,t_cv_train,Regularization_coefficient,Kernel_type,Kernel_para); % 训练及训练集预测
    InputWeight= OutputWeight;
    [cv_valid_simu] = kelmPredict(p_cv_train,InputWeight,Kernel_type,Kernel_para,p_cv_valid);   % 验证集预测
    
    
    % 统计计算MSE的值
    error_valid = cv_valid_simu-t_cv_valid;      % 验证集绝对误差
    MSE_valid= mean((error_valid).^2);   % 均方根误差
    MSE(i)=sum(MSE_valid);
    
end
cv_MSE=mean(MSE,2);
fitness=cv_MSE;
end




