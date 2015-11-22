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

columnsVector=repmat(1:size(Z,1),1,size(Z,2))+L;
sizeCol=size(columnsVector,1);
rowsVector=1:sizeCol;

values=[-ones(1,sizeCol) ones(1,size(Z(:),1))];

columnsVector=[columnsVector Z(:)'+1];
rowsVector=[rowsVector rowsVector];

A1=sparse(rowsVector,columnsVector,values);

w=sqrt(w);
w=w(:);
b=repmat(t,size(Z,1),1);
b=b(:);

b=log(b);
b=b.*w;
b(end+1)=0;

A1=bsxfun(@times,A1,w); 

A2=zeros(1,size(A1,2));
A2(floor(L/2+0.5)+1)=1;

A=[A1; A2];

pomC=[sparse([1:L-2 1:L-2],[1:L-2 3:L],1) sparse(L-2,size(Z,1))];
indC=2:L-1;
C=pomC+[sparse(1:length(indC),indC,-2) sparse(L-2,size(Z,1)+1)];
b=[b; zeros(size(C,1),1)];
A=[A; C*sqrt(lambda)];

finaleMat=A\b;

finv=exp(finaleMat(1:L));
E=exp(finaleMat(L+1:end));

%%

assert(numel(finv) == L);
assert(numel(E) == N);

end
