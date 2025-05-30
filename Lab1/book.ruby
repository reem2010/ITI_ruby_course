require 'json'

class Invrtory
  def initialize    
  end

  def add_book(title, auther , isbn)
    File.open('books.txt', 'a') do |file|
      search_res = search_by_isbn(isbn)
      puts search_res
      if(!search_res.nil?)
        books = read_books()
        old_book_idx = books.find_index(search_res)
        books[old_book_idx] = "#{title},#{auther},#{isbn},#{search_res.split(",")[3].to_i + 1}"
        save(books)
      else
        file.puts "#{title},#{auther},#{isbn},1\n"
      end
    end
  end
  def remove_book(isbn)
    if(File.file?("books.txt"))
      lines = read_books().select{|line| line.split(",")[2] != isbn}
      save lines
    else
      puts "\nthere is no books to delete"
    end
  end
  def list_books()
    if(File.file?("books.txt"))
      lines = read_books()
      lines.each do |line|
        print_book(line)
    
      end
    else
      puts "\nthere is no books to show"
    end
  end
  def sort_books()
    if(File.file?("books.txt"))
      lines = read_books()
      sorted = lines.sort_by{ |line| line.split(',')[2].to_i }
      save(sorted)
      
    else
      puts "\nthere is no books to show"
    end
  end
  def search_by_isbn(value)
    lines = read_books()
    output = lines.find do |line|
      line.split(",")[2]==value
    end
    return output

  end
  def search_by_name(value)
    lines = read_books()
    output = lines.select{|line| line.split(",")[0] == value}
    return output

  end
  def search_by_author(value)
    lines = read_books()
    output = lines.select{|line| line.split(",")[1] == value}
    return output

  end

  def save(data)
    File.write('books.txt', data.join("\n")+("\n"))
  end

  def read_books()
    File.read('books.txt').split
  end

  def print_book(book)
    # books.each do |line|
    data = book.split(',')
    puts "title: #{data[0]}, author: #{data[1]}, isbn: #{data[2]}, count: #{data[3]}"
    # end
  end

end


obj = Invrtory.new 

obj.sort_books

while true
  puts "\nYour books engine\n1-Enter 1 to add new book\n2-Enter 2 to remove book\n3-Enter 3 to list all books\n4-Enter 4 to sort\n5-Enter 5 to search by isbn\n6-Enter 6 to search by name\n7-Enter 7 to search by author\n8- Enter 8 to exit"
  print "\nEnter your choice: "
  choice = gets.chomp
  case choice
  when "1"
    print "Enter the book name: "
    name = gets.chomp
    print "Enter the book author: "
    author = gets.chomp
    print "Enter the book isbn: "
    isbn = gets.chomp
    if name.empty? || author.empty? || isbn.empty?
      puts "inputs cannot be empty"
    else
      obj.add_book(name, author, isbn)
    end    
  when "2"
    print "Enter the book isbn: "
    isbn = gets.chomp
    if isbn.empty?
      puts "isbn cannot be empty"
    else
      obj.remove_book isbn
    end
  when "3"
    obj.list_books
  when "4"
    obj.sort_books
  when "5"
    print "Enter the isbn the book: "
    value = gets.chomp
    if value.empty?
      puts "isbn cannot be empty"
    else
      output = obj.search_by_isbn value
      obj.print_book output
    end 
   
  when "6"
    print "Enter the name of the book: "
    value = gets.chomp
    if value.empty?
      puts "name cannot be empty"
    else
      books = obj.search_by_name value
      books.each do |line|
        obj.print_book line
      end
    end 
   
  when "7"
    print "Enter the author of the book: "
    value = gets.chomp
    if value.empty?
      puts "author cannot be empty"
    else
      books = obj.search_by_author value
      books.each do |line|
        obj.print_book line
      end
    end   

  when "8"
    break

  end
  
end