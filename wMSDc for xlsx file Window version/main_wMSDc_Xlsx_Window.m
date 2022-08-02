%% OPTIONS SAVE
Save_CSV_option = 1; % Save results in a csv file (1 == ON; 0 == OFF)
OPTION_plot = 1; % Save figures (1 == ON; 0 == OFF)


%% %%%%%%%%%%%
%% USER INPUT Data dimension 1D or 2D
dimension = 2;

%% USER INPUT Parameters for window width and threshold
averaged_velocity = 0.6; % Estimate your averaged velocity for your dataset
minimal_velocity = 0.3; % Estimate your minimal velocity expected for your dataset

%% USER INPUT Time between 2 consecutive frames.
dt = 0.050; % in seconds
%% USER INPUT Pixel size in um
pxl_to_um = 0.53; % um

%% Start classifiying from the n-ieme molecule %(1 -> 1st molecule)
ik_part_start = 1; 

%% Advanced Settings: 
    %% OPTION Fixed threshold (1 == ON; 0 == OFF)
    Fixed_alpha_threshold_option = 0;
    alpha_threshold_fixed = 1.25;

    %% OPTION Fixed threshold (1 == ON; 0 == OFF)
    Fixed_Window_w_option = 0;
    Wfixed = 15; %(Min 15 and max 65)
    

    %% OPTION FAst switching (1 == ON; 0 == OFF)
    Fast_switch_option = 0;

    %% PARAMETERS for classification: Case direct turnaround = effect of the Window
    % Normal decrease when direct turnaround (Default = 0.15)
    decrease_direct_threshold_factor = 0.15;
    %% PARAMETERS for classification: Smoothing for directed transport directionality
    % Number of consecutive points taken to calculate the slope (+ or -) 
    % of the kymograph 
    % (Default = 30 recommanded or 15 for fast switching)
    smooth_value_directed_transport = 30;



