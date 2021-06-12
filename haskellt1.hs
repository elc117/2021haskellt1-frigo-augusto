import Text.Printf

type Point     = (Float,Float)
type Rect      = (Point,Float,Float)
type Circle    = (Point,Float)
type Ellipse = (Point, Float, Float)

-------------------------------------------------------------------------------
-- Paletas
-------------------------------------------------------------------------------

-- O '$' é uma facilidade sintática que substitui parênteses
-- O cycle é uma função bacana -- procure saber mais sobre ela :-)
--Agora ele vai ciclicamente do preto ao azul. Quando chega ao 255, volta a 0.
sequenceBluePalette:: Int -> [(Int, Int, Int)]
sequenceBluePalette n = take n $ cycle [(0,0,x) | x <- [0 .. 255]]

sequenceRedPalette:: Int -> [(Int, Int, Int)]
sequenceRedPalette n = take n $ cycle [(x,0,0) | x <- [120 .. 255-120]]



-------------------------------------------------------------------------------
-- Geração de retângulos em suas posições
-------------------------------------------------------------------------------


genRectsInDiagonal :: Int -> [Rect]
genRectsInDiagonal n  = [((m*(w+gap), (m*(w+gap))), w, h) | m <- [0..fromIntegral (n-1)]]
  where (w,h) = (3,3)
        gap = 1




-- Vou gerar quadrados e nao retangulos, pois, do contrario, nao e possivel colocar um circulo dentro (na verdade até dá, mas fica feio)
genRectsInLine :: Int -> Int -> Float-> Float -> Float -> Float -> Float -> Float -> [Rect]
genRectsInLine column 0  w h xgap ygap initialx initialy = []
genRectsInLine column line w h xgap ygap initialx initialy = [((initialx+m*(w+xgap), initialy), w, h) | m <- [0..fromIntegral (column-1)]] ++ genRectsInLine column (line - 1) w h xgap ygap initialx (initialy + h + ygap)
--Essa funcao gera quadrados em linha, depois se chama recursivamente pra fazer tudo de novo em outra coordenada y+h+ygap, a condicao de parada dela eh ter 0 colunas restantes pra desenhar



genCircles ::  Int -> Int -> Float -> Float -> Float -> Float -> Float -> Bool -> [Circle]
genCircles 0 line r xgap ygap initialx initialy fullfill= []
genCircles column line r xgap ygap initialx initialy False= [] ++ genCircles (column - 1) line r xgap ygap (initialx + 2*r + xgap) initialy True

genCircles column line r xgap ygap initialx initialy True = [((initialx, m*(2*r+ygap)+initialy), r) | m <- [0..fromIntegral (line-1)]] ++ genCircles (column - 1) line r xgap ygap (initialx + 2*r + xgap) initialy False
-------------------------------------------------------------------------------
-- Strings SVG
-------------------------------------------------------------------------------

-- Gera string representando retângulo SVG 
-- dadas coordenadas e dimensões do retângulo e uma string com atributos de estilo
svgRect :: Rect -> String -> String 
svgRect ((x,y),w,h) style = 
  printf "<rect x='%.3f' y='%.3f' width='%.2f' height='%.2f' style='%s' />\n" x y w h style


svgCircle :: Circle -> String -> String
svgCircle ((x,y),r) style = printf "<circle cx='%.3f' cy='%.3f' r='%.2f' style='%s' />\n" x y r style

svgEllipse :: Ellipse -> String -> String
svgEllipse ((x,y), rx, ry) style = printf "<ellipse cx="200" cy="80" rx="100" ry="50"
  style="fill:yellow;stroke:purple;stroke-width:2" />"
 
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
  writeFile "rects.svg" $ svgstrs
  where svgstrs = svgBegin w h ++ svgfinalrects ++ svgfinalcircles ++ svgEnd
        svgfinalrects = svgElements svgRect rects (map svgStyle palette)
        svgfinalcircles = svgElements svgCircle circles (map svgStyle circlePalette)
        circles = genCircles   5 10  15   5 10 315 415 True
        --parametros do circulo: colunas linhas raio xgap ygap (initialx + r) (initialy + r)
        rects = genRectsInLine 5 10 30 30 5 10 300 400
        nrects = 5*10
        lines = 10
        columns = 5
        ncircles = nrects
        palette = sequenceBluePalette nrects
        circlePalette = sequenceRedPalette ncircles
        (w,h) = (5000,5000) -- width,height da imagem SVG



