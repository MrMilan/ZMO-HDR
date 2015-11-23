function [E, finv] = estimate_response(Z, t, w, lambda)
%ESTIMATE_EXPOSURE Estimate irradiance and response function
%
% [E, finv] = estimate_exposure(Z, t, w, lambda)
%
% Estimate irradiance and the inverse response function from pixel intensities
% from multiple exposures.
%
% Input:
%   Z [NxP double] Pixel intensities.
%     Z(i,j) is the intensity of pixel i in image j.
%   t [1xP double] Exposure times, t > 0.
%   w [NxP double] Weights.
%   lambda [1x1 double] Smoothness violation penalty.
%
% Output:
%   E    [Nx1 double] Irradiance (up to scale).
%   finv [Lx1 double] Inverse response function (up to scale),
%     finv(round(L/2)+1) = 1 (soft constraint).
%

assert(ismatrix(Z));
assert(numel(Z) == numel(w));
assert(size(Z, 2) == numel(t));
assert(all(t(:) > 0));

[N, P] = size(Z);
L = max(Z(:)) + 1;
% Get pixel and image indices.
[i_E, i_t] = ind2sub(size(Z), (1:numel(Z))');

%% TODO: Implement me!
b = log(t(i_t))';
eZ = reshape(Z,[],1);
j = [eZ+1, L+i_E];
i = [(1:N*P)', (1:N*P)'];
wz = sqrt(w);
wz = reshape(wz,[],1);
v = [wz, -wz];
A = sparse(i, j, v);
b = b.*wz;
b = [b; zeros(L-2,1)];
j = [(1:L-2)',(2:L-1)', (3:L)'];
i = [(1:L-2)', (1:L-2)', (1:L-2)'];
sl = sqrt(lambda);
v = [sl*ones(L-2,1), -2*sl*ones(L-2,1), sl*ones(L-2,1)];
A2 = sparse(i,j,v,L-2,N+L);
A = [A; A2];
A(:,round(L/2)+1) = 0;

finMat=A\b;

finv=exp(finMat(1:L));
E=exp(finMat(L+1:end));

%%

assert(numel(finv) == L);
assert(numel(E) == N);

end
