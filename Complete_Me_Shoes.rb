require_relative './lib/complete_me'

Shoes.app {
  complete_me = CompleteMe.new
  dictionary = File.read('/usr/share/dict/words')
  complete_me.populate(dictionary)


  @stack = stack( margin: 20){
    @title = para 'Complete Me'
    # @title.style font: "Impact"
    @edit = edit_line
    @push_me = button "Use and remember"
    @suggestion1 = edit_line
    @suggestion2 = edit_line
    @suggestion3 = edit_line

    @suggestions = para ''

    flow do
    @edit.change() do
      if @edit.text.length <2
        @suggestion1.text = ''
        @suggestion2.text = ''
        @suggestion3.text = ''
        @suggestions.text = ''
        # @s_line.text = 'bananas'
      else
          words = complete_me.suggest(@edit.text).join(", ")
          @suggestion1.text = words.split(", ")[0]
          @suggestion2.text =words.split(", ")[1]
          @suggestion2.style font: "Verdana"
          @suggestion3.text =words.split(", ")[2]
          @suggestions.text = words
      end
    end

    @push_me.click do
      @edit.text.chars.length.times do |count|
        complete_me.select(@edit.text[0..count],@edit.text)
      end
    end
    end
  # end
  }

  @stack.style font: 'Verdana'







}






# require_relative './lib/complete_me'
#
# completer = CompleteMe.new
#
# # dictionary = File.read("/usr/share/dict/words")
# dictionary = File.read("./complete_me_spec_harness/test/medium.txt")
# completer.populate(dictionary)
#
#
# Shoes.app(title: "Complete-Me") do
#   stack :margin => 10 do
#     @edit_box = edit_box do |e|
#       array_of_choices = completer.suggest(@edit.text)
#       @copy_box.text = array_of_choices.join("\n")
#       @para.text = @edit.text
#     end
#     # @copy_box.text = para "Type in your word, please"
#   end
# end
