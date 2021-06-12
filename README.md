# Trabalho 1 de Paradigmas de programação

  ## Objetivo

  O trabalho foi desenvolvido em Haskell e tem como objetivo desenhar um fundo de quadrados espaçados que têm o RGB incrementado do preto ao azul e, quando se chega a 255, volta ao preto, formando um ciclo.

  ## Implementação

  O trabalho foi implementado utilizando as funções exemplificadas nas práticas 6 e 4 como base. A lógica foi quase que completamente modificada, mantendo-se apenas as funções de geração do SVG.
  
  A função que gera o RGB utiliza list comprehension para gerar cores de (0,0,0) a (0,0,255) ciclicamente conforme o numero de elementos.

  A função que gera os quadrados faz uma list comprehension para gerar os quadrados no eixo X, e chama-se recursivamente para fazer o mesmo no eixo y, conforme o número de recursões solicitado pelo usuário. A função respeita, também, diferentes "gaps" para os eixos x e y.

  