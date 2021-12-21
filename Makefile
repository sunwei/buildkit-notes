DOCKER ?= $(shell command -v docker 2>/dev/null)
PANDOC ?= $(shell command -v pandoc 2>/dev/null)

PUBLISH_DIRNAME	?= www/
OUTPUT_DIRNAME	?= output/
DOC_FILENAME	?= writing

PANDOC_CONTAINER ?= docker.io/vbatts/pandoc:1.17.0.3-2.fc25.x86_64
ifeq "$(strip $(PANDOC))" ''
	ifneq "$(strip $(DOCKER))" ''
		PANDOC = $(DOCKER) run \
			--rm \
			-v $(shell pwd)/:/input/:ro \
			-v $(shell pwd)/$(OUTPUT_DIRNAME)/:/$(OUTPUT_DIRNAME)/ \
			-u $(shell id -u) \
			--workdir /input \
			$(PANDOC_CONTAINER)
		PANDOC_SRC := /input/
		PANDOC_DST := /
	endif
endif

# These docs are in an order that determines how they show up in the HTML docs.
DOC_FILES := \
	spec.md \
	content.md

FIGURE_FILES := \
	img/dream.JPG

help:
	@echo "Usage: make <target>"
	@echo
	@echo " * 'docs' - produce document in the $(OUTPUT_DIRNAME) directory"

docs: $(OUTPUT_DIRNAME)/$(DOC_FILENAME).html

ifeq "$(strip $(PANDOC))" ''
$(OUTPUT_DIRNAME)/$(DOC_FILENAME).html: $(DOC_FILES) $(FIGURE_FILES)
	$(error cannot build $@ without either pandoc or docker)
else
$(OUTPUT_DIRNAME)/$(DOC_FILENAME).html: header.html $(DOC_FILES) $(FIGURE_FILES)
	@mkdir -p $(OUTPUT_DIRNAME)/ && \
    cp -R img $(shell pwd)/$(OUTPUT_DIRNAME)/ && \
	$(PANDOC) -f markdown_github -t html5 -H $(PANDOC_SRC)header.html --standalone -o $(PANDOC_DST)$@ $(patsubst %,$(PANDOC_SRC)%,$(DOC_FILES))
	ls -sh $(realpath $@)
endif

publish:
	mkdir -p $(PUBLISH_DIRNAME)/ && \
	cp ./CNAME ./$(PUBLISH_DIRNAME)/CNAME && \
	cp -R img ./$(PUBLISH_DIRNAME)/ && \
	cp ./$(OUTPUT_DIRNAME)/$(DOC_FILENAME).html ./$(PUBLISH_DIRNAME)/index.html

.PHONY: \
	docs \
	publish
