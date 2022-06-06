*Define 2022 initial capital(k0), initial infrastructure capital(kf0), initial capital to produce fossil fuel energy(kff0), initial capital to produce renewable energy(kre0)
*initial population for USA in million (populusa0,popus0), initial GDP per capita for USA in thousand dollar(gdppc0,gdppcus0), captial factor for USA ??efficiency??(kfactorusa) 
scalar k0,kf0,kff0,kre0,populusa0,popus0,gdppc0,gdppcus0,kfactorusa;
popus0 = 330;
populusa0 = 330;
gdppcus0 = 60;
kfactorusa = 1;
k0 = 55000*kfactorusa*(populusa0/popus0);
kf0 = 22000*kfactorusa*(populusa0/popus0);
kff0 = 1100*kfactorusa*(populusa0/popus0);
kre0 = 110*kfactorusa*(populusa0/popus0);
*Define the years 2022-2050 as well as the starting and ending year
set t /2022*2050/
tstart(t)
tend(t);
*Define start time as the first element in the time range
tstart(t) = yes$(ord(t) eq 1);
*Define end time as the last element in the time range
tend(t) = yes$(ord(t) eq card(t));

*set e is education: no schooling, nos; primary, p; lower secondary, ls; upper secondary, us; tertiary, ts;
set e /nos,ps,ls,us,ts/
*set es is the set with education larger or equal to 3 yrs
set es(e);
es(e) = yes$(ord(e) ge 3);

*Give another name (ea) to the previously declared set e
alias(e,ea);

*define g as gender
set g /male,female/;
*define survival rate(surv) and fertility rate(fer), male(m); female(f); high income countries(hic)
set surv /musa,fusa,mhic,fhic/;
set fer /usa,hic/;

*Sectors(sec): subsistence, agriculture(ag), mining(mine), construction(con), power(pow), manufacturing(man)
*professional services (traded), real estate(re), non-traded services(sern), traded services(sert), education(ed), health care(heal), public administration(pub)
*sect: tradable sectors
*secn: nontradable sectors

set sec /ag, mine, con, pow, man, re, sern, sert, ed, heal, pub/
sect(sec) /ag, mine, man, sert/
secn(sec) /con, pow, re, sern, ed, heal, pub/;

*sets and subsets for age
*define age 1 for births(a1); subset for working age ranges from 12 to 65(aw); subset for ages in the fertility range from 20 to 49(af2049);
*Primary age(ap); Lower secondary age(als); Fertile age between 15 and 49(af); Upper secondary age(aus); Tertiary age(ater); School age between 6 and 23(as)
*age 6 group(an); age 7 to 22 group(asc); age 16 to 100(ad)
           
set a /1*100/
a1(a), aw(a), af2049(a), an(a), ap(a), als(a), af(a), aus(a), ater(a), as(a), asc(a),ad(a);
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
ad(a) = yes$(ord(a) ge 16);

*Give another name (aa) to the previously declared set as
alias(as,aa);

*Define scenarios for low and high cases 
set scen /low , high/;

*define parameters(all by scenario and year): Debt to GDP ratio(debtgdps); Consumption per capita(conpcs)!!appear twice; Capital to produce energy with fossil fuels(kffs);
*Capital to produce energy with renewables(kres); Infrastructure capital stock(kfs); Wages byeducation level(wages); Total capital(ktots);
*Marginal product of capital(mpks)!!appear twice; Output(qs); output per capita(qpcs); business capital stock i.e. plant and equipment (kaps); education cost as a ratio to gdp(edcostgdps);
*Investment(invs); share of population in school(schoolshs)!!appear twice; schooling years??(schoolyrs); total fertility rate(tfrs);??tfrts??;
*total population(poptots); education cost(edcosts); school enrollment rate(enrollrates); birth rate(birthrates); fertility share(fertshs);
*Marginal product of infrastructure capital(mpkfs); Marginal product of energy capital(mpens); cost of investment in infrastructure to GDP ratio(cinvfshgdps);
*investment in infrastructure to GDP ratio(invfshgdps)      
   
