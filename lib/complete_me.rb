require 'pry'

class Node
  attr_accessor :link, :word, :weight, :value

  def initialize( word=false, link={},  weight=0, value="")
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

  def suggest(part_word, node=root)
    part_word = part_word.chars
    search_trie(part_word, node)
  end

  def search_trie(part_word, node)
    letter = part_word.shift
    if node.link.has_key?(letter)
      search_trie(part_word, node.link[letter])
    else
    list = []
    if node.word == true
      list << node.value
    end
      search_remaining_nodes(node, list)
    end
  end

  def search_remaining_nodes(node, list)
    node.link.each_value do |node|
      if node.word == true
        list << node.value
      end
        search_remaining_nodes(node, list)
    end
    list
  end

  def select(partial_word, weighted_word)
    partial_word = partial_word.chars
    weighted_list = search_trie(partial_word, node=root)
    if weighted_list.include?(weighted_word)
      weighted_list.each do |word|
        if word == weighted_word
          word.weight += 1
        end
      end
    end
  end

  def populate(word_list)
    words = word_list.split("\n")
    words.each do |w|
      insert(w)
    end
  end

end




if __FILE__ == $0
completer = CompleteMe.new
dictionary = File.read("/usr/share/dict/words")
completer.populate(dictionary)
p completer.suggest("piz")
p completer.suggest("aa")
end
