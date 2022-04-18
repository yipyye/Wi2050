set a /1*100/
a299(a)
a622(a);
a299(a) = yes$(ord(a) ge 2);
a622(a) = yes$(ord(a) ge 6 and ord(a) le 22);
set ag /0-4,5-9,10-14,15-19,20-24,25-29,30-34,35-39,40-44,45-49,50-54,55-59,60-64,65-69,70-74,75-79,80-84,85-89,90-94,95-99,100+/
agfert /15-19,20-24,25-29,30-34,35-39,40-44,45-49/;
set surv /mdrc, fdrc, mhic, fhic/;
set edu /no,ptotal,pc,stotal,sc,ttotal,tc,pop/ ;
set age624 /s0sh,ps,ls,us,ts/;
set educ /12,15,18,22/;
set eda /ps,ls,us,ts/;
set secp /sub, ag, min, man, con, prof, serv/;
alias(a,a1,a2);
set fer /drc, hic/;
set g /male, female/;
parameter popg0(a,g), fert0(a), surv0(a,surv), wf0(a,educ), wm0(a,educ);
parameter age5yr(ag,g),asfr(agfert,fer),survival(a,surv),edattainf(a,a,edu),edattainm(a,a,edu),s0shf(a,age624),s0shm(a,age624),bed(secp,eda);

$CALL GDXXRW drcdata.xlsx Index=Index!a1 trace=3
$GDXIN drcdata.gdx
$LOAD age5yr=D1 asfr=D2 survival=D3 s0shf=D4 s0shm=D5 edattainf=D6 edattainm=D7  bed=D8
$GDXIN

display age5yr,asfr,survival,s0shf,s0shm,edattainf,edattainm, bed;

parameter avag(ag);
avag(ag) = (ord(ag)-1)*5+2;

$offOrder

display avag;

loop(ag,
popg0(a,g)$(ord(a) eq (ord(ag)-1)*5+2) = age5yr(ag,g)/5000;
popg0(a,g)$(ord(a) eq (ord(ag)-1)*5+3) = (age5yr(ag,g)+(1/5)*(age5yr(ag+1,g)-age5yr(ag,g)))/5000;
popg0(a,g)$(ord(a) eq (ord(ag)-1)*5+4) = (age5yr(ag,g)+(2/5)*(age5yr(ag+1,g)-age5yr(ag,g)))/5000;
popg0(a,g)$(ord(a) eq (ord(ag)-1)*5+5) = (age5yr(ag,g)+(3/5)*(age5yr(ag+1,g)-age5yr(ag,g)))/5000;
popg0(a,g)$(ord(a) eq (ord(ag)-1)*5+6) = (age5yr(ag,g)+(4/5)*(age5yr(ag+1,g)-age5yr(ag,g)))/5000;);

popg0("1",g) = popg0("2",g) + (popg0("2",g) - popg0("3",g));

display popg0;

loop(agfert,
fert0(a)$(ord(a) eq (ord(agfert)-1)*5+15) = asfr(agfert,"drc")/1000;
fert0(a)$(ord(a) eq (ord(agfert)-1)*5+16) = asfr(agfert,"drc")/1000;
fert0(a)$(ord(a) eq (ord(agfert)-1)*5+17) = asfr(agfert,"drc")/1000;
fert0(a)$(ord(a) eq (ord(agfert)-1)*5+18) = asfr(agfert,"drc")/1000;
fert0(a)$(ord(a) eq (ord(agfert)-1)*5+19) = asfr(agfert,"drc")/1000;);

display fert0;
parameter tfr0;
tfr0 = sum(a,fert0(a));
display tfr0;

parameter ferthic0(a);

loop(agfert,
ferthic0(a)$(ord(a) eq (ord(agfert)-1)*5+15) = asfr(agfert,"hic")/1000;
ferthic0(a)$(ord(a) eq (ord(agfert)-1)*5+16) = asfr(agfert,"hic")/1000;
ferthic0(a)$(ord(a) eq (ord(agfert)-1)*5+17) = asfr(agfert,"hic")/1000;
ferthic0(a)$(ord(a) eq (ord(agfert)-1)*5+18) = asfr(agfert,"hic")/1000;
ferthic0(a)$(ord(a) eq (ord(agfert)-1)*5+19) = asfr(agfert,"hic")/1000;);

