.DEFAULT_GOAL := help

help:
	@echo "HTTP server h2o unofficial installer"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

install: _install_h2o ## install h2o and h2o settings
	sudo mkdir -p /usr/local/etc/h2o
	sudo chown $(whoami):$(whoami) /usr/local/etc/h2o
	cp h2o.conf /etc/systemd/system/
	sudo cp h2o.service /etc/systemd/system/
	sudo systemctl daemon-reload

_install_h2o:
	cd /usr/local/src/h2o && sudo make install

build: ## download h2o from GitHub and build h2o
	sudo apt update && sudo apt install build-essential cmake libssl-dev
	git clone https://github.com/h2o/h2o.git
	sudo mkdir -p /usr/local/src
	sudo mv h2o /usr/local/src/
	cd /usr/local/src/h2o && git checkout $(curl -sSfL https://api.github.com/repos/h2o/h2o/releases/latest | grep html_url | grep h2o |sed -e 's/.*tag\/\(.*\)".*/\1/g')
	cmake -DWITH_BUNDLED_SSL=on .
	make
