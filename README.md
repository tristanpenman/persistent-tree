# Persistent Tree

The goal of this gem is to provide a Partially-Persistent Tree implementation for Ruby. A Partially-Persistent Tree can be used to efficiently maintain and access previous versions of tree-based data structures, such as Maps and Sets.

This work is based on Okasaki's thesis *[Purely Functional Data Structures](http://www.cs.cmu.edu/~rwh/theses/okasaki.pdf)* and lectures available online for the MIT *[Advanced Data Structures](https://courses.csail.mit.edu/6.851/)* course.

## Design

The `PersistentTree::Map` class provides an interface that is designed to mimic Ruby's built-in Hash class. That is to say that using a `PersistentTree::Map` in place of a Hash should be completely unsurprising.

As a Partially-Persistent data structure, each update to a Map results in a new version of the Map being spawned using an approach that is memory efficient relative to the number of key-value pairs in the Map. Previous versions of a Map are accessible through read-only 'views' of the data structure.

A `PersistentTree::Map` object provides a method called 'version' that, when called with no arguments, returns the current version. When called with one argument (a version number), it will return a view of the Map at that version.

A user of this library might use it like so:

    m = PersistentTree::Map.new   # Create a new map
    m.version                     # Returns current version number (0)
    m['k'] = 'v'                  # Returns stored value ('v')
    m.version                     # Returns current version number (1)
    m['k']                        # Returns stored value ('v')
    m.version(0)                  # Returns a read-only view of version 0
    m.version(0)['k']             # Returns nil (default value)
    m.version(0).fetch('k')       # Raises KeyError
    m.store('k', 'w')             # Returns stored value ('w')
    m.version(1).fetch('k')       # Returns stored value in version 1 ('v')

## Shortcomings

This gem is still very much a work-in-progress. Just off the top of my head, any user of this gem should be aware of the following limitations and shortcomings:

* Deletion of key-value pairs is not supported - at least not in a way that will lead to new versions of the map being created
* Performance is currently unmeasured
* RSpec tests are provided, but coverage is weak for the underlying Tree class
* No form of fuzzing has been conducted, so input validation should be considered untested

## Graphviz

The example script in [bin/example](bin/example) shows how the library can be used to visualise the persistent tree data structure. The script adds the letters 'a' to 'n' to a tree, in random order. After each addition, the tree representing the latest version is dumped to a file in the `tmp` directory. These are written in DOT format, and can be converted to PNG or PDF using `dot`:

    dot -T pdf ./tmp/v14.dot > ./tmp/v14.pdf
    dot -T png ./tmp/v14.dot > ./tmp/v14.png

An example is shown here:

![Graphviz Example](example.png)

There is also a corresponding [example.pdf](./example.pdf).

The way to interpret this is that the first field in a record is a node's key. After that are its left and right children. And the last field represents a 'mod' applied to that node. If the node has been modified, it shows the version corresponding to the modification, as well as the updated child pointer (either left or right).

### Step-by-step: Two Nodes

Here's how to read the diagram, step-by-step.

When we first add a node to the tree (e.g. with value 'B'), it looks like this:

             ┌────(1)────┐
    Root ───►│ Val = 'B' │
    (v1)     ├───────────┤
             │  L = nil  │
             ├───────────┤
             │  R = nil  │
             ├─────┬─────┤
             │  -  │  /  │
             └─────┴─────┘

The root (at version 1) points to the new node, and that's the entire tree. The `L` and `R` pointers for the node are both nil, because it has no children in version 1.

When we add the value 'B' to the tree, this is what the tree looks like:

             ┌────(1)────┐
    Root ───►│ Val = 'B' │
    (v2)     ├───────────┤
             │  L = nil  │
             ├───────────┤
             │  R = nil  │
             ├─────┬─────┤    ┌────(2)────┐
             │  2  │  R  ├───►│ Val = 'C' │
             └─────┴─────┘    ├───────────┤
                              │     L     │
                              ├───────────┤
                              │     R     │
                              ├─────┬─────┤
                              │  -  │  -  │
                              └─────┴─────┘

The root still points at the original 'B' node. But now the 'B' node contains a modification. The modification says that, in version 2 of this node, it now has a right child (R), that points to node 'C'.

If we wanted to query version 1 of the tree, we would still begin at the root. However we would only traverse node 'B', stopping when we see that it contains a modification for version 2.

If instead we queried version 2 of the tree, we would traverse the modification.

### Step-by-step: New Root

Now we add another node, 'A', which would become the left child of 'B'.

Node 'B' already contains a modification, so we cannot add another one. Instead, we create a _new_ node 'B', containing both pointers. The result is version 3 of the tree:

             ┌────(3)────┐
    Root ───►│ Val = 'B' │
    (v3)     ├───────────┤                     ┌────(3)────┐
             │  L = ...  ├────────────────────►│ Val = 'A' │
             ├───────────┤    ┌────(2)────┐    ├───────────┤
             │  R = ...  ├───►│ Val = 'C' │    │  L = nil  │
             ├─────┬─────┤    ├───────────┤    ├───────────┤
             │  -  │  /  │    │  L = nil  │    │  R = nil  │
             └─────┴─────┘    ├───────────┤    ├─────┬─────┤
                              │  R = nil  │    │  -  │  /  │
                              ├─────┬─────┤    └─────┴─────┘
                              │  -  │  /  │
                              └─────┴─────┘

The new version of node 'B', created for version 3, no longer contains any modifications. Instead, it has both L and R pointers set from its time of creation.

## License

This code is licensed under the MIT License.

See the LICENSE file for more information.
