set t /2022/
tstart(t)
tend(t);
tstart(t) = yes$(ord(t) eq 1);
tend(t) = yes$(ord(t) eq card(t));

*set e is education: primary, p; lower secondary, ls; upper secondary, us; tertiary, t;

set e /p,ls,us,t/;
alias(e,ea);

set g /male,female/;
set surv /mdrc,fdrc,mhic,fhic/;
set fer /drc,hic/;

*Sectors: subsistence, agriculture, construction, manufacturing
* professional services (traded), services (nontraded), education, health care
*secp: sectors with capital accumulation
*sect: tradable sectors
*secn: nontradable sectors

set sec /sub, ag, min, con, man, prof, serv, ed, health/
secp(sec) /sub, ag, min, con, man, prof, serv/
sect(sec) /sub, ag, min, man, prof/
secn(sec) /con, serv/
secs(sec) /ed, health/;

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

parameter gdptots(scen,t),debtgdps(scen,t),contrpcs(scen,t),schools(scen,t), kffs(scen,t),kres(scen,t), kfs(scen,t), wages(scen,e,t),ktots(scen,t),mpks(scen,sec,t),
entots(scen,t), gdpts(scen,t),contrs(scen,t), contrpcs(scen,t), qs(scen,sec,t), pas(scen,t),lsas(scen,t),usas(scen,t),tsas(scen,t), ks(scen,sec,t), edbudgetgdps(scen,t)
invs(scen,sec,t);


$offOrder

*bsec coefficients on labor by education in the production function

Table bed(e,sec)

    sub  ag   min  man  con   prof   serv
p   .91  .5   .3   .1    .2    .05    0.2
ls  .03  .3   .3   .2    .4    .20    0.3
us  .03  .15  .3   .5    .3    .25    0.3
t   .03  .05  .1   .2    .1    .50    0.2 ;

*bk coefficient on business capital stock (plant and equipment) in the production function

parameter bk(sec)
/sub   .05
 ag    .25
 min   .25
 con   .25
 man   .25
 prof  .25
 serv  .25/;

*bkf coefficient on infrastructure capital in the production function

parameter bkf(sec);
bkf(secp) = .10;

parameter ben(sec);
ben(secp) = .05;

parameter bland(sec)
/sub   .25
 ag    .25
 min   .00
 con   .00
 man   .00
 prof  .00
 serv  .00/;

parameter bmin(sec) ;
bmin("min") = .5;

scalar land0,min0;
land0 = 1000;
min0 = 100;

parameter blab(sec);
blab(secp) = 1-bk(secp)-bkf(secp)-ben(secp)-bland(secp)-bmin(secp);

parameter bled(e,sec);
bled(e,secp) = blab(secp)*bed(e,secp);

parameter bltot(sec);
bltot(secp) = sum(e,bled(e,secp))+ben(secp)+bk(secp)+bkf(secp) ;

display bltot,bled;


scalar ek, costff, costre, hc, dep, r, kff0, kre0, aff, taxlim;
ek = .10;
costff = 1;
costre = 3;
hc = .002;
dep = .05;
r = .05;
aff = .20;
taxlim = .5;

*total factor productivity

parameter pi(sec)

/sub   .2
 ag     1
 min    1
 con    1
 man    2
 prof   2
 serv   1
 ed     1
 health 1 /;


*discount factor

parameter disc(t);
disc(t) = 1/(1+r)**(ord(t)-1);

parameter debtqlim;


*employment for primary (p), lower secondary (ls), upper secondary (up), and tertiary education (t)

table es(e,ea)

     p      ls     us     t
p   0.0    .05    .05    .05
ls  0.0    .1     .1     .05
us  0.0    .1     .1     .10
t   0.0    .1     .1     .15  ;

parameter hs(e)

/p    .05
 ls   .05
 us   .10
 t    .05/;

parameter fert0(a,fer),surv0(a,surv),w0(a,a,g),s0(a,g),ferthic0(a,fer);

Table popg0(a,g)

         male        female
