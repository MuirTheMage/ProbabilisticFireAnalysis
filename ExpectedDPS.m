function [expectedDPS,DPS,totalprobs] = ExpectedDPS(directDmg,directProb,igniteDmg,igniteProb, nmages, ncasts,castTime,threshold,PLOTS)
%     [directDmg,directProb] = directDamage(SP,hitpct,critpct, Dmin,Dmax,ncasts,castTime,false);
    firepowerTalents = 5;
    multiplier = 1+.01*firepowerTalents;
    if PLOTS
        figure()
        plot(directDmg/(ncasts*castTime),directProb)
        xlim([0, min(max(directDmg/(ncasts*castTime)),threshold)])
        title("Directed DPS")
    end
    
%     [igniteDmg,igniteProb] = expectedIgnite(Emat,Smat,SP, Dmin,Dmax, castTime, ncasts);
    igniteDmg = igniteDmg/nmages;
    if PLOTS
        figure()
        plot(igniteDmg/(ncasts*castTime),igniteProb)
        ylim([0,max(igniteProb(2:end))])
        xlim([0, min(max(igniteDmg/(ncasts*castTime)),threshold)])
        title("Ignite DPS Per Mage")
    end
    
    [totalDmg, totalprobs] = mergeDamage(directDmg*multiplier,directProb,igniteDmg*multiplier,igniteProb);
    DPS = totalDmg/(ncasts*castTime);
    thresholds =DPS>threshold;
    if any(thresholds)
        thresholdInd = find(thresholds,1,'first');
        totalprobs(thresholdInd:end) = 0;
        totalprobs = totalprobs/sum(totalprobs);
    end
    if PLOTS
        figure()
        plot(DPS,totalprobs)
        ylim([0,max(totalprobs(2:end))])
        xlim([0, min(max(DPS),threshold)])
        title("Total DPS Per Mage")
    end
    expectedDPS = sum(DPS.*totalprobs');
end