parameter debtgdps(scen,t),conpcs(scen,t), kffs(scen,t),kres(scen,t), kfs(scen,t), wages(scen,e,t),ktots(scen,t),mpks(scen,t),conpcs(scen,t), qs(scen,t), qpcs(scen,t),kaps(scen,t), edcostgdps(scen,t),
invs(scen,t),schoolshs(scen,t),schoolyrs(scen,t), tfrts(scen,t),tfrs(scen,t),poptots(scen,t),edcosts(scen,t),enrollrates(scen,t),schoolshs(scen,t),birthrates(scen,t),fertshs(scen),
mpks(scen,t),mpkfs(scen,t),mpens(scen,t),cinvfshgdps(scen,t),invfshgdps(scen,t);


$offOrder

*Production function coefficients on labor by sector and education(bed)
parameter bed(sec,e);



*bk coefficient on business capital stock (plant and equipment) in the production function
parameter bk;
bk = .35;

*bkf coefficient on infrastructure capital in the production function
parameter bkf;
bkf = .10;

*ben coefficient on power in the production function
parameter ben;

ben = .05;



*Coeff. on labor is remainder after subtract share for business capital, infra, and energy(blab)
parameter blab;
blab = 1-bk-bkf-ben;

*Coeff. on labor by education level
parameter bledr(e)

/nos .002
ps .008
ls .04
us .35
ts  .6 /;

parameter bled(e),bleds(e);

*Coeff. on labor times coefficient on labor by education?? 
bled(e) = blab*bledr(e);
bleds("ls") = blab*(bledr("nos")+bledr("ps")+bledr("ls"));
bleds("us") = blab*(bledr("us"));
bleds("ts") = blab*(bledr("ts"));




*Demand for capital stock??why??(ek); Cost of fossil fuel generation(costff); Cost of renewable energy generation(costre); Depreciation(dep);
*Interest rate(r); Percentage of fossil fuel capital required as input to produce energy(aff); Tax limit(taxlim); Production of mining sector in 2022 at time 0(min0);
*Production of land in 2022 at time 0(land0); Total factor productivity at time 1??(tfp1); ??group of phis?? fossil fuel(phiff),  renewable energy(phire), infrastructure(phif), (phi)
*output per capita in 2022 at time 0(qpc0)

scalar ek, costff, costre, dep, r, aff, taxlim, min0, land0, tfp1, phiff, phire, phif, phi, qpc0;
qpc0 = 58.543;
ek = .10;
costff = 1;
costre = 3;
*hc = .002;
dep = .05;
r = .05;
aff = .25;
taxlim = .5;
min0 = 10;
land0 = 20;
tfp1 = 15;
phiff = 0;
phire = 0;
phif = 0;
phi = 0;

*Discount factor defined by interest rate and target year;

parameter disc(t);
disc(t) = 1/(1+r)**(ord(t)-1);

*Define maximum debt to GDP ratio
parameter debtqlim;

*Initial population by age and gender(popg0); Initial fertility by age(fert0); Initial survival rates by age(surv0);
*Initial working age population by age and gender(w0); Initial school achievement by age and gender(s0);
*Initial high-income country fertility by age(ferthic0); Total factor productivity by sector(tfp)

parameter popg0(a,g),fert0(a,fer),surv0(a,surv),w0(a,a,g),s0(a,g),ferthic0(a,fer),tfp(sec);

*read in data
$CALL GDXXRW usadatainput.xlsx Index=Index!a1 trace=3
$GDXIN usadatainput.gdx
$LOAD popg0=D1 fert0= D2 surv0=D3 w0=D4 s0=D5 ferthic0=D6
$GDXIN

fert0(a,"hic") = ferthic0(a,"hic");

display popg0,fert0,surv0,w0,s0,ferthic0;

*total fertility rate
parameter tfr0(fer);
tfr0(fer) = sum(af,fert0(af,fer));

*survival rate for USA and High Income Countries at time 0 for male and female
parameter survive0(a,g);
survive0(a,"female") = surv0(a,"fusa");
survive0(a,"male") = surv0(a,"musa");
parameter survivehi0(a,g);
survivehi0(a,"female") = surv0(a,"fhic");
survivehi0(a,"male") = surv0(a,"mhic");

*?? not appear in anywhere else??
parameter poptotp(t),schooltotp(t);

*Labor force participation rate by years of schooling

