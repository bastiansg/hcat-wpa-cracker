.PHONY: build run


build:
	docker compose build hcat-cracker

test: build
	docker compose run --entrypoint="hashcat -b" hcat-cracker

run: check-cap-file check-dict-file
run:
	docker compose run --rm -e PCAP_FILE=$(PCAP_FILE) -e DICT_FILE=$(DICT_FILE) hcat-cracker


check-cap-file:
ifndef PCAP_FILE
	echo -e $(error parameter PCAP_FILE is required)
endif

check-dict-file:
ifndef DICT_FILE
	echo -e $(error parameter DICT_FILE is required)
endif
