library(data.table)
library(ggplot2)
library(ggfortify)



Eigenvec <- read.table("1000k_study_cohort.PCA_plot.eigenvec", header=FALSE, na.strings = "-9")




a <- ggplot(data=subset(Eigenvec, !is.na(V13)), aes(x = V3, y = V4, group=V13)) +
  geom_point(aes(shape=V13, color=V13), size=2) + xlab("PC1") + ylab("PC2") +
  ggtitle("PCA Plot 
          ")  + 
  theme_bw()+ 
  scale_shape_manual(name = "Race/Ethnicity & Study cohort", values=c(16, 16, 16, 16, 16, 3))+
  scale_color_manual(name = "Race/Ethnicity & Study cohort",values=c('#A52A2A','#00688B', '#458B74', '#9AC0CD','#8B6969', '#1A1A1A'))+
  theme(plot.title = element_text(hjust = 0.5, size=10)) + theme(panel.grid.major=element_blank(),  panel.grid.minor=element_blank())


tiff("PCA.tiff", units="in", width=7, height=5, res=300)
a
dev.off()
