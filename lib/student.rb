class Student

    #### Attributes ####
    attr_reader :id
    attr_accessor :name, :grade


    #### Instance Methods ####
    def initialize(id=nil, name, grade)
        @id = id
        @name = name
        @grade = grade
    end

    def save
        sql = <<-SQL
            INSERT INTO students (name, grade)
            VALUES(?, ?)
            SQL
        DB[:conn].execute(sql, self.name, self.grade)
        @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end

    #### Class Methods####
    def self.create_table
        sql = <<-SQL
            CREATE TABLE IF NOT EXISTS students (
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

    def self.create(student_hash)
        student = Student.new(student_hash[:name], student_hash[:grade])
        student.save
        student
    end
end
