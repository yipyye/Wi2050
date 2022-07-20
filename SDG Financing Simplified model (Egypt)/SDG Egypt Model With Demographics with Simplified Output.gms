$title SDG Financing Simplified model Egypt_ commented and cleaned by Philo and Yip
$stitle Last Updated: July 20, 2022


************
* Settings *
************

$ontext
This section contains the set declaration and imported parameters(to be added).
$offtext

*Set Declaration
*****************

*Define the years 2022-2030 as well as the starting and ending year
Set     t /2022*2050/
        tstart(t)   First Period tstart(t)
        tend(t)     Last Period tend(t)
;

tstart(t) = yes$(ord(t) eq 1);
tend(t) = yes$(ord(t) eq card(t));

*Define education levels: primary, p; lower secondary, ls; upper secondary, us; tertiary, t;
set e /nos,ps,ls,us,ts/;
alias(e,ea);

*Define gender
set g /male,female/;

*Define survival rates by gender for [target country] and high-income country
set surv /megypt,fegypt,mhic,fhic/;

*Define fertility rates for [target country] and high-income country
set fer /egypt,hic/;

*Define age elements from 1-100
*sets and subsets for age
set a /1*100/
    a1(a)       Age 1 (for births)
    aw(a)       Working age between 12 and 65
    af2049(a)   Age between 20 and 49
    an(a)       age 6 group (asc) 
    ap(a)       Primary age
    als(a)      Lower secondary age
    af(a)       Fertile age between 15 and 49
    aus(a)      Upper secondary age
    ater(a)     Tertiary age
    as(a)       School age between 12 and 23
    asc(a)      Age 7 to 22 group
    ;
    
a1(a) = yes$(ord(a) eq 1);
an(a) = yes$(ord(a) eq 6);
ap(a) = yes$(ord(a) ge 7 and ord(a) le 12);
als(a) = yes$(ord(a) ge 13 and ord(a) le 15);
aus(a) = yes$(ord(a) ge 16 and ord(a) le 18);
ater(a) = yes$(ord(a) ge 19 and ord(a) le 22);
as(a) = yes$(ord(a) ge 6 and ord(a) le 23);
asc(a) = yes$(ord(a) ge 7 and ord(a) le 22);
aw(a) = yes$(ord(a) ge 12 and ord(a) le 65);
af2049(a) = yes$(ord(a) ge 20 and ord(a) le 49);
af(a) = yes$(ord(a) ge 15 and ord(a) le 49);

*Give another name (aa) to the previously declared set as
*alias(as,aa); comment out:not used in this model

**Define scenarios for low and high cases** 
*set scen /low , high/; comment out: no scen in this model



$onText
Comment out: parameters with s means by senario, not used in this model

**Define parameters(all by scenario and year)**
***********************
*need to delete the scenario sets
parameter   debtgdps(t)    Debt to GDP ratio 
            conpcs(t)      Consumption per capita, 
            kffs(t)        Capital to produce energy with fossil fuels
            kres(t)        Capital to produce energy with renewables
            kfs(t)         Infrastructure capital stock
            wages(e,t)     Wages by education level
            ktots(t)       Total capital
            mpks(t)        Marginal product of capital 
            qs(t)          Output 
            qpcs(t)        Output per capita
            ks(t)          Capital stock
            edcostgdps(t)  Education cost of GDP
            invs(t)        Investment
            schoolshs(t)   Share of population in school
            schoolyrs(t)   Schooling years
            tfrts(t)       ?? Not used in this model 
            tfrs(t)        Total fertility rate
            poptots(t)     Totoal population 
            edcosts(t)     Education cost
            enrollrates(t) Enrollment rates 
            birthrates(t)  Birth rate
            fertshs       Fertility share 
            ;

$offText

$offOrder

**Production function coefficients**

*Production function coefficients on labor by sector and education(bed)
*parameter bed(e);

parameter   bk      bk coefficient on business capital stock (plant and equipment) in the production function
            bkf     bkf coefficient on infrastructure capital in the production function
            ben     ben coefficient on power in the production function
            k0      k0 initial capital stock (2022)
            kf0     kf0 initial infrastructure capital stock
            ;

