/**********************************************************************************

DESCRIPTION:  THIS PROGRAM ILLUSTRATES HOW TO IDENTIFY PERSONS WITH A CONDITION AND
              CALCULATE ESTIMATES ON USE AND EXPENDITURES FOR PERSONS WITH THE CONDITION

              THE CONDITION USED IN THIS EXERCISE IS DIABETES (CCS CODE=049 OR 050)

DEFINITION OF 61 CONDITIONS BASED ON THE CCS CODE

  1  Infectious diseases                                           : CCS CODE = 1-9
  2  Cancer                                                        : CCS CODE = 11-45
  3  Non-malignant neoplasm                                        : CCS CODE = 46, 47
  4  Thyroid disease                                               : CCS CODE = 48
  5  Diabetes mellitus                                             : CCS CODE = 49,50
  6  Other endocrine, nutritional & immune disorder                : CCS CODE = 51, 52, 54 - 58
  7  Hyperlipidemia                                                : CCS CODE = 53
  8  Anemia and other deficiencies                                 : CCS CODE = 59
  9  Hemorrhagic, coagulation, and disorders of White Blood cells  : CCS CODE = 60-64
  10 Mental disorders                                              : CCS CODE = 650-670
  11 CNS infection                                                 : CCS CODE = 76-78
  12 Hereditary, degenerative and other nervous system disorders   : CCS CODE = 79-81
  13 Paralysis                                                     : CCS CODE = 82
  14 Headache                                                      : CCS CODE = 84
  15 Epilepsy and convulsions                                      : CCS CODE = 83
  16 Coma, brain damage                                            : CCS CODE = 85
  17 Cataract                                                      : CCS CODE = 86
  18 Glaucoma                                                      : CCS CODE = 88
  19 Other eye disorders                                           : CCS CODE = 87, 89-91
  20 Otitis media                                                  : CCS CODE = 92
  21 Other CNS disorders                                           : CCS CODE = 93-95
  22 Hypertension                                                  : CCS CODE = 98,99
  23 Heart disease                                                 : CCS CODE = 96, 97, 100-108
  24 Cerebrovascular disease                                       : CCS CODE = 109-113
  25 Other circulatory conditions arteries, veins, and lymphatics  : CCS CODE = 114 -121
  26 Pneumonia                                                     : CCS CODE = 122
  27 Influenza                                                     : CCS CODE = 123
  28 Tonsillitis                                                   : CCS CODE = 124
  29 Acute Bronchitis and URI                                      : CCS CODE = 125 , 126
  30 COPD, asthma                                                  : CCS CODE = 127-134
  31 Intestinal infection                                          : CCS CODE = 135
  32 Disorders of teeth and jaws                                   : CCS CODE = 136
  33 Disorders of mouth and esophagus                              : CCS CODE = 137
  34 Disorders of the upper GI                                     : CCS CODE = 138-141
  35 Appendicitis                                                  : CCS CODE = 142
  36 Hernias                                                       : CCS CODE = 143
  37 Other stomach and intestinal disorders                        : CCS CODE = 144- 148
  38 Other GI                                                      : CCS CODE = 153-155
  39 Gallbladder, pancreatic, and liver disease                    : CCS CODE = 149-152
  40 Kidney Disease                                                : CCS CODE = 156-158, 160, 161
  41 Urinary tract infections                                      : CCS CODE = 159
  42 Other urinary                                                 : CCS CODE = 162,163
  43 Male genital disorders                                        : CCS CODE = 164-166
  44 Non-malignant breast disease                                  : CCS CODE = 167
  45 Female genital disorders, and contraception                   : CCS CODE = 168-176
  46 Complications of pregnancy and birth                          : CCS CODE = 177-195
  47 Normal birth/live born                                        : CCS CODE = 196, 218
  48 Skin disorders                                                : CCS CODE = 197-200
  49 Osteoarthritis and other non-traumatic joint disorders        : CCS CODE = 201-204
  50 Back problems                                                 : CCS CODE = 205
  51 Other bone and musculoskeletal  disease                       : CCS CODE = 206-209, 212
  52 Systemic lupus and connective tissues disorders               : CCS CODE = 210-211
  53 Congenital anomalies                                          : CCS CODE = 213-217
  54 Perinatal Conditions                                          : CCS CODE = 219-224
  55 Trauma-related disorders                                      : CCS CODE = 225-236, 239, 240, 244
  56 Complications of surgery or device                            : CCS CODE = 237, 238
  57 Poisoning by medical and non-medical substances               : CCS CODE = 241 - 243
  58 Residual Codes                                                : CCS CODE = 259
  59 Other care and screening                                      : CCS CODE = 10, 254-258
  60 Symptoms                                                      : CCS CODE = 245-252
  61 Allergic reactions                                            : CCS CODE = 253


INPUT FILES:  1) /folders/myfolders/sasuser.v94/MEPS-master/data/H180.SAS7BDAT (2015 CONDITION PUF DATA)
              2) /folders/myfolders/sasuser.v94/MEPS-master/data/H181.SAS7BDAT (2015 FY PUF DATA)

*********************************************************************************/;
OPTIONS LS=132 PS=79 NODATE FORMCHAR="|----|+|---+=|-/\<>*" PAGENO=1;
FILENAME MYLOG "/folders/myfolders/sasuser.v94/MEPS-master/SAS/workshop_exercises/exercise_3a/Exercise3a_log.TXT";
FILENAME MYPRINT "/folders/myfolders/sasuser.v94/MEPS-master/SAS/workshop_exercises/exercise_3a/Exercise3a_OUTPUT.TXT";
PROC PRINTTO LOG=MYLOG PRINT=MYPRINT NEW;
RUN;
/*Indicate where to store the log and output.*/

