require 'sqlite3'
require_relative 'plays'

class Playwright
    attr_accessor :name, :birth_year
    attr_reader :id

    def self.all
        results = PlayDBConnection.instance.execute(<<-SQL)
            SELECT
                *
            FROM
                playwrights
        SQL

        results.map { |result| Playwright.new(result) }
    end

    def self.find_by_name(name)
        result = PlayDBConnection.instance.execute(<<-SQL, name)
            SELECT
                *
            FROM
                playwrights
            WHERE
                name = ?
        SQL

        return nil unless person.length > 0

        Playwright.new(result.first)
    end

    def initialize(option)
        @id = option['id']
        @name = option['name']
        @birth_year = option['birth_year']
    end

    def create
        raise "#{self} already exists in the database" if self.id
        PlayDBConnection.instance.execute(<<-SQL, self.name, self.birth_year)
            INSERT INTO
                playwrights (name, birth_year)
            VALUES
                (?, ?)
        SQL

        self.id = PlayDBConnection.instance.last_insert_row_id
    end

    def update
        raise "#{self} does not exist in the database" unless self.id
        PlayDBConnection.instance.execute(<<-SQL, self.name, self.birth_year, self.id)
            UPDATE
                playwrights
            SET
                name = ?, birth_year = ?
            WHERE
                id = ?
        SQL
    end

    def get_plays
        raise "#{self} not in database" unless self.id
        results = PlayDBConnection.instance.execute(<<-SQL, self.id)
            SELECT
                *
            FROM
                plays
            WHERE
                playwright_id = ?
        SQL

        results.map { |result| Play.new(result) }

    end

end