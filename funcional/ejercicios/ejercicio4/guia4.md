# Guía de Ejercicios - Pattern Matching y Mónadas con Árboles Binarios

## Introducción

Esta guía presenta ejercicios para practicar **pattern matching** y **mónadas** en Elm, usando **árboles binarios** como estructura de datos principal. Aprenderás a:

- Trabajar con tipos algebraicos y pattern matching
- Manejar operaciones que pueden fallar con `Maybe`
- Proporcionar errores descriptivos con `Result`
- Encadenar operaciones con `andThen` (bind monádico)
- Combinar diferentes mónadas en pipelines de transformación

### Conceptos importantes:

- **Pattern Matching**: Destructurar datos según su forma
- **Maybe**: Representa valores opcionales (`Just valor` o `Nothing`)
- **Result**: Representa operaciones que pueden fallar (`Ok valor` o `Err mensaje`)
- **andThen**: Encadena operaciones monádicas (también conocido como `>>=` o bind)

---

## Parte 0: Definición del Árbol Binario

Antes de comenzar, vamos a definir nuestro tipo de dato árbol binario:

```elm
type Tree a
    = Empty
    | Node a (Tree a) (Tree a)
```

Un árbol puede ser:
- `Empty`: Un árbol vacío (caso base)
- `Node valor izquierdo derecho`: Un nodo con un valor y dos subárboles

### Ejercicios de Construcción

**1. Crear Árboles de Ejemplo**

Creá los siguientes árboles usando la definición anterior:

```elm
-- Un árbol vacío
arbolVacio : Tree Int
arbolVacio = Empty

-- Un árbol con un solo nodo (hoja)
arbolHoja : Tree Int
arbolHoja = Node 5 Empty Empty
-- Ejemplo:     5

-- Un árbol pequeño
arbolPequeno : Tree Int
arbolPequeno =
    Node 3
        (Node 1 Empty Empty)
        (Node 5 Empty Empty)

-- Un árbol mediano
arbolMediano : Tree Int
arbolMediano =
    (Node 10
        (Node 3 Empty Empty)
        (Node 7 Empty Empty)
    )
    (Node 15
        (Node 12 Empty Empty)
        (Node 20 Empty Empty)
    )
 ```   
**2. Es Vacío**

Escribí una función que determine si un árbol está vacío.

```elm
esVacio : Tree a -> Bool
esVacio arbol =
    case arbol of 
        Empty ->
            True

        Node _ _ _ ->
            False
```

**3. Es Hoja**

Escribí una función que determine si un árbol es una hoja (nodo sin hijos).

```elm
esHoja : Tree a -> Bool
esHoja arbol =
    case arbol of
        Node _ Empty Empty ->
            True

        _->
            False
```

---

## Parte 1: Pattern Matching con Árboles

El pattern matching nos permite escribir funciones recursivas de forma clara y concisa.

### Ejercicios Básicos

**4. Tamaño del Árbol**

Contá cuántos nodos tiene un árbol.

```elm
tamaño : Tree a -> Int
tamaño arbol =
    case arbol of
        Empty ->
            0

        Node _ izquierda derecha ->
            1 + tamaño izquierda + tamaño derecha


```

**5. Altura del Árbol**

Calculá la altura de un árbol (la distancia del nodo raíz a la hoja más lejana).

```elm
altura : Tree a -> Int
altura arbol =
    case arbol of
        Empty ->
            0

        Node _ izquierda derecha ->
            1 + max (altura izquierda) (altura derecha)
```

**6. Suma de Valores**

Sumá todos los valores de un árbol de enteros.

```elm
sumarArbol : Tree Int -> Int
sumarArbol arbol =
    case arbol of
        Empty ->
            0

        Node valor izquierda derecha ->
            valor + sumarArbol izquierda + sumarArbol derecha
```

**7. Contiene Valor**

Verificá si un valor existe en el árbol.

