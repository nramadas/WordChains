class WordChain
  def initialize(start, target, dictionary_file = "dictionary.txt")
    @start, @target = start, target
    @root = WordNode.new(@start, nil)
    @dictionary = load_dictionary(dictionary_file)
    safety
  end

  def adjacent_words(word)
    possibles = []

    word.split('').each_with_index do |char, index|
      regex = word.dup
      regex[index] = "[^#{char}]"
      possibles += @dictionary.select { |w| w.match(Regexp.new(regex)) }
    end
    possibles
  end

  def run
    queue = [@root]
    checked_words = []

    while word = queue.shift
      if word.value==@target
        print_parent(word)
        return
      end

      checked_words << word.value

      children = adjacent_words(word.value)
      children.select! {|w| !checked_words.include?(w)}
      queue.each do |w|
        children.delete_if { |child| w.value==child }
      end

      queue += children.map { |child| WordNode.new(child, word)}
    end

    puts "Word chain not found"
  end

  def print_parent(word)
    print_parent(word.parent) unless word.parent.nil?
    puts word.value
  end

  def load_dictionary(filename)
    dictionary = File.readlines(filename).map { |word| word.chomp.downcase }
    dictionary.select { |word| word.length == @target.length }
  end

  def safety
    raise ArgumentError.new("This will never work.") if @start.length != @target.length
    raise ArgumentError.new("#{@start} is not a real word") unless @dictionary.include?(@start)
    raise ArgumentError.new("#{@target} is not a real word") unless @dictionary.include?(@target)
  end
end

class WordNode
  attr_reader :value, :parent

  def initialize(value, parent)
    @value, @parent = value, parent
  end
end