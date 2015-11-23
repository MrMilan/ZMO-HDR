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

onesMatPos=sparse(1:N,1:N,ones(1,N));
A1=sparse([repmat(onesMatPos,P,1) kron(eye(P),ones(N,1))]);
w=sqrt(w);
w=w(:);
pomMat=(log(Z(:))).*w;

A1=bsxfun(@times,A1,w); 

pomMat(end+1)=0;
A2=zeros(1,size(A1,2));
A2(N+1)=1;
vyslMat=[A1;A2]\pomMat;
t=exp(vyslMat(N+1:end));
E=exp(vyslMat(1:N));

%%

assert(numel(E) == N);
assert(numel(t) == P);

end