1        8.2125966        8.0483568
2        7.991895        7.835544
3        7.7711934        7.6227312
4        7.5504918        7.4099184
5        7.3297902        7.1971056
6        7.1090886        6.9842928
7        6.888387        6.77148
8        6.671877        6.5615186
9        6.455367        6.3515572
10        6.238857        6.1415958
11        6.022347        5.9316344
12        5.805837        5.721673
13        5.5968086        5.5197014
14        5.3877802        5.3177298
15        5.1787518        5.1157582
16        4.9697234        4.9137866
17        4.760695        4.711815
18        4.58238        4.5415706
19        4.404065        4.3713262
20        4.22575        4.2010818
21        4.047435        4.0308374
22        3.86912        3.860593
23        3.7385208        3.7331542
24        3.6079216        3.6057154
25        3.4773224        3.4782766
26        3.3467232        3.3508378
27        3.216124        3.223399
28        3.1048614        3.1149436
29        2.9935988        3.0064882
30        2.8823362        2.8980328
31        2.7710736        2.7895774
32        2.659811        2.681122
33        2.5670378        2.5899888
34        2.4742646        2.4988556
35        2.3814914        2.4077224
36        2.2887182        2.3165892
37        2.195945        2.225456
38        2.116047        2.1468914
39        2.036149        2.0683268
40        1.956251        1.9897622
41        1.876353        1.9111976
42        1.796455        1.832633
43        1.7306958        1.7678628
44        1.6649366        1.7030926
45        1.5991774        1.6383224
46        1.5334182        1.5735522
47        1.467659        1.508782
48        1.4113756        1.4541246
49        1.3550922        1.3994672
50        1.2988088        1.3448098
51        1.2425254        1.2901524
52        1.186242        1.235495
53        1.1358378        1.186605
54        1.0854336        1.137715
55        1.0350294        1.088825
56        0.9846252        1.039935
57        0.934221        0.991045
58        0.8898098        0.9476852
59        0.8453986        0.9043254
60        0.8009874        0.8609656
61        0.7565762        0.8176058
62        0.712165        0.774246
63        0.6733248        0.73569
64        0.6344846        0.697134
65        0.5956444        0.658578
66        0.5568042        0.620022
67        0.517964        0.581466
68        0.4863104        0.5510356
69        0.4546568        0.5206052
70        0.4230032        0.4901748
71        0.3913496        0.4597444
72        0.359696        0.429314
73        0.329943        0.3972002
74        0.30019        0.3650864
75        0.270437        0.3329726
76        0.240684        0.3008588
77        0.210931        0.268745
78        0.188272        0.2419738
79        0.165613        0.2152026
80        0.142954        0.1884314
81        0.120295        0.1616602
82        0.097636        0.134889
83        0.084537        0.1178332
84        0.071438        0.1007774
85        0.058339        0.0837216
86        0.04524        0.0666658
87        0.032141        0.04961
88        0.0270154        0.0421004
89        0.0218898        0.0345908
90        0.0167642        0.0270812
91        0.0116386        0.0195716
92        0.006513        0.012062
93        0.0053496        0.0099942
94        0.0041862        0.0079264
95        0.0030228        0.0058586
96        0.0018594        0.0037908
97        0.000696        0.001723
98        0.0005646        0.0014064
99        0.0004332        0.0010898
100        0.0003018        0.0007732  ;

$onText

$CALL GDXXRW drcdatainput.xlsx Index=Index!a1 trace=3
$GDXIN drcdatainput.gdx
$LOAD popg0=D1 fert0= D2 surv0=D3 w0=D4 s0=D5 ferthic0=D6
$GDXIN

display popg0,fert0,surv0,w0,s0,ferthic0;

parameter tfr0(fer);
tfr0(fer) = sum(af,fert0(af,fer));
parameter survive0(a,g);
survive0(a,"female") = surv0(a,"fdrc");
survive0(a,"male") = surv0(a,"mdrc");
parameter survivehi0(a,g);
survivehi0(a,"female") = surv0(a,"fhic");
survivehi0(a,"male") = surv0(a,"mhic");

$offText

positive variables lfe(e,t), schoolpop(t), schooltsa(t), q(sec,t),qpc(t),gdp(t),gdpt(t),gdptpc(t), edbudgetgdp(t),
k(sec,t),contr(t),contrpc(t), tx(t), schoolcgdp(t), connt(t),conntpc(t), lsec(e,sec,t), mpk(sec,t),min(secp,t),
scgdp(t), kff(t),kre(t), he(t), en(sec,t), entot(t),enh(t), enhpc(t), invff(t), invre(t), ff(t), invf(t), kh(t),invh(t),hspc(t),kf(t),ktot(t),
lqp(t),lsub(t), healthcost(t),hcommod(t), gov(t),gdptot(t), pn(t), debt(t), debtgdp(t), cont12(t), govgdp(t),
lfe(e,t), schoolpop(t), schooltsa(t), cont(a,t), s(a,g,t), leave(a,a,g,t),neet(a,a,t), school(e,t), schooltot(t), schoolc(t), ps(t),ls(t),us(t),ts(t),lse(t), use(t), tse(t),
eattain(a,t),w(a,a,g,t),worka(a,t), pop(a,g,t),poptot(t),pa(t),lsa(t),usa(t),tsa(t),lf(t),h(t),birth(t), fert(a,a,t),land(sec,t),hland(t),bio(t);

variable util, ut(t), wage(e,t),debt(t),debtgdp(t),nx(t),inv(sec,t);

Equations

eq7(t), eq8(t), eq9(t), eq10(t), eq25(t), eq26(t), eq27(t), eq28(t), eq29(t), eq30(t), eq31(t), eq32(t), eq33(t),
utilt(t), utility, laborfc(e,t), output(sec,t), outputpc(t), ewage(e,t), leduc(e,t), lhealth(e,t), gdped(sec,t),
gdph(sec,t),  healthc(t), gdptrade(t), leduc(e,t), lhealth(e,t), gdph(sec,t), gdped(sec,t),
construct(t), ntservices(t), energy(t), energyd(t), ffuel(t),
consumetr(t), govbudget(t), grossproduct(t), housepc(t), pricent(t), educgdp(t)
governgdp(t),marginalpk(sec,t),energyhpc(t),landuse(t),minuse(t);