%% START
%% Import data
path = 'E:\Script wMSDc for Matlab\Data\Motor proteins\';
file = 'Dynein_2Ddata.xlsx';
% Check if the folder results already exists
ifodersave = 1;
Foldersaveall = [path,'Results_', num2str(ifodersave),'\']

if exist(Foldersaveall,'dir')==0
    mkdir(Foldersaveall)
else
    while exist(Foldersaveall,'dir')~=0
    ifodersave = ifodersave+1;
    Foldersaveall = [path,'Results_', num2str(ifodersave),'\']
    
    end
    mkdir(Foldersaveall)
end

% Create the folder results if not existing
Foldersave = Foldersaveall;


Foldersavefig = [Foldersave,'Figures\'];
mkdir(Foldersavefig) 
%%

            
% Load the MATRIX containing Alpha values function of
% ratio PL/displacement
% Columns correspond to the ratio Noise on displacement
% Rows correspond to the window width
% Each value in the matrix corresponds to alpha value
% for each given couple
% (Noise_on_displacement, Window width)

MATRIX = [0	0.100000000000000	0.200000000000000	0.300000000000000	0.400000000000000	0.500000000000000	0.600000000000000	0.700000000000000	0.800000000000000	0.900000000000000	1	1.10000000000000	1.20000000000000	1.30000000000000	1.40000000000000	1.50000000000000	1.60000000000000	1.70000000000000	1.80000000000000	1.90000000000000	2	2.10000000000000	2.20000000000000	2.30000000000000	2.40000000000000	2.50000000000000	2.60000000000000	2.70000000000000	2.80000000000000	2.90000000000000	3	3.10000000000000	3.20000000000000	3.30000000000000	3.40000000000000	3.50000000000000	3.60000000000000	3.70000000000000	3.80000000000000	3.90000000000000	4	4.10000000000000	4.20000000000000	4.30000000000000	4.40000000000000	4.50000000000000	4.60000000000000	4.70000000000000	4.80000000000000	4.90000000000000	5	5.10000000000000	5.20000000000000	5.30000000000000	5.40000000000000	5.50000000000000	5.60000000000000	5.70000000000000	5.80000000000000	5.90000000000000	6	6.10000000000000	6.20000000000000	6.30000000000000	6.40000000000000	6.50000000000000	6.60000000000000	6.70000000000000	6.80000000000000	6.90000000000000	7
    NaN	NaN	NaN	NaN	NaN	NaN	NaN	1.81259885653809	1.76769409268804	1.72278932883798	1.67788456498792	1.64889000627335	1.60819063510848	1.56602816238733	1.52386568966618	1.48170321694503	1.43739520275272	1.39629703402551	1.36161855622848	1.32694007843145	1.29226160063442	1.25758312283739	1.22290464504036	1.18835017832940	1.15383114335732	1.11931210838524	1.08479307341317	1.05383773900679	1.03000980573182	1.00618187245685	0.982353939181885	0.958526005906917	0.934698072631948	0.910870139356980	0.884882631961527	0.857815337505831	0.830748043050135	0.803680748594440	0.776613454138744	0.749546159683048	0.722478865227353	0.707667528436262	0.692856191645171	0.678044854854080	0.663233518062990	0.648422181271899	0.633610844480808	0.618799507689718	0.603988170898627	0.589176834107536	0.574365497316445	0.559554160525355	0.544742823734264	0.529931486943173	0.515120150152082	0.500308813360992	0.485497476569901	0.470686139778810	0.455874802987719	0.441063466196629	0.426252129405538	0.411440792614447	0.396629455823356	0.381818119032266	0.367006782241175	0.352195445450084	0.337384108658994	NaN	NaN	NaN	NaN
    NaN	NaN	NaN	NaN	NaN	NaN	NaN	1.86162753748829	1.82755252173065	1.79347750597301	1.75940249021537	1.73691338250424	1.70543581107102	1.67283468167255	1.64023355227407	1.60763242287559	1.57262513857520	1.53977543009258	1.51124087324547	1.48270631639837	1.45417175955127	1.42563720270416	1.39710264585706	1.36793270083274	1.33858121632923	1.30922973182571	1.27987824732220	1.25380241773701	1.23427789798847	1.21475337823992	1.19522885849138	1.17570433874284	1.15617981899429	1.13665529924575	1.11308908820834	1.08750203152651	1.06191497484467	1.03632791816283	1.01074086148099	0.985153804799150	0.959566748117312	0.943413837727907	0.927260927338503	0.911108016949099	0.894955106559695	0.878802196170290	0.862649285780886	0.846496375391482	0.830343465002078	0.814190554612674	0.798037644223269	0.781884733833865	0.765731823444461	0.749578913055057	0.733426002665652	0.717273092276248	0.701120181886844	0.684967271497440	0.668814361108036	0.652661450718631	0.636508540329227	0.620355629939823	0.604202719550419	0.588049809161015	0.571896898771610	0.555743988382206	0.539591077992802	NaN	NaN	NaN	NaN
    NaN	NaN	NaN	NaN	NaN	NaN	NaN	1.88218808448390	1.85295563337565	1.82372318226739	1.79449073115914	1.77442669804060	1.74734676657100	1.71938984780752	1.69143292904404	1.66347601028056	1.63301766774637	1.60435293894555	1.57927543761149	1.55419793627742	1.52912043494335	1.50404293360929	1.47896543227522	1.45189882303595	1.42426389725234	1.39662897146873	1.36899404568511	1.34495098585575	1.32809165793487	1.31123233001399	1.29437300209311	1.27751367417224	1.26065434625136	1.24379501833048	1.22218186341439	1.19819179500069	1.17420172658699	1.15021165817329	1.12622158975959	1.10223152134589	1.07824145293219	1.06229449972478	1.04634754651737	1.03040059330996	1.01445364010254	0.998506686895134	0.982559733687723	0.966612780480313	0.950665827272902	0.934718874065491	0.918771920858080	0.902824967650670	0.886878014443259	0.870931061235848	0.854984108028437	0.839037154821026	0.823090201613616	0.807143248406205	0.791196295198794	0.775249341991383	0.759302388783972	0.743355435576562	0.727408482369151	0.711461529161740	0.695514575954329	0.679567622746918	0.663620669539508	NaN	NaN	NaN	NaN
    NaN	NaN	NaN	NaN	NaN	NaN	NaN	1.90350397212882	1.87932473178181	1.85514549143480	1.83096625108779	1.81520183359776	1.79257339688314	1.76908695776545	1.74560051864776	1.72211407953007	1.69597931430506	1.67134520047105	1.64971238941906	1.62807957836708	1.60644676731509	1.58481395626310	1.56318114521112	1.53999873579336	1.51637358398538	1.49274843217740	1.46912328036942	1.44841310521386	1.43353288336314	1.41865266151243	1.40377243966172	1.38889221781100	1.37401199596029	1.35913177410958	1.33915818958020	1.31663792371148	1.29411765784276	1.27159739197405	1.24907712610533	1.22655686023661	1.20403659436790	1.18928090813404	1.17452522190018	1.15976953566633	1.14501384943247	1.13025816319861	1.11550247696476	1.10074679073090	1.08599110449704	1.07123541826319	1.05647973202933	1.04172404579547	1.02696835956162	1.01221267332776	0.997456987093905	0.982701300860049	0.967945614626192	0.953189928392336	0.938434242158480	0.923678555924623	0.908922869690767	0.894167183456910	0.879411497223054	0.864655810989197	0.849900124755341	0.835144438521484	0.820388752287628	NaN	NaN	NaN	NaN
    NaN	NaN	NaN	NaN	NaN	NaN	NaN	1.91395248739866	1.89226084162860	1.87056919585854	1.84887755008848	1.83483982251839	1.81444477269918	1.79325505759882	1.77206534249847	1.75087562739811	1.72736376061722	1.70505491707009	1.68515211999049	1.66524932291089	1.64534652583129	1.62544372875168	1.60554093167208	1.58465513511365	1.56348848156126	1.54232182800888	1.52115517445650	1.50240772271174	1.48849867458224	1.47458962645274	1.46068057832324	1.44677153019375	1.43286248206425	1.41895343393475	1.40058647646719	1.37999056433059	1.35939465219400	1.33879874005740	1.31820282792081	1.29760691578422	1.27701100364762	1.26238363075806	1.24775625786850	1.23312888497894	1.21850151208938	1.20387413919982	1.18924676631026	1.17461939342069	1.15999202053113	1.14536464764157	1.13073727475201	1.11610990186245	1.10148252897289	1.08685515608333	1.07222778319377	1.05760041030420	1.04297303741464	1.02834566452508	1.01371829163552	0.999090918745959	0.984463545856398	0.969836172966837	0.955208800077276	0.940581427187714	0.925954054298153	0.911326681408592	0.896699308519031	NaN	NaN	NaN	NaN
    NaN	NaN	NaN	NaN	NaN	NaN	NaN	1.92662607199843	1.90965118534789	1.89267629869735	1.87570141204682	1.85872652539628	1.84021539446898	1.82151223300709	1.80280907154520	1.78410591008331	1.76355893216604	1.74409075002995	1.72678015945622	1.70946956888249	1.69215897830877	1.67484838773504	1.65753779716131	1.63872903039957	1.61949221329839	1.60025539619721	1.58101857909604	1.56418461192204	1.55215634460241	1.54012807728277	1.52809980996314	1.51607154264350	1.50404327532387	1.49201500800423	1.47522957414085	1.45606555700559	1.43690153987033	1.41773752273507	1.39857350559981	1.37940948846455	1.36024547132929	1.34684899121638	1.33345251110348	1.32005603099058	1.30665955087767	1.29326307076477	1.27986659065187	1.26647011053896	1.25307363042606	1.23967715031316	1.22628067020025	1.21288419008735	1.19948770997445	1.18609122986154	1.17269474974864	1.15929826963574	1.14590178952283	1.13250530940993	1.11910882929703	1.10571234918412	1.09231586907122	1.07891938895831	1.06552290884541	1.05212642873251	1.03872994861960	1.02533346850670	1.01193698839380	NaN	NaN	NaN	NaN
    NaN	NaN	NaN	NaN	NaN	NaN	NaN	1.93281845495576	1.91723437599560	1.90165029703544	1.88606621807528	1.87048213911512	1.85347194052880	1.83628347698921	1.81909501344962	1.80190654991003	1.78303738656531	1.76507328027065	1.74891928807614	1.73276529588163	1.71661130368712	1.70045731149260	1.68430331929809	1.66719470005028	1.64981333021581	1.63243196038134	1.61505059054687	1.59964974997334	1.58820996792166	1.57677018586999	1.56533040381831	1.55389062176664	1.54245083971496	1.53101105766329	1.51532348490867	1.49751201680257	1.47970054869648	1.46188908059039	1.44407761248430	1.42626614437821	1.40845467627211	1.39547172137563	1.38248876647915	1.36950581158267	1.35652285668619	1.34353990178971	1.33055694689323	1.31757399199675	1.30459103710027	1.29160808220379	1.27862512730731	1.26564217241083	1.25265921751435	1.23967626261787	1.22669330772139	1.21371035282491	1.20072739792843	1.18774444303195	1.17476148813547	1.16177853323899	1.14879557834251	1.13581262344603	1.12282966854955	1.10984671365307	1.09686375875659	1.08388080386011	1.07089784896363	NaN	NaN	NaN	NaN
    NaN	NaN	NaN	NaN	NaN	NaN	NaN	1.94046813369105	1.92660529825901	1.91274246282698	1.89887962739494	1.88501679196291	1.86980712901451	1.85442911262657	1.83905109623863	1.82367307985068	1.80667953164582	1.79055743463194	1.77617823999998	1.76179904536803	1.74741985073608	1.73304065610413	1.71866146147218	1.70298597797218	1.68694012622418	1.67089427447617	1.65484842272816	1.64078462329108	1.63068492847583	1.62058523366058	1.61048553884533	1.60038584403009	1.59028614921484	1.58018645439959	1.56594440328269	1.54963117401497	1.53331794474724	1.51700471547951	1.50069148621179	1.48437825694406	1.46806502767634	1.45591388346139	1.44376273924644	1.43161159503149	1.41946045081655	1.40730930660160	1.39515816238665	1.38300701817170	1.37085587395676	1.35870472974181	1.34655358552686	1.33440244131191	1.32225129709697	1.31010015288202	1.29794900866707	1.28579786445212	1.27364672023718	1.26149557602223	1.24934443180728	1.23719328759233	1.22504214337739	1.21289099916244	1.20073985494749	1.18858871073254	1.17643756651759	1.16428642230265	1.15213527808770	NaN	NaN	NaN	NaN
    NaN	NaN	NaN	NaN	NaN	NaN	NaN	1.94472054875658	1.93183568769973	1.91895082664288	1.90606596558603	1.89318110452919	1.87900112740266	1.86465926076742	1.85031739413219	1.83597552749695	1.82010735686295	1.80502036670299	1.79149573749111	1.77797110827922	1.76444647906733	1.75092184985544	1.73739722064355	1.72270753736612	1.70768498149852	1.69266242563092	1.67763986976333	1.66445632710048	1.65495081084712	1.64544529459377	1.63593977834042	1.62643426208707	1.61692874583371	1.60742322958036	1.59371804464857	1.57791302537757	1.56210800610656	1.54630298683556	1.53049796756456	1.51469294829355	1.49888792902255	1.48727702541962	1.47566612181669	1.46405521821377	1.45244431461084	1.44083341100791	1.42922250740499	1.41761160380206	1.40600070019913	1.39438979659620	1.38277889299328	1.37116798939035	1.35955708578742	1.34794618218450	1.33633527858157	1.32472437497864	1.31311347137572	1.30150256777279	1.28989166416986	1.27828076056693	1.26666985696401	1.25505895336108	1.24344804975815	1.23183714615523	1.22022624255230	1.20861533894937	1.19700443534645	NaN	NaN	NaN	NaN
    NaN	NaN	NaN	NaN	NaN	NaN	NaN	1.95010267035647	1.93844798905512	1.92679330775378	1.91513862645244	1.90348394515109	1.89050615355576	1.87736297317367	1.86421979279159	1.85107661240950	1.83681510389406	1.82318943982450	1.81083546464669	1.79848148946888	1.78612751429108	1.77377353911327	1.76141956393546	1.74793661705368	1.73413110682791	1.72032559660214	1.70652008637636	1.69442264161616	1.68574132778710	1.67706001395804	1.66837870012898	1.65969738629992	1.65101607247086	1.64233475864180	1.62973289818396	1.61517076441173	1.60060863063949	1.58604649686726	1.57148436309503	1.55692222932279	1.54236009555056	1.53128564184324	1.52021118813593	1.50913673442861	1.49806228072130	1.48698782701398	1.47591337330666	1.46483891959935	1.45376446589203	1.44269001218472	1.43161555847740	1.42054110477008	1.40946665106277	1.39839219735545	1.38731774364814	1.37624328994082	1.36516883623350	1.35409438252619	1.34301992881887	1.33194547511156	1.32087102140424	1.30979656769693	1.29872211398961	1.28764766028229	1.27657320657498	1.26549875286766	1.25442429916035	NaN	NaN	NaN	NaN
    NaN	NaN	NaN	NaN	NaN	NaN	NaN	1.95309313708718	1.94212652830293	1.93115991951868	1.92019331073442	1.90922670195017	1.89698701373734	1.88458819059595	1.87218936745455	1.85979054431316	1.84646521214897	1.83366867356924	1.82192972215842	1.81019077074759	1.79845181933676	1.78671286792594	1.77497391651511	1.76221674033203	1.74916864278546	1.73612054523888	1.72307244769230	1.71162402015369	1.70337493263101	1.69512584510833	1.68687675758565	1.67862767006297	1.67037858254029	1.66212949501761	1.65011875603452	1.63622719132123	1.62233562660793	1.60844406189464	1.59455249718134	1.58066093246805	1.56676936775475	1.55632947526277	1.54588958277079	1.53544969027881	1.52500979778682	1.51456990529484	1.50413001280286	1.49369012031088	1.48325022781890	1.47281033532692	1.46237044283494	1.45193055034296	1.44149065785097	1.43105076535899	1.42061087286701	1.41017098037503	1.39973108788305	1.38929119539107	1.37885130289909	1.36841141040710	1.35797151791512	1.34753162542314	1.33709173293116	1.32665184043918	1.31621194794720	1.30577205545522	1.29533216296324	NaN	NaN	NaN	NaN];
%%
% Create the Matrix alpha with a continous
% possibility of Window width
colWW =[15,21,25,31,35,41,45,51,55,61,65];
colWWline = 15:65;
NEW_MATRIX = zeros(size(colWWline,2),size(MATRIX,2));
for imatrix = 1:size(MATRIX,2)
    Alphainterp2hhere = interp1(colWW,MATRIX(2:end,imatrix),colWWline');

    NEW_MATRIX(:,imatrix) = Alphainterp2hhere;
end
NEW_MATRIX = [MATRIX(1,:);NEW_MATRIX];

% Load all the Data contained in the xlsx
if dimension == 1
    [PAR] = readdata_1D([path,file]);
elseif dimension == 2
    [PAR,ORT] = readdata([path,file]);
    checkparort(PAR,ORT);   %Check if PAR and ORT have the right size
    % checkparort(TIM,ORT); %Check if TIM and ORT have the right size
    % [D,l]=displacement2(PAR,ORT); %Find the displacement as function of time
    
end

% Loop over the data
for ik_part = ik_part_start:size(PAR,2)

    % Get the data for this trajectory
    % Store X and Y values
    XC = PAR{ik_part};
    if dimension == 1
        YC = 0.*randn(1,size(XC,1))';
    elseif dimension == 2
        YC = ORT{ik_part};
    end
    % Store Time
    TIME = [1:size(PAR{ik_part},1)]';

    % Create a Time vector from 0 to number of frames in the trajectory (frame)
    % in case the experimental Time vector contains
    % missing values
    XCh = XC(isnan(XC)==0);
    YCh = YC(isnan(XC)==0);
    TIMEh = TIME(isnan(XC)==0);
    
    % Interpolate vectors X and Y in case of
    % missing values - linear interpolation (degree = 1)
    XC = interp1(TIMEh,XCh,TIME)*pxl_to_um;% X and Y converted in um
    YC = interp1(TIMEh,YCh,TIME)*pxl_to_um;
    
    %% Calculate the precision of localization using
    % the global MSD in the X direction
    
    % Calculate MSD
    numberoflagsmax = 600;
    [LagTtt,MSD_meantt,MSD_stdtt,yfittt,ptt] = MSD(XC,TIME*dt,min(numberoflagsmax,(size(TIME,1))),dt);

    % Perform a linear fit of the MSD on the 3
    % first points - fittedDtt(1) = intercept and
    % fittedDtt(2) = slope
    fittedDtt = polyfit(LagTtt(1:3), MSD_meantt(1:3),1);
    % Force the PL at 0.035 um if the slope if negative
    if fittedDtt(2)<=0
        Precision_localization = 0.035;
    else
        Precision_localization = max(sqrt(fittedDtt(2)),0.035);
    end

    %% Calculate the Optimal window
    % Ratio Noise on average displacement
    Noise_on_displacement = (Precision_localization)/(averaged_velocity*dt);
    
    
    % Find the column in the Matrix_Alpha corresponding to the Ratio PL/displacement
    if Noise_on_displacement > 6.7
        ii_noise = size(NEW_MATRIX,2)-4;
    else
        ii_noise = round(mean(find(NEW_MATRIX(1,:)>=Noise_on_displacement-0.1 & NEW_MATRIX(1,:)<=Noise_on_displacement+0.1)));
        
    end


    
    % Same for the Ratio PL on diplacement for the minimal detectable velocity                              
    Noise_on_displacementMINhere = min((Precision_localization)./(minimal_velocity*dt),6.7);
    if Noise_on_displacementMINhere>=6.7
        ii_noise_min = size(NEW_MATRIX,2)-4;
    else
        ii_noise_min = round(mean(find(NEW_MATRIX(1,:)>=Noise_on_displacementMINhere-0.1 & NEW_MATRIX(1,:)<=Noise_on_displacementMINhere+0.1)));
        
    end

    
    % Find the line (WW) in the matrix
    % Determine the window width AUTOMATICALLY
    % Minimal threshold alpha to determine the
    % window width for the minimum velocity

    alpha_mminforwindow = 1;

    % find the minimal row (irow) in the matrix with
    % alpha > 'alpha_mminforwindow' for
    % the minimal velocity and alpha
    % between min and maxthreshold for
    % the averaged velocity    

    if ii_noise >=  8 && ii_noise_min >= 8
    % Case when the PL/displacement is higher than
    % (or equal to) 0.7. Below 0.7, alpha is high
    % and the window would be smaller than 15 times
    % points, which is not possible due to
    % statistical reasons (i.e. MSD)


        % Alpha values of the 2 columns PL/min disp and PL/mean disp
        Alphavalues_forminvelocity = NEW_MATRIX(2:end,ii_noise_min);
        Alphavalues_forMEANvelocity = NEW_MATRIX(2:end,ii_noise);

       
        if Fixed_Window_w_option == 1
            % Case Fixed window width
            % Min 15 and max 65

            WW_set  = Wfixed;
            irow = find(colWWline==WW_set);
            alpha_max_at03 = Alphavalues_forminvelocity(irow);
            alpha_averaged_velocity = Alphavalues_forMEANvelocity(irow);
           
        else
            % Case semi-automatic for finding the window width

            % Max threshold
            maxthreshold = 1.8;
            % Min threshold for alpha(PL/mean) depending on alpha values for
            % the minimal velocity
            minthreshold = min(max(Alphavalues_forminvelocity),maxthreshold-0.1);
            
            % Select the minimal window width value respecting the
            % conditions on alpha
            irow = round(min(find(Alphavalues_forminvelocity>=alpha_mminforwindow & Alphavalues_forMEANvelocity<=maxthreshold & Alphavalues_forMEANvelocity>=minthreshold)));
            
            if isempty(irow)==1
            % If this is empty, you take
            % the maximal value for the
            % window width = 65 frames
                WW_set = max(colWWline);
                alpha_max_at03 = Alphavalues_forminvelocity(end);
                alpha_averaged_velocity = Alphavalues_forMEANvelocity(end);
            else
                % take the corresponding window width
                WW_set = colWWline(irow);
                alpha_max_at03 = Alphavalues_forminvelocity(irow); 
                alpha_averaged_velocity = Alphavalues_forMEANvelocity(irow);
               
            end
        end

    else
        % Case when PL/displacement is lower than 0.7
        % Window width is set at 15 time points
        WW_set = 15;
        alpha_max_at03 = 1.3;%NEW_MATRIX(2,8);
        alpha_averaged_velocity = 1.3;%NEW_MATRIX(2,8);
%                             alpha_max_at03 = NEW_MATRIX(2,ii_noise_min);
%                             alpha_averaged_velocity = NEW_MATRIX(2,ii_noise);
    end


    % Add odd value condition for the Window width
    if mod(WW_set,2)==1
        Window_width = WW_set;
    else
        Window_width = WW_set-1;
    end

    %% Alpha analysis
    % Selection of trajectories with a number of
    % time points above the window width

    if size(XC,1)<=Window_width
    else
        
        
        % Initialization of the tables
        
        Offsets_Par_Per = [];
        Tout = [];
        Tout15 = [];                                
        XY_alpha_PAR_ORT = [];
        T_alpha_PAR_ORT = [];
        XY_mean_alpha_PAR_ORT_MSD = [];
            


        %% Calculate alpha in the sliding WW
        ss = round((Window_width)/2)-1;
        
        for it = ss+1:1:length(XC)-ss
            [it length(XC)-ss]
           

            % Alpha power law function
            if dimension == 2
                % 2D data
                [ID,Offset_par,Offset_per,alpha_local_par,alpha_local_per,alpha_local_2D,MSD_meanPAR,MSD_meanPER,LagTPAR,LagTPER] = Alpha_power_law(XC,YC,ss,it,TIME,dt,Window_width);
            else
                % 1D data
                [ID,Offset_par,Offset_per,alpha_local_par,alpha_local_per,MSD_meanPAR,MSD_meanPER,LagTPAR,LagTPER] = Alpha_power_law_1D(XC,YC,ss,it,TIME,dt,Window_width);
            end

            %% Store Results in matrix
            % Offset of local MSD / PL
            Offsets_Par_Per = [Offsets_Par_Per; [(XC(it)),(YC(it)),Offset_par Offset_per]];
            % Corresponding Time in Frame
            Tout = [Tout; it];
            Tout15 = [Tout15;TIME(ID)];  
            % Alpha par and alpha per
            if dimension == 2
            % 2D data
                XY_alpha_PAR_ORT = [XY_alpha_PAR_ORT;[XC(ID),YC(ID), alpha_local_par.*ones(size(XC(ID),1),1) alpha_local_per.*ones(size(XC(ID),1),1) alpha_local_2D.*ones(size(XC(ID),1),1)]];
            else
                XY_alpha_PAR_ORT = [XY_alpha_PAR_ORT;[XC(ID),YC(ID), alpha_local_par.*ones(size(XC(ID),1),1) alpha_local_per.*ones(size(XC(ID),1),1)]];
            end
            T_alpha_PAR_ORT = [T_alpha_PAR_ORT;[TIME(ID) alpha_local_par.*ones(size(XC(ID),1),1) alpha_local_per.*ones(size(XC(ID),1),1)]];
            % MSD values
            XY_mean_alpha_PAR_ORT_MSD = [XY_mean_alpha_PAR_ORT_MSD;[(XC(it)),(YC(it)), alpha_local_par alpha_local_per MSD_meanPAR LagTPAR  MSD_meanPER LagTPER]];
            
        end     
        %% Classification
        RESULTSEND = [];                       
        Time_in_AA = [];
        Time_in_AR = [];
        Time_in_RA = [];
        Time_in_RR = [];
        
        % X, Y, alpha par, alpha per and time
        XXC = XY_alpha_PAR_ORT(:,1);
        YYC = XY_alpha_PAR_ORT(:,2);
        AAC = XY_alpha_PAR_ORT(:,3);
        if dimension == 2
            AA2DC = XY_alpha_PAR_ORT(:,5);
        else
        end
        AACp = XY_alpha_PAR_ORT(:,4);
        ToutGG = T_alpha_PAR_ORT(:,1);


        % Sort by time
        [~,sortTC] = sort(ToutGG);
        XXC = XY_alpha_PAR_ORT(sortTC,1);
        YYC = XY_alpha_PAR_ORT(sortTC,2);
        AAC = XY_alpha_PAR_ORT(sortTC,3);
        if dimension == 2
            AA2DC = XY_alpha_PAR_ORT(sortTC,5);
        else
            AA2DC = AAC;
        end
        AACp = XY_alpha_PAR_ORT(sortTC,4);
        ToutGG = T_alpha_PAR_ORT(sortTC,1);


        % Eliminate nan values in positions
        XXCb = XXC(~isnan(XXC) & ~isnan(YYC));
        YYCb =YYC(~isnan(XXC) & ~isnan(YYC));
        AACb =AAC(~isnan(XXC) & ~isnan(YYC));
        AAC2Db =AA2DC(~isnan(XXC) & ~isnan(YYC));
        AACpb =AACp(~isnan(XXC) & ~isnan(YYC));
        ToutGGb =ToutGG(~isnan(XXC) & ~isnan(YYC));


        % Initialization of the tables
        XXCg = zeros(size([min(ToutGGb):max(ToutGGb)],2),1);
        YYCg = zeros(size([min(ToutGGb):max(ToutGGb)],2),1);
        AACg = zeros(size([min(ToutGGb):max(ToutGGb)],2),1);
        AAC2Dg = zeros(size([min(ToutGGb):max(ToutGGb)],2),1);
        AACpg = zeros(size([min(ToutGGb):max(ToutGGb)],2),1);
        ToutGGg = zeros(size([min(ToutGGb):max(ToutGGb)],2),1);
        ith = 0;
        for itt = min(ToutGGb):max(ToutGGb)
            ith =ith +1;
            XXCg(ith) = mean(XXCb(ToutGGb==itt));
            YYCg(ith) = mean(YYCb(ToutGGb==itt));
            AACg(ith) = mean(AACb(ToutGGb==itt));
            AAC2Dg(ith) = mean(AAC2Db(ToutGGb==itt));
            AACpg(ith) = mean(AACpb(ToutGGb==itt));
            ToutGGg(ith) = mean(ToutGGb(ToutGGb==itt));

        end


        %New positins and their alpha values
        Xxhereconv = XXCg(~isnan(XXCg) & ~isnan(YYCg));
        Yyhereconv =YYCg(~isnan(XXCg) & ~isnan(YYCg));
        AAhereconv =AACg(~isnan(XXCg) & ~isnan(YYCg));
        AAhereconv2D  =AAC2Dg(~isnan(XXCg) & ~isnan(YYCg));
        AAhereconvp =AACpg(~isnan(XXCg) & ~isnan(YYCg));
        TThereconvp =ToutGGg(~isnan(XXCg) & ~isnan(YYCg));



        % Calulate the diffusion coefficient in the perpendicular direction
        % 'MSD' per for three time lag
        MSDper1 = (Yyhereconv(2:end)-Yyhereconv(1:end-1)).^2;
        MSDper2 = (Yyhereconv(3:end)-Yyhereconv(1:end-2)).^2;
        MSDper3 = (Yyhereconv(4:end)-Yyhereconv(1:end-3)).^2;
        DDlper = [MSDper1(1:end-2)  MSDper2(1:end-1) MSDper3];

        D_Holcman_fitper = zeros(size([1:size(DDlper,1)],2),1);
        Pre_locper =zeros(size([1:size(DDlper,1)],2),1);

        for eachdiff = 1:size(DDlper,1)
            p = polyfit([1 2 3].*dt,DDlper(eachdiff,:),1);
            Pre_locper(eachdiff) = p(2);                            
            D_Holcman_fitper(eachdiff) = p(1)/2;
        end
       
        % Calulate the diffusion coefficient in the parallel direction
        % 'MSD' per for three time lag
        MSDpar1 = (Xxhereconv(2:end)-Xxhereconv(1:end-1)).^2;
        MSDpar2 = (Xxhereconv(3:end)-Xxhereconv(1:end-2)).^2;
        MSDpar3 = (Xxhereconv(4:end)-Xxhereconv(1:end-3)).^2;
        DDlpar = [MSDpar1(1:end-2)  MSDpar2(1:end-1) MSDpar3];

        D_Holcman_fitpar = zeros(size([1:size(DDlpar,1)],2),1);
        Pre_locpar = zeros(size([1:size(DDlpar,1)],2),1);

        for eachdiff = 1:size(DDlpar,1)
            p = polyfit([1 2 3].*dt,DDlpar(eachdiff,:),1);
            Pre_locpar(eachdiff) = p(2);
            D_Holcman_fitpar(eachdiff) = p(1)/2;
        end


        %%
        % Calcul velocity
        velocityHolcmanpar = (Xxhereconv(2:end)-Xxhereconv(1:end-1))./(TThereconvp(2:end)-TThereconvp(1:end-1))./dt;
        velocityHolcmanper = (Yyhereconv(2:end)-Yyhereconv(1:end-1))./(TThereconvp(2:end)-TThereconvp(1:end-1))./dt;                        %                             velocityHolcman = (Xxhereconv(2:end)-Xxhereconv(1:end-1))./(TThereconvp(2:end)-TThereconvp(1:end-1))./dt;
        nbpts = 4;
        VELOCITYpar = zeros(size([1+nbpts : size(Xxhereconv,1)-nbpts],2),1);
        VELOCITYper = zeros(size([1+nbpts : size(Xxhereconv,1)-nbpts],2),1);
        
        ith2 = 0;
        for it = 1+nbpts : size(Xxhereconv,1)-nbpts
            ith2 = ith2+1;
            p = polyfit(TThereconvp(it+[-nbpts:nbpts]).*dt,Xxhereconv(it+[-nbpts:nbpts]),1);
            p2 = polyfit(TThereconvp(it+[-nbpts:nbpts]).*dt,Yyhereconv(it+[-nbpts:nbpts]),1);
            
            VELOCITYpar(ith2) = p(1);
            VELOCITYper(ith2) = p2(1);
        end

        VELOCITYparall = [VELOCITYpar(1)*ones(nbpts,1);VELOCITYpar;VELOCITYpar(end)*ones(nbpts,1)];
        VELOCITYperall = [VELOCITYper(1)*ones(nbpts,1);VELOCITYper;VELOCITYper(end)*ones(nbpts,1)];


        %% Calculate the alpha value threshold
        %% Default settings
    
        % Take the middle between the min and max value
        % of alpha with min alpha above 0.
        alpha_thresholdc = max(AAhereconv)-(max(AAhereconv)-max(0,min(AAhereconv)))/2;


        alpha_threshold1 = alpha_thresholdc;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        if alpha_threshold1>max(AAhereconv)-max(AAhereconv)*decrease_direct_threshold_factor
           % lower the threshold below 1 when it is higher than the
           % 'normal' decrease during a direct turn
           if alpha_max_at03> 1
               % Set the threshold at 1 when alpha for 
               % the minimal velocity
               % is higher than 1.
               
                alpha_threshold1 = 1;
           else
               % Case when the alpha for the minimal
               % velocity is lower than 1
                alpha_threshold1 = alpha_max_at03;
            end
        else
        end
     

        %% OPTION FAst switching
        if Fast_switch_option == 1
               
                % Case when 2 or more switches occurs
                % in a laps of time lower than the
                % window width. Alpha will decrease on a 
                % longer period of time than in the case of a single direct turn
                % the threshold is then calculated
                % using the median instead of the max
                
                
                alpha_thresholdc2 = median(AAhereconv(AAhereconv>=alpha_thresholdc))-(median(AAhereconv(AAhereconv>=alpha_thresholdc))-max(min(AAhereconv),0))/2;
                alpha_threshold1 = alpha_thresholdc2;

            if alpha_threshold1>max(AAhereconv)-max(AAhereconv)*decrease_direct_threshold_factor
               % lower the threshold below 1 when it is higher than the
               % 'normal' decrease during a direct turn
               if alpha_max_at03> 1
                   % Set the threshold at 1 when alpha for 
                   % the minimal velocity
                   % is higher than 1.
                   
                    alpha_threshold1 = 1;
               else
                   % Case when the alpha for the minimal
                   % velocity is lower than 1
                    alpha_threshold1 = alpha_max_at03;
                end
            else
            end
        end

        if dimension == 2
            % Case 2D data: Apply the condition on alpha
            % perpendicular
            AAhereconvpo = (AAhereconvp);
            AAhereconvpo(AAhereconvpo<0)=0;


            if max(AAhereconv-AAhereconvp)<=alpha_max_at03-0.5
                alpha_threshold1 = max(AAhereconv);
            elseif max(AAhereconv-AAhereconvp)>alpha_max_at03-0.5 
                criteria4 = round(AAhereconv2D(find(AAhereconv-AAhereconvp==max(AAhereconv-AAhereconvp))),2);
                criteria4(criteria4<0) = 0;
                criteria4l = round(AAhereconv(find(AAhereconv-AAhereconvp==max(AAhereconv-AAhereconvp))) - 1/6,2);
                
                criteria4l(criteria4<0) = 0;
                
                if criteria4<=criteria4l && round(max(AAhereconvp),2)>round(alpha_max_at03-0.2,2)
           
                    alpha_threshold1 = max(AAhereconv);%%%
                else
                end
            end
              
        else
        end
        
        %% OPTION Fixed threshold
        if Fixed_alpha_threshold_option == 1

            alpha_threshold1 = alpha_threshold_fixed;
        else
        end
        
        if OPTION_plot == 1
        %% PLot Alpha values color-coded
        
        colors = jet;
        ALPHA_MAX = 2;
        ALPHA_MIN = 0;
        ALPHA = AAhereconv;
        ALPHA(ALPHA<0)=0;
        ALPHA(ALPHA>2)=2;
        ALPHA_NORM = (ALPHA-ALPHA_MIN)./(ALPHA_MAX-ALPHA_MIN);
        discret = 1./(size(colors,1)-1);
        ithere = floor(ALPHA_NORM./discret)+1;

        %% Plot XY- traj
        figure(1)
        hold off
        for iii = 1:size(ithere,1)

            plot(Xxhereconv(iii)-min(Xxhereconv),Yyhereconv(iii)-min(Yyhereconv),'o','color',colors(ithere(iii),:,:),'MarkerFaceColor',colors(ithere(iii),:,:),'linewidth',2)
            hold on

        end
        plot(Xxhereconv-min(Xxhereconv),Yyhereconv-min(Yyhereconv),'--k','linewidth',1.1)
        caxis([0 2])

        c1 = colorbar;
        colormap(jet)
        c1.Label.String = '\alpha_{//}';
        c1.Limits = [0 2];
        set(gca,'fontsize',12)

        xlabel('X \mum')
        ylabel('Y \mum')


        xlim([min(Xxhereconv-min(Xxhereconv))-1 max(Xxhereconv-min(Xxhereconv))+1])
        xLIM_val = (max(Xxhereconv-min(Xxhereconv))+1-(min(Xxhereconv-min(Xxhereconv))-1))/2;
        ylim([-xLIM_val xLIM_val])
        saveas(1,[Foldersavefig,'Alphapar_value_XY_N_' num2str(ik_part,'00%.0f'),'_p.fig'])
        saveas(1,[Foldersavefig,'Alphapar_value_XY_N_' num2str(ik_part,'00%.0f'),'_p.png'])
        
        
       
        end
        %% Plot YT- traj
        figure(2)
        hold off
        for iii = 1:size(ithere,1)

            plot(TThereconvp(iii)*dt,Xxhereconv(iii),'o','color',colors(ithere(iii),:,:),'MarkerFaceColor',colors(ithere(iii),:,:),'linewidth',2)
            hold on

        end
        plot(TThereconvp*dt,Xxhereconv,'--k','linewidth',1.1)
        caxis([0 2])

        c2 = colorbar;
        colormap(jet)
        c2.Label.String = '\alpha_{//}';
        c2.Limits = [0 2];
        set(gca,'fontsize',12)

        xlabel('Time (s)')
        ylabel('X (\mum)')
        ylim([min(Xxhereconv)-1 max(Xxhereconv)+1])
        xlim([0 max(TThereconvp(iii)*dt)+3.*dt])

        saveas(2,[Foldersavefig,'Alphapar_value_XT_N_' num2str(ik_part,'00%.0f'),'_p.fig'])
        saveas(2,[Foldersavefig,'Alphapar_value_XT_N_' num2str(ik_part,'00%.0f'),'_p.png'])
        
        
        %% Plot alpha-T values and threshold
        figure(3)
        hold off
        plot(TThereconvp*dt,AAhereconv,'-k','linewidth',1.5)
        hold on
        plot(TThereconvp*dt,alpha_threshold1+TThereconvp*0,'-r','linewidth',1.5)
        ylabel('\alpha_{//}')
        xlabel('Time (s)')

        set(gca,'fontsize',14)
        xlim([0 max(TThereconvp(iii)*dt)+3.*dt])
        ylim([0 2.5])
        c3 = legend(['WW ' num2str(Window_width,'%.0f'), ' \alpha ' num2str(alpha_threshold1,'%.2f')]);
        
        saveas(3,[Foldersavefig,'alpha_par_N_' num2str(ik_part,'00%.0f'),'_p.fig'])
        saveas(3,[Foldersavefig,'alpha_par_N_' num2str(ik_part,'00%.0f'),'_p.png'])
        
       
        %% Create the classification in Class.Classar (0.0: diffusion/pause , 1.1: anterograde directed transport, 1.3: retrograde directed transport)
        
        velocityHolcmanparsmooth = smooth(VELOCITYparall,smooth_value_directed_transport);
        velocityHolcmanpersmooth = smooth(VELOCITYperall,smooth_value_directed_transport);
        Class = 0.*AAhereconv;
        Classar = 0.*AAhereconv;

        % TX plot
        figure(4)
        hold off
        for iii = 1:size(AAhereconv,1)
            if AAhereconv(iii) <= alpha_threshold1
                plot(TThereconvp(iii)*dt,Xxhereconv(iii),'o','color',[0.5 1 1],'MarkerFaceColor',[0.5 1 1],'linewidth',2)
                hold on
                Class(iii) = 0;
                Classar(iii) = 0;

            elseif AAhereconv(iii) > alpha_threshold1 && velocityHolcmanparsmooth(iii) <= 0

                plot(TThereconvp(iii)*dt,Xxhereconv(iii),'o','color',[0.5 0.5 1],'MarkerFaceColor',[0.5 0.5 1],'linewidth',2)
                hold on
                Classar(iii) = 3;
                Class(iii) = 1;
            else
                plot(TThereconvp(iii)*dt,Xxhereconv(iii),'o','color',[1 0.5 0.5],'MarkerFaceColor',[1 0.5 0.5],'linewidth',2)
                hold on
                Classar(iii) = 1;
                Class(iii) = 1;
            end
        end
        plot(TThereconvp*dt,Xxhereconv,'--k','linewidth',1.1)

        xlabel('Time (s)')
        ylabel('X (\mum)')
        set(gca,'fontsize',14)
        ylim([min(Xxhereconv)-1 max(Xxhereconv)+1])
        xlim([0 max(TThereconvp(iii)*dt)+3.*dt])
        
        saveas(4,[Foldersavefig,'Classification_N_' num2str(ik_part,'00%.0f'),'_p.fig'])
        saveas(4,[Foldersavefig,'Classification_N_' num2str(ik_part,'00%.0f'),'_p.png'])
        
        
        %% TX plot velocity
        VELO = abs(velocityHolcmanparsmooth);


        colors = hot;
        VELO_MAX = max(abs(VELO));
        VELO_MIN = 0;


        VELO_NORM = (VELO-VELO_MIN)./(VELO_MAX-VELO_MIN);
        discret = 1./(size(colors,1)-1);
        ithere = floor(VELO_NORM./discret)+1;
        figure(5)
        hold off

        for iii = 1:size(ithere,1)
            if AAhereconv(iii) > alpha_threshold1
                plot(TThereconvp(iii)*dt,Xxhereconv(iii),'o','color',colors(ithere(iii),:,:),'MarkerFaceColor',colors(ithere(iii),:,:),'linewidth',2)
                hold on
            else
            end

        end
        plot(TThereconvp*dt,Xxhereconv,'--k','linewidth',1.1)
        caxis([0 VELO_MAX])

        c5 = colorbar;
        colormap(hot)
        c5.Label.String = 'v_{//} (\mum/s)';
        c5.Limits = [0 VELO_MAX];
        set(gca,'fontsize',12)
        
       
        xlabel('Time (s)')
        ylabel('X (\mum)')
        ylim([min(Xxhereconv)-1 max(Xxhereconv)+1])
        xlim([0 max(TThereconvp(iii)*dt)+3.*dt])% TX plot velocity

        saveas(5,[Foldersavefig,'Velocity_N_' num2str(ik_part,'00%.0f'),'_p.fig'])
        saveas(5,[Foldersavefig,'Velocity_N_' num2str(ik_part,'00%.0f'),'_p.png'])
        

        
        
        %% Plot (alpha par, alpha ort and alpha 2D) function of T values
        if dimension == 2
            figure(6)
            hold off

        plot(TThereconvp*dt,AAhereconv-AAhereconvpo,'-k','linewidth',1.5)
        hold on
        plot(TThereconvp*dt,AAhereconv2D,'-','color',[0.5 0.5 0.5],'linewidth',1.5)
        plot(TThereconvp(find(AAhereconv-AAhereconvpo == max(AAhereconv-AAhereconvpo)))*dt,AAhereconv2D(find(AAhereconv-AAhereconvpo == max(AAhereconv-AAhereconvpo))),'o','color',[1 0.5 0.5],'linewidth',1.5)

        ylabel('\alpha_{X} - \alpha_{Y} and \alpha_{2D}')
        xlabel('Time (s)')
        xlim([0 max(TThereconvp(iii)*dt)+3.*dt])
        ylim([0 2.5])
        hold off
        
        saveas(6,[Foldersavefig,'alpha_par_AND_per_N_' num2str(ik_part,'00%.0f'),'_p.fig'])
        saveas(6,[Foldersavefig,'alpha_par_AND_per_N_' num2str(ik_part,'00%.0f'),'_p.png'])
        

        
        else
        end
        

        %% Classification between AA, AR, RR and RA pauses based on Class.Classar values
        i_time_antero_diff_switch = [TThereconvp(Class(2:end)-Class(1:end-1)==-1 & Classar(2:end)-Classar(1:end-1) == -1) 1.*ones(size(find(Class(2:end)-Class(1:end-1)==-1 & Classar(2:end)-Classar(1:end-1) == -1),1),1)];
        i_time_diff_retro_switch = [TThereconvp(Class(2:end)-Class(1:end-1)==1 & Classar(2:end)-Classar(1:end-1) == 3) 2.*ones(size(find(Class(2:end)-Class(1:end-1)==1 & Classar(2:end)-Classar(1:end-1) == 3),1),1)];
        i_time_retro_diff_switch = [TThereconvp(Class(2:end)-Class(1:end-1)==-1 & Classar(2:end)-Classar(1:end-1) == -3) 3.*ones(size(find(Class(2:end)-Class(1:end-1)==-1 & Classar(2:end)-Classar(1:end-1) == -3),1),1)];
        i_time_diff_antero_switch = [TThereconvp(Class(2:end)-Class(1:end-1)==1 & Classar(2:end)-Classar(1:end-1) == 1) 4.*ones(size(find(Class(2:end)-Class(1:end-1)==1 & Classar(2:end)-Classar(1:end-1) == 1),1),1)];
        i_time_antero_retro_switch = [TThereconvp(Class(2:end)-Class(1:end-1)==0 & Classar(2:end)-Classar(1:end-1) == 2) 5.*ones(size(find(Class(2:end)-Class(1:end-1)==0 & Classar(2:end)-Classar(1:end-1) == 2),1),1)];
        i_time_retro_antero_switch = [TThereconvp(Class(2:end)-Class(1:end-1)==0 & Classar(2:end)-Classar(1:end-1) == -2) 6.*ones(size(find(Class(2:end)-Class(1:end-1)==0 & Classar(2:end)-Classar(1:end-1) == -2),1),1)];

        Sequence = [i_time_antero_diff_switch;i_time_diff_retro_switch;i_time_retro_diff_switch;i_time_diff_antero_switch; i_time_antero_retro_switch; i_time_retro_antero_switch];
        [~,ordertime] = sort(Sequence(:,1));
        Time_switchs = Sequence(ordertime,1);
        Story = Sequence(ordertime,2);


        AA = 0;
        ARd = 0;
        RAd = 0;
        RR = 0;
        AR = 0;
        RA = 0;
        AA_or_AR_switchs = find(Story ==1);
        for num_switchs_beginning_by_A = 1:size(AA_or_AR_switchs,1)
            if Story(AA_or_AR_switchs(num_switchs_beginning_by_A))==1 && Time_switchs(AA_or_AR_switchs(num_switchs_beginning_by_A))== max(Time_switchs)
            elseif Story(AA_or_AR_switchs(num_switchs_beginning_by_A))==1 && Story(AA_or_AR_switchs(num_switchs_beginning_by_A)+1) == 4
                mean_Location_switch = mean(Xxhereconv(TThereconvp>=Time_switchs(AA_or_AR_switchs(num_switchs_beginning_by_A)) & TThereconvp<=Time_switchs(AA_or_AR_switchs(num_switchs_beginning_by_A)+1)));
                Time_in_AA = [Time_in_AA;Time_switchs(AA_or_AR_switchs(num_switchs_beginning_by_A)+1)-Time_switchs(AA_or_AR_switchs(num_switchs_beginning_by_A)) mean_Location_switch];
                % This is a AA diffusion
                AA = AA+1;
            elseif  Story(AA_or_AR_switchs(num_switchs_beginning_by_A))==1 && Story(AA_or_AR_switchs(num_switchs_beginning_by_A)+1) == 2
                % This is a AR diffusion
                AR = AR+1;
                mean_Location_switch = mean(Xxhereconv(TThereconvp>=Time_switchs(AA_or_AR_switchs(num_switchs_beginning_by_A)) & TThereconvp<=Time_switchs(AA_or_AR_switchs(num_switchs_beginning_by_A)+1)));
                Time_in_AR = [Time_in_AR;Time_switchs(AA_or_AR_switchs(num_switchs_beginning_by_A)+1)-Time_switchs(AA_or_AR_switchs(num_switchs_beginning_by_A)) mean_Location_switch];
            end
        end

        RA_or_RR_switchs = find(Story ==3);
        for num_switchs_beginning_by_R = 1:size(RA_or_RR_switchs,1)
            if Story(RA_or_RR_switchs(num_switchs_beginning_by_R))==3 && Time_switchs(RA_or_RR_switchs(num_switchs_beginning_by_R)) == max(Time_switchs)
            elseif Story(RA_or_RR_switchs(num_switchs_beginning_by_R))==3 && Story(RA_or_RR_switchs(num_switchs_beginning_by_R)+1) == 2
                mean_Location_switch = mean(Xxhereconv(TThereconvp>=Time_switchs(RA_or_RR_switchs(num_switchs_beginning_by_R)) & TThereconvp<=Time_switchs(RA_or_RR_switchs(num_switchs_beginning_by_R)+1)));
                Time_in_RR = [Time_in_RR;Time_switchs(RA_or_RR_switchs(num_switchs_beginning_by_R)+1)-Time_switchs(RA_or_RR_switchs(num_switchs_beginning_by_R)) mean_Location_switch];
                % This is a RR diffusion
                RR = RR + 1;
            elseif  Story(RA_or_RR_switchs(num_switchs_beginning_by_R))==3 && Story(RA_or_RR_switchs(num_switchs_beginning_by_R)+1) == 4
                % This is a RA diffusion
                RA = RA + 1;
                mean_Location_switch = mean(Xxhereconv(TThereconvp>=Time_switchs(RA_or_RR_switchs(num_switchs_beginning_by_R)) & TThereconvp<=Time_switchs(RA_or_RR_switchs(num_switchs_beginning_by_R)+1)));
                Time_in_RA = [Time_in_RA;Time_switchs(RA_or_RR_switchs(num_switchs_beginning_by_R)+1)-Time_switchs(RA_or_RR_switchs(num_switchs_beginning_by_R)) mean_Location_switch];
            end
        end

        RA_direct_switch = find(Story==6);
        if isempty(RA_direct_switch)==0
            for num_switchs_direct_RA = 1:size(RA_direct_switch,1)
                if Time_switchs(RA_direct_switch(num_switchs_direct_RA))~=1 || Time_switchs(RA_direct_switch(num_switchs_direct_RA)) ~= max(TThereconvp);
                    Location_switch = Xxhereconv(TThereconvp==Time_switchs(RA_direct_switch(num_switchs_direct_RA)));
                    Time_in_RA = [Time_in_RA;0 Location_switch];
                    RAd = RAd +1;
                else
                end
            end
        else
        end

        AR_direct_switch = find(Story==5);
        if isempty(AR_direct_switch)==0
            for num_switchs_direct_AR = 1:size(AR_direct_switch,1)
                if Time_switchs(AR_direct_switch(num_switchs_direct_AR))~=1 || Time_switchs(AR_direct_switch(num_switchs_direct_AR)) ~= max(TThereconvp)
                    Location_switch = Xxhereconv(TThereconvp==Time_switchs(AR_direct_switch(num_switchs_direct_AR)));
                    Time_in_AR = [Time_in_AR;0 Location_switch];
                    ARd = ARd+1;
                else
                end
            end
        else
        end

        %% Output tables
        RESULTSEND = [RESULTSEND;TThereconvp Xxhereconv Yyhereconv AAhereconv AAhereconvp [D_Holcman_fitpar ; D_Holcman_fitpar(end).*ones(3,1)] [D_Holcman_fitper ; D_Holcman_fitper(end).*ones(3,1)] [velocityHolcmanpar ; velocityHolcmanpar(end).*ones(1,1)] [velocityHolcmanper ; velocityHolcmanper(end).*ones(1,1)] Class Classar VELOCITYparall VELOCITYperall];

        Final_classification = 0.*Class;
        for iii =1: size(TThereconvp,1)
            if Class(iii,1) == 1 && Classar(iii,1) == 1
                Final_classification(iii,1) = 1;
            elseif Class(iii,1) == 1 && Classar(iii,1) == 3
                Final_classification(iii,1) = -1;
            elseif Class(iii,1) == 0 && Classar(iii,1) == 0
                Final_classification(iii,1) = 0;
            end
        end
        CLASSIFICATION_MSD = [TThereconvp Xxhereconv Yyhereconv AAhereconv AAhereconvp Final_classification Class Classar];
        %%
        Time = zeros(size([1:size(TIME,1)-1],2),1);
        X = zeros(size([1:size(TIME,1)-1],2),1);
        Y = zeros(size([1:size(TIME,1)-1],2),1);
        Alpha_PAR = zeros(size([1:size(TIME,1)-1],2),1);
        Alpha_ORT = zeros(size([1:size(TIME,1)-1],2),1);
        Alpha_2D = zeros(size([1:size(TIME,1)-1],2),1);
        CLASS = zeros(size([1:size(TIME,1)-1],2),1);
        Class_column = zeros(size([1:size(TIME,1)-1],2),7);
        for eachit = 1:size(TIME,1)-1
            idat = find(TThereconvp==TIME(eachit));
            Class_column(eachit,:) = [TIME(eachit) XC(eachit) YC(eachit) AAhereconv(idat) AAhereconvp(idat) AAhereconv2D(idat) Final_classification(idat)];
            Time(eachit) = TIME(eachit);
            X(eachit) = XC(eachit);
            Y(eachit) = YC(eachit);
            Alpha_PAR(eachit) = AAhereconv(idat);
            Alpha_ORT(eachit) = AAhereconvp(idat);
            Alpha_2D(eachit) = AAhereconv2D(idat);
            CLASS(eachit) = Final_classification(idat);
        end

        if Save_CSV_option == 1
            Foldersavexlsx = [Foldersave,'CSV files\'];
            mkdir(Foldersavexlsx)
            T = table(Time,X,Y,Alpha_PAR,Alpha_ORT,Alpha_2D,CLASS);

            writetable(T,[Foldersavexlsx,'Results_N_' num2str(ik_part,'00%.0f'),'_Ath_' num2str(alpha_threshold1,'%.2f'),'_W_' num2str(Window_width,'%.2f'),'.csv'],'Delimiter',',')
        else
        end
        save([Foldersave,'Results_N_' num2str(ik_part,'00%.0f'),'.mat'])
    end
end

