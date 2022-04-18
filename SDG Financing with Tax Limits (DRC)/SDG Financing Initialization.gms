set t /2022*2022/
tstart(t)
tend(t);
tstart(t) = yes$(ord(t) eq 1);
tend(t) = yes$(ord(t) eq card(t));

*set e is education: primary, p; lower secondary, ls; upper secondary, us; tertiary, t;

set e /ps,ls,us,ts/;
alias(e,ea);

set g /male,female/;
set surv /mdrc,fdrc,mhic,fhic/;
set fer /drc,hic/;

*Sectors: subsistence, agriculture, construction, manufacturing
* professional services (traded), services (nontraded), education, health care
*secp: sectors with capital accumulation
*sect: tradable sectors
*secn: nontradable sectors

set sec /sub, ag, mine, con, man, prof, serv, ed, health/
secp(sec) /sub, ag, mine, con, man, prof, serv/
sect(sec) /sub, ag, mine, man, prof/
secn(sec) /con, serv/;

*sets and subsets for age

set a /1*100/
a1(a), aw(a), af2049(a), ap(a), als(a), af(a), aus(a), ater(a), as(a);
a1(a) = yes$(ord(a) eq 1);
ap(a) = yes$(ord(a) ge 6 and ord(a) le 12);
als(a) = yes$(ord(a) ge 13 and ord(a) le 15);
aus(a) = yes$(ord(a) ge 16 and ord(a) le 18);
ater(a) = yes$(ord(a) ge 19 and ord(a) le 22);
as(a) = yes$(ord(a) ge 12 and ord(a) le 23);
aw(a) = yes$(ord(a) ge 12 and ord(a) le 65);
af2049(a) = yes$(ord(a) ge 20 and ord(a) le 49);
af(a) = yes$(ord(a) ge 15 and ord(a) le 49);

alias(as,aa);

set scen /lim , nolim/;

parameter gdptots(scen,t),debtgdps(scen,t),contrpcs(scen,t), kffs(scen,t),kres(scen,t), kfs(scen,t), wages(scen,e,t),ktots(scen,t),mpks(scen,sec,t),
entots(scen,t), gdpts(scen,t),contrs(scen,t), contrpcs(scen,t), qs(scen,sec,t), pas(scen,t),lsas(scen,t),usas(scen,t),tsas(scen,t), ks(scen,sec,t), edbudgetgdps(scen,t)
invs(scen,sec,t),govgdps(scen,t),schools(scen,e,t);


$offOrder

*bsec coefficients on labor by education in the production function

parameter bed(sec,e);

*bk coefficient on business capital stock (plant and equipment) in the production function

parameter bk(sec)
/sub  0.01
 ag   0.20
 mine 0.25
 con  0.25
 man  0.25
 prof 0.2
 serv 0.1/;

*bkf coefficient on infrastructure capital in the production function

parameter bkf(sec);
bkf(secp) = .10;

parameter ben(sec);

ben(secp) = .05;

parameter bland(sec)

/sub .30
 ag   .30
 mine .1
 con  .05
 man  .05
 prof .05
 serv .05   /  ;

parameter  bmin(sec)

/sub  0.0
 ag   0.0
 mine 0.2
 con  0.0
 man  0.0
 prof 0.0
 serv 0.0/;;

parameter blab(sec);
blab(secp) = 1-bland(secp)-bmin(secp)-bk(secp)-bkf(secp)-ben(secp);

*k0 initial capital stock (2022)


parameter k0(sec)

/sub   0.1
 ag    1.0
 mine  1.0
 man   1.0
 con   1.0
 prof  0.1
 serv  0.5/;

*kh0 initial housing capital stock

parameter kh0;
kh0 = .2*sum(sec,k0(sec));

*kf0 initial infrastructure capital stock

parameter kf0;
kf0 = (1/6)*sum(sec,k0(sec));

*energy demand from capital stock, cost of fossil-fuel generation, cost of renewable energy generation