parameter pr(a)
/6  .45
 7  .45
 8  .45
 9  .45
10  .45
11  .45
12  .45
13  .45
14  .45
15  .45
16  .50
17  .60
18  .65
19  .65
20  .65
21  .65
22  .75/;

scalar fertsh;

*labor force in education
parameter lfed(e)

/ls  0
 us  0.1
 ts  0.1/;

*labor force in health
parameter lfhl(e)

/ls   0
 us   0.03
 ts   0.01/;

*capital stock in education; capital stock in health
scalar ked, khl;
ked = 1;
khl = 10;

*years corresponding to education level
parameter years(e)
/nos 0
 ps 6
 ls 9
 us 12
 ts 16/;

*define positive variables: lfe(e,t) Labor force as a function of education and year(!! appear twice), schoolsh(t) Total school population share as a function of year,
*schooltsa(t) School age as a function of year(!! appear twice), q(t) output, qpc(t) output per capita, gdp(t) GDP,gdps(t) Social service component of GDP, gdppc(t) GDP per capita, 
*gdpt(t) Total GDP (output and social services)(??difference with gdptot), gdptpc(t) GDP total per capita, emp(t) Employment as a function of sector and year, hc(t)(??housing consumption??),
*k(t) business capital as a function of year,kq(t) Capital stock for output production, ks(t) Capital stock for social services (education and healthcare), con(t) consumption, tx(t) taxes, conpc(t) consumption per capita,
*land(t) land ,min(t) mining, edcost(t) education cost(!! appear twice), edcostgdp(t) edu cost as ratio to GDP, ktot(t) total capital(!! appear twice), qpc(t) output per capita,
*efflabor(a,t) Labor measured in efficiency units by age, efflabtot(t) Total labor measured in efficiency units,scgdp(t)??, kff(t) Capital stock for fossil fuel energy production by year,
*kre(t) Capital stock for renewable energy production by year, he(t)??, en(t) Energy, entot(t) Total energy, enh(t) Housing energy,
*enhpc(t) Housing energy per capita, invff(t) Investment in fossil fuels, invre(t) Investment in renewable energy, ff(t) Fossil fuels, 
*invf(t) Investment for capital infrastructure, kh(t) Capital for housing, invh(t) Investment in housing, hspc(t) Housing per capita, 
*kf(t) Infrastructure capital, lqp(t)??,lsub(t)??, gov(t) Government expenditure, gdptot(t) total GDP??, pn(t) Price of non-tradeables, 
*debt(t) Debt level, debtgdp(t) Debt-GDP ratio, cont12(t)??, govgdp(t) Government expenditure as % of GDP, reserve(t) Reserve levels, 
*hlcost(t) health cost, control(t)??, healthpc(t) health per capita??, hlcostgdp(t) health cost-GDP ratio,
*schoolpop(t) Total school population, cont(a,t) Continuation rate, s(a,g,t) Schooling as a function of age gender and year, 
*leave(a,a,g,t) School dropout rate as a function of two age elements gender and year, neet(a,a,t) Not in education employment or training, 
*school(e,t) School enrollment at level, schooltot(t) Total school enrollment, schoolc(t) School completion, ps(t) Primary school,
*ls(t) Lower secondary, us(t) Upper secondary,ts(t) Tertiary,lse(t) Lower secondary enrollment, use(t) Upper secondary enrollment, tse(t) Tertiary enrollment,
*eattain(a,t) Educational attainment, w(a,a,g,t) Working population, worka(a,t) Working age, pop(a,g,t) Age and gender-specific population, poptot(t) Total population,
*noa(t) Labor force that did not complete primary school, pa(t) Primary attainment, lsa(t) Lower secondary attainment, upsa(t) Upper secondary attainment, tsa(t) Tertiary attainment, lf(t) Total labor force,
*h(t) Housing, birth(t) Birth rate, fert(a,a,t) Fertility, inv(t) Investment, schoolyr(t) scooling years, cinv(t) cost of investment,
*cinvff(t) cost of investment in Fossil fuels, cinvf(t) cost of investment in infrastructure, cinvre(t) cost of investment in renewable energy, debt(t) debt, debtgdp(t) debt-GDP ratio, 
*schoolage(t) schooling age, enrollrate(t) enrollment rate, birthrate(t) birthrate, fbyage(a,t) Fertile female by age,tfr(t) Total fertility rate, cinvfgdp(t) cost of investment in infrastructure-GDP ratio,
*pubgdp(t) Cost of public administration as a percent of total GDP,outlaygdp(t) Percent of GDP spent on education\healthcare\public administration\infrastructure, 
*edunitcost(t) Cost of education per unit of consumption by the students, hlunitcost(t)  Cost of healthcare per unit of consumption by the total population, gcost(t) Government spending,
*invfr(t) Growth rate of infrastructure capital, lfep(e,t)  labor force participation??, lfeptot(e,t) total labor force participation, lfepq(e,t) labor force participation in output production,
*lfeps(e,t) labor force participation in social services, lfp(t) total labor force participation ??;