```elm
contiene : a -> Tree a -> Bool
contiene valor arbol =
    case arbol of
        Empty ->
            False

        Node x izquierda derecha ->
            if x == valor then
                True
            else
                contiene valor izquierda || contiene valor derecha
```

**8. Contar Hojas**

Contá cuántas hojas tiene un árbol.

```elm
contarHojas : Tree a -> Int
contarHojas arbol =
    case arbol of
        Empty ->
            0

        Node _ Empty Empty ->
            1

        Node _ izquierda derecha ->
            contarHojas izquierda + contarHojas derecha
```

**9. Valor Mínimo (sin Maybe)**

Encontrá el valor mínimo en un árbol. Si el árbol está vacío, devolvé 0.

```elm
minimo : Tree Int -> Int
minimo arbol =
    case arbol of
        Empty ->
            0

        Node valor Empty Empty ->
            valor

        Node valor izquierda derecha ->
            let
                minIzq = minimo izquierda
                minDer = minimo derecha
            in
            List.minimum [ valor, minIzq, minDer ]
                |> Maybe.withDefault valor
```

**10. Valor Máximo (sin Maybe)**

Encontrá el valor máximo en un árbol. Si el árbol está vacío, devolvé 0.

```elm
maximo : Tree Int -> Int
maximo arbol =
    case arbol of
        Empty ->
            0

        Node valor Empty Empty ->
            valor

        Node valor izquierda derecha ->
            let
                maxIzq = maximo izquierda
                maxDer = maximo derecha
            in
            List.maximum [ valor, maxIzq, maxDer ]
                |> Maybe.withDefault valor
```

---

## Parte 2: Introducción a Maybe (Búsquedas que Pueden Fallar)

`Maybe` representa valores opcionales. Es perfecto para búsquedas que pueden no encontrar nada.

```elm
type Maybe a
    = Just a    -- Contiene un valor
    | Nothing   -- No hay valor
```

### Ejercicios con Maybe

**11. Buscar Valor**

Buscá un valor en el árbol. Si existe, devolvé `Just valor`, sino `Nothing`.

```elm
buscar : a -> Tree a -> Maybe a
buscar valor arbol =
    case arbol of
        Empty ->
            Nothing

        Node x izquierda derecha ->
            if x == valor then
                Just x
            else
                case buscar valor izquierda of
                    Just encontrado ->
                        Just encontrado

                    Nothing ->
                        buscar valor derecha
```

**12. Encontrar Mínimo (con Maybe)**

Encontrá el valor mínimo. Si el árbol está vacío, devolvé `Nothing`.

```elm
encontrarMinimo : Tree comparable -> Maybe comparable
encontrarMinimo arbol =
    case arbol of
        Empty ->
            Nothing

        Node valor Empty Empty ->
            Just valor

        Node valor izquierda derecha ->
            let
                minIzq = encontrarMinimo izquierda
                minDer = encontrarMinimo derecha
            in
            case (minIzq, minDer) of
                (Nothing, Nothing) ->
                    Just valor

                (Just a, Nothing) ->
                    Just (min a valor)

                (Nothing, Just b) ->
                    Just (min b valor)

                (Just a, Just b) ->
                    Just (min valor (min a b))
```

**13. Encontrar Máximo (con Maybe)**

Encontrá el valor máximo. Si el árbol está vacío, devolvé `Nothing`.

```elm
encontrarMaximo : Tree comparable -> Maybe comparable
encontrarMaximo arbol =
    case arbol of
        Empty ->
            Nothing

        Node valor Empty Empty ->
            Just valor

        Node valor izquierda derecha ->
            let
                maxIzq = encontrarMaximo izquierda
                maxDer = encontrarMaximo derecha
            in
            case (maxIzq, maxDer) of
                (Nothing, Nothing) ->
                    Just valor

                (Just a, Nothing) ->
                    Just (max a valor)

                (Nothing, Just b) ->
                    Just (max b valor)

                (Just a, Just b) ->
                    Just (max valor (max a b))
```

