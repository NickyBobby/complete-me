require 'pry'

class Node
  attr_accessor :link, :word, :weight, :value

  def initialize( word=false, link={},  weight=Hash.new(0), value="")
    @link = link
    @word = word
    @weight = weight
    @value = value

  end


end


class CompleteMe
  attr_accessor :count
  attr_reader :root

  def initialize
    @root = Node.new
    @count = 0
  end

  def insert(word, node=root, value="")
    @count += 1
    word = word.downcase.chars
    add_word(word, node, value)
  end

  def add_word(word, node, value)
    if word.empty?
      node.value = value
      node.word = true
    else
      letter = word.shift
      value += letter
      if node.link[letter].nil?
        node.link[letter] = Node.new
        add_word(word, node.link[letter], value)
      else
        add_word(word, node.link[letter], value)
      end
    end
  end

  def populate(word_list)
    words = word_list.split("\n")
    words.each do |word|
      insert(word)
    end
  end

  def suggest(part_word, node=root)
    word_chars = part_word.chars
    list = search_trie(word_chars, node)
    sorting_list(part_word, list)
  end

  def select(partial_word, weighted_word)
    word_chars = partial_word.chars
    weighted_list = search_trie(word_chars, node=root)
      weighted_list.each do |node|
        if node.value == weighted_word
          node.weight[partial_word] += 1
        end
      end
      suggest(partial_word, node)
  end

  def search_trie(part_word, node)
    letter = part_word.shift
    if node.link.has_key?(letter)
      search_trie(part_word, node.link[letter])
    else
    list = []
    if node.word == true
      list << node
    end
      search_remaining_nodes(node, list)
    end
  end

  def search_remaining_nodes(node, list)
    node.link.each_value do |node|
      if node.word == true
        list << node
      end
        search_remaining_nodes(node, list)
    end
  list
  end

  def sorting_list(partial_word, nodes_list)
    sorted = nodes_list.sort_by { |n| n.weight[partial_word] * -1 }
    sorted.map {|n| n.value }
  end

end




if __FILE__ == $0
completer = CompleteMe.new
dictionary = File.read("/usr/share/dict/words")
completer.populate(dictionary)
p completer.suggest("piz")
# p completer.suggest("aa")
completer.select("piz", "pizzicato" )
completer.select("pi", "pizza")
p completer.suggest("piz")
p completer.suggest("pi")
end
