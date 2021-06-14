# Trabalho 1 de Paradigmas de programação - Haskell

  ## Objetivo

  O trabalho foi desenvolvido em Haskell e tem como objetivo desenhar um fundo de quadrados espaçados que têm o tom de azul incrementado conforme o input do usuário. Além disso, desenha elipses dentro dos quadrados, que têm seu tom de vermelho incrementado, também de acordo com o input do usuário.

  ## Informações gerais

  É Possível escolher distâncias personalizadas e tamanhos livremente, bem como coordenadas iniciais. Os retângulos com elipses serão sempre desenhados de forma retangular, não sendo possível desenhar escadas, por exemplo. As elipses sempre aparecerão completando os quadrados pelo eixo y e depois completando só o primeiro e o último quadrado do eixo y, ciclicamente.

  ## Observações

  Cuidado com o RGB que colocar, pode parecer que o programa não está desenhando a elipse, mas na verdade as cores podem estar apenas muito próximas.

  ## Sugestão de uso

  Quantas linhas de retangulos?(INT)
  10

  Quantas colunas de retangulos?(INT)
  10

  Qual a coordenada x inicial?(FLOAT)
  0

  Qual a coordenada y inicial?(FLOAT)
  0

  Qual o espaco entre quadrados no eixo x?(FLOAT)
  10

  Qual o espaco entre quadrados no eixo y?(FLOAT)
  10

  Qual a altura dos retangulos?(FLOAT)
  90

  Qual a largura dos retangulos?(FLOAT)
  90

  Qal o valor inicial do RGB azul?(INT)
  120

  Qual o valor de incremento do RGB azul?(INT)
  10

  Qual o valor inicial do RGB vermelho?(INT)
  120

  Qual o valor de incremento do RGB vermelho?(INT)
  10

  É interessante, também, utilizar o input acima com valores diferentes de largura e altura dos retângulos,pois há suporte a elipses.

  ## Implementação

  O trabalho foi implementado utilizando as funções exemplificadas nas práticas 6 e 4 como base. A lógica foi quase que completamente modificada, mantendo-se apenas as funções de geração do SVG.
  
  As funções que geram o RGB fazem um ciclo conforme o input do usuário, ou seja, o usuário entra com um valor x que é o inicial no ciclo até 255, e um valor y que é o passo desse ciclo. Para quadrados, utiliza-se (0,0,x) e, para as elipses, (x,0,0).

  A função que gera os quadrados faz uma list comprehension para gerar os quadrados no eixo X, e chama-se recursivamente para fazer o mesmo no eixo y, conforme o número de recursões solicitado pelo usuário. A função respeita, também, diferentes "gaps" para os eixos x e y.

  A função que gera as elipses faz algo semelhante à função anterior, mas tem mais condições de não execução. Isso porque o objetivo não é preencher todos os quadrados, mas sim apenas uma parte deles, formando um desenho. Eu havia implementado com círculos anteriormente, mas isso obrigava os retângulos a se tornarem quadrados, do contrário, o círculo ficava para fora. O programa manipula os valores das elipses para encaixá-las, Utiliza-se ry = altura/2 e rx = largura/2, e incrementa-se o valor inicial inserido para o quadrado com o respectivo raio da elipse.

  A main utiliza variáveis auxiliares para traduzir a leitura, pois seria ilegível passar "(read argumento :: Float)" em todos os argumentos de funções. Pega todos os valores que são solicitados ao usuário e gera a imagem completamente baseada neles, sem a utilização de pontos fixos. Só foi utilizado como fixo o tamanho da imagem, 1920x1080.