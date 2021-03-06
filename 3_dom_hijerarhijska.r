#pouzdanost
install.packages("haven", dependencies = T)
library(haven)

#uvodjenje matrice
matrica <- read_spss(file.choose())
#check
colnames(matrica)

ajtemi_SWLS <- subset(matrica, select=c(417:421)) 
#check
colnames(ajtemi_SWLS)

library(psych)
#alfa
alpha(ajtemi_SWLS, check.keys = T)



#HIREGAN
#1 korak prediktor zadovoljstvo Ĺľivotom SWLS

#objekat
HIREGAN_mod1<- lm( Negativni_NASuzd ~ SWLS, data = matrica)
#check
summary(HIREGAN_mod1)

#2 korak prediktori pozitivan i negativan efekat PA_panas i NA_panas

#objekat
HIREGAN_mod2 <- lm(Negativni_NASuzd ~ SWLS + PA_panas + NA_panas, data = matrica)
#check
summary(HIREGAN_mod2)

#3 korak prediktori  BFI

#objekat
HIREGAN_mod3 <- lm(Negativni_NASuzd ~ SWLS + PA_panas + NA_panas + prijatnostBFI + emocionalna_stabilnostBFI + ekstraverzijaBFI + intelektBFI + savesnostBFI, data = matrica)
#check
summary(HIREGAN_mod3)

#ANOVA

anova(HIREGAN_mod1, HIREGAN_mod2, HIREGAN_mod3)
#HIREGAN_mod3 die beste

#brisanje ispitanika sa SR van ±2.5
matrica_template <- subset(matrica, select=c(417:421))
options(max.print=1000000)


matrica_template
matrica_svi_odg <- matrica_template[1:933,]

#SR
std.resid <- rstandard(HIREGAN_mod1)
matrica2 <- cbind(matrica_svi_odg, std.resid)
#check
colnames(matrica2)

#izvan opsega
matrica2[std.resid >2.50,]
matrica2[std.resid < -2.50,]



#VIF
library(car)
vif(HIREGAN_mod3)
tolerance <- 1/vif(HIREGAN_mod3)

tolerance