**14. Buscar Por Predicado**

Buscá el primer valor que satisfaga un predicado.

```elm
buscarPor : (a -> Bool) -> Tree a -> Maybe a
buscarPor predicado arbol =
    case arbol of
        Empty ->
            Nothing

        Node valor izquierda derecha ->
            if predicado valor then
                Just valor
            else
                case buscarPor predicado izquierda of
                    Just encontrado ->
                        Just encontrado

                    Nothing ->
                        buscarPor predicado derecha
```

**15. Obtener Valor de Raíz**

Obtené el valor de la raíz del árbol.

```elm
raiz : Tree a -> Maybe a
raiz arbol =
    case arbol of
        Empty ->
            Nothing

        Node valor _ _ ->
            Just valor
```

### Encadenando Operaciones con andThen

`andThen` (o `Maybe.andThen`) permite encadenar operaciones que pueden fallar.

**Firma**: `andThen : (a -> Maybe b) -> Maybe a -> Maybe b`

**16. Obtener Hijo Izquierdo**

Escribí funciones para obtener el subárbol izquierdo y derecho.

```elm
hijoIzquierdo : Tree a -> Maybe (Tree a)
hijoIzquierdo arbol =
    case arbol of
        Empty ->
            Nothing

        Node _ izquierda _ ->
            Just izquierda

hijoDerecho : Tree a -> Maybe (Tree a)
hijoDerecho arbol =
    case arbol of
        Empty ->
            Nothing

            Node _ _ derecha ->
            Just derecha
```

**17. Obtener Nieto**

Usá `andThen` para obtener el hijo izquierdo del hijo izquierdo.

```elm
nietoIzquierdoIzquierdo : Tree a -> Maybe (Tree a)
nietoIzquierdoIzquierdo arbol =
    hijoIzquierdo arbol
        |> Maybe.andThen hijoIzquierdo
```

**18. Buscar en Profundidad**

Buscá un valor en el árbol y luego buscá otro valor en el subárbol encontrado.

```elm
-- Primero implementá esta función auxiliar:
obtenerSubarbol : a -> Tree a -> Maybe (Tree a)
obtenerSubarbol valor arbol =
    case arbol of
        Empty ->
            Nothing

        Node x izquierda derecha ->
            if x == valor then
                Just arbol
            else
                case obtenerSubarbol valor izquierda of
                    Just sub ->
                        Just sub

                    Nothing ->
                        obtenerSubarbol valor derecha


-- Luego úsala para implementar:
buscarEnSubarbol : a -> a -> Tree a -> Maybe a
buscarEnSubarbol valor1 valor2 arbol =
    obtenerSubarbol valor1 arbol
        |> Maybe.andThen (buscar valor2)
```

---

## Parte 3: Result para Validaciones con Errores Descriptivos

`Result` es como `Maybe`, pero cuando falla te dice **por qué**.

```elm
type Result error value
    = Ok value           -- Operación exitosa
    | Err error          -- Operación falló con un error
```

### Ejercicios con Result

**19. Validar No Vacío**

Verificá que un árbol no esté vacío. Si está vacío, devolvé un error.

```elm
validarNoVacio : Tree a -> Result String (Tree a)
validarNoVacio arbol =
    case arbol of
        Empty ->
            Err "El árbol está vacío"

        _ ->
            Ok arbol
```

**20. Obtener Raíz con Error**

Obtené la raíz del árbol. Si está vacío, devolvé un mensaje de error.

```elm
obtenerRaiz : Tree a -> Result String a
obtenerRaiz arbol =
    case arbol of
        Empty ->
            Err "No se puede obtener la raíz de un árbol vacío"

        Node valor _ _ ->
            Ok valor
```

**21. Dividir en Valor Raíz y Subárboles**

Dividí un árbol en su valor raíz y sus dos subárboles.