positive variables lfe(e,t), schoolsh(t), schooltsa(t), q(t),qpc(t),gdp(t),gdps(t),gdppc(t), gdpt(t),gdptpc(t), emp(t), hc(t),
k(t),kq(t), ks(t), con(t), tx(t), conpc(t),land(t),min(t), edcost(t), edcostgdp(t),ktot(t), qpc(t), efflabor(a,t), efflabtot(t),
scgdp(t), kff(t),kre(t), he(t), en(t), entot(t),enh(t), enhpc(t), invff(t), invre(t), ff(t), invf(t), kh(t),invh(t),hspc(t),kf(t),ktot(t),
lqp(t),lsub(t), gov(t),gdptot(t), pn(t), debt(t), debtgdp(t), cont12(t), govgdp(t), reserve(t), edcost(t), hlcost(t),control(t), healthpc(t), hlcostgdp(t),
lfe(e,t), schoolpop(t), schooltsa(t), cont(a,t), s(a,g,t), leave(a,a,g,t),neet(a,a,t), school(e,t), schooltot(t), schoolc(t), ps(t),ls(t),us(t),ts(t),lse(t), use(t), tse(t),
eattain(a,t),w(a,a,g,t),worka(a,t), pop(a,g,t),poptot(t),noa(t), pa(t),lsa(t),upsa(t),tsa(t),lf(t),h(t),birth(t), fert(a,a,t), inv(t),schoolyr(t),
cinv(t),cinvff(t),cinvf(t),cinvre(t),debt(t),debtgdp(t), schoolage(t), enrollrate(t), birthrate(t),fbyage(a,t),tfr(t), cinvfgdp(t),pubgdp(t),outlaygdp(t),
edunitcost(t),hlunitcost(t),gcost(t),invfr(t),lfep(e,t),lfeptot(e,t),lfepq(e,t),lfeps(e,t),lfp(t);

*Main utility variable(util); Utility by year(ut); wage(wage); Net exports(nx)
variable util, ut(t), wage(e,t), nx(t),test;



Equations           eq1(a,g,t)          Student population by age and gender at t+1 is those who continued at t
                    eq2(g,t)            All 6 year-olds enroll in elementary school when they turn 7
                    eq3(a,g,t)          Population by age and gender at t+1 is those who survived at t
                    eq4(a,a,t)          Fertility rate depends on local values for females with less than 12 yrs of education and depends on a mix of local values and high income country average fertility rate for those with more than 12 yrs of education
                    eq5(t)              Expected births at time t after accounting for female education
                    eq6(a,g,t)          Equalizes gender ratio at birth
                    eq7(t)              Total population of age for primary school
                    eq8(t)              Total population of age for lower secondary school
                    eq9(t)              Total population of age for upper secondary school
                    eq10(t)             Total population of age for tertiary school
                    eq11(t)             Lower secondary school enrollment rate
                    eq12(t)             Upper secondary school enrollment rate
                    eq13(t)             Tertiary school enrollment rate
                    eq14(t)             Total population in school (primary lower sec upper sec tertiary)
                    eq15(a,a,g,t)       Total drop-outs from school at each age without double counting
                    eq16(a,a,g,t)       Total eligible-for-work population by age and gender at t+1 equals those already working at t plus new drop-outs
                    eq17(a,g,t)         Age 12 working population equals 0    
