require_relative 'db_connection'
require 'active_support/inflector'

class RubyORM
  attr_accessor :attributes
  def self.columns
    return @columns if @columns
    cols = DBConnection.execute2(<<-SQL).first
      SELECT
        *
      FROM
      #{self.table_name}
      LIMIT
        0
    SQL
    cols.map!(&:to_sym)
    @columns = cols
  end

  def self.table_name_exceptions
    @table_name_exceptions = {"Human" => "humans"}
  end

  def self.finalize!
    self.columns.each do |attr|
      define_method(attr){self.attributes[attr]}
      define_method("#{attr}="){|val| self.attributes[attr] = val}
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    if self.table_name_exceptions[self.to_s]
      @table_name = self.table_name_exceptions[self.to_s]
    else
      @table_name ||= self.to_s.tableize
    end
  end

  def self.all
    rows = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
      #{self.table_name}
    SQL
    self.parse_all(rows)
  end

  def self.parse_all(results)
    results.map do |hash|
      self.new(hash)
    end
  end

  def self.find(id)
    row = DBConnection.execute(<<-SQL, id)
      SELECT
        #{self.table_name}.*
      FROM
        #{self.table_name}
      WHERE
        #{table_name}.id = ?
    SQL
    result = self.parse_all(row).first
  end

  def self.create(params)
    self.new(params).save
  end

  def initialize(params = {})
    params.each do |attr_name, val|
      attr_name = attr_name.to_sym
      if self.class.columns.include?(attr_name)
        self.send("#{attr_name}=", val)
      else
        raise "unknown attribute '#{attr_name}'"
      end
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map {|col_name| self.send(col_name)}
  end

  def insert
    col = self.class.columns.drop(1)
    col_names = col.map(&:to_s).join(", ")
    question_marks = (["?"]*col.length).join(", ")
    DBConnection.execute(<<-SQL, *attribute_values.drop(1))
    INSERT INTO
      #{self.class.table_name} (#{col_names})
    VALUES
      (#{question_marks})
    SQL

    self.id = DBConnection.last_insert_row_id
  end

  def update
    col_names = self.class.columns.map do |col_name|
      "#{col_name.to_s} = ?"
    end.join(", ")

    DBConnection.execute(<<-SQL, *attribute_values, id)
    UPDATE
      #{self.class.table_name}
    SET
      #{col_names}
    WHERE
      #{self.class.table_name}.id = ?
    SQL
  end

  def save
    self.id.nil? ? self.insert : self.update
  end

end