***gdx file ****
bk = .25;
bkf = .10;
ben = .05;
k0 = 20;
KF0 = 3;

**maybe need to declare after gdx file input
Parameters  blab    blab coefficient on labor is remainder after subtract share for business capital infrastructure and energy ;
blab = 1-bk-bkf-ben;



**Define some hardcoded variables**
scalar
*          ek                   Demand for capital stock(?)
           costff               Cost of fossil fuel generation
           costre               Cost of renewable energy generation
           dep                  Depreciation
           r                    Interest rate
           kff0                 Initial fossil fuel capital stock
           kre0                 Initial reneable energy capital stock
           aff                  Percentage of fossil fuel capital required as input to produce energy
*           taxlim               Tax limit
*           min0                 Production of mining sector in 2022 at time period 0
*          land0                Production of land in 2022 at time period 0
           tfp1                 Total factor productivity at time period 1(?)
           phi                  Unit cost of investment increases with growth rate
           ;

***gdx file ****
       
*ek = .10;
costff = 1;
costre = 3;
*hc = .002;
dep = .05;
r = .05;
kff0 = 10;
kre0 = 1;
aff = .25;
*taxlim = .5;
*min0 = 10;
*land0 = 20;
tfp1 = 1;
phi = .20;

**maybe need to declare after gdx file input
Parameters debtqlim        Define maximum debt to GDP ratio;
debtqlim = 10;
Parameters  disc(t)         Discount factor defined by interest rate and target year ;
disc(t) = 1/(1+r)**(ord(t)-1);


**Some initial variables**
parameter        
            popg0(a,g)      Initial population by age and gender
            fert0(a,fer)    Initial fertility by age
            surv0(a,surv)   Initial survival rates by age
            w0(a,a,g)       Initial working age population by age and gender
            s0(a,g)         Initial school achievement by age and gender
            ferthic0(a,fer) Initial high-income country fertility by age
            ;

*read in data
$CALL GDXXRW egyptdatainput.xlsx Index=Index!a1 trace=3
$GDXIN egyptdatainput.gdx
$LOAD popg0=D1 fert0= D2 surv0=D3 w0=D4 s0=D5 ferthic0=D6
$GDXIN

fert0(a,"hic") = ferthic0(a,"hic");

display popg0,fert0,surv0,w0,s0,ferthic0;


*initial setting
parameter   tfr0(fer)         Initial total fertility rate;
tfr0(fer) = sum(af,fert0(af,fer));

parameter   survive0(a,g)     Initial survival rate by age and gender;
survive0(a,"female") = surv0(a,"fegypt");
survive0(a,"male") = surv0(a,"megypt");

parameter   survivehi0(a,g)   Initial high-income survival rate by age and gender;
survivehi0(a,"female") = surv0(a,"fhic");
survivehi0(a,"male") = surv0(a,"mhic");
            

parameter   lfep(e,t)       Labor force by education and year
            poptotp(t)      Total school population by year
            schooltotp(t)   ??Total school enrollment by year
            lfp(t)           Total labor force by year
            ;

scalar fertsh;
fertsh = .5;

** gdx file **
parameter years(e)
/nos 0
 ps 6
 ls 9
 us 12
 ts 16/;


*Variable declaration
*********************
positive variables    lfe(e,t)              Labor force as a function of education and year
                      schoolsh(t)           Total school population share as a function of year
*                      schooltsa(t)          School age as a function of year
                      q(t)                  Output
                      qpc(t)                Output per capita
*                      gdp(t)                GDP
*                      gdpt(t)               Total GDP(? same as gdptot?)
*                      gdptpc(t)             GDP Total per capita(? same as gdppc?)
*                      emp(t)                Employment as a function of sector and year
                      hc(t)                 Human capital
                      k(t)                  Business capital as a function of year
                      con(t)                Consumption
*                      tx(t)                 Taxes
                      conpc(t)              Consumption per capita
                      mpk(t)                Marginal product of capital
