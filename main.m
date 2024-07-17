%%  清空环境变量
warning off             
close all               
clear                   
clc                     
format compact;
currentFolder = pwd;
addpath(genpath(currentFolder));   
%%  初始数据导入数据
[DATA]=xlsread('数据集.xlsx');
input=DATA(:,1:5); 
output=DATA(:,6:12);   

[N,~]=size(input);
Nu_train= N*0.8;
Nu_test = N - Nu_train;  
input_train=input(1:Nu_train,:);   
input_test=input(Nu_train+1:N,:);  
output_train=output(1:Nu_train,:); 
output_test=output(Nu_train+1:N,:);

inputn_train=input_train';  outputn_train=output_train';
inputn_test=input_test';   outputn_test=output_test';
% 数据归一化
[inputn_train,inputps]  =mapminmax(inputn_train);  [outputn_train,outputps]=mapminmax(outputn_train);
inputn_test =mapminmax('apply',inputn_test,inputps);  outputn_test=mapminmax('apply',outputn_test,outputps);

%% DBO_KELM
SearchAgents_no=30;  
Max_iteration=20;    
dim=2;        
lb = [0.1,0.0001];   
ub = [2000,100]; 

fobj_KELM = @(x) fun_KELM_CV(x,inputn_train,outputn_train);
[Best_score,Best_pos,Convergence_curve]=DBO(SearchAgents_no,Max_iteration,lb,ub,dim,fobj_KELM); %蜣螂优化算法


%% 提取最优超参数
Regularization_coefficient=Best_pos(1);
Kernel_para=Best_pos(2);

disp(['最优惩罚参数Ｃ：' num2str(Regularization_coefficient)])
disp(['核参数：' num2str(Kernel_para)])

%%
Kernel_type = 'rbf';
% 训练 +训练集预测
[KELM_train_simu,OutputWeight1] = kelmTrain(inputn_train,outputn_train,Regularization_coefficient,Kernel_type,Kernel_para); % 训练及训练集预测
InputWeight1 = OutputWeight1;
[KELM_test_simu] = kelmPredict(inputn_train,InputWeight1,Kernel_type,Kernel_para,inputn_test);   %测试集预测

% 反归一化
KELM_train_simu = mapminmax('reverse',KELM_train_simu,outputps);
KELM_test_simu= mapminmax('reverse',KELM_test_simu,outputps);
KELM_train_simu=KELM_train_simu';   KELM_test_simu=KELM_test_simu';
result_train = [KELM_train_simu output_train];
result_test = [KELM_test_simu output_test];    %output_test为测试样本的实测值  KELM_test_simu为测试样本测试结果

