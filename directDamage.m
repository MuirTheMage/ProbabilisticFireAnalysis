function [vals,out] = directDamage(SP,hitpct,critpct, Dmin,Dmax,casts,castTime,DPS)
    N = casts;
    M= 10^4+1;
    Dvals = [Dmin; Dmax];
    coeff = 1;

    expD = (Dvals + coeff*ones(2,1)*SP);
    maxval = 1.6*max(expD);
    ts = linspace(0,maxval,M);
    Pd = zeros(M,1);
    Pd(1) = 1-hitpct;
    c1 = find(ts>1.5*expD(1),1);
    c2 = find(ts>1.5*expD(2),1);
    Pd(c1:c2) = critpct/(c2-c1+1);
    c1 = find(ts>expD(1),1);
    c2 = find(ts>expD(2),1);
    Pd(c1:c2) = (hitpct-critpct)/(c2-c1+1);
    out  = Pd;
    for i=2:N
        out = conv(Pd,out);
    end
    if DPS
        vals = linspace(0,maxval/castTime,size(out,1));
    else
        vals = linspace(0,maxval*N,size(out,1));
    end
end
