module Main exposing (..)

import Html exposing (Html, text)


main : Html msg
main =
    text "Hello, Elm!"


add : Int -> Int -> Int
add a b =
    a + b


multiply : Int -> Int -> Int
multiply a b =
    a * b


-- Ejercicio 1: Función Potencia
power : Int -> Int -> Int
power a b =
    -- TODO: Implementar función potencia
    if b == 0 then
        1
    else
        a * power a (b - 1)


-- Ejercicio 2: Factorial
factorial : Int -> Int
factorial n =
    -- TODO: Implementar factorial
    0
     if n == 0 then
        1
    else
        n * factorial (n - 1)

-- Ejercicio 3: Fibonacci
fibonacciExponential : Int -> Int
fibonacciExponential n =
    -- TODO: Implementar fibonacci exponencial
    0
    if n == 0 then
        0
    else if n == 1 then
        1
    else
        fibonacciExponential (n - 1) + fibonacciExponential (n - 2)

fibonacciLinear : Int -> Int
fibonacciLinear n =
    -- TODO: Implementar fibonacci lineal con acumuladores
    0
    if n == 0 then
        acc1
    else if n == 1 then
    else
        fibonacciHelper (n - 1) acc2 (acc1 + acc2)


fibonacciHelper : Int -> Int -> Int -> Int
fibonacciHelper n acc1 acc2 =
    -- TODO: Función auxiliar para fibonacci lineal
    0
    if n == 0 then
        acc1
    else
        fibonacciHelper (n - 1) acc2 (acc1 + acc2)

-- Ejercicio 4: Triángulo de Pascal 
pascalTriangle : Int -> Int -> Int
pascalTriangle x y =
    -- TODO: Implementar triángulo de Pascal
    0
    f y == 0 || y == x then
        1
    else
        pascalTriangle (x - 1) (y - 1) + pascalTriangle (x - 1) y


-- Ejercicio 5: Máximo Común Divisor (MCD)
gcd : Int -> Int -> Int
gcd a b =
    -- TODO: Implementar algoritmo euclidiano
    0
    gcd : Int -> Int -> Int
gcd a b =
    if b == 0 then
        a
    else
        gcd b (modBy b a)


-- Ejercicio 6: Contar Dígitos
countDigits : Int -> Int
countDigits n =
    -- TODO: Implementar contador de dígitos
    0

    

-- Ejercicio 7: Suma de Dígitos
sumDigits : Int -> Int
sumDigits n =
    -- TODO: Implementar suma de dígitos
    0


-- Ejercicio 8: Verificar Palíndromo
isPalindrome : Int -> Bool
isPalindrome n =
    -- TODO: Implementar verificador de palíndromo
 

reverseNumber : Int -> Int
reverseNumber n =
    -- TODO: Implementar función para invertir número
    0


reverseHelper : Int -> Int -> Int
reverseHelper n acc =
    -- TODO: Función auxiliar para invertir número
    0
    if n < 10 then 
        acc * 10 + n
    else 
        reverseHelper (n // 10) (acc * 10 + modBy 10 n)

-- Ejercicio 9: Paréntesis Balanceados
isBalanced : String -> Bool
isBalanced str =
    -- TODO: Implementar verificador de paréntesis balanceados
    False


isBalancedHelper : List Char -> Int -> Bool
isBalancedHelper chars counter =
    -- TODO: Función auxiliar para verificar paréntesis balanceados
    Falsen