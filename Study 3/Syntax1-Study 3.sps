* Encoding: UTF-8.
recode  Emto1_1 Emto1_4 Emto2_1 Emto2_4 Emto3_1 Emto3_4 (1=7) (2=6) (3=5) (4=4) (5=3) (6=2) (7=1). 

COMPUTE Authentichumility=(AH1 + AH2 + AH3 + AH4 + AH5 + AH6 +AH7 + AH8) / 8.
EXECUTE.

COMPUTE Interauthentichumility=(AH1 + AH4 + AH5 +AH7 + AH8) / 5.
EXECUTE.

COMPUTE Intraauthentichumility=(AH2 + AH3 + AH6) / 3.
EXECUTE.

COMPUTE degradinghumility=(SDH1 + SDH2 + SDH3 + SDH4 + SDH5) / 5.
EXECUTE.

COMPUTE AuthenticPride=(authenticpride1 + authenticpride2 + authenticpride3 + authenticpride4 + authenticpride5 + authenticpride6 + authenticpride7) / 7.
EXECUTE.

COMPUTE Globalhumiliation=(Humiliation1 + Humiliation2 + Humiliation3 + Humiliation4 + Humiliation5 
    + Humiliation6 + Humiliation7 + Humiliation8) / 8.
EXECUTE.

compute emptot=means (Emto1_1 ,Emto1_2 ,Emto1_3 ,Emto1_4 ,Emto2_1, Emto2_2 ,Emto2_3 ,Emto2_4, Emto3_1, Emto3_2, 
    Emto3_3, Emto3_4, Emto4_1, Emto4_2 ,Emto4_3). 

compute toltot=means (Emto1_5 ,Emto1_6 ,Emto1_7, Emto2_5 ,Emto2_6 ,Emto2_7 ,Emto3_5 ,Emto3_6 ,Emto3_7, Emto4_5 ,Emto4_6 ,Emto4_7). 


COMPUTE Attitude=(thoughts_1 + thoughts_2 + thoughts_4 + thoughts_5) / 4.
EXECUTE.

RELIABILITY
  /VARIABLES=AH1 AH2 AH3 AH4 AH5 AH6 AH7 AH8
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA.

RELIABILITY
  /VARIABLES=AH1 AH4 AH5 AH7 AH8
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA.

RELIABILITY
  /VARIABLES=SDH1 SDH2 SDH3 SDH4 SDH5
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA.

RELIABILITY
  /VARIABLES=authenticpride1 authenticpride2 authenticpride3 authenticpride4 authenticpride5 authenticpride6 authenticpride7
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA.

RELIABILITY
  /VARIABLES=Humiliation1 Humiliation2 Humiliation3 Humiliation4 Humiliation5 Humiliation6 Humiliation7 Humiliation8
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA.

RELIABILITY
  /VARIABLES=Emto1_1 Emto1_2 Emto1_3 Emto1_4 Emto2_1 Emto2_2 Emto2_3 Emto2_4 Emto3_1 Emto3_2
    Emto3_3 Emto3_4 Emto4_1 Emto4_2 Emto4_3
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA.

RELIABILITY
  /VARIABLES=Emto1_5 Emto1_6 Emto1_7 Emto2_5 Emto2_6 Emto2_7 Emto3_5 Emto3_6 Emto3_7 Emto4_5 Emto4_6 Emto4_7
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA.

ONEWAY pleasantness Authentichumility  Interauthentichumility degradinghumility AuthenticPride Globalhumiliation emptot toltot Attitude BY 
    condition
  /ES=OVERALL
  /STATISTICS DESCRIPTIVES WELCH 
  /MISSING ANALYSIS
  /CRITERIA=CILEVEL(0.95)
  /POSTHOC=TUKEY GH ALPHA(0.05).

CORRELATIONS
  /VARIABLES=pleasantness Authentichumility Interauthentichumility degradinghumility emptot toltot 
    Attitude gender age
  /PRINT=TWOTAIL NOSIG FULL
  /MISSING=PAIRWISE.
