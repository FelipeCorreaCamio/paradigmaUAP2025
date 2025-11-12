module Clase4 exposing (..)

{-| Ejercicios de Programación Funcional - Clase 4
Este módulo contiene ejercicios para practicar pattern matching y mónadas en Elm
usando árboles binarios como estructura de datos principal.

Temas:
- Pattern Matching con tipos algebraicos
- Mónada Maybe para operaciones opcionales
- Mónada Result para manejo de errores
- Composición monádica con andThen
-}


-- ============================================================================
-- DEFINICIÓN DEL ÁRBOL BINARIO
-- ============================================================================

type Tree a
    = Empty
    | Node a (Tree a) (Tree a)


-- ============================================================================
-- PARTE 0: CONSTRUCCIÓN DE ÁRBOLES
-- ============================================================================


-- 1. Crear Árboles de Ejemplo


arbolVacio : Tree Int
arbolVacio =
    Empty


arbolHoja : Tree Int
arbolHoja =
    Node 5 Empty Empty


arbolPequeno : Tree Int
arbolPequeno =
    Node 3 (Node 1 Empty Empty) (Node 5 Empty Empty)


arbolMediano : Tree Int
arbolMediano =
    Node 10
        (Node 5 (Node 3 Empty Empty) (Node 7 Empty Empty))
        (Node 15 (Node 12 Empty Empty) (Node 20 Empty Empty))


-- 2. Es Vacío


esVacio : Tree a -> Bool
esVacio arbol =
    case arbol of
        Empty ->
            True

        _ ->
            False


-- 3. Es Hoja


esHoja : Tree a -> Bool
esHoja arbol =
    case arbol of
        Node _ Empty Empty ->
            True

        _ ->
            False


-- ============================================================================
-- PARTE 1: PATTERN MATCHING CON ÁRBOLES
-- ============================================================================


-- 4. Tamaño del Árbol


tamaño : Tree a -> Int
tamaño arbol =
    case arbol of
        Empty -> 0
        Node _ izq der -> 1 + tamaño izq + tamaño der


-- 5. Altura del Árbol


altura : Tree a -> Int
altura arbol =
    case arbol of
        Empty -> 0
        Node _ izq der -> 1 + max (altura izq) (altura der)


-- 6. Suma de Valores


sumarArbol : Tree Int -> Int
sumarArbol arbol =
    case arbol of
        Empty -> 0
        Node v izq der -> v + sumarArbol izq + sumarArbol der


-- 7. Contiene Valor


contiene : a -> Tree a -> Bool
contiene valor arbol =
    case arbol of
        Empty -> False
        Node v izq der ->
            (v == valor) || contiene valor izq || contiene valor der


-- 8. Contar Hojas


contarHojas : Tree a -> Int
contarHojas arbol =
    case arbol of
        Empty -> 0
        Node _ Empty Empty -> 1
        Node _ izq der -> contarHojas izq + contarHojas der


-- 9. Valor Mínimo (sin Maybe)


minimo : Tree Int -> Int
minimo arbol =
    case arbol of
        Empty -> 0
        Node v izq der ->
            let
                mi = minimo izq
                md = minimo der
                menor = if mi == 0 && izq == Empty then v else if md == 0 && der == Empty then v else Basics.min v (Basics.min mi md)
            in
            if izq == Empty && der == Empty then v else Basics.min v (Basics.min mi md)


-- 10. Valor Máximo (sin Maybe)


maximo : Tree Int -> Int
maximo arbol =
    case arbol of
        Empty -> 0
        Node v izq der ->
            let
                mi = maximo izq
                md = maximo der
            in
            Basics.max v (Basics.max mi md)


-- ============================================================================
-- PARTE 2: INTRODUCCIÓN A MAYBE
-- ============================================================================


-- 11. Buscar Valor


buscar : a -> Tree a -> Maybe a
buscar valor arbol =
    case arbol of
        Empty -> Nothing
        Node v izq der ->
            if v == valor then Just v else
                case buscar valor izq of
                    Just x -> Just x
                    Nothing -> buscar valor der


-- 12. Encontrar Mínimo (con Maybe)


