# Simulating page replacement algorithms

# Generate test file if specified
if ARGV[0] == "mkfile" and not File.exist?("TestingData.txt")
  File.open("TestingData.txt", "w") do |f|
    50.times do
      create_line = lambda {
        result = ""

        30.times do
          result += rand(0..7).to_s
        end

        return result
      }

      line = create_line.call
      f.puts(line)
    end
  end
end

PAGE_FRAME_SIZES = [3, 4, 5, 6].freeze

=begin
conducting a performance analysis of them based on the performance measure of page faults for each page replacement algorithm using multiple inputs.
Output the details of each algorithm’s execution.
You need to show what pages are inside the page frames along with the reference string and mark it when a page fault occurred.
You can choose your display format, for examples, you can display the results for each reference string in a table format as shown in the class notes.
=end

# First In First Out(FIFO)
def fifo(page_frame_size, reference_line, output = false)
  faults = 0
  page_table = Array.new(page_frame_size)
  current_table_slot = 0

  # print out reference string if logging enabled
  if output
    puts("FIFO algorithm with reference string: #{reference_line}")
  end

  # start processing
  # convert reference string into array of pages
  pages = reference_line.split("").map(&:to_i)

  # iterate through each page
  pages.each do |new_page|
    curr_page = page_table[current_table_slot % page_frame_size]

    if curr_page != new_page
      faults += 1
    end

    page_table[current_table_slot % page_frame_size] = new_page

    current_table_slot += 1
  end

  return faults
end

# Least Recently Used (LRU)
def lru(page_frame_size, line)
end

# Optimal Algorithm (OPT)
def opt(page_frame_size, line)
end

fifo(3, "1234567", true)