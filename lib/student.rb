require_relative "../config/environment.rb"

class Student

  attr_accessor :name,:grade
  attr_reader :id
  
  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE students (
      id INTEGER PRIMARY KEY,
      name TEXT,
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
      self.update
    else
      sql = <<-SQL
      INSERT INTO students(name,grade)
      VALUES (?,?)
      SQL
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end
  
  def self.create(name="",grade="")
    self.new(name,grade).save
  end
  
  def self.new_from_db(rows)
    new_student = self.new
    new_student.id = rows[0]
    new_student.name =  rows[1]
    new_student.grade = rows[2]
    new_student
  end
  
  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM STUDENTS
    WHERE name = ?
    SQL
    DB[:conn].execute(sql,name).map{|row| Student.new_from_db(row)}.first
  end
  
  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end
end