```elm
dividir : Tree a -> Result String (a, Tree a, Tree a)
dividir arbol =
    case arbol of
        Empty ->
            Err "No se puede dividir un árbol vacío"

        Node valor izquierda derecha ->
            Ok (valor, izquierda, derecha)
```

**22. Obtener Mínimo con Error**

Encontrá el mínimo, pero con un mensaje de error descriptivo si falla.

```elm
obtenerMinimo : Tree comparable -> Result String comparable
obtenerMinimo arbol =
    case arbol of
        Empty ->
            Err "No hay mínimo en un árbol vacío"

        Node valor Empty Empty ->
            Ok valor

        Node valor izquierda derecha ->
            let
                minIzq = obtenerMinimo izquierda
                minDer = obtenerMinimo derecha
            in
            case (minIzq, minDer) of
                (Err _, Err _) ->
                    Ok valor

                (Ok a, Err _) ->
                    Ok (min a valor)

                (Err _, Ok b) ->
                    Ok (min b valor)

                (Ok a, Ok b) ->
                    Ok (min valor (min a b)
```

### Árbol Binario de Búsqueda (BST)

En un BST:
- Todos los valores del subárbol izquierdo son **menores** que la raíz
- Todos los valores del subárbol derecho son **mayores** que la raíz

**23. Verificar si es BST**

Verificá si un árbol es un BST válido.

```elm
esBST : Tree comparable -> Bool
esBST arbol =
    case arbol of
        Empty ->
            True

        Node valor izquierda derecha ->
            let
                menorQueTodos =
                    case encontrarMaximo izquierda of
                        Just maxIzq ->
                            maxIzq < valor

                        Nothing ->
                            True

                mayorQueTodos =
                    case encontrarMinimo derecha of
                        Just minDer ->
                            valor < minDer

                        Nothing ->
                            True
            in
            menorQueTodos
                && mayorQueTodos
                && esBST izquierda
                && esBST derecha
```

**24. Insertar en BST**

Insertá un valor en un BST. Si el valor ya existe, devolvé un error.

```elm
insertarBST : comparable -> Tree comparable -> Result String (Tree comparable)
insertarBST valor arbol =
    case arbol of
        Empty ->
            Ok (Node valor Empty Empty)

        Node x izquierda derecha ->
            if valor == x then
                Err ("El valor " ++ String.fromInt valor ++ " ya existe en el árbol")

            else if valor < x then
                case insertarBST valor izquierda of
                    Ok nuevoIzq ->
                        Ok (Node x nuevoIzq derecha)

                    Err msg ->
                        Err msg

            else
                case insertarBST valor derecha of
                    Ok nuevoDer ->
                        Ok (Node x izquierda nuevoDer)

                    Err msg ->
                        Err msg
```

**25. Buscar en BST**

Buscá un valor en un BST de forma eficiente. Devolvé `Result` con error descriptivo.

```elm
buscarEnBST : comparable -> Tree comparable -> Result String comparable
buscarEnBST valor arbol =
    case arbol of
        Empty ->
            Err ("El valor " ++ String.fromInt valor ++ " no se encuentra en el árbol")

        Node x izquierda derecha ->
            if valor == x then
                Ok x

            else if valor < x then
                buscarEnBST valor izquierda

            else
                buscarEnBST valor derecha
```

**26. Validar BST con Result**

Verificá si un árbol es un BST válido. Si no lo es, explicá por qué.

```elm
validarBST : Tree comparable -> Result String (Tree comparable)
validarBST arbol =
    case arbol of
        Empty ->
            Ok Empty

        Node valor izquierda derecha ->
            case validarBST izquierda of
                Err msg ->
                    Err msg

                Ok _ ->
                    case validarBST derecha of
                        Err msg ->
                            Err msg

                        Ok _ ->
                            case (encontrarMaximo izquierda, encontrarMinimo derecha) of
                                (Just maxIzq, _) if maxIzq >= valor ->
                                    Err ("Nodo con valor " ++ String.fromInt maxIzq
                                         ++ " viola la propiedad BST: debe ser menor que "
                                         ++ String.fromInt valor)

                                (_, Just minDer) if minDer <= valor ->
                                    Err ("Nodo con valor " ++ String.fromInt minDer
                                         ++ " viola la propiedad BST: debe ser mayor que "
                                         ++ String.fromInt valor)

                                _ ->
                                    Ok arbol
```