*eq18(a,t),
                    eq19(a,t)           Total eligible-for-work population given a certain level of education attainment
                    eq19a(t)            No one of age 1 should be eiligible for work
                    eq19b(t)            No one of age 2 should be eiligible for work
                    eq19c(t)            No one of age 3 should be eiligible for work
                    eq19d(t)            No one of age 4 should be eiligible for work
                    eq19e(t)            No one of age 5 should be eiligible for work
                    eq20(t)             Total labor force depends on labor force participation at each level of education attainment
                    eq21a(t)            Labor force that did not complete primary school (assumes 100% labor force participation)
                    eq21(t)             Labor force that completed primary school but did not complete lower secondary school or higher
                    eq22(t)             Labor force that completed lower secondary school but did not complete upper secondary school or higher
                    eq23(t)             Labor force that completed upper secondary school but did not complete tertiary school
                    eq24(t)             Labor force that completed tertiary school
                    eq25(t)             Total population at time t
                    eq26(t)             Enables "school" to track total population of age for primary school
                    eq27(t)             Enables "school" to track total population of age for lower secondary school
                    eq28(t)             Enables "school" to track total population of age for upper secondary school
                    eq29(t)             Enables "school" to track total population of age for tertiary school
                    eq30a(t)            Enables "lfe" to track labor force that did not complete primary school
                    eq30(t)             Enables "lfe" to track labor force that completed primary school but did not complete lower secondary school or higher
                    eq31(t)             Enables "lfe" to track labor force that completed lower secondary school but did not complete upper secondary school or higher
                    eq32(t)             Enables "lfe" to track labor force that completed upper secondary school but did not complete tertiary school
                    eq33(t)             Enables "lfe" to track labor force that completed tertiary school
                    eq34(t)
                    eq36(a,g),
                    eq37(a,g),
                    eq38(a,a,g),
                    eq39(t),
                    eq40(t),
                    eq41(t),
                    eq42(t),
                    eq43(t),
                    eq44(t),
                    eq45(t),
                    eq46(t),
                    eq47(t),
                    eq48(t),
                    eq49(t),
                    eq50,
                    eq51(t),
                    eq52(a,t),
                    eq53(t),
                    eq54(t),
                    eq55(t),
                    eq56(t),
                    eq57(t),
                    eq58(t),
                    eq59(t),
                    eq60(t),
                    eq61(t)             Total population of school age (7-22)
                    eq62(t)             School enrollment rate
                    eq63(t)             Expected brith rate equals expected births divided by total population at time t
                    eq64(a,t)           Fertile female by age
                    eq65(t)             Total fertility rate at time t equals the sum of fertility rates given years of education and age
                    eq66(e,t),
                    eq67(t),
                    eq68(t),
                    eq69(t),
                    eq70(t)
                    ;

