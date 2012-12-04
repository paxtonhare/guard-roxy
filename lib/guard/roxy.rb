require 'guard'
require 'guard/guard'
require 'guard/watcher'
require 'rexml/document'

module Guard
  class Roxy < Guard

    # # Calls #run_all if the :all_on_start option is present.
    def start
      run_all if options[:all_on_start]
    end

    # Call #run_on_change for all files which match this guard.
    def run_all
      deploy_code
      run_test
    end

    # Print the result of the command(s), if there are results to be printed.
    def run_on_change(paths)
      puts paths
      deploy_code
      paths.each do |path|
        run_test(path) if File.exists?("src/#{path}")
      end
    end

    def deploy_code
      output = `ml local deploy modules`
    end

    def run_test(test = nil)
      test_str = "--test=#{test}" if test
      output = `ml local test #{test_str} --format=xml`
      doc = REXML::Document.new(output)
      assertions = doc.root.attribute('assertions').to_s.to_i
      successes = doc.root.attribute('successes').to_s.to_i
      failures = doc.root.attribute('failures').to_s.to_i
      errors = doc.root.attribute('errors').to_s.to_i
      time = doc.root.attribute('time').to_s

      msg = "Ran #{assertions} assertions, #{successes} successes, #{failures} failures, #{errors} errors in #{time} seconds."
      ::Guard::Notifier.notify(
        msg,
        :title => "Roxy:Test results",
        :image => (failures == 0 && errors == 0) ? :success : :failed
      )
      # puts output
      print_stack_dump(doc)
    end

    def print_stack_dump(doc)
      REXML::XPath.each(doc, '//error:error') do |error|
        puts "#{error.elements['./error:name'].text}: #{error.elements['./error:code'].text}"
        puts "\nCall Stack:\n"

        index = -1
        last_operation = ''
        error.each_element('error:stack/error:frame') do |frame|
          index += 1
          uri = frame.elements['error:uri']
          uri = uri ? uri.text : "evaluated code"
          line = frame.elements['error:line'].text
          puts "#{uri}:#{line}\n\t#{last_operation}\n\n" if index > 0
          last_operation = frame.elements['error:operation'].text
        end
      end
    end
  end
end