LIBNAME CDATA '/folders/myfolders/sasuser.v94/MEPS-master/data';
/*Assign a nickname to the library where the data is stored for SAS to call upon.*/


TITLE1 '2018 AHRQ MEPS DATA USERS WORKSHOP';
TITLE2 'EXERCISE4.SAS: CALCULATE ESTIMATES ON USE AND EXPENDITURES FOR PERSONS WITH A CONDITION (DIABETES)';


PROC FORMAT;
  VALUE SEX
     . = 'TOTAL'
     1 = 'MALE'
     2 = 'FEMALE'
       ;

  VALUE YESNO
     . = 'TOTAL'
     1 = 'YES'
     2 = 'NO'
       ;
RUN;
/*Assign descriptive labels to the data in the dataset for clarity using the FORMAT procedure.*/


/*1) PULL OUT CONDITIONS WITH DIABETES (CCS CODE='049', '050') FROM 2015 CONDITION PUF - HC180*/

DATA DIAB;
 SET CDATA.H180;
    IF CCCODEX IN ('049', '050');
RUN;
/*Create a dataset named DIAB using the DATA statement.*/
/*Use SET to read in the H180 dataset as the DIAB dataset.*/
/*Use the IF statement to select only the with the code for Diabetes.*/


TITLE3 "CHECK CCS CODES FOR DIABETIC CONDITIONS";
PROC FREQ DATA=DIAB;
  TABLES CCCODEX / LIST MISSING;
RUN;
/*Use FREQ statement to print the counts and proportions
of all values from the category CCCODEX in the dataset DIAB.*/
/*Use the option MISSING to show a row of the missing values*/


/*2) IDENTIFY PERSONS WHO REPORTED DIABETES*/

PROC SORT DATA=DIAB OUT=DIABPERS (KEEP=DUPERSID) NODUPKEY;
  BY DUPERSID;
RUN;
/*SORT the DIAB dataset by the column DUPERSID and name the output the dataset DIABPERS.*/


/*3) CREATE A FLAG FOR PERSONS WITH DIABETES IN THE 2015 FY DATA*/

DATA  FY1;
MERGE CDATA.H181 (IN=AA)
      DIABPERS   (IN=BB) ;
   BY DUPERSID;

      LABEL DIABPERS='PERSONS WHO REPORTED DIABETES';
      IF AA AND BB THEN DIABPERS = 1;
                   ELSE DIABPERS = 2;

RUN;
/*Create a new dataset named FY1 and set with a MERGE of two datasets: H181 and DIABPERS. The IN data set options
sets a 1 or 0 for data coming from each set.*/
/*Then the dataset DIABPERS is labeled (flagged) 1 if data comes from both datasets.*/


TITLE3 "Supporting crosstabs for the flag variables";
TITLE3 "UNWEIGHTED # OF PERSONS WHO REPORTED DIABETES, 2015";
PROC FREQ DATA=FY1;
  TABLES DIABPERS
         DIABPERS * SEX / LIST MISSING;
  FORMAT SEX      sex.
         DIABPERS yesno.
    ;
RUN;
/*Use FREQ statement to print the counts and proportions
of all values from the category DIABPERS and DIABPERS * SEX.*/
/*Use the option MISSING to show a row of the missing values*/
/*Assign formats to the data.*/


TITLE3 "WEIGHTED # OF PERSONS WHO REPORTED DIABETES, 2015";
PROC FREQ DATA=FY1;
  TABLES DIABPERS
         DIABPERS * SEX /LIST MISSING;
  WEIGHT PERWT15F ;
  FORMAT SEX      sex.
         DIABPERS yesno.
    ;
RUN;
/*Now show the frequency again with the values weighted by the column PERWT15F.*/

/*4) CALCULATE ESTIMATES ON USE AND EXPENDITURES FOR PERSONS WHO REPORTED DIABETES*/

ODS GRAPHICS OFF;
ODS LISTING CLOSE;
PROC SURVEYMEANS DATA=FY1 NOBS SUMWGT SUM STD MEAN STDERR;
	STRATA  VARSTR ;
	CLUSTER VARPSU ;
	WEIGHT PERWT15F ;
	DOMAIN DIABPERS('1') SEX*DIABPERS('1');
	VAR TOTEXP15 TOTSLF15 OBTOTV15;
      ods output domain=work.domain_results;
RUN;
/*Perform SURVEYMEANS procedure on the dataset FY1 with the following statistics: number of nonmissing objects (NOBS),
sum of the weights (SUMWGT), weighted sum (SUM), mathematical average (MEAN), and standard error of the MEAN or
RATIO (STDERR).*/


ODS LISTING;
TITLE3 "ESTIMATES ON USE AND EXPENDITURES FOR PERSONS WHO REPORTED DIABETES, 2015";
PROC PRINT DATA=work.domain_results (DROP=DOMAINLABEL)  NOOBS LABEL BLANKLINE=3 ;
VAR SEX VARNAME N SUMWGT SUM STDDEV MEAN STDERR;
FORMAT N                      comma6.0
       SUMWGT   SUM    STDDEV comma17.0
       MEAN     STDERR        comma9.2
       DIABPERS               yesno.
       SEX                    sex.
   ;
RUN;
/*Print the results of the functions in the WORK dataset and replace the numerical identifiers with labels
as column headings. Print the specified variables with the specified formatting. */

TITLE3 "SUMMARY STATISTICS";
PROC MEANS DATA=FY1;
	VAR TOTEXP15 TOTSLF15 OBTOTV15;
RUN;
/*Generate summary statistics using PROC MEANS.*/


PROC PRINTTO;
RUN;
/*PRINTTO without arguments will output to the destinations indicated above.*/