scalar ek, costff, costre, hc, dep, r, kff0, kre0, aff, taxlim,min0,landrural0;
ek = .10;
costff = 1;
costre = 3;
hc = .002;
dep = .05;
r = .05;
kff0 = .15*sum(secp,k0(secp));
kre0 = .1*kff0;
aff = .20;
taxlim = .5;
min0 = 10;
landrural0 = 50;

*total factor productivity

parameter q0(sec)

/sub          0.824
ag           4.920
mine         1.671
con          0.25
man          0.651
prof         0.079
serv         0.50/  ;

parameter empsh0(sec)

/sub         0.3
 ag          0.2
 mine        0.1
 con         0.1
 man         0.1
 prof        0.05
 serv        0.15 / ;

*discount factor

parameter disc(t);
disc(t) = 1/(1+r)**(ord(t)-1);

parameter debtqlim;


*employment for primary (p), lower secondary (ls), upper secondary (up), and tertiary education (t)

table es(e,ea)

     ps      ls     us     ts
ps   0.0    .05    .05    .05
ls   0.0    .1     .1     .05
us   0.0    .1     .1     .10
ts   0.0    .1     .1     .15  ;

parameter hs(e)

/ps    .05
 ls    .05
 us    .10
 ts    .05/;

parameter popg0(a,g),fert0(a,fer),surv0(a,surv),w0(a,a,g),s0(a,g),ferthic0(a,fer);

$CALL GDXXRW drcdatainput.xlsx Index=Index!a1 trace=3
$GDXIN drcdatainput.gdx
$LOAD popg0=D1 fert0= D2 surv0=D3 w0=D4 s0=D5 ferthic0=D6 bed=D7
$GDXIN

display popg0,fert0,surv0,w0,s0,ferthic0,bed;

parameter bled(e,sec);
bled(e,secp) = blab(secp)*bed(secp,e);

parameter bltot(sec);
bltot(secp) = sum(e,bled(e,secp))+ben(secp)+bk(secp)+bkf(secp) ;

display bltot,bled;

parameter tfr0(fer);
tfr0(fer) = sum(af,fert0(af,fer));
parameter survive0(a,g);
survive0(a,"female") = surv0(a,"fdrc");
survive0(a,"male") = surv0(a,"mdrc");
parameter survivehi0(a,g);
survivehi0(a,"female") = surv0(a,"fhic");
survivehi0(a,"male") = surv0(a,"mhic");

positive variables lfe(e,t), schoolpop(t), schooltsa(t), q(sec,t),qpc(t),gdp(t),gdpt(t),gdptpc(t), edbudgetgdp(t),
k(sec,t),contr(t),contrpc(t), tx(t), schoolcgdp(t), connt(t),conntpc(t), lsec(e,sec,t), mpk(sec,t),land(sec,t),min(sec,t),
scgdp(t), kff(t),kre(t), he(t), en(sec,t), entot(t),enh(t), enhpc(t), invff(t), invre(t), ff(t), invf(t), kh(t),invh(t),hspc(t),kf(t),ktot(t),lftot(t),
lqp(t),lsub(t), healthcost(t),hcommod(t), gov(t),gdptot(t), pn(t), debt(t), debtgdp(t), cont12(t), govgdp(t), reserve(t),
lfe(e,t), schoolpop(t), schooltsa(t), cont(a,t), s(a,g,t), leave(a,a,g,t),neet(a,a,t), school(e,t), schooltot(t), schoolc(t), ps(t),ls(t),us(t),ts(t),lse(t), use(t), tse(t),
eattain(a,t),w(a,a,g,t),worka(a,t), pop(a,g,t),poptot(t),pa(t),lsa(t),usa(t),tsa(t),lf(t),h(t),birth(t), fert(a,a,t),
inv(sec,t),pi(sec,t),emp(sec,t);

variable util, ut(t), wage(e,t), debt(t), debtgdp(t), nx(t);

Equations

