function [igniteDamage,igniteProb] = expectedIgnite(ExpectedTicks,SP, Dmin,Dmax, castTime, ncasts,nmages)
    batchTime = .2;
    % Emat is expected transition, Smat is the sum of expected states after 1:T batch windows, casts is number
    % above T =  castTime/batchTime, the number of batches in one cast. 
    initVec = zeros(1,size(ExpectedTicks,1));
    initVec(end) = 1;
    
    totalnumBatches = (ncasts*castTime)/batchTime;
    distribution = initVec*ExpectedTicks/totalnumBatches;
    tickDistribution = sum(distribution(reshape((round(1/batchTime*2):round(1/batchTime*2):numel(distribution)),[2,5])));
    
    igniteProb = [1];
    igniteDamage = [0];
    totalnumBatches = (ncasts*castTime)/batchTime;
    for i= 1:5
        [tempDamage,tempP] = directDamage(SP,1,1, Dmin,Dmax,i,castTime,false);
        tempP = tempP*tickDistribution(i);
        tempP(1) = 1-sum(tempP);
        [igniteDamage,igniteProb] = mergeDamage(igniteDamage,igniteProb,tempDamage*(.4/2)*totalnumBatches/nmages,tempP);
    end
    
end