def main(): Unit \ IO = {
    println("Hello, World!");
    println(twosum(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: Nil, 6))
}