*eq1(a,g,t), eq2(g,t),
*eq3(a,g,t),
eq4(a,a,t), eq5(t),
*eq6(a,g,t),
eq7(t), eq8(t), eq9(t), eq10(t), eq11(t), eq12(t),
eq13(t), eq14(t), eq15(a,a,g,t),
*eq16(a,a,g,t), eq17(a,g,t),
eq18(a,t), eq19(a,t), eq20(t), eq21(t), eq22(t),
eq23(t), eq24(t), eq25(t), eq26(t), eq27(t), eq28(t), eq29(t), eq30(t), eq31(t), eq32(t), eq33(t), eq34(t),
eq36(a,g), eq37(a,g), eq38(a,a,g), eq39(t), eq40(t), eq41(t), eq42(t), eq43(t), eq44(t), eq45(t), eq46(t),
*utilt(t),
utility, laborfc(e,t), output(sec,t), outputpc(t), ewage(e,t), leduc(e,t), lhealth(e,t), gdped(sec,t),
gdph(sec,t), hcommodity(t), healthc(t), gdptrade(t), leduc(e,t), lhealth(e,t), gdph(sec,t), gdped(sec,t),
hcommodity(t), kstart(sec,t), kfstart(t), kffstart(t), krestart(t),
*knext(sec,t),
ktotal(t),
employsec(sec,t),
empeduc(t)
emphealth(t)
*kfnext(t), kffnext(t),
*krenext(t),
khstart(t),
*khnext(t),
*construct(t),
ntservices(t), khend(t), kfend(t), energy(t), energyd(t), ffuel(t),
dstart(t), tbalance(t),
*totdebt(t),
debttogdp(t),
debtlimit(t),
conend(t), conlim(t), consumetrpc(t),
consumentpc(t), govbudget(t), grossproduct(t), housepc(t), pricent(t), kend(sec,t), kffend(t), kreend(t), educgdp(t)
governgdp(t),
taxmax(t),laborfctot(t), laborfcsh(sec,t),
marginalpk(sec,t),energyhpc(t),landtotrural(t),mintot(t);
*output0(sec,t);

*eq1(as+1,g,t+1)..  s(as+1,g,t+1) =e= cont(as,t)*s(as,g,t);
*eq2(g,t+1)..  s("12",g,t+1) =e= cont12(t)*pop("11",g,t);
*eq3(a+1,g,t+1)..  pop(a+1,g,t+1) =e= pop(a,g,t)*survive0(a,g);
eq4(af,as,t)..  fert(af,as,t) =e= w(af,as,"female",t)*fert0(af,"drc")$(ord(as) lt 6) + w(af,as,"female",t)*fert0(af,"hic")$(ord(as) ge 6);
eq5(t)..   birth(t) =e= sum(af,sum(as,fert(af,as,t)));
*eq6(a1,g,t+1)..   pop(a1,g,t+1) =e= 0.5*birth(t);
eq7(t)..  ps(t) =e=  sum(ap,sum(g,pop(ap,g,t)));
eq8(t)..  ls(t) =e=  sum(als,sum(g,s(als,g,t)));
eq9(t)..  us(t) =e=  sum(aus,sum(g,s(aus,g,t)));
eq10(t)..  ts(t) =e=  sum(ater,sum(g,s(ater,g,t)));
eq11(t).. lse(t) =e= ls(t)/(sum(als,sum(g,pop(als,g,t))));
eq12(t).. use(t) =e= us(t)/(sum(aus,sum(g,pop(aus,g,t))));
eq13(t).. tse(t) =e= ts(t)/(sum(ater,sum(g,pop(ater,g,t))));
eq14(t).. schooltot(t) =e= ps(t) + ls(t) + us(t) + ts(t);
eq15(aw,as,g,t).. leave(aw,as,g,t) =e= (1-cont(as,t))*s(as,g,t)$(ord(aw) eq ord(as));
*eq16(aw+1,as,g,t+1).. w(aw+1,as,g,t+1) =e= w(aw,as,g,t)$(ord(aw) ge ord(as)) + leave(aw,as,g,t)$(ord(aw) eq ord(as)) + 0$(ord(aw) lt ord(as));;
*eq17(as,g,t+1).. w("12",as,g,t+1) =e= 0;
eq18(af,t).. worka(af,t) =e= sum(as,sum(g,w(af,as,g,t)));
eq19(as,t).. eattain(as,t) =e= sum(aw,sum(g,w(aw,as,g,t)));
eq20(t).. lf(t) =e= sum(as,eattain(as,t));
eq21(t).. pa(t) =e= eattain("12",t) + eattain("13",t) + eattain("14",t) ;
eq22(t)..  lsa(t) =e= eattain("15",t)+eattain("16",t)+eattain("17",t);
eq23(t)..  usa(t) =e= eattain("18",t)+eattain("19",t)+eattain("20",t)+eattain("21",t);
eq24(t)..  tsa(t) =e= eattain("22",t);
eq25(t)..  poptot(t) =e= sum(a,sum(g,pop(a,g,t)));
eq26(t).. school("ps",t) =e= ps(t);
eq27(t).. school("ls",t) =e= ls(t);
eq28(t).. school("us",t) =e= us(t);
eq29(t).. school("ts",t) =e= ts(t);
eq30(t).. lfe("ps",t) =e= pa(t);
eq31(t).. lfe("ls",t) =e= lsa(t);
eq32(t).. lfe("us",t) =e= usa(t);
eq33(t).. lfe("ts",t) =e= tsa(t);
eq34(t).. schoolpop(t) =e= schooltot(t)/poptot(t);
eq36(as,g).. s(as,g,"2022") =e= s0(as,g);
eq37(a,g).. pop(a,g,"2022") =e= popg0(a,g);
eq38(aw,as,g).. w(aw,as,g,"2022") =e= w0(aw,as,g);
eq39(t).. cont("12",t) =e= 1;
eq40(t).. cont("13",t) =e= 1;
eq41(t).. cont("14",t) =e= 1;
eq42(t).. cont("16",t) =e= 1;
eq43(t).. cont("17",t) =e= 1;
eq44(t).. cont("19",t) =e= 1;
eq45(t).. cont("20",t) =e= 1;
eq46(t).. cont("21",t) =e= 1;

