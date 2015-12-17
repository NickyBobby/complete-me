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

  # index_B_arr[0]== index_A_arr[1]
# iterate through each character of the partial word
# check to see if a link exists from the root to the first letter
# if it exists then go to that node,
# change the node position and send it back to the beginning (recursion)
# you do this until you find either the end of the branch,
# or the end of the partial word,
# then look down the branch for any true flags and return the value(s)

      # if part_word.empty?
      #   until node.link[letter] == letter
      #   return node.value if node.word == true
      #   end
      #   letter = part_word.shift
      # elsif node.link[letter] == letter
      #   search_trie(part_word, node.link[letter])
      # end

  def select

  end

  def populate(word_list)
    word_list.each do |word|
      insert(word)
    end

  end

end




if __FILE__ == $0
completer = CompleteMe.new
dictionary = File.read("/usr/share/dict/words")
completer.populate(dictionary)
p completer.suggest("piz")
# completer.insert("pizza")
# completer.insert("pizzeria")
# completer.insert("apple")
# completer.insert("aardvark")
# completer.insert("android")
# completer.insert("picker")
# p completer.suggest("piz")
# puts completer.root.link
# puts completer.count

# p dictionary
# p completer.suggest("piz")    # => nil
end
# completer.insert("pizzeria")
