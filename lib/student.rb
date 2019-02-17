require_relative "../config/environment.rb"

class Student
   attr_accessor :id, :name, :grade
    def initialize(name=nil,grade=nil,id=nil)
      @name=name
      @grade =grade
      @id = id
    end


    def self.create_table
      sql= <<-SQL
      CREATE TABLE IF NOT EXISTS students(
      id INTEGER PRIMARY KEY,
         name TEXT,
         grade TEXT );
       SQL
       DB[:conn].execute(sql)
     end
  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
  def save
    if self.id
      self.update
    else
      sql= <<-SQL
      INSERT INTO students (name, grade) VALUES (?, ?);
      SQL
    DB[:conn].execute(sql, self.name, self.grade)
    @id =DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end
  end
  def self.create(name,grade)
    file=Student.new(name,grade)
    file.save# saves in the db
    file
  end
  def self.new_from_db(row)
    file =self.new
    file.id=row[0]
    file.name=row[1]
    file.grade=row[2]
file
  end
  def self.find_by_name(name)
      sql = <<-SQL
          SELECT *
          FROM students
          WHERE name = ?
          LIMIT 1
        SQL

        DB[:conn].execute(sql, name).map do |row|
          self.new_from_db(row)
        end.first
      end
    def update
        sql = <<-SQL
        UPDATE students SET  name =?, grade =? WHERE id =?
        SQL
            DB[:conn].execute(sql, self.name ,self.grade, self.id)
    end







end