*                      land(t)               Land
*                      min(t)                Mining
                      edcost(t)             Education cost
                      edcostgdp(t)          Edu cost as ratio to GDP           
                      ktot(t)               Total capital stock
                      efflabor(a,t)         Labor measured in efficiency units by age           
                      efflabtot(t)          Total labor measured in efficiency units
*                      scgdp(t)
                      kff(t)                Capital stock for fossil fuel energy production by year
                      kre(t)                Capital stock for renewable energy production by year
*                      he(t)
                      en(t)                 Energy
*                      entot(t)              Total energy
                      enh(t)                Housing energy
                      enhpc(t)              Housing energy per capita
                      invff(t)              Investment in fossil fuels
                      invre(t)              Investment in renewable energy
                      ff(t)                 Fossil fuels
                      invf(t)               Investment for capital infrastructure
*                      kh(t)                 Capital for housing
*                      invh(t)               Investment in housing
*                      hspc(t)               Housing per capita           
                      kf(t)                 Infrastructure capital
*                      ktot(t)               Total capital stock
*                      lqp(t)
*                      lsub(t)
*                      gov(t)                Government expenditure
*                      gdptot(t)             Total GDP(? same as gdpt?)
*                      pn(t)                 Price of non-tradeables
                      debt(t)               Debt level
                      debtgdp(t)            Debt-GDP ratio
*                      cont12(t)
*                      govgdp(t)             Government expenditure as % of GDP
*                      reserve(t)            Reserve levels
                      hlcost(t)             Health cost
                      control(t)
*                      healthpc(t)           Health per capita           
                      hlcostgdp(t)          Health cost-GDP ratio       
*                      schoolpop(t)          Total school population                   
                      cont(a,t)             Continuation rate
                      s(a,g,t)              Schooling as a function of age gender and year
                      leave(a,a,g,t)        School dropout rate as a function of two age elements gender and year           
*                      neet(a,a,t)           Not in education employment or training           
                      school(e,t)           School enrollment at level           
                      schooltot(t)          Total school enrollment           
*                      schoolc(t)            School completion
                      ps(t)                 Primary school
                      ls(t)                 Lower secondary
                      us(t)                 Upper secondary
                      ts(t)                 Tertiary
                      lse(t)                Lower secondary enrollment
                      use(t)                Upper secondary enrollment
                      tse(t)                Tertiary enrollment
                      eattain(a,t)          Educational attainment           
                      w(a,a,g,t)            Working population
*                      worka(a,t)            Working age
                      pop(a,g,t)            Age and gender-specific population
                      poptot(t)             Total population
                      noa(t)                Labor force that did not complete primary school
                      pa(t)                 Primary attainment           
                      lsa(t)                Lower secondary attainment
                      usa(t)               Upper secondary attainment
                      tsa(t)                Tertiary attainmen
                      lf(t)                 Total labor force
*                      h(t)                  Housing
                      birth(t)              Birth number
                      fert(a,a,t)           Fertility           
                      inv(t)                Investment
                      schoolyr(t)           Scooling years          
                      cinv(t)               Cost of investment
                      cinvff(t)             Cost of investment in fossil fuels
                      cinvf(t)              Cost of investment in infrastructure
                      cinvre(t)             Cost of investment in renewable energy
                      schoolage(t)          Schooling age           
                      enrollrate(t)         Enrollment rate
                      birthrate(t)          Birth rate           
                      fbyage(a,t)           Fertile female by age           
                      tfr(t)                Total fertility rate
                      invfgdp(t)            Investment in infrastructure-GDP ratio           
                      pubgdp(t)             Cost of public administration as a percent of total GDP
                      outlaygdp(t)          Percent of GDP spent on education\healthcare\public administration\infrastructure           
                      edunitcost(t)         Cost of education per unit of consumption by the students           
                      hlunitcost(t)         Cost of healthcare per unit of consumption by the total population           
                      gcost(t)              Government spending
                      ;               



Variable            util            Main utility variable
                    ut(t)           Utility by year
                    wage(e,t)       Wage as a function of education level and time
                    nx(t)           Net exports by year
                    test
                    ;