display ferthic0;
parameter tfrhic0;
tfrhic0 = sum(a,ferthic0(a));
display tfrhic0;

loop(ag,
survival(a,"mdrc")$(ord(a) eq ord(ag)*5+1) = survival(a-1,"mdrc")*(survival(a+4,"mdrc")/survival(a-1,"mdrc"))**(1/5);
survival(a,"mdrc")$(ord(a) eq ord(ag)*5+2) = survival(a-2,"mdrc")*(survival(a+3,"mdrc")/survival(a-2,"mdrc"))**(2/5);
survival(a,"mdrc")$(ord(a) eq ord(ag)*5+3) = survival(a-3,"mdrc")*(survival(a+2,"mdrc")/survival(a-3,"mdrc"))**(3/5);
survival(a,"mdrc")$(ord(a) eq ord(ag)*5+4) = survival(a-4,"mdrc")*(survival(a+1,"mdrc")/survival(a-4,"mdrc"))**(4/5);
survival(a,"mdrc")$(ord(a) eq ord(ag)*5+5) = survival(a-5,"mdrc")*(survival(a  ,"mdrc")/survival(a-5,"mdrc"))**(5/5);
survival(a,"fdrc")$(ord(a) eq ord(ag)*5+1) = survival(a-1,"fdrc")*(survival(a+4,"fdrc")/survival(a-1,"mdrc"))**(1/5);
survival(a,"fdrc")$(ord(a) eq ord(ag)*5+2) = survival(a-2,"fdrc")*(survival(a+3,"fdrc")/survival(a-2,"mdrc"))**(2/5);
survival(a,"fdrc")$(ord(a) eq ord(ag)*5+3) = survival(a-3,"fdrc")*(survival(a+2,"fdrc")/survival(a-3,"mdrc"))**(3/5);
survival(a,"fdrc")$(ord(a) eq ord(ag)*5+4) = survival(a-4,"fdrc")*(survival(a+1,"fdrc")/survival(a-4,"mdrc"))**(4/5);
survival(a,"fdrc")$(ord(a) eq ord(ag)*5+5) = survival(a-5,"fdrc")*(survival(a  ,"fdrc")/survival(a-5,"mdrc"))**(5/5);
survival(a,"mhic")$(ord(a) eq ord(ag)*5+1) = survival(a-1,"mhic")*(survival(a+4,"mhic")/survival(a-1,"mhic"))**(1/5);
survival(a,"mhic")$(ord(a) eq ord(ag)*5+2) = survival(a-2,"mhic")*(survival(a+3,"mhic")/survival(a-2,"mhic"))**(2/5);
survival(a,"mhic")$(ord(a) eq ord(ag)*5+3) = survival(a-3,"mhic")*(survival(a+2,"mhic")/survival(a-3,"mhic"))**(3/5);
survival(a,"mhic")$(ord(a) eq ord(ag)*5+4) = survival(a-4,"mhic")*(survival(a+1,"mhic")/survival(a-4,"mhic"))**(4/5);
survival(a,"mhic")$(ord(a) eq ord(ag)*5+5) = survival(a-5,"mhic")* (survival(a,"mhic")/survival(a-5,"mhic"))**(5/5);
survival(a,"fhic")$(ord(a) eq ord(ag)*5+1) = survival(a-1,"fhic")*(survival(a+4,"fhic")/survival(a-1,"fhic"))**(1/5);
survival(a,"fhic")$(ord(a) eq ord(ag)*5+2) = survival(a-2,"fhic")*(survival(a+3,"fhic")/survival(a-2,"fhic"))**(2/5);
survival(a,"fhic")$(ord(a) eq ord(ag)*5+3) = survival(a-3,"fhic")*(survival(a+2,"fhic")/survival(a-3,"fhic"))**(3/5);
survival(a,"fhic")$(ord(a) eq ord(ag)*5+4) = survival(a-4,"fhic")*(survival(a+1,"fhic")/survival(a-4,"fhic"))**(4/5);
survival(a,"fhic")$(ord(a) eq ord(ag)*5+5) = survival(a-5,"fhic")*(survival(a  ,"fhic")/survival(a-5,"fhic"))**(5/5););

