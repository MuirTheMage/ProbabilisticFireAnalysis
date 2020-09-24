function [damage, probs] = mergeDamage(d1,p1,d2,p2)
    t1 = max(find(p1~=0,1,'last'),1);
    p1 = p1(1:t1);
    d1 = d1(1:t1);
    t2 = max(find(p2~=0,1,'last'),1);
    p2 = p2(1:t2);
    d2 = d2(1:t2);
    if max(d1)>max(d2)
        damage = d1;
        probs = p1;
        mergeD = d2;
        mergeprobs = p2;
    else
        damage = d2;
        probs = p2;
        mergeD = d1;
        mergeprobs = p1;
    end
    pmod = zeros(size(probs));
    for i=1:numel(mergeD)
        dval = mergeD(i);
        ind = find(dval>=damage,1,'last');
        pmod(ind) =  pmod(ind) + mergeprobs(i);
    end
    truncateInd = max(find(pmod~=0,1,'last'),1);
    pmod = pmod(1:truncateInd);
    dmod = damage(1:truncateInd);
    damage = linspace(min(dmod)+min(damage),max(dmod)+max(damage),numel(dmod)+numel(damage)-1);
    probs = conv(pmod,probs);
    
end


