dkms=$(shell which dkms)
ifeq ("$(dkms)","")
$(error need dkms, try to install dkms)
endif

module_target=toshiba-acpi
module_version=$(shell grep TOSHIBA_ACPI_VERSION $(module_target)/toshiba_acpi.c | head -n 1 | grep -o "[0-9\.]\+")
install_path=/usr/src/$(module_target)-$(module_version)

all: setup dkms_add dkms_build dkms_install

clean: dkms_uninstall dkms_remove
	-@[ -d $(install_path) ] && rm -rf $(install_path)

setup:
	-@[ -d $(install_path) ] && rm -rf $(install_path)
	cp -f -rap $(shell pwd)/$(module_target) $(install_path)



dkms_add:
	dkms add $(module_target)/$(module_version)

dkms_build:	
	dkms build $(module_target)/$(module_version)

dkms_install:
	dkms install $(module_target)/$(module_version)

dkms_uninstall:
	dkms uninstall $(module_target)/$(module_version)
	
dkms_remove:
	dkms remove $(module_target)/$(module_version) --all

