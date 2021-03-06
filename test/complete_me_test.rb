require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'complete_me'

class NodeTest < Minitest::Test

  def setup

    @node = Node.new
  end

  def test_new_object_gets_created_in_the_Node_class

    assert_equal Node, @node.class
  end

  def test_new_nodes_get_created_with_an_initial_value_of_zero_for_weight

    assert_equal Hash.new(0), @node.weight
  end

  def test_new_nodes_get_created_with_an_initial_value_of_false_for_word_attribute

    assert_equal false, @node.word
  end

  def test_new_nodes_get_created_with_an_empty_had_for_the_initial_value_of_link

    assert_equal true, @node.link.empty?
  end

end

class CompleteMeTest < Minitest::Test

  def setup

    @completion = CompleteMe.new
  end

  def test_root_gets_created_in_the_node_class

    assert_equal Node, @completion.root.class
  end

  def test_new_object_gets_created_in_the_CompleteMe_class

    assert_equal CompleteMe, @completion.class
  end

  def test_word_gets_inserted_to_the_trie_correctly
    @completion.insert("apple")

    assert_equal 1, @completion.count
    assert_equal "apple", @completion.root.link["a"].link["p"].link["p"].link["l"].link["e"].value
  end

  def test_muliple_words_can_be_inserted_into_the_trie_and_adds_to_the_count
    @completion.insert("pizza")
    @completion.insert("pizzeria")

    assert_equal 2, @completion.count
  end

  def test_insert_method_will_accept_a_word_with_a_capital_letter_in_it
    @completion.insert("Pizza")

    assert_equal 1, @completion.count
    assert_equal "pizza", @completion.root.link["p"].link["i"].link["z"].link["z"].link["a"].value
  end

  def test_suggest_returns_an_array_of_words_when_collection_only_has_two_words
    @completion.insert("pizza")
    @completion.insert("pizzeria")

    assert_equal ["pizza", "pizzeria"], @completion.suggest("piz")
  end

  def test_returns_word_when_it_is_the_suggested_word
    @completion.insert("a")
    @completion.insert("an")
    @completion.insert("android")
    @completion.insert("aardvark")
    @completion.insert("aardwolf")

    assert_equal ["android"], @completion.suggest("android")
  end

  def test_returns_suggested_word_along_with_other_words_down_the_branch
    @completion.insert("a")
    @completion.insert("an")
    @completion.insert("android")
    @completion.insert("aardvark")
    @completion.insert("aardwolf")

    assert_equal ["a", "an", "android", "aardvark", "aardwolf"], @completion.suggest("a")
  end

  def test_select_method_returns_weighted_word_first
    @completion.insert("pizza")
    @completion.insert("pizzeria")
    @completion.insert("pizzicato")
    @completion.select("piz", "pizzicato")

    assert_equal ["pizzicato", "pizzeria", "pizza"], @completion.suggest("piz")
  end

  def test_select_method_returns_weighted_word_first_for_muliple_partial_words
    @completion.insert("pizza")
    @completion.insert("pizzeria")
    @completion.insert("pizzicato")
    @completion.select("piz", "pizzicato")
    @completion.select("pi", "pizza")

    assert_equal ["pizzicato", "pizzeria", "pizza"], @completion.suggest("piz")
    assert_equal ["pizza", "pizzeria","pizzicato"], @completion.suggest("pi")
  end

  def test_select_method_returns_weighted_word_for_a_list_of_very_similar_words
    @completion.insert("a")
    @completion.insert("an")
    @completion.insert("android")
    @completion.insert("aardvark")
    @completion.insert("aardwolf")
    @completion.select("a", "aardwolf")
    @completion.select("aa", "aardvark")

    assert_equal ["aardwolf", "android", "an", "aardvark", "a"], @completion.suggest("a")
    assert_equal ["aardvark", "aardwolf"], @completion.suggest("aa")
  end


  def test_correctly_tells_me_how_many_words_are_in_the_dictionary
    dictionary = File.read("/usr/share/dict/words")
    @completion.populate(dictionary)

    assert_equal 235886, @completion.count
  end

  def test_suggest_returns_an_array_of_suggested_words_from_the_dictionary
    dictionary = File.read("/usr/share/dict/words")
    @completion.populate(dictionary)

    assert_equal ["pize", "pizza", "pizzeria", "pizzicato", "pizzle"], @completion.suggest("piz")
  end


end