eq1(as+1,g,t+1)..  s(as+1,g,t+1) =e= cont(as,t)*s(as,g,t);
eq2(g,t+1)..  s("7",g,t+1) =e= pop("6",g,t);
eq3(a+1,g,t+1)..  pop(a+1,g,t+1) =e= pop(a,g,t)*survive0(a,g);
eq4(af,as,t)..  fert(af,as,t) =e= w(af,as,"female",t)*fert0(af,"usa")$(ord(as) lt 12) + w(af,as,"female",t)*(fertsh*fert0(af,"usa")+(1-fertsh)*fert0(af,"hic"))$(ord(as) ge 12);
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
eq20(t).. lf(t) =e= sum(as,pr(as)*eattain(as,t));
eq21a(t).. noa(t) =e= sum(as$(ord(as) ge 1 and ord(as) le 5),eattain(as,t));
eq21(t).. pa(t) =e= pr("12")*eattain("12",t) + pr("13")*eattain("13",t) + pr("14")*eattain("14",t) ;
eq22(t)..  lsa(t) =e= pr("15")*eattain("15",t)+pr("16")*eattain("16",t)+pr("17")*eattain("17",t);
eq23(t)..  upsa(t) =e= pr("18")*eattain("18",t)+pr("19")*eattain("19",t)+pr("20")*eattain("20",t)+pr("21")*eattain("21",t);
eq24(t)..  tsa(t) =e= pr("22")*eattain("22",t);
eq25(t)..  poptot(t) =e= sum(a,sum(g,pop(a,g,t)));
eq26(t).. school("ps",t) =e= ps(t);
eq27(t).. school("ls",t) =e= ls(t);
eq28(t).. school("us",t) =e= us(t);
eq29(t).. school("ts",t) =e= ts(t);
eq30a(t).. lfe("nos",t) =e= noa(t);
eq30(t).. lfe("ps",t) =e= pa(t);
eq31(t).. lfe("ls",t) =e= lsa(t);
eq32(t).. lfe("us",t) =e= upsa(t);
eq33(t).. lfe("ts",t) =e= tsa(t);
eq34(t).. schoolsh(t) =e= schooltot(t)/poptot(t);
eq36(as,g).. s(as,g,"2022") =e= s0(as,g);
eq37(a,g).. pop(a,g,"2022") =e= popg0(a,g);
eq38(aw,as,g).. w(aw,as,g,"2022") =e= w0(aw,as,g);
eq39(t).. cont("12",t) =l= 1;
eq40(t).. cont("13",t) =e= 1;
eq41(t).. cont("14",t) =e= 1;
eq42(t).. cont("16",t) =e= 1;
eq43(t).. cont("17",t) =e= 1;
eq44(t).. cont("19",t) =e= 1;
eq45(t).. cont("20",t) =e= 1;
eq46(t).. cont("21",t) =e= 1;
eq47(t).. cont("15",t) =l= 1;
eq48(t).. cont("18",t) =l= .5;
eq49(t).. cont("22",t) =e= 0;
eq50.. test =e= sum(t,control(t)*control(t));
eq51(t).. schoolyr(t) =e= sum(a,eattain(a,t)*(ord(a)-6))/sum(a,.000001+eattain(a,t));
eq52(as,t).. efflabor(as,t) =e= exp(.1*ord(as))*pr(as)*eattain(as,t);
eq53(t).. efflabtot(t) =e= sum(as,efflabor(as,t));
eq54(t).. hc(t) =e= efflabtot(t)/(.00001+lf(t));
eq55(t).. cont("7",t) =e= 1;
eq56(t).. cont("8",t) =e= 1;
eq57(t).. cont("9",t) =e= 1;
eq58(t).. cont("10",t) =e= 1;
eq59(t).. cont("11",t) =e= 1;
eq60(t).. cont("6",t) =e= 1;

eq66(e,t).. lfep(e,t) =e= lfe(e,t);
eq67(t).. lfeptot("ls",t) =e= lfep("nos",t)+lfep("ps",t)+lfep("ls",t);
eq68(t).. lfeptot("us",t) =e= lfep("us",t);
eq69(t).. lfeptot("ts",t) =e= lfep("ts",t);
eq70(t).. lfp(t) =e= lf(t);

Equations
utilt(t), utility,  output(t), outputpc(t), ewage(e,t), labors(e,t), labormk(e,t),
kstart(t), kfstart(t), kffstart(t), krestart(t), knext(t), kfnext(t), kffnext(t),
krenext(t),kfend(t), energy(t), ffuel(t),
*conlim(t),
education(t), edugdp(t),
dstart(t), tbalance(t), totdebt(t), debttogdp(t),
*debtlimit(t),
conend(t), consumetrpc(t),
kend(t), kffend(t), kreend(t),ktotal(t), costk(t),costkre(t),costkff(t),costkf(t),
health(t),govcost(t),hlgdp(t), pubadgdp(t),
cinfgdp(t),
poutlay(t), educationuc(t),healthuc(t),
gdpsocial(t), gdptotal(t), gdppercap(t), capitals(t), capitaltot(t),
*invfmin(t),
invfrate(t);
*taxmax(t),
*marginalpk(t)
;

