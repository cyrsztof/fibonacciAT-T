name := $(shell ls *.s | grep -v dbg | cut -d. -f1)

$(name): $(name).o
				ld $< -o $@

$(name).o: $(name).s
				as $< -o $@ -g

.PHONY: clean
        clean:
				rm -f $(name) *.o *dbg*

