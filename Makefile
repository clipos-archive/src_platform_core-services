# SPDX-License-Identifier: LGPL-2.1-or-later
# Copyright © 2007-2018 ANSSI. All Rights Reserved.
INIT_FILES := clip_update clip_user clip_audit clip_sshd clip_admin
ETC_FILES  := 
LIB_FILES  := jails.sub
JAILS := admin audit user update ike

ifdef WITH_X11
INIT_FILES += clip_x11
ETC_FILES += fstab.x11
JAILS += x11
endif

INST_INIT := install -D -m 0500
INST_ETC  := install -D -m 0400
INST_LIB  := install -D -m 0755

all:

install: install_etc install_init install_vserver install_lib

install_etc:
	for file in ${ETC_FILES}; do \
		${INST_ETC} etc/$${file} ${DESTDIR}/etc/$${file}; \
	done

install_init:
	for file in ${INIT_FILES}; do \
		${INST_INIT} init/$${file} ${DESTDIR}/etc/init.d/$${file}; \
	done

install_lib:
	for file in ${LIB_FILES}; do \
		${INST_LIB} lib/$${file} ${DESTDIR}/lib/clip/$${file}; \
	done

install_vserver:
	mkdir -p ${DESTDIR}/etc/jails
	for dir in ${JAILS}; do \
		if [[ -z "${ARCH_64}" ]] ; then \
			sed -i -e 's/@clip32@//' jails/$${dir}/fstab.external* ; \
			sed -i -e '/@clip64@/d' jails/$${dir}/fstab.external* ; \
		else \
			sed -i -e '/@clip32@/d' jails/$${dir}/fstab.external* ; \
			sed -i -e 's/@clip64@//' jails/$${dir}/fstab.external* ; \
		fi ; \
		cp -a jails/$${dir} ${DESTDIR}/etc/jails ; \
	done