---

## Parte 4: Combinando Maybe y Result

A veces necesitamos convertir entre `Maybe` y `Result`, o combinar operaciones de ambas.

### Conversiones

**27. Maybe a Result**

Convertí un `Maybe` a `Result`, proporcionando un mensaje de error.

```elm
maybeAResult : String -> Maybe a -> Result String a
maybeAResult mensaje valor =
    case valor of
        Nothing ->
            Err mensaje

        Just x ->
            Ok x
```

**28. Result a Maybe**

Convertí un `Result` a `Maybe`, descartando el mensaje de error.

```elm
resultAMaybe : Result error value -> Maybe value
resultAMaybe resultado =
    case resultado of
        Err _ ->
            Nothing

        Ok valor ->
            Just valor
```

### Pipelines de Transformación

**29. Buscar y Validar**

Buscá un valor en un árbol y luego validá que sea positivo.

```elm
buscarPositivo : Int -> Tree Int -> Result String Int
buscarPositivo valor arbol =
    buscar valor arbol
        |> maybeAResult ("El valor " ++ String.fromInt valor ++ " no se encuentra en el árbol")
        |> Result.andThen validarPositivo


validarPositivo : Int -> Result String Int
validarPositivo n =
    if n > 0 then
        Ok n
    else
        Err ("El valor " ++ String.fromInt n ++ " no es positivo")
```

**30. Pipeline de Validaciones**

Realizá múltiples validaciones en secuencia sobre un árbol.

```elm
validarArbol : Tree Int -> Result String (Tree Int)
validarArbol arbol =
    validarNoVacio arbol
        |> Result.andThen validarBST
        |> Result.andThen validarPositivos
```

**31. Encadenar Búsquedas**

Buscá un valor, y si lo encontrás, usá ese valor para buscar en otro árbol.

```elm
buscarEnDosArboles : Int -> Tree Int -> Tree Int -> Result String Int
buscarEnDosArboles valor arbol1 arbol2 =
    buscar valor arbol1
        |> maybeAResult ("El valor " ++ String.fromInt valor ++ " no se encuentra en el primer árbol")
        |> Result.andThen (\encontrado ->
            buscar encontrado arbol2
                |> maybeAResult ("El valor " ++ String.fromInt encontrado ++ " no se encuentra en el segundo árbol")
        )
```

---

## Parte 5: Desafíos Avanzados

### Recorridos (Traversals)

Los recorridos visitan todos los nodos en un orden específico.

**32. Recorrido Inorder**

Recorrido: izquierdo → raíz → derecho (en BST da valores ordenados).

```elm
inorder : Tree a -> List a
inorder arbol =
    case arbol of
        Empty ->
            []

        Node valor izquierda derecha ->
            inorder izquierda ++ [ valor ] ++ inorder derecha
```

**33. Recorrido Preorder**

Recorrido: raíz → izquierdo → derecho.

```elm
preorder : Tree a -> List a
preorder arbol =
    case arbol of
        Empty ->
            []

        Node valor izquierda derecha ->
            [ valor ] ++ preorder izquierda ++ preorder derecha
```

**34. Recorrido Postorder**

Recorrido: izquierdo → derecho → raíz.

```elm
postorder : Tree a -> List a
postorder arbol =
    case arbol of
        Empty ->
            []

        Node valor izquierda derecha ->
            postorder izquierda ++ postorder derecha ++ [ valor ]
```

### Transformaciones

**35. Map sobre Árbol**

Aplicá una función a todos los valores del árbol.