Equations
                    eq1(a,g,t)     Student population by age and gender at t+1 is those who continued at t
                    eq2(g,t)       All 6 year-olds enroll in elementary school when they turn 7
                    eq3(a,g,t)     Population by age and gender at t+1 is those who survived at t
                    eq4(a,a,t)     Fertility rate depends on local values for females with less than 12 yrs of education and depends on a mix of local values and high income country average fertility rate for those with more than 12 yrs of education
                    eq5(t)         Expected births at time t after accounting for female education
                    eq6(a,g,t)     Equalizes gender ratio at birth
                    eq7(t)         Total population enrolled in primary school (assuming 100% continuation)
                    eq8(t)         Total population enrolled in lower secondary school
                    eq9(t)         Total population enrolled in upper secondary school
                    eq10(t)        Total population enrolled in tertiary school
                    eq11(t)        Lower secondary school enrollment rate
                    eq12(t)        Upper secondary school enrollment rate
                    eq13(t)        Tertiary school enrollment rate
                    eq14(t)        Total population in school (primary lower sec upper sec tertiary)
                    eq15(a,a,g,t)  Total drop-outs from school at each age (without double counting)
                    eq16(a,a,g,t)  Total eligible-for-work population by age and gender at t+1 equals those already working at t plus new drop-outs
                    eq17(a,g,t)    No one of age 12 is eligible for work
*eq18(a,t)
                    eq19(a,t)      Total eligible-for-work population given a certain level of education attainment
                    eq19a(t)       No one of age 1 should be eligible for work
                    eq19b(t)       No one of age 2 should be eligible for work
                    eq19c(t)       No one of age 3 should be eligible for work
                    eq19d(t)       No one of age 4 should be eligible for work
                    eq19e(t)       No one of age 5 should be eligible for work
                    eq20(t)        Total labor force summed by educational attainment per year
                    eq21(t)        Primary attainment in year t as sum of attainment for 12 13 and 14 year olds
                    eq21a(t)       Labor force that did not complete primary school (assumes 100% labor force participation here)
                    eq22(t)        LS attainment in year t as sum of attainment for 15 16 and 17 year olds
                    eq23(t)        US attainment as sum of attainment for 18 19 20 and 21 year olds
                    eq24(t)        TER attainment as sum of attainment for 22 year olds
                    eq25(t)        Total population summation at time t
                    eq26(t)        Total population enrolled in primary at time t
                    eq27(t)        Total population enrolled in lower secondary at time t
                    eq28(t)        Total population enrolled in upper secondary at time t
                    eq29(t)        Total population enrolled in tertiary at time t eq30(t)
                    eq30a(t)       Enables "lfe" to track labor force that did not complete primary school
                    eq30(t)        Enables "lfe" to track labor force that completed primary school but did not complete lower secondary school or higher
                    eq31(t)        Enables "lfe" to track labor force that completed lower secondary school but did not complete upper secondary school or higher
                    eq32(t)        Enables "lfe" to track labor force that completed upper secondary school but did not complete tertiary school
                    eq33(t)        Enables "lfe" to track labor force that completed tertiary school
                    eq34(t)        Percentage of total population in school at time t
                    eq36(a,g)      Education for school-aged people in 2022
                    eq37(a,g)      Population in 2022
                    eq38(a,a,g)    Worker population in 2022
                    eq39(t)        Set continuation rate = 0.95 at age 12
                    eq40(t)        Set continuation rate = 1 at age 13
                    eq41(t)        Set continuation rate = 1 at age 14
                    eq42(t)        Set continuation rate = 1 at age 16
                    eq43(t)        Set continuation rate = 1 at age 17
                    eq44(t)        Set continuation rate = 1 at age 19
                    eq45(t)        Set continuation rate = 1 at age 20
                    eq46(t)        Set continuation rate = 1 at age 21
                    eq47(t)        Set continuation rate = 1 at age 15
                    eq48(t)        Set continuation rate = 0.5 at age 18
                    eq49(t)        Set continuation rate = 0 at age 22 
                    eq50
                    eq51(t)        Average years of schooling received by the country's work-eligible population
                    eq52(a,t)      Labor measured in efficiency units by age (assuming each year of schooling makes a worker roughly 10% more efficient)
                    eq53(t)        Total labor measured in efficiency units
                    eq54(t)        Human capital equals average labor in efficiency units per worker
                    eq55(t)        Set continuation rate = 1 at age 7
                    eq56(t)        Set continuation rate = 1 at age 8
                    eq57(t)        Set continuation rate = 1 at age 9
                    eq58(t)        Set continuation rate = 1 at age 10
                    eq59(t)        Set continuation rate = 1 at age 11
                    eq60(t)        Set continuation rate = 1 at age 6
                    eq61(t)        Total population of school age (7-22)
                    eq62(t)        School enrollment rate
                    eq63(t)        Expected brith rate equals expected births divided by total population at time t
                    eq64(a,t)      Fertile female by age
                    eq65(t)        Total fertility rate at time t equals the sum of fertility rates given years of education and age
                    ;
                 