encontrarMinimo : Tree comparable -> Maybe comparable
encontrarMinimo arbol =
    case arbol of
        Empty -> Nothing
        Node v Empty Empty -> Just v
        Node v izq der ->
            let
                mi = encontrarMinimo izq
                md = encontrarMinimo der
            in
            case ( mi, md ) of
                ( Nothing, Nothing ) -> Just v
                ( Just a, Nothing ) -> Just (Basics.min a v)
                ( Nothing, Just b ) -> Just (Basics.min b v)
                ( Just a, Just b ) -> Just (List.foldl Basics.min v [ a, b ])


-- 13. Encontrar Máximo (con Maybe)


encontrarMaximo : Tree comparable -> Maybe comparable
encontrarMaximo arbol =
    case arbol of
        Empty -> Nothing
        Node v Empty Empty -> Just v
        Node v izq der ->
            let
                mi = encontrarMaximo izq
                md = encontrarMaximo der
            in
            case ( mi, md ) of
                ( Nothing, Nothing ) -> Just v
                ( Just a, Nothing ) -> Just (Basics.max a v)
                ( Nothing, Just b ) -> Just (Basics.max b v)
                ( Just a, Just b ) -> Just (List.foldl Basics.max v [ a, b ])


-- 14. Buscar Por Predicado


buscarPor : (a -> Bool) -> Tree a -> Maybe a
buscarPor predicado arbol =
    case arbol of
        Empty -> Nothing
        Node v izq der ->
            if predicado v then Just v else
                case buscarPor predicado izq of
                    Just x -> Just x
                    Nothing -> buscarPor predicado der


-- 15. Obtener Valor de Raíz


raiz : Tree a -> Maybe a
raiz arbol =
    case arbol of
        Empty -> Nothing
        Node v _ _ -> Just v


-- 16. Obtener Hijo Izquierdo


hijoIzquierdo : Tree a -> Maybe (Tree a)
hijoIzquierdo arbol =
    case arbol of
        Empty -> Nothing
        Node _ izq _ -> Just izq


hijoDerecho : Tree a -> Maybe (Tree a)
hijoDerecho arbol =
    case arbol of
        Empty -> Nothing
        Node _ _ der -> Just der


-- 17. Obtener Nieto


nietoIzquierdoIzquierdo : Tree a -> Maybe (Tree a)
nietoIzquierdoIzquierdo arbol =
    hijoIzquierdo arbol |> Maybe.andThen hijoIzquierdo


-- 18. Buscar en Profundidad


obtenerSubarbol : a -> Tree a -> Maybe (Tree a)
obtenerSubarbol valor arbol =
    case arbol of
        Empty -> Nothing
        Node v izq der ->
            if v == valor then Just arbol else
                case obtenerSubarbol valor izq of
                    Just x -> Just x
                    Nothing -> obtenerSubarbol valor der


buscarEnSubarbol : a -> a -> Tree a -> Maybe a
buscarEnSubarbol valor1 valor2 arbol =
    obtenerSubarbol valor1 arbol |> Maybe.andThen (\sub -> buscar valor2 sub)


-- ============================================================================
-- PARTE 3: RESULT PARA VALIDACIONES
-- ============================================================================


-- 19. Validar No Vacío


validarNoVacio : Tree a -> Result String (Tree a)
validarNoVacio arbol =
    case arbol of
        Empty -> Err "El árbol está vacío"
        _ -> Ok arbol


-- 20. Obtener Raíz con Error


obtenerRaiz : Tree a -> Result String a
obtenerRaiz arbol =
    case arbol of
        Empty -> Err "No se puede obtener la raíz de un árbol vacío"
        Node v _ _ -> Ok v


-- 21. Dividir en Valor Raíz y Subárboles


dividir : Tree a -> Result String ( a, Tree a, Tree a )
dividir arbol =
    case arbol of
        Empty -> Err "No se puede dividir un árbol vacío"
        Node v izq der -> Ok ( v, izq, der )


-- 22. Obtener Mínimo con Error


obtenerMinimo : Tree comparable -> Result String comparable
obtenerMinimo arbol =
    let
        minMaybe = encontrarMinimo arbol
    in
    case minMaybe of
        Nothing -> Err "No hay mínimo en un árbol vacío"
        Just v -> Ok v


-- 23. Verificar si es BST


