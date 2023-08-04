 /* Step 1: Data Exploration and Cleaning */


/* 1. Load the dataset */
proc import datafile= "C:\Users\asifa\OneDrive\Desktop\Analysis Project\cirrhosis\cirrhosis.csv"
            out=clinical_trial
            dbms=csv
            replace;
run;
/* Define formats for 'Status', 'Sex', and 'Drug' */
proc format;
  value $status_fmt
    'C' = 1
    'CL' = 2
    'D' = 3
	' ' =.;

  value $sex_fmt
    'M' = 1
    'F' = 2
	' ' =.;

  value $drug_fmt
    'D-penicillamine' = 1
    'Placebo' = 2
	' ' =.;
run;

/* Apply formats to the original variables and label them */
data clinical_trial;
  set clinical_trial;

  /* Apply formats to convert the categorical variables into numerical values */
  format Status $status_fmt.
         Sex $sex_fmt.
         Drug $drug_fmt.;
/* Label the variables */
  label Status = 'Status'
        Sex = 'Sex'
        Drug = 'Drug';

run;


/* 2. Inspect the dataset structure */
proc contents data=clinical_trial;
run;

/* 3. Check for missing values */
proc means data=clinical_trial nmiss;
run;



/* 4. Handle missing values */

/*Imputation for Numerical Data (using median)*/
/* Step 1: Calculate the median for each numerical variable */
/* Step 1: Calculate the median for each numerical variable */
PROC MEANS DATA=clinical_trial N MEDIAN;
  VAR Cholesterol Copper Alk_Phos SGOT Tryglicerides Platelets Prothrombin;
  OUTPUT OUT=median_stats MEDIAN=  median_Cholesterol median_Copper median_Alk_Phos median_SGOT median_Tryglicerides median_Platelets median_Prothrombin ;
RUN;

/* Step 2: Impute missing values using calculated medians */
DATA clinical_trial;
  SET clinical_trial;
  /* Read the median statistics */
  if _N_ = 1 then set median_stats;
  /* Impute missing values for numerical variables */
  if missing(Cholesterol) then Cholesterol = median_Cholesterol;
  if missing(Copper) then Copper = median_Copper;
  if missing(Alk_Phos) then Alk_Phos = median_Alk_Phos;
  if missing(SGOT) then SGOT = median_SGOT;
  if missing(Tryglicerides) then Tryglicerides = median_Tryglicerides;
  if missing(Platelets) then Platelets = median_Platelets;
  if missing(Prothrombin) then Prothrombin = median_Prothrombin;
  
  /* Drop the temporary variables */
  DROP median_: _TYPE_ _FREQ_;
RUN;
/*Imputation for Categorical Data (using mode)*/

/* Calculate the mode for each categorical variable */
proc freq data=clinical_trial;
  tables Drug Ascites Hepatomegaly Spiders Stage ;
run;
/* Manually apply the modes to the dataset */
data clinical_trial;
  set clinical_trial;

  /* Check and replace missing values with specified values */
  if missing(Drug) then Drug = "1";
  if missing(Ascites) then Ascites = "0";
  if missing(Hepatomegaly) then Hepatomegaly = "1";
  if missing(Spiders) then Spiders = "0";
  if missing(Stage) then Stage = "3";
run;
/*Step 2: Descriptive Statistics*/
/* Assuming the dataset is named 'clinical_data' in your SAS environment */

/* Calculate descriptive statistics for continuous variables */
proc means data=clinical_trial n mean median std min max;
  var Age Bilirubin Cholesterol Albumin Copper Alk_Phos SGOT Tryglicerides Platelets Prothrombin;
run;

/* Create histograms for continuous variables */
ods graphics on;
proc sgplot data=Clinical_trial;
title 'Histograms of Age';
    histogram Age / binwidth=1000;
    xaxis label="Age (days)";
    yaxis label="Frequency";