```elm
mapArbol : (a -> b) -> Tree a -> Tree b
mapArbol f arbol =
    case arbol of
        Empty ->
            Empty

        Node valor izquierda derecha ->
            Node (f valor) (mapArbol f izquierda) (mapArbol f derecha)
```

**36. Filter sobre Árbol**

Mantené solo los nodos que satisfagan un predicado. ¡Cuidado! Esto puede romper la estructura BST.

```elm
filterArbol : (a -> Bool) -> Tree a -> Tree a
filterArbol predicado arbol =
    case arbol of
        Empty ->
            Empty

        Node valor izquierda derecha ->
            let
                izquierdaFiltrada = filterArbol predicado izquierda
                derechaFiltrada = filterArbol predicado derecha
            in
            if predicado valor then
                Node valor izquierdaFiltrada derechaFiltrada
            else
                -- Si el valor no cumple, unimos los subárboles filtrados
                combinar izquierdaFiltrada derechaFiltrada


combinar : Tree a -> Tree a -> Tree a
combinar izquierda derecha =
    case izquierda of
        Empty ->
            derecha

        Node valor izq der ->
            Node valor izq (combinar der derecha)
```

**37. Fold sobre Árbol**

Implementá fold para árboles (similar a List.foldl).

```elm
foldArbol : (a -> b -> b) -> b -> Tree a -> b
foldArbol f acumulador arbol =
    case arbol of
        Empty ->
            acumulador

        Node valor izquierda derecha ->
            let
                acumuladorIzq = foldArbol f acumulador izquierda
                acumuladorConValor = f valor acumuladorIzq
            in
            foldArbol f acumuladorConValor derecha
```

### BST Avanzado

**38. Eliminar de BST**

Eliminá un valor de un BST. Esta es una operación compleja que requiere manejar 3 casos:
1. Nodo es hoja
2. Nodo tiene un hijo
3. Nodo tiene dos hijos (reemplazar con el mínimo del subárbol derecho)

```elm
eliminarBST : comparable -> Tree comparable -> Result String (Tree comparable)
-- Ejemplo: eliminarBST 1 arbolPequeno == Ok (Node 3 Empty (Node 5 Empty Empty))
-- Ejemplo: eliminarBST 10 arbolPequeno == Err "El valor 10 no existe en el árbol"
```

**39. Construir BST desde Lista**

Creá un BST insertando todos los elementos de una lista.

```elm
desdeListaBST : List comparable -> Result String (Tree comparable)
-- Si hay valores duplicados, retorna un error
-- Ejemplo: desdeListaBST [3, 1, 5] == Ok arbolPequeno
-- Ejemplo: desdeListaBST [3, 1, 3] == Err "Valor duplicado: 3"
```

**40. Verificar Balance**

Un árbol está balanceado si la diferencia de altura entre subárboles no supera 1.

```elm
estaBalanceado : Tree a -> Bool
-- Ejemplo: estaBalanceado arbolPequeno == True
```

**41. Balancear BST**

Convertí un BST desbalanceado en uno balanceado.

```elm
balancear : Tree comparable -> Tree comparable
-- Pista: Convierte a lista ordenada (inorder), luego reconstruye balanceado
-- desde el elemento medio
```

### Path Finding

**42. Camino a un Valor**

Encontrá el camino desde la raíz hasta un valor (lista de direcciones).

```elm
type Direccion = Izquierda | Derecha

encontrarCamino : a -> Tree a -> Result String (List Direccion)
-- Ejemplo: encontrarCamino 1 arbolPequeno == Ok [Izquierda]
-- Ejemplo: encontrarCamino 5 arbolPequeno == Ok [Derecha]
-- Ejemplo: encontrarCamino 10 arbolPequeno == Err "El valor 10 no existe en el árbol"
```

**43. Seguir Camino**

Dado un camino, llegá al nodo correspondiente.

