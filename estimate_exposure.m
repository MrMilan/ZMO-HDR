function [E, t] = estimate_exposure(Z, w)
%ESTIMATE_EXPOSURE Estimate irradiance and exposure time
%
% [E, t] = estimate_exposure(Z, w)
%
% Estimate irradiance and exposure times from pixel intensities from multiple
% exposures.
% 
% Assume that the response function f is identity.
% (Note that if the response function is known you can transform
% the pixel intensities prior to calling this function.)
% 
% Use eps instead of zero Z values for taking the logarithm to avoid
% infinity.
%
% Input:
%   Z [NxP double] Pixel intensities,
%     Z(i,j) corresponds to the intensity of pixel i in image j.
%   w [NxP double] Weights corresponding to Z.
%
% Output:
%   E [Nx1 double] Irradiance (up to scale).
%   t [1xP double] Exposure times (up to scale),
%     t(1) = 1 (soft constraint).
%

assert(ismatrix(Z));
assert(numel(Z) == numel(w));

[N, P] = size(Z);
% Get pixel and image indices.
[i_E, i_t] = ind2sub(size(Z), (1:numel(Z))');

%% TODO: Implement me!

onesMat = sparse(1:N,1:N,ones(1,N));
repMatA = repmat(onesMat,P,1);
repMatB = kron(eye(P),ones(N,1));
A= [repMatA repMatB];
g=log(Z(:));
weight=sqrt(w);
g=bsxfun(@times,g,weight(:));
A=bsxfun(@times,A,weight(:));
A(1:N,N+1)=0;
finMat=A\g;
t=exp(finMat(N+1:end));
E=exp(finMat(1:N));

%%

assert(numel(E) == N);
assert(numel(t) == P);

end