run;
proc sgplot data=Clinical_trial;
title 'Histograms of Bilirubin';
    histogram Bilirubin / binwidth=1;
    xaxis label="Bilirubin (mg/dl)";
    yaxis label="Frequency";
run;
proc sgplot data=Clinical_trial;
title 'Histograms of Cholesterol';
    histogram Cholesterol / binwidth=50;
    xaxis label="Cholesterol (mg/dl)";
    yaxis label="Frequency";
run;

proc sgplot data=Clinical_trial;
  title 'Histogram of Albumin';
  histogram Albumin / binwidth=0.2;
  xaxis label="Albumin (gm/dl)";
  yaxis label="Frequency";
run;

proc sgplot data=Clinical_trial;
  title 'Histogram of Copper';
  histogram Copper / binwidth=50;
  xaxis label="Copper (ug/day)";
  yaxis label="Frequency";
run;

proc sgplot data=Clinical_trial;
  title 'Histogram of Alk_Phos';
  histogram Alk_Phos / binwidth=100;
  xaxis label="Alkaline Phosphatase (U/liter)";
  yaxis label="Frequency";
run;

proc sgplot data=Clinical_trial;
  title 'Histogram of SGOT';
  histogram SGOT / binwidth=50;
  xaxis label="SGOT (U/ml)";
  yaxis label="Frequency";
run;

proc sgplot data=Clinical_trial;
  title 'Histogram of Triglycerides';
  histogram Tryglicerides / binwidth=50;
  xaxis label="Triglycerides (mg/dl)";
  yaxis label="Frequency";
run;

proc sgplot data=Clinical_trial;
  title 'Histogram of Platelets';
  histogram Platelets / binwidth=50;
  xaxis label="Platelets (cubic ml/1000)";
  yaxis label="Frequency";
run;

proc sgplot data=Clinical_trial;
  title 'Histogram of Prothrombin';
  histogram Prothrombin / binwidth=1;
  xaxis label="Prothrombin Time (seconds)";
  yaxis label="Frequency";
run;

/* Create boxplots for continuous variables */
proc sgplot data=Clinical_trial;
title 'Boxplots of age by drug';
   vbox Age / category=Drug;
   xaxis label="Drug";
   yaxis label="Age (days)";
run;

proc sgplot data=Clinical_trial;
  title 'Boxplot of Bilirubin by Drug';
  vbox Bilirubin / category=Drug;
  xaxis label="Drug";
  yaxis label="Bilirubin (mg/dl)";
run;

proc sgplot data=Clinical_trial;
  title 'Boxplot of Cholesterol by Drug';
  vbox Cholesterol / category=Drug;
  xaxis label="Drug";
  yaxis label="Cholesterol (mg/dl)";
run;

proc sgplot data=Clinical_trial;
  title 'Boxplot of Albumin by Drug';
  vbox Albumin / category=Drug;
  xaxis label="Drug";
  yaxis label="Albumin (gm/dl)";
run;

proc sgplot data=Clinical_trial;
  title 'Boxplot of Copper by Drug';
  vbox Copper / category=Drug;
  xaxis label="Drug";
  yaxis label="Copper (ug/day)";
run;

proc sgplot data=Clinical_trial;
  title 'Boxplot of Alk_Phos by Drug';
  vbox Alk_Phos / category=Drug;
  xaxis label="Drug";
  yaxis label="Alkaline Phosphatase (U/liter)";
run;

proc sgplot data=Clinical_trial;
  title 'Boxplot of SGOT by Drug';
  vbox SGOT / category=Drug;
  xaxis label="Drug";
  yaxis label="SGOT (U/ml)";
run;

proc sgplot data=Clinical_trial;
  title 'Boxplot of Triglycerides by Drug';
  vbox Tryglicerides / category=Drug;
  xaxis label="Drug";
  yaxis label="Triglycerides (mg/dl)";
run;

