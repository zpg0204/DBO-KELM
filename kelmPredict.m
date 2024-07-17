%      Kernel_type ∫À¿‡–Õ                - Type of Kernels:
%                                   'RBF_kernel' for RBF Kernel
%                                   'lin_kernel' for Linear Kernel
%                                   'poly_kernel' for Polynomial Kernel
%                                   'wav_kernel' for Wavelet Kernel


function [TestOutT] = kelmPredict(P_train,InputWeight,Kernel_type,Kernel_para,P_test)

P = P_train;
PT = P_test;
Omega_test = kernel_matrix(P',Kernel_type, Kernel_para,PT');
TY=(Omega_test' * InputWeight)';                            %   TY: the actual output of the testing data
TestOutT = TY;
end