laborfc(e,t)..        lfe(e,t) =e= sum(sec,lsec(e,sec,t));
laborfctot(t)..       lftot(t) =e= sum(e,lfe(e,t));
laborfcsh(secp,t)..   empsh0(secp)*(lftot(t)-emp("ed",t)-emp("health",t)) =e= emp(secp,t);
output(secp,t)..      q(secp,t) =e= pi(secp,t)*min(secp,t)**bmin(secp)*land(secp,t)**bland(secp)*en(secp,t)**ben(secp)*kf(t)**bkf(secp)*k(secp,t)**bk(secp)*prod(e,lsec(e,secp,t)**bled(e,secp));
*output0(secp,t)..     q(secp,t) =e= q0(secp);
employsec(secp,t)..   emp(secp,t) =e= sum(e,lsec(e,secp,t));
landtotrural(t)..     sum(secp,land(secp,t)) =e= landrural0;
mintot(t)..           sum(secp,min(secp,t)) =e= min0;
outputpc(t)..         gdptpc(t) =e= gdpt(t)/poptot(t);
gdptrade(t)..         gdpt(t) =e= sum(sect,q(sect,t));
ewage(e,t)..          wage(e,t) =e= bled(e,"man")*q("man",t)/lsec(e,"man",t);
leduc(e,t)..          lsec(e,"ed",t) =e= sum(ea,school(ea,t)*es(ea,e));
empeduc(t)..          emp("ed",t) =e= sum(e,lsec(e,"ed",t));
lhealth(e,t)..        lsec(e,"health",t) =e= .1*poptot(t)*hs(e);
emphealth(t)..        emp("health",t) =e= sum(e,lsec(e,"health",t));
gdped("ed",t)..       q("ed",t) =e= sum(e,lsec(e,"ed",t)*wage(e,t));
gdph("health",t)..    q("health",t) =e= sum(e,lsec(e,"health",t)*wage(e,t));
hcommodity(t)..       hcommod(t) =e= 0.001*poptot(t)* hc;
healthc(t)..          healthcost(t) =e= q("health",t) + hcommod(t);
marginalpk(secp,t)..  mpk(secp,t) =e= (bk(secp)*q(secp,t)/k(secp,t));