output(t)..           q(t) =e= tfp1*en(t)**ben*kf(t)**bkf*kq(t)**bk*prod(es,lfepq(es,t)**bleds(es));
labormk(es,t)..          lfeptot(es,t) =e= lfepq(es,t) + lfeps(es,t);
labors(es,t)..         lfeps(es,t) =e= lfed(es)*schooltot(t) + lfhl(es)*poptot(t);
*capitals(t)..          ks(t) =e= 0*ked*schooltot(t) + khl*poptot(t);
capitals(t)..           ks(t) =e= .2*gdps(t)/(r+dep);
capitaltot(t)..         k(t) =e= kq(t) + ks(t);
outputpc(t)..         qpc(t) =e= q(t)/poptot(t);
ewage(es,t)..          wage(es,t) =e= bleds(es)*q(t)/lfepq(es,t);
gdpsocial(t)..         gdps(t) =e= ks(t)*(r+dep)+ sum(es,lfeps(es,t)*wage(es,t));
gdptotal(t)..          gdpt(t) =e= q(t) + gdps(t);
gdppercap(t)..         gdppc(t) =e= gdpt(t)/poptot(t);

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
costkff(t)..          cinvff(t) =e= costff*invff(t)*(1+phiff*(invff(t)/kff(t)));
costkre(t)..          cinvre(t) =e= costre*invre(t)*(1+phire*(invre(t)/kre(t)));
costkf(t)..           cinvf(t) =e= invf(t)*(1+phif*(invfr(t)));
*invfmin(t)..          invfr(t) =g= dep;
invfrate(t)..         invfr(t) =e= invf(t)/kf(t);
costk(t)..            cinv(t) =e= inv(t)*(1+phi*(inv(t)/k(t)));
tbalance(t)..         nx(t) =e= q(t) - cinv(t) - cinvf(t) - con(t) - gcost(t) - cinvff(t) - cinvre(t) - ff(t);
totdebt(t+1)..        debt(t+1) =e= (1+r)*debt(t) - nx(t);
debttogdp(t)..        debtgdp(t) =e= debt(t)/q(t);
*debtlimit(t)..        debtgdp(t) =l= debtqlim;
*conlim(t)..           con(t) =l= q(t) - dep*(k(t)+kf(t)+kre(t)+kff(t)) - r*debt(t) - (edcostgdp(t)+hlcostgdp(t)+pubgdp(t))*q(t) -ff(t);
conend(tend)..        con(tend) =e= q(tend) - cinv(tend) - cinvf(tend) - cinvff(tend) - cinvre(tend) - r*debt(tend) - gcost(tend) - ff(tend);
kend(tend)..          k(tend)*dep =e= inv(tend);
kffend(tend)..        kff(tend)*dep =e= invff(tend);
kreend(tend)..        kre(tend)*dep =e= invre(tend);
kfend(tend)..         kf(tend)*dep =e= invf(tend);
ktotal(t)..           ktot(t) =e= k(t) + kf(t) + kff(t) + kre(t);
consumetrpc(t)..      conpc(t) =e= con(t)/poptot(t);
educationuc(t)..      edunitcost(t) =e= edcost(t)/schooltot(t)/qpc(t);
healthuc(t)..         hlunitcost(t) =e= hlcost(t)/poptot(t)/qpc(t);
education(t)..        edcost(t) =e= sum(es,wage(es,t)*lfed(es))*schooltot(t);
health(t)..           hlcost(t) =e= sum(es,wage(es,t)*lfhl(es))*poptot(t);
govcost(t)..          gcost(t) =e= 0.0*q(t);
edugdp(t)..           edcostgdp(t) =e= edcost(t)/gdpt(t);
hlgdp(t)..            hlcostgdp(t) =e= hlcost(t)/gdpt(t);
poutlay(t)..          outlaygdp(t) =e= edcostgdp(t) + hlcostgdp(t) + pubgdp(t) + cinvfgdp(t);
pubadgdp(t)..         pubgdp(t) =e= .05;
cinfgdp(t)..          cinvfgdp(t) =e= cinvf(t)/gdpt(t);
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
gdpt.lo(t) = .001;
qpc.lo(t) = .0001;
enh.lo(t) = .001;
enhpc.lo(t) = .001;
kf.lo(t) = .001;
schooltot.lo(t) = .001;
schoolage.lo(t) = 001;
fbyage.lo(a,t) = .001;
lfepq.lo(e,t) = .001;

parameter debtqlim;

debtqlim = 10;

parameter dlim(scen)

/low   10
 high 10/;

parameter rs(scen)

/low 0.05
high 0.05/;

parameter taxmaxs(scen)
/low  0.1
high 0.4/;

parameter fertshs
/low .5
 high .5/;

