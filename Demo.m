clc;
clear;
close all;
addpath('MeasureTools');
addpath('LIB');
% compile_func(0);
Y=[];
load('data_3Sources.mat'); % load data
 
kmeansK = length(unique(Y));

%kmeansK = 5;

ViewN = length(X);
label=Y;
TotalSampleNo=length(Y);

%label=Y;
%TotalSampleNo=170;
N=TotalSampleNo;
members = zeros(N,6); 

for groupnum = 1:6 

newX = cell(size(X)); % 创建一个与 X 大小相同的空 cell 数组
  for j = 1:numel(X)
    dataset = X{j}; % 获取当前视图的数据集
    num_features = size(dataset, 2); % 获取当前视图的特征数量
    % 计算需要选择的特征数量（60%）
    %random_number = 0.85 + (0.95 - 0.85) * rand(1); 
    num_selected_features = round(0.8 * num_features);
    % 随机选择特征索引
    selected_feature_indices = randperm(num_features, num_selected_features);
    % 根据选择的特征索引提取新的数据集
    newX{j} = dataset(:, selected_feature_indices);
  end




Dist = cell(ViewN, 1);
for vIndex=1:ViewN
    TempvData=newX{vIndex};
    NorTempvData=NormalizeFea(double(TempvData));
    [tempN,tempD] = size(TempvData);
    tempDM=zeros(tempN,tempN);
    for tempi = 1:tempN
        for tempj =  1:tempN
            tempDM(tempi,tempj) = norm(NorTempvData(tempi,:) - NorTempvData(tempj,:)).^2;
        end
    end
    Dist{vIndex} = tempDM;
end
% get similarity matrices
knn = 16; % this parameter can be adjusted to obtain better results
sigma = 0.5;
Sim = cell(length(Dist), 1);
for ii = 1:length(Dist)
    Sim{ii} = bs_convert2sim_knn(Dist{ii}, knn, sigma);
end

%%
para.mu = 0.3;%原本的值是0.3
para.max_iter_diffusion = 5;%原本的值是10
para.max_iter_alternating = 5;%原本的值是10
para.thres = 1e-3;
I = eye(size(Sim{1}), 'single');
para.beta = ones(length(Sim), 1)/length(Sim);
%[A, ~] = CGD_eta(Sim, I, para);
[A, ~] = CGD_eta(Sim, I, para);
%out=PridictLabel(A,label',kmeansK);
%[result,Con] = ClusteringMeasure(label, out');  % [8: ACC MIhat Purity ARI F-score Precision Recall Contingency];
%disp(result);

%[out, ~] = SpectralClustering(A,kmeansK);
A_double = double(A);
 [Label, ~] = SpectralClustering(A_double,kmeansK);
  members(:, groupnum) = Label';
end
goalLabel=FastMICE_ConsensusFunction(members,kmeansK,20,5);


 [result,Con] = ClusteringMeasure(label, goalLabel');
 disp(result);