kstart(secp,tstart).. k(secp,tstart) =e= k0(secp);
dstart(tstart)..      debt(tstart) =e= 0;
kffstart(tstart)..    kff(tstart) =e= kff0;
krestart(tstart)..    kre(tstart) =e= kre0;
khstart(tstart)..     kh(tstart) =e= kh0;
kfstart(tstart)..     kf(tstart) =e= kf0;
*knext(secp,t+1)..     k(secp,t+1) =e= k(secp,t)*(1-dep) + inv(secp,t);
ktotal(t)..           ktot(t) =e= sum(secp,k(secp,t));
*kffnext(t+1)..        kff(t+1) =e= kff(t)*(1-dep) + invff(t)/costff;
*krenext(t+1)..        kre(t+1) =e= kre(t)*(1-dep) + invre(t)/costre;
*khnext(t+1)..         kh(t+1) =e= kh(t)*(1-dep) + invh(t);
*kfnext(t+1)..         kf(t+1) =e= kf(t)*(1-dep) + invf(t);
*construct(t)..        q("con",t) =e= invh(t) + 0*sum(secp,inv(secp,t)) + 0*invf(t);
ntservices(t)..       q("serv",t) =e= connt(t);
energy(t)..           entot(t) =e= kff(t) + kre(t);
ffuel(t)..            ff(t) =e= aff*kff(t);
energyd(t)..          entot(t) =e= sum(secp,en(secp,t)) + enh(t);
tbalance(t)..         nx(t) =e= gdpt(t) - sum(secp,inv(secp,t)) - invf(t) - contr(t) - invff(t) - invre(t) - ff(t) - hcommod(t);
*totdebt(t+1)..        debt(t+1) =e= (1+r)*debt(t) - nx(t);
debttogdp(t)..        debtgdp(t) =e= debt(t)/gdpt(t);
debtlimit(t)..        debtgdp(t) =l= debtqlim;
conend(tend)..        contr(tend) =e= gdpt(tend) - sum(secp,inv(secp,tend)) - invf(tend) - invff(tend) - invre(tend) - r*debt(tend) - ff(tend) - hcommod(tend);
conlim(t)..           contr(t) =l= gdpt(t) - r*debt(t) - ff(t);
kend(secp,tend)..     k(secp,tend)*dep =e= inv(secp,tend);
kffend(tend)..        kff(tend)*dep =e= invff(tend);
kreend(tend)..        kre(tend)*dep =e= invre(tend);
khend(tend)..         kh(tend)*dep =e= invh(tend);
kfend(tend)..         kf(tend)*dep =e= invf(tend);
consumetrpc(t)..      contrpc(t) =e= contr(t)/poptot(t);
*contrpcmin(t)..       contrpc(t) =g= .001;
consumentpc(t)..      conntpc(t) =e= connt(t)/poptot(t);
govbudget(t)..        gov(t) =e= healthcost(t) + q("ed",t);
governgdp(t)..        govgdp(t) =e= gov(t)/gdptot(t);
taxmax(t)..           govgdp(t) =l= taxlim;
grossproduct(t)..     gdptot(t) =e= sum(sect,q(sect,t))+(r+dep)*(kff(t)+kre(t))+(r+dep)*kh(t)+pn(t)*q("serv",t)+q("ed",t)+q("health",t);
educgdp(t)..          edbudgetgdp(t) =e= q("ed",t)/gdptot(t);
housepc(t)..          hspc(t) =e= (kh(t)**.8*kf(t)**.2)/poptot(t);
pricent(t)..          pn(t) =e= .2*(contrpc(t)/conntpc(t));
energyhpc(t)..        enhpc(t) =e= enh(t)/poptot(t);
*utilt(t)..            ut(t) =e= log(contrpc(t))+.2*log(conntpc(t))+.10*log(hspc(t))+.01*log(enhpc(t));
*utilt(t)..            ut(t) =e= log(contr(t))+.2*log(connt(t))+.1*log(kh(t))+.01*log(enh(t));
*utility..             util =e= sum(t,disc(t)* ut(t)) + (1/r)*sum(tend,disc(tend)*ut(tend));
utility..              util =e= -sum(t,sum(secp,(q(secp,t)-q0(secp))*(q(secp,t)-q0(secp))));