survival("2","fhic") = survival("1","fhic")*(survival("5","fhic")/survival("1","fhic"))**(1/4);
survival("3","fhic") = survival("1","fhic")*(survival("5","fhic")/survival("1","fhic"))**(2/4);
survival("4","fhic") = survival("1","fhic")*(survival("5","fhic")/survival("1","fhic"))**(3/4);
survival("2","mhic") = survival("1","mhic")*(survival("5","mhic")/survival("1","mhic"))**(1/4);
survival("3","mhic") = survival("1","mhic")*(survival("5","mhic")/survival("1","mhic"))**(2/4);
survival("4","mhic") = survival("1","mhic")*(survival("5","mhic")/survival("1","mhic"))**(3/4);
survival("2","fdrc") = survival("1","fdrc")*(survival("5","fdrc")/survival("1","fdrc"))**(1/4);
survival("3","fdrc") = survival("1","fdrc")*(survival("5","fdrc")/survival("1","fdrc"))**(2/4);
survival("4","fdrc") = survival("1","fdrc")*(survival("5","fdrc")/survival("1","fdrc"))**(3/4);
survival("2","mdrc") = survival("1","mdrc")*(survival("5","mdrc")/survival("1","mdrc"))**(1/4);
survival("3","mdrc") = survival("1","mdrc")*(survival("5","mdrc")/survival("1","mdrc"))**(2/4);
survival("4","mdrc") = survival("1","mdrc")*(survival("5","mdrc")/survival("1","mdrc"))**(3/4);

display survival;

surv0(a299,surv) = survival(a299+1,surv)/survival(a299,surv);

surv0("1",surv) = survival("1",surv)/100000;

display surv0;

display edattainf, edattainm;

wf0(a,"12")$(ord(a) ge 13 and ord(a) le 24) = s0shf(a,"ps");
wf0(a,"15")$(ord(a) ge 13 and ord(a) le 24) = s0shf(a,"ls");
wf0(a,"18")$(ord(a) ge 13 and ord(a) le 24) = s0shf(a,"us");
wf0(a,"22")$(ord(a) ge 13 and ord(a) le 24) = s0shf(a,"ts");
wf0(a,"12")$(ord(a) ge 25 and ord(a) le 34) = edattainf("25","34","no")+edattainf("25","34","ptotal");
wf0(a,"12")$(ord(a) ge 35 and ord(a) le 44) = edattainf("35","44","no")+edattainf("35","44","ptotal");
wf0(a,"12")$(ord(a) ge 45 and ord(a) le 54) = edattainf("45","54","no")+edattainf("45","54","ptotal");
wf0(a,"12")$(ord(a) ge 55 and ord(a) le 65) = edattainf("55","64","no")+edattainf("55","64","ptotal");
wf0(a,"15")$(ord(a) ge 25 and ord(a) le 34) = edattainf("25","34","stotal")-edattainf("25","34","sc");
wf0(a,"15")$(ord(a) ge 35 and ord(a) le 44) = edattainf("35","44","stotal")-edattainf("35","44","sc");
wf0(a,"15")$(ord(a) ge 45 and ord(a) le 54) = edattainf("45","54","stotal")-edattainf("45","54","sc");
wf0(a,"15")$(ord(a) ge 55 and ord(a) le 65) = edattainf("55","64","stotal")-edattainf("55","64","sc");
wf0(a,"18")$(ord(a) ge 25 and ord(a) le 34) = edattainf("25","34","sc") + edattainf("25","34","ttotal")- edattainf("25","34","tc");
wf0(a,"18")$(ord(a) ge 35 and ord(a) le 44) = edattainf("35","44","sc") + edattainf("35","44","ttotal")- edattainf("35","44","tc");
wf0(a,"18")$(ord(a) ge 45 and ord(a) le 54) = edattainf("45","54","sc") + edattainf("45","54","ttotal")- edattainf("45","54","tc");
wf0(a,"18")$(ord(a) ge 55 and ord(a) le 65) = edattainf("55","64","sc") + edattainf("55","64","ttotal")- edattainf("55","64","tc");
wf0(a,"22")$(ord(a) ge 25 and ord(a) le 34) = edattainf("25","34","tc");
wf0(a,"22")$(ord(a) ge 35 and ord(a) le 44) = edattainf("35","44","tc");
wf0(a,"22")$(ord(a) ge 45 and ord(a) le 54) = edattainf("45","54","tc");
wf0(a,"22")$(ord(a) ge 55 and ord(a) le 65) = edattainf("55","64","tc");

