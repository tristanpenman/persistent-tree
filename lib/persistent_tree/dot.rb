require_relative 'node'

module PersistentTree
  ##
  # Methods for dumping the contents of a tree in DOT format
  #
  module Dot
    class << self
      def dump_edges(node, version, complete)
        return [] unless node

        edges = []

        actual_left_child = node.get_left_child(version)
        if actual_left_child
          if node.modified? && node.mod_left?
            edges << <<~DOT
              "#{node.object_id}":f3 -> "#{actual_left_child.object_id}":f0
            DOT
          else
            edges << <<~DOT
              "#{node.object_id}":f1 -> "#{actual_left_child.object_id}":f0
            DOT
          end
          edges += dump_edges(actual_left_child, version, complete)
        end

        actual_right_child = node.get_right_child(version)
        if actual_right_child
          if node.modified? && !node.mod_left?
            edges << <<~DOT
              "#{node.object_id}":f3 -> "#{actual_right_child.object_id}":f0
            DOT
          else
            edges << <<~DOT
              "#{node.object_id}":f2 -> "#{actual_right_child.object_id}":f0
            DOT
          end
          edges += dump_edges(actual_right_child, version, complete)
        end

        if complete
          if !node.original_left_child.nil? && node.original_left_child != actual_left_child
            edges << <<~DOT
              "#{node.object_id}":f1 -> "#{node.original_left_child.object_id}":f0
            DOT
          end
          if !node.original_right_child.nil? && node.original_right_child != actual_right_child
            edges << <<~DOT
              "#{node.object_id}":f2 -> "#{node.original_right_child.object_id}":f0
            DOT
          end
        end

        edges
      end

      def dump_node(node, version, complete)
        return [] unless node

        mod = if node.modified?
                "{ #{node.mod_version} | <f3> #{node.mod_left? ? 'L' : 'R'} }"
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

        actual_left_child = node.get_left_child(version)
        nodes += dump_node(actual_left_child, version, complete)

        actual_right_child = node.get_right_child(version)
        nodes += dump_node(actual_right_child, version, complete)

        if complete
          if !node.original_left_child.nil? && node.original_left_child != actual_left_child
            nodes += dump_node(node.original_left_child, version, complete)
          end
          if !node.original_right_child.nil? && node.original_right_child != actual_right_child
            nodes += dump_node(node.original_right_child, version, complete)
          end
        end

        nodes
      end

      def dump_tree(root, version, complete)
        <<~DOT
          digraph g {
          rankdir="LR"
          #{dump_node(root, version, complete).join("\n")}
          #{dump_edges(root, version, complete).join("\n")}
          }
        DOT
      end
    end
  end
end
