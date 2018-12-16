require 'sqlite3'

class Playwright
    attr_accessor :name, :birth_year

    def self.all
        results = PlayDBConnection.instance.execute(<<-SQL)
            select *
            from playwrights
        SQL

        results.map { |result| Playwright.new(result) }
    end

    def self.find_by_name(name)
        result = PlayDBConnection.instance.execute(<<-SQL, name)
            Select *
            from playwrights
            where name = ?
        SQL

        Playwright.new(result.first)
    end

    def initialize(option)
        @id = option['id']
        @name = option['name']
        @birth_year = option['birth_year']
    end

    def create
        raise "#{self} already exists in the database" if @id
        PlayDBConnection.instance.execute(<<- SQL, @name, @birth_year)
            insert into
            playwrights (name, birth_year)
            values
            (?, ?)
        SQL

        @id = PlayDBConnection.instance.last_insert_row_id
    end

    def update
        raise "#{self} does not exist in the database" unless @id
        PlayDBConnection.instance.execute(<<-SQL, @name, @birth_year, @id)
            update
            playwrights
            set
            name = ?, birth_year = ?
            where
            id = ?
        SQL
    end

    def get_plays

    end

end