model sdgfinance using /all/;

poptot.lo(t) = .00001;
en.lo(secp,t) = .001;
tsa.lo(t) = .00001;
pop.lo(a,g,t) = .000001;
k.lo(secp,t) = .001;
contrpc.lo(t) = .001;
contr.lo(t) = .001;
conntpc.lo(t) = .001;
connt.lo(t) = .001;
q.lo(secp,t) = .0001;
enh.lo(t) = .001;
enhpc.lo(t) = .001;
lsec.lo(e,secp,t) = .0001;
gdpt.lo(t) = .001;
kh.lo(t) = .001;
hspc.lo(t) = .001;
kf.lo(t) = .001;
cont12.up(t) = 1.0;
cont.up(a,t) = 1.0;
gdptot.lo(t) = .00001;
land.lo(secp,t) = .0001;

*debtqlim = 20;

*solve sdgfinance maximizing util using dnlp;

parameter dlim(scen)

/lim  10
 nolim 10/;

parameter rs(scen)

/lim 0.15
nolim 0.05/;

parameter taxmaxs(scen)
/lim  0.1
nolim 0.4/;

loop(scen,
debtqlim = dlim(scen);
r = rs(scen);
taxlim = taxmaxs(scen);
solve sdgfinance maximizing util using dnlp;
ks(scen,secp,t) = k.L(secp,t);
debtgdps(scen,t) = debtgdp.L(t);
contrpcs(scen,t) = contrpc.L(t);
gdptots(scen,t) = gdptot.L(t);
kffs(scen,t) = kff.L(t);
kres(scen,t) = kre.L(t);
kfs(scen,t) = kf.L(t);
mpks(scen,secp,t) = mpk.L(secp,t);
ktots(scen,t) = ktot.L(t);
wages(scen,e,t) = wage.L(e,t);
gdpts(scen,t) = gdpt.L(t);
qs(scen,sec,t) = q.L(sec,t);
contrs(scen,t) = contr.L(t);
contrpcs(scen,t) = contrpc.L(t);
pas(scen,t) = pa.L(t);
govgdps(scen,t) = govgdp.L(t);
lsas(scen,t) = lsa.L(t);
usas(scen,t) = usa.L(t);
tsas(scen,t) = tsa.L(t);
schools(scen,e,t) = school.L(e,t);
invs(scen,secp,t) = inv.L(secp,t);
edbudgetgdps(scen,t) = edbudgetgdp.L(t);
entots(scen,t) = entot.L(t););


display pas, lsas, usas, tsas, gdpts, kffs, kres, contrpcs, debtgdps, edbudgetgdps;

display mpks, invs;

display govgdps;

display qs,q0,util.L;

display pi.L;

display emp.L;

parameter emptot(t),empptot(t),employsh(sec,t);
emptot(t) = sum(sec,emp.L(sec,t));
empptot(t) = sum(secp,emp.L(secp,t));
employsh(secp,t) = emp.L(secp,t)/empptot(t);

display emptot, lftot.L;

display employsh, empsh0;

*execute_unload 'data.gdx' qpcs, ks, conpcs, births, eduuss;
*execute 'gdxxrw data.gdx par=qpcs rng=qpcs!A1 par=ks rng=ks!A1 par = conpcs rng=conpcs!A1 par = births rng=births!A1 par=eduuss rng=eduss!A1

$onText

display bled,blab,bed;
display q.L,k.L,land.L,min.L,contr.L;
display cont.L;
display pa.L,lsa.L,usa.L,tsa.L;
display lsec.L;

$offText