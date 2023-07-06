SCAD=openscad

STLOPTS= --export-format binstl
PNGOPTS= --colorscheme BeforeDawn --viewall --autocenter --imgsize 800,800 \
	 --render

STLDIR = stlout
PNGDIR = pngout

SRC = $(wildcard *.scad)

STL = $(addprefix $(STLDIR)/,$(SRC:.scad=.stl))
PNG = $(addprefix $(PNGDIR)/,$(SRC:.scad=.png))

.PHONY: _default
_default: stl

.PHONY: all
all: clean stl png

.PHONY: stl
stl: $(STLDIR) $(STL)

$(STLDIR)/%.stl: %.scad
	@echo [ STL ] $<
	@$(SCAD) $(STLOPTS) -o $@ $<

png: $(PNGDIR) $(PNG)

$(PNGDIR)/%.png: %.scad
	@echo [ PNG ] $<
	@$(SCAD) $(PNGOPTS) -o $@ $<

$(PNGDIR):
	@mkdir -p $(PNGDIR)/

$(STLDIR):
	@mkdir -p $(STLDIR)/

.PHONY: clean
clean:
	@rm -rf $(STLDIR)/
	@rm -rf $(PNGDIR)/
