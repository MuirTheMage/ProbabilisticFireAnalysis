function [Emat,Smat,ExpectedTicks] = fixedTransition(C,nmages, castTime,ncasts)
    % Crit chance C, nmages is number of mages, castTime is spell cast time
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
    
    
    Smat  = zeros(size(Cmat));
    prodMat = eye(size(Cmat));
    nBatches = (round(1/batchTime*castTime));
    magePerBlock = ceil(nmages/nBatches);
    blockDelta = floor(nBatches/nmages);
    count = 0;
    for t = 1:nBatches
        ninclude = min(nmages-count,magePerBlock*(1-ceil(mod(t,blockDelta)/blockDelta)));
        count = count + ninclude;
        prodMat = prodMat*Cmat^ninclude*Tmat;
        Smat = Smat + prodMat;
        if t==nBatches
            Emat = prodMat;
        end
    end
    ExpectedTicks = zeros(size(Emat));
    for k = 1:ncasts
        ExpectedTicks = ExpectedTicks+ Smat;
        if k<ncasts
            Smat = Smat*Emat;
        end
    end

end