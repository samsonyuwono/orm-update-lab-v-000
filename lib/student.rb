require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade, :id

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  def initialize(id =nil, name, grade)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students(
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    )
    SQL
    DB[:conn].execute(sql)
  end


  def self.drop_table
    DB[:conn].execute("DROP TABLE students")
  end

  def save
    if self.id
       self.update
     else
    sql = <<-SQL
    INSERT INTO students (name, grade)
    VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT * FROM students ORDER BY id DESC LIMIT 1").flatten[0]
    end
  end

  def self.create(name, grade)
    Student.new(name, grade).save
  end


  def self.new_from_db(row)
    Student.new(row[0],row[1],row[2])
  end

  def self.find_by_name(name)
  row = DB[:conn].execute("SELECT * FROM students WHERE name = ? LIMIT 1", name).flatten
  new_from_db(row)
  end

  def update
    DB[:conn].execute("UPDATE students SET name = ?, grade = ? WHERE id= ?", @name, @grade, @id)
  end



end
