
# Portabilidade de Clientes Grafos

### Link Pdf

[Relatório](relatorio_final.pdf)

### Introdução

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
O tema escolhido foi a portabilidade de clientes da plataforma de cursos on-line DataCamp. O banco de dados utilizado recupera as informações sobre portabilidade de alunos da plataforma. Este banco de dados faz parte do curso _Predictive Analytics Using Networked Data in R_ oferecido pela mesma plataforma.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
A primeira parte do trabalho consistiu na análise exploratória e descritiva do grafo por meio da ilustração da rede e cálculo de estatísticas descritivas. A segunda parte consistiu na modelagem da cooperação entre clientes da rede utilizando o modelo de Grafos Aleatórios Exponenciais.


### Conclusões

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
O modelo apresentou __ajuste significativo__ para explicar a __conectividade da rede de clientes__. A qualidade do ajuste indicou que o modelo é __similar__ aos grafos simulados aleatoriamente com a mesma estrutura de coeficientes. Somente na estatística __proporção de vértices por grau__, o modelo parece __distoar__ das simulações na região central da distribuição.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
O coeficiente __nodecov.Portabilidade__ indicou que os grupos que optaram pela __portabilidade cooperavam__ mais na rede. Tal evidência poderia sugerir que clientes __mais conectados__ tenderiam a __conhecer novas plataformas__ e a trocar de plataforma com mais frequência. Outra razão seria supor que clientes mais engajados tenderiam a __completar seus estudos__ e migrar para plataformas diferentes.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
A compreensão da variabilidade na conexão entre os indivíduos  poderia ser melhor examinada com a __mineração de mais dados__ sobre o comportamento dos clientes. No que diz respeito a implementações futuras, __modelos de classificação binária__ poderiam ser considerados para tentar __inferir a portabilidade de clientes__  considerando como atributos as estatísticas das estruturas desta rede.