function hdr = compose_hdr(im, t, w, finv)
%COMPOSE_HDR Compose HDR image
%
% hdr = compose_hdr(im, t, w, finv)
%
% Input:
%   im   [1xP cell] Cell array of images [MxNxC].
%   t    [1xP double] Exposure times.
%   w    [1xL double] Intensity weights, indexed as w(double(im{i})+1).
%   finv [1xL double] Inverse response function, indexed as finv(double(im{i})+1).
%
% Output:
%   hdr [MxNxC double] HDR image composed from the input images.
%

assert(numel(im) == numel(t));
assert(numel(w) == numel(finv));

hdr = zeros(size(im{1}));

%% TODO: Implement me!
hdr1=hdr;
hdr2=hdr;
for i=1:size(im,1);
    point=double(im{i})+1;
    hdr1=hdr1+finv(point).*w(point)/t(i);
    hdr2=hdr2+w(point);
end
hdr=hdr1./hdr2;

%%

end
