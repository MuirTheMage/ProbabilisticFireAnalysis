# Probabilistic Fire Analysis
## Introduction and Usage

This application is meant to compute the distribution of damage that a group of fire mages may expect to do. This may best be considered a mage team optimizer in that the output assumes that all mages have the stats. The innovation here is that a simulation at best can only sample this distribution rather than provide a full perspective as to the damage the mage team may do. Furthermore this application allows you to set a fight length determined by the number of casts.

The application was written using Matlab. In order to run it you do not need a Matlab license but will need to install the framework using the installer. Available on [Github](https://github.com/MuirTheMage/ProbabilisticFireAnalysis), simply download the project as a Zip, then use **FireAnalysis_web.exe** on Windows or **FireAnalysis_web.app** on Mac OSX to install both the application and Matlab framework. Unfortunately on Mac your new loadouts will not automatically save (due to path issues) unless you follow the instructions generated in '/Applications/FireDamage/application/readme.txt', to run the application via the generated script 'run_FireDamage.sh'. In order to do this you must execute 'chmod +x run_FireDamage.sh' to make the file executable then run './run_FireDamage.sh' from the '/Applications/FireDamage/application/' directory. Additional files are not required but are provided for those interested in the implementation (and submitting bug reports).

## Assumptions

The application works takes in the number of mages in the group and the intellect, bonus critical hit and bonus hit chance from gear then computes a distribution as if attacking a level 63 boss. Wowhead has a [helpful tool](https://classic.wowhead.com/gear-planner/) for finding the stats for different gear setups. The application assumes that the mage is consumed and buffed minimally with the following

    1. Greater Arcane Elixir
    2. Greater Firepower
    3. Greater Wizard Oil
    4. Arcane Intellect
    5. Mark of the Wild

It is also assumed that the mage has 3 talent points in both Elemental Precision and Critical Mass as well as 5 talent points in both Improved Fireball and Ignite and is using Fireball Rank 12. Options are included for world buffs which increase your critical strike chance or multiplicative adjust your total intellect in the case of the Spirit of Zandalar buff. 

Notable options which are intentionally not included are Gnome racial, Power Infusion, trinkets and improved scorches. These factors will scale up your damage proportionally for any gear load out that you select such that they can be ignored as constant multiples. 

## Under the Hood

For an explanation of the method please see the write up included as [Application Write Up](https://github.com/MuirTheMage/ProbabilisticFireAnalysis/blob/master/ApplicationWriteUp.pdf).