wm0(a,"12")$(ord(a) ge 13 and ord(a) le 24) = s0shm(a,"ps");
wm0(a,"15")$(ord(a) ge 13 and ord(a) le 24) = s0shm(a,"ls");
wm0(a,"18")$(ord(a) ge 13 and ord(a) le 24) = s0shm(a,"us");
wm0(a,"22")$(ord(a) ge 13 and ord(a) le 24) = s0shm(a,"ts");
wm0(a,"12")$(ord(a) ge 25 and ord(a) le 34) = edattainm("25","34","no")+edattainm("25","34","ptotal");
wm0(a,"12")$(ord(a) ge 35 and ord(a) le 44) = edattainm("35","44","no")+edattainm("35","44","ptotal");
wm0(a,"12")$(ord(a) ge 45 and ord(a) le 54) = edattainm("45","54","no")+edattainm("45","54","ptotal");
wm0(a,"12")$(ord(a) ge 55 and ord(a) le 65) = edattainm("55","64","no")+edattainm("55","64","ptotal");
wm0(a,"15")$(ord(a) ge 25 and ord(a) le 34) = edattainm("25","34","stotal")-edattainm("25","34","sc");
wm0(a,"15")$(ord(a) ge 35 and ord(a) le 44) = edattainm("35","44","stotal")-edattainm("35","44","sc");
wm0(a,"15")$(ord(a) ge 45 and ord(a) le 54) = edattainm("45","54","stotal")-edattainm("45","54","sc");
wm0(a,"15")$(ord(a) ge 55 and ord(a) le 65) = edattainm("55","64","stotal")-edattainm("55","64","sc");
wm0(a,"18")$(ord(a) ge 25 and ord(a) le 34) = edattainm("25","34","sc") + edattainm("25","34","ttotal")- edattainm("25","34","tc");
wm0(a,"18")$(ord(a) ge 35 and ord(a) le 44) = edattainm("35","44","sc") + edattainm("35","44","ttotal")- edattainm("35","44","tc");
wm0(a,"18")$(ord(a) ge 45 and ord(a) le 54) = edattainm("45","54","sc") + edattainm("45","54","ttotal")- edattainm("45","54","tc");
wm0(a,"18")$(ord(a) ge 55 and ord(a) le 65) = edattainm("55","64","sc") + edattainm("55","64","ttotal")- edattainm("55","64","tc");
wm0(a,"22")$(ord(a) ge 25 and ord(a) le 34) = edattainm("25","34","tc");
wm0(a,"22")$(ord(a) ge 35 and ord(a) le 44) = edattainm("35","44","tc");
wm0(a,"22")$(ord(a) ge 45 and ord(a) le 54) = edattainm("45","54","tc");
wm0(a,"22")$(ord(a) ge 55 and ord(a) le 65) = edattainm("55","64","tc");

display wf0,wm0;
parameter w0(a,educ,g);
w0(a,educ,"female") = wf0(a,educ)*.01*popg0(a,"female");
w0(a,educ,"male") = wm0(a,educ)*.01*popg0(a,"male");

display w0;

parameter s0(a,g);
s0(a,"female") = popg0(a,"female")*s0shf(a,"s0sh")*.01;
s0(a,"male") = popg0(a,"male")*s0shm(a,"s0sh")*.01;

display s0;

execute_unload 'drcdata1.gdx' popg0,fert0,ferthic0,surv0,w0,s0,bed;
execute 'gdxxrw drcdata1.gdx par=popg0 rng=popg0!A1 par=fert0 rng=fert0!A1 par=ferthic0 rng=ferthic0!A1 par = surv0 rng=surv0!A1 par=w0 rng=w0!A1 par=s0 rng=s0!A1 par=bed rng=bed!A1'; ;