eq1(as+1,g,t+1)..  s(as+1,g,t+1) =e= cont(as,t)*s(as,g,t);
eq2(g,t+1)..  s("7",g,t+1) =e= pop("6",g,t);
eq3(a+1,g,t+1)..  pop(a+1,g,t+1) =e= pop(a,g,t)*survive0(a,g);
eq4(af,as,t)..  fert(af,as,t) =e= w(af,as,"female",t)*fert0(af,"egypt")$(ord(as) lt 12) + w(af,as,"female",t)*(fertsh*fert0(af,"egypt")+(1-fertsh)*fert0(af,"hic"))$(ord(as) ge 12);
eq5(t)..   birth(t) =e= sum(af,sum(as,fert(af,as,t)));
eq63(t)..  birthrate(t) =e= birth(t)/poptot(t);
eq64(af,t)..  fbyage(af,t) =e= sum(as,w(af,as,"female",t));
eq65(t)..  tfr(t) =e= sum(af,sum(as,fert(af,as,t)/fbyage(af,t)));
eq6(a1,g,t+1)..   pop(a1,g,t+1) =e= 0.5*birth(t);
eq7(t)..  ps(t) =e=  sum(ap,sum(g,pop(ap,g,t)));
eq8(t)..  ls(t) =e=  sum(als,sum(g,s(als,g,t)));
eq9(t)..  us(t) =e=  sum(aus,sum(g,s(aus,g,t)));
eq10(t)..  ts(t) =e=  sum(ater,sum(g,s(ater,g,t)));
eq61(t)..  schoolage(t) =e= sum(asc,sum(g,pop(asc,g,t)));
eq62(t)..  enrollrate(t) =e= schooltot(t)/schoolage(t);
eq11(t).. lse(t) =e= ls(t)/(.0001+sum(als,sum(g,pop(als,g,t))));
eq12(t).. use(t) =e= us(t)/(.0001+sum(aus,sum(g,pop(aus,g,t))));
eq13(t).. tse(t) =e= ts(t)/(.0001+sum(ater,sum(g,pop(ater,g,t))));
eq14(t).. schooltot(t) =e= ps(t) + ls(t) + us(t) + ts(t);
eq15(aw,as,g,t).. leave(aw,as,g,t) =e= (1-cont(as,t))*s(as,g,t)$(ord(aw)+6 eq ord(as));
eq16(aw+1,as,g,t+1).. w(aw+1,as,g,t+1) =e= w(aw,as,g,t)$(ord(aw)+6 ge ord(as)) + leave(aw,as,g,t)$(ord(aw)+6 eq ord(as)) + 0$(ord(aw)+6 lt ord(as));;
eq17(as,g,t+1).. w("12",as,g,t+1) =e= 0;
*eq18(af,t).. worka(af,t) =e= sum(as,sum(g,w(af,as,g,t)));
eq19(as,t).. eattain(as,t) =e= sum(aw,sum(g,w(aw,as,g,t)));
eq19a(t).. eattain("1",t) =e= 0;
eq19b(t).. eattain("2",t) =e= 0;
eq19c(t).. eattain("3",t) =e= 0;
eq19d(t).. eattain("4",t) =e= 0;
eq19e(t).. eattain("5",t) =e= 0;
eq20(t).. lf(t) =e= sum(as,eattain(as,t));
eq21a(t).. noa(t) =e= sum(as$(ord(as) ge 1 and ord(as) le 5),eattain(as,t));
eq21(t).. pa(t) =e= eattain("12",t) + eattain("13",t) + eattain("14",t) ;
eq22(t)..  lsa(t) =e= eattain("15",t)+eattain("16",t)+eattain("17",t);
eq23(t)..  usa(t) =e= eattain("18",t)+eattain("19",t)+eattain("20",t)+eattain("21",t);
eq24(t)..  tsa(t) =e= eattain("22",t);
eq25(t)..  poptot(t) =e= sum(a,sum(g,pop(a,g,t)));
eq26(t).. school("ps",t) =e= ps(t);
eq27(t).. school("ls",t) =e= ls(t);
eq28(t).. school("us",t) =e= us(t);
eq29(t).. school("ts",t) =e= ts(t);
eq30a(t).. lfe("nos",t) =e= noa(t);
eq30(t).. lfe("ps",t) =e= pa(t);
eq31(t).. lfe("ls",t) =e= lsa(t);
eq32(t).. lfe("us",t) =e= usa(t);
eq33(t).. lfe("ts",t) =e= tsa(t);
eq34(t).. schoolsh(t) =e= schooltot(t)/poptot(t);
eq36(as,g).. s(as,g,"2022") =e= s0(as,g);
eq37(a,g).. pop(a,g,"2022") =e= popg0(a,g);
eq38(aw,as,g).. w(aw,as,g,"2022") =e= w0(aw,as,g);
eq39(t).. cont("12",t) =e= 0.95;
eq40(t).. cont("13",t) =e= 1;
eq41(t).. cont("14",t) =e= 1;
eq42(t).. cont("16",t) =e= 1;
eq43(t).. cont("17",t) =e= 1;
eq44(t).. cont("19",t) =e= 1;
eq45(t).. cont("20",t) =e= 1;
eq46(t).. cont("21",t) =e= 1;
eq47(t).. cont("15",t) =e= 1;
eq48(t).. cont("18",t) =e= .5;
eq49(t).. cont("22",t) =e= 0;
eq50.. test =e= sum(t,control(t)*control(t));
eq51(t).. schoolyr(t) =e= sum(a,eattain(a,t)*(ord(a)-6))/sum(a,.000001+eattain(a,t));
eq52(as,t).. efflabor(as,t) =e= exp(.1*ord(as))*eattain(as,t);
eq53(t).. efflabtot(t) =e= sum(as,efflabor(as,t));
eq54(t).. hc(t) =e= efflabtot(t)/(.00001+lf(t));
eq55(t).. cont("7",t) =e= 1;
eq56(t).. cont("8",t) =e= 1;
eq57(t).. cont("9",t) =e= 1;
eq58(t).. cont("10",t) =e= 1;
eq59(t).. cont("11",t) =e= 1;
eq60(t).. cont("6",t) =e= 1;

