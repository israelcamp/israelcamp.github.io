module Jekyll
  module WrapTextFilter
    # Splits `input` into lines of `words_per_line` words, joined with <br>
    def wrapText(input, words_per_line = 50)
      return "" if input.nil?
      words = input.to_s.split(/\s+/)
      lines = words.each_slice(words_per_line).map { |slice| slice.join(" ") }
      lines.join("<br>")
    end
  end
end

Liquid::Template.register_filter(Jekyll::WrapTextFilter)
