# LaTeX Makefile

This Makefile automates LaTeX → PDF compilation (with BibTeX support) into a `build/` directory.

## Usage

```bash
make            # Compile all .tex files → build/*.pdf
make view       # Open generated PDFs
make clean      # Remove build/ and all generated files
make clean-aux  # Remove only auxiliary files
make force      # Clean + rebuild everything
make help       # Show available targets