proc sgplot data=Clinical_trial;
  title 'Boxplot of Platelets by Drug';
  vbox Platelets / category=Drug;
  xaxis label="Drug";
  yaxis label="Platelets (cubic ml/1000)";
run;

proc sgplot data=Clinical_trial;
  title 'Boxplot of Prothrombin by Drug';
  vbox Prothrombin / category=Drug;
  xaxis label="Drug";
  yaxis label="Prothrombin Time (seconds)";
run;
title;

/* Compute frequency tables for categorical variables */
proc freq data=Clinical_trial;
    tables Status Drug Sex Ascites Hepatomegaly Spiders Edema Stage / nocum nopercent;
run;

/* Generate bar plots for categorical variables */
proc sgplot data=Clinical_trial;
title 'Barplot of status by Drug';
    vbar Status / group=Drug datalabel;
    xaxis label="Status";
    yaxis label="Frequency";
run;

proc sgplot data=Clinical_trial;
title 'Barplot of sex by Drug';
    vbar Sex / group=Drug datalabel;
    xaxis label="Sex";
    yaxis label="Frequency";
run;

proc sgplot data=Clinical_trial;
title 'Barplot of Ascites by Drug';
    vbar Ascites / group=Drug datalabel;
    xaxis label="Ascites";
    yaxis label="Frequency";
run;

proc sgplot data=Clinical_trial;
title 'Barplot of hepatomegaly by Drug';
    vbar Hepatomegaly / group=Drug datalabel;
    xaxis label="Hepatomegaly";
    yaxis label="Frequency";
run;

proc sgplot data=Clinical_trial;
title 'Barplot of spiders by Drug';
    vbar Spiders / group=Drug datalabel;
    xaxis label="Spiders";
    yaxis label="Frequency";
run;

proc sgplot data=Clinical_trial;
title 'Barplot of edema by Drug';
   vbar Edema / group=Drug datalabel; 
   xaxis label='Edema';
   yaxis label='Frequency';
run;
proc sgplot data=Clinical_trial; 
title 'Barplot of stage by Drug';
   vbar Stage / group=Drug datalabel; 
   xaxis label='Stage';
   yaxis label='Frequency';
run;

/* Cross-tabulation of categorical variables */
proc freq data=clinical_trial;
  tables Drug*Sex;
  tables Status*Drug / chisq;
run;
/* Bar chart for categorical variables */
proc sgplot data=clinical_trial;
  title 'Bar Chart: Drug';
  vbar Drug / datalabel;
run;
/* Bar chart for categorical variables */
proc sgplot data=clinical_trial;
  title 'Bar Chart: Sex';
  vbar Sex / datalabel;
run;
/* Chi-square test for independence */
proc freq data=clinical_trial;
  tables Drug*Sex / chisq;
run;
title;




/*Step 4: Cox Proportional Hazards Model*/

proc phreg data=Clinical_trial;
   class Drug(ref='2') Sex(ref='1') Ascites(ref='0') Hepatomegaly(ref='0') Spiders(ref='0') Edema(ref='0')Stage(ref='1');
   model N_Days*event(0) = Drug Age Sex Ascites Hepatomegaly Spiders Edema Bilirubin Cholesterol Albumin Copper Alk_Phos SGOT Tryglicerides Platelets Prothrombin Stage;
run;




/*Step 5: Stage Analysis*/
/* Load the LIFETEST procedure for survival analysis */
/* Perform survival analysis using PROC LIFETEST */
proc lifetest data=Clinical_trial plots=survival(atrisk cb);
  time N_Days*Event(0);
  strata Drug;
  strata Stage; /* Separate patients into different groups based on histologic stage */
run;



/* Load the PROC CORR procedure */
proc corr data=CStep 6linical_trial;
  var Age Bilirubin Cholesterol Albumin Copper Alk_Phos SGOT Tryglicerides Platelets Prothrombin;
  with N_Days;
run;


