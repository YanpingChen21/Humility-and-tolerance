* Encoding: UTF-8.
recode Hum1_2  Hum1_4 Hum2_1 Hum3_1 Hum4_3  (1=7) (2=6) (3=5) (4=4) (5=3) (6=2) (7=1). 

recode  Emto1_1 Emto1_4 Emto2_1 Emto2_4 Emto3_1 Emto3_4 (1=7) (2=6) (3=5) (4=4) (5=3) (6=2) (7=1). 

RELIABILITY
  /VARIABLES=Hum1_1, Hum1_2, Hum1_3, Hum1_4, Hum1_5, hum2_1, hum2_2, hum2_3, hum2_4, hum2_5, hum3_1, hum3_2, 
    hum3_4, hum3_5 ,hum4_1 ,hum4_2 ,hum4_3, hum4_4
  /SCALE('humtot') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.


COMPUTE Authentichumilityfeelings=(AH1 + AH2 + AH3 + AH4 + AH5 + AH6 + AH7 + AH8) / 8.
EXECUTE.


COMPUTE Degradinghumilityfeelings=(SDH1 + SDH2 + SDH3 + SDH4 + SDH5) / 5.
EXECUTE.


RELIABILITY
  /VARIABLES=AH1 AH2 AH3 AH4 AH5 AH6 AH7 AH8
  /SCALE('Authentichumilityfeelings') ALL
  /MODEL=ALPHA.

RELIABILITY
  /VARIABLES=SDH1 SDH2 SDH3 SDH4 SDH5
  /SCALE('Degradinghumilityfeelings') ALL
  /MODEL=ALPHA.

compute humtot=means (Hum1_1, Hum1_2, Hum1_3, Hum1_4, Hum1_5, hum2_1, hum2_2, hum2_3, hum2_4, hum2_5, hum3_1, hum3_2, 
    hum3_4, hum3_5 ,hum4_1 ,hum4_2 ,hum4_3, hum4_4).

COMPUTE intraAuthentichumilityfeelings=(AH2 + AH3 + AH7) / 3.
EXECUTE.


COMPUTE interAuthentichumilityfeelings=(AH1 + AH4 + AH5 + AH6 + AH8) / 5.
EXECUTE.

compute overallhum=means (hex, bhs, cole).


RELIABILITY
  /VARIABLES=Emto1_1 Emto1_2 Emto1_3 Emto1_4 Emto2_1 Emto2_2 Emto2_3 Emto2_4 Emto3_1 Emto3_2 
    Emto3_3 Emto3_4
  /SCALE('emptot') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

compute emptot=means (Emto1_1 ,Emto1_2 ,Emto1_3 ,Emto1_4 ,Emto2_1, Emto2_2 ,Emto2_3 ,Emto2_4, Emto3_1, Emto3_2, 
    Emto3_3, Emto3_4, Emto4_1, Emto4_2 ,Emto4_3). 



RELIABILITY
  /VARIABLES=Emto1_5 Emto1_6 Emto1_7 Emto2_5 Emto2_6 Emto2_7 Emto3_5 Emto3_6 Emto3_7
  /SCALE('toltot') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

compute toltot=means (Emto1_5 ,Emto1_6 ,Emto1_7, Emto2_5 ,Emto2_6 ,Emto2_7 ,Emto3_5 ,Emto3_6 ,Emto3_7, Emto4_5 ,Emto4_6 ,Emto4_7). 

CORRELATIONS
  /VARIABLES=humtot emptot toltot
  /PRINT=TWOTAIL NOSIG FULL
  /MISSING=PAIRWISE.

RELIABILITY
  /VARIABLES=attittudes_1 attittudes_2 attittudes_3 attittudes_4
  /SCALE('attitude') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.


COMPUTE Attitude=(attittudes_1 + attittudes_2 + attittudes_3 + attittudes_4) / 4.
EXECUTE.
compute hex=means (hum2_4, hum4_4 ,hum3_1, hum2_1). 
compute bhs=means (Hum1_1 ,hum2_3 ,hum4_3, hum4_1 ,Hum1_4 ,Hum1_2). 
compute cole=means (Hum1_3 ,hum2_2, hum3_2 ,hum4_2 ,hum3_4 ,hum3_5 ,hum2_5, Hum1_5). 

RELIABILITY
  /VARIABLES= hum2_4  hum4_4 hum3_1 hum2_1
  /SCALE('hexaco') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

RELIABILITY
  /VARIABLES=Hum1_1 hum2_3 hum4_3 hum4_1 Hum1_4 Hum1_2
  /SCALE('bhs') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

