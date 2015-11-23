function im = tonemap_log(hdr)
%TONEMAP_LOG Tonemapping via logarithm
%
% im = tonemap_log(hdr)
%
% Input:
%   hdr   [MxNx3 double]  HDR image in the RGB color space, not normalized.
%
% Output:
%   im [MxNx3 double] Tone-mapped image in RGB, normalized to [0, 1].
%
% Use log(x + eps) instead of log(x) to avoid infinities.
%

im = hdr - min(hdr(:));
im = im ./ max(im(:));

%% TODO: Implement me!

hsvImg = rgb2hsv(im);

hsvImg(:,:,3) = log(hsvImg(:,:,3)+eps);
minHSV = min(min(hsvImg));
maxHSV = max(max(hsvImg));
hsvImg(:,:,3) = hsvImg - minHSV;
hsvImg(:,:,3) = hsvImg/maxHSV;

im = hsvImg - min(min(hsvImg));
maxImg = max(max(im));
im = hsv2rgb(im ./ maxImg);





%%

end
