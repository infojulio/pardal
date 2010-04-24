class ImportCurriculums < ImportClass

  def initialize
    @old_table_class = LegacyCurriculum
    @new_table_class = Curriculum
    super
  end

  def parse
    @rows = Array.new
    @legacy_rows.each do |reg|
      hash = Hash.new
      hash[:structure_code] = reg[:CodigoDaEstrutura]
      hash[:credit_hours] = reg[:CargaHorariaDoCurso]
      hash[:school_id] = reg[:CodigoDoCurso].to_i
      hash[:period_id] = reg[:CodigoDoTurno].to_i
      hash[:curriculum_type] = reg[:TipoDeEstrutura]
      hash[:implementation_semester] = reg[:AnoESemestreDeImplantacao]
      hash[:avg_school_time] = reg[:NumeroDeSemestres]
      hash[:max_school_time] = reg[:NumeroMaximoDeSemestres]
      @rows << hash
    end
    @legacy_rows = nil
  end

end

