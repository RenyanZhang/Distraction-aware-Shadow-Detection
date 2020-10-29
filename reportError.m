% function reportError(ae, clabel)
function reportError(ae)

mn = mean(ae);
md = median(ae);
mx = max(ae);
ae_sort = sort(ae);
bst = mean(ae_sort(ceil(1:0.25*length(ae_sort))));
wst = mean(ae_sort(ceil(0.75*length(ae_sort)):end));
tr = (md+(ae_sort(ceil(0.25*length(ae_sort)))+ae_sort(ceil(0.75*length(ae_sort))))/2)/2;
Q95 = prctile(ae,95);
fprintf('Mean: %.2f, Median: %.2f, Trimean: %.2f, Best-25 %2.2f, Worst-25 %2.2f, Quantile-95: %2.2f, Max: %.2f\n', mn,md,tr,bst,wst,Q95,mx);

% beep