model demo using /all/;

*eattain.lo(a,t) = .00001;

Equations 
                    utilt(t)        Utility function by year
                    utility         Total utility summed and discounted over time
                    output(t)       Defines Cobb-Douglas style output func with energy capital infrustructure capital and labor
                    outputpc(t)     Total GDP per capita at time t
                    ewage(e,t)      Wage by education and time t given as marginal cost of labor
                    kstart(t)       Initial capital stock for each sector at t0
                    kfstart(t)      Initial infrastructure capital stock
                    kffstart(t)     Initial capital stock for energy from fossil fuels given as 0
                    krestart(t)     Initial capital stock for energy from renewables given as 0
                    knext(t)        Motion of capital: next period equals current + invest - depreciate
                    kfnext(t)       Motion of infrastructure capital
                    kffnext(t)      Motion of fossil fuel capital
                    krenext(t)      Motion of renewable capital
                    kfend(t)        Infrastructure capital at end setting depreciation=investment
                    ktotal(t)       Total capital stock in the economy
                    energy(t)       Capital in the power sector is the sum of fossil and renewable capital
                    ffuel(t)        FF energy generated as product of FF capital and FF capital intensity
                    conlim(t)       Consumption limit 
                    education(t)    Cost of education (assumes wages are the same for a output-producing worker and a teacher as long as they have the same level of education)
                    edugdp(t)       Cost of education as a percent of total GDP
                    dstart(t)       Initial debt at t0 given as 0
                    tbalance(t)     GDP solved for net exports
                    totdebt(t)      Debt incurred from foreign trade?
                    debttogdp(t)    Debt-GDP ratio calculation
                    debtlimit(t)    Defines the debt-GDP ratio limit
                    conend(t)       Defines end output
                    consumetrpc(t)  Consumption per capita in tradeable sectors
                    kend(t)         Capital at end by sector setting final investment = depreciation
                    kffend(t)       FF capital at end
                    kreend(t)       RE capital at end
                    costk(t)        Total cost of investment in output-producing and social service capital stock (unit cost increases linearly in growth rate)
                    costkf(t)       Total cost of investment in infrastructure capital stock
                    costkff(t)      Total cost of investment in fossil fuel capital stock
                    costkre(t)      Total cost of investment in renewable energy capital stock
                    health(t)       Cost of healthcare (assumes wages are the same for a output-producing worker and a healthcare worker as long as they have the same level of education)
                    govcost(t)      Government spending (assumed to be 10% of output each year)
                    hlgdp(t)        Cost of healthcare as a percent of total GDP
                    pubadgdp(t)     Cost of public administration as a percent of total GDP    
                    infgdp(t)       Cost of investment in infrastructure as a percent of total GDP
                    poutlay(t)      Percent of GDP spent on education \ healthcare \ public administration \ infrastructure
                    educationuc(t)  Cost of education per unit of consumption by the students
                    healthuc(t)     Cost of healthcare per unit of consumption by the total population
*taxmax(t),
                    marginalpk(t)   Marginal product of capital given as capital production over total capital
                    ;


*output(t)..           q(t) =e= tfp1*en(t)**ben*kf(t)**bkf*k(t)**bk*prod(e,lfep(e,t)**bled(e));
output(t)..           q(t) =e= tfp1*en(t)**ben*kf(t)**bkf*k(t)**bk*efflabtot(t)**blab;
outputpc(t)..         qpc(t) =e= q(t)/poptotp(t);
*ewage(e,t)..          wage(e,t) =e= bled(e)*q(t)/lfep(e,t);
ewage(e,t)..          wage(e,t) =e= blab*q(t)/efflabtot(t)*exp(.1*years(e));
marginalpk(t)..       mpk(t) =e= bk*q(t)/k(t);
kstart(tstart)..      k(tstart) =e= k0;
dstart(tstart)..      debt(tstart) =e= 0;
kffstart(tstart)..    kff(tstart) =e= kff0;
krestart(tstart)..    kre(tstart) =e= kre0;
kfstart(tstart)..     kf(tstart) =e= kf0;
knext(t+1)..          k(t+1) =e= k(t)*(1-dep) + inv(t);
kffnext(t+1)..        kff(t+1) =e= kff(t)*(1-dep) + invff(t);
krenext(t+1)..        kre(t+1) =e= kre(t)*(1-dep) + invre(t);
kfnext(t+1)..         kf(t+1) =e= kf(t)*(1-dep) + invf(t);
energy(t)..           en(t) =e= kff(t) + kre(t);
ffuel(t)..            ff(t) =e= aff*kff(t);
costkff(t)..          cinvff(t) =e= costff*invff(t)*(1+phi*(invff(t)/kff(t)));
costkre(t)..          cinvre(t) =e= costre*invre(t)*(1+phi*(invre(t)/kre(t)));
costkf(t)..           cinvf(t) =e= invf(t)*(1+phi*(invf(t)/kf(t)));
costk(t)..            cinv(t) =e= inv(t)*(1+phi*(inv(t)/k(t)));
tbalance(t)..         nx(t) =e= q(t) - cinv(t) - cinvf(t) - con(t) - hlcost(t) - edcost(t) - gcost(t) - cinvff(t) - cinvre(t) - ff(t);
totdebt(t+1)..        debt(t+1) =e= (1+r)*debt(t) - nx(t);
debttogdp(t)..        debtgdp(t) =e= debt(t)/q(t);
debtlimit(t)..        debtgdp(t) =l= debtqlim;
conlim(t)..           con(t) =l= q(t) - dep*(k(t)+kf(t)+kre(t)+kff(t)) - r*debt(t) - (edcostgdp(t)+hlcostgdp(t)+pubgdp(t))*q(t) -ff(t);
conend(tend)..        con(tend) =e= q(tend) - cinv(tend) - cinvf(tend) - cinvff(tend) - cinvre(tend) - r*debt(tend) - (pubgdp(tend)+edcostgdp(tend)+hlcostgdp(tend))*q(tend)-ff(tend);
kend(tend)..          k(tend)*dep =e= inv(tend);
kffend(tend)..        kff(tend)*dep =e= invff(tend);
kreend(tend)..        kre(tend)*dep =e= invre(tend);
kfend(tend)..         kf(tend)*dep =e= invf(tend);
ktotal(t)..           ktot(t) =e= k(t) + kf(t) + kff(t) + kre(t);
consumetrpc(t)..      conpc(t) =e= con(t)/poptotp(t);
educationuc(t)..      edunitcost(t) =e= 2*((1/10)*wage("ts",t)+(1/10)*wage("us",t))/qpc(t);
healthuc(t)..         hlunitcost(t) =e= 2*((1/50)*wage("ts",t)+(1/50)*wage("us",t))/qpc(t);
education(t)..        edcost(t) =e= edunitcost(t)*schooltot(t);
health(t)..           hlcost(t) =e= hlunitcost(t)*poptot(t);
govcost(t)..          gcost(t) =e= 0.10*q(t);
edugdp(t)..           edcostgdp(t) =e= edcost(t)/q(t);
hlgdp(t)..            hlcostgdp(t) =e= hlcost(t)/q(t);
poutlay(t)..          outlaygdp(t) =e= edcostgdp(t) + hlcostgdp(t) + pubgdp(t) + invfgdp(t);
pubadgdp(t)..         pubgdp(t) =e= .10;
infgdp(t)..           invfgdp(t) =e= cinvf(t)/q(t);
utilt(t)..            ut(t) =e= log(conpc(t));
utility..             util =e= sum(t,disc(t)* ut(t)) + (1/r)*sum(tend,disc(tend)*ut(tend));


