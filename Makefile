FILE=paper-capstone-earthquake

all: ${FILE}.pdf

d: clean
	pdflatex ${FILE}
	biber ${FILE}
	pdflatex ${FILE}
	pdflatex ${FILE}

# -pdf tells latexmk to generate a PDF instead of DVI.
# -pdflatex="" tells latexmk to call a specific backend with specific options.
# -use-make tells latexmk to call make for generating missing files.
# -interaction=nonstopmode keeps the pdflatex backend from stopping at a
# missing file reference and interactively asking you for an alternative.
# -synctex=1 is required to jump between the source PDF and the text editor.
# -pvc (preview continuously) watches the directory for changes.
# -quiet suppresses most status messages (https://tex.stackexchange.com/questions/40783/can-i-make-latexmk-quieter).
%.pdf: %.tex
	#latexmk -quiet -bibtex $(PREVIEW_CONTINUOUSLY) -f -pdf -pdflatex="pdflatex -synctex=1 -interaction=nonstopmode" -use-make $<
	latexmk -quiet $(PREVIEW_CONTINUOUSLY) -f -pdf -pdflatex="pdflatex -synctex=1 -interaction=nonstopmode" -use-make $<

# The .PHONY rule keeps make from processing a file named "watch" or "clean".
.PHONY: watch
# Set the PREVIEW_CONTINUOUSLY variable to -pvc to switch latexmk into the preview continuously mode
watch: PREVIEW_CONTINUOUSLY=-pvc
watch: ${FILE}.pdf

.PHONY: clean
# -bibtex also removes the .bbl files (http://tex.stackexchange.com/a/83384/79184).
clean:
	latexmk -CA -bibtex
	rm -f ${FILE}.run.xml
	rm -f *.tdo

dot:
	dot -Tpdf -o images/singularity.pdf images/singularity.dot

info:
	python bin/sysinfo.py

manual:
	wget -O rivanna-manual.html https://laszewsk.github.io/mlcommons/docs/tutorials/_print
	wget https://github.com/laszewsk/mlcommons/blob/main/www/content/en/docs/tutorials/rivanna.md -O rivanna-manual.md 
