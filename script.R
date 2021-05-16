# -----------------------------------------------------------------------------

# Script Portabilidade de Clientes Grafos Aleatorios

# -----------------------------------------------------------------------------

# Carrega Bibliotecas
library(igraph)
library(tidyverse)
library(knitr)
library(ergm)
library(broom)

# -----------------------------------------------------------------------------

# Carrega dados
load("dados/StudentEdgelist.RData")
load("dados/StudentCustomers.RData")

# Renomeia categorias de portabilidade
clientes <- customers %>% mutate(portabilidade = ifelse(churn == 0, "Não", "Sim"))

# -----------------------------------------------------------------------------

# Declara a rede apartir do data frame de arestas
rede <- graph_from_data_frame(edgeList, directed = FALSE)

# Atribui cor verde para clientes que portaram 
V(rede)$color <- gsub("1", "green", clientes$churn) 

# Atribui a cor azul para os clientes que não portaram
V(rede)$color <- gsub("0", "blue", clientes$churn)

# Desenha o grafo
plot(rede,
     vertex.label = NA,
     edge.label = NA,
     edge.color = "black",
     vertex.size = 2,
     layout = layout_with_kk)

# -----------------------------------------------------------------------------

# Constroi rede
rede <- graph_from_data_frame(edgeList, directed = FALSE)

# Atribui cor verde para clientes que portaram 
V(rede)$color <- gsub("1", "green", customers$churn) 

# Atribui a cor azul para os que nao portaram
V(rede)$color <- gsub("0", "blue", customers$churn)

# -----------------------------------------------------------------------------

# Declara subgrafo de clientes que optaram pela portabilidade
rede_portabilidade <- induced_subgraph(rede, v = V(rede)[which(V(rede)$churn == 1)])

# Desenha grafico 
plot(rede_portabilidade,
     vertex.label = NA,
     vertex.size = 2,
     edge.size = 4,
     edge.color = "black",
     vertex.color = "green",
     layout = layout_with_fr)

# -----------------------------------------------------------------------------

# Verifica se o grafo é simples
simples <- is.simple(rede)

# Verifica se a rede e conectada 
conectada <- is.connected(rede)

# Calcula diâmetro
diametro <- diameter(rede)

# Calcula densidade 
densidade <- graph.density(rede)

# Calcula transitividade 
transitividade <- transitivity(rede)

# Calcula assortatividade nominal
assort_nominal <- assortativity_nominal(rede, (V(rede)$color == "1") + 1, directed = F)

# Calcula assortatividade de grau
assort_graus <- assortativity.degree(rede)

# Calcula número e tamanho de comunidades
comunidades <- sizes(fastgreedy.community(rede))

# -----------------------------------------------------------------------------

# Cálcula graus da rede 
graus <- degree(rede)

# Desenha Histograma de Graus
ggplot(as_tibble(graus), aes(x = value))+
  geom_histogram(binwidth = 1,
                 fill = "blue",
                 col="grey",
                 position = 'dodge')+
  xlab("Graus")+
  ylab("Frequencia")+
  ggtitle("Histograma dos Graus")

# -----------------------------------------------------------------------------

# Desenha gráfico de barras da portabilidade de clientes
ggplot(clientes, aes(x = as.factor(portabilidade),
                     fill = as.factor(portabilidade) )) +  
  geom_bar() +
  xlab("Portabilidade") + 
  ylab("Frequencia") +
  scale_fill_manual("Portabilidade",
                    values = c("blue", "green"))

# -----------------------------------------------------------------------------

# Define rede do tipo network a partir de matriz de adjacências
rede.s <- network::as.network( as.matrix( get.adjacency(rede) ), directed = F)

# Define atributo de portabilidade
network::set.vertex.attribute(rede.s, "Portabilidade", clientes$churn)

# Especifica modelo
minha.ergm <- formula(rede.s ~ edges + kstar(2) + kstar(3) + triangle +
                        nodemain("Portabilidade") + match("Portabilidade"))

# Recupera resumo da especificação
especs <- t(t(summary(minha.ergm)))

# Declara data frame de resultados
especs <- tibble(Estatisticas = row.names(especs),
                 Contagem = especs[,1] %>%  as.vector())

# -----------------------------------------------------------------------------

# Indica Semente
set.seed(10)

# Ajusta modelo
modelo <- ergm(minha.ergm, set.control.ergm = control.ergm(MCMC.burnin = 1e5))

# Declara data frame de resultados
resultados <- data.frame(Atributos = c("Arestas",
                                       "Estrela-2",
                                       "Estrela-3",
                                       "Triângulo",
                                       "nodcov.Portabilidade",
                                       "nodmatch.Portabilidade")) %>%
  cbind(summary(modelo)$coefficients) %>% 
  as_tibble() %>% 
  rename("Estimativa" = "Estimate",
         "Erro Padrão" = "Std. Error",
         "Valor z" = "z value")

# -----------------------------------------------------------------------------

# Calcula analise de variancia e recupera comparação de modelos
analise_var <- tidy(anova(modelo)) %>% 
  rename("Modelo" = "term",
         "Gl" = "df",
         "Desvio" = "Deviance",
         "Resíduo Gl" = "Resid..Df",
         "Desvio Resíduos" = "Resid..Dev",
         "Pvalor" = "Pr...Chisq..") %>% 
  replace_na(list(Gl = "-", Desvio = "-", Pvalor = "-")) %>% 
  mutate(Modelo = c("Nulo", "Especificado"))

# -----------------------------------------------------------------------------

# Simula grafos aleatórios para comparar ajuste
bondade_ajuste <- gof(modelo)

# Desenha gráficos
plot(bondade_ajuste, main = "Diagnóstico da Qualidade do Ajuste")

# -----------------------------------------------------------------------------



