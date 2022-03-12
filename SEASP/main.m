clear
clc

dataset_names = {'Indian_Pines', 'Pavia_University', 'Salinas', 'KSC', 'Botswana'};
classifier_names = {'KNN', 'SVM', 'LDA'};
train_ratio = [0.1, 0.1, 0.1, 0.1, 0.1, 0.1];
svm_para = {'-c 10000.000000 -g 0.500000 -m 500 -t 2 -q',...
    '-c 100 -g 4 -m 500 -t 2 -q',...
    '-c 100 -g 16 -m 500 -t 2 -q',...
    '-c 10000.000000 -g 16.000000 -m 500 -t 2 -q',...
    '-c 10000 -g 0.5 -m 500 -t 2 -q',...
    }; % parameters to run svm tuned on each of the five datasets

x = [5, 7, 10, 15, 26, 30, 36, 39, 42, 44, 47, 49]; % the number of selected bands
ResSavePath = 'SEASP/results/';
if(~exist(ResSavePath,'file'))
    mkdir(ResSavePath);
    addpath(genpath(ResSavePath));
end
warning off;
for dataset_id = 1 : 5
    Dataset = get_data(dataset_names{dataset_id});
    Dataset.svm_para = svm_para{1, dataset_id};
    Dataset.train_ratio = train_ratio(dataset_id);
    for classifier_id = 1 : 3
        for j = 1 : length(x)
            Y = SEASP(Dataset.A, x(j));
            [acc,~] = test_bs_accu(Y, Dataset, classifier_names{classifier_id});
            OA(1,j) = acc.OA;
            MA(1,j) = acc.MA;
            Kappa(1,j) = acc.Kappa;
            STDOA(1,j) = acc.STDOA;
            STDMA(1,j) = acc.STDMA;
            STDKappa(1,j) = acc.STDKappa;
        end
        resFile = [ResSavePath 'SEASP-',dataset_names{dataset_id},'-',classifier_names{classifier_id},'.mat'];
        save(resFile, 'OA','MA','Kappa','STDOA','STDMA','STDKappa');
    end
end