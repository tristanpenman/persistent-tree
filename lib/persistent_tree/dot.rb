require_relative 'node'

module PersistentTree
  ##
  # Methods for dumping the contents of a tree in DOT format
  #
  module Dot
    class << self
      def dump_edges(node, version)
        return [] unless node

        edges = []

        left_child = node.get_left_child(version)
        if left_child
          if node.modified? && node.mod.left
            edges << <<~DOT
              "#{node.object_id}":f3 -> "#{left_child.object_id}":f0
            DOT
          else
            edges << <<~DOT
              "#{node.object_id}":f1 -> "#{left_child.object_id}":f0
            DOT
          end
          edges += dump_edges(left_child, version)
        end

        right_child = node.get_right_child(version)
        if right_child
          if node.modified? && !node.mod.left
            edges << <<~DOT
              "#{node.object_id}":f3 -> "#{right_child.object_id}":f0
            DOT
          else
            edges << <<~DOT
              "#{node.object_id}":f2 -> "#{right_child.object_id}":f0
            DOT
          end
          edges += dump_edges(right_child, version)
        end

        edges
      end

      def dump_node(node, version)
        return [] unless node

        mod = if node.modified?
                "{ #{node.mod.version} | <f3> #{node.mod.left ? 'L' : 'R'} }"
              else
                '{ - | - }'
              end

        nodes = [
          <<~DOT
            "#{node.object_id}" [
              label = "<f0> #{node.value.key} | <f1> L | <f2> R | #{mod}"
              shape = "record"
            ]
          DOT
        ]

        nodes +
          dump_node(node.get_left_child(version), version) +
          dump_node(node.get_right_child(version), version)
      end

      def dump_tree(node, version)
        <<~DOT
          digraph g {
          rankdir="LR"
          #{dump_node(node, version).join("\n")}
          #{dump_edges(node, version).join("\n")}
          }
        DOT
      end
    end
  end
end