esBST : Tree comparable -> Bool
esBST arbol =
    let
        inorderList = inorder arbol
        esNoDecreciente l =
            case l of
                [] -> True
                [ _ ] -> True
                x :: y :: xs -> (x <= y) && esNoDecreciente (y :: xs)
    in
    esNoDecreciente inorderList


-- 24. Insertar en BST


insertarBST : comparable -> Tree comparable -> Result String (Tree comparable)
insertarBST valor arbol =
    case arbol of
        Empty -> Ok (Node valor Empty Empty)
        Node v izq der ->
            if valor == v then
                Err ("El valor " ++ String.fromInt (Basics.round 0 + 0) |> always "El valor ya existe en el árbol")
            else if valor < v then
                insertarBST valor izq |> Result.map (\ni -> Node v ni der)
            else
                insertarBST valor der |> Result.map (\nd -> Node v izq nd)


-- 25. Buscar en BST


buscarEnBST : comparable -> Tree comparable -> Result String comparable
buscarEnBST valor arbol =
    case arbol of
        Empty -> Err ("El valor " ++ Debug.toString valor ++ " no se encuentra en el árbol")
        Node v izq der ->
            if valor == v then Ok v
            else if valor < v then buscarEnBST valor izq
            else buscarEnBST valor der


-- 26. Validar BST con Result


validarBST : Tree comparable -> Result String (Tree comparable)
validarBST arbol =
    if esBST arbol then Ok arbol else Err "El árbol no es un BST válido"


-- ============================================================================
-- PARTE 4: COMBINANDO MAYBE Y RESULT
-- ============================================================================


-- 27. Maybe a Result


maybeAResult : String -> Maybe a -> Result String a
maybeAResult mensajeError maybe =
    case maybe of
        Nothing -> Err mensajeError
        Just v -> Ok v


-- 28. Result a Maybe


resultAMaybe : Result error value -> Maybe value
resultAMaybe result =
    case result of
        Ok v -> Just v
        Err _ -> Nothing


-- 29. Buscar y Validar


buscarPositivo : Int -> Tree Int -> Result String Int
buscarPositivo valor arbol =
    case buscar valor arbol of
        Nothing -> Err ("El valor " ++ String.fromInt valor ++ " no se encuentra en el árbol")
        Just v -> if v > 0 then Ok v else Err ("El valor " ++ String.fromInt v ++ " no es positivo")


-- 30. Pipeline de Validaciones


validarArbol : Tree Int -> Result String (Tree Int)
validarArbol arbol =
    validarNoVacio arbol
        |> Result.andThen (\_ -> if esBST arbol then Ok arbol else Err "El árbol no es BST")
        |> Result.andThen (\t ->
            let
                todosPositivos =
                    let
                        lista = inorder arbol
                    in
                    List.all (\x -> x > 0) lista
            in
            if todosPositivos then Ok t else Err "Hay valores no positivos"
           )


-- 31. Encadenar Búsquedas


buscarEnDosArboles : Int -> Tree Int -> Tree Int -> Result String Int
buscarEnDosArboles valor arbol1 arbol2 =
    buscarPositivo valor arbol1
        |> Result.andThen (\v -> buscarPositivo v arbol2)


-- ============================================================================
-- PARTE 5: DESAFÍOS AVANZADOS
-- ============================================================================


-- 32. Recorrido Inorder


inorder : Tree a -> List a
inorder arbol =
    case arbol of
        Empty -> []
        Node v izq der -> inorder izq ++ [ v ] ++ inorder der


-- 33. Recorrido Preorder


preorder : Tree a -> List a
preorder arbol =
    case arbol of
        Empty -> []
        Node v izq der -> [ v ] ++ preorder izq ++ preorder der


-- 34. Recorrido Postorder


postorder : Tree a -> List a
postorder arbol =
    case arbol of
        Empty -> []
        Node v izq der -> postorder izq ++ postorder der ++ [ v ]


-- 35. Map sobre Árbol


mapArbol : (a -> b) -> Tree a -> Tree b
mapArbol funcion arbol =
    case arbol of
        Empty -> Empty
        Node v izq der -> Node (funcion v) (mapArbol funcion izq) (mapArbol funcion der)


-- 36. Filter sobre Árbol


