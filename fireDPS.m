function [DPS,totalprobs,hitW, SPW,DPSW]= fireDPS(nmages,ncasts, int, SPgear,hit, critGear, DMT, SF, HEAD, HEART, FLASK, computeDPS,computestatWeights)
    %r12, r11, sc, fb
    Dvals = [596, 760; 561,715;237, 280; 446, 524]';
    dotvals = [76,76; 72,72;0,0;446,524];
    coeff = [1;1;1.5/3.5;1.5/3.5]';
    ct = [3;3;1.5;1.5];

    threshold = inf;
    intellect = int+12+15+31;%base, Songflower, gift of wild, AI
    SPconsumes = 35+40+36+150*FLASK; %Greater Firepower, Greater Arcane Elixir,Wizard Oil, supreme power
    SP = SPgear + SPconsumes;
    critInt = intellect*(1+0.15*HEART)/59.5; %Zandalar is 15%
    critBuff = 6+1+5*SF+3*DMT+10*HEAD; %talent, Wizard Oil, Songflower, DMT, Ony
    crit = critGear + critInt +critBuff;
    Dmin = 596;
    Dmax = 760;
    castTime = 3;
    hitpct = min(83+6+hit,99)/100.0; % talented 6%
    critpct = crit/100.0;
    
%    Transition = @(critpct,nmages, castTime,ncasts) fixedTransition(critpct*hitpct,nmages, castTime,ncasts);
    Transition = @(critpct,nmages, castTime,ncasts) expectedTransition(critpct*hitpct,nmages, castTime,ncasts);
    if computeDPS
        [~,~,ExpectedTicks] = Transition(critpct,nmages, castTime,ncasts);
        [directDmg,directProb] = directDamage(SP,hitpct,critpct, Dmin,Dmax,ncasts,castTime,false);
        [igniteDmg,igniteProb] = expectedIgnite(ExpectedTicks,SP, Dmin,Dmax, castTime, ncasts,nmages);

        [~,DPS,totalprobs] = ExpectedDPS(directDmg,directProb,igniteDmg,igniteProb,nmages, ncasts,castTime,threshold,false);
    else 
        DPS = nan;
        totalprobs = nan;
    end
    delta = 1;
    %Hit affect
    if computestatWeights
        [directDmg,directProb] = directDamage(SP,hitpct+delta/100,critpct, Dmin,Dmax,ncasts,castTime,false);
        expectedDPSplus = ExpectedDPS(directDmg,directProb,igniteDmg,igniteProb,nmages, ncasts,castTime,threshold,false);
        [directDmg,directProb] = directDamage(SP,hitpct-delta/100,critpct, Dmin,Dmax,ncasts,castTime,false);
        expectedDPSminus = ExpectedDPS(directDmg,directProb,igniteDmg,igniteProb,nmages, ncasts,castTime,threshold,false);
        hitW = (2*delta)/(expectedDPSplus-expectedDPSminus);

        % Spell power affect
        [directDmg,directProb] = directDamage(SP+delta,hitpct,critpct, Dmin,Dmax,ncasts,castTime,false);
        [igniteDmg,igniteProb] = expectedIgnite(ExpectedTicks,SP+delta, Dmin,Dmax, castTime, ncasts,nmages);
        expectedDPSplus = ExpectedDPS(directDmg,directProb,igniteDmg,igniteProb,nmages, ncasts,castTime,threshold,false);
        [directDmg,directProb] = directDamage(SP-delta,hitpct,critpct, Dmin,Dmax,ncasts,castTime,false);
        [igniteDmg,igniteProb] = expectedIgnite(ExpectedTicks,SP-delta, Dmin,Dmax, castTime, ncasts,nmages);
        expectedDPSminus = ExpectedDPS(directDmg,directProb,igniteDmg,igniteProb,nmages, ncasts,castTime,threshold,false);
        SPW = (2*delta)/(expectedDPSplus-expectedDPSminus);

        % Crit affect
        [~,~,ExpectedTicks] = Transition(critpct+delta/100,nmages, castTime,ncasts);
        [directDmg,directProb] = directDamage(SP,hitpct,critpct+delta/100, Dmin,Dmax,ncasts,castTime,false);
        [igniteDmg,igniteProb] = expectedIgnite(ExpectedTicks,SP, Dmin,Dmax, castTime, ncasts,nmages);
        expectedDPSplus = ExpectedDPS(directDmg,directProb,igniteDmg,igniteProb,nmages, ncasts,castTime,threshold,false);
        
        [~,~,ExpectedTicks] = Transition(critpct-delta/100,nmages, castTime,ncasts);
        [directDmg,directProb] = directDamage(SP,hitpct,critpct -delta/100, Dmin,Dmax,ncasts,castTime,false);
        [igniteDmg,igniteProb] = expectedIgnite(ExpectedTicks,SP, Dmin,Dmax, castTime, ncasts,nmages);
        expectedDPSminus = ExpectedDPS(directDmg,directProb,igniteDmg,igniteProb,nmages, ncasts,castTime,threshold,false);
        critW = (2*delta)/(expectedDPSplus-expectedDPSminus);
        
        denom = critW;
        hitW = hitW/denom;
        SPW  = SPW/denom;
        DPSW = 1/denom;
    else
        hitW = nan;
        SPW  = nan;
        DPSW = nan;
    end
end
