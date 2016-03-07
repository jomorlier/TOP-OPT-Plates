function xnew = OC(nelx, nely, element, x, FrVol, dF, move, SF)
% Implement the Optimality Criteria method.
% 'nelx' and 'nely' are the number of elements along the two dimensions.
% 'element' is a FE object.
% 'x' is a nely-by-nelx matrix representing the density field on the plate.
% 'FrVol' is the desired volume fraction at the optimum condition.
% 'dF' is a nely-by-nelx matrix returned by the sensitivity analysis.
% 'move' is the limit to the change of 'x' (stabilization).
% 'SF' is a stabilization factor.
% 'xnew' is the updated density distribution.

% WARNING: to minimize compliance pass dF.
%          to maximize eigenfrequency pass -dF.

Ae = element.dims.height * element.dims.width; % element's area
l1 = 0; l2 = 1e20;  % limits to the volume Lagrange multiplier
mu = max(max(dF));  % shift to the Lagrange multiplier (effective for objective different from compliance)
meth = 'new';       % selector to choose the method to be used
switch meth
    case 'bis'
        % find the volume multiplier using a bisection method
        while (l2-l1 > 1e-9)
            lmid = 0.5*(l2+l1);
            xnew = max(0.001, max(x-move, min(1., min(x+move, x.*((mu-dF)./(lmid*Ae)).^SF))));
            if sum(sum(xnew.*Ae)) - FrVol*nelx*nely*Ae > 0
                l1 = lmid;
            else
                l2 = lmid;
            end
        end
    case 'new'
        % NOT TESTED!
        % find the volume multiplier using the Newton method
        l = 0.5*(l2+l1);
        xnew = max(0.001, max(x-move, min(1., min(x+move, x.*(max(0.0001,-dC)./l).^FS))));
        totvol = sum(sum(xnew));
        while abs(totvol - FrVol*nelx*nely) > 1e-1
            totvol = sum(sum(xnew));
            l = l - (totvol - FrVol*nelx*nely)/(totvol*(-FS/l));
            xnew = max(0.001, max(x-move, min(1., min(x+move, x.*(max(0.0001,-dC)./l).^FS))));
        end
    case 'ana'
        % NOT TESTED!
        % find the volume multiplier analitically from the volume constraint
        l = (FrVol*nelx*nely/(sum(sum(x.*(-dC).^FS))))^(-1/FS);
        xnew = max(0.001, max(x-move, min(1., min(x+move, x.*(max(0.0001,-dC)./l).^FS))));
end
end