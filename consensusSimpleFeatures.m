function consensusSimpleFeatures(camera)

method = 'SimpleFeatures';
nCV = 3;
nTrees = 30;
threshold = 0.025;


dataset  = load(['D:\Research\Color_Constancy\RGB_datasets\' camera '/' camera '_gt.mat']);
% dataset  = load([camera '/' camera '_gt.mat']);
nImages  = length(dataset.all_image_names);

if ~exist(['_Results/' camera '/' method],'dir')
    mkdir(['_Results/' camera], method)
end

dirInput  = ['D:\Research\Color_Constancy\RGB_datasets\' camera '/PNG/'];
% dirInput  = [camera '/PNG/'];
dirOutput = ['_Results/' camera '/' method '/'];

[idxTrain, idxTest] = makeCrossValidationSplits(nImages,nCV);

featureRegression  = zeros(nImages,8);

pc_names = cell(nImages,1);
for i = 1:nImages
    pc_names{i} = [dirOutput 'pc_' dataset.all_image_names{i} '.mat'];
    if ~exist(pc_names{i},'file')
        fprintf('\tPrecomputing for %s\n',dataset.all_image_names{i});
        
        preComputeSimpleFeatures([dirInput dataset.all_image_names{i} '.png'], ...
                                 pc_names{i}, ...
                                 dataset.darkness_level, ...
                                 dataset.saturation_level, ...
                                 dataset.CC_coords(i,:));
    end
    pc = load(pc_names{i});
    featureRegression(i,:) = [pc.mn pc.mx pc.dmnt pc.pk];
end

%% 
%%%%%%%%%% train and predict regression trees %%%%%%%%%%
truel = dataset.groundtruth_illuminants;
tl_b  = sum(truel,2);
tl_r  = truel(:,1)./tl_b;
tl_g  = truel(:,2)./tl_b;

% step 1: generating candidates
rCandidates_mn   = zeros(nImages,nTrees);
gCandidates_mn   = zeros(nImages,nTrees);
rCandidates_mx   = zeros(nImages,nTrees);
gCandidates_mx   = zeros(nImages,nTrees);
rCandidates_dmnt = zeros(nImages,nTrees);
gCandidates_dmnt = zeros(nImages,nTrees);
rCandidates_pk   = zeros(nImages,nTrees);
gCandidates_pk   = zeros(nImages,nTrees);

for f = 1:nCV
    
    Xf_mn   = featureRegression(idxTrain{f},1:2);
    Xf_mx   = featureRegression(idxTrain{f},3:4);
    Xf_dmnt = featureRegression(idxTrain{f},5:6);
    Xf_pk   = featureRegression(idxTrain{f},7:8);

    Yrf = tl_r(idxTrain{f});
    Ygf = tl_g(idxTrain{f});
    
    % train decision tree regression
    rTrees_mn   = cell(1,nTrees);
    gTrees_mn   = cell(1,nTrees);
    rTrees_mx   = cell(1,nTrees);
    gTrees_mx   = cell(1,nTrees);
    rTrees_dmnt = cell(1,nTrees);
    gTrees_dmnt = cell(1,nTrees);
    rTrees_pk   = cell(1,nTrees);
    gTrees_pk   = cell(1,nTrees);
    
    % sort according to the illuminant chromaticity
    [Yrf_s, id_s] = sort(Yrf,'ascend');
    Ygf_s         = Ygf(id_s);
    Xf_mn_s       = Xf_mn(id_s,:);
    Xf_mx_s       = Xf_mx(id_s,:);
    Xf_dmnt_s     = Xf_dmnt(id_s,:);
    Xf_pk_s       = Xf_pk(id_s,:);
    
    nn = length(idxTrain{f});
    
    T  = floor(nn/(nTrees+1));
    for r = 1:nTrees
        idxSubset_l = 1+(r-1)*T : (r+1)*T;
        idxSubset   = [repmat(idxSubset_l,1,nTrees) 1:nn];
        
        rTrees_mn{r} = fitrtree(Xf_mn_s(idxSubset,:), Yrf_s(idxSubset));
        gTrees_mn{r} = fitrtree(Xf_mn_s(idxSubset,:), Ygf_s(idxSubset));
        rCandidates_mn(idxTest{f},r) = predict(rTrees_mn{r},featureRegression(idxTest{f},1:2));
        gCandidates_mn(idxTest{f},r) = predict(gTrees_mn{r},featureRegression(idxTest{f},1:2));
        
        rTrees_mx{r} = fitrtree(Xf_mx_s(idxSubset,:), Yrf_s(idxSubset));
        gTrees_mx{r} = fitrtree(Xf_mx_s(idxSubset,:), Ygf_s(idxSubset));
        rCandidates_mx(idxTest{f},r) = predict(rTrees_mx{r},featureRegression(idxTest{f},3:4));
        gCandidates_mx(idxTest{f},r) = predict(gTrees_mx{r},featureRegression(idxTest{f},3:4));
        
        rTrees_dmnt{r} = fitrtree(Xf_dmnt_s(idxSubset,:), Yrf_s(idxSubset));
        gTrees_dmnt{r} = fitrtree(Xf_dmnt_s(idxSubset,:), Ygf_s(idxSubset));
        rCandidates_dmnt(idxTest{f},r) = predict(rTrees_dmnt{r},featureRegression(idxTest{f},5:6));
        gCandidates_dmnt(idxTest{f},r) = predict(gTrees_dmnt{r},featureRegression(idxTest{f},5:6));
        
        rTrees_pk{r} = fitrtree(Xf_pk_s(idxSubset,:), Yrf_s(idxSubset));
        gTrees_pk{r} = fitrtree(Xf_pk_s(idxSubset,:), Ygf_s(idxSubset));
        rCandidates_pk(idxTest{f},r) = predict(rTrees_pk{r},featureRegression(idxTest{f},7:8));
        gCandidates_pk(idxTest{f},r) = predict(gTrees_pk{r},featureRegression(idxTest{f},7:8));
    end
end


%%
%%%%%%%%%% examin the candidates consensus %%%%%%%%%%
ei  = zeros(nImages,3);
ae = zeros(nImages,1);
cons = boolean(zeros(1,nTrees));

for i = 1:nImages
    cons(:) = 0;
    for k = 1:nTrees
        a = [rCandidates_mn(i,k)   gCandidates_mn(i,k)];
        b = [rCandidates_mx(i,k)   gCandidates_mx(i,k)];
        c = [rCandidates_dmnt(i,k) gCandidates_dmnt(i,k)];
        d = [rCandidates_pk(i,k)   gCandidates_pk(i,k)];
        
        dabcd = [norm(a-b) norm(a-c) norm(a-d) norm(b-c) norm(b-d) norm(c-d)];
        
        if sum(dabcd<threshold)>=3
           cons(k) = 1;
        end
    end
    if sum(cons) == 0 % use the median of all candidates
        ei(i,1) = median([rCandidates_mn(i,:) rCandidates_mx(i,:) rCandidates_dmnt(i,:) rCandidates_pk(i,:)]);
        ei(i,2) = median([gCandidates_mn(i,:) gCandidates_mx(i,:) gCandidates_dmnt(i,:) gCandidates_pk(i,:)]);
    else
        ei(i,1) = median([rCandidates_mn(i,cons) rCandidates_mx(i,cons) rCandidates_dmnt(i,cons) rCandidates_pk(i,cons)]);
        ei(i,2) = median([gCandidates_mn(i,cons) gCandidates_mx(i,cons) gCandidates_dmnt(i,cons) gCandidates_pk(i,cons)]);
    end

    ei(i,3) = 1 - ei(i,1)- ei(i,2);
    ei(i,:) = ei(i,:)./norm(ei(i,:));
    ae(i) = acosd(sum(ei(i,:).*truel(i,:)));
end

reportError(ae)

return