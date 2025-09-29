# Generic Makefile for LaTeX compilation with BibTeX support
# Compiles any .tex files in the current directory to build/ directory

# Variables
BUILD_DIR = build
TEX_FILES = $(wildcard *.tex)
PDF_FILES = $(TEX_FILES:.tex=.pdf)
BUILD_PDF_FILES = $(addprefix $(BUILD_DIR)/, $(PDF_FILES))
BIB_FILES = $(wildcard *.bib)

# Files that need BibTeX processing (have \bibliography command)
BIBTEX_FILES = case_study_abstract case_study_report case_study_proposal

# Default target
all: $(BUILD_PDF_FILES)

# Create build directory if it doesn't exist
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Check if a .tex file needs BibTeX processing
needs_bibtex = $(if $(filter $(basename $<),$(BIBTEX_FILES)),yes,no)

# Compile .tex files to PDF in build directory
$(BUILD_DIR)/%.pdf: %.tex | $(BUILD_DIR)
	@echo "Compiling $< to $@"
	@if [ "$(call needs_bibtex)" = "yes" ]; then \
		echo "  - Document requires BibTeX processing"; \
		pdflatex -output-directory=$(BUILD_DIR) -interaction=nonstopmode $<; \
		bibtex $(BUILD_DIR)/$(basename $<); \
		pdflatex -output-directory=$(BUILD_DIR) -interaction=nonstopmode $<; \
		pdflatex -output-directory=$(BUILD_DIR) -interaction=nonstopmode $<; \
	else \
		echo "  - Standard LaTeX compilation"; \
		pdflatex -output-directory=$(BUILD_DIR) -interaction=nonstopmode $<; \
		pdflatex -output-directory=$(BUILD_DIR) -interaction=nonstopmode $<; \
	fi
	@echo "Successfully compiled $< to $@"

# Clean build directory
clean:aux
	@echo "Cleaning build directory..."
	rm -rf $(BUILD_DIR)
	@echo "Build directory cleaned"

# Clean auxiliary files but keep PDFs
clean-aux:
	@echo "Cleaning auxiliary files..."
	rm -f $(BUILD_DIR)/*.aux $(BUILD_DIR)/*.log $(BUILD_DIR)/*.out $(BUILD_DIR)/*.toc $(BUILD_DIR)/*.fdb_latexmk $(BUILD_DIR)/*.fls $(BUILD_DIR)/*.synctex.gz $(BUILD_DIR)/*.bbl $(BUILD_DIR)/*.blg $(BUILD_DIR)/*.nav $(BUILD_DIR)/*.snm $(BUILD_DIR)/*.vrb
	@echo "Auxiliary files cleaned"

# View PDF files (requires xdg-open on Linux)
view: $(BUILD_PDF_FILES)
	@for pdf in $(BUILD_PDF_FILES); do \
		echo "Opening $$pdf"; \
		xdg-open $$pdf 2>/dev/null || echo "Could not open $$pdf - please open manually"; \
	done

# Force recompilation
force: clean all

# Show available targets
help:
	@echo "Available targets:"
	@echo "  all        - Compile all .tex files to PDF in build/ directory"
	@echo "  clean      - Remove build directory and all generated files"
	@echo "  clean-aux  - Remove auxiliary files but keep PDFs"
	@echo "  view       - Open all generated PDFs"
	@echo "  force      - Clean and recompile everything"
	@echo "  help       - Show this help message"
	@echo ""
	@echo "Source files: $(TEX_FILES)"
	@echo "Target PDFs:  $(BUILD_PDF_FILES)"
	@echo "BibTeX files: $(BIB_FILES)"
	@echo "Files with BibTeX: $(BIBTEX_FILES)"

# Phony targets
.PHONY: all clean clean-aux view force help

# Default target when no target is specified
.DEFAULT_GOAL := all
