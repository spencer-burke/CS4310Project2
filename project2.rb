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

# First In First Out(FIFO)
def fifo(page_frame_size, reference_line, output = false)
  faults = 0
  page_table = Array.new(page_frame_size)
  current_table_slot = 0

  if output
    puts("FIFO algorithm with reference string: #{reference_line}")
  end

  pages = reference_line.split("").map(&:to_i)

  if output
    puts("Page table start: #{page_table}")
  end
  
  pages.each do |new_page|
    if page_table.include?(new_page)
      if output
        puts("Page table: #{page_table} new page: #{new_page} faults: #{faults} HIT")
      end
    else
      page_table[current_table_slot % page_frame_size] = new_page

      current_table_slot += 1
      faults += 1

      if output
        puts("Page table: #{page_table} new page: #{new_page} faults: #{faults} MISS")
      end
    end
  end

  return faults
end

# Least Recently Used (LRU)
def lru(page_frame_size, reference_line, output = false)
  faults = 0
  # start with an empty array to make sure length works properly
  page_stack = []

  if output
    puts("LRU algorithm with reference string: #{reference_line}")
  end

  pages = reference_line.split("").map(&:to_i)

  if output
    puts("Page table start: #{page_stack}")
  end

  pages.each do |new_page|
    if page_stack.include?(new_page)
      page_stack.delete(new_page)
      page_stack.push(new_page)

      if output
        puts("Page table: #{page_stack} new page: #{new_page} faults: #{faults} HIT")
      end
    else
      if page_stack.length < page_frame_size
        page_stack.push(new_page)
      else
        page_stack.shift
        page_stack.push(new_page)
      end

      faults += 1

      if output
        puts("Page table: #{page_stack} new page: #{new_page} faults: #{faults} MISS")
      end
    end
  end

  return faults
end

# Optimal Algorithm (OPT)
def opt(page_frame_size, reference_line, output = false)
  faults = 0
  page_table = []

  if output
    puts("OPT algorithm with reference string: #{reference_line}")
  end

  pages = reference_line.split("").map(&:to_i)

  if output
    puts("Page table start: #{page_table}")
  end

  pages.each_with_index do |new_page, index|
    # if found do nothing
    if page_table.include?(new_page)
      if output
        puts("Page table: #{page_table} new page: #{new_page} faults: #{faults} HIT")
      end
    else
      # if not found and space available
      if page_table.length < page_frame_size
        page_table.push(new_page)

      # if not found and full then replace with distance calcs
      else
        search_pages = pages[(index + 1)..-1]

        replace_page = nil
        furthest_index = -1

        page_table.each do |current_page|
          current_index = search_pages.index(current_page)

          # infinite case
          if current_index.nil?
            replace_page = current_page
            break
          # get the furthest so far
          elsif current_index > furthest_index
            furthest_index = current_index
            replace_page = current_page
          end
        end

        page_table.delete(replace_page)
        page_table.push(new_page)
      end

      faults += 1

      if output
        puts("Page table: #{page_table} new page: #{new_page} faults: #{faults} MISS")
      end
    end
  end

  return faults
end

fifo(3, "70120304230321201701", true)
lru(3, "70120304230321201701", true)
opt(3, "70120304230321201701", true)