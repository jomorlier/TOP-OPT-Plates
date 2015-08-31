function xnew = OC(nelx, nely, x, FrVol, dC)
% Implement the Optimality Criteria method for compliance optimization.
% 'nelx' and 'nely' are the number of element along the two dimensions.
% 'x' is a nely-by-nelx matrix representing the density field on the plate.
% 'FrVol' is the desired volume fraction at the optimum condition.
% 'dC' is a nely-by-nelx matrix returned by the sensitivity analysis.

% WARNING: this code is written assuming unit element's area.

l1 = 0; l2 = 1e20;  % limits to the volume Lagrange multiplier
move = 0.2;         % limit to the change of 'x'
FS = 0.5;           % stabilization factor
% find the volume multiplier using a bisection method
while (l2-l1 > 1e-4)
    lmid = 0.5*(l2+l1);
    xnew = max(0.001, max(x-move, min(1., min(x+move, x.*(max(0.0001,-dC)./lmid).^FS))));
    if sum(sum(xnew)) - FrVol*nelx*nely > 0
        l1 = lmid;
    else
        l2 = lmid;
    end
end
end