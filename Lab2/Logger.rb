require 'time'
module Logger
  def log_info(msg)
    File.open('app.logs', 'a') do |file|
     file.puts("#{Time.now.iso8601} -- info -- #{msg}")
    end
  end

  def log_warning(msg)
    File.open('app.logs', 'a') do |file|
      file.puts("#{Time.now.iso8601} -- warning -- #{msg}")
     end
  end
  def log_error(msg)
    File.open('app.logs', 'a') do |file|
      file.puts("#{Time.now.iso8601} -- error -- #{msg}")
     end
  end
end

class User
  attr_accessor :name, :balance
  def initialize (name, balance)
    @name = name
    @balance = balance    
  end
end

class Transaction
  attr_reader :user, :value
  def initialize (user, value)
    @user = user
    @value = value    
  end
end

class Bank
  def initialize 
    raise "Abstract class"   
  end

  def process_transactions (trans, &block)
    raise "Abstract mathod"    
  end
end

class CBABank < Bank
  include Logger
  @@users = []

  def initialize 
  end

  def self.initialize_users(users)
    @@users = users
  end

  def process_transactions (trans, &block)
    logged_trans = trans.map do |tran|
      "User #{tran.user.name} transaction with value #{tran.value}"
    end
    log_info "Processing Transactions #{logged_trans.join(", ")}"   

    trans.each do |tran|
      begin
        if !@@users.include? tran.user
          raise "User #{tran.user.name} transaction with value #{tran.value} failed with message #{tran.user.name} not exist in the bank!!"
        elsif tran.user.balance + tran.value < 0
          raise "User #{tran.user.name} transaction with value #{tran.value} failed with message Not enough balance"
        elsif tran.user.balance + tran.value == 0
          tran.user.balance = 0
          log_warning "#{tran.user.name} has 0 balance"
        else
          tran.user.balance = tran.user.balance + tran.value
          log_info "User #{tran.user.name} transaction with value #{tran.value} succeeded"
        end
        block.call true, tran

      rescue => msg
        log_error msg
        block.call false, tran, msg
      end
      
     
    end
  end
end

users = [
  User.new("Ali", 200),
  User.new("Peter", 500),
  User.new("Manda", 100)
]

out_side_bank_users = [
  User.new("Menna", 400),
]

transactions = [
  Transaction.new(users[0], -20),
  Transaction.new(users[0], -30),
  Transaction.new(users[0], -50),
  Transaction.new(users[0], -100),
  Transaction.new(users[0], -100),
  Transaction.new(out_side_bank_users[0], -100)
]
CBABank::initialize_users users

bank =  CBABank.new 
bank.process_transactions(transactions) do |success, transaction, msg| 
  if success 
    puts "Call endpoint for success of User #{transaction.user.name} transaction with value #{transaction.value}"
  else
    puts "Call endpoint for failure of #{msg}"
  end
end