model sdgfinance using /all/;

poptot.lo(t) = .00001;
en.lo(t) = .001;
tsa.lo(t) = .00001;
pop.lo(a,g,t) = .00000001;
k.lo(t) = .001;
kf.lo(t) = .001;
kff.lo(t) = .001;
kre.lo(t) = .001;
conpc.lo(t) = .001;
q.lo(t) = .0001;
qpc.lo(t) = .0001;
enh.lo(t) = .001;
enhpc.lo(t) = .001;
kf.lo(t) = .001;
schooltot.lo(t) = .001;
schoolage.lo(t) = 001;
fbyage.lo(a,t) = .001;

$onText

parameter           debtqlim            Upper limit of debt to GDP ratio
                    ;

debtqlim = 10;
r=.05;


parameter           dlim(scen)          Upper limit of debt to GDP ratio by scenario

/low   10
 high 10/;

parameter           rs(scen)            Interest rate by scenario

/low 0.15
high 0.05/;

parameter           taxmaxs(scen)       Taxation limit by scenario
/low  0.1
high 0.4/;

parameter           fertshs             Weight on high-income country fertility rate for females with more than 12 years of education
/low .5
 high 0/;

debtqlim = 10;
r = .05;
taxlim = .4;
fertsh = .5;
$offText


solve demo minimizing test using dnlp;
*lfep(e,t) = lfe.L(e,t);
*lfp(t) = lf.L(t);
poptotp(t) = poptot.L(t);
schooltotp(t) = schooltot.L(t);
solve sdgfinance maximizing util using dnlp;
display qpc.L, edcostgdp.L, hlcostgdp.L, invfgdp.L, outlaygdp.L;
