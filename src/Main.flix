eff MayContainZero {
    pub def insertZero(): List[Int32]
}

enum Tree[t] {
    case Empty,
    case Leaf(t),
    case Node(Tree[t], t, Tree[t])
}

def sum(tree: Tree[Int32]): Int32 = match tree {
    case Tree.Empty => 0,
    case Tree.Leaf(x) => x,
    case Tree.Node(l, c, r) => sum(l) + c + sum(r)
}

def insert(x: Int32, tree: Tree[Int32]): Tree[Int32] = match (x, tree) {
    case (e, Tree.Empty) =>  Tree.Leaf(e),
    case (e, Tree.Leaf(l)) => if (e < l) Tree.Node(Tree.Leaf(e), l, Tree.Empty) else Tree.Node(Tree.Empty, l, Tree.Leaf(e)),
    case (e, Tree.Node(l, c, r)) => if (e < c) Tree.Node(insert(e, l), c, r) else Tree.Node(l, c, insert(e, r))
}

def treeToListWithEff(t: Tree[Int32]): List[Int32] \ MayContainZero = match t {
    case Tree.Empty => Nil,
    case Tree.Leaf(42) => List.append(42 :: Nil, do MayContainZero.insertZero()),
    case Tree.Leaf(x) => x :: Nil,
    case Tree.Node(l, x, r) => List.append(List.append(treeToListWithEff(l), (x :: Nil)), treeToListWithEff(r))
}

def printTree(t: Tree[Int32]): Unit \ IO = {
    try {
        println(treeToListWithEff(t))
    }  with MayContainZero {
        def insertZero(k) = {
            k(0 :: Nil)     
        }
    }
}

//def main(): Unit \ IO = {
//    let t = insert(42, insert(1, insert(43, insert(40, insert(45, insert(-3, Tree.Empty))))));
//    printTree(t)
//}