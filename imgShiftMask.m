function [img_out, mask] = imgShiftMask(img_raw, blk, sat, coordinates)

img_out = (double(img_raw) - blk)/(sat-blk);
img_out(img_out<0)=0;

% saturated pixels
mask = max(img_out,[],3) >= 0.98;

if exist('coordinates', 'var')
    coordinates = min(coordinates,[Inf size(mask,1) Inf size(mask,2)]);
    coordinates = max(coordinates,[1 1 1 1]);
    mask(coordinates(1):coordinates(2),coordinates(3):coordinates(4)) = true;
end