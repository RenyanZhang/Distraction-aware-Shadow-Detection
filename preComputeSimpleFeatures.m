function preComputeSimpleFeatures(i_name,o_name,blk,sat,coordinates)

img = double(imread(i_name));
[img, mask] = imgShiftMask(img, blk, sat, coordinates);
data = reshape(img,[],3);
data(mask,:) = [];

grayworld= mean(data);
% mn = [grayworld(1) grayworld(2) grayworld(3)];
ss = sum(grayworld);
mn(1,1)= grayworld(1)/ss;
mn(1,2)= grayworld(2)/ss;

% histogram/sample the colors appearing in the image
[cnt,map] = hist3D(reshape(data,1,[],3));
map(cnt<200,:) = []; % filter some noise
cnt(cnt<200) = [];

chrom_map(:,2) = map(:,2)./sum(map,2);
chrom_map(:,1) = map(:,1)./sum(map,2);

[~,idxMax] = max(sum(map,2));
mx = [chrom_map(idxMax,1) chrom_map(idxMax,2)];
% mx = [map(idxMax,1) map(idxMax,2) map(idxMax,3)];

% [~,idxMax] = max(cnt.*sum(map,2));
[~,idxMax] = max(cnt);
dmnt = [chrom_map(idxMax,1) chrom_map(idxMax,2)];
% dmnt = [map(idxMax,1) map(idxMax,2) map(idxMax,3)];

[~,density,r,g] = kde2d(chrom_map,0.005,2^8,[0 0],[1,1]);
[~,idxPeak] = max(density(:));
pk = [r(idxPeak) g(idxPeak)];

save('-mat',o_name,'mn','mx', 'dmnt','pk');