function [Emat,Smat,ExpectedTicks] = expectedTransition(C,n, castTime,ncasts)
    % Crit chance C, n mages, castTime is spell cast time
    batchTime = .2;
    T = (round(1/batchTime*4));

    I = eye((round(1/batchTime*2)));
    I5 = eye(5);
    S5 = I5([2:size(I5,1),1],:);
    S5(end,:) = I5(end,:);

    M = [I, zeros(size(I));I, zeros(size(I))];
    Cmat = padarray(kron(S5,M)*C +eye(size(S5).*size(M))*(1-C),[1 1],0,'post');
    Cmat(end,1) = C;
    Cmat(end,end) = 1-C;

    IT = eye(T);
    ST = IT([2:size(IT,1),1],:);
    ST(end,:) = zeros(1,T);
    Tmat = padarray(kron(I5,ST),[1 1],0,'post');
    Tmat(all(Tmat==0,2),end)=1;
    
    m = (round(1/batchTime*castTime));
    
    Smat  = zeros(size(Cmat));
    nBatches = (round(1/batchTime*castTime));
    for t = 1:nBatches
        tMat = zeros(size(Cmat));
        normSum = 0;
        for m = 0:n
            Mat = coefficient(t,m,Tmat, Cmat,false);
            tMat = tMat + Mat;
            normSum = normSum + nchoosek(t+m-1,t-1);
        end
        Smat = Smat + tMat/normSum;
        if t==nBatches
            Emat = tMat/normSum;
        end
    end
    Emat = abs(Emat);
    Smat = abs(Smat);
    ExpectedTicks = zeros(size(Emat));
    for k = 1:ncasts
        ExpectedTicks = ExpectedTicks+ Smat;
        if k<ncasts
            Smat = Smat*Emat;
        end
    end
    
end

function SumMat = coefficient(m,n,Tmat, Cmat,normalized)
    q = (m+n);
    P = @(x) (Cmat+x*Tmat)^(n+m-1);
    roots = @(m) exp(2*pi*1i/m).^(0:(m-1));
    root = roots(q);
    SumMat = zeros(size(Cmat));
    for i=(1:q)
       r = root(i);
       SumMat = SumMat + r^(-(m-1))*P(r);
    end
    if normalized
        ncoeff = nchoosek(m+n-1,m-1);
    else
        ncoeff = 1;
    end
    SumMat = SumMat*Tmat/(q*ncoeff);
end