RELIABILITY
  /VARIABLES=Hum1_3 hum2_2 hum3_2 hum4_2 hum3_4 hum3_5 hum2_5 Hum1_5
  /SCALE('cole') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.


CORRELATIONS
  /VARIABLES=humtot emptot toltot attitude bhs cole hex cole
  /PRINT=TWOTAIL NOSIG FULL
  /MISSING=PAIRWISE.

.

CORRELATIONS
  /VARIABLES=humtot emptot toltot attitude bhs cole hex coleshare colesmall
  /PRINT=TWOTAIL NOSIG FULL
  /MISSING=PAIRWISE.

RELIABILITY
  /VARIABLES=Hum1_3 hum3_2 hum3_5 Hum1_5
  /SCALE('coleshare') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

compute coleshare=means (Hum1_3 ,hum3_2, hum3_5, Hum1_5). 

RELIABILITY
  /VARIABLES=hum2_5 hum3_4  
  /SCALE('colesmall') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

compute colesmall=means (hum2_5, hum3_4). 







temp.
select if attitude < 4.1.
REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT toltot
  /METHOD=ENTER bhs
  /METHOD=ENTER emptot
  /METHOD=ENTER Age Gender .


temp.
select if attitude < 4.
  REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT toltot
  /METHOD=ENTER hex
  /METHOD=ENTER emptot
  /METHOD=ENTER Age Gender.


temp.
select if attitude < 4.
  REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT toltot
  /METHOD=ENTER zcole zhex zbhs
  /METHOD=ENTER emptot
  /METHOD=ENTER Age Gender.

FACTOR
  /VARIABLES Hum1_1 hum2_3 hum2_4 hum4_4 hum4_1 hum4_3 hum3_1 hum2_1 Hum1_2 Hum1_4 Hum1_3 hum3_2 
    Hum1_5 hum3_5 hum4_2 hum2_2 hum2_5 hum3_4
  /MISSING LISTWISE 
  /ANALYSIS Hum1_1 hum2_3 hum2_4 hum4_4 hum4_1 hum4_3 hum3_1 hum2_1 Hum1_2 Hum1_4 Hum1_3 hum3_2 
    Hum1_5 hum3_5 hum4_2 hum2_2 hum2_5 hum3_4
  /PRINT INITIAL EXTRACTION ROTATION
  /CRITERIA MINEIGEN(1) ITERATE(25)
  /EXTRACTION PC
  /CRITERIA ITERATE(25) DELTA(0)
  /ROTATION OBLIMIN
  /METHOD=CORRELATION.


CORRELATIONS
  /VARIABLES=humtot hex bhs cole Authentichumilityfeelings Degradinghumilityfeelings emptot toltot 
    Attitude gender age
  /PRINT=TWOTAIL NOSIG FULL
  /MISSING=PAIRWISE.



COMPUTE Attitude=(attittudes_1 + attittudes_2 + attittudes_3 + attittudes_4) / 4.
compute emptot=means (Emto1_1 ,Emto1_2 ,Emto1_3 ,Emto1_4 ,Emto2_1, Emto2_2 ,Emto2_3 ,Emto2_4, Emto3_1, Emto3_2, 
    Emto3_3, Emto3_4, Emto4_1, Emto4_2 ,Emto4_3). 
compute toltot=means (Emto1_5 ,Emto1_6 ,Emto1_7, Emto2_5 ,Emto2_6 ,Emto2_7 ,Emto3_5 ,Emto3_6 ,Emto3_7, Emto4_5 ,Emto4_6 ,Emto4_7). 

COMPUTE Attitude2=(attittudes_2 + attittudes_3 + attittudes_4) / 3.
EXECUTE.



compute emptot2=means (Emto2_1, Emto2_2 ,Emto2_3,Emto2_4, Emto3_1, Emto3_2, 
    Emto3_3, Emto3_4, Emto4_1, Emto4_2 ,Emto4_3). 

compute toltot2=means (Emto2_5 ,Emto2_6 ,Emto2_7 ,Emto3_5 ,Emto3_6 ,Emto3_7, Emto4_5 ,Emto4_6 ,Emto4_7). 


compute colenosmallness=means (Hum1_3, hum2_2, hum3_2, hum4_2, hum3_5, Hum1_5). 

COMPUTE colenosmallness=(Hum1_3 + hum2_2 + hum3_2 + hum4_2 + hum3_5 + Hum1_5) / 6.
EXECUTE.