debtqlim = 10;
taxlim = .4;
fertsh = .5;

parameter cinvfshgdp(t),invfshgdp(t),mpk(t),mpkf(t),mpen(t);

loop(scen,
*debtqlim = dlim(scen);
r = rs(scen);
*taxlim = taxmaxs(scen);
*fertsh = fertshs(scen);
solve sdgfinance maximizing util using dnlp;
schoolyrs(scen,t) = schoolyr.L(t);
kaps(scen,t) = k.L(t);
debtgdps(scen,t) = debtgdp.L(t);
kffs(scen,t) = kff.L(t);
kres(scen,t) = kre.L(t);
kfs(scen,t) = kf.L(t);
mpks(scen,t) = bk*q.L(t)/k.L(t);
ktots(scen,t) = ktot.L(t);
wages(scen,e,t) = wage.L(e,t);
invs(scen,t) = inv.L(t);
qs(scen,t) = q.L(t);
qpcs(scen,t) = qpc.L(t);
conpcs(scen,t) = conpc.L(t);
edcosts(scen,t) = edcost.L(t);
schoolshs(scen,t) = schoolsh.L(t);
edcostgdps(scen,t) = edcostgdp.L(t);
enrollrates(scen,t) = enrollrate.L(t);
birthrates(scen,t) = birthrate.L(t);
poptots(scen,t) = poptot.L(t);
tfrs(scen,t) = tfr.L(t);
cinvfshgdps(scen,t) = cinvf.L(t)/q.L(t);
invfshgdps(scen,t) = invf.L(t)/q.L(t);
mpks(scen,t) = bk*q.L(t)/k.L(t);
mpkfs(scen,t) = bkf*q.L(t)/kf.L(t);
mpens(scen,t) = ben*q.L(t)/en.L(t););


*display qs,qpcs, tfrs, ks, mpks, invs, birthrates, poptots,schoolshs, enrollrates,schoolyrs, edcosts, edcostgdps, wages, kffs, kres;


execute_unload 'usaoutput.gdx' qpcs, poptots, tfrs;
execute 'gdxxrw usaoutput.gdx par=qpcs rng=qpcs!A1 par=poptots rng=poptots!A1 par = tfrs rng=tfrs!A1'


*display eattain.L;

parameter adultpop(t);
adultpop(t) = sum(ad,sum(g,pop.L(ad,g,t)));

display adultpop;

parameter kqratio(t),kfqratio(t),kenratio(t),ktotratio(t);
kqratio(t) = kq.L(t)/q.L(t);
kfqratio(t) = kf.L(t)/q.L(t);
kenratio(t) = en.L(t)/q.L(t);
ktotratio(t) = ktot.L(t)/q.L(t);

display kqratio,kfqratio,kenratio,ktotratio;

display edunitcost.L, edcost.L, edcostgdp.L;

display k.L,kf.L,kre.L,kff.L;

*solve sdgfinance maximizing util using dnlp;

display lfep.L;

display wage.L;

display ben, bkf, bk, bleds;

parameter kappc(t), kfpc(t), kffpc(t), krepc(t), lfeppc(e,t), qpctest(t), mpk(t),mpkf(t),mpen(t);

kappc(t) = kq.L(t)/poptot.L(t);
kfpc(t) = kf.L(t)/poptot.L(t);
kffpc(t) = kff.L(t)/poptot.L(t);
krepc(t) = kre.L(t)/poptot.L(t);
lfeppc(e,t) = lfepq.L(e,t)/poptot.L(t);
qpctest(t) = tfp1*(kffpc(t)+krepc(t))**ben*kfpc(t)**bkf*kappc(t)**bk*prod(es,lfeppc(es,t)**bleds(es));
mpk(t) = bk*q.L(t)/kq.L(t);
mpkf(t) = bkf*q.L(t)/kf.L(t);
mpen(t) = ben*q.L(t)/en.L(t);

display kappc,kfpc,kffpc,krepc,lfeppc,qpctest,qpc.L;

display mpk,mpkf,mpen;

display cont.L;

display lfepq.L, lfeps.L, lfeptot.L;

display q.L, gdps.L, gdpt.L, gdppc.L;

display ks.L, kq.L;

display inv.L;
