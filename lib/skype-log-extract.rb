require 'highline/import'
require 'sqlite3'
require 'nokogiri'

module SkypeLogExtract
  class CLI
    def self.run!
      maindb = ARGV[0] || begin
        skype_dir  = File.join(ENV['HOME'], '.Skype')
        identities = Dir["#{skype_dir}/*"].
          select { |d| File.directory?(d) }.
          select { |d| File.exists?(File.join(d, 'main.db')) }

        fail 'could not find any identity' if identities.empty?

        identity = (identities.size == 1) ? identities.first : begin
          puts 'Choose identity:'
          choose do |menu|
            identities.each do |ident|
              menu.choice(File.basename(ident)) { ident }
            end
            menu.choice('Nevermind') { exit }
          end
        end

        File.join(identity, 'main.db')
      end

      puts "Using main.db file #{maindb}..."

      db = SQLite3::Database.new(maindb)

      puts 'Choose conversation:'
      conversation_id = choose do |menu|
        db.execute('SELECT id,displayname FROM Conversations ORDER BY last_activity_timestamp ASC') do |row|
          menu.choice(row[1]) { row[0] }
        end
        menu.choice('Nevermind') { exit }
      end

      puts 'Printing conversation to STDERR...'
      db.execute("SELECT timestamp,from_dispname,body_xml FROM Messages WHERE convo_id = #{conversation_id} ORDER BY timestamp") do |row|
        $stderr.puts "[#{Time.at(row[0]).to_s}] #{row[1]}: #{Nokogiri::XML.fragment(row[2])}"
      end
    end
  end
end
