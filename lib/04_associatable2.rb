require_relative '03_associatable'

# Phase IV
module Associatable
  # Remember to go back to 04_associatable to write ::assoc_options

  def has_one_through(name, through_name, source_name)


    define_method(name) do
      through_opts = self.class.assoc_options[through_name]
      source_opts = through_opts.model_class.assoc_options[source_name]

      through_table = through_opts.table_name
      through_fk = through_opts.foreign_key
      through_pk = through_opts.primary_key

      source_table = source_opts.table_name
      source_fk = source_opts.foreign_key
      source_pk = source_opts.primary_key

      value = self.send(through_opts.foreign_key)
      results = DBConnection.execute(<<-SQL, value)

      SELECT
        #{source_table}.*
      FROM
        #{through_table}
      JOIN
        #{source_table} ON #{through_table}.#{source_fk} = #{source_table}.#{source_pk}
      WHERE
        #{through_table}.#{through_pk} = ?
      SQL
      res = source_opts.model_class.parse_all(results).first
  
    end


  end
end