eq7(t)..  ps(t) =e=  sum(ap,sum(g,popg0(ap,g)));
eq8(t)..  ls(t) =e=  sum(als,sum(g,popg0(als,g)));
eq9(t)..  us(t) =e=  sum(aus,sum(g,popg0(aus,g)));
eq10(t)..  ts(t) =e=  0.5*sum(ater,sum(g,popg0(ater,g)));
eq25(t)..  poptot(t) =e= sum(a,sum(g,popg0(a,g)));
eq26(t).. school("p",t) =e= ps(t);
eq27(t).. school("ls",t) =e= ls(t);
eq28(t).. school("us",t) =e= us(t);
eq29(t).. school("t",t) =e= ts(t);
eq30(t).. lfe("p",t) =e= .1*poptot(t);
eq31(t).. lfe("ls",t) =e= .2*poptot(t);
eq32(t).. lfe("us",t) =e= .45*poptot(t);
eq33(t).. lfe("t",t) =e= .25*poptot(t);


laborfc(e,t)..        lfe(e,t) =e= sum(sec,lsec(e,sec,t));
output(secp,t)..      q(secp,t) =e= pi(secp)*min(secp,t)**bmin(secp)*land(secp,t)**bland(secp)*en(secp,t)**ben(secp)*kf(t)**bkf(secp)*k(secp,t)**bk(secp)*prod(e,lsec(e,secp,t)**bled(e,secp));
outputpc(t)..         gdptpc(t) =e= gdpt(t)/poptot(t);
gdptrade(t)..         gdpt(t) =e= sum(sect,q(sect,t)) - ff(t)- (r+dep)*(sum(secp,k(secp,t))+kf(t)+kh(t)+kff(t)+kre(t));
ewage(e,t)..          wage(e,t) =e= bled(e,"man")*q("man",t)/lsec(e,"man",t);
leduc(e,t)..          lsec(e,"ed",t) =e= sum(ea,school(ea,t)*es(ea,e));
lhealth(e,t)..        lsec(e,"health",t) =e= .1*poptot(t)*hs(e);
gdped("ed",t)..       q("ed",t) =e= sum(e,lsec(e,"ed",t)*wage(e,t));
gdph("health",t)..    q("health",t) =e= sum(e,lsec(e,"health",t)*wage(e,t));
healthc(t)..          healthcost(t) =e= q("health",t);
marginalpk(secp,t)..  mpk(secp,t) =e= (bk(secp)*q(secp,t)/k(secp,t));
landuse(t)..          land0 =e= sum(secp,land(secp,t));
minuse(t)..           min0 =e= sum(secp,min(secp,t));


construct(t)..        q("con",t) =e= dep*kh(t) + 0*sum(secp,inv(secp,t)) + 0*invf(t);
ntservices(t)..       q("serv",t) =e= connt(t);
energy(t)..           entot(t) =e= kff(t) + kre(t);
ffuel(t)..            ff(t) =e= aff*kff(t);
energyd(t)..          entot(t) =e= sum(secp,en(secp,t)) + enh(t);

consumetr(t)..        contr(t) =e= gdpt(t);
govbudget(t)..        gov(t) =e= healthcost(t) + q("ed",t) + invff(t) + invre(t) + invf(t);
governgdp(t)..        govgdp(t) =e= gov(t)/gdptot(t);
grossproduct(t)..     gdptot(t) =e= sum(sect,q(sect,t))+pn(t)*q("serv",t)+q("ed",t)+q("health",t);
educgdp(t)..          edbudgetgdp(t) =e= q("ed",t)/gdptot(t);
housepc(t)..          hspc(t) =e= (kh(t)**.8*kf(t)**.2)/poptot(t);
pricent(t)..          pn(t) =e= .2*(contrpc(t)/conntpc(t));
energyhpc(t)..        enhpc(t) =e= enh(t)/poptot(t);
utilt(t)..            ut(t) =e= log(contr(t))+ log(connt(t))+.2*log(kh(t))+.05*log(enh(t));
utility..             util =e= sum(t,disc(t)* ut(t)) + (1/r)*sum(tend,disc(tend)*ut(tend));

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
lsec.lo(e,secp,t) = .0001;
gdpt.lo(t) = .001;
kh.lo(t) = .001;
hspc.lo(t) = .001;
kf.lo(t) = .001;
cont12.up(t) = 1.0;
gdptot.lo(t) = .00001;
land.lo(secp,t) = .0001;
min.lo(secp,t) = .0001;

solve sdgfinance maximizing util using dnlp;

display k.L, kf.L, contr.L, mpk.L, gdpt.L, q.L;

display gdptot.L, ut.L, land.L, util.L;

display lfe.L, lsec.L;


*execute_unload 'data.gdx' qpcs, ks, conpcs, births, eduuss;
*execute 'gdxxrw data.gdx par=qpcs rng=qpcs!A1 par=ks rng=ks!A1 par = conpcs rng=conpcs!A1 par = births rng=births!A1 par=eduuss rng=eduss!A1