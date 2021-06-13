import Text.Printf

type Point     = (Float,Float)
type Rect      = (Point,Float,Float)
type Ellipsis = (Point, Float, Float)

-------Constantes
img_width :: Float
img_width = 1920

img_height :: Float
img_height = 1080

-------------------------------------------------------------------------------
-- Paletas
-------------------------------------------------------------------------------

-- O '$' é uma facilidade sintática que substitui parênteses
-- O cycle é uma função bacana -- procure saber mais sobre ela :-)
--Agora ele vai ciclicamente do preto ao azul. Quando chega ao 255, volta a 0.
sequenceBluePalette:: Int -> Int -> Int -> [(Int, Int, Int)]
sequenceBluePalette n initial increment = take n $ cycle [(0,0,x) | x <- [initial, initial+increment .. 255]]

sequenceRedPalette:: Int -> Int -> Int -> [(Int, Int, Int)]
sequenceRedPalette n initial increment = take n $ cycle [(x,0,0) | x <- [initial, initial+increment .. 255]]



-------------------------------------------------------------------------------
-- Geração de retângulos em suas posições
-------------------------------------------------------------------------------





genRectsInLine :: Int -> Int -> Float-> Float -> Float -> Float -> Float -> Float -> [Rect]
genRectsInLine column 0  w h xgap ygap initialx initialy = []
genRectsInLine column line w h xgap ygap initialx initialy = 
  [((initialx+m*(w+xgap), initialy), w, h) | m <- [0..fromIntegral (column-1)]] ++ genRectsInLine column (line - 1) w h xgap ygap initialx (initialy + h + ygap)
--Essa funcao gera retangulos em linha, depois se chama recursivamente pra fazer tudo de novo em outra coordenada y+h+ygap, a condicao de parada dela eh ter 0 colunas restantes pra desenhar


--------

------Elipse
genEllipsis ::  Int -> Int -> Float -> Float -> Float -> Float -> Float -> Float -> Bool -> [Ellipsis]
genEllipsis 0 line rx ry xgap ygap initialx initialy fullfill= []

genEllipsis column line rx ry xgap ygap initialx initialy False= 
  [((initialx, initialy), rx, ry)] ++ [(((initialx, initialy+((fromIntegral (line-1))*(2*ry+ygap))), rx, ry))] ++ genEllipsis (column - 1) line rx ry xgap ygap (initialx + 2*rx + xgap) initialy True

genEllipsis column line rx ry xgap ygap initialx initialy True = 
  [((initialx, m*(2*ry+ygap)+initialy), rx,ry) | m <- [0..fromIntegral (line-1)]] ++ genEllipsis (column - 1) line rx ry xgap ygap (initialx + 2*rx + xgap) initialy False
--Aqui ele vai gerar a lista de elipses e seus raios e coordenadas. Essas coordenadas foram calculadas considerando a posicao dos quadrados. Segue uma logica semelhante a funcao de geracao de retangulos, ajustada para ser feita na direcao do eixo y. O valor booleano da funcao eh o fullfill, que serve pra indicar se a coluna de quadrados vai ser preenchida ou se vai receber elipses somente em seu topo e embaixo.
-----------------


-------------------------------------------------------------------------------
-- Strings SVG
-------------------------------------------------------------------------------

-- Gera string representando retângulo SVG 
-- dadas coordenadas e dimensões do retângulo e uma string com atributos de estilo
svgRect :: Rect -> String -> String 
svgRect ((x,y),w,h) style = 
  printf "<rect x='%.3f' y='%.3f' width='%.2f' height='%.2f' style='%s' />\n" x y w h style

svgEllipsis :: Ellipsis -> String -> String
svgEllipsis ((x,y), rx, ry) style = printf "<ellipse cx='%.3f' cy='%.3f' rx='%.3f' ry='%.3f' style='%s' />" x y rx ry style
 
-- String inicial do SVG

svgBegin :: Float -> Float -> String
svgBegin w h = printf "<svg width='%.2f' height='%.2f' xmlns='http://www.w3.org/2000/svg'>\n" w h 

-- String final do SVG
svgEnd :: String
svgEnd = "</svg>"

-- Gera string com atributos de estilo para uma dada cor
-- Atributo mix-blend-mode permite misturar cores
svgStyle :: (Int,Int,Int) -> String
svgStyle (r,g,b) = printf "fill:rgb(%d,%d,%d); mix-blend-mode: screen;" r g b

-- Gera strings SVG para uma dada lista de figuras e seus atributos de estilo
-- Recebe uma função geradora de strings SVG, uma lista de círculos/retângulos e strings de estilo
svgElements :: (a -> String -> String) -> [a] -> [String] -> String
svgElements func elements styles = concat $ zipWith func elements styles

-------------------------------------------------------------------------------
-- Função principal que gera arquivo com imagem SVG
-------------------------------------------------------------------------------

main :: IO ()
main = do
  putStrLn("Quantas linhas de retangulos?(INT)")
  input_lines <- getLine
  putStrLn("Quantas colunas de retangulos?(INT)")
  input_columns <- getLine
  putStrLn("Qual a coordenada x inicial?(FLOAT)")
  input_initialx <- getLine
  putStrLn("Qual a coordenada y inicial?(FLOAT)")
  input_initialy <- getLine
  putStrLn("Qual o espaco entre quadrados no eixo x?(FLOAT)")
  input_xgap <- getLine
  putStrLn("Qual o espaco entre quadrados no eixo y?(FLOAT)")
  input_ygap <- getLine
  putStrLn("Qual a altura dos retangulos?(FLOAT)")
  input_rect_height <- getLine
  putStrLn ("Qual a largura dos retangulos?(FLOAT)")
  input_rect_width <- getLine
  putStrLn ("Qual o valor inicial do RGB azul?(INT)")
  input_initial_blueRGB <- getLine
  putStrLn ("Qual o valor de incremento do RGB azul?(INT)")
  input_increment_blueRGB <- getLine
  putStrLn ("Qual o valor inicial do RGB vermelho?(INT)")
  input_initial_redRGB <- getLine
  putStrLn("Qual o valor de incremento do RGB vermelho?(INT)")
  input_increment_redRGB <- getLine

  
  let   svgstrs = svgBegin img_width img_height ++ svgfinalrects ++ svgfinalellipsis ++ svgEnd
        svgfinalrects = svgElements svgRect rects (map svgStyle rectPalette)
        svgfinalellipsis = svgElements svgEllipsis ellipsis (map svgStyle ellipsisPalette)

        ellipsis = genEllipsis  columns lines rx ry xgap ygap (initialx + rx) (initialy + ry) True

        rects = genRectsInLine columns lines rect_width rect_height xgap ygap initialx initialy


        rectPalette = sequenceBluePalette nrects initial_blueRGB increment_blueRGB
        ellipsisPalette = sequenceRedPalette nellipsis initial_redRGB increment_redRGB

        nrects = columns*lines
        rx = rect_width/2
        ry = rect_height/2
        nellipsis = nrects

        initialx = read input_initialx :: Float
        initialy = read input_initialy :: Float
        xgap = read input_xgap :: Float
        ygap = read input_ygap :: Float
        rect_width = read input_rect_width :: Float
        rect_height = read input_rect_height :: Float
        lines = read input_lines :: Int
        columns = read input_columns :: Int
        initial_blueRGB = read input_initial_blueRGB :: Int
        increment_blueRGB = read input_increment_blueRGB :: Int
        initial_redRGB = read input_initial_redRGB :: Int
        increment_redRGB = read input_increment_redRGB :: Int



  writeFile "rects.svg" $ svgstrs




