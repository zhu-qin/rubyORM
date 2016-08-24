require_relative 'db_connection'
require_relative 'ruby_orm'

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

class RubyORM
  extend Searchable
end