```elm
seguirCamino : List Direccion -> Tree a -> Result String a
-- Ejemplo: seguirCamino [Izquierda] arbolPequeno == Ok 1
-- Ejemplo: seguirCamino [Izquierda, Izquierda] arbolPequeno == Err "Camino inválido: no hay hijo izquierdo"
```

**44. Ancestro Común Más Cercano**

Encontrá el ancestro común más cercano de dos valores en un BST.

```elm
ancestroComun : comparable -> comparable -> Tree comparable -> Result String comparable
-- Ejemplo: Para el árbol arbolMediano:
--        10
--       /  \
--      5    15
--     / \   / \
--    3  7 12  20
-- ancestroComun 3 7 arbolMediano == Ok 5
-- ancestroComun 3 12 arbolMediano == Ok 10
```

---

## Parte 6: Desafío Final - Sistema de Árbol con Todo

**45. Sistema Completo de BST**

Implementá un módulo completo con todas las operaciones de BST, cada una usando el tipo de retorno apropiado (`Bool`, `Maybe`, o `Result`).

```elm
-- Operaciones que retornan Bool
esBSTValido : Tree comparable -> Bool
estaBalanceado : Tree comparable -> Bool
contiene : comparable -> Tree comparable -> Bool

-- Operaciones que retornan Maybe
buscar : comparable -> Tree comparable -> Maybe comparable
encontrarMinimo : Tree comparable -> Maybe comparable
encontrarMaximo : Tree comparable -> Maybe comparable

-- Operaciones que retornan Result
insertar : comparable -> Tree comparable -> Result String (Tree comparable)
eliminar : comparable -> Tree comparable -> Result String (Tree comparable)
validar : Tree comparable -> Result String (Tree comparable)
obtenerEnPosicion : Int -> Tree comparable -> Result String comparable  -- n-ésimo elemento en inorder

-- Operaciones de transformación
map : (a -> b) -> Tree a -> Tree b
filter : (a -> Bool) -> Tree a -> Tree a
fold : (a -> b -> b) -> b -> Tree a -> b

-- Conversiones
aLista : Tree a -> List a  -- inorder
desdeListaBalanceada : List comparable -> Tree comparable
```

---

## Bonus: Reflexión sobre Mónadas

### Preguntas para pensar:

1. **¿Por qué usar Maybe en lugar de devolver 0 o ""?**
   - Compará `buscar` que retorna `Maybe` vs la versión que retorna 0 si no encuentra

2. **¿Cuándo usar Maybe vs Result?**
   - ¿En qué casos preferirías un mensaje de error descriptivo?

3. **¿Qué ventaja tiene andThen?**
   - Escribí código que busque un valor, luego busque en su subárbol, usando:
     - a) Pattern matching manual con case
     - b) andThen
   - ¿Cuál es más limpio?

4. **Composición de validaciones**
   - Si tenés 5 validaciones que pueden fallar, ¿cómo las encadenarías con Result?

---

## Recursos Adicionales

### Funciones Útiles de la Biblioteca Estándar

```elm
-- Maybe
Maybe.map : (a -> b) -> Maybe a -> Maybe b
Maybe.andThen : (a -> Maybe b) -> Maybe a -> Maybe b
Maybe.withDefault : a -> Maybe a -> a

-- Result
Result.map : (a -> b) -> Result x a -> Result x b
Result.andThen : (a -> Result x b) -> Result x a -> Result x b
Result.withDefault : a -> Result x a -> a
Result.mapError : (x -> y) -> Result x a -> Result y a
```

### Patrón de Uso Común

```elm
-- Encadenar operaciones con pipeline
obtenerYValidar : Tree Int -> Result String Int
obtenerYValidar arbol =
    obtenerRaiz arbol
        |> Result.andThen (\valor ->
            if valor > 0 then
                Ok valor
            else
                Err "El valor debe ser positivo"
           )
        |> Result.andThen (\valor ->
            if valor < 100 then
                Ok valor
            else
                Err "El valor debe ser menor que 100"
           )
```

¡Buena suerte con los ejercicios!
