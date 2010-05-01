class ImportEnrollments < ImportClass

  def initialize
    @old_table_class = LegacyHistory
    @new_table_class = Enrollment
    super
  end

  def parse
    @rows = Array.new
    @legacy_rows.each do |reg|
      hash = Hash.new
      student = Student.find_all_by_registration reg.NumeroDeMatricula
      case student.size
      when 0
        logger.error("Nao foi encontrado o aluno => #{reg.NumeroDeMatricula}")
      when 1
        student = student.first
        discipline = Discipline.find(reg.CodigoDaDisciplina)
        courses = discipline.courses.find_all_by_course_school_id(reg[:CodigoDaTurma]) if reg.CodigoDaTurma
        courses ||= discipline.courses_from_curriculum(student.curriculum)
        if courses.empty?
          logger.error("Nao foram encontradas turmas para o aluno #{reg.inspect}")
          courses = discipline.courses
          if courses.empty?
            course_school = student.curriculum.course_schools.first
            courses << discipline.courses.create(:course_school_id => course_school.id)
          end
        end
        course_semester = courses.first.course_semesters.find_or_create_by_semester(reg.SemestreEAno)
      else
        logger.error("Foi encotrado mais de um aluno #{student.inspect}")
      end
      hash[:student_id] = student.id
      hash[:course_semester_id] = course_semester.id
      hash[:grade] = reg[:Conceito]
      hash[:situation_id] = reg[:SituacaoDaMatricula]
      @rows << hash
    end
    @legacy_rows = nil
  end

end
