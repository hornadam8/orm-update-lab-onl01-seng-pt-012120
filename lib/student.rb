require_relative "../config/environment.rb"

class Student

  attr_accessor :name,:grade
  attr_reader :id
  
  def intitialize(id=nil,name grade)
    @id = id
    @name = name
    @grade = grade
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE students (
      id INTEGER PRIMARY KEY
      name TEXT
      grade TEXT)
    SQL
    
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = <<-SQL
    DROP TABLE students
    SQL
    DB[:conn].execute(sql)
  end
  
  def save
    if self.id
      self.udpate
    else
      sql = <<-SQL
      INSERT INTO students(name,grade)
      VALUES (?,?)
      SQL
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")
    end
  end
  
  def create(name="",grade="")
    student.new(name,grade).save
  end
  
  def new_from_db(array)
    
  end
end
