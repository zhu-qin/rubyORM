require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    search = params.map do |k,v|
      "#{k} = ?"
    end.join(" AND ")
    result = DBConnection.execute(<<-SQL, *params.values)
    SELECT
      *
    FROM
      #{table_name}
    WHERE
      #{search}
    SQL
    parse_all(result)
  
  end
end

class SQLObject
  #extend allows for methods in the module to be used as class methods
  #include allows for methods in the module to be used as instance methods
  extend Searchable
end
