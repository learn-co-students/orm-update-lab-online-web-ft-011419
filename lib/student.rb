require_relative "../config/environment.rb"
require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
      SQL
    DB[:conn].execute(sql)
  end
  def self.drop_table
    sql = <<-SQL
      DROP TABLE IF EXISTS students
    SQL
    DB[:conn].execute(sql)
  end
  def save
    if self.id
      self.update
    else
      DB[:conn].execute("INSERT INTO students (name, grade) VALUES (?, ?)", self.name, self.grade)
      self.id = DB[:conn].execute("SELECT id FROM students WHERE id = (SELECT MAX(id) FROM students)")[0][0]
    end
  end
  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
    student
  end
  def self.new_from_db(row)
    Student.new(row[0], row[1], row[2])
  end
  def self.find_by_name(name)
    row = DB[:conn].execute("SELECT * FROM students WHERE name = ?", name).first
    Student.new_from_db(row)
  end
  def update
    DB[:conn].execute("UPDATE students SET name = ?, grade = ? WHERE id = ?", self.name, self.grade, self.id)
  end
end