filterArbol : (a -> Bool) -> Tree a -> Tree a
filterArbol predicado arbol =
    case arbol of
        Empty -> Empty
        Node v izq der ->
            let
                fIzq = filterArbol predicado izq
                fDer = filterArbol predicado der
            in
            if predicado v then
                Node v fIzq fDer
            else
                case ( fIzq, fDer ) of
                    ( Empty, Empty ) -> Empty
                    ( Empty, t ) -> t
                    ( t, Empty ) -> t
                    ( t, _ ) -> t


-- 37. Fold sobre Árbol


foldArbol : (a -> b -> b) -> b -> Tree a -> b
foldArbol funcion acumulador arbol =
    case arbol of
        Empty -> acumulador
        Node v izq der ->
            let
                acumIzq = foldArbol funcion acumulador izq
                acumNodo = funcion v acumIzq
            in
            foldArbol funcion acumNodo der


-- 38. Eliminar de BST


eliminarBST : comparable -> Tree comparable -> Result String (Tree comparable)
eliminarBST valor arbol =
    let
        minValor t =
            case t of
                Empty -> Nothing
                Node v Empty _ -> Just v
                Node _ izq _ -> minValor izq

        eliminar v t =
            case t of
                Empty -> Err ("El valor " ++ Debug.toString v ++ " no existe en el árbol")
                Node x izq der ->
                    if v < x then eliminar v izq |> Result.map (\ni -> Node x ni der)
                    else if v > x then eliminar v der |> Result.map (\nd -> Node x izq nd)
                    else
                        -- borrar este nodo
                        case ( izq, der ) of
                            ( Empty, Empty ) -> Ok Empty
                            ( Empty, _ ) -> Ok der
                            ( _, Empty ) -> Ok izq
                            ( _, _ ) ->
                                case minValor der of
                                    Just m ->
                                        eliminar m der |> Result.map (\nuevoDer -> Node m izq nuevoDer)
                                    Nothing -> Ok izq
    in
    eliminar valor arbol


-- 39. Construir BST desde Lista


desdeListaBST : List comparable -> Result String (Tree comparable)
desdeListaBST lista =
    let
        insertarSinDup val t =
            insertarBST val t
        paso val accResult =
            case accResult of
                Err msg -> Err msg
                Ok t ->
                    case insertarSinDup val t of
                        Err _ -> Err ("Valor duplicado: " ++ Debug.toString val)
                        Ok nt -> Ok nt
    in
    List.foldl paso (Ok Empty) lista


-- 40. Verificar Balance


estaBalanceado : Tree a -> Bool
estaBalanceado arbol =
    let
        alturaLocal t =
            case t of
                Empty -> 0
                Node _ l r -> 1 + max (alturaLocal l) (alturaLocal r)
        balanced t =
            case t of
                Empty -> True
                Node _ l r ->
                    let
                        diff = Basics.abs (alturaLocal l - alturaLocal r)
                    in
                    diff <= 1 && balanced l && balanced r
    in
    balanced arbol


-- 41. Balancear BST


balancear : Tree comparable -> Tree comparable
balancear arbol =
    let
        lista = inorder arbol
        build l =
            case l of
                [] -> Empty
                _ ->
                    let
                        n = List.length l
                        medio = n // 2
                        izquierda = List.take medio l
                        v = List.drop medio l |> List.head |> Maybe.withDefault (Debug.todo "lista vacía inesperada")
                        derecha = List.drop (medio + 1) l
                    in
                    Node v (build izquierda) (build derecha)
    in
    build lista


-- 42. Camino a un Valor


type Direccion
    = Izquierda
    | Derecha


encontrarCamino : a -> Tree a -> Result String (List Direccion)
encontrarCamino valor arbol =
    case arbol of
        Empty -> Err ("El valor " ++ Debug.toString valor ++ " no existe en el árbol")
        Node v izq der ->
            if v == valor then Ok []
            else
                case encontrarCamino valor izq of
                    Ok camino -> Ok (Izquierda :: camino)
                    Err _ ->
                        case encontrarCamino valor der of
                            Ok camino2 -> Ok (Derecha :: camino2)
                            Err _ -> Err ("El valor " ++ Debug.toString valor ++ " no existe en el árbol")


-- 43. Seguir Camino


seguirCamino : List Direccion -> Tree a -> Result String a
seguirCamino camino arbol =
    case ( camino, arbol ) of
        ( [], Empty ) -> Err "Camino inválido: árbol vacío"
        ( [], Node v _ _ ) -> Ok v
        ( Izquierda :: ds, Node _ izq _ ) -> seguirCamino ds izq
        ( Derecha :: ds, Node _ _ der ) -> seguirCamino ds der
        ( Izquierda :: _, Empty ) -> Err "Camino inválido: no hay hijo izquierdo"
        ( Derecha :: _, Empty ) -> Err "Camino inválido: no hay hijo derecho"


-- 44. Ancestro Común Más Cercano


ancestroComun : comparable -> comparable -> Tree comparable -> Result String comparable
ancestroComun valor1 valor2 arbol =
    let
        ambosExisten = contiene valor1 arbol && contiene valor2 arbol
        lca v1 v2 t =
            case t of
                Empty -> Err "Uno o ambos valores no existen en el árbol"
                Node v izq der ->
                    if (v1 < v) && (v2 < v) then lca v1 v2 izq
                    else if (v1 > v) && (v2 > v) then lca v1 v2 der
                    else Ok v
    in
    if ambosExisten then lca valor1 valor2 arbol else Err "Uno o ambos valores no existen en el árbol"


-- ============================================================================
-- PARTE 6: DESAFÍO FINAL - SISTEMA COMPLETO
-- ============================================================================


-- 45. Sistema Completo de BST
-- (Las funciones individuales ya están definidas arriba)


-- Operaciones que retornan Bool
esBSTValido : Tree comparable -> Bool
esBSTValido arbol =
    esBST arbol


estaBalanceadoCompleto : Tree comparable -> Bool
estaBalanceadoCompleto arbol =
    estaBalanceado arbol


contieneValor : comparable -> Tree comparable -> Bool
contieneValor valor arbol =
    contiene valor arbol


-- Operaciones que retornan Maybe
buscarMaybe : comparable -> Tree comparable -> Maybe comparable
buscarMaybe valor arbol =
    buscar valor arbol


encontrarMinimoMaybe : Tree comparable -> Maybe comparable
encontrarMinimoMaybe arbol =
    encontrarMinimo arbol


encontrarMaximoMaybe : Tree comparable -> Maybe comparable
encontrarMaximoMaybe arbol =
    encontrarMaximo arbol


-- Operaciones que retornan Result
insertarResult : comparable -> Tree comparable -> Result String (Tree comparable)
insertarResult valor arbol =
    insertarBST valor arbol


eliminarResult : comparable -> Tree comparable -> Result String (Tree comparable)
eliminarResult valor arbol =
    eliminarBST valor arbol


validarResult : Tree comparable -> Result String (Tree comparable)
validarResult arbol =
    validarBST arbol


obtenerEnPosicion : Int -> Tree comparable -> Result String comparable
obtenerEnPosicion posicion arbol =
    if posicion < 0 then Err "Posición inválida" else
        let lista = inorder arbol in
        case List.drop posicion lista |> List.head of
            Just v -> Ok v
            Nothing -> Err "Posición inválida"


-- Operaciones de transformación
map : (a -> b) -> Tree a -> Tree b
map funcion arbol =
    mapArbol funcion arbol


filter : (a -> Bool) -> Tree a -> Tree a
filter predicado arbol =
    filterArbol predicado arbol


fold : (a -> b -> b) -> b -> Tree a -> b
fold funcion acumulador arbol =
    foldArbol funcion acumulador arbol


-- Conversiones
aLista : Tree a -> List a
aLista arbol =
    inorder arbol


desdeListaBalanceada : List comparable -> Tree comparable
desdeListaBalanceada lista =
    let
        build l =
            case l of
                [] -> Empty
                _ ->
                    let
                        n = List.length l
                        medio = n // 2
                        izquierda = List.take medio l
                        v = List.drop medio l |> List.head |> Maybe.withDefault (Debug.todo "lista vacía inesperada")
                        derecha = List.drop (medio + 1) l
                    in
                    Node v (build izquierda) (build derecha)
    in
    build (List.sort lista)
