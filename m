Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab1ENK7L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 06:59:11 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:65478 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410Ab1ENK4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 06:56:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lgTOsWV7CebiUOlxXVi/PVzxe2cuRq+d83wyu3zZne+B0JtNLIiYDXnPjr5SoEP0zo
         16m9gLbQo5Ojv5X+Y4UF/jMNSc9szMEGs5Jrp6vjt/ECINdj+SrWymn9833HvCnCL1Oz
         c5okg5H14aOrd8QX9+lAgRdLF45UP3czt1UUM=
From: matt mooney <mfmooney@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/14] staging: usbip: userspace: rename source directories
Date: Sat, 14 May 2011 03:55:09 -0700
Message-Id: <39cd3477704c2fd793294ba72887fa346e9584e2.1305369176.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305369175.git.mfm@muteddisk.com>
References: <cover.1305369175.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: matt mooney <mfm@muteddisk.com>

Rename cmd/ to src/ and lib/ to libsrc/.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/Makefile.am        |    5 +-
 drivers/staging/usbip/userspace/cmd/Makefile.am    |   19 -
 drivers/staging/usbip/userspace/cmd/bind-driver.c  |  644 ----------------
 drivers/staging/usbip/userspace/cmd/usbip.c        |  725 ------------------
 .../staging/usbip/userspace/cmd/usbip_network.c    |  251 ------
 .../staging/usbip/userspace/cmd/usbip_network.h    |  198 -----
 drivers/staging/usbip/userspace/cmd/usbipd.c       |  571 --------------
 drivers/staging/usbip/userspace/cmd/utils.c        |  256 -------
 drivers/staging/usbip/userspace/cmd/utils.h        |   38 -
 drivers/staging/usbip/userspace/configure.ac       |    2 +-
 drivers/staging/usbip/userspace/lib/Makefile.am    |   10 -
 drivers/staging/usbip/userspace/lib/names.c        |  793 --------------------
 drivers/staging/usbip/userspace/lib/names.h        |   57 --
 drivers/staging/usbip/userspace/lib/stub_driver.c  |  390 ----------
 drivers/staging/usbip/userspace/lib/stub_driver.h  |   36 -
 drivers/staging/usbip/userspace/lib/usbip.h        |   19 -
 drivers/staging/usbip/userspace/lib/usbip_common.c |  282 -------
 drivers/staging/usbip/userspace/lib/usbip_common.h |  149 ----
 drivers/staging/usbip/userspace/lib/vhci_driver.c  |  506 -------------
 drivers/staging/usbip/userspace/lib/vhci_driver.h  |   61 --
 drivers/staging/usbip/userspace/libsrc/Makefile.am |   10 +
 drivers/staging/usbip/userspace/libsrc/names.c     |  793 ++++++++++++++++++++
 drivers/staging/usbip/userspace/libsrc/names.h     |   57 ++
 .../staging/usbip/userspace/libsrc/stub_driver.c   |  390 ++++++++++
 .../staging/usbip/userspace/libsrc/stub_driver.h   |   36 +
 drivers/staging/usbip/userspace/libsrc/usbip.h     |   19 +
 .../staging/usbip/userspace/libsrc/usbip_common.c  |  282 +++++++
 .../staging/usbip/userspace/libsrc/usbip_common.h  |  149 ++++
 .../staging/usbip/userspace/libsrc/vhci_driver.c   |  506 +++++++++++++
 .../staging/usbip/userspace/libsrc/vhci_driver.h   |   61 ++
 drivers/staging/usbip/userspace/src/Makefile.am    |   19 +
 drivers/staging/usbip/userspace/src/bind-driver.c  |  644 ++++++++++++++++
 drivers/staging/usbip/userspace/src/usbip.c        |  725 ++++++++++++++++++
 .../staging/usbip/userspace/src/usbip_network.c    |  251 ++++++
 .../staging/usbip/userspace/src/usbip_network.h    |  198 +++++
 drivers/staging/usbip/userspace/src/usbipd.c       |  571 ++++++++++++++
 drivers/staging/usbip/userspace/src/utils.c        |  256 +++++++
 drivers/staging/usbip/userspace/src/utils.h        |   38 +
 38 files changed, 5009 insertions(+), 5008 deletions(-)
 delete mode 100644 drivers/staging/usbip/userspace/cmd/Makefile.am
 delete mode 100644 drivers/staging/usbip/userspace/cmd/bind-driver.c
 delete mode 100644 drivers/staging/usbip/userspace/cmd/usbip.c
 delete mode 100644 drivers/staging/usbip/userspace/cmd/usbip_network.c
 delete mode 100644 drivers/staging/usbip/userspace/cmd/usbip_network.h
 delete mode 100644 drivers/staging/usbip/userspace/cmd/usbipd.c
 delete mode 100644 drivers/staging/usbip/userspace/cmd/utils.c
 delete mode 100644 drivers/staging/usbip/userspace/cmd/utils.h
 delete mode 100644 drivers/staging/usbip/userspace/lib/Makefile.am
 delete mode 100644 drivers/staging/usbip/userspace/lib/names.c
 delete mode 100644 drivers/staging/usbip/userspace/lib/names.h
 delete mode 100644 drivers/staging/usbip/userspace/lib/stub_driver.c
 delete mode 100644 drivers/staging/usbip/userspace/lib/stub_driver.h
 delete mode 100644 drivers/staging/usbip/userspace/lib/usbip.h
 delete mode 100644 drivers/staging/usbip/userspace/lib/usbip_common.c
 delete mode 100644 drivers/staging/usbip/userspace/lib/usbip_common.h
 delete mode 100644 drivers/staging/usbip/userspace/lib/vhci_driver.c
 delete mode 100644 drivers/staging/usbip/userspace/lib/vhci_driver.h
 create mode 100644 drivers/staging/usbip/userspace/libsrc/Makefile.am
 create mode 100644 drivers/staging/usbip/userspace/libsrc/names.c
 create mode 100644 drivers/staging/usbip/userspace/libsrc/names.h
 create mode 100644 drivers/staging/usbip/userspace/libsrc/stub_driver.c
 create mode 100644 drivers/staging/usbip/userspace/libsrc/stub_driver.h
 create mode 100644 drivers/staging/usbip/userspace/libsrc/usbip.h
 create mode 100644 drivers/staging/usbip/userspace/libsrc/usbip_common.c
 create mode 100644 drivers/staging/usbip/userspace/libsrc/usbip_common.h
 create mode 100644 drivers/staging/usbip/userspace/libsrc/vhci_driver.c
 create mode 100644 drivers/staging/usbip/userspace/libsrc/vhci_driver.h
 create mode 100644 drivers/staging/usbip/userspace/src/Makefile.am
 create mode 100644 drivers/staging/usbip/userspace/src/bind-driver.c
 create mode 100644 drivers/staging/usbip/userspace/src/usbip.c
 create mode 100644 drivers/staging/usbip/userspace/src/usbip_network.c
 create mode 100644 drivers/staging/usbip/userspace/src/usbip_network.h
 create mode 100644 drivers/staging/usbip/userspace/src/usbipd.c
 create mode 100644 drivers/staging/usbip/userspace/src/utils.c
 create mode 100644 drivers/staging/usbip/userspace/src/utils.h

diff --git a/drivers/staging/usbip/userspace/Makefile.am b/drivers/staging/usbip/userspace/Makefile.am
index c076952..3be3060 100644
--- a/drivers/staging/usbip/userspace/Makefile.am
+++ b/drivers/staging/usbip/userspace/Makefile.am
@@ -1,6 +1,7 @@
-SUBDIRS = lib cmd
+SUBDIRS = libsrc src
 includedir=@includedir@/usbip
-include_HEADERS = lib/usbip.h lib/usbip_common.h lib/vhci_driver.h lib/stub_driver.h
+include_HEADERS := $(addprefix libsrc/, \
+		     usbip.h usbip_common.h vhci_driver.h stub_driver.h)
 
 dist_man_MANS := $(addprefix doc/, usbip.8 usbipd.8 usbip_bind_driver.8)
 
diff --git a/drivers/staging/usbip/userspace/cmd/Makefile.am b/drivers/staging/usbip/userspace/cmd/Makefile.am
deleted file mode 100644
index 5cc50fc..0000000
--- a/drivers/staging/usbip/userspace/cmd/Makefile.am
+++ /dev/null
@@ -1,19 +0,0 @@
-# $Id$
-
-sbin_PROGRAMS = usbip usbipd usbip_bind_driver
-
-usbip_SOURCES = usbip.c usbip_network.c usbip_network.h
-usbipd_SOURCES = usbipd.c usbip_network.c usbip_network.h
-usbip_bind_driver_SOURCES = bind-driver.c \
-		utils.c utils.h \
-		usbip_network.h usbip_network.c
-
-#usbip_bind_driver_CFLAGS = -Wall -W -Wstrict-prototypes @PACKAGE_CFLAGS@
-#usbip_bind_driver_LDADD = @PACKAGE_LIBS@
-
-#AM_CPPFLAGS = -I../include -Wall -std=gnu99
-INCLUDES = -I$(top_srcdir)/lib
-LDADD = ../lib/libusbip.la @PACKAGE_LIBS@
-EXTRA_CFLAGS = @EXTRA_CFLAGS@
-AM_CFLAGS = -Wall -W -Wstrict-prototypes -std=gnu99 $(EXTRA_CFLAGS) @PACKAGE_CFLAGS@ -DUSBIDS_FILE='"@USBIDS_DIR@/usb.ids"'
-
diff --git a/drivers/staging/usbip/userspace/cmd/bind-driver.c b/drivers/staging/usbip/userspace/cmd/bind-driver.c
deleted file mode 100644
index 5226751..0000000
--- a/drivers/staging/usbip/userspace/cmd/bind-driver.c
+++ /dev/null
@@ -1,644 +0,0 @@
-/*
- * $Id$
- *
- * Copyright (C) 2005-2007 Takahiro Hirofuchi
- */
-
-#include "utils.h"
-
-#define _GNU_SOURCE
-#include <getopt.h>
-#include <glib.h>
-
-
-
-static const struct option longopts[] = {
-	{"usbip",	required_argument,	NULL, 'u'},
-	{"other",	required_argument,	NULL, 'o'},
-	{"list",	no_argument,		NULL, 'l'},
-	{"list2",	no_argument,		NULL, 'L'},
-	{"help",	no_argument,		NULL, 'h'},
-#if 0
-	{"allusbip",	no_argument,		NULL, 'a'},
-	{"export-to",   required_argument,	NULL, 'e'},
-	{"unexport",    required_argument,	NULL, 'x'},
-	{"busid",	required_argument,	NULL, 'b'},
-#endif
-
-	{NULL,		0,			NULL,  0}
-};
-
-static const char match_busid_path[] = "/sys/bus/usb/drivers/usbip/match_busid";
-
-
-static void show_help(void)
-{
-	printf("Usage: usbip_bind_driver [OPTION]\n");
-	printf("Change driver binding for USB/IP.\n");
-	printf("  --usbip busid        make a device exportable\n");
-	printf("  --other busid        use a device by a local driver\n");
-	printf("  --list               print usb devices and their drivers\n");
-	printf("  --list2              print usb devices and their drivers in parseable mode\n");
-#if 0
-	printf("  --allusbip           make all devices exportable\n");
-	printf("  --export-to host     export the device to 'host'\n");
-	printf("  --unexport host      unexport a device previously exported to 'host'\n");
-	printf("  --busid busid        the busid used for --export-to\n");
-#endif
-}
-
-static int modify_match_busid(char *busid, int add)
-{
-	int fd;
-	int ret;
-	char buff[BUS_ID_SIZE + 4];
-
-	/* BUS_IS_SIZE includes NULL termination? */
-	if (strnlen(busid, BUS_ID_SIZE) > BUS_ID_SIZE - 1) {
-		g_warning("too long busid");
-		return -1;
-	}
-
-	fd = open(match_busid_path, O_WRONLY);
-	if (fd < 0)
-		return -1;
-
-	if (add)
-		snprintf(buff, BUS_ID_SIZE + 4, "add %s", busid);
-	else
-		snprintf(buff, BUS_ID_SIZE + 4, "del %s", busid);
-
-	g_debug("write \"%s\" to %s", buff, match_busid_path);
-
-	ret = write(fd, buff, sizeof(buff));
-	if (ret < 0) {
-		close(fd);
-		return -1;
-	}
-
-	close(fd);
-
-	return 0;
-}
-
-static const char unbind_path_format[] = "/sys/bus/usb/devices/%s/driver/unbind";
-
-/* buggy driver may cause dead lock */
-static int unbind_interface_busid(char *busid)
-{
-	char unbind_path[PATH_MAX];
-	int fd;
-	int ret;
-
-	snprintf(unbind_path, sizeof(unbind_path), unbind_path_format, busid);
-
-	fd = open(unbind_path, O_WRONLY);
-	if (fd < 0) {
-		g_warning("opening unbind_path failed: %d", fd);
-		return -1;
-	}
-
-	ret = write(fd, busid, strnlen(busid, BUS_ID_SIZE));
-	if (ret < 0) {
-		g_warning("write to unbind_path failed: %d", ret);
-		close(fd);
-		return -1;
-	}
-
-	close(fd);
-
-	return 0;
-}
-
-static int unbind_interface(char *busid, int configvalue, int interface)
-{
-	char inf_busid[BUS_ID_SIZE];
-	g_debug("unbinding interface");
-
-	snprintf(inf_busid, BUS_ID_SIZE, "%s:%d.%d", busid, configvalue, interface);
-
-	return unbind_interface_busid(inf_busid);
-}
-
-
-static const char bind_path_format[] = "/sys/bus/usb/drivers/%s/bind";
-
-static int bind_interface_busid(char *busid, char *driver)
-{
-	char bind_path[PATH_MAX];
-	int fd;
-	int ret;
-
-	snprintf(bind_path, sizeof(bind_path), bind_path_format, driver);
-
-	fd = open(bind_path, O_WRONLY);
-	if (fd < 0)
-		return -1;
-
-	ret = write(fd, busid, strnlen(busid, BUS_ID_SIZE));
-	if (ret < 0) {
-		close(fd);
-		return -1;
-	}
-
-	close(fd);
-
-	return 0;
-}
-
-static int bind_interface(char *busid, int configvalue, int interface, char *driver)
-{
-	char inf_busid[BUS_ID_SIZE];
-
-	snprintf(inf_busid, BUS_ID_SIZE, "%s:%d.%d", busid, configvalue, interface);
-
-	return bind_interface_busid(inf_busid, driver);
-}
-
-static int unbind(char *busid)
-{
-	int configvalue = 0;
-	int ninterface = 0;
-	int devclass = 0;
-	int i;
-	int failed = 0;
-
-	configvalue = read_bConfigurationValue(busid);
-	ninterface  = read_bNumInterfaces(busid);
-	devclass  = read_bDeviceClass(busid);
-
-	if (configvalue < 0 || ninterface < 0 || devclass < 0) {
-		g_warning("read config and ninf value, removed?");
-		return -1;
-	}
-
-	if (devclass == 0x09) {
-		g_message("skip unbinding of hub");
-		return -1;
-	}
-
- 	for (i = 0; i < ninterface; i++) {
- 		char driver[PATH_MAX];
-		int ret;
-
-		bzero(&driver, sizeof(driver));
-
- 		getdriver(busid, configvalue, i, driver, PATH_MAX-1);
-
-		g_debug(" %s:%d.%d	-> %s ", busid, configvalue, i, driver);
-
-		if (!strncmp("none", driver, PATH_MAX))
-			continue; /* unbound interface */
-
-#if 0
-		if (!strncmp("usbip", driver, PATH_MAX))
-			continue; /* already bound to usbip */
-#endif
-
-		/* unbinding */
-		ret = unbind_interface(busid, configvalue, i);
-		if (ret < 0) {
-			g_warning("unbind driver at %s:%d.%d failed",
-					busid, configvalue, i);
-			failed = 1;
-		}
-	}
-
-	if (failed)
-		return -1;
-	else
-		return 0;
-}
-
-/* call at unbound state */
-static int bind_to_usbip(char *busid)
-{
-	int configvalue = 0;
-	int ninterface = 0;
-	int i;
-	int failed = 0;
-
-	configvalue = read_bConfigurationValue(busid);
-	ninterface  = read_bNumInterfaces(busid);
-
-	if (configvalue < 0 || ninterface < 0) {
-		g_warning("read config and ninf value, removed?");
-		return -1;
-	}
-
- 	for (i = 0; i < ninterface; i++) {
-		int ret;
-
-		ret = bind_interface(busid, configvalue, i, "usbip");
-		if (ret < 0) {
-			g_warning("bind usbip at %s:%d.%d, failed",
-					busid, configvalue, i);
-			failed = 1;
-			/* need to contine binding at other interfaces */
-		}
-	}
-
-	if (failed)
-		return -1;
-	else
-		return 0;
-}
-
-
-static int use_device_by_usbip(char *busid)
-{
-	int ret;
-
-	ret = unbind(busid);
-	if (ret < 0) {
-		g_warning("unbind drivers of %s, failed", busid);
-		return -1;
-	}
-
-	ret = modify_match_busid(busid, 1);
-	if (ret < 0) {
-		g_warning("add %s to match_busid, failed", busid);
-		return -1;
-	}
-
-	ret = bind_to_usbip(busid);
-	if (ret < 0) {
-		g_warning("bind usbip to %s, failed", busid);
-		modify_match_busid(busid, 0);
-		return -1;
-	}
-
-	g_message("bind %s to usbip, complete!", busid);
-
-	return 0;
-}
-
-
-
-static int use_device_by_other(char *busid)
-{
-	int ret;
-	int config;
-
-	/* read and write the same config value to kick probing */
-	config = read_bConfigurationValue(busid);
-	if (config < 0) {
-		g_warning("read bConfigurationValue of %s, failed", busid);
-		return -1;
-	}
-
-	ret = modify_match_busid(busid, 0);
-	if (ret < 0) {
-		g_warning("del %s to match_busid, failed", busid);
-		return -1;
-	}
-
-	ret = write_bConfigurationValue(busid, config);
-	if (ret < 0) {
-		g_warning("read bConfigurationValue of %s, failed", busid);
-		return -1;
-	}
-
-	g_message("bind %s to other drivers than usbip, complete!", busid);
-
-	return 0;
-}
-
-
-#include <sys/types.h>
-#include <regex.h>
-
-#include <errno.h>
-#include <string.h>
-#include <stdio.h>
-
-
-
-static int is_usb_device(char *busid)
-{
-	int ret;
-
-	regex_t regex;
-	regmatch_t pmatch[1];
-
-	ret = regcomp(&regex, "^[0-9]+-[0-9]+(\\.[0-9]+)*$", REG_NOSUB|REG_EXTENDED);
-	if (ret < 0)
-		g_error("regcomp: %s\n", strerror(errno));
-
-	ret = regexec(&regex, busid, 0, pmatch, 0);
-	if (ret)
-		return 0;	/* not matched */
-
-	return 1;
-}
-
-
-#include <dirent.h>
-static int show_devices(void)
-{
-	DIR *dir;
-
-	dir = opendir("/sys/bus/usb/devices/");
-	if (!dir)
-		g_error("opendir: %s", strerror(errno));
-
-	printf("List USB devices\n");
-	for (;;) {
-		struct dirent *dirent;
-		char *busid;
-
-		dirent = readdir(dir);
-		if (!dirent)
-			break;
-
-		busid = dirent->d_name;
-
-		if (is_usb_device(busid)) {
-			char name[100] = {'\0'};
-			char driver[100] =  {'\0'};
-			int conf, ninf = 0;
-			int i;
-
-			conf = read_bConfigurationValue(busid);
-			ninf = read_bNumInterfaces(busid);
-
-			getdevicename(busid, name, sizeof(name));
-
-			printf(" - busid %s (%s)\n", busid, name);
-
-			for (i = 0; i < ninf; i++) {
-				getdriver(busid, conf, i, driver, sizeof(driver));
-				printf("         %s:%d.%d -> %s\n", busid, conf, i, driver);
-			}
-			printf("\n");
-		}
-	}
-
-	closedir(dir);
-
-	return 0;
-}
-
-static int show_devices2(void)
-{
-	DIR *dir;
-
-	dir = opendir("/sys/bus/usb/devices/");
-	if (!dir)
-		g_error("opendir: %s", strerror(errno));
-
-	for (;;) {
-		struct dirent *dirent;
-		char *busid;
-
-		dirent = readdir(dir);
-		if (!dirent)
-			break;
-
-		busid = dirent->d_name;
-
-		if (is_usb_device(busid)) {
-			char name[100] = {'\0'};
-			char driver[100] =  {'\0'};
-			int conf, ninf = 0;
-			int i;
-
-			conf = read_bConfigurationValue(busid);
-			ninf = read_bNumInterfaces(busid);
-
-			getdevicename(busid, name, sizeof(name));
-
-			printf("busid=%s#usbid=%s#", busid, name);
-
-			for (i = 0; i < ninf; i++) {
-				getdriver(busid, conf, i, driver, sizeof(driver));
-				printf("%s:%d.%d=%s#", busid, conf, i, driver);
-			}
-			printf("\n");
-		}
-	}
-
-	closedir(dir);
-
-	return 0;
-}
-
-
-#if 0
-static int export_to(char *host, char *busid) {
-
-	int ret;
-
-	if( host == NULL ) {
-		printf( "no host given\n\n");
-		show_help();
-		return -1;
-	}
-	if( busid == NULL ) {
-		/* XXX print device list and ask for busnumber, if none is
-		 * given */
-		printf( "no busid given, use --busid switch\n\n");
-		show_help();
-		return -1;
-	}
-
-
-	ret = use_device_by_usbip(busid);
-	if( ret != 0 ) {
-		printf( "could not bind driver to usbip\n");
-		return -1;
-	}
-
-	printf( "DEBUG: exporting device '%s' to '%s'\n", busid, host );
-	ret = export_busid_to_host(host, busid); /* usbip_export.[ch] */
-	if( ret != 0 ) {
-		printf( "could not export device to host\n" );
-		printf( "   host: %s, device: %s\n", host, busid );
-		use_device_by_other(busid);
-		return -1;
-	}
-
-	return 0;
-}
-
-static int unexport_from(char *host, char *busid) {
-
-	int ret;
-
-	if (!host || !busid)
-		g_error("no host or no busid\n");
-
-	g_message("unexport_from: host: '%s', busid: '%s'", host, busid);
-
-	ret = unexport_busid_from_host(host, busid); /* usbip_export.[ch] */
-	if( ret != 0 ) {
-		err( "could not unexport device from host\n" );
-		err( "   host: %s, device: %s\n", host, busid );
-	}
-
-	ret = use_device_by_other(busid);
-	if (ret < 0)
-		g_error("could not unbind device from usbip\n");
-
-	return 0;
-}
-
-
-static int allusbip(void)
-{
-	DIR *dir;
-
-	dir = opendir("/sys/bus/usb/devices/");
-	if (!dir)
-		g_error("opendir: %s", strerror(errno));
-
-	for (;;) {
-		struct dirent *dirent;
-		char *busid;
-
-		dirent = readdir(dir);
-		if (!dirent)
-			break;
-
-		busid = dirent->d_name;
-
-		if (!is_usb_device(busid))
-			continue;
-
-		{
-			char name[PATH_MAX];
-			int conf, ninf = 0;
-			int i;
-			int be_local = 0;
-
-			conf = read_bConfigurationValue(busid);
-			ninf = read_bNumInterfaces(busid);
-
-			getdevicename(busid, name, sizeof(name));
-
-			for (i = 0; i < ninf; i++) {
-				char driver[PATH_MAX];
-
-				getdriver(busid, conf, i, driver, sizeof(driver));
-#if 0
-				if (strncmp(driver, "usbhid", 6) == 0 || strncmp(driver, "usb-storage", 11) == 0) {
-					be_local = 1;
-					break;
-				}
-#endif
-			}
-			
-			if (be_local == 0)
-				use_device_by_usbip(busid);
-		}
-	}
-
-	closedir(dir);
-
-	return 0;
-}
-#endif
-
-int main(int argc, char **argv)
-{
-	char *busid = NULL;
-	char *remote_host = NULL;
-
-	enum {
-		cmd_unknown = 0,
-		cmd_use_by_usbip,
-		cmd_use_by_other,
-		cmd_list,
-		cmd_list2,
-		cmd_allusbip,
-		cmd_export_to,
-		cmd_unexport,
-		cmd_help,
-	} cmd = cmd_unknown;
-
-	if (geteuid() != 0)
-		g_warning("running non-root?");
-
-	for (;;) {
-		int c;
-		int index = 0;
-
-		c = getopt_long(argc, argv, "u:o:hlLae:x:b:", longopts, &index);
-		if (c == -1)
-			break;
-
-		switch (c) {
-			case 'u':
-				cmd = cmd_use_by_usbip;
-				busid = optarg;
-				break;
-			case 'o' :
-				cmd = cmd_use_by_other;
-				busid = optarg;
-				break;
-			case 'l' :
-				cmd = cmd_list;
-				break;
-			case 'L' :
-				cmd = cmd_list2;
-				break;
-			case 'a' :
-				cmd = cmd_allusbip;
-				break;
-			case 'b':
-				busid = optarg;
-				break;
-			case 'e':
-				cmd = cmd_export_to;
-				remote_host = optarg;
-				break;
-			case 'x':
-				cmd = cmd_unexport;
-				remote_host = optarg;
-				break;
-			case 'h': /* fallthrough */
-			case '?':
-				cmd = cmd_help;
-				break;
-			default:
-				g_error("getopt");
-		}
-
-		//if (cmd)
-		//	break;
-	}
-
-	switch (cmd) {
-		case cmd_use_by_usbip:
-			use_device_by_usbip(busid);
-			break;
-		case cmd_use_by_other:
-			use_device_by_other(busid);
-			break;
-		case cmd_list:
-			show_devices();
-			break;
-		case cmd_list2:
-			show_devices2();
-			break;
-#if 0
-		case cmd_allusbip:
-			allusbip();
-			break;
-		case cmd_export_to:
-			export_to(remote_host, busid);
-			break;
-		case cmd_unexport:
-			unexport_from(remote_host, busid);
-			break;
-#endif
-		case cmd_help: /* fallthrough */
-		case cmd_unknown:
-			show_help();
-			break;
-		default:
-			g_error("NOT REACHED");
-	}
-
-	return 0;
-}
diff --git a/drivers/staging/usbip/userspace/cmd/usbip.c b/drivers/staging/usbip/userspace/cmd/usbip.c
deleted file mode 100644
index 8775394..0000000
--- a/drivers/staging/usbip/userspace/cmd/usbip.c
+++ /dev/null
@@ -1,725 +0,0 @@
-/*
- * $Id$
- *
- * Copyright (C) 2005-2007 Takahiro Hirofuchi
- */
-
-#ifdef HAVE_CONFIG_H
-#include "../config.h"
-#endif
-
-#include "usbip.h"
-#include "usbip_network.h"
-#include <ctype.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <stdlib.h>
-#include <fcntl.h>
-#include <glib.h>
-
-static const char version[] = PACKAGE_STRING
-	" ($Id$)";
-
-
-/* /sys/devices/platform/vhci_hcd/usb6/6-1/6-1:1.1  -> 1 */
-static int get_interface_number(char *path)
-{
-	char *c;
-
-	c = strstr(path, vhci_driver->hc_device->bus_id);
-	if (!c)
-		return -1;	/* hc exist? */
-	c++;
-	/* -> usb6/6-1/6-1:1.1 */
-
-	c = strchr(c, '/');
-	if (!c)
-		return -1;	/* hc exist? */
-	c++;
-	/* -> 6-1/6-1:1.1 */
-
-	c = strchr(c, '/');
-	if (!c)
-		return -1;	/* no interface path */
-	c++;
-	/* -> 6-1:1.1 */
-
-	c = strchr(c, ':');
-	if (!c)
-		return -1;	/* no configuration? */
-	c++;
-	/* -> 1.1 */
-
-	c = strchr(c, '.');
-	if (!c)
-		return -1;	/* no interface? */
-	c++;
-	/* -> 1 */
-
-
-	return atoi(c);
-}
-
-
-static struct sysfs_device *open_usb_interface(struct usb_device *udev, int i)
-{
-	struct sysfs_device *suinf;
-	char busid[SYSFS_BUS_ID_SIZE];
-
-	snprintf(busid, SYSFS_BUS_ID_SIZE, "%s:%d.%d",
-			udev->busid, udev->bConfigurationValue, i);
-
-	suinf = sysfs_open_device("usb", busid);
-	if (!suinf)
-		err("sysfs_open_device %s", busid);
-
-	return suinf;
-}
-
-
-#define MAX_BUFF 100
-static int record_connection(char *host, char *port, char *busid, int rhport)
-{
-	int fd;
-	char path[PATH_MAX+1];
-	char buff[MAX_BUFF+1];
-	int ret;
-
-	mkdir(VHCI_STATE_PATH, 0700);
-
-	snprintf(path, PATH_MAX, VHCI_STATE_PATH"/port%d", rhport);
-
-	fd = open(path, O_WRONLY|O_CREAT|O_TRUNC, S_IRWXU);
-	if (fd < 0)
-		return -1;
-
-	snprintf(buff, MAX_BUFF, "%s %s %s\n",
-			host, port, busid);
-
-	ret = write(fd, buff, strlen(buff));
-	if (ret != (ssize_t) strlen(buff)) {
-		close(fd);
-		return -1;
-	}
-
-	close(fd);
-
-	return 0;
-}
-
-static int read_record(int rhport, char *host, char *port, char *busid)
-{
-	FILE *file;
-	char path[PATH_MAX+1];
-
-	snprintf(path, PATH_MAX, VHCI_STATE_PATH"/port%d", rhport);
-
-	file = fopen(path, "r");
-	if (!file) {
-		err("fopen");
-		return -1;
-	}
-
-	if (fscanf(file, "%s %s %s\n", host, port, busid) != 3) {
-		err("fscanf");
-		fclose(file);
-		return -1;
-	}
-
-	fclose(file);
-
-	return 0;
-}
-
-
-int usbip_vhci_imported_device_dump(struct usbip_imported_device *idev)
-{
-	char product_name[100];
-	char host[NI_MAXHOST] = "unknown host";
-	char serv[NI_MAXSERV] = "unknown port";
-	char remote_busid[SYSFS_BUS_ID_SIZE];
-	int ret;
-
-	if (idev->status == VDEV_ST_NULL || idev->status == VDEV_ST_NOTASSIGNED) {
-		info("Port %02d: <%s>", idev->port, usbip_status_string(idev->status));
-		return 0;
-	}
-
-	ret = read_record(idev->port, host, serv, remote_busid);
-	if (ret) {
-		err("read_record");
-		return -1;
-	}
-
-	info("Port %02d: <%s> at %s", idev->port,
-			usbip_status_string(idev->status), usbip_speed_string(idev->udev.speed));
-
-	usbip_names_get_product(product_name, sizeof(product_name),
-			idev->udev.idVendor, idev->udev.idProduct);
-
-	info("       %s",  product_name);
-
-	info("%10s -> usbip://%s:%s/%s  (remote devid %08x (bus/dev %03d/%03d))",
-			idev->udev.busid, host, serv, remote_busid,
-			idev->devid,
-			idev->busnum, idev->devnum);
-
-	for (int i=0; i < idev->udev.bNumInterfaces; i++) {
-		/* show interface information */
-		struct sysfs_device *suinf;
-
-		suinf = open_usb_interface(&idev->udev, i);
-		if (!suinf)
-			continue;
-
-		info("       %6s used by %-17s", suinf->bus_id, suinf->driver_name);
-		sysfs_close_device(suinf);
-
-		/* show class device information */
-		struct class_device *cdev;
-
-		dlist_for_each_data(idev->cdev_list, cdev, struct class_device) {
-			int ifnum = get_interface_number(cdev->devpath);
-			if (ifnum == i) {
-				info("           %s", cdev->clspath);
-			}
-		}
-	}
-
-	return 0;
-}
-
-
-
-
-static int query_exported_devices(int sockfd)
-{
-	int ret;
-	struct op_devlist_reply rep;
-	uint16_t code = OP_REP_DEVLIST;
-
-	bzero(&rep, sizeof(rep));
-
-	ret = usbip_send_op_common(sockfd, OP_REQ_DEVLIST, 0);
-	if (ret < 0) {
-		err("send op_common");
-		return -1;
-	}
-
-	ret = usbip_recv_op_common(sockfd, &code);
-	if (ret < 0) {
-		err("recv op_common");
-		return -1;
-	}
-
-	ret = usbip_recv(sockfd, (void *) &rep, sizeof(rep));
-	if (ret < 0) {
-		err("recv op_devlist");
-		return -1;
-	}
-
-	PACK_OP_DEVLIST_REPLY(0, &rep);
-	dbg("exportable %d devices", rep.ndev);
-
-	for (unsigned int i=0; i < rep.ndev; i++) {
-		char product_name[100];
-		char class_name[100];
-		struct usb_device udev;
-
-		bzero(&udev, sizeof(udev));
-
-		ret = usbip_recv(sockfd, (void *) &udev, sizeof(udev));
-		if (ret < 0) {
-			err("recv usb_device[%d]", i);
-			return -1;
-		}
-		pack_usb_device(0, &udev);
-
-		usbip_names_get_product(product_name, sizeof(product_name),
-				udev.idVendor, udev.idProduct);
-		usbip_names_get_class(class_name, sizeof(class_name), udev.bDeviceClass,
-				udev.bDeviceSubClass, udev.bDeviceProtocol);
-
-		info("%8s: %s", udev.busid, product_name);
-		info("%8s: %s", " ", udev.path);
-		info("%8s: %s", " ", class_name);
-
-		for (int j=0; j < udev.bNumInterfaces; j++) {
-			struct usb_interface uinf;
-
-			ret = usbip_recv(sockfd, (void *) &uinf, sizeof(uinf));
-			if (ret < 0) {
-				err("recv usb_interface[%d]", j);
-				return -1;
-			}
-
-			pack_usb_interface(0, &uinf);
-			usbip_names_get_class(class_name, sizeof(class_name), uinf.bInterfaceClass,
-					uinf.bInterfaceSubClass, uinf.bInterfaceProtocol);
-
-			info("%8s: %2d - %s", " ", j, class_name);
-		}
-
-		info(" ");
-	}
-
-	return rep.ndev;
-}
-
-static int import_device(int sockfd, struct usb_device *udev)
-{
-	int ret;
-	int port;
-
-	ret = usbip_vhci_driver_open();
-	if (ret < 0) {
-		err("open vhci_driver");
-		return -1;
-	}
-
-	port = usbip_vhci_get_free_port();
-	if (port < 0) {
-		err("no free port");
-		usbip_vhci_driver_close();
-		return -1;
-	}
-
-	ret = usbip_vhci_attach_device(port, sockfd, udev->busnum,
-			udev->devnum, udev->speed);
-	if (ret < 0) {
-		err("import device");
-		usbip_vhci_driver_close();
-		return -1;
-	}
-
-	usbip_vhci_driver_close();
-
-	return port;
-}
-
-
-static int query_import_device(int sockfd, char *busid)
-{
-	int ret;
-	struct op_import_request request;
-	struct op_import_reply   reply;
-	uint16_t code = OP_REP_IMPORT;
-
-	bzero(&request, sizeof(request));
-	bzero(&reply, sizeof(reply));
-
-
-	/* send a request */
-	ret = usbip_send_op_common(sockfd, OP_REQ_IMPORT, 0);
-	if (ret < 0) {
-		err("send op_common");
-		return -1;
-	}
-
-	strncpy(request.busid, busid, SYSFS_BUS_ID_SIZE-1);
-
-	PACK_OP_IMPORT_REQUEST(0, &request);
-
-	ret = usbip_send(sockfd, (void *) &request, sizeof(request));
-	if (ret < 0) {
-		err("send op_import_request");
-		return -1;
-	}
-
-
-	/* recieve a reply */
-	ret = usbip_recv_op_common(sockfd, &code);
-	if (ret < 0) {
-		err("recv op_common");
-		return -1;
-	}
-
-	ret = usbip_recv(sockfd, (void *) &reply, sizeof(reply));
-	if (ret < 0) {
-		err("recv op_import_reply");
-		return -1;
-	}
-
-	PACK_OP_IMPORT_REPLY(0, &reply);
-
-
-	/* check the reply */
-	if (strncmp(reply.udev.busid, busid, SYSFS_BUS_ID_SIZE)) {
-		err("recv different busid %s", reply.udev.busid);
-		return -1;
-	}
-
-
-	/* import a device */
-	return import_device(sockfd, &reply.udev);
-}
-
-static int attach_device(char *host, char *busid)
-{
-	int sockfd;
-	int ret;
-	int rhport;
-
-	sockfd = tcp_connect(host, USBIP_PORT_STRING);
-	if (sockfd < 0) {
-		err("tcp connect");
-		return -1;
-	}
-
-	rhport = query_import_device(sockfd, busid);
-	if (rhport < 0) {
-		err("query");
-		return -1;
-	}
-
-	close(sockfd);
-
-	ret = record_connection(host, USBIP_PORT_STRING,
-			busid, rhport);
-	if (ret < 0) {
-		err("record connection");
-		return -1;
-	}
-
-	return 0;
-}
-
-static int detach_port(char *port)
-{
-	int ret;
-	uint8_t portnum;
-
-	for (unsigned int i=0; i < strlen(port); i++)
-		if (!isdigit(port[i])) {
-			err("invalid port %s", port);
-			return -1;
-		}
-
-	/* check max port */
-
-	portnum = atoi(port);
-
-	ret = usbip_vhci_driver_open();
-	if (ret < 0) {
-		err("open vhci_driver");
-		return -1;
-	}
-
-	ret = usbip_vhci_detach_device(portnum);
-	if (ret < 0)
-		return -1;
-
-	usbip_vhci_driver_close();
-
-	return ret;
-}
-
-static int show_exported_devices(char *host)
-{
-	int ret;
-	int sockfd;
-
-	sockfd = tcp_connect(host, USBIP_PORT_STRING);
-	if (sockfd < 0) {
-		err("- %s failed", host);
-		return -1;
-	}
-
-	info("- %s", host);
-
-	ret = query_exported_devices(sockfd);
-	if (ret < 0) {
-		err("query");
-		return -1;
-	}
-
-	close(sockfd);
-	return 0;
-}
-
-static int attach_exported_devices(char *host, int sockfd)
-{
-	int ret;
-	struct op_devlist_reply rep;
-	uint16_t code = OP_REP_DEVLIST;
-
-	bzero(&rep, sizeof(rep));
-
-	ret = usbip_send_op_common(sockfd, OP_REQ_DEVLIST, 0);
-	if(ret < 0) {
-		err("send op_common");
-		return -1;
-	}
-
-	ret = usbip_recv_op_common(sockfd, &code);
-	if(ret < 0) {
-		err("recv op_common");
-		return -1;
-	}
-
-	ret = usbip_recv(sockfd, (void *) &rep, sizeof(rep));
-	if(ret < 0) {
-		err("recv op_devlist");
-		return -1;
-	}
-
-	PACK_OP_DEVLIST_REPLY(0, &rep);
-	dbg("exportable %d devices", rep.ndev);
-
-	for(unsigned int i=0; i < rep.ndev; i++) {
-		char product_name[100];
-		char class_name[100];
-		struct usb_device udev;
-
-		bzero(&udev, sizeof(udev));
-
-		ret = usbip_recv(sockfd, (void *) &udev, sizeof(udev));
-		if(ret < 0) {
-			err("recv usb_device[%d]", i);
-			return -1;
-		}
-		pack_usb_device(0, &udev);
-
-		usbip_names_get_product(product_name, sizeof(product_name),
-				udev.idVendor, udev.idProduct);
-		usbip_names_get_class(class_name, sizeof(class_name), udev.bDeviceClass,
-				udev.bDeviceSubClass, udev.bDeviceProtocol);
-
-		dbg("Attaching usb port %s from host %s on usbip, with deviceid: %s", udev.busid, host, product_name);
-
-		for (int j=0; j < udev.bNumInterfaces; j++) {
-			struct usb_interface uinf;
-
-			ret = usbip_recv(sockfd, (void *) &uinf, sizeof(uinf));
-			if (ret < 0) {
-				err("recv usb_interface[%d]", j);
-				return -1;
-			}
-
-			pack_usb_interface(0, &uinf);
-			usbip_names_get_class(class_name, sizeof(class_name), uinf.bInterfaceClass,
-					uinf.bInterfaceSubClass, uinf.bInterfaceProtocol);
-
-			dbg("interface %2d - %s", j, class_name);
-		}
-
-		attach_device(host, udev.busid);
-	}
-
-	return rep.ndev;
-}
-
-static int attach_devices_all(char *host)
-{
-	int ret;
-	int sockfd;
-
-	sockfd = tcp_connect(host, USBIP_PORT_STRING);
-	if(sockfd < 0) {
-		err("- %s failed", host);
-		return -1;
-	}
-
-	info("- %s", host);
-
-	ret = attach_exported_devices(host, sockfd);
-	if(ret < 0) {
-		err("query");
-		return -1;
-	}
-
-	close(sockfd);
-	return 0;
-}
-
-
-const char help_message[] = "\
-Usage: usbip [options]				\n\
-	-a, --attach [host] [bus_id]		\n\
-		Attach a remote USB device.	\n\
-						\n\
-	-x, --attachall [host]		\n\
-		Attach all remote USB devices on the specific host.	\n\
-						\n\
-	-d, --detach [ports]			\n\
-		Detach an imported USB device.	\n\
-						\n\
-	-l, --list [hosts]			\n\
-		List exported USB devices.	\n\
-						\n\
-	-p, --port				\n\
-		List virtual USB port status. 	\n\
-						\n\
-	-D, --debug				\n\
-		Print debugging information.	\n\
-						\n\
-	-v, --version				\n\
-		Show version.			\n\
-						\n\
-	-h, --help 				\n\
-		Print this help.		\n";
-
-static void show_help(void)
-{
-	printf("%s", help_message);
-}
-
-static int show_port_status(void)
-{
-	int ret;
-	struct usbip_imported_device *idev;
-
-	ret = usbip_vhci_driver_open();
-	if (ret < 0)
-		return ret;
-
-	for (int i = 0; i < vhci_driver->nports; i++) {
-		idev = &vhci_driver->idev[i];
-
-		if (usbip_vhci_imported_device_dump(idev) < 0)
-			ret = -1;
-	}
-
-	usbip_vhci_driver_close();
-
-	return ret;
-}
-
-#define _GNU_SOURCE
-#include <getopt.h>
-static const struct option longopts[] = {
-	{"attach",	no_argument,	NULL, 'a'},
-	{"attachall",	no_argument,	NULL, 'x'},
-	{"detach",	no_argument,	NULL, 'd'},
-	{"port",	no_argument,	NULL, 'p'},
-	{"list",	no_argument,	NULL, 'l'},
-	{"version",	no_argument,	NULL, 'v'},
-	{"help",	no_argument,	NULL, 'h'},
-	{"debug",	no_argument,	NULL, 'D'},
-	{"syslog",	no_argument,	NULL, 'S'},
-	{NULL,		0,		NULL,  0}
-};
-
-int main(int argc, char *argv[])
-{
-	int ret;
-
-	enum {
-		cmd_attach = 1,
-		cmd_attachall,
-		cmd_detach,
-		cmd_port,
-		cmd_list,
-		cmd_help,
-		cmd_version
-	} cmd = 0;
-
-	usbip_use_stderr = 1;
-
-	if (geteuid() != 0)
-		g_warning("running non-root?");
-
- 	ret = usbip_names_init(USBIDS_FILE);
- 	if (ret)
- 		notice("failed to open %s", USBIDS_FILE);
-
-	for (;;) {
-		int c;
-		int index = 0;
-
-		c = getopt_long(argc, argv, "adplvhDSx", longopts, &index);
-
-		if (c == -1)
-			break;
-
-		switch(c) {
-			case 'a':
-				if (!cmd)
-					cmd = cmd_attach;
-				else
-					cmd = cmd_help;
-				break;
-			case 'd':
-				if (!cmd)
-					cmd = cmd_detach;
-				else
-					cmd = cmd_help;
-				break;
-			case 'p':
-				if (!cmd)
-					cmd = cmd_port;
-				else cmd = cmd_help;
-				break;
-			case 'l':
-				if (!cmd)
-					cmd = cmd_list;
-				else
-					cmd = cmd_help;
-				break;
-			case 'v':
-				if (!cmd)
-					cmd = cmd_version;
-				else
-					cmd = cmd_help;
-				break;
-			case 'x':
-				if(!cmd)
-					cmd = cmd_attachall;
-				else
-					cmd = cmd_help;
-				break;
-			case 'h':
-				cmd = cmd_help;
-				break;
-			case 'D':
-				usbip_use_debug = 1;
-				break;
-			case 'S':
-				usbip_use_syslog = 1;
-				break;
-			case '?':
-				break;
-
-			default:
-				err("getopt");
-		}
-	}
-
-	ret = 0;
-	switch(cmd) {
-		case cmd_attach:
-			if (optind == argc - 2)
-				ret = attach_device(argv[optind], argv[optind+1]);
-			else
-				show_help();
-			break;
-		case cmd_detach:
-			while (optind < argc)
-				ret = detach_port(argv[optind++]);
-			break;
-		case cmd_port:
-			ret = show_port_status();
-			break;
-		case cmd_list:
-			while (optind < argc)
-				ret = show_exported_devices(argv[optind++]);
-			break;
-		case cmd_attachall:
-			while(optind < argc)
-				ret = attach_devices_all(argv[optind++]);
-			break;
-		case cmd_version:
-			printf("%s\n", version);
-			break;
-		case cmd_help:
-			show_help();
-			break;
-		default:
-			show_help();
-	}
-
-
-	usbip_names_free();
-
-	exit((ret == 0) ? EXIT_SUCCESS : EXIT_FAILURE);
-}
diff --git a/drivers/staging/usbip/userspace/cmd/usbip_network.c b/drivers/staging/usbip/userspace/cmd/usbip_network.c
deleted file mode 100644
index a3a955b..0000000
--- a/drivers/staging/usbip/userspace/cmd/usbip_network.c
+++ /dev/null
@@ -1,251 +0,0 @@
-/*
- * $Id$
- *
- * Copyright (C) 2005-2007 Takahiro Hirofuchi
- */
-
-#include "usbip_network.h"
-
-void pack_uint32_t(int pack, uint32_t *num)
-{
-	uint32_t i;
-
-	if (pack)
-		i = htonl(*num);
-	else
-		i = ntohl(*num);
-
-	*num = i;
-}
-
-void pack_uint16_t(int pack, uint16_t *num)
-{
-	uint16_t i;
-
-	if (pack)
-		i = htons(*num);
-	else
-		i = ntohs(*num);
-
-	*num = i;
-}
-
-void pack_usb_device(int pack, struct usb_device *udev)
-{
-	pack_uint32_t(pack, &udev->busnum);
-	pack_uint32_t(pack, &udev->devnum);
-	pack_uint32_t(pack, &udev->speed );
-
-	pack_uint16_t(pack, &udev->idVendor );
-	pack_uint16_t(pack, &udev->idProduct);
-	pack_uint16_t(pack, &udev->bcdDevice);
-}
-
-void pack_usb_interface(int pack, struct usb_interface *udev)
-{
-	/* uint8_t members need nothing */
-}
-
-
-static ssize_t usbip_xmit(int sockfd, void *buff, size_t bufflen, int sending)
-{
-	ssize_t total = 0;
-
-	if (!bufflen)
-		return 0;
-
-	do {
-		ssize_t nbytes;
-
-		if (sending)
-			nbytes = send(sockfd, buff, bufflen, 0);
-		else
-			nbytes = recv(sockfd, buff, bufflen, MSG_WAITALL);
-
-		if (nbytes <= 0)
-			return -1;
-
-		buff	= (void *) ((intptr_t) buff + nbytes);
-		bufflen	-= nbytes;
-		total	+= nbytes;
-
-	} while (bufflen > 0);
-
-
-	return total;
-}
-
-ssize_t usbip_recv(int sockfd, void *buff, size_t bufflen)
-{
-	return usbip_xmit(sockfd, buff, bufflen, 0);
-}
-
-ssize_t usbip_send(int sockfd, void *buff, size_t bufflen)
-{
-	return usbip_xmit(sockfd, buff, bufflen, 1);
-}
-
-int usbip_send_op_common(int sockfd, uint32_t code, uint32_t status)
-{
-	int ret;
-	struct op_common op_common;
-
-	bzero(&op_common, sizeof(op_common));
-
-	op_common.version	= USBIP_VERSION;
-	op_common.code		= code;
-	op_common.status	= status;
-
-	PACK_OP_COMMON(1, &op_common);
-
-	ret = usbip_send(sockfd, (void *) &op_common, sizeof(op_common));
-	if (ret < 0) {
-		err("send op_common");
-		return -1;
-	}
-
-	return 0;
-}
-
-int usbip_recv_op_common(int sockfd, uint16_t *code)
-{
-	int ret;
-	struct op_common op_common;
-
-	bzero(&op_common, sizeof(op_common));
-
-	ret = usbip_recv(sockfd, (void *) &op_common, sizeof(op_common));
-	if (ret < 0) {
-		err("recv op_common, %d", ret);
-		goto err;
-	}
-
-	PACK_OP_COMMON(0, &op_common);
-
-	if (op_common.version != USBIP_VERSION) {
-		err("version mismatch, %d %d", op_common.version, USBIP_VERSION);
-		goto err;
-	}
-
-	switch(*code) {
-		case OP_UNSPEC:
-			break;
-		default:
-			if (op_common.code != *code) {
-				info("unexpected pdu %d for %d", op_common.code, *code);
-				goto err;
-			}
-	}
-
-	if (op_common.status != ST_OK) {
-		info("request failed at peer, %d", op_common.status);
-		goto err;
-	}
-
-	*code = op_common.code;
-
-	return 0;
-err:
-	return -1;
-}
-
-
-int usbip_set_reuseaddr(int sockfd)
-{
-	const int val = 1;
-	int ret;
-
-	ret = setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val));
-	if (ret < 0)
-		err("setsockopt SO_REUSEADDR");
-
-	return ret;
-}
-
-int usbip_set_nodelay(int sockfd)
-{
-	const int val = 1;
-	int ret;
-
-	ret = setsockopt(sockfd, IPPROTO_TCP, TCP_NODELAY, &val, sizeof(val));
-	if (ret < 0)
-		err("setsockopt TCP_NODELAY");
-
-	return ret;
-}
-
-int usbip_set_keepalive(int sockfd)
-{
-	const int val = 1;
-	int ret;
-
-	ret = setsockopt(sockfd, SOL_SOCKET, SO_KEEPALIVE, &val, sizeof(val));
-	if (ret < 0)
-		err("setsockopt SO_KEEPALIVE");
-
-	return ret;
-}
-
-/* IPv6 Ready */
-/*
- * moved here from vhci_attach.c
- */
-int tcp_connect(char *hostname, char *service)
-{
-	struct addrinfo hints, *res, *res0;
-	int sockfd;
-	int err;
-
-
-	memset(&hints, 0, sizeof(hints));
-	hints.ai_socktype = SOCK_STREAM;
-
-	/* get all possible addresses */
-	err = getaddrinfo(hostname, service, &hints, &res0);
-	if (err) {
-		err("%s %s: %s", hostname, service, gai_strerror(err));
-		return -1;
-	}
-
-	/* try all the addresses */
-	for (res = res0; res; res = res->ai_next) {
-		char hbuf[NI_MAXHOST], sbuf[NI_MAXSERV];
-
-		err = getnameinfo(res->ai_addr, res->ai_addrlen,
-				hbuf, sizeof(hbuf), sbuf, sizeof(sbuf), NI_NUMERICHOST | NI_NUMERICSERV);
-		if (err) {
-			err("%s %s: %s", hostname, service, gai_strerror(err));
-			continue;
-		}
-
-		dbg("trying %s port %s\n", hbuf, sbuf);
-
-		sockfd = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
-		if (sockfd < 0) {
-			err("socket");
-			continue;
-		}
-
-		/* should set TCP_NODELAY for usbip */
-		usbip_set_nodelay(sockfd);
-		/* TODO: write code for heatbeat */
-		usbip_set_keepalive(sockfd);
-
-		err = connect(sockfd, res->ai_addr, res->ai_addrlen);
-		if (err < 0) {
-			close(sockfd);
-			continue;
-		}
-
-		/* connected */
-		dbg("connected to %s:%s", hbuf, sbuf);
-		freeaddrinfo(res0);
-		return sockfd;
-	}
-
-
-	dbg("%s:%s, %s", hostname, service, "no destination to connect to");
-	freeaddrinfo(res0);
-
-	return -1;
-}
diff --git a/drivers/staging/usbip/userspace/cmd/usbip_network.h b/drivers/staging/usbip/userspace/cmd/usbip_network.h
deleted file mode 100644
index 804f83d..0000000
--- a/drivers/staging/usbip/userspace/cmd/usbip_network.h
+++ /dev/null
@@ -1,198 +0,0 @@
-/*
- * Copyright (C) 2005-2007 Takahiro Hirofuchi
- */
-
-#ifndef _USBIP_NETWORK_H
-#define _USBIP_NETWORK_H
-
-#include "usbip.h"
-#include <sys/types.h>
-#include <sys/socket.h>
-#include <netinet/tcp.h>
-
-
-/* -------------------------------------------------- */
-/* Define Protocol Format                             */
-/* -------------------------------------------------- */
-
-
-/* ---------------------------------------------------------------------- */
-/* Common header for all the kinds of PDUs. */
-struct op_common {
-	uint16_t version;
-
-#define OP_REQUEST	(0x80 << 8)
-#define OP_REPLY	(0x00 << 8)
-	uint16_t code;
-
-	/* add more error code */
-#define ST_OK	0x00
-#define ST_NA	0x01
-	uint32_t status; /* op_code status (for reply) */
-
-} __attribute__((packed));
-
-#define PACK_OP_COMMON(pack, op_common)  do {\
-	pack_uint16_t(pack, &(op_common)->version);\
-	pack_uint16_t(pack, &(op_common)->code   );\
-	pack_uint32_t(pack, &(op_common)->status );\
-} while (0)
-
-
-/* ---------------------------------------------------------------------- */
-/* Dummy Code */
-#define OP_UNSPEC	0x00
-#define OP_REQ_UNSPEC	OP_UNSPEC
-#define OP_REP_UNSPEC	OP_UNSPEC
-
-/* ---------------------------------------------------------------------- */
-/* Retrieve USB device information. (still not used) */
-#define OP_DEVINFO	0x02
-#define OP_REQ_DEVINFO	(OP_REQUEST | OP_DEVINFO)
-#define OP_REP_DEVINFO	(OP_REPLY   | OP_DEVINFO)
-
-struct op_devinfo_request {
-	char busid[SYSFS_BUS_ID_SIZE];
-} __attribute__((packed));
-
-struct op_devinfo_reply {
-	struct usb_device udev;
-	struct usb_interface uinf[];
-} __attribute__((packed));
-
-
-/* ---------------------------------------------------------------------- */
-/* Import a remote USB device. */
-#define OP_IMPORT	0x03
-#define OP_REQ_IMPORT	(OP_REQUEST | OP_IMPORT)
-#define OP_REP_IMPORT   (OP_REPLY   | OP_IMPORT)
-
-struct op_import_request {
-	char busid[SYSFS_BUS_ID_SIZE];
-} __attribute__((packed));
-
-struct op_import_reply {
-	struct usb_device udev;
-//	struct usb_interface uinf[];
-} __attribute__((packed));
-
-#define PACK_OP_IMPORT_REQUEST(pack, request)  do {\
-} while (0)
-
-#define PACK_OP_IMPORT_REPLY(pack, reply)  do {\
-	pack_usb_device(pack, &(reply)->udev);\
-} while (0)
-
-
-
-/* ---------------------------------------------------------------------- */
-/* Export a USB device to a remote host. */
-#define OP_EXPORT	0x06
-#define OP_REQ_EXPORT	(OP_REQUEST | OP_EXPORT)
-#define OP_REP_EXPORT	(OP_REPLY   | OP_EXPORT)
-
-struct op_export_request {
-	struct usb_device udev;
-} __attribute__((packed));
-
-struct op_export_reply {
-	int returncode; 
-} __attribute__((packed));
-
-
-#define PACK_OP_EXPORT_REQUEST(pack, request)  do {\
-	pack_usb_device(pack, &(request)->udev);\
-} while (0)
-
-#define PACK_OP_EXPORT_REPLY(pack, reply)  do {\
-} while (0)
-
-/* ---------------------------------------------------------------------- */
-/* un-Export a USB device from a remote host. */
-#define OP_UNEXPORT	0x07
-#define OP_REQ_UNEXPORT	(OP_REQUEST | OP_UNEXPORT)
-#define OP_REP_UNEXPORT	(OP_REPLY   | OP_UNEXPORT)
-
-struct op_unexport_request {
-	struct usb_device udev;
-} __attribute__((packed));
-
-struct op_unexport_reply {
-	int returncode; 
-} __attribute__((packed));
-
-#define PACK_OP_UNEXPORT_REQUEST(pack, request)  do {\
-	pack_usb_device(pack, &(request)->udev);\
-} while (0)
-
-#define PACK_OP_UNEXPORT_REPLY(pack, reply)  do {\
-} while (0)
-
-
-
-/* ---------------------------------------------------------------------- */
-/* Negotiate IPSec encryption key. (still not used) */
-#define OP_CRYPKEY	0x04
-#define OP_REQ_CRYPKEY	(OP_REQUEST | OP_CRYPKEY)
-#define OP_REP_CRYPKEY	(OP_REPLY   | OP_CRYPKEY)
-
-struct op_crypkey_request {
-	/* 128bit key */
-	uint32_t key[4];
-} __attribute__((packed));
-
-struct op_crypkey_reply {
-	uint32_t __reserved;
-} __attribute__((packed));
-
-
-/* ---------------------------------------------------------------------- */
-/* Retrieve the list of exported USB devices. */
-#define OP_DEVLIST	0x05
-#define OP_REQ_DEVLIST	(OP_REQUEST | OP_DEVLIST)
-#define OP_REP_DEVLIST	(OP_REPLY   | OP_DEVLIST)
-
-struct op_devlist_request {
-} __attribute__((packed));
-
-struct op_devlist_reply {
-	uint32_t ndev;
-	/* followed by reply_extra[] */
-} __attribute__((packed));
-
-struct op_devlist_reply_extra {
-	struct usb_device    udev;
-	struct usb_interface uinf[];
-} __attribute__((packed));
-
-#define PACK_OP_DEVLIST_REQUEST(pack, request)  do {\
-} while (0)
-
-#define PACK_OP_DEVLIST_REPLY(pack, reply)  do {\
-	pack_uint32_t(pack, &(reply)->ndev);\
-} while (0)
-
-
-/* -------------------------------------------------- */
-/* Declare Prototype Function                         */
-/* -------------------------------------------------- */
-
-void pack_uint32_t(int pack, uint32_t *num);
-void pack_uint16_t(int pack, uint16_t *num);
-void pack_usb_device(int pack, struct usb_device *udev);
-void pack_usb_interface(int pack, struct usb_interface *uinf);
-
-ssize_t usbip_recv(int sockfd, void *buff, size_t bufflen);
-ssize_t usbip_send(int sockfd, void *buff, size_t bufflen);
-int usbip_send_op_common(int sockfd, uint32_t code, uint32_t status);
-int usbip_recv_op_common(int sockfd, uint16_t *code);
-int usbip_set_reuseaddr(int sockfd);
-int usbip_set_nodelay(int sockfd);
-int usbip_set_keepalive(int sockfd);
-
-int tcp_connect(char *hostname, char *service);
-
-#define USBIP_PORT 3240
-#define USBIP_PORT_STRING "3240"
-
-#endif
diff --git a/drivers/staging/usbip/userspace/cmd/usbipd.c b/drivers/staging/usbip/userspace/cmd/usbipd.c
deleted file mode 100644
index 441dcde..0000000
--- a/drivers/staging/usbip/userspace/cmd/usbipd.c
+++ /dev/null
@@ -1,571 +0,0 @@
-/*
- * $Id$
- *
- * Copyright (C) 2005-2007 Takahiro Hirofuchi
- */
-
-#ifdef HAVE_CONFIG_H
-#include "../config.h"
-#endif
-
-#include <unistd.h>
-#include <netdb.h>
-#include <strings.h>
-#include <stdlib.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <arpa/inet.h>
-#include <sys/socket.h>
-#include <netinet/in.h>
-
-#ifdef HAVE_LIBWRAP
-#include <tcpd.h>
-#endif
-
-#define _GNU_SOURCE
-#include <getopt.h>
-#include <signal.h>
-
-#include "usbip.h"
-#include "usbip_network.h"
-
-#include <glib.h>
-
-static const char version[] = PACKAGE_STRING
-	" ($Id$)";
-
-
-static int send_reply_devlist(int sockfd)
-{
-	int ret;
-	struct usbip_exported_device *edev;
-	struct op_devlist_reply reply;
-
-
-	reply.ndev = 0;
-
-	/* how many devices are exported ? */
-	dlist_for_each_data(stub_driver->edev_list, edev, struct usbip_exported_device) {
-		reply.ndev += 1;
-	}
-
-	dbg("%d devices are exported", reply.ndev);
-
-	ret = usbip_send_op_common(sockfd, OP_REP_DEVLIST,  ST_OK);
-	if (ret < 0) {
-		err("send op_common");
-		return ret;
-	}
-
-	PACK_OP_DEVLIST_REPLY(1, &reply);
-
-	ret = usbip_send(sockfd, (void *) &reply, sizeof(reply));
-	if (ret < 0) {
-		err("send op_devlist_reply");
-		return ret;
-	}
-
-	dlist_for_each_data(stub_driver->edev_list, edev, struct usbip_exported_device) {
-		struct usb_device pdu_udev;
-
-		dump_usb_device(&edev->udev);
-		memcpy(&pdu_udev, &edev->udev, sizeof(pdu_udev));
-		pack_usb_device(1, &pdu_udev);
-
-		ret = usbip_send(sockfd, (void *) &pdu_udev, sizeof(pdu_udev));
-		if (ret < 0) {
-			err("send pdu_udev");
-			return ret;
-		}
-
-		for (int i=0; i < edev->udev.bNumInterfaces; i++) {
-			struct usb_interface pdu_uinf;
-
-			dump_usb_interface(&edev->uinf[i]);
-			memcpy(&pdu_uinf, &edev->uinf[i], sizeof(pdu_uinf));
-			pack_usb_interface(1, &pdu_uinf);
-
-			ret = usbip_send(sockfd, (void *) &pdu_uinf, sizeof(pdu_uinf));
-			if (ret < 0) {
-				err("send pdu_uinf");
-				return ret;
-			}
-		}
-	}
-
-	return 0;
-}
-
-
-static int recv_request_devlist(int sockfd)
-{
-	int ret;
-	struct op_devlist_request req;
-
-	bzero(&req, sizeof(req));
-
-	ret = usbip_recv(sockfd, (void *) &req, sizeof(req));
-	if (ret < 0) {
-		err("recv devlist request");
-		return -1;
-	}
-
-	ret = send_reply_devlist(sockfd);
-	if (ret < 0) {
-		err("send devlist reply");
-		return -1;
-	}
-
-	return 0;
-}
-
-
-static int recv_request_import(int sockfd)
-{
-	int ret;
-	struct op_import_request req;
-	struct op_common reply;
-	struct usbip_exported_device *edev;
-	int found = 0;
-	int error = 0;
-
-	bzero(&req, sizeof(req));
-	bzero(&reply, sizeof(reply));
-
-	ret = usbip_recv(sockfd, (void *) &req, sizeof(req));
-	if (ret < 0) {
-		err("recv import request");
-		return -1;
-	}
-
-	PACK_OP_IMPORT_REQUEST(0, &req);
-
-	dlist_for_each_data(stub_driver->edev_list, edev, struct usbip_exported_device) {
-		if (!strncmp(req.busid, edev->udev.busid, SYSFS_BUS_ID_SIZE)) {
-			dbg("found requested device %s", req.busid);
-			found = 1;
-			break;
-		}
-	}
-
-	if (found) {
-		/* should set TCP_NODELAY for usbip */
-		usbip_set_nodelay(sockfd);
-
-		/* export_device needs a TCP/IP socket descriptor */
-		ret = usbip_stub_export_device(edev, sockfd);
-		if (ret < 0)
-			error = 1;
-	} else {
-		info("not found requested device %s", req.busid);
-		error = 1;
-	}
-
-
-	ret = usbip_send_op_common(sockfd, OP_REP_IMPORT, (!error ? ST_OK : ST_NA));
-	if (ret < 0) {
-		err("send import reply");
-		return -1;
-	}
-
-	if (!error) {
-		struct usb_device pdu_udev;
-
-		memcpy(&pdu_udev, &edev->udev, sizeof(pdu_udev));
-		pack_usb_device(1, &pdu_udev);
-
-		ret = usbip_send(sockfd, (void *) &pdu_udev, sizeof(pdu_udev));
-		if (ret < 0) {
-			err("send devinfo");
-			return -1;
-		}
-	}
-
-	return 0;
-}
-
-
-
-static int recv_pdu(int sockfd)
-{
-	int ret;
-	uint16_t code = OP_UNSPEC;
-
-
-	ret = usbip_recv_op_common(sockfd, &code);
-	if (ret < 0) {
-		err("recv op_common, %d", ret);
-		return ret;
-	}
-
-
-	ret = usbip_stub_refresh_device_list();
-	if (ret < 0)
-		return -1;
-
-	switch(code) {
-		case OP_REQ_DEVLIST:
-			ret = recv_request_devlist(sockfd);
-			break;
-
-		case OP_REQ_IMPORT:
-			ret = recv_request_import(sockfd);
-			break;
-
-		case OP_REQ_DEVINFO:
-		case OP_REQ_CRYPKEY:
-
-		default:
-			err("unknown op_code, %d", code);
-			ret = -1;
-	}
-
-
-	return ret;
-}
-
-
-
-
-static void log_addrinfo(struct addrinfo *ai)
-{
-	int ret;
-	char hbuf[NI_MAXHOST];
-	char sbuf[NI_MAXSERV];
-
-	ret = getnameinfo(ai->ai_addr, ai->ai_addrlen, hbuf, sizeof(hbuf),
-			sbuf, sizeof(sbuf), NI_NUMERICHOST | NI_NUMERICSERV);
-	if (ret)
-		err("getnameinfo, %s", gai_strerror(ret));
-
-	info("listen at [%s]:%s", hbuf, sbuf);
-}
-
-static struct addrinfo *my_getaddrinfo(char *host, int ai_family)
-{
-	int ret;
-	struct addrinfo hints, *ai_head;
-
-	bzero(&hints, sizeof(hints));
-
-	hints.ai_family   = ai_family;
-	hints.ai_socktype = SOCK_STREAM;
-	hints.ai_flags    = AI_PASSIVE;
-
-	ret = getaddrinfo(host, USBIP_PORT_STRING, &hints, &ai_head);
-	if (ret) {
-		err("%s: %s", USBIP_PORT_STRING, gai_strerror(ret));
-		return NULL;
-	}
-
-	return ai_head;
-}
-
-#define MAXSOCK 20
-static int listen_all_addrinfo(struct addrinfo *ai_head, int lsock[])
-{
-	struct addrinfo *ai;
-	int n = 0;		/* number of sockets */
-
-	for (ai = ai_head; ai && n < MAXSOCK; ai = ai->ai_next) {
-		int ret;
-
-		lsock[n] = socket(ai->ai_family, ai->ai_socktype, ai->ai_protocol);
-		if (lsock[n] < 0)
-			continue;
-
-		usbip_set_reuseaddr(lsock[n]);
-		usbip_set_nodelay(lsock[n]);
-
-		if (lsock[n] >= FD_SETSIZE) {
-			close(lsock[n]);
-			lsock[n] = -1;
-			continue;
-		}
-
-		ret = bind(lsock[n], ai->ai_addr, ai->ai_addrlen);
-		if (ret < 0) {
-			close(lsock[n]);
-			lsock[n] = -1;
-			continue;
-		}
-
-		ret = listen(lsock[n], SOMAXCONN);
-		if (ret < 0) {
-			close(lsock[n]);
-			lsock[n] = -1;
-			continue;
-		}
-
-		log_addrinfo(ai);
-
-		/* next if succeed */
-		n++;
-	}
-
-	if (n == 0) {
-		err("no socket to listen to");
-		return -1;
-	}
-
-	dbg("listen %d address%s", n, (n==1)?"":"es");
-
-	return n;
-}
-
-#ifdef HAVE_LIBWRAP
-static int tcpd_auth(int csock)
-{
-	int ret;
-	struct request_info request;
-
-	request_init(&request, RQ_DAEMON, "usbipd", RQ_FILE, csock, 0);
-
-	fromhost(&request);
-
-	ret = hosts_access(&request);
-	if (!ret)
-		return -1;
-
-	return 0;
-}
-#endif
-
-static int my_accept(int lsock)
-{
-	int csock;
-	struct sockaddr_storage ss;
-	socklen_t len = sizeof(ss);
-	char host[NI_MAXHOST], port[NI_MAXSERV];
-	int ret;
-
-	bzero(&ss, sizeof(ss));
-
-	csock = accept(lsock, (struct sockaddr *) &ss, &len);
-	if (csock < 0) {
-		err("accept");
-		return -1;
-	}
-
-	ret = getnameinfo((struct sockaddr *) &ss, len,
-			host, sizeof(host), port, sizeof(port),
-			(NI_NUMERICHOST | NI_NUMERICSERV));
-	if (ret)
-		err("getnameinfo, %s", gai_strerror(ret));
-
-#ifdef HAVE_LIBWRAP
-	ret = tcpd_auth(csock);
-	if (ret < 0) {
-		info("deny access from %s", host);
-		close(csock);
-		return -1;
-	}
-#endif
-
-	info("connected from %s:%s", host, port);
-
-	return csock;
-}
-
-
-GMainLoop *main_loop;
-
-static void signal_handler(int i)
-{
-	dbg("signal catched, code %d", i);
-
-	if (main_loop)
-		g_main_loop_quit(main_loop);
-}
-
-static void set_signal(void)
-{
-	struct sigaction act;
-
-	bzero(&act, sizeof(act));
-	act.sa_handler = signal_handler;
-	sigemptyset(&act.sa_mask);
-	sigaction(SIGTERM, &act, NULL);
-	sigaction(SIGINT, &act, NULL);
-}
-
-
-gboolean process_comming_request(GIOChannel *gio, GIOCondition condition, gpointer data)
-{
-	int ret;
-
-	if (condition & (G_IO_ERR | G_IO_HUP | G_IO_NVAL))
-		g_error("unknown condition");
-
-
-	if (condition & G_IO_IN) {
-		int lsock;
-		int csock;
-
-		lsock = g_io_channel_unix_get_fd(gio);
-
-		csock = my_accept(lsock);
-		if (csock < 0)
-			return TRUE;
-
-		ret = recv_pdu(csock);
-		if (ret < 0)
-			err("process recieved pdu");
-
-		close(csock);
-	}
-
-	return TRUE;
-}
-
-
-static void do_standalone_mode(gboolean daemonize)
-{
-	int ret;
-	int lsock[MAXSOCK];
-	struct addrinfo *ai_head;
-	int n;
-
-
-
-	ret = usbip_names_init(USBIDS_FILE);
-	if (ret)
-		err("open usb.ids");
-
-	ret = usbip_stub_driver_open();
-	if (ret < 0)
-		g_error("driver open failed");
-
-	if (daemonize) {
-		if (daemon(0,0) < 0)
-			g_error("daemonizing failed: %s", g_strerror(errno));
-
-		usbip_use_syslog = 1;
-	}
-
-	set_signal();
-
-	ai_head = my_getaddrinfo(NULL, PF_UNSPEC);
-	if (!ai_head)
-		return;
-
-	n = listen_all_addrinfo(ai_head, lsock);
-	if (n <= 0)
-		g_error("no socket to listen to");
-
-	for (int i = 0; i < n; i++) {
-		GIOChannel *gio;
-
-		gio = g_io_channel_unix_new(lsock[i]);
-		g_io_add_watch(gio, (G_IO_IN | G_IO_ERR | G_IO_HUP | G_IO_NVAL),
-				process_comming_request, NULL);
-	}
-
-
-	info("usbipd start (%s)", version);
-
-
-	main_loop = g_main_loop_new(FALSE, FALSE);
-	g_main_loop_run(main_loop);
-
-	info("shutdown");
-
-	freeaddrinfo(ai_head);
-	usbip_names_free();
-	usbip_stub_driver_close();
-
-	return;
-}
-
-
-static const char help_message[] = "\
-Usage: usbipd [options]				\n\
-	-D, --daemon				\n\
-		Run as a daemon process.	\n\
-						\n\
-	-d, --debug				\n\
-		Print debugging information.	\n\
-						\n\
-	-v, --version				\n\
-		Show version.			\n\
-						\n\
-	-h, --help 				\n\
-		Print this help.		\n";
-
-static void show_help(void)
-{
-	printf("%s", help_message);
-}
-
-static const struct option longopts[] = {
-	{"daemon",	no_argument,	NULL, 'D'},
-	{"debug",	no_argument,	NULL, 'd'},
-	{"version",	no_argument,	NULL, 'v'},
-	{"help",	no_argument,	NULL, 'h'},
-	{NULL,		0,		NULL,  0}
-};
-
-int main(int argc, char *argv[])
-{
-	gboolean daemonize = FALSE;
-
-	enum {
-		cmd_standalone_mode = 1,
-		cmd_help,
-		cmd_version
-	} cmd = cmd_standalone_mode;
-
-
-	usbip_use_stderr = 1;
-	usbip_use_syslog = 0;
-
-	if (geteuid() != 0)
-		g_warning("running non-root?");
-
-	for (;;) {
-		int c;
-		int index = 0;
-
-		c = getopt_long(argc, argv, "vhdD", longopts, &index);
-
-		if (c == -1)
-			break;
-
-		switch (c) {
-			case 'd':
-				usbip_use_debug = 1;
-				continue;
-			case 'v':
-				cmd = cmd_version;
-				break;
-			case 'h':
-				cmd = cmd_help;
-				break;
-			case 'D':
-				daemonize = TRUE;
-				break;
-			case '?':
-				show_help();
-				exit(EXIT_FAILURE);
-			default:
-				err("getopt");
-		}
-	}
-
-	switch (cmd) {
-		case cmd_standalone_mode:
-			do_standalone_mode(daemonize);
-			break;
-		case cmd_version:
-			printf("%s\n", version);
-			break;
-		case cmd_help:
-			show_help();
-			break;
-		default:
-			info("unknown cmd");
-			show_help();
-	}
-
-	return 0;
-}
diff --git a/drivers/staging/usbip/userspace/cmd/utils.c b/drivers/staging/usbip/userspace/cmd/utils.c
deleted file mode 100644
index 403c30f..0000000
--- a/drivers/staging/usbip/userspace/cmd/utils.c
+++ /dev/null
@@ -1,256 +0,0 @@
-/*
- * $Id$
- *
- * Copyright (C) 2005-2007 Takahiro Hirofuchi
- */
-
-#include "utils.h"
-
-int read_integer(char *path)
-{
-	char buff[100];
-	int fd;
-	int ret = 0;
-
-	bzero(buff, sizeof(buff));
-
-	fd = open(path, O_RDONLY);
-	if (fd < 0)
-		return -1;
-
-	ret = read(fd, buff, sizeof(buff));
-	if (ret < 0) {
-		close(fd);
-		return -1;
-	}
-
-	sscanf(buff, "%d", &ret);
-
-	close(fd);
-
-	return ret;
-}
-
-int read_string(char *path, char *string, size_t len)
-{
-	int fd;
-	int ret = 0;
-	char  *p;
-
-	bzero(string, len);
-
-	fd = open(path, O_RDONLY);
-	if (fd < 0) {
-		string = NULL;
-		return -1;
-	}
-
-	ret = read(fd, string, len-1);
-	if (ret < 0) {
-		string = NULL;
-		close(fd);
-		return -1;
-	}
-
-	p = strchr(string, '\n');
-	*p = '\0';
-
-	close(fd);
-
-	return 0;
-}
-
-int write_integer(char *path, int value)
-{
-	int fd;
-	int ret;
-	char buff[100];
-
-	snprintf(buff, sizeof(buff), "%d", value);
-
-	fd = open(path, O_WRONLY);
-	if (fd < 0)
-		return -1;
-
-	ret = write(fd, buff, strlen(buff));
-	if (ret < 0) {
-		close(fd);
-		return -1;
-	}
-
-	close(fd);
-
-	return 0;
-}
-
-int read_bConfigurationValue(char *busid)
-{
-	char path[PATH_MAX];
-
-	snprintf(path, PATH_MAX, "/sys/bus/usb/devices/%s/bConfigurationValue", busid);
-
-	return read_integer(path);
-}
-
-int write_bConfigurationValue(char *busid, int config)
-{
-	char path[PATH_MAX];
-
-	snprintf(path, PATH_MAX, "/sys/bus/usb/devices/%s/bConfigurationValue", busid);
-
-	return write_integer(path, config);
-}
-
-int read_bNumInterfaces(char *busid)
-{
-	char path[PATH_MAX];
-
-	snprintf(path, PATH_MAX, "/sys/bus/usb/devices/%s/bNumInterfaces", busid);
-
-	return read_integer(path);
-}
-
-int read_bDeviceClass(char *busid)
-{
-	char path[PATH_MAX];
-
-	snprintf(path, PATH_MAX, "/sys/bus/usb/devices/%s/bDeviceClass", busid);
-
-	return read_integer(path);
-}
-
-int getdriver(char *busid, int conf, int infnum, char *driver, size_t len)
-{
-	char path[PATH_MAX];
-	char linkto[PATH_MAX];
-	int ret;
-
-	snprintf(path, PATH_MAX, "/sys/bus/usb/devices/%s:%d.%d/driver", busid, conf, infnum);
-
-	/* readlink does not add NULL */
-	bzero(linkto, sizeof(linkto));
-	ret = readlink(path, linkto, sizeof(linkto)-1);
-	if (ret < 0) {
-		strncpy(driver, "none", len);
-		return -1;
-	} else {
-		strncpy(driver, basename(linkto), len);
-		return 0;
-	}
-}
-
-int getdevicename(char *busid, char *name, size_t len)
-{
-	char path[PATH_MAX];
-	char idProduct[10], idVendor[10];
-
-	snprintf(path, PATH_MAX, "/sys/bus/usb/devices/%s/idVendor", busid);
-	read_string(path, idVendor, sizeof(idVendor));
-
-	snprintf(path, PATH_MAX, "/sys/bus/usb/devices/%s/idProduct", busid);
-	read_string(path, idProduct, sizeof(idProduct));
-
-	if (!idVendor[0] || !idProduct[0])
-		return -1;
-
-	snprintf(name, len, "%s:%s", idVendor, idProduct);
-
-	return 0;
-}
-
-#define MAXLINE 100
-
-/* if this cannot read a whole line, return -1 */
-int readline(int sockfd, char *buff, int bufflen)
-{
-	int ret;
-	char c;
-	int index = 0;
-
-
-	while (index < bufflen) {
-		ret = read(sockfd, &c, sizeof(c));
-		if (ret < 0 && errno == EINTR)
-			continue;
-		if (ret <= 0) {
-			return -1;
-		}
-
-		buff[index] = c;
-
-		if ( index > 0 && buff[index-1] == '\r'  && buff[index] == '\n') {
-			/* end of line */
-			buff[index-1] = '\0';	/* get rid of delimitor */
-			return index;
-		} else
-			index++;
-	}
-
-	return -1;
-}
-
-#if 0
-int writeline(int sockfd, char *str, int strlen)
-{
-	int ret;
-	int index = 0;
-	int len;
-	char buff[MAXLINE];
-
-	if (strlen + 3 > MAXLINE)
-		return -1;
-
-	strncpy(buff, str, strlen);
-	buff[strlen+1] = '\r';
-	buff[strlen+2] = '\n';
-	buff[strlen+3] = '\0';
-
-	len = strlen + 3;
-
-	while (len > 0) {
-		ret = write(sockfd, buff+index, len);
-		if (ret <= 0) {
-			return -1;
-		}
-
-		len -= ret;
-		index += ret;
-	}
-
-	return index;
-}
-#endif
-
-int writeline(int sockfd, char *str, int strlen)
-{
-	int ret;
-	int index = 0;
-	int len;
-	char buff[MAXLINE];
-
-	len = strnlen(str, strlen);
-
-	if (strlen + 2 > MAXLINE)
-		return -1;
-
-	memcpy(buff, str, strlen);
-	buff[strlen] = '\r';
-	buff[strlen+1] = '\n';		/* strlen+1 <= MAXLINE-1 */
-
-	len = strlen + 2;
-
-	while (len > 0) {
-		ret = write(sockfd, buff+index, len);
-		if (ret < 0 && errno == EINTR)
-			continue;
-		if (ret <= 0) {
-			return -1;
-		}
-
-		len -= ret;
-		index += ret;
-	}
-
-	return index;
-}
-
diff --git a/drivers/staging/usbip/userspace/cmd/utils.h b/drivers/staging/usbip/userspace/cmd/utils.h
deleted file mode 100644
index 6c29ae9..0000000
--- a/drivers/staging/usbip/userspace/cmd/utils.h
+++ /dev/null
@@ -1,38 +0,0 @@
-
-#ifdef HAVE_CONFIG_H
-#include "../config.h"
-#endif
-
-#define _GNU_SOURCE
-#include <string.h>
-#include <sys/un.h>
-#include <sys/types.h>
-#include <sys/socket.h>
-
-#include <sysfs/libsysfs.h>
-#include <glib.h>
-#include <unistd.h>
-#include <stdio.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <fcntl.h>
-#include <stdlib.h>
-#include <time.h>
-#include <errno.h>
-
-
-
-/* Be sync to kernel header */
-#define BUS_ID_SIZE 20
-
-int read_string(char *path, char *, size_t len);
-int read_integer(char *path);
-int getdevicename(char *busid, char *name, size_t len);
-int getdriver(char *busid, int conf, int infnum, char *driver, size_t len);
-int read_bNumInterfaces(char *busid);
-int read_bConfigurationValue(char *busid);
-int write_integer(char *path, int value);
-int write_bConfigurationValue(char *busid, int config);
-int read_bDeviceClass(char *busid);
-int readline(int sockfd, char *str, int strlen);
-int writeline(int sockfd, char *buff, int bufflen);
diff --git a/drivers/staging/usbip/userspace/configure.ac b/drivers/staging/usbip/userspace/configure.ac
index 6de5bc7..24fd8ae 100644
--- a/drivers/staging/usbip/userspace/configure.ac
+++ b/drivers/staging/usbip/userspace/configure.ac
@@ -101,5 +101,5 @@ PKG_CHECK_MODULES(PACKAGE, glib-2.0 >= $GLIB2_REQUIRED)
 AC_SUBST(PACKAGE_CFLAGS)
 AC_SUBST(PACKAGE_LIBS)
 
-AC_CONFIG_FILES([Makefile lib/Makefile cmd/Makefile])
+AC_CONFIG_FILES([Makefile libsrc/Makefile src/Makefile])
 AC_OUTPUT
diff --git a/drivers/staging/usbip/userspace/lib/Makefile.am b/drivers/staging/usbip/userspace/lib/Makefile.am
deleted file mode 100644
index 10b919d..0000000
--- a/drivers/staging/usbip/userspace/lib/Makefile.am
+++ /dev/null
@@ -1,10 +0,0 @@
-# AM_CFLAGS = -Wall -std=gnu99
-lib_LTLIBRARIES = libusbip.la
-libusbip_la_SOURCES = names.c names.h stub_driver.c stub_driver.h usbip.h usbip_common.c usbip_common.h vhci_driver.c vhci_driver.h
-#libusbip_la_SOURCES = names.c names.h stub_driver.c usbip_common.c vhci_driver.c
-#INCLUDES = -I../include
-#AM_CPPFLAGS = -I../include -Wall -std=gnu99
-libusbip_la_LDFLAGS = -version-info 0:1:0
-EXTRA_CFLAGS = @EXTRA_CFLAGS@
-libusbip_la_CFLAGS = -Wall -W -Wstrict-prototypes -std=gnu99 $(EXTRA_CFLAGS) -DUSBIDS_FILE='"@USBIDS_DIR@/usb.ids"'
-
diff --git a/drivers/staging/usbip/userspace/lib/names.c b/drivers/staging/usbip/userspace/lib/names.c
deleted file mode 100644
index b4de18b..0000000
--- a/drivers/staging/usbip/userspace/lib/names.c
+++ /dev/null
@@ -1,793 +0,0 @@
-/*****************************************************************************/
-/*
- *      names.c  --  USB name database manipulation routines
- *
- *      Copyright (C) 1999, 2000  Thomas Sailer (sailer@ife.ee.ethz.ch)
- *
- *      This program is free software; you can redistribute it and/or modify
- *      it under the terms of the GNU General Public License as published by
- *      the Free Software Foundation; either version 2 of the License, or
- *      (at your option) any later version.
- *
- *      This program is distributed in the hope that it will be useful,
- *      but WITHOUT ANY WARRANTY; without even the implied warranty of
- *      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *      GNU General Public License for more details.
- *
- *      You should have received a copy of the GNU General Public License
- *      along with this program; if not, write to the Free Software
- *      Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
- *
- */
-
-/*
- * 	Copyright (C) 2005 Takahiro Hirofuchi
- * 		- names_deinit() is added.
- */
-
-/*****************************************************************************/
-
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <fcntl.h>
-#include <dirent.h>
-#include <string.h>
-#include <errno.h>
-#include <stdlib.h>
-#include <unistd.h>
-#include <stdio.h>
-#include <ctype.h>
-
-
-#include "names.h"
-
-
-/* ---------------------------------------------------------------------- */
-
-struct vendor {
-	struct vendor *next;
-	u_int16_t vendorid;
-	char name[1];
-};
-
-struct product {
-	struct product *next;
-	u_int16_t vendorid, productid;
-	char name[1];
-};
-
-struct class {
-	struct class *next;
-	u_int8_t classid;
-	char name[1];
-};
-
-struct subclass {
-	struct subclass *next;
-	u_int8_t classid, subclassid;
-	char name[1];
-};
-
-struct protocol {
-	struct protocol *next;
-	u_int8_t classid, subclassid, protocolid;
-	char name[1];
-};
-
-struct audioterminal {
-	struct audioterminal *next;
-	u_int16_t termt;
-	char name[1];
-};
-
-struct genericstrtable {
-        struct genericstrtable *next;
-        unsigned int num;
-        char name[1];
-};
-
-/* ---------------------------------------------------------------------- */
-
-#define HASH1  0x10
-#define HASH2  0x02
-#define HASHSZ 16
-
-static unsigned int hashnum(unsigned int num)
-{
-	unsigned int mask1 = HASH1 << 27, mask2 = HASH2 << 27;
-
-	for (; mask1 >= HASH1; mask1 >>= 1, mask2 >>= 1)
-		if (num & mask1)
-			num ^= mask2;
-	return num & (HASHSZ-1);
-}
-
-/* ---------------------------------------------------------------------- */
-
-static struct vendor *vendors[HASHSZ] = { NULL, };
-static struct product *products[HASHSZ] = { NULL, };
-static struct class *classes[HASHSZ] = { NULL, };
-static struct subclass *subclasses[HASHSZ] = { NULL, };
-static struct protocol *protocols[HASHSZ] = { NULL, };
-static struct audioterminal *audioterminals[HASHSZ] = { NULL, };
-static struct genericstrtable *hiddescriptors[HASHSZ] = { NULL, };
-static struct genericstrtable *reports[HASHSZ] = { NULL, };
-static struct genericstrtable *huts[HASHSZ] = { NULL, };
-static struct genericstrtable *biass[HASHSZ] = { NULL, };
-static struct genericstrtable *physdess[HASHSZ] = { NULL, };
-static struct genericstrtable *hutus[HASHSZ] = { NULL, };
-static struct genericstrtable *langids[HASHSZ] = { NULL, };
-static struct genericstrtable *countrycodes[HASHSZ] = { NULL, };
-
-/* ---------------------------------------------------------------------- */
-
-static const char *names_genericstrtable(struct genericstrtable *t[HASHSZ], unsigned int index)
-{
-        struct genericstrtable *h;
-
-        for (h = t[hashnum(index)]; h; h = h->next)
-                if (h->num == index)
-                        return h->name;
-        return NULL;
-}
-
-const char *names_hid(u_int8_t hidd)
-{
-	return names_genericstrtable(hiddescriptors, hidd);
-}
-
-const char *names_reporttag(u_int8_t rt)
-{
-	return names_genericstrtable(reports, rt);
-}
-
-const char *names_huts(unsigned int data)
-{
-	return names_genericstrtable(huts, data);
-}
-
-const char *names_hutus(unsigned int data)
-{
-	return names_genericstrtable(hutus, data);
-}
-
-const char *names_langid(u_int16_t langid)
-{
-	return names_genericstrtable(langids, langid);
-}
-
-const char *names_physdes(u_int8_t ph)
-{
-	return names_genericstrtable(physdess, ph);
-}
-
-const char *names_bias(u_int8_t b)
-{
-	return names_genericstrtable(biass, b);
-}
-
-const char *names_countrycode(unsigned int countrycode)
-{
-	return names_genericstrtable(countrycodes, countrycode);
-}
-
-const char *names_vendor(u_int16_t vendorid)
-{
-	struct vendor *v;
-
-	v = vendors[hashnum(vendorid)];
-	for (; v; v = v->next)
-		if (v->vendorid == vendorid)
-			return v->name;
-	return NULL;
-}
-
-const char *names_product(u_int16_t vendorid, u_int16_t productid)
-{
-	struct product *p;
-
-	p = products[hashnum((vendorid << 16) | productid)];
-	for (; p; p = p->next)
-		if (p->vendorid == vendorid && p->productid == productid)
-			return p->name;
-	return NULL;
-}
-
-const char *names_class(u_int8_t classid)
-{
-	struct class *c;
-
-	c = classes[hashnum(classid)];
-	for (; c; c = c->next)
-		if (c->classid == classid)
-			return c->name;
-	return NULL;
-}
-
-const char *names_subclass(u_int8_t classid, u_int8_t subclassid)
-{
-	struct subclass *s;
-
-	s = subclasses[hashnum((classid << 8) | subclassid)];
-	for (; s; s = s->next)
-		if (s->classid == classid && s->subclassid == subclassid)
-			return s->name;
-	return NULL;
-}
-
-const char *names_protocol(u_int8_t classid, u_int8_t subclassid, u_int8_t protocolid)
-{
-	struct protocol *p;
-
-	p = protocols[hashnum((classid << 16) | (subclassid << 8) | protocolid)];
-	for (; p; p = p->next)
-		if (p->classid == classid && p->subclassid == subclassid && p->protocolid == protocolid)
-			return p->name;
-	return NULL;
-}
-
-const char *names_audioterminal(u_int16_t termt)
-{
-	struct audioterminal *at;
-
-	at = audioterminals[hashnum(termt)];
-	for (; at; at = at->next)
-		if (at->termt == termt)
-			return at->name;
-	return NULL;
-}
-
-/* ---------------------------------------------------------------------- */
-/* add a cleanup function by takahiro */
-
-struct pool {
-	struct pool *next;
-	void *mem;
-};
-
-static struct pool *pool_head = NULL;
-
-static void *my_malloc(size_t size)
-{
-	struct pool *p;
-
-	p = calloc(1, sizeof(struct pool));
-	if (!p) {
-		free(p);
-		return NULL;
-	}
-
-	p->mem = calloc(1, size);
-	if (!p->mem)
-		return NULL;
-
-	p->next = pool_head;
-	pool_head = p;
-
-	return p->mem;
-}
-
-void names_free(void)
-{
-	struct pool *pool;
-
-	if (!pool_head)
-		return;
-
-	for (pool = pool_head; pool != NULL; ) {
-		struct pool *tmp;
-
-		if (pool->mem)
-			free(pool->mem);
-
-		tmp = pool;
-		pool = pool->next;
-		free(tmp);
-	}
-}
-
-/* ---------------------------------------------------------------------- */
-
-static int new_vendor(const char *name, u_int16_t vendorid)
-{
-	struct vendor *v;
-	unsigned int h = hashnum(vendorid);
-
-	v = vendors[h];
-	for (; v; v = v->next)
-		if (v->vendorid == vendorid)
-			return -1;
-	v = my_malloc(sizeof(struct vendor) + strlen(name));
-	if (!v)
-		return -1;
-	strcpy(v->name, name);
-	v->vendorid = vendorid;
-	v->next = vendors[h];
-	vendors[h] = v;
-	return 0;
-}
-
-static int new_product(const char *name, u_int16_t vendorid, u_int16_t productid)
-{
-	struct product *p;
-	unsigned int h = hashnum((vendorid << 16) | productid);
-
-	p = products[h];
-	for (; p; p = p->next)
-		if (p->vendorid == vendorid && p->productid == productid)
-			return -1;
-	p = my_malloc(sizeof(struct product) + strlen(name));
-	if (!p)
-		return -1;
-	strcpy(p->name, name);
-	p->vendorid = vendorid;
-	p->productid = productid;
-	p->next = products[h];
-	products[h] = p;
-	return 0;
-}
-
-static int new_class(const char *name, u_int8_t classid)
-{
-	struct class *c;
-	unsigned int h = hashnum(classid);
-
-	c = classes[h];
-	for (; c; c = c->next)
-		if (c->classid == classid)
-			return -1;
-	c = my_malloc(sizeof(struct class) + strlen(name));
-	if (!c)
-		return -1;
-	strcpy(c->name, name);
-	c->classid = classid;
-	c->next = classes[h];
-	classes[h] = c;
-	return 0;
-}
-
-static int new_subclass(const char *name, u_int8_t classid, u_int8_t subclassid)
-{
-	struct subclass *s;
-	unsigned int h = hashnum((classid << 8) | subclassid);
-
-	s = subclasses[h];
-	for (; s; s = s->next)
-		if (s->classid == classid && s->subclassid == subclassid)
-			return -1;
-	s = my_malloc(sizeof(struct subclass) + strlen(name));
-	if (!s)
-		return -1;
-	strcpy(s->name, name);
-	s->classid = classid;
-	s->subclassid = subclassid;
-	s->next = subclasses[h];
-	subclasses[h] = s;
-	return 0;
-}
-
-static int new_protocol(const char *name, u_int8_t classid, u_int8_t subclassid, u_int8_t protocolid)
-{
-	struct protocol *p;
-	unsigned int h = hashnum((classid << 16) | (subclassid << 8) | protocolid);
-
-	p = protocols[h];
-	for (; p; p = p->next)
-		if (p->classid == classid && p->subclassid == subclassid && p->protocolid == protocolid)
-			return -1;
-	p = my_malloc(sizeof(struct protocol) + strlen(name));
-	if (!p)
-		return -1;
-	strcpy(p->name, name);
-	p->classid = classid;
-	p->subclassid = subclassid;
-	p->protocolid = protocolid;
-	p->next = protocols[h];
-	protocols[h] = p;
-	return 0;
-}
-
-static int new_audioterminal(const char *name, u_int16_t termt)
-{
-	struct audioterminal *at;
-	unsigned int h = hashnum(termt);
-
-	at = audioterminals[h];
-	for (; at; at = at->next)
-		if (at->termt == termt)
-			return -1;
-	at = my_malloc(sizeof(struct audioterminal) + strlen(name));
-	if (!at)
-		return -1;
-	strcpy(at->name, name);
-	at->termt = termt;
-	at->next = audioterminals[h];
-	audioterminals[h] = at;
-	return 0;
-}
-
-static int new_genericstrtable(struct genericstrtable *t[HASHSZ], const char *name, unsigned int index)
-{
-        struct genericstrtable *g;
-	unsigned int h = hashnum(index);
-
-        for (g = t[h]; g; g = g->next)
-                if (g->num == index)
-                        return -1;
-        g = my_malloc(sizeof(struct genericstrtable) + strlen(name));
-        if (!g)
-                return -1;
-        strcpy(g->name, name);
-        g->num = index;
-        g->next = t[h];
-        t[h] = g;
-        return 0;
-}
-
-static int new_hid(const char *name, u_int8_t hidd)
-{
-	return new_genericstrtable(hiddescriptors, name, hidd);
-}
-
-static int new_reporttag(const char *name, u_int8_t rt)
-{
-	return new_genericstrtable(reports, name, rt);
-}
-
-static int new_huts(const char *name, unsigned int data)
-{
-	return new_genericstrtable(huts, name, data);
-}
-
-static int new_hutus(const char *name, unsigned int data)
-{
-	return new_genericstrtable(hutus, name, data);
-}
-
-static int new_langid(const char *name, u_int16_t langid)
-{
-	return new_genericstrtable(langids, name, langid);
-}
-
-static int new_physdes(const char *name, u_int8_t ph)
-{
-	return new_genericstrtable(physdess, name, ph);
-}
-static int new_bias(const char *name, u_int8_t b)
-{
-	return new_genericstrtable(biass, name, b);
-}
-
-static int new_countrycode(const char *name, unsigned int countrycode)
-{
-	return new_genericstrtable(countrycodes, name, countrycode);
-}
-
-/* ---------------------------------------------------------------------- */
-
-#define DBG(x)
-
-static void parse(FILE *f)
-{
-	char buf[512], *cp;
-	unsigned int linectr = 0;
-	int lastvendor = -1, lastclass = -1, lastsubclass = -1, lasthut=-1, lastlang=-1;
-	unsigned int u;
-
-	while (fgets(buf, sizeof(buf), f)) {
-		linectr++;
-		/* remove line ends */
-		if ((cp = strchr(buf, 13)))
-			*cp = 0;
-		if ((cp = strchr(buf, 10)))
-			*cp = 0;
-		if (buf[0] == '#' || !buf[0])
-			continue;
-		cp = buf;
-                if (buf[0] == 'P' && buf[1] == 'H' && buf[2] == 'Y' && buf[3] == 'S' && buf[4] == 'D' &&
-                    buf[5] == 'E' && buf[6] == 'S' && /*isspace(buf[7])*/ buf[7] == ' ') {
-                        cp = buf + 8;
-                        while (isspace(*cp))
-                                cp++;
-                        if (!isxdigit(*cp)) {
-                                fprintf(stderr, "Invalid Physdes type at line %u\n", linectr);
-                                continue;
-                        }
-                        u = strtoul(cp, &cp, 16);
-                        while (isspace(*cp))
-                                cp++;
-                        if (!*cp) {
-                                fprintf(stderr, "Invalid Physdes type at line %u\n", linectr);
-                                continue;
-                        }
-                        if (new_physdes(cp, u))
-                                fprintf(stderr, "Duplicate Physdes  type spec at line %u terminal type %04x %s\n", linectr, u, cp);
-                        DBG(printf("line %5u physdes type %02x %s\n", linectr, u, cp));
-                        continue;
-
-                }
-                if (buf[0] == 'P' && buf[1] == 'H' && buf[2] == 'Y' && /*isspace(buf[3])*/ buf[3] == ' ') {
-                        cp = buf + 4;
-                        while (isspace(*cp))
-                                cp++;
-                        if (!isxdigit(*cp)) {
-                                fprintf(stderr, "Invalid PHY type at line %u\n", linectr);
-                                continue;
-                        }
-                        u = strtoul(cp, &cp, 16);
-                        while (isspace(*cp))
-                                cp++;
-                        if (!*cp) {
-                                fprintf(stderr, "Invalid PHY type at line %u\n", linectr);
-                                continue;
-                        }
-                        if (new_physdes(cp, u))
-                                fprintf(stderr, "Duplicate PHY type spec at line %u terminal type %04x %s\n", linectr, u, cp);
-                        DBG(printf("line %5u PHY type %02x %s\n", linectr, u, cp));
-                        continue;
-
-                }
-                if (buf[0] == 'B' && buf[1] == 'I' && buf[2] == 'A' && buf[3] == 'S' && /*isspace(buf[4])*/ buf[4] == ' ') {
-                        cp = buf + 5;
-                        while (isspace(*cp))
-                                cp++;
-                        if (!isxdigit(*cp)) {
-                                fprintf(stderr, "Invalid BIAS type at line %u\n", linectr);
-                                continue;
-                        }
-                        u = strtoul(cp, &cp, 16);
-                        while (isspace(*cp))
-                                cp++;
-                        if (!*cp) {
-                                fprintf(stderr, "Invalid BIAS type at line %u\n", linectr);
-                                continue;
-                        }
-                        if (new_bias(cp, u))
-                                fprintf(stderr, "Duplicate BIAS  type spec at line %u terminal type %04x %s\n", linectr, u, cp);
-                        DBG(printf("line %5u BIAS type %02x %s\n", linectr, u, cp));
-                        continue;
-
-                }
-                if (buf[0] == 'L' && /*isspace(buf[1])*/ buf[1] == ' ') {
-                        cp =  buf+2;
-                        while (isspace(*cp))
-                                cp++;
-                        if (!isxdigit(*cp)) {
-                                fprintf(stderr, "Invalid LANGID spec at line %u\n", linectr);
-                                continue;
-                        }
-                        u = strtoul(cp, &cp, 16);
-                        while (isspace(*cp))
-                                cp++;
-                        if (!*cp) {
-                                fprintf(stderr, "Invalid LANGID spec at line %u\n", linectr);
-                                continue;
-                        }
-                        if (new_langid(cp, u))
-                                fprintf(stderr, "Duplicate LANGID spec at line %u language-id %04x %s\n", linectr, u, cp);
-                        DBG(printf("line %5u LANGID %02x %s\n", linectr, u, cp));
-                        lasthut = lastclass = lastvendor = lastsubclass = -1;
-                        lastlang = u;
-                        continue;
-                }
-		if (buf[0] == 'C' && /*isspace(buf[1])*/ buf[1] == ' ') {
-			/* class spec */
-			cp = buf+2;
-			while (isspace(*cp))
-				cp++;
-			if (!isxdigit(*cp)) {
-				fprintf(stderr, "Invalid class spec at line %u\n", linectr);
-				continue;
-			}
-			u = strtoul(cp, &cp, 16);
-			while (isspace(*cp))
-				cp++;
-			if (!*cp) {
-				fprintf(stderr, "Invalid class spec at line %u\n", linectr);
-				continue;
-			}
-			if (new_class(cp, u))
-				fprintf(stderr, "Duplicate class spec at line %u class %04x %s\n", linectr, u, cp);
-			DBG(printf("line %5u class %02x %s\n", linectr, u, cp));
-			lasthut = lastlang = lastvendor = lastsubclass = -1;
-			lastclass = u;
-			continue;
-		}
-		if (buf[0] == 'A' && buf[1] == 'T' && isspace(buf[2])) {
-			/* audio terminal type spec */
-			cp = buf+3;
-			while (isspace(*cp))
-				cp++;
-			if (!isxdigit(*cp)) {
-				fprintf(stderr, "Invalid audio terminal type at line %u\n", linectr);
-				continue;
-			}
-			u = strtoul(cp, &cp, 16);
-			while (isspace(*cp))
-				cp++;
-			if (!*cp) {
-				fprintf(stderr, "Invalid audio terminal type at line %u\n", linectr);
-				continue;
-			}
-			if (new_audioterminal(cp, u))
-				fprintf(stderr, "Duplicate audio terminal type spec at line %u terminal type %04x %s\n", linectr, u, cp);
-			DBG(printf("line %5u audio terminal type %02x %s\n", linectr, u, cp));
-			continue;
-		}
-		if (buf[0] == 'H' && buf[1] == 'C' && buf[2] == 'C' && isspace(buf[3])) {
-			/* HID Descriptor bCountryCode */
-                        cp =  buf+3;
-                        while (isspace(*cp))
-                                cp++;
-                        if (!isxdigit(*cp)) {
-                                fprintf(stderr, "Invalid HID country code at line %u\n", linectr);
-                                continue;
-                        }
-                        u = strtoul(cp, &cp, 10);
-                        while (isspace(*cp))
-                                cp++;
-                        if (!*cp) {
-                                fprintf(stderr, "Invalid HID country code at line %u\n", linectr);
-                                continue;
-                        }
-                        if (new_countrycode(cp, u))
-                                fprintf(stderr, "Duplicate HID country code at line %u country %02u %s\n", linectr, u, cp);
-                        DBG(printf("line %5u keyboard country code %02u %s\n", linectr, u, cp));
-                        continue;
-		}
-		if (isxdigit(*cp)) {
-			/* vendor */
-			u = strtoul(cp, &cp, 16);
-			while (isspace(*cp))
-				cp++;
-			if (!*cp) {
-				fprintf(stderr, "Invalid vendor spec at line %u\n", linectr);
-				continue;
-			}
-			if (new_vendor(cp, u))
-				fprintf(stderr, "Duplicate vendor spec at line %u vendor %04x %s\n", linectr, u, cp);
-			DBG(printf("line %5u vendor %04x %s\n", linectr, u, cp));
-			lastvendor = u;
-			lasthut = lastlang = lastclass = lastsubclass = -1;
-			continue;
-		}
-		if (buf[0] == '\t' && isxdigit(buf[1])) {
-			/* product or subclass spec */
-			u = strtoul(buf+1, &cp, 16);
-			while (isspace(*cp))
-				cp++;
-			if (!*cp) {
-				fprintf(stderr, "Invalid product/subclass spec at line %u\n", linectr);
-				continue;
-			}
-			if (lastvendor != -1) {
-				if (new_product(cp, lastvendor, u))
-					fprintf(stderr, "Duplicate product spec at line %u product %04x:%04x %s\n", linectr, lastvendor, u, cp);
-				DBG(printf("line %5u product %04x:%04x %s\n", linectr, lastvendor, u, cp));
-				continue;
-			}
-			if (lastclass != -1) {
-				if (new_subclass(cp, lastclass, u))
-					fprintf(stderr, "Duplicate subclass spec at line %u class %02x:%02x %s\n", linectr, lastclass, u, cp);
-				DBG(printf("line %5u subclass %02x:%02x %s\n", linectr, lastclass, u, cp));
-				lastsubclass = u;
-				continue;
-			}
-			if (lasthut != -1) {
-				if (new_hutus(cp, (lasthut << 16)+u))
-					fprintf(stderr, "Duplicate HUT Usage Spec at line %u\n", linectr);
-				continue;
-			}
-			if (lastlang != -1) {
-                                if (new_langid(cp, lastlang+(u<<10)))
-                                        fprintf(stderr, "Duplicate LANGID Usage Spec at line %u\n", linectr);
-                                continue;
-                        }
-			fprintf(stderr, "Product/Subclass spec without prior Vendor/Class spec at line %u\n", linectr);
-			continue;
-		}
-		if (buf[0] == '\t' && buf[1] == '\t' && isxdigit(buf[2])) {
-			/* protocol spec */
-			u = strtoul(buf+2, &cp, 16);
-			while (isspace(*cp))
-				cp++;
-			if (!*cp) {
-				fprintf(stderr, "Invalid protocol spec at line %u\n", linectr);
-				continue;
-			}
-			if (lastclass != -1 && lastsubclass != -1) {
-				if (new_protocol(cp, lastclass, lastsubclass, u))
-					fprintf(stderr, "Duplicate protocol spec at line %u class %02x:%02x:%02x %s\n", linectr, lastclass, lastsubclass, u, cp);
-				DBG(printf("line %5u protocol %02x:%02x:%02x %s\n", linectr, lastclass, lastsubclass, u, cp));
-				continue;
-			}
-			fprintf(stderr, "Protocol spec without prior Class and Subclass spec at line %u\n", linectr);
-			continue;
-		}
-		if (buf[0] == 'H' && buf[1] == 'I' && buf[2] == 'D' && /*isspace(buf[3])*/ buf[3] == ' ') {
-			cp = buf + 4;
-                        while (isspace(*cp))
-                                cp++;
-                        if (!isxdigit(*cp)) {
-                                fprintf(stderr, "Invalid HID type at line %u\n", linectr);
-                                continue;
-                        }
-                        u = strtoul(cp, &cp, 16);
-                        while (isspace(*cp))
-                                cp++;
-                        if (!*cp) {
-                                fprintf(stderr, "Invalid HID type at line %u\n", linectr);
-                                continue;
-                        }
-                        if (new_hid(cp, u))
-                                fprintf(stderr, "Duplicate HID type spec at line %u terminal type %04x %s\n", linectr, u, cp);
-                        DBG(printf("line %5u HID type %02x %s\n", linectr, u, cp));
-                        continue;
-
-		}
-                if (buf[0] == 'H' && buf[1] == 'U' && buf[2] == 'T' && /*isspace(buf[3])*/ buf[3] == ' ') {
-                        cp = buf + 4;
-                        while (isspace(*cp))
-                                cp++;
-                        if (!isxdigit(*cp)) {
-                                fprintf(stderr, "Invalid HUT type at line %u\n", linectr);
-                                continue;
-                        }
-                        u = strtoul(cp, &cp, 16);
-                        while (isspace(*cp))
-                                cp++;
-                        if (!*cp) {
-                                fprintf(stderr, "Invalid HUT type at line %u\n", linectr);
-                                continue;
-                        }
-                        if (new_huts(cp, u))
-                                fprintf(stderr, "Duplicate HUT type spec at line %u terminal type %04x %s\n", linectr, u, cp);
-			lastlang = lastclass = lastvendor = lastsubclass = -1;
-			lasthut = u;
-                        DBG(printf("line %5u HUT type %02x %s\n", linectr, u, cp));
-                        continue;
-
-                }
-                if (buf[0] == 'R' && buf[1] == ' ') {
-                        cp = buf + 2;
-                        while (isspace(*cp))
-                                cp++;
-                        if (!isxdigit(*cp)) {
-                                fprintf(stderr, "Invalid Report type at line %u\n", linectr);
-                                continue;
-                        }
-                        u = strtoul(cp, &cp, 16);
-                        while (isspace(*cp))
-                                cp++;
-                        if (!*cp) {
-                                fprintf(stderr, "Invalid Report type at line %u\n", linectr);
-                                continue;
-                        }
-                        if (new_reporttag(cp, u))
-                                fprintf(stderr, "Duplicate Report type spec at line %u terminal type %04x %s\n", linectr, u, cp);
-                        DBG(printf("line %5u Report type %02x %s\n", linectr, u, cp));
-                        continue;
-
-                }
-                if (buf[0] == 'V' && buf[1] == 'T') {
-			/* add here */
-			continue;
-		}
-		fprintf(stderr, "Unknown line at line %u\n", linectr);
-	}
-}
-
-/* ---------------------------------------------------------------------- */
-
-int names_init(char *n)
-{
-	FILE *f;
-
-	if (!(f = fopen(n, "r"))) {
-		return errno;
-	}
-	parse(f);
-	fclose(f);
-	return 0;
-}
diff --git a/drivers/staging/usbip/userspace/lib/names.h b/drivers/staging/usbip/userspace/lib/names.h
deleted file mode 100644
index 3a269fe..0000000
--- a/drivers/staging/usbip/userspace/lib/names.h
+++ /dev/null
@@ -1,57 +0,0 @@
-/*****************************************************************************/
-
-/*
- *      names.h  --  USB name database manipulation routines
- *
- *      Copyright (C) 1999, 2000  Thomas Sailer (sailer@ife.ee.ethz.ch)
- *
- *      This program is free software; you can redistribute it and/or modify
- *      it under the terms of the GNU General Public License as published by
- *      the Free Software Foundation; either version 2 of the License, or
- *      (at your option) any later version.
- *
- *      This program is distributed in the hope that it will be useful,
- *      but WITHOUT ANY WARRANTY; without even the implied warranty of
- *      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *      GNU General Public License for more details.
- *
- *      You should have received a copy of the GNU General Public License
- *      along with this program; if not, write to the Free Software
- *      Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
- *
- */
-
-/*
- *	Copyright (C) 2005 Takahiro Hirofuchi
- *	       - names_free() is added.
- */
-
-/*****************************************************************************/
-
-#ifndef _NAMES_H
-#define _NAMES_H
-
-#include <sys/types.h>
-
-/* ---------------------------------------------------------------------- */
-
-extern const char *names_vendor(u_int16_t vendorid);
-extern const char *names_product(u_int16_t vendorid, u_int16_t productid);
-extern const char *names_class(u_int8_t classid);
-extern const char *names_subclass(u_int8_t classid, u_int8_t subclassid);
-extern const char *names_protocol(u_int8_t classid, u_int8_t subclassid, u_int8_t protocolid);
-extern const char *names_audioterminal(u_int16_t termt);
-extern const char *names_hid(u_int8_t hidd);
-extern const char *names_reporttag(u_int8_t rt);
-extern const char *names_huts(unsigned int data);
-extern const char *names_hutus(unsigned int data);
-extern const char *names_langid(u_int16_t langid);
-extern const char *names_physdes(u_int8_t ph);
-extern const char *names_bias(u_int8_t b);
-extern const char *names_countrycode(unsigned int countrycode);
-extern int  names_init(char *n);
-extern void names_free(void);
-
-/* ---------------------------------------------------------------------- */
-#endif /* _NAMES_H */
diff --git a/drivers/staging/usbip/userspace/lib/stub_driver.c b/drivers/staging/usbip/userspace/lib/stub_driver.c
deleted file mode 100644
index bfe67480..0000000
--- a/drivers/staging/usbip/userspace/lib/stub_driver.c
+++ /dev/null
@@ -1,390 +0,0 @@
-/*
- * Copyright (C) 2005-2007 Takahiro Hirofuchi
- */
-
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <unistd.h>
-
-#include "usbip.h"
-
-static const char *usbip_stub_driver_name = "usbip";
-
-
-struct usbip_stub_driver *stub_driver;
-
-static struct sysfs_driver *open_sysfs_stub_driver(void)
-{
-	int ret;
-
-	char sysfs_mntpath[SYSFS_PATH_MAX];
-	char stub_driver_path[SYSFS_PATH_MAX];
-	struct sysfs_driver *stub_driver;
-
-
-	ret = sysfs_get_mnt_path(sysfs_mntpath, SYSFS_PATH_MAX);
-	if (ret < 0) {
-		err("sysfs must be mounted");
-		return NULL;
-	}
-
-	snprintf(stub_driver_path, SYSFS_PATH_MAX, "%s/%s/usb/%s/%s",
-			sysfs_mntpath, SYSFS_BUS_NAME, SYSFS_DRIVERS_NAME,
-			usbip_stub_driver_name);
-
-	stub_driver = sysfs_open_driver_path(stub_driver_path);
-	if (!stub_driver) {
-		err("usbip_common_mod.ko and usbip.ko must be loaded");
-		return NULL;
-	}
-
-	return stub_driver;
-}
-
-
-#define SYSFS_OPEN_RETRIES 100
-
-/* only the first interface value is true! */
-static int32_t read_attr_usbip_status(struct usb_device *udev)
-{
-	char attrpath[SYSFS_PATH_MAX];
-	struct sysfs_attribute *attr;
-	int value = 0;
-	int  ret;
-	struct stat s;
-	int retries = SYSFS_OPEN_RETRIES;
-
-	/* This access is racy!
-	 *
-	 * Just after detach, our driver removes the sysfs
-	 * files and recreates them.
-	 *
-	 * We may try and fail to open the usbip_status of
-	 * an exported device in the (short) window where
-	 * it has been removed and not yet recreated.
-	 *
-	 * This is a bug in the interface. Nothing we can do
-	 * except work around it here by polling for the sysfs
-	 * usbip_status to reappear.
-	 */
-
-	snprintf(attrpath, SYSFS_PATH_MAX, "%s/%s:%d.%d/usbip_status",
-			udev->path, udev->busid,
-			udev->bConfigurationValue,
-			0);
-
-	while (retries > 0) {
-		if (stat(attrpath, &s) == 0)
-			break;
-
-		if (errno != ENOENT) {
-			err("error stat'ing %s", attrpath);
-			return -1;
-		}
-
-		usleep(10000); /* 10ms */
-		retries--;
-	}
-
-	if (retries == 0)
-		err("usbip_status not ready after %d retries", 
-			SYSFS_OPEN_RETRIES);
-	else if (retries < SYSFS_OPEN_RETRIES)
-		info("warning: usbip_status ready after %d retries",
-			 SYSFS_OPEN_RETRIES - retries);
-
-	attr = sysfs_open_attribute(attrpath);
-	if (!attr) {
-		err("open %s", attrpath);
-		return -1;
-	}
-
-	ret = sysfs_read_attribute(attr);
-	if (ret) {
-		err("read %s", attrpath);
-		sysfs_close_attribute(attr);
-		return -1;
-	}
-
-	value = atoi(attr->value);
-
-	sysfs_close_attribute(attr);
-
-	return value;
-}
-
-
-static void usbip_exported_device_delete(void *dev)
-{
-	struct usbip_exported_device *edev =
-		(struct usbip_exported_device *) dev;
-
-	sysfs_close_device(edev->sudev);
-	free(dev);
-}
-
-
-static struct usbip_exported_device *usbip_exported_device_new(char *sdevpath)
-{
-	struct usbip_exported_device *edev = NULL;
-
-	edev = (struct usbip_exported_device *) calloc(1, sizeof(*edev));
-	if (!edev) {
-		err("alloc device");
-		return NULL;
-	}
-
-	edev->sudev = sysfs_open_device_path(sdevpath);
-	if (!edev->sudev) {
-		err("open %s", sdevpath);
-		goto err;
-	}
-
-	read_usb_device(edev->sudev, &edev->udev);
-
-	edev->status = read_attr_usbip_status(&edev->udev);
-	if (edev->status < 0)
-		goto err;
-
-	/* reallocate buffer to include usb interface data */
-	size_t size = sizeof(*edev) + edev->udev.bNumInterfaces * sizeof(struct usb_interface);
-	edev = (struct usbip_exported_device *) realloc(edev, size);
-	if (!edev) {
-		err("alloc device");
-		goto err;
-	}
-
-	for (int i=0; i < edev->udev.bNumInterfaces; i++)
-		read_usb_interface(&edev->udev, i, &edev->uinf[i]);
-
-	return edev;
-
-err:
-	if (edev && edev->sudev)
-		sysfs_close_device(edev->sudev);
-	if (edev)
-		free(edev);
-	return NULL;
-}
-
-
-static int check_new(struct dlist *dlist, struct sysfs_device *target)
-{
-	struct sysfs_device *dev;
-
-	dlist_for_each_data(dlist, dev, struct sysfs_device) {
-		if (!strncmp(dev->bus_id, target->bus_id, SYSFS_BUS_ID_SIZE))
-			/* found. not new */
-			return 0;
-	}
-
-	return 1;
-}
-
-static void delete_nothing(void *dev)
-{
-	/* do not delete anything. but, its container will be deleted. */
-}
-
-static int refresh_exported_devices(void)
-{
-	struct sysfs_device	*suinf;  /* sysfs_device of usb_interface */
-	struct dlist		*suinf_list;
-
-	struct sysfs_device	*sudev;  /* sysfs_device of usb_device */
-	struct dlist		*sudev_list;
-
-
-	sudev_list = dlist_new_with_delete(sizeof(struct sysfs_device), delete_nothing);
-
-	suinf_list = sysfs_get_driver_devices(stub_driver->sysfs_driver);
-	if (!suinf_list) {
-		printf("Bind usbip.ko to a usb device to be exportable!\n");
-		goto bye;
-	}
-
-	/* collect unique USB devices (not interfaces) */
-	dlist_for_each_data(suinf_list, suinf, struct sysfs_device) {
-
-		/* get usb device of this usb interface */
-		sudev = sysfs_get_device_parent(suinf);
-		if (!sudev) {
-			err("get parent dev of %s", suinf->name);
-			continue;
-		}
-
-		if (check_new(sudev_list, sudev)) {
-			dlist_unshift(sudev_list, sudev);
-		}
-	}
-
-	dlist_for_each_data(sudev_list, sudev, struct sysfs_device) {
-		struct usbip_exported_device *edev;
-
-		edev = usbip_exported_device_new(sudev->path);
-		if (!edev) {
-			err("usbip_exported_device new");
-			continue;
-		}
-
-		dlist_unshift(stub_driver->edev_list, (void *) edev);
-		stub_driver->ndevs++;
-	}
-
-
-	dlist_destroy(sudev_list);
-
-bye:
-
-	return 0;
-}
-
-int usbip_stub_refresh_device_list(void)
-{
-	int ret;
-
-	if (stub_driver->edev_list)
-		dlist_destroy(stub_driver->edev_list);
-
-	stub_driver->ndevs = 0;
-
-	stub_driver->edev_list = dlist_new_with_delete(sizeof(struct usbip_exported_device),
-			usbip_exported_device_delete);
-	if (!stub_driver->edev_list) {
-		err("alloc dlist");
-		return -1;
-	}
-
-	ret = refresh_exported_devices();
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
-int usbip_stub_driver_open(void)
-{
-	int ret;
-
-
-	stub_driver = (struct usbip_stub_driver *) calloc(1, sizeof(*stub_driver));
-	if (!stub_driver) {
-		err("alloc stub_driver");
-		return -1;
-	}
-
-	stub_driver->ndevs = 0;
-
-	stub_driver->edev_list = dlist_new_with_delete(sizeof(struct usbip_exported_device),
-			usbip_exported_device_delete);
-	if (!stub_driver->edev_list) {
-		err("alloc dlist");
-		goto err;
-	}
-
-	stub_driver->sysfs_driver = open_sysfs_stub_driver();
-	if (!stub_driver->sysfs_driver)
-		goto err;
-
-	ret = refresh_exported_devices();
-	if (ret < 0)
-		goto err;
-
-	return 0;
-
-
-err:
-	if (stub_driver->sysfs_driver)
-		sysfs_close_driver(stub_driver->sysfs_driver);
-	if (stub_driver->edev_list)
-		dlist_destroy(stub_driver->edev_list);
-	free(stub_driver);
-
-	stub_driver = NULL;
-	return -1;
-}
-
-
-void usbip_stub_driver_close(void)
-{
-	if (!stub_driver)
-		return;
-
-	if (stub_driver->edev_list)
-		dlist_destroy(stub_driver->edev_list);
-	if (stub_driver->sysfs_driver)
-		sysfs_close_driver(stub_driver->sysfs_driver);
-	free(stub_driver);
-
-	stub_driver = NULL;
-}
-
-int usbip_stub_export_device(struct usbip_exported_device *edev, int sockfd)
-{
-	char attrpath[SYSFS_PATH_MAX];
-	struct sysfs_attribute *attr;
-	char sockfd_buff[30];
-	int ret;
-
-
-	if (edev->status != SDEV_ST_AVAILABLE) {
-		info("device not available, %s", edev->udev.busid);
-		switch( edev->status ) {
-			case SDEV_ST_ERROR:
-				info("     status SDEV_ST_ERROR");
-				break;
-			case SDEV_ST_USED:
-				info("     status SDEV_ST_USED");
-				break;
-			default:
-				info("     status unknown: 0x%x", edev->status);
-		}
-		return -1;
-	}
-
-	/* only the first interface is true */
-	snprintf(attrpath, sizeof(attrpath), "%s/%s:%d.%d/%s",
-			edev->udev.path,
-			edev->udev.busid,
-			edev->udev.bConfigurationValue, 0,
-			"usbip_sockfd");
-
-	attr = sysfs_open_attribute(attrpath);
-	if (!attr) {
-		err("open %s", attrpath);
-		return -1;
-	}
-
-	snprintf(sockfd_buff, sizeof(sockfd_buff), "%d\n", sockfd);
-
-	dbg("write: %s", sockfd_buff);
-
-	ret = sysfs_write_attribute(attr, sockfd_buff, strlen(sockfd_buff));
-	if (ret < 0) {
-		err("write sockfd %s to %s", sockfd_buff, attrpath);
-		goto err_write_sockfd;
-	}
-
-	info("connect %s", edev->udev.busid);
-
-err_write_sockfd:
-	sysfs_close_attribute(attr);
-
-	return ret;
-}
-
-struct usbip_exported_device *usbip_stub_get_device(int num)
-{
-	struct usbip_exported_device *edev;
-	struct dlist		*dlist = stub_driver->edev_list;
-	int count = 0;
-
-	dlist_for_each_data(dlist, edev, struct usbip_exported_device) {
-		if (num == count)
-			return edev;
-		else
-			count++ ;
-	}
-
-	return NULL;
-}
diff --git a/drivers/staging/usbip/userspace/lib/stub_driver.h b/drivers/staging/usbip/userspace/lib/stub_driver.h
deleted file mode 100644
index 3107d18..0000000
--- a/drivers/staging/usbip/userspace/lib/stub_driver.h
+++ /dev/null
@@ -1,36 +0,0 @@
-/*
- * Copyright (C) 2005-2007 Takahiro Hirofuchi
- */
-
-#ifndef _USBIP_STUB_DRIVER_H
-#define _USBIP_STUB_DRIVER_H
-
-#include "usbip.h"
-
-
-struct usbip_stub_driver {
-	int ndevs;
-	struct sysfs_driver *sysfs_driver;
-
-	struct dlist *edev_list;	/* list of exported device */
-};
-
-struct usbip_exported_device {
-	struct sysfs_device *sudev;
-
-	int32_t status;
-	struct usb_device    udev;
-	struct usb_interface uinf[];
-};
-
-
-extern struct usbip_stub_driver *stub_driver;
-
-int usbip_stub_driver_open(void);
-void usbip_stub_driver_close(void);
-
-int usbip_stub_refresh_device_list(void);
-int usbip_stub_export_device(struct usbip_exported_device *edev, int sockfd);
-
-struct usbip_exported_device *usbip_stub_get_device(int num);
-#endif
diff --git a/drivers/staging/usbip/userspace/lib/usbip.h b/drivers/staging/usbip/userspace/lib/usbip.h
deleted file mode 100644
index 7cb8e6f..0000000
--- a/drivers/staging/usbip/userspace/lib/usbip.h
+++ /dev/null
@@ -1,19 +0,0 @@
-/*
- * Copyright (C) 2005-2007 Takahiro Hirofuchi
- */
-
-#ifndef _USBIP_H
-#define _USBIP_H
-
-#ifdef HAVE_CONFIG_H
-#include "../config.h"
-#endif
-
-#include "usbip_common.h"
-#include "stub_driver.h"
-#include "vhci_driver.h"
-#ifdef DMALLOC
-#include <dmalloc.h>
-#endif
-
-#endif
diff --git a/drivers/staging/usbip/userspace/lib/usbip_common.c b/drivers/staging/usbip/userspace/lib/usbip_common.c
deleted file mode 100644
index a128a92..0000000
--- a/drivers/staging/usbip/userspace/lib/usbip_common.c
+++ /dev/null
@@ -1,282 +0,0 @@
-/*
- * Copyright (C) 2005-2007 Takahiro Hirofuchi
- */
-
-#include "usbip.h"
-#include "names.h"
-
-int usbip_use_syslog = 0;
-int usbip_use_stderr = 0;
-int usbip_use_debug  = 0;
-
-struct speed_string {
-	int num;
-	char *speed;
-	char *desc;
-};
-
-static const struct speed_string speed_strings[] = {
-	{ USB_SPEED_UNKNOWN, "unknown", "Unknown Speed"},
-	{ USB_SPEED_LOW,  "1.5", "Low Speed(1.5Mbps)"  },
-	{ USB_SPEED_FULL, "12",  "Full Speed(12Mbps)" },
-	{ USB_SPEED_HIGH, "480", "High Speed(480Mbps)" },
-	{ 0, NULL, NULL }
-};
-
-struct portst_string {
-	int num;
-	char *desc;
-};
-
-static struct portst_string portst_strings[] = {
-	{ SDEV_ST_AVAILABLE,	"Device Available" },
-	{ SDEV_ST_USED,		"Device in Use" },
-	{ SDEV_ST_ERROR,	"Device Error"},
-	{ VDEV_ST_NULL,		"Port Available"},
-	{ VDEV_ST_NOTASSIGNED,	"Port Initializing"},
-	{ VDEV_ST_USED,		"Port in Use"},
-	{ VDEV_ST_ERROR,	"Port Error"},
-	{ 0, NULL}
-};
-
-const char *usbip_status_string(int32_t status)
-{
-	for (int i=0; portst_strings[i].desc != NULL; i++)
-		if (portst_strings[i].num == status)
-			return portst_strings[i].desc;
-
-	return "Unknown Status";
-}
-
-const char *usbip_speed_string(int num)
-{
-	for (int i=0; speed_strings[i].speed != NULL; i++)
-		if (speed_strings[i].num == num)
-			return speed_strings[i].desc;
-
-	return "Unknown Speed";
-}
-
-
-#define DBG_UDEV_INTEGER(name)\
-	dbg("%-20s = %x", to_string(name), (int) udev->name)
-
-#define DBG_UINF_INTEGER(name)\
-	dbg("%-20s = %x", to_string(name), (int) uinf->name)
-
-void dump_usb_interface(struct usb_interface *uinf)
-{
-	char buff[100];
-	usbip_names_get_class(buff, sizeof(buff),
-			uinf->bInterfaceClass,
-			uinf->bInterfaceSubClass,
-			uinf->bInterfaceProtocol);
-	dbg("%-20s = %s", "Interface(C/SC/P)", buff);
-}
-
-void dump_usb_device(struct usb_device *udev)
-{
-	char buff[100];
-
-
-	dbg("%-20s = %s", "path",  udev->path);
-	dbg("%-20s = %s", "busid", udev->busid);
-
-	usbip_names_get_class(buff, sizeof(buff),
-			udev->bDeviceClass,
-			udev->bDeviceSubClass,
-			udev->bDeviceProtocol);
-	dbg("%-20s = %s", "Device(C/SC/P)", buff);
-
-	DBG_UDEV_INTEGER(bcdDevice);
-
-	usbip_names_get_product(buff, sizeof(buff),
-			udev->idVendor,
-			udev->idProduct);
-	dbg("%-20s = %s", "Vendor/Product", buff);
-
-	DBG_UDEV_INTEGER(bNumConfigurations);
-	DBG_UDEV_INTEGER(bNumInterfaces);
-
-	dbg("%-20s = %s", "speed",
-			usbip_speed_string(udev->speed));
-
-	DBG_UDEV_INTEGER(busnum);
-	DBG_UDEV_INTEGER(devnum);
-}
-
-
-int read_attr_value(struct sysfs_device *dev, const char *name, const char *format)
-{
-	char attrpath[SYSFS_PATH_MAX];
-	struct sysfs_attribute *attr;
-	int num = 0;
-	int ret;
-
-	snprintf(attrpath, sizeof(attrpath), "%s/%s", dev->path, name);
-
-	attr = sysfs_open_attribute(attrpath);
-	if (!attr) {
-		err("open attr %s", attrpath);
-		return 0;
-	}
-
-	ret = sysfs_read_attribute(attr);
-	if (ret < 0) {
-		err("read attr");
-		goto err;
-	}
-
-	ret = sscanf(attr->value, format, &num);
-	if (ret < 1) {
-		err("sscanf");
-		goto err;
-	}
-
-err:
-	sysfs_close_attribute(attr);
-
-	return num;
-}
-
-
-int read_attr_speed(struct sysfs_device *dev)
-{
-	char attrpath[SYSFS_PATH_MAX];
-	struct sysfs_attribute *attr;
-	char speed[100];
-	int ret;
-
-	snprintf(attrpath, sizeof(attrpath), "%s/%s", dev->path, "speed");
-
-	attr = sysfs_open_attribute(attrpath);
-	if (!attr) {
-		err("open attr");
-		return 0;
-	}
-
-	ret = sysfs_read_attribute(attr);
-	if (ret < 0) {
-		err("read attr");
-		goto err;
-	}
-
-	ret = sscanf(attr->value, "%s\n", speed);
-	if (ret < 1) {
-		err("sscanf");
-		goto err;
-	}
-err:
-	sysfs_close_attribute(attr);
-
-	for (int i=0; speed_strings[i].speed != NULL; i++) {
-		if (!strcmp(speed, speed_strings[i].speed))
-			return speed_strings[i].num;
-	}
-
-	return USB_SPEED_UNKNOWN;
-}
-
-#define READ_ATTR(object, type, dev, name, format)\
-	do { (object)->name = (type) read_attr_value(dev, to_string(name), format); } while (0)
-
-
-int read_usb_device(struct sysfs_device *sdev, struct usb_device *udev)
-{
-	uint32_t busnum, devnum;
-
-	READ_ATTR(udev, uint8_t,  sdev, bDeviceClass,		"%02x\n");
-	READ_ATTR(udev, uint8_t,  sdev, bDeviceSubClass,	"%02x\n");
-	READ_ATTR(udev, uint8_t,  sdev, bDeviceProtocol,	"%02x\n");
-
-	READ_ATTR(udev, uint16_t, sdev, idVendor,		"%04x\n");
-	READ_ATTR(udev, uint16_t, sdev, idProduct,		"%04x\n");
-	READ_ATTR(udev, uint16_t, sdev, bcdDevice,		"%04x\n");
-
-	READ_ATTR(udev, uint8_t,  sdev, bConfigurationValue,	"%02x\n");
-	READ_ATTR(udev, uint8_t,  sdev, bNumConfigurations,	"%02x\n");
-	READ_ATTR(udev, uint8_t,  sdev, bNumInterfaces,		"%02x\n");
-
-	READ_ATTR(udev, uint8_t,  sdev, devnum,			"%d\n");
-	udev->speed = read_attr_speed(sdev);
-
-	strncpy(udev->path,  sdev->path,  SYSFS_PATH_MAX);
-	strncpy(udev->busid, sdev->name, SYSFS_BUS_ID_SIZE);
-
-	sscanf(sdev->name, "%u-%u", &busnum, &devnum);
-	udev->busnum = busnum;
-
-	return 0;
-}
-
-int read_usb_interface(struct usb_device *udev, int i, struct usb_interface *uinf)
-{
-	char busid[SYSFS_BUS_ID_SIZE];
-	struct sysfs_device *sif;
-
-	sprintf(busid, "%s:%d.%d", udev->busid, udev->bConfigurationValue, i);
-
-	sif = sysfs_open_device("usb", busid);
-	if (!sif) {
-		err("open sif of %s", busid);
-		return -1;
-	}
-
-	READ_ATTR(uinf, uint8_t,  sif, bInterfaceClass,		"%02x\n");
-	READ_ATTR(uinf, uint8_t,  sif, bInterfaceSubClass,	"%02x\n");
-	READ_ATTR(uinf, uint8_t,  sif, bInterfaceProtocol,	"%02x\n");
-
-	sysfs_close_device(sif);
-
-	return 0;
-}
-
-int usbip_names_init(char *f)
-{
-	return names_init(f);
-}
-
-void usbip_names_free()
-{
-	names_free();
-}
-
-void usbip_names_get_product(char *buff, size_t size, uint16_t vendor, uint16_t product)
-{
-	const char *prod, *vend;
-
-	prod = names_product(vendor, product);
-	if (!prod)
-		prod = "unknown product";
-
-
-	vend = names_vendor(vendor);
-	if (!vend)
-		vend = "unknown vendor";
-
-	snprintf(buff, size, "%s : %s (%04x:%04x)", vend, prod, vendor, product);
-}
-
-void usbip_names_get_class(char *buff, size_t size, uint8_t class, uint8_t subclass, uint8_t protocol)
-{
-	const char *c, *s, *p;
-
-	if (class == 0 && subclass == 0 && protocol == 0) {
-		snprintf(buff, size, "(Defined at Interface level) (%02x/%02x/%02x)", class, subclass, protocol);
-		return;
-	}
-
-	p = names_protocol(class, subclass, protocol);
-	if (!p)
-		p = "unknown protocol";
-
-	s = names_subclass(class, subclass);
-	if (!s)
-		s = "unknown subclass";
-
-	c = names_class(class);
-	if (!c)
-		c = "unknown class";
-
-	snprintf(buff, size, "%s / %s / %s (%02x/%02x/%02x)", c, s, p, class, subclass, protocol);
-}
diff --git a/drivers/staging/usbip/userspace/lib/usbip_common.h b/drivers/staging/usbip/userspace/lib/usbip_common.h
deleted file mode 100644
index c254b54..0000000
--- a/drivers/staging/usbip/userspace/lib/usbip_common.h
+++ /dev/null
@@ -1,149 +0,0 @@
-/*
- * Copyright (C) 2005-2007 Takahiro Hirofuchi
- */
-
-#ifndef _USBIP_COMMON_H
-#define _USBIP_COMMON_H
-
-#include <unistd.h>
-#include <stdint.h>
-#include <syslog.h>
-#include <errno.h>
-#include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
-#include <strings.h>
-
-#include <sysfs/libsysfs.h>
-#include <netdb.h>
-#include <sys/socket.h>
-
-#ifndef USBIDS_FILE
-#define USBIDS_FILE "/usr/share/hwdata/usb.ids"
-#endif
-
-#ifndef VHCI_STATE_PATH
-#define VHCI_STATE_PATH "/var/run/vhci_hcd"
-#endif
-
-//#include <linux/usb_ch9.h>
-enum usb_device_speed {
-	USB_SPEED_UNKNOWN = 0,                  /* enumerating */
-	USB_SPEED_LOW, USB_SPEED_FULL,          /* usb 1.1 */
-	USB_SPEED_HIGH,                         /* usb 2.0 */
-	USB_SPEED_VARIABLE                      /* wireless (usb 2.5) */
-};
-
-/* FIXME: how to sync with drivers/usbip_common.h ? */
-enum usbip_device_status{
-	/* sdev is available. */
-	SDEV_ST_AVAILABLE = 0x01,
-	/* sdev is now used. */
-	SDEV_ST_USED,
-	/* sdev is unusable because of a fatal error. */
-	SDEV_ST_ERROR,
-
-	/* vdev does not connect a remote device. */
-	VDEV_ST_NULL,
-	/* vdev is used, but the USB address is not assigned yet */
-	VDEV_ST_NOTASSIGNED,
-	VDEV_ST_USED,
-	VDEV_ST_ERROR
-};
-
-extern int usbip_use_syslog;
-extern int usbip_use_stderr;
-extern int usbip_use_debug ;
-
-#define err(fmt, args...)	do { \
-	if (usbip_use_syslog) { \
-		syslog(LOG_ERR, "usbip err: %13s:%4d (%-12s) " fmt "\n", \
-			__FILE__, __LINE__, __FUNCTION__,  ##args); \
-	} \
-	if (usbip_use_stderr) { \
-		fprintf(stderr, "usbip err: %13s:%4d (%-12s) " fmt "\n", \
-			__FILE__, __LINE__, __FUNCTION__,  ##args); \
-	} \
-} while (0)
-
-#define notice(fmt, args...)	do { \
-	if (usbip_use_syslog) { \
-		syslog(LOG_DEBUG, "usbip: " fmt, ##args); \
-	} \
-	if (usbip_use_stderr) { \
-		fprintf(stderr, "usbip: " fmt "\n",  ##args); \
-	} \
-} while (0)
-
-#define info(fmt, args...)	do { \
-	if (usbip_use_syslog) { \
-		syslog(LOG_DEBUG, fmt, ##args); \
-	} \
-	if (usbip_use_stderr) { \
-		fprintf(stderr, fmt "\n",  ##args); \
-	} \
-} while (0)
-
-#define dbg(fmt, args...)	do { \
-	if (usbip_use_debug) { \
-		if (usbip_use_syslog) { \
-			syslog(LOG_DEBUG, "usbip dbg: %13s:%4d (%-12s) " fmt, \
-				__FILE__, __LINE__, __FUNCTION__,  ##args); \
-		} \
-		if (usbip_use_stderr) { \
-			fprintf(stderr, "usbip dbg: %13s:%4d (%-12s) " fmt "\n", \
-				__FILE__, __LINE__, __FUNCTION__,  ##args); \
-		} \
-	} \
-} while (0)
-
-
-#define BUG()	do { err("sorry, it's a bug"); abort(); } while (0)
-
-
-struct usb_interface {
-	uint8_t bInterfaceClass;
-	uint8_t bInterfaceSubClass;
-	uint8_t bInterfaceProtocol;
-	uint8_t padding;	/* alignment */
-} __attribute__((packed));
-
-
-
-struct usb_device {
-	char path[SYSFS_PATH_MAX];
-	char busid[SYSFS_BUS_ID_SIZE];
-
-	uint32_t busnum;
-	uint32_t devnum;
-	uint32_t speed;
-
-	uint16_t idVendor;
-	uint16_t idProduct;
-	uint16_t bcdDevice;
-
-	uint8_t bDeviceClass;
-	uint8_t bDeviceSubClass;
-	uint8_t bDeviceProtocol;
-	uint8_t bConfigurationValue;
-	uint8_t bNumConfigurations;
-	uint8_t bNumInterfaces;
-} __attribute__((packed));
-
-#define to_string(s)	#s
-
-void dump_usb_interface(struct usb_interface *);
-void dump_usb_device(struct usb_device *);
-int read_usb_device(struct sysfs_device *sdev, struct usb_device *udev);
-int read_attr_value(struct sysfs_device *dev, const char *name, const char *format);
-int read_usb_interface(struct usb_device *udev, int i, struct usb_interface *uinf);
-
-const char *usbip_speed_string(int num);
-const char *usbip_status_string(int32_t status);
-
-int usbip_names_init(char *);
-void usbip_names_free(void);
-void usbip_names_get_product(char *buff, size_t size, uint16_t vendor, uint16_t product);
-void usbip_names_get_class(char *buff, size_t size, uint8_t class, uint8_t subclass, uint8_t protocol);
-
-#endif
diff --git a/drivers/staging/usbip/userspace/lib/vhci_driver.c b/drivers/staging/usbip/userspace/lib/vhci_driver.c
deleted file mode 100644
index 5e54810..0000000
--- a/drivers/staging/usbip/userspace/lib/vhci_driver.c
+++ /dev/null
@@ -1,506 +0,0 @@
-/*
- * Copyright (C) 2005-2007 Takahiro Hirofuchi
- */
-
-
-#include "usbip.h"
-
-
-static const char vhci_driver_name[] = "vhci_hcd";
-
-struct usbip_vhci_driver *vhci_driver;
-
-static struct usbip_imported_device *imported_device_init(struct usbip_imported_device *idev, char *busid)
-{
-	struct sysfs_device *sudev;
-
-	sudev = sysfs_open_device("usb", busid);
-	if (!sudev) {
-		err("sysfs_open_device %s", busid);
-		goto err;
-	}
-	read_usb_device(sudev, &idev->udev);
-	sysfs_close_device(sudev);
-
-	/* add class devices of this imported device */
-	struct class_device *cdev;
-	dlist_for_each_data(vhci_driver->cdev_list, cdev, struct class_device) {
-		if (!strncmp(cdev->devpath, idev->udev.path, strlen(idev->udev.path))) {
-			struct class_device *new_cdev;
-
-			/* alloc and copy because dlist is linked from only one list */
-			new_cdev = calloc(1, sizeof(*new_cdev));
-			if (!new_cdev)
-				goto err;
-
-			memcpy(new_cdev, cdev, sizeof(*new_cdev));
-			dlist_unshift(idev->cdev_list, (void*) new_cdev);
-		}
-	}
-
-	return idev;
-
-err:
-	return NULL;
-}
-
-
-
-static int parse_status(char *value)
-{
-	int ret = 0;
-	char *c;
-
-
-	for (int i = 0; i < vhci_driver->nports; i++)
-		bzero(&vhci_driver->idev[i], sizeof(struct usbip_imported_device));
-
-
-	/* skip a header line */
-	c = strchr(value, '\n') + 1;
-
-	while (*c != '\0') {
-		int port, status, speed, devid;
-		unsigned long socket;
-		char lbusid[SYSFS_BUS_ID_SIZE];
-
-		ret = sscanf(c, "%d %d %d %x %lx %s\n",
-				&port, &status, &speed,
-				&devid, &socket, lbusid);
-
-		if (ret < 5) {
-			err("scanf %d", ret);
-			BUG();
-		}
-
-		dbg("port %d status %d speed %d devid %x",
-				port, status, speed, devid);
-		dbg("socket %lx lbusid %s", socket, lbusid);
-
-
-		/* if a device is connected, look at it */
-		{
-			struct usbip_imported_device *idev = &vhci_driver->idev[port];
-
-			idev->port	= port;
-			idev->status	= status;
-
-			idev->devid	= devid;
-
-			idev->busnum	= (devid >> 16);
-			idev->devnum	= (devid & 0x0000ffff);
-
-			idev->cdev_list = dlist_new(sizeof(struct class_device));
-			if (!idev->cdev_list) {
-				err("init new device");
-				return -1;
-			}
-
-			if (idev->status != VDEV_ST_NULL && idev->status != VDEV_ST_NOTASSIGNED) {
-				idev = imported_device_init(idev, lbusid);
-				if (!idev) {
-					err("init new device");
-					return -1;
-				}
-			}
-		}
-
-
-		/* go to the next line */
-		c = strchr(c, '\n') + 1;
-	}
-
-	dbg("exit");
-
-	return 0;
-}
-
-
-static int check_usbip_device(struct sysfs_class_device *cdev)
-{
-	char clspath[SYSFS_PATH_MAX];	/* /sys/class/video4linux/video0/device     */
-	char devpath[SYSFS_PATH_MAX];	/* /sys/devices/platform/vhci_hcd/usb6/6-1:1.1  */
-
-	int ret;
-
-	snprintf(clspath, sizeof(clspath), "%s/device", cdev->path);
-
-	ret = sysfs_get_link(clspath, devpath, SYSFS_PATH_MAX);
-	if (!ret) {
-		if (!strncmp(devpath, vhci_driver->hc_device->path,
-					strlen(vhci_driver->hc_device->path))) {
-			/* found usbip device */
-			struct class_device *cdev;
-
-			cdev = calloc(1, sizeof(*cdev));
-			if (!cdev) {
-				err("calloc cdev");
-				return -1;
-			}
-			dlist_unshift(vhci_driver->cdev_list, (void*) cdev);
-			strncpy(cdev->clspath, clspath, sizeof(cdev->clspath));
-			strncpy(cdev->devpath, devpath, sizeof(cdev->clspath));
-			dbg("  found %s %s", clspath, devpath);
-		}
-	}
-
-	return 0;
-}
-
-
-static int search_class_for_usbip_device(char *cname)
-{
-	struct sysfs_class *class;
-	struct dlist *cdev_list;
-	struct sysfs_class_device *cdev;
-	int ret = 0;
-
-	class = sysfs_open_class(cname);
-	if (!class) {
-		err("open class");
-		return -1;
-	}
-
-	dbg("class %s", class->name);
-
-	cdev_list = sysfs_get_class_devices(class);
-	if (!cdev_list)
-		/* nothing */
-		goto out;
-
-	dlist_for_each_data(cdev_list, cdev, struct sysfs_class_device) {
-		dbg("   cdev %s", cdev->name);
-		ret = check_usbip_device(cdev);
-		if (ret < 0)
-			goto out;
-	}
-
-out:
-	sysfs_close_class(class);
-
-	return ret;
-}
-
-
-static int refresh_class_device_list(void)
-{
-	int ret;
-	struct dlist *cname_list;
-	char *cname;
-
-	/* search under /sys/class */
-	cname_list = sysfs_open_directory_list("/sys/class");
-	if (!cname_list) {
-		err("open class directory");
-		return -1;
-	}
-
-	dlist_for_each_data(cname_list, cname, char) {
-		ret = search_class_for_usbip_device(cname);
-		if (ret < 0) {
-			sysfs_close_list(cname_list);
-			return -1;
-		}
-	}
-
-	sysfs_close_list(cname_list);
-
-	/* seach under /sys/block */
-	ret = search_class_for_usbip_device(SYSFS_BLOCK_NAME);
-	if (ret < 0)
-		return -1;
-
-	return 0;
-}
-
-
-static int refresh_imported_device_list(void)
-{
-	struct sysfs_attribute *attr_status;
-
-
-	attr_status = sysfs_get_device_attr(vhci_driver->hc_device, "status");
-	if (!attr_status) {
-		err("get attr %s of %s", "status", vhci_driver->hc_device->name);
-		return -1;
-	}
-
-	dbg("name %s, path %s, len %d, method %d\n", attr_status->name,
-			attr_status->path, attr_status->len, attr_status->method);
-
-	dbg("%s", attr_status->value);
-
-	return parse_status(attr_status->value);
-}
-
-static int get_nports(void)
-{
-	int nports = 0;
-	struct sysfs_attribute *attr_status;
-
-	attr_status = sysfs_get_device_attr(vhci_driver->hc_device, "status");
-	if (!attr_status) {
-		err("get attr %s of %s", "status", vhci_driver->hc_device->name);
-		return -1;
-	}
-
-	dbg("name %s, path %s, len %d, method %d\n", attr_status->name,
-			attr_status->path, attr_status->len, attr_status->method);
-
-	dbg("%s", attr_status->value);
-
-	{
-		char *c;
-
-		/* skip a header line */
-		c = strchr(attr_status->value, '\n') + 1;
-
-		while (*c != '\0') {
-			/* go to the next line */
-			c = strchr(c, '\n') + 1;
-			nports += 1;
-		}
-	}
-
-	return nports;
-}
-
-static int get_hc_busid(char *sysfs_mntpath, char *hc_busid)
-{
-        struct sysfs_driver *sdriver;
-        char sdriver_path[SYSFS_PATH_MAX];
-
-	struct sysfs_device *hc_dev;
-	struct dlist *hc_devs;
-
-	int found = 0;
-
-        snprintf(sdriver_path, SYSFS_PATH_MAX, "%s/%s/platform/%s/%s",
-                                sysfs_mntpath, SYSFS_BUS_NAME, SYSFS_DRIVERS_NAME,
-                                vhci_driver_name);
-
-        sdriver = sysfs_open_driver_path(sdriver_path);
-        if (!sdriver) {
-		info("%s is not found", sdriver_path);
-                info("load usbip_common_mod.ko and vhci-hcd.ko !");
-                return -1;
-        }
-
-	hc_devs = sysfs_get_driver_devices(sdriver);
-	if (!hc_devs) {
-		err("get hc list");
-		goto err;
-	}
-
-	/* assume only one vhci_hcd */
-	dlist_for_each_data(hc_devs, hc_dev, struct sysfs_device) {
-		strncpy(hc_busid, hc_dev->bus_id, SYSFS_BUS_ID_SIZE);
-		found = 1;
-	}
-
-err:
-	sysfs_close_driver(sdriver);
-
-	if (found)
-		return 0;
-
-	err("not found usbip hc");
-	return -1;
-}
-
-
-/* ---------------------------------------------------------------------- */
-
-int usbip_vhci_driver_open(void)
-{
-	int ret;
-	char hc_busid[SYSFS_BUS_ID_SIZE];
-
-	vhci_driver = (struct usbip_vhci_driver *) calloc(1, sizeof(*vhci_driver));
-	if (!vhci_driver) {
-		err("alloc vhci_driver");
-		return -1;
-	}
-
-	ret = sysfs_get_mnt_path(vhci_driver->sysfs_mntpath, SYSFS_PATH_MAX);
-	if (ret < 0) {
-		err("sysfs must be mounted");
-		goto err;
-	}
-
-	ret = get_hc_busid(vhci_driver->sysfs_mntpath, hc_busid);
-	if (ret < 0)
-		goto err;
-
-	/* will be freed in usbip_driver_close() */
-	vhci_driver->hc_device = sysfs_open_device("platform", hc_busid);
-	if (!vhci_driver->hc_device) {
-		err("get sysfs vhci_driver");
-		goto err;
-	}
-
-	vhci_driver->nports = get_nports();
-
-	info("%d ports available\n", vhci_driver->nports);
-
-	vhci_driver->cdev_list = dlist_new(sizeof(struct class_device));
-	if (!vhci_driver->cdev_list)
-		goto err;
-
-	if (refresh_class_device_list())
-		goto err;
-
-	if (refresh_imported_device_list())
-		goto err;
-
-
-	return 0;
-
-
-err:
-	if (vhci_driver->cdev_list)
-		dlist_destroy(vhci_driver->cdev_list);
-	if (vhci_driver->hc_device)
-		sysfs_close_device(vhci_driver->hc_device);
-	if (vhci_driver)
-		free(vhci_driver);
-
-	vhci_driver = NULL;
-	return -1;
-}
-
-
-void usbip_vhci_driver_close()
-{
-	if (!vhci_driver)
-		return;
-
-	if (vhci_driver->cdev_list)
-		dlist_destroy(vhci_driver->cdev_list);
-
-	for (int i = 0; i < vhci_driver->nports; i++) {
-		if (vhci_driver->idev[i].cdev_list)
-			dlist_destroy(vhci_driver->idev[i].cdev_list);
-	}
-
-	if (vhci_driver->hc_device)
-		sysfs_close_device(vhci_driver->hc_device);
-	free(vhci_driver);
-
-	vhci_driver = NULL;
-}
-
-
-int usbip_vhci_refresh_device_list(void)
-{
-	if (vhci_driver->cdev_list)
-		dlist_destroy(vhci_driver->cdev_list);
-
-
-	for (int i = 0; i < vhci_driver->nports; i++) {
-		if (vhci_driver->idev[i].cdev_list)
-			dlist_destroy(vhci_driver->idev[i].cdev_list);
-	}
-
-	vhci_driver->cdev_list = dlist_new(sizeof(struct class_device));
-	if (!vhci_driver->cdev_list)
-		goto err;
-
-	if (refresh_class_device_list())
-		goto err;
-
-	if (refresh_imported_device_list())
-		goto err;
-
-	return 0;
-err:
-	if (vhci_driver->cdev_list)
-		dlist_destroy(vhci_driver->cdev_list);
-
-	for (int i = 0; i < vhci_driver->nports; i++) {
-		if (vhci_driver->idev[i].cdev_list)
-			dlist_destroy(vhci_driver->idev[i].cdev_list);
-	}
-
-	err("refresh device list");
-	return -1;
-}
-
-
-int usbip_vhci_get_free_port(void)
-{
-	for (int i = 0; i < vhci_driver->nports; i++) {
-		if (vhci_driver->idev[i].status == VDEV_ST_NULL)
-			return i;
-	}
-
-	return -1;
-}
-
-int usbip_vhci_attach_device2(uint8_t port, int sockfd, uint32_t devid,
-		uint32_t speed) {
-	struct sysfs_attribute *attr_attach;
-	char buff[200]; /* what size should be ? */
-	int ret;
-
-	attr_attach = sysfs_get_device_attr(vhci_driver->hc_device, "attach");
-	if (!attr_attach) {
-		err("get attach");
-		return -1;
-	}
-
-	snprintf(buff, sizeof(buff), "%u %u %u %u",
-			port, sockfd, devid, speed);
-	dbg("writing: %s", buff);
-
-	ret = sysfs_write_attribute(attr_attach, buff, strlen(buff));
-	if (ret < 0) {
-		err("write to attach failed");
-		return -1;
-	}
-
-	info("port %d attached", port);
-
-	return 0;
-}
-
-static unsigned long get_devid(uint8_t busnum, uint8_t devnum)
-{
-	return (busnum << 16) | devnum;
-}
-
-/* will be removed */
-int usbip_vhci_attach_device(uint8_t port, int sockfd, uint8_t busnum,
-		uint8_t devnum, uint32_t speed)
-{
-	int devid = get_devid(busnum, devnum);
-
-	return usbip_vhci_attach_device2(port, sockfd, devid, speed);
-}
-
-int usbip_vhci_detach_device(uint8_t port)
-{
-	struct sysfs_attribute  *attr_detach;
-	char buff[200]; /* what size should be ? */
-	int ret;
-
-	attr_detach = sysfs_get_device_attr(vhci_driver->hc_device, "detach");
-	if (!attr_detach) {
-		err("get detach");
-		return -1;
-	}
-
-	snprintf(buff, sizeof(buff), "%u", port);
-	dbg("writing to detach");
-	dbg("writing: %s", buff);
-
-	ret = sysfs_write_attribute(attr_detach, buff, strlen(buff));
-	if (ret < 0) {
-		err("write to detach failed");
-		return -1;
-	}
-
-	info("port %d detached", port);
-
-	return 0;
-}
diff --git a/drivers/staging/usbip/userspace/lib/vhci_driver.h b/drivers/staging/usbip/userspace/lib/vhci_driver.h
deleted file mode 100644
index cad8ad7..0000000
--- a/drivers/staging/usbip/userspace/lib/vhci_driver.h
+++ /dev/null
@@ -1,61 +0,0 @@
-/*
- * Copyright (C) 2005-2007 Takahiro Hirofuchi
- */
-
-#ifndef _VHCI_DRIVER_H
-#define _VHCI_DRIVER_H
-
-#include "usbip.h"
-
-
-
-#define MAXNPORT 128
-
-struct class_device {
-	char clspath[SYSFS_PATH_MAX];
-	char devpath[SYSFS_PATH_MAX];
-};
-
-struct usbip_imported_device {
-	uint8_t port;
-	uint32_t status;
-
-	uint32_t devid;
-
-	uint8_t busnum;
-	uint8_t devnum;
-
-
-	struct dlist *cdev_list;	/* list of class device */
-	struct usb_device udev;
-};
-
-struct usbip_vhci_driver {
-	char sysfs_mntpath[SYSFS_PATH_MAX];
-	struct sysfs_device *hc_device; /* /sys/devices/platform/vhci_hcd */
-
-	struct dlist *cdev_list;	/* list of class device */
-
-	int nports;
-	struct usbip_imported_device idev[MAXNPORT];
-};
-
-
-extern struct usbip_vhci_driver *vhci_driver;
-
-int usbip_vhci_driver_open(void);
-void usbip_vhci_driver_close(void);
-
-int  usbip_vhci_refresh_device_list(void);
-
-
-int usbip_vhci_get_free_port(void);
-int usbip_vhci_attach_device2(uint8_t port, int sockfd, uint32_t devid,
-		uint32_t speed);
-
-/* will be removed */
-int usbip_vhci_attach_device(uint8_t port, int sockfd, uint8_t busnum,
-		uint8_t devnum, uint32_t speed);
-
-int usbip_vhci_detach_device(uint8_t port);
-#endif
diff --git a/drivers/staging/usbip/userspace/libsrc/Makefile.am b/drivers/staging/usbip/userspace/libsrc/Makefile.am
new file mode 100644
index 0000000..10b919d
--- /dev/null
+++ b/drivers/staging/usbip/userspace/libsrc/Makefile.am
@@ -0,0 +1,10 @@
+# AM_CFLAGS = -Wall -std=gnu99
+lib_LTLIBRARIES = libusbip.la
+libusbip_la_SOURCES = names.c names.h stub_driver.c stub_driver.h usbip.h usbip_common.c usbip_common.h vhci_driver.c vhci_driver.h
+#libusbip_la_SOURCES = names.c names.h stub_driver.c usbip_common.c vhci_driver.c
+#INCLUDES = -I../include
+#AM_CPPFLAGS = -I../include -Wall -std=gnu99
+libusbip_la_LDFLAGS = -version-info 0:1:0
+EXTRA_CFLAGS = @EXTRA_CFLAGS@
+libusbip_la_CFLAGS = -Wall -W -Wstrict-prototypes -std=gnu99 $(EXTRA_CFLAGS) -DUSBIDS_FILE='"@USBIDS_DIR@/usb.ids"'
+
diff --git a/drivers/staging/usbip/userspace/libsrc/names.c b/drivers/staging/usbip/userspace/libsrc/names.c
new file mode 100644
index 0000000..b4de18b
--- /dev/null
+++ b/drivers/staging/usbip/userspace/libsrc/names.c
@@ -0,0 +1,793 @@
+/*****************************************************************************/
+/*
+ *      names.c  --  USB name database manipulation routines
+ *
+ *      Copyright (C) 1999, 2000  Thomas Sailer (sailer@ife.ee.ethz.ch)
+ *
+ *      This program is free software; you can redistribute it and/or modify
+ *      it under the terms of the GNU General Public License as published by
+ *      the Free Software Foundation; either version 2 of the License, or
+ *      (at your option) any later version.
+ *
+ *      This program is distributed in the hope that it will be useful,
+ *      but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *      GNU General Public License for more details.
+ *
+ *      You should have received a copy of the GNU General Public License
+ *      along with this program; if not, write to the Free Software
+ *      Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ *
+ */
+
+/*
+ * 	Copyright (C) 2005 Takahiro Hirofuchi
+ * 		- names_deinit() is added.
+ */
+
+/*****************************************************************************/
+
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <dirent.h>
+#include <string.h>
+#include <errno.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <ctype.h>
+
+
+#include "names.h"
+
+
+/* ---------------------------------------------------------------------- */
+
+struct vendor {
+	struct vendor *next;
+	u_int16_t vendorid;
+	char name[1];
+};
+
+struct product {
+	struct product *next;
+	u_int16_t vendorid, productid;
+	char name[1];
+};
+
+struct class {
+	struct class *next;
+	u_int8_t classid;
+	char name[1];
+};
+
+struct subclass {
+	struct subclass *next;
+	u_int8_t classid, subclassid;
+	char name[1];
+};
+
+struct protocol {
+	struct protocol *next;
+	u_int8_t classid, subclassid, protocolid;
+	char name[1];
+};
+
+struct audioterminal {
+	struct audioterminal *next;
+	u_int16_t termt;
+	char name[1];
+};
+
+struct genericstrtable {
+        struct genericstrtable *next;
+        unsigned int num;
+        char name[1];
+};
+
+/* ---------------------------------------------------------------------- */
+
+#define HASH1  0x10
+#define HASH2  0x02
+#define HASHSZ 16
+
+static unsigned int hashnum(unsigned int num)
+{
+	unsigned int mask1 = HASH1 << 27, mask2 = HASH2 << 27;
+
+	for (; mask1 >= HASH1; mask1 >>= 1, mask2 >>= 1)
+		if (num & mask1)
+			num ^= mask2;
+	return num & (HASHSZ-1);
+}
+
+/* ---------------------------------------------------------------------- */
+
+static struct vendor *vendors[HASHSZ] = { NULL, };
+static struct product *products[HASHSZ] = { NULL, };
+static struct class *classes[HASHSZ] = { NULL, };
+static struct subclass *subclasses[HASHSZ] = { NULL, };
+static struct protocol *protocols[HASHSZ] = { NULL, };
+static struct audioterminal *audioterminals[HASHSZ] = { NULL, };
+static struct genericstrtable *hiddescriptors[HASHSZ] = { NULL, };
+static struct genericstrtable *reports[HASHSZ] = { NULL, };
+static struct genericstrtable *huts[HASHSZ] = { NULL, };
+static struct genericstrtable *biass[HASHSZ] = { NULL, };
+static struct genericstrtable *physdess[HASHSZ] = { NULL, };
+static struct genericstrtable *hutus[HASHSZ] = { NULL, };
+static struct genericstrtable *langids[HASHSZ] = { NULL, };
+static struct genericstrtable *countrycodes[HASHSZ] = { NULL, };
+
+/* ---------------------------------------------------------------------- */
+
+static const char *names_genericstrtable(struct genericstrtable *t[HASHSZ], unsigned int index)
+{
+        struct genericstrtable *h;
+
+        for (h = t[hashnum(index)]; h; h = h->next)
+                if (h->num == index)
+                        return h->name;
+        return NULL;
+}
+
+const char *names_hid(u_int8_t hidd)
+{
+	return names_genericstrtable(hiddescriptors, hidd);
+}
+
+const char *names_reporttag(u_int8_t rt)
+{
+	return names_genericstrtable(reports, rt);
+}
+
+const char *names_huts(unsigned int data)
+{
+	return names_genericstrtable(huts, data);
+}
+
+const char *names_hutus(unsigned int data)
+{
+	return names_genericstrtable(hutus, data);
+}
+
+const char *names_langid(u_int16_t langid)
+{
+	return names_genericstrtable(langids, langid);
+}
+
+const char *names_physdes(u_int8_t ph)
+{
+	return names_genericstrtable(physdess, ph);
+}
+
+const char *names_bias(u_int8_t b)
+{
+	return names_genericstrtable(biass, b);
+}
+
+const char *names_countrycode(unsigned int countrycode)
+{
+	return names_genericstrtable(countrycodes, countrycode);
+}
+
+const char *names_vendor(u_int16_t vendorid)
+{
+	struct vendor *v;
+
+	v = vendors[hashnum(vendorid)];
+	for (; v; v = v->next)
+		if (v->vendorid == vendorid)
+			return v->name;
+	return NULL;
+}
+
+const char *names_product(u_int16_t vendorid, u_int16_t productid)
+{
+	struct product *p;
+
+	p = products[hashnum((vendorid << 16) | productid)];
+	for (; p; p = p->next)
+		if (p->vendorid == vendorid && p->productid == productid)
+			return p->name;
+	return NULL;
+}
+
+const char *names_class(u_int8_t classid)
+{
+	struct class *c;
+
+	c = classes[hashnum(classid)];
+	for (; c; c = c->next)
+		if (c->classid == classid)
+			return c->name;
+	return NULL;
+}
+
+const char *names_subclass(u_int8_t classid, u_int8_t subclassid)
+{
+	struct subclass *s;
+
+	s = subclasses[hashnum((classid << 8) | subclassid)];
+	for (; s; s = s->next)
+		if (s->classid == classid && s->subclassid == subclassid)
+			return s->name;
+	return NULL;
+}
+
+const char *names_protocol(u_int8_t classid, u_int8_t subclassid, u_int8_t protocolid)
+{
+	struct protocol *p;
+
+	p = protocols[hashnum((classid << 16) | (subclassid << 8) | protocolid)];
+	for (; p; p = p->next)
+		if (p->classid == classid && p->subclassid == subclassid && p->protocolid == protocolid)
+			return p->name;
+	return NULL;
+}
+
+const char *names_audioterminal(u_int16_t termt)
+{
+	struct audioterminal *at;
+
+	at = audioterminals[hashnum(termt)];
+	for (; at; at = at->next)
+		if (at->termt == termt)
+			return at->name;
+	return NULL;
+}
+
+/* ---------------------------------------------------------------------- */
+/* add a cleanup function by takahiro */
+
+struct pool {
+	struct pool *next;
+	void *mem;
+};
+
+static struct pool *pool_head = NULL;
+
+static void *my_malloc(size_t size)
+{
+	struct pool *p;
+
+	p = calloc(1, sizeof(struct pool));
+	if (!p) {
+		free(p);
+		return NULL;
+	}
+
+	p->mem = calloc(1, size);
+	if (!p->mem)
+		return NULL;
+
+	p->next = pool_head;
+	pool_head = p;
+
+	return p->mem;
+}
+
+void names_free(void)
+{
+	struct pool *pool;
+
+	if (!pool_head)
+		return;
+
+	for (pool = pool_head; pool != NULL; ) {
+		struct pool *tmp;
+
+		if (pool->mem)
+			free(pool->mem);
+
+		tmp = pool;
+		pool = pool->next;
+		free(tmp);
+	}
+}
+
+/* ---------------------------------------------------------------------- */
+
+static int new_vendor(const char *name, u_int16_t vendorid)
+{
+	struct vendor *v;
+	unsigned int h = hashnum(vendorid);
+
+	v = vendors[h];
+	for (; v; v = v->next)
+		if (v->vendorid == vendorid)
+			return -1;
+	v = my_malloc(sizeof(struct vendor) + strlen(name));
+	if (!v)
+		return -1;
+	strcpy(v->name, name);
+	v->vendorid = vendorid;
+	v->next = vendors[h];
+	vendors[h] = v;
+	return 0;
+}
+
+static int new_product(const char *name, u_int16_t vendorid, u_int16_t productid)
+{
+	struct product *p;
+	unsigned int h = hashnum((vendorid << 16) | productid);
+
+	p = products[h];
+	for (; p; p = p->next)
+		if (p->vendorid == vendorid && p->productid == productid)
+			return -1;
+	p = my_malloc(sizeof(struct product) + strlen(name));
+	if (!p)
+		return -1;
+	strcpy(p->name, name);
+	p->vendorid = vendorid;
+	p->productid = productid;
+	p->next = products[h];
+	products[h] = p;
+	return 0;
+}
+
+static int new_class(const char *name, u_int8_t classid)
+{
+	struct class *c;
+	unsigned int h = hashnum(classid);
+
+	c = classes[h];
+	for (; c; c = c->next)
+		if (c->classid == classid)
+			return -1;
+	c = my_malloc(sizeof(struct class) + strlen(name));
+	if (!c)
+		return -1;
+	strcpy(c->name, name);
+	c->classid = classid;
+	c->next = classes[h];
+	classes[h] = c;
+	return 0;
+}
+
+static int new_subclass(const char *name, u_int8_t classid, u_int8_t subclassid)
+{
+	struct subclass *s;
+	unsigned int h = hashnum((classid << 8) | subclassid);
+
+	s = subclasses[h];
+	for (; s; s = s->next)
+		if (s->classid == classid && s->subclassid == subclassid)
+			return -1;
+	s = my_malloc(sizeof(struct subclass) + strlen(name));
+	if (!s)
+		return -1;
+	strcpy(s->name, name);
+	s->classid = classid;
+	s->subclassid = subclassid;
+	s->next = subclasses[h];
+	subclasses[h] = s;
+	return 0;
+}
+
+static int new_protocol(const char *name, u_int8_t classid, u_int8_t subclassid, u_int8_t protocolid)
+{
+	struct protocol *p;
+	unsigned int h = hashnum((classid << 16) | (subclassid << 8) | protocolid);
+
+	p = protocols[h];
+	for (; p; p = p->next)
+		if (p->classid == classid && p->subclassid == subclassid && p->protocolid == protocolid)
+			return -1;
+	p = my_malloc(sizeof(struct protocol) + strlen(name));
+	if (!p)
+		return -1;
+	strcpy(p->name, name);
+	p->classid = classid;
+	p->subclassid = subclassid;
+	p->protocolid = protocolid;
+	p->next = protocols[h];
+	protocols[h] = p;
+	return 0;
+}
+
+static int new_audioterminal(const char *name, u_int16_t termt)
+{
+	struct audioterminal *at;
+	unsigned int h = hashnum(termt);
+
+	at = audioterminals[h];
+	for (; at; at = at->next)
+		if (at->termt == termt)
+			return -1;
+	at = my_malloc(sizeof(struct audioterminal) + strlen(name));
+	if (!at)
+		return -1;
+	strcpy(at->name, name);
+	at->termt = termt;
+	at->next = audioterminals[h];
+	audioterminals[h] = at;
+	return 0;
+}
+
+static int new_genericstrtable(struct genericstrtable *t[HASHSZ], const char *name, unsigned int index)
+{
+        struct genericstrtable *g;
+	unsigned int h = hashnum(index);
+
+        for (g = t[h]; g; g = g->next)
+                if (g->num == index)
+                        return -1;
+        g = my_malloc(sizeof(struct genericstrtable) + strlen(name));
+        if (!g)
+                return -1;
+        strcpy(g->name, name);
+        g->num = index;
+        g->next = t[h];
+        t[h] = g;
+        return 0;
+}
+
+static int new_hid(const char *name, u_int8_t hidd)
+{
+	return new_genericstrtable(hiddescriptors, name, hidd);
+}
+
+static int new_reporttag(const char *name, u_int8_t rt)
+{
+	return new_genericstrtable(reports, name, rt);
+}
+
+static int new_huts(const char *name, unsigned int data)
+{
+	return new_genericstrtable(huts, name, data);
+}
+
+static int new_hutus(const char *name, unsigned int data)
+{
+	return new_genericstrtable(hutus, name, data);
+}
+
+static int new_langid(const char *name, u_int16_t langid)
+{
+	return new_genericstrtable(langids, name, langid);
+}
+
+static int new_physdes(const char *name, u_int8_t ph)
+{
+	return new_genericstrtable(physdess, name, ph);
+}
+static int new_bias(const char *name, u_int8_t b)
+{
+	return new_genericstrtable(biass, name, b);
+}
+
+static int new_countrycode(const char *name, unsigned int countrycode)
+{
+	return new_genericstrtable(countrycodes, name, countrycode);
+}
+
+/* ---------------------------------------------------------------------- */
+
+#define DBG(x)
+
+static void parse(FILE *f)
+{
+	char buf[512], *cp;
+	unsigned int linectr = 0;
+	int lastvendor = -1, lastclass = -1, lastsubclass = -1, lasthut=-1, lastlang=-1;
+	unsigned int u;
+
+	while (fgets(buf, sizeof(buf), f)) {
+		linectr++;
+		/* remove line ends */
+		if ((cp = strchr(buf, 13)))
+			*cp = 0;
+		if ((cp = strchr(buf, 10)))
+			*cp = 0;
+		if (buf[0] == '#' || !buf[0])
+			continue;
+		cp = buf;
+                if (buf[0] == 'P' && buf[1] == 'H' && buf[2] == 'Y' && buf[3] == 'S' && buf[4] == 'D' &&
+                    buf[5] == 'E' && buf[6] == 'S' && /*isspace(buf[7])*/ buf[7] == ' ') {
+                        cp = buf + 8;
+                        while (isspace(*cp))
+                                cp++;
+                        if (!isxdigit(*cp)) {
+                                fprintf(stderr, "Invalid Physdes type at line %u\n", linectr);
+                                continue;
+                        }
+                        u = strtoul(cp, &cp, 16);
+                        while (isspace(*cp))
+                                cp++;
+                        if (!*cp) {
+                                fprintf(stderr, "Invalid Physdes type at line %u\n", linectr);
+                                continue;
+                        }
+                        if (new_physdes(cp, u))
+                                fprintf(stderr, "Duplicate Physdes  type spec at line %u terminal type %04x %s\n", linectr, u, cp);
+                        DBG(printf("line %5u physdes type %02x %s\n", linectr, u, cp));
+                        continue;
+
+                }
+                if (buf[0] == 'P' && buf[1] == 'H' && buf[2] == 'Y' && /*isspace(buf[3])*/ buf[3] == ' ') {
+                        cp = buf + 4;
+                        while (isspace(*cp))
+                                cp++;
+                        if (!isxdigit(*cp)) {
+                                fprintf(stderr, "Invalid PHY type at line %u\n", linectr);
+                                continue;
+                        }
+                        u = strtoul(cp, &cp, 16);
+                        while (isspace(*cp))
+                                cp++;
+                        if (!*cp) {
+                                fprintf(stderr, "Invalid PHY type at line %u\n", linectr);
+                                continue;
+                        }
+                        if (new_physdes(cp, u))
+                                fprintf(stderr, "Duplicate PHY type spec at line %u terminal type %04x %s\n", linectr, u, cp);
+                        DBG(printf("line %5u PHY type %02x %s\n", linectr, u, cp));
+                        continue;
+
+                }
+                if (buf[0] == 'B' && buf[1] == 'I' && buf[2] == 'A' && buf[3] == 'S' && /*isspace(buf[4])*/ buf[4] == ' ') {
+                        cp = buf + 5;
+                        while (isspace(*cp))
+                                cp++;
+                        if (!isxdigit(*cp)) {
+                                fprintf(stderr, "Invalid BIAS type at line %u\n", linectr);
+                                continue;
+                        }
+                        u = strtoul(cp, &cp, 16);
+                        while (isspace(*cp))
+                                cp++;
+                        if (!*cp) {
+                                fprintf(stderr, "Invalid BIAS type at line %u\n", linectr);
+                                continue;
+                        }
+                        if (new_bias(cp, u))
+                                fprintf(stderr, "Duplicate BIAS  type spec at line %u terminal type %04x %s\n", linectr, u, cp);
+                        DBG(printf("line %5u BIAS type %02x %s\n", linectr, u, cp));
+                        continue;
+
+                }
+                if (buf[0] == 'L' && /*isspace(buf[1])*/ buf[1] == ' ') {
+                        cp =  buf+2;
+                        while (isspace(*cp))
+                                cp++;
+                        if (!isxdigit(*cp)) {
+                                fprintf(stderr, "Invalid LANGID spec at line %u\n", linectr);
+                                continue;
+                        }
+                        u = strtoul(cp, &cp, 16);
+                        while (isspace(*cp))
+                                cp++;
+                        if (!*cp) {
+                                fprintf(stderr, "Invalid LANGID spec at line %u\n", linectr);
+                                continue;
+                        }
+                        if (new_langid(cp, u))
+                                fprintf(stderr, "Duplicate LANGID spec at line %u language-id %04x %s\n", linectr, u, cp);
+                        DBG(printf("line %5u LANGID %02x %s\n", linectr, u, cp));
+                        lasthut = lastclass = lastvendor = lastsubclass = -1;
+                        lastlang = u;
+                        continue;
+                }
+		if (buf[0] == 'C' && /*isspace(buf[1])*/ buf[1] == ' ') {
+			/* class spec */
+			cp = buf+2;
+			while (isspace(*cp))
+				cp++;
+			if (!isxdigit(*cp)) {
+				fprintf(stderr, "Invalid class spec at line %u\n", linectr);
+				continue;
+			}
+			u = strtoul(cp, &cp, 16);
+			while (isspace(*cp))
+				cp++;
+			if (!*cp) {
+				fprintf(stderr, "Invalid class spec at line %u\n", linectr);
+				continue;
+			}
+			if (new_class(cp, u))
+				fprintf(stderr, "Duplicate class spec at line %u class %04x %s\n", linectr, u, cp);
+			DBG(printf("line %5u class %02x %s\n", linectr, u, cp));
+			lasthut = lastlang = lastvendor = lastsubclass = -1;
+			lastclass = u;
+			continue;
+		}
+		if (buf[0] == 'A' && buf[1] == 'T' && isspace(buf[2])) {
+			/* audio terminal type spec */
+			cp = buf+3;
+			while (isspace(*cp))
+				cp++;
+			if (!isxdigit(*cp)) {
+				fprintf(stderr, "Invalid audio terminal type at line %u\n", linectr);
+				continue;
+			}
+			u = strtoul(cp, &cp, 16);
+			while (isspace(*cp))
+				cp++;
+			if (!*cp) {
+				fprintf(stderr, "Invalid audio terminal type at line %u\n", linectr);
+				continue;
+			}
+			if (new_audioterminal(cp, u))
+				fprintf(stderr, "Duplicate audio terminal type spec at line %u terminal type %04x %s\n", linectr, u, cp);
+			DBG(printf("line %5u audio terminal type %02x %s\n", linectr, u, cp));
+			continue;
+		}
+		if (buf[0] == 'H' && buf[1] == 'C' && buf[2] == 'C' && isspace(buf[3])) {
+			/* HID Descriptor bCountryCode */
+                        cp =  buf+3;
+                        while (isspace(*cp))
+                                cp++;
+                        if (!isxdigit(*cp)) {
+                                fprintf(stderr, "Invalid HID country code at line %u\n", linectr);
+                                continue;
+                        }
+                        u = strtoul(cp, &cp, 10);
+                        while (isspace(*cp))
+                                cp++;
+                        if (!*cp) {
+                                fprintf(stderr, "Invalid HID country code at line %u\n", linectr);
+                                continue;
+                        }
+                        if (new_countrycode(cp, u))
+                                fprintf(stderr, "Duplicate HID country code at line %u country %02u %s\n", linectr, u, cp);
+                        DBG(printf("line %5u keyboard country code %02u %s\n", linectr, u, cp));
+                        continue;
+		}
+		if (isxdigit(*cp)) {
+			/* vendor */
+			u = strtoul(cp, &cp, 16);
+			while (isspace(*cp))
+				cp++;
+			if (!*cp) {
+				fprintf(stderr, "Invalid vendor spec at line %u\n", linectr);
+				continue;
+			}
+			if (new_vendor(cp, u))
+				fprintf(stderr, "Duplicate vendor spec at line %u vendor %04x %s\n", linectr, u, cp);
+			DBG(printf("line %5u vendor %04x %s\n", linectr, u, cp));
+			lastvendor = u;
+			lasthut = lastlang = lastclass = lastsubclass = -1;
+			continue;
+		}
+		if (buf[0] == '\t' && isxdigit(buf[1])) {
+			/* product or subclass spec */
+			u = strtoul(buf+1, &cp, 16);
+			while (isspace(*cp))
+				cp++;
+			if (!*cp) {
+				fprintf(stderr, "Invalid product/subclass spec at line %u\n", linectr);
+				continue;
+			}
+			if (lastvendor != -1) {
+				if (new_product(cp, lastvendor, u))
+					fprintf(stderr, "Duplicate product spec at line %u product %04x:%04x %s\n", linectr, lastvendor, u, cp);
+				DBG(printf("line %5u product %04x:%04x %s\n", linectr, lastvendor, u, cp));
+				continue;
+			}
+			if (lastclass != -1) {
+				if (new_subclass(cp, lastclass, u))
+					fprintf(stderr, "Duplicate subclass spec at line %u class %02x:%02x %s\n", linectr, lastclass, u, cp);
+				DBG(printf("line %5u subclass %02x:%02x %s\n", linectr, lastclass, u, cp));
+				lastsubclass = u;
+				continue;
+			}
+			if (lasthut != -1) {
+				if (new_hutus(cp, (lasthut << 16)+u))
+					fprintf(stderr, "Duplicate HUT Usage Spec at line %u\n", linectr);
+				continue;
+			}
+			if (lastlang != -1) {
+                                if (new_langid(cp, lastlang+(u<<10)))
+                                        fprintf(stderr, "Duplicate LANGID Usage Spec at line %u\n", linectr);
+                                continue;
+                        }
+			fprintf(stderr, "Product/Subclass spec without prior Vendor/Class spec at line %u\n", linectr);
+			continue;
+		}
+		if (buf[0] == '\t' && buf[1] == '\t' && isxdigit(buf[2])) {
+			/* protocol spec */
+			u = strtoul(buf+2, &cp, 16);
+			while (isspace(*cp))
+				cp++;
+			if (!*cp) {
+				fprintf(stderr, "Invalid protocol spec at line %u\n", linectr);
+				continue;
+			}
+			if (lastclass != -1 && lastsubclass != -1) {
+				if (new_protocol(cp, lastclass, lastsubclass, u))
+					fprintf(stderr, "Duplicate protocol spec at line %u class %02x:%02x:%02x %s\n", linectr, lastclass, lastsubclass, u, cp);
+				DBG(printf("line %5u protocol %02x:%02x:%02x %s\n", linectr, lastclass, lastsubclass, u, cp));
+				continue;
+			}
+			fprintf(stderr, "Protocol spec without prior Class and Subclass spec at line %u\n", linectr);
+			continue;
+		}
+		if (buf[0] == 'H' && buf[1] == 'I' && buf[2] == 'D' && /*isspace(buf[3])*/ buf[3] == ' ') {
+			cp = buf + 4;
+                        while (isspace(*cp))
+                                cp++;
+                        if (!isxdigit(*cp)) {
+                                fprintf(stderr, "Invalid HID type at line %u\n", linectr);
+                                continue;
+                        }
+                        u = strtoul(cp, &cp, 16);
+                        while (isspace(*cp))
+                                cp++;
+                        if (!*cp) {
+                                fprintf(stderr, "Invalid HID type at line %u\n", linectr);
+                                continue;
+                        }
+                        if (new_hid(cp, u))
+                                fprintf(stderr, "Duplicate HID type spec at line %u terminal type %04x %s\n", linectr, u, cp);
+                        DBG(printf("line %5u HID type %02x %s\n", linectr, u, cp));
+                        continue;
+
+		}
+                if (buf[0] == 'H' && buf[1] == 'U' && buf[2] == 'T' && /*isspace(buf[3])*/ buf[3] == ' ') {
+                        cp = buf + 4;
+                        while (isspace(*cp))
+                                cp++;
+                        if (!isxdigit(*cp)) {
+                                fprintf(stderr, "Invalid HUT type at line %u\n", linectr);
+                                continue;
+                        }
+                        u = strtoul(cp, &cp, 16);
+                        while (isspace(*cp))
+                                cp++;
+                        if (!*cp) {
+                                fprintf(stderr, "Invalid HUT type at line %u\n", linectr);
+                                continue;
+                        }
+                        if (new_huts(cp, u))
+                                fprintf(stderr, "Duplicate HUT type spec at line %u terminal type %04x %s\n", linectr, u, cp);
+			lastlang = lastclass = lastvendor = lastsubclass = -1;
+			lasthut = u;
+                        DBG(printf("line %5u HUT type %02x %s\n", linectr, u, cp));
+                        continue;
+
+                }
+                if (buf[0] == 'R' && buf[1] == ' ') {
+                        cp = buf + 2;
+                        while (isspace(*cp))
+                                cp++;
+                        if (!isxdigit(*cp)) {
+                                fprintf(stderr, "Invalid Report type at line %u\n", linectr);
+                                continue;
+                        }
+                        u = strtoul(cp, &cp, 16);
+                        while (isspace(*cp))
+                                cp++;
+                        if (!*cp) {
+                                fprintf(stderr, "Invalid Report type at line %u\n", linectr);
+                                continue;
+                        }
+                        if (new_reporttag(cp, u))
+                                fprintf(stderr, "Duplicate Report type spec at line %u terminal type %04x %s\n", linectr, u, cp);
+                        DBG(printf("line %5u Report type %02x %s\n", linectr, u, cp));
+                        continue;
+
+                }
+                if (buf[0] == 'V' && buf[1] == 'T') {
+			/* add here */
+			continue;
+		}
+		fprintf(stderr, "Unknown line at line %u\n", linectr);
+	}
+}
+
+/* ---------------------------------------------------------------------- */
+
+int names_init(char *n)
+{
+	FILE *f;
+
+	if (!(f = fopen(n, "r"))) {
+		return errno;
+	}
+	parse(f);
+	fclose(f);
+	return 0;
+}
diff --git a/drivers/staging/usbip/userspace/libsrc/names.h b/drivers/staging/usbip/userspace/libsrc/names.h
new file mode 100644
index 0000000..3a269fe
--- /dev/null
+++ b/drivers/staging/usbip/userspace/libsrc/names.h
@@ -0,0 +1,57 @@
+/*****************************************************************************/
+
+/*
+ *      names.h  --  USB name database manipulation routines
+ *
+ *      Copyright (C) 1999, 2000  Thomas Sailer (sailer@ife.ee.ethz.ch)
+ *
+ *      This program is free software; you can redistribute it and/or modify
+ *      it under the terms of the GNU General Public License as published by
+ *      the Free Software Foundation; either version 2 of the License, or
+ *      (at your option) any later version.
+ *
+ *      This program is distributed in the hope that it will be useful,
+ *      but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *      GNU General Public License for more details.
+ *
+ *      You should have received a copy of the GNU General Public License
+ *      along with this program; if not, write to the Free Software
+ *      Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ *
+ */
+
+/*
+ *	Copyright (C) 2005 Takahiro Hirofuchi
+ *	       - names_free() is added.
+ */
+
+/*****************************************************************************/
+
+#ifndef _NAMES_H
+#define _NAMES_H
+
+#include <sys/types.h>
+
+/* ---------------------------------------------------------------------- */
+
+extern const char *names_vendor(u_int16_t vendorid);
+extern const char *names_product(u_int16_t vendorid, u_int16_t productid);
+extern const char *names_class(u_int8_t classid);
+extern const char *names_subclass(u_int8_t classid, u_int8_t subclassid);
+extern const char *names_protocol(u_int8_t classid, u_int8_t subclassid, u_int8_t protocolid);
+extern const char *names_audioterminal(u_int16_t termt);
+extern const char *names_hid(u_int8_t hidd);
+extern const char *names_reporttag(u_int8_t rt);
+extern const char *names_huts(unsigned int data);
+extern const char *names_hutus(unsigned int data);
+extern const char *names_langid(u_int16_t langid);
+extern const char *names_physdes(u_int8_t ph);
+extern const char *names_bias(u_int8_t b);
+extern const char *names_countrycode(unsigned int countrycode);
+extern int  names_init(char *n);
+extern void names_free(void);
+
+/* ---------------------------------------------------------------------- */
+#endif /* _NAMES_H */
diff --git a/drivers/staging/usbip/userspace/libsrc/stub_driver.c b/drivers/staging/usbip/userspace/libsrc/stub_driver.c
new file mode 100644
index 0000000..bfe67480
--- /dev/null
+++ b/drivers/staging/usbip/userspace/libsrc/stub_driver.c
@@ -0,0 +1,390 @@
+/*
+ * Copyright (C) 2005-2007 Takahiro Hirofuchi
+ */
+
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+
+#include "usbip.h"
+
+static const char *usbip_stub_driver_name = "usbip";
+
+
+struct usbip_stub_driver *stub_driver;
+
+static struct sysfs_driver *open_sysfs_stub_driver(void)
+{
+	int ret;
+
+	char sysfs_mntpath[SYSFS_PATH_MAX];
+	char stub_driver_path[SYSFS_PATH_MAX];
+	struct sysfs_driver *stub_driver;
+
+
+	ret = sysfs_get_mnt_path(sysfs_mntpath, SYSFS_PATH_MAX);
+	if (ret < 0) {
+		err("sysfs must be mounted");
+		return NULL;
+	}
+
+	snprintf(stub_driver_path, SYSFS_PATH_MAX, "%s/%s/usb/%s/%s",
+			sysfs_mntpath, SYSFS_BUS_NAME, SYSFS_DRIVERS_NAME,
+			usbip_stub_driver_name);
+
+	stub_driver = sysfs_open_driver_path(stub_driver_path);
+	if (!stub_driver) {
+		err("usbip_common_mod.ko and usbip.ko must be loaded");
+		return NULL;
+	}
+
+	return stub_driver;
+}
+
+
+#define SYSFS_OPEN_RETRIES 100
+
+/* only the first interface value is true! */
+static int32_t read_attr_usbip_status(struct usb_device *udev)
+{
+	char attrpath[SYSFS_PATH_MAX];
+	struct sysfs_attribute *attr;
+	int value = 0;
+	int  ret;
+	struct stat s;
+	int retries = SYSFS_OPEN_RETRIES;
+
+	/* This access is racy!
+	 *
+	 * Just after detach, our driver removes the sysfs
+	 * files and recreates them.
+	 *
+	 * We may try and fail to open the usbip_status of
+	 * an exported device in the (short) window where
+	 * it has been removed and not yet recreated.
+	 *
+	 * This is a bug in the interface. Nothing we can do
+	 * except work around it here by polling for the sysfs
+	 * usbip_status to reappear.
+	 */
+
+	snprintf(attrpath, SYSFS_PATH_MAX, "%s/%s:%d.%d/usbip_status",
+			udev->path, udev->busid,
+			udev->bConfigurationValue,
+			0);
+
+	while (retries > 0) {
+		if (stat(attrpath, &s) == 0)
+			break;
+
+		if (errno != ENOENT) {
+			err("error stat'ing %s", attrpath);
+			return -1;
+		}
+
+		usleep(10000); /* 10ms */
+		retries--;
+	}
+
+	if (retries == 0)
+		err("usbip_status not ready after %d retries", 
+			SYSFS_OPEN_RETRIES);
+	else if (retries < SYSFS_OPEN_RETRIES)
+		info("warning: usbip_status ready after %d retries",
+			 SYSFS_OPEN_RETRIES - retries);
+
+	attr = sysfs_open_attribute(attrpath);
+	if (!attr) {
+		err("open %s", attrpath);
+		return -1;
+	}
+
+	ret = sysfs_read_attribute(attr);
+	if (ret) {
+		err("read %s", attrpath);
+		sysfs_close_attribute(attr);
+		return -1;
+	}
+
+	value = atoi(attr->value);
+
+	sysfs_close_attribute(attr);
+
+	return value;
+}
+
+
+static void usbip_exported_device_delete(void *dev)
+{
+	struct usbip_exported_device *edev =
+		(struct usbip_exported_device *) dev;
+
+	sysfs_close_device(edev->sudev);
+	free(dev);
+}
+
+
+static struct usbip_exported_device *usbip_exported_device_new(char *sdevpath)
+{
+	struct usbip_exported_device *edev = NULL;
+
+	edev = (struct usbip_exported_device *) calloc(1, sizeof(*edev));
+	if (!edev) {
+		err("alloc device");
+		return NULL;
+	}
+
+	edev->sudev = sysfs_open_device_path(sdevpath);
+	if (!edev->sudev) {
+		err("open %s", sdevpath);
+		goto err;
+	}
+
+	read_usb_device(edev->sudev, &edev->udev);
+
+	edev->status = read_attr_usbip_status(&edev->udev);
+	if (edev->status < 0)
+		goto err;
+
+	/* reallocate buffer to include usb interface data */
+	size_t size = sizeof(*edev) + edev->udev.bNumInterfaces * sizeof(struct usb_interface);
+	edev = (struct usbip_exported_device *) realloc(edev, size);
+	if (!edev) {
+		err("alloc device");
+		goto err;
+	}
+
+	for (int i=0; i < edev->udev.bNumInterfaces; i++)
+		read_usb_interface(&edev->udev, i, &edev->uinf[i]);
+
+	return edev;
+
+err:
+	if (edev && edev->sudev)
+		sysfs_close_device(edev->sudev);
+	if (edev)
+		free(edev);
+	return NULL;
+}
+
+
+static int check_new(struct dlist *dlist, struct sysfs_device *target)
+{
+	struct sysfs_device *dev;
+
+	dlist_for_each_data(dlist, dev, struct sysfs_device) {
+		if (!strncmp(dev->bus_id, target->bus_id, SYSFS_BUS_ID_SIZE))
+			/* found. not new */
+			return 0;
+	}
+
+	return 1;
+}
+
+static void delete_nothing(void *dev)
+{
+	/* do not delete anything. but, its container will be deleted. */
+}
+
+static int refresh_exported_devices(void)
+{
+	struct sysfs_device	*suinf;  /* sysfs_device of usb_interface */
+	struct dlist		*suinf_list;
+
+	struct sysfs_device	*sudev;  /* sysfs_device of usb_device */
+	struct dlist		*sudev_list;
+
+
+	sudev_list = dlist_new_with_delete(sizeof(struct sysfs_device), delete_nothing);
+
+	suinf_list = sysfs_get_driver_devices(stub_driver->sysfs_driver);
+	if (!suinf_list) {
+		printf("Bind usbip.ko to a usb device to be exportable!\n");
+		goto bye;
+	}
+
+	/* collect unique USB devices (not interfaces) */
+	dlist_for_each_data(suinf_list, suinf, struct sysfs_device) {
+
+		/* get usb device of this usb interface */
+		sudev = sysfs_get_device_parent(suinf);
+		if (!sudev) {
+			err("get parent dev of %s", suinf->name);
+			continue;
+		}
+
+		if (check_new(sudev_list, sudev)) {
+			dlist_unshift(sudev_list, sudev);
+		}
+	}
+
+	dlist_for_each_data(sudev_list, sudev, struct sysfs_device) {
+		struct usbip_exported_device *edev;
+
+		edev = usbip_exported_device_new(sudev->path);
+		if (!edev) {
+			err("usbip_exported_device new");
+			continue;
+		}
+
+		dlist_unshift(stub_driver->edev_list, (void *) edev);
+		stub_driver->ndevs++;
+	}
+
+
+	dlist_destroy(sudev_list);
+
+bye:
+
+	return 0;
+}
+
+int usbip_stub_refresh_device_list(void)
+{
+	int ret;
+
+	if (stub_driver->edev_list)
+		dlist_destroy(stub_driver->edev_list);
+
+	stub_driver->ndevs = 0;
+
+	stub_driver->edev_list = dlist_new_with_delete(sizeof(struct usbip_exported_device),
+			usbip_exported_device_delete);
+	if (!stub_driver->edev_list) {
+		err("alloc dlist");
+		return -1;
+	}
+
+	ret = refresh_exported_devices();
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+int usbip_stub_driver_open(void)
+{
+	int ret;
+
+
+	stub_driver = (struct usbip_stub_driver *) calloc(1, sizeof(*stub_driver));
+	if (!stub_driver) {
+		err("alloc stub_driver");
+		return -1;
+	}
+
+	stub_driver->ndevs = 0;
+
+	stub_driver->edev_list = dlist_new_with_delete(sizeof(struct usbip_exported_device),
+			usbip_exported_device_delete);
+	if (!stub_driver->edev_list) {
+		err("alloc dlist");
+		goto err;
+	}
+
+	stub_driver->sysfs_driver = open_sysfs_stub_driver();
+	if (!stub_driver->sysfs_driver)
+		goto err;
+
+	ret = refresh_exported_devices();
+	if (ret < 0)
+		goto err;
+
+	return 0;
+
+
+err:
+	if (stub_driver->sysfs_driver)
+		sysfs_close_driver(stub_driver->sysfs_driver);
+	if (stub_driver->edev_list)
+		dlist_destroy(stub_driver->edev_list);
+	free(stub_driver);
+
+	stub_driver = NULL;
+	return -1;
+}
+
+
+void usbip_stub_driver_close(void)
+{
+	if (!stub_driver)
+		return;
+
+	if (stub_driver->edev_list)
+		dlist_destroy(stub_driver->edev_list);
+	if (stub_driver->sysfs_driver)
+		sysfs_close_driver(stub_driver->sysfs_driver);
+	free(stub_driver);
+
+	stub_driver = NULL;
+}
+
+int usbip_stub_export_device(struct usbip_exported_device *edev, int sockfd)
+{
+	char attrpath[SYSFS_PATH_MAX];
+	struct sysfs_attribute *attr;
+	char sockfd_buff[30];
+	int ret;
+
+
+	if (edev->status != SDEV_ST_AVAILABLE) {
+		info("device not available, %s", edev->udev.busid);
+		switch( edev->status ) {
+			case SDEV_ST_ERROR:
+				info("     status SDEV_ST_ERROR");
+				break;
+			case SDEV_ST_USED:
+				info("     status SDEV_ST_USED");
+				break;
+			default:
+				info("     status unknown: 0x%x", edev->status);
+		}
+		return -1;
+	}
+
+	/* only the first interface is true */
+	snprintf(attrpath, sizeof(attrpath), "%s/%s:%d.%d/%s",
+			edev->udev.path,
+			edev->udev.busid,
+			edev->udev.bConfigurationValue, 0,
+			"usbip_sockfd");
+
+	attr = sysfs_open_attribute(attrpath);
+	if (!attr) {
+		err("open %s", attrpath);
+		return -1;
+	}
+
+	snprintf(sockfd_buff, sizeof(sockfd_buff), "%d\n", sockfd);
+
+	dbg("write: %s", sockfd_buff);
+
+	ret = sysfs_write_attribute(attr, sockfd_buff, strlen(sockfd_buff));
+	if (ret < 0) {
+		err("write sockfd %s to %s", sockfd_buff, attrpath);
+		goto err_write_sockfd;
+	}
+
+	info("connect %s", edev->udev.busid);
+
+err_write_sockfd:
+	sysfs_close_attribute(attr);
+
+	return ret;
+}
+
+struct usbip_exported_device *usbip_stub_get_device(int num)
+{
+	struct usbip_exported_device *edev;
+	struct dlist		*dlist = stub_driver->edev_list;
+	int count = 0;
+
+	dlist_for_each_data(dlist, edev, struct usbip_exported_device) {
+		if (num == count)
+			return edev;
+		else
+			count++ ;
+	}
+
+	return NULL;
+}
diff --git a/drivers/staging/usbip/userspace/libsrc/stub_driver.h b/drivers/staging/usbip/userspace/libsrc/stub_driver.h
new file mode 100644
index 0000000..3107d18
--- /dev/null
+++ b/drivers/staging/usbip/userspace/libsrc/stub_driver.h
@@ -0,0 +1,36 @@
+/*
+ * Copyright (C) 2005-2007 Takahiro Hirofuchi
+ */
+
+#ifndef _USBIP_STUB_DRIVER_H
+#define _USBIP_STUB_DRIVER_H
+
+#include "usbip.h"
+
+
+struct usbip_stub_driver {
+	int ndevs;
+	struct sysfs_driver *sysfs_driver;
+
+	struct dlist *edev_list;	/* list of exported device */
+};
+
+struct usbip_exported_device {
+	struct sysfs_device *sudev;
+
+	int32_t status;
+	struct usb_device    udev;
+	struct usb_interface uinf[];
+};
+
+
+extern struct usbip_stub_driver *stub_driver;
+
+int usbip_stub_driver_open(void);
+void usbip_stub_driver_close(void);
+
+int usbip_stub_refresh_device_list(void);
+int usbip_stub_export_device(struct usbip_exported_device *edev, int sockfd);
+
+struct usbip_exported_device *usbip_stub_get_device(int num);
+#endif
diff --git a/drivers/staging/usbip/userspace/libsrc/usbip.h b/drivers/staging/usbip/userspace/libsrc/usbip.h
new file mode 100644
index 0000000..7cb8e6f
--- /dev/null
+++ b/drivers/staging/usbip/userspace/libsrc/usbip.h
@@ -0,0 +1,19 @@
+/*
+ * Copyright (C) 2005-2007 Takahiro Hirofuchi
+ */
+
+#ifndef _USBIP_H
+#define _USBIP_H
+
+#ifdef HAVE_CONFIG_H
+#include "../config.h"
+#endif
+
+#include "usbip_common.h"
+#include "stub_driver.h"
+#include "vhci_driver.h"
+#ifdef DMALLOC
+#include <dmalloc.h>
+#endif
+
+#endif
diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_common.c b/drivers/staging/usbip/userspace/libsrc/usbip_common.c
new file mode 100644
index 0000000..a128a92
--- /dev/null
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_common.c
@@ -0,0 +1,282 @@
+/*
+ * Copyright (C) 2005-2007 Takahiro Hirofuchi
+ */
+
+#include "usbip.h"
+#include "names.h"
+
+int usbip_use_syslog = 0;
+int usbip_use_stderr = 0;
+int usbip_use_debug  = 0;
+
+struct speed_string {
+	int num;
+	char *speed;
+	char *desc;
+};
+
+static const struct speed_string speed_strings[] = {
+	{ USB_SPEED_UNKNOWN, "unknown", "Unknown Speed"},
+	{ USB_SPEED_LOW,  "1.5", "Low Speed(1.5Mbps)"  },
+	{ USB_SPEED_FULL, "12",  "Full Speed(12Mbps)" },
+	{ USB_SPEED_HIGH, "480", "High Speed(480Mbps)" },
+	{ 0, NULL, NULL }
+};
+
+struct portst_string {
+	int num;
+	char *desc;
+};
+
+static struct portst_string portst_strings[] = {
+	{ SDEV_ST_AVAILABLE,	"Device Available" },
+	{ SDEV_ST_USED,		"Device in Use" },
+	{ SDEV_ST_ERROR,	"Device Error"},
+	{ VDEV_ST_NULL,		"Port Available"},
+	{ VDEV_ST_NOTASSIGNED,	"Port Initializing"},
+	{ VDEV_ST_USED,		"Port in Use"},
+	{ VDEV_ST_ERROR,	"Port Error"},
+	{ 0, NULL}
+};
+
+const char *usbip_status_string(int32_t status)
+{
+	for (int i=0; portst_strings[i].desc != NULL; i++)
+		if (portst_strings[i].num == status)
+			return portst_strings[i].desc;
+
+	return "Unknown Status";
+}
+
+const char *usbip_speed_string(int num)
+{
+	for (int i=0; speed_strings[i].speed != NULL; i++)
+		if (speed_strings[i].num == num)
+			return speed_strings[i].desc;
+
+	return "Unknown Speed";
+}
+
+
+#define DBG_UDEV_INTEGER(name)\
+	dbg("%-20s = %x", to_string(name), (int) udev->name)
+
+#define DBG_UINF_INTEGER(name)\
+	dbg("%-20s = %x", to_string(name), (int) uinf->name)
+
+void dump_usb_interface(struct usb_interface *uinf)
+{
+	char buff[100];
+	usbip_names_get_class(buff, sizeof(buff),
+			uinf->bInterfaceClass,
+			uinf->bInterfaceSubClass,
+			uinf->bInterfaceProtocol);
+	dbg("%-20s = %s", "Interface(C/SC/P)", buff);
+}
+
+void dump_usb_device(struct usb_device *udev)
+{
+	char buff[100];
+
+
+	dbg("%-20s = %s", "path",  udev->path);
+	dbg("%-20s = %s", "busid", udev->busid);
+
+	usbip_names_get_class(buff, sizeof(buff),
+			udev->bDeviceClass,
+			udev->bDeviceSubClass,
+			udev->bDeviceProtocol);
+	dbg("%-20s = %s", "Device(C/SC/P)", buff);
+
+	DBG_UDEV_INTEGER(bcdDevice);
+
+	usbip_names_get_product(buff, sizeof(buff),
+			udev->idVendor,
+			udev->idProduct);
+	dbg("%-20s = %s", "Vendor/Product", buff);
+
+	DBG_UDEV_INTEGER(bNumConfigurations);
+	DBG_UDEV_INTEGER(bNumInterfaces);
+
+	dbg("%-20s = %s", "speed",
+			usbip_speed_string(udev->speed));
+
+	DBG_UDEV_INTEGER(busnum);
+	DBG_UDEV_INTEGER(devnum);
+}
+
+
+int read_attr_value(struct sysfs_device *dev, const char *name, const char *format)
+{
+	char attrpath[SYSFS_PATH_MAX];
+	struct sysfs_attribute *attr;
+	int num = 0;
+	int ret;
+
+	snprintf(attrpath, sizeof(attrpath), "%s/%s", dev->path, name);
+
+	attr = sysfs_open_attribute(attrpath);
+	if (!attr) {
+		err("open attr %s", attrpath);
+		return 0;
+	}
+
+	ret = sysfs_read_attribute(attr);
+	if (ret < 0) {
+		err("read attr");
+		goto err;
+	}
+
+	ret = sscanf(attr->value, format, &num);
+	if (ret < 1) {
+		err("sscanf");
+		goto err;
+	}
+
+err:
+	sysfs_close_attribute(attr);
+
+	return num;
+}
+
+
+int read_attr_speed(struct sysfs_device *dev)
+{
+	char attrpath[SYSFS_PATH_MAX];
+	struct sysfs_attribute *attr;
+	char speed[100];
+	int ret;
+
+	snprintf(attrpath, sizeof(attrpath), "%s/%s", dev->path, "speed");
+
+	attr = sysfs_open_attribute(attrpath);
+	if (!attr) {
+		err("open attr");
+		return 0;
+	}
+
+	ret = sysfs_read_attribute(attr);
+	if (ret < 0) {
+		err("read attr");
+		goto err;
+	}
+
+	ret = sscanf(attr->value, "%s\n", speed);
+	if (ret < 1) {
+		err("sscanf");
+		goto err;
+	}
+err:
+	sysfs_close_attribute(attr);
+
+	for (int i=0; speed_strings[i].speed != NULL; i++) {
+		if (!strcmp(speed, speed_strings[i].speed))
+			return speed_strings[i].num;
+	}
+
+	return USB_SPEED_UNKNOWN;
+}
+
+#define READ_ATTR(object, type, dev, name, format)\
+	do { (object)->name = (type) read_attr_value(dev, to_string(name), format); } while (0)
+
+
+int read_usb_device(struct sysfs_device *sdev, struct usb_device *udev)
+{
+	uint32_t busnum, devnum;
+
+	READ_ATTR(udev, uint8_t,  sdev, bDeviceClass,		"%02x\n");
+	READ_ATTR(udev, uint8_t,  sdev, bDeviceSubClass,	"%02x\n");
+	READ_ATTR(udev, uint8_t,  sdev, bDeviceProtocol,	"%02x\n");
+
+	READ_ATTR(udev, uint16_t, sdev, idVendor,		"%04x\n");
+	READ_ATTR(udev, uint16_t, sdev, idProduct,		"%04x\n");
+	READ_ATTR(udev, uint16_t, sdev, bcdDevice,		"%04x\n");
+
+	READ_ATTR(udev, uint8_t,  sdev, bConfigurationValue,	"%02x\n");
+	READ_ATTR(udev, uint8_t,  sdev, bNumConfigurations,	"%02x\n");
+	READ_ATTR(udev, uint8_t,  sdev, bNumInterfaces,		"%02x\n");
+
+	READ_ATTR(udev, uint8_t,  sdev, devnum,			"%d\n");
+	udev->speed = read_attr_speed(sdev);
+
+	strncpy(udev->path,  sdev->path,  SYSFS_PATH_MAX);
+	strncpy(udev->busid, sdev->name, SYSFS_BUS_ID_SIZE);
+
+	sscanf(sdev->name, "%u-%u", &busnum, &devnum);
+	udev->busnum = busnum;
+
+	return 0;
+}
+
+int read_usb_interface(struct usb_device *udev, int i, struct usb_interface *uinf)
+{
+	char busid[SYSFS_BUS_ID_SIZE];
+	struct sysfs_device *sif;
+
+	sprintf(busid, "%s:%d.%d", udev->busid, udev->bConfigurationValue, i);
+
+	sif = sysfs_open_device("usb", busid);
+	if (!sif) {
+		err("open sif of %s", busid);
+		return -1;
+	}
+
+	READ_ATTR(uinf, uint8_t,  sif, bInterfaceClass,		"%02x\n");
+	READ_ATTR(uinf, uint8_t,  sif, bInterfaceSubClass,	"%02x\n");
+	READ_ATTR(uinf, uint8_t,  sif, bInterfaceProtocol,	"%02x\n");
+
+	sysfs_close_device(sif);
+
+	return 0;
+}
+
+int usbip_names_init(char *f)
+{
+	return names_init(f);
+}
+
+void usbip_names_free()
+{
+	names_free();
+}
+
+void usbip_names_get_product(char *buff, size_t size, uint16_t vendor, uint16_t product)
+{
+	const char *prod, *vend;
+
+	prod = names_product(vendor, product);
+	if (!prod)
+		prod = "unknown product";
+
+
+	vend = names_vendor(vendor);
+	if (!vend)
+		vend = "unknown vendor";
+
+	snprintf(buff, size, "%s : %s (%04x:%04x)", vend, prod, vendor, product);
+}
+
+void usbip_names_get_class(char *buff, size_t size, uint8_t class, uint8_t subclass, uint8_t protocol)
+{
+	const char *c, *s, *p;
+
+	if (class == 0 && subclass == 0 && protocol == 0) {
+		snprintf(buff, size, "(Defined at Interface level) (%02x/%02x/%02x)", class, subclass, protocol);
+		return;
+	}
+
+	p = names_protocol(class, subclass, protocol);
+	if (!p)
+		p = "unknown protocol";
+
+	s = names_subclass(class, subclass);
+	if (!s)
+		s = "unknown subclass";
+
+	c = names_class(class);
+	if (!c)
+		c = "unknown class";
+
+	snprintf(buff, size, "%s / %s / %s (%02x/%02x/%02x)", c, s, p, class, subclass, protocol);
+}
diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_common.h b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
new file mode 100644
index 0000000..c254b54
--- /dev/null
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
@@ -0,0 +1,149 @@
+/*
+ * Copyright (C) 2005-2007 Takahiro Hirofuchi
+ */
+
+#ifndef _USBIP_COMMON_H
+#define _USBIP_COMMON_H
+
+#include <unistd.h>
+#include <stdint.h>
+#include <syslog.h>
+#include <errno.h>
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <strings.h>
+
+#include <sysfs/libsysfs.h>
+#include <netdb.h>
+#include <sys/socket.h>
+
+#ifndef USBIDS_FILE
+#define USBIDS_FILE "/usr/share/hwdata/usb.ids"
+#endif
+
+#ifndef VHCI_STATE_PATH
+#define VHCI_STATE_PATH "/var/run/vhci_hcd"
+#endif
+
+//#include <linux/usb_ch9.h>
+enum usb_device_speed {
+	USB_SPEED_UNKNOWN = 0,                  /* enumerating */
+	USB_SPEED_LOW, USB_SPEED_FULL,          /* usb 1.1 */
+	USB_SPEED_HIGH,                         /* usb 2.0 */
+	USB_SPEED_VARIABLE                      /* wireless (usb 2.5) */
+};
+
+/* FIXME: how to sync with drivers/usbip_common.h ? */
+enum usbip_device_status{
+	/* sdev is available. */
+	SDEV_ST_AVAILABLE = 0x01,
+	/* sdev is now used. */
+	SDEV_ST_USED,
+	/* sdev is unusable because of a fatal error. */
+	SDEV_ST_ERROR,
+
+	/* vdev does not connect a remote device. */
+	VDEV_ST_NULL,
+	/* vdev is used, but the USB address is not assigned yet */
+	VDEV_ST_NOTASSIGNED,
+	VDEV_ST_USED,
+	VDEV_ST_ERROR
+};
+
+extern int usbip_use_syslog;
+extern int usbip_use_stderr;
+extern int usbip_use_debug ;
+
+#define err(fmt, args...)	do { \
+	if (usbip_use_syslog) { \
+		syslog(LOG_ERR, "usbip err: %13s:%4d (%-12s) " fmt "\n", \
+			__FILE__, __LINE__, __FUNCTION__,  ##args); \
+	} \
+	if (usbip_use_stderr) { \
+		fprintf(stderr, "usbip err: %13s:%4d (%-12s) " fmt "\n", \
+			__FILE__, __LINE__, __FUNCTION__,  ##args); \
+	} \
+} while (0)
+
+#define notice(fmt, args...)	do { \
+	if (usbip_use_syslog) { \
+		syslog(LOG_DEBUG, "usbip: " fmt, ##args); \
+	} \
+	if (usbip_use_stderr) { \
+		fprintf(stderr, "usbip: " fmt "\n",  ##args); \
+	} \
+} while (0)
+
+#define info(fmt, args...)	do { \
+	if (usbip_use_syslog) { \
+		syslog(LOG_DEBUG, fmt, ##args); \
+	} \
+	if (usbip_use_stderr) { \
+		fprintf(stderr, fmt "\n",  ##args); \
+	} \
+} while (0)
+
+#define dbg(fmt, args...)	do { \
+	if (usbip_use_debug) { \
+		if (usbip_use_syslog) { \
+			syslog(LOG_DEBUG, "usbip dbg: %13s:%4d (%-12s) " fmt, \
+				__FILE__, __LINE__, __FUNCTION__,  ##args); \
+		} \
+		if (usbip_use_stderr) { \
+			fprintf(stderr, "usbip dbg: %13s:%4d (%-12s) " fmt "\n", \
+				__FILE__, __LINE__, __FUNCTION__,  ##args); \
+		} \
+	} \
+} while (0)
+
+
+#define BUG()	do { err("sorry, it's a bug"); abort(); } while (0)
+
+
+struct usb_interface {
+	uint8_t bInterfaceClass;
+	uint8_t bInterfaceSubClass;
+	uint8_t bInterfaceProtocol;
+	uint8_t padding;	/* alignment */
+} __attribute__((packed));
+
+
+
+struct usb_device {
+	char path[SYSFS_PATH_MAX];
+	char busid[SYSFS_BUS_ID_SIZE];
+
+	uint32_t busnum;
+	uint32_t devnum;
+	uint32_t speed;
+
+	uint16_t idVendor;
+	uint16_t idProduct;
+	uint16_t bcdDevice;
+
+	uint8_t bDeviceClass;
+	uint8_t bDeviceSubClass;
+	uint8_t bDeviceProtocol;
+	uint8_t bConfigurationValue;
+	uint8_t bNumConfigurations;
+	uint8_t bNumInterfaces;
+} __attribute__((packed));
+
+#define to_string(s)	#s
+
+void dump_usb_interface(struct usb_interface *);
+void dump_usb_device(struct usb_device *);
+int read_usb_device(struct sysfs_device *sdev, struct usb_device *udev);
+int read_attr_value(struct sysfs_device *dev, const char *name, const char *format);
+int read_usb_interface(struct usb_device *udev, int i, struct usb_interface *uinf);
+
+const char *usbip_speed_string(int num);
+const char *usbip_status_string(int32_t status);
+
+int usbip_names_init(char *);
+void usbip_names_free(void);
+void usbip_names_get_product(char *buff, size_t size, uint16_t vendor, uint16_t product);
+void usbip_names_get_class(char *buff, size_t size, uint8_t class, uint8_t subclass, uint8_t protocol);
+
+#endif
diff --git a/drivers/staging/usbip/userspace/libsrc/vhci_driver.c b/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
new file mode 100644
index 0000000..5e54810
--- /dev/null
+++ b/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
@@ -0,0 +1,506 @@
+/*
+ * Copyright (C) 2005-2007 Takahiro Hirofuchi
+ */
+
+
+#include "usbip.h"
+
+
+static const char vhci_driver_name[] = "vhci_hcd";
+
+struct usbip_vhci_driver *vhci_driver;
+
+static struct usbip_imported_device *imported_device_init(struct usbip_imported_device *idev, char *busid)
+{
+	struct sysfs_device *sudev;
+
+	sudev = sysfs_open_device("usb", busid);
+	if (!sudev) {
+		err("sysfs_open_device %s", busid);
+		goto err;
+	}
+	read_usb_device(sudev, &idev->udev);
+	sysfs_close_device(sudev);
+
+	/* add class devices of this imported device */
+	struct class_device *cdev;
+	dlist_for_each_data(vhci_driver->cdev_list, cdev, struct class_device) {
+		if (!strncmp(cdev->devpath, idev->udev.path, strlen(idev->udev.path))) {
+			struct class_device *new_cdev;
+
+			/* alloc and copy because dlist is linked from only one list */
+			new_cdev = calloc(1, sizeof(*new_cdev));
+			if (!new_cdev)
+				goto err;
+
+			memcpy(new_cdev, cdev, sizeof(*new_cdev));
+			dlist_unshift(idev->cdev_list, (void*) new_cdev);
+		}
+	}
+
+	return idev;
+
+err:
+	return NULL;
+}
+
+
+
+static int parse_status(char *value)
+{
+	int ret = 0;
+	char *c;
+
+
+	for (int i = 0; i < vhci_driver->nports; i++)
+		bzero(&vhci_driver->idev[i], sizeof(struct usbip_imported_device));
+
+
+	/* skip a header line */
+	c = strchr(value, '\n') + 1;
+
+	while (*c != '\0') {
+		int port, status, speed, devid;
+		unsigned long socket;
+		char lbusid[SYSFS_BUS_ID_SIZE];
+
+		ret = sscanf(c, "%d %d %d %x %lx %s\n",
+				&port, &status, &speed,
+				&devid, &socket, lbusid);
+
+		if (ret < 5) {
+			err("scanf %d", ret);
+			BUG();
+		}
+
+		dbg("port %d status %d speed %d devid %x",
+				port, status, speed, devid);
+		dbg("socket %lx lbusid %s", socket, lbusid);
+
+
+		/* if a device is connected, look at it */
+		{
+			struct usbip_imported_device *idev = &vhci_driver->idev[port];
+
+			idev->port	= port;
+			idev->status	= status;
+
+			idev->devid	= devid;
+
+			idev->busnum	= (devid >> 16);
+			idev->devnum	= (devid & 0x0000ffff);
+
+			idev->cdev_list = dlist_new(sizeof(struct class_device));
+			if (!idev->cdev_list) {
+				err("init new device");
+				return -1;
+			}
+
+			if (idev->status != VDEV_ST_NULL && idev->status != VDEV_ST_NOTASSIGNED) {
+				idev = imported_device_init(idev, lbusid);
+				if (!idev) {
+					err("init new device");
+					return -1;
+				}
+			}
+		}
+
+
+		/* go to the next line */
+		c = strchr(c, '\n') + 1;
+	}
+
+	dbg("exit");
+
+	return 0;
+}
+
+
+static int check_usbip_device(struct sysfs_class_device *cdev)
+{
+	char clspath[SYSFS_PATH_MAX];	/* /sys/class/video4linux/video0/device     */
+	char devpath[SYSFS_PATH_MAX];	/* /sys/devices/platform/vhci_hcd/usb6/6-1:1.1  */
+
+	int ret;
+
+	snprintf(clspath, sizeof(clspath), "%s/device", cdev->path);
+
+	ret = sysfs_get_link(clspath, devpath, SYSFS_PATH_MAX);
+	if (!ret) {
+		if (!strncmp(devpath, vhci_driver->hc_device->path,
+					strlen(vhci_driver->hc_device->path))) {
+			/* found usbip device */
+			struct class_device *cdev;
+
+			cdev = calloc(1, sizeof(*cdev));
+			if (!cdev) {
+				err("calloc cdev");
+				return -1;
+			}
+			dlist_unshift(vhci_driver->cdev_list, (void*) cdev);
+			strncpy(cdev->clspath, clspath, sizeof(cdev->clspath));
+			strncpy(cdev->devpath, devpath, sizeof(cdev->clspath));
+			dbg("  found %s %s", clspath, devpath);
+		}
+	}
+
+	return 0;
+}
+
+
+static int search_class_for_usbip_device(char *cname)
+{
+	struct sysfs_class *class;
+	struct dlist *cdev_list;
+	struct sysfs_class_device *cdev;
+	int ret = 0;
+
+	class = sysfs_open_class(cname);
+	if (!class) {
+		err("open class");
+		return -1;
+	}
+
+	dbg("class %s", class->name);
+
+	cdev_list = sysfs_get_class_devices(class);
+	if (!cdev_list)
+		/* nothing */
+		goto out;
+
+	dlist_for_each_data(cdev_list, cdev, struct sysfs_class_device) {
+		dbg("   cdev %s", cdev->name);
+		ret = check_usbip_device(cdev);
+		if (ret < 0)
+			goto out;
+	}
+
+out:
+	sysfs_close_class(class);
+
+	return ret;
+}
+
+
+static int refresh_class_device_list(void)
+{
+	int ret;
+	struct dlist *cname_list;
+	char *cname;
+
+	/* search under /sys/class */
+	cname_list = sysfs_open_directory_list("/sys/class");
+	if (!cname_list) {
+		err("open class directory");
+		return -1;
+	}
+
+	dlist_for_each_data(cname_list, cname, char) {
+		ret = search_class_for_usbip_device(cname);
+		if (ret < 0) {
+			sysfs_close_list(cname_list);
+			return -1;
+		}
+	}
+
+	sysfs_close_list(cname_list);
+
+	/* seach under /sys/block */
+	ret = search_class_for_usbip_device(SYSFS_BLOCK_NAME);
+	if (ret < 0)
+		return -1;
+
+	return 0;
+}
+
+
+static int refresh_imported_device_list(void)
+{
+	struct sysfs_attribute *attr_status;
+
+
+	attr_status = sysfs_get_device_attr(vhci_driver->hc_device, "status");
+	if (!attr_status) {
+		err("get attr %s of %s", "status", vhci_driver->hc_device->name);
+		return -1;
+	}
+
+	dbg("name %s, path %s, len %d, method %d\n", attr_status->name,
+			attr_status->path, attr_status->len, attr_status->method);
+
+	dbg("%s", attr_status->value);
+
+	return parse_status(attr_status->value);
+}
+
+static int get_nports(void)
+{
+	int nports = 0;
+	struct sysfs_attribute *attr_status;
+
+	attr_status = sysfs_get_device_attr(vhci_driver->hc_device, "status");
+	if (!attr_status) {
+		err("get attr %s of %s", "status", vhci_driver->hc_device->name);
+		return -1;
+	}
+
+	dbg("name %s, path %s, len %d, method %d\n", attr_status->name,
+			attr_status->path, attr_status->len, attr_status->method);
+
+	dbg("%s", attr_status->value);
+
+	{
+		char *c;
+
+		/* skip a header line */
+		c = strchr(attr_status->value, '\n') + 1;
+
+		while (*c != '\0') {
+			/* go to the next line */
+			c = strchr(c, '\n') + 1;
+			nports += 1;
+		}
+	}
+
+	return nports;
+}
+
+static int get_hc_busid(char *sysfs_mntpath, char *hc_busid)
+{
+        struct sysfs_driver *sdriver;
+        char sdriver_path[SYSFS_PATH_MAX];
+
+	struct sysfs_device *hc_dev;
+	struct dlist *hc_devs;
+
+	int found = 0;
+
+        snprintf(sdriver_path, SYSFS_PATH_MAX, "%s/%s/platform/%s/%s",
+                                sysfs_mntpath, SYSFS_BUS_NAME, SYSFS_DRIVERS_NAME,
+                                vhci_driver_name);
+
+        sdriver = sysfs_open_driver_path(sdriver_path);
+        if (!sdriver) {
+		info("%s is not found", sdriver_path);
+                info("load usbip_common_mod.ko and vhci-hcd.ko !");
+                return -1;
+        }
+
+	hc_devs = sysfs_get_driver_devices(sdriver);
+	if (!hc_devs) {
+		err("get hc list");
+		goto err;
+	}
+
+	/* assume only one vhci_hcd */
+	dlist_for_each_data(hc_devs, hc_dev, struct sysfs_device) {
+		strncpy(hc_busid, hc_dev->bus_id, SYSFS_BUS_ID_SIZE);
+		found = 1;
+	}
+
+err:
+	sysfs_close_driver(sdriver);
+
+	if (found)
+		return 0;
+
+	err("not found usbip hc");
+	return -1;
+}
+
+
+/* ---------------------------------------------------------------------- */
+
+int usbip_vhci_driver_open(void)
+{
+	int ret;
+	char hc_busid[SYSFS_BUS_ID_SIZE];
+
+	vhci_driver = (struct usbip_vhci_driver *) calloc(1, sizeof(*vhci_driver));
+	if (!vhci_driver) {
+		err("alloc vhci_driver");
+		return -1;
+	}
+
+	ret = sysfs_get_mnt_path(vhci_driver->sysfs_mntpath, SYSFS_PATH_MAX);
+	if (ret < 0) {
+		err("sysfs must be mounted");
+		goto err;
+	}
+
+	ret = get_hc_busid(vhci_driver->sysfs_mntpath, hc_busid);
+	if (ret < 0)
+		goto err;
+
+	/* will be freed in usbip_driver_close() */
+	vhci_driver->hc_device = sysfs_open_device("platform", hc_busid);
+	if (!vhci_driver->hc_device) {
+		err("get sysfs vhci_driver");
+		goto err;
+	}
+
+	vhci_driver->nports = get_nports();
+
+	info("%d ports available\n", vhci_driver->nports);
+
+	vhci_driver->cdev_list = dlist_new(sizeof(struct class_device));
+	if (!vhci_driver->cdev_list)
+		goto err;
+
+	if (refresh_class_device_list())
+		goto err;
+
+	if (refresh_imported_device_list())
+		goto err;
+
+
+	return 0;
+
+
+err:
+	if (vhci_driver->cdev_list)
+		dlist_destroy(vhci_driver->cdev_list);
+	if (vhci_driver->hc_device)
+		sysfs_close_device(vhci_driver->hc_device);
+	if (vhci_driver)
+		free(vhci_driver);
+
+	vhci_driver = NULL;
+	return -1;
+}
+
+
+void usbip_vhci_driver_close()
+{
+	if (!vhci_driver)
+		return;
+
+	if (vhci_driver->cdev_list)
+		dlist_destroy(vhci_driver->cdev_list);
+
+	for (int i = 0; i < vhci_driver->nports; i++) {
+		if (vhci_driver->idev[i].cdev_list)
+			dlist_destroy(vhci_driver->idev[i].cdev_list);
+	}
+
+	if (vhci_driver->hc_device)
+		sysfs_close_device(vhci_driver->hc_device);
+	free(vhci_driver);
+
+	vhci_driver = NULL;
+}
+
+
+int usbip_vhci_refresh_device_list(void)
+{
+	if (vhci_driver->cdev_list)
+		dlist_destroy(vhci_driver->cdev_list);
+
+
+	for (int i = 0; i < vhci_driver->nports; i++) {
+		if (vhci_driver->idev[i].cdev_list)
+			dlist_destroy(vhci_driver->idev[i].cdev_list);
+	}
+
+	vhci_driver->cdev_list = dlist_new(sizeof(struct class_device));
+	if (!vhci_driver->cdev_list)
+		goto err;
+
+	if (refresh_class_device_list())
+		goto err;
+
+	if (refresh_imported_device_list())
+		goto err;
+
+	return 0;
+err:
+	if (vhci_driver->cdev_list)
+		dlist_destroy(vhci_driver->cdev_list);
+
+	for (int i = 0; i < vhci_driver->nports; i++) {
+		if (vhci_driver->idev[i].cdev_list)
+			dlist_destroy(vhci_driver->idev[i].cdev_list);
+	}
+
+	err("refresh device list");
+	return -1;
+}
+
+
+int usbip_vhci_get_free_port(void)
+{
+	for (int i = 0; i < vhci_driver->nports; i++) {
+		if (vhci_driver->idev[i].status == VDEV_ST_NULL)
+			return i;
+	}
+
+	return -1;
+}
+
+int usbip_vhci_attach_device2(uint8_t port, int sockfd, uint32_t devid,
+		uint32_t speed) {
+	struct sysfs_attribute *attr_attach;
+	char buff[200]; /* what size should be ? */
+	int ret;
+
+	attr_attach = sysfs_get_device_attr(vhci_driver->hc_device, "attach");
+	if (!attr_attach) {
+		err("get attach");
+		return -1;
+	}
+
+	snprintf(buff, sizeof(buff), "%u %u %u %u",
+			port, sockfd, devid, speed);
+	dbg("writing: %s", buff);
+
+	ret = sysfs_write_attribute(attr_attach, buff, strlen(buff));
+	if (ret < 0) {
+		err("write to attach failed");
+		return -1;
+	}
+
+	info("port %d attached", port);
+
+	return 0;
+}
+
+static unsigned long get_devid(uint8_t busnum, uint8_t devnum)
+{
+	return (busnum << 16) | devnum;
+}
+
+/* will be removed */
+int usbip_vhci_attach_device(uint8_t port, int sockfd, uint8_t busnum,
+		uint8_t devnum, uint32_t speed)
+{
+	int devid = get_devid(busnum, devnum);
+
+	return usbip_vhci_attach_device2(port, sockfd, devid, speed);
+}
+
+int usbip_vhci_detach_device(uint8_t port)
+{
+	struct sysfs_attribute  *attr_detach;
+	char buff[200]; /* what size should be ? */
+	int ret;
+
+	attr_detach = sysfs_get_device_attr(vhci_driver->hc_device, "detach");
+	if (!attr_detach) {
+		err("get detach");
+		return -1;
+	}
+
+	snprintf(buff, sizeof(buff), "%u", port);
+	dbg("writing to detach");
+	dbg("writing: %s", buff);
+
+	ret = sysfs_write_attribute(attr_detach, buff, strlen(buff));
+	if (ret < 0) {
+		err("write to detach failed");
+		return -1;
+	}
+
+	info("port %d detached", port);
+
+	return 0;
+}
diff --git a/drivers/staging/usbip/userspace/libsrc/vhci_driver.h b/drivers/staging/usbip/userspace/libsrc/vhci_driver.h
new file mode 100644
index 0000000..cad8ad7
--- /dev/null
+++ b/drivers/staging/usbip/userspace/libsrc/vhci_driver.h
@@ -0,0 +1,61 @@
+/*
+ * Copyright (C) 2005-2007 Takahiro Hirofuchi
+ */
+
+#ifndef _VHCI_DRIVER_H
+#define _VHCI_DRIVER_H
+
+#include "usbip.h"
+
+
+
+#define MAXNPORT 128
+
+struct class_device {
+	char clspath[SYSFS_PATH_MAX];
+	char devpath[SYSFS_PATH_MAX];
+};
+
+struct usbip_imported_device {
+	uint8_t port;
+	uint32_t status;
+
+	uint32_t devid;
+
+	uint8_t busnum;
+	uint8_t devnum;
+
+
+	struct dlist *cdev_list;	/* list of class device */
+	struct usb_device udev;
+};
+
+struct usbip_vhci_driver {
+	char sysfs_mntpath[SYSFS_PATH_MAX];
+	struct sysfs_device *hc_device; /* /sys/devices/platform/vhci_hcd */
+
+	struct dlist *cdev_list;	/* list of class device */
+
+	int nports;
+	struct usbip_imported_device idev[MAXNPORT];
+};
+
+
+extern struct usbip_vhci_driver *vhci_driver;
+
+int usbip_vhci_driver_open(void);
+void usbip_vhci_driver_close(void);
+
+int  usbip_vhci_refresh_device_list(void);
+
+
+int usbip_vhci_get_free_port(void);
+int usbip_vhci_attach_device2(uint8_t port, int sockfd, uint32_t devid,
+		uint32_t speed);
+
+/* will be removed */
+int usbip_vhci_attach_device(uint8_t port, int sockfd, uint8_t busnum,
+		uint8_t devnum, uint32_t speed);
+
+int usbip_vhci_detach_device(uint8_t port);
+#endif
diff --git a/drivers/staging/usbip/userspace/src/Makefile.am b/drivers/staging/usbip/userspace/src/Makefile.am
new file mode 100644
index 0000000..3717fc5
--- /dev/null
+++ b/drivers/staging/usbip/userspace/src/Makefile.am
@@ -0,0 +1,19 @@
+# $Id$
+
+sbin_PROGRAMS = usbip usbipd usbip_bind_driver
+
+usbip_SOURCES = usbip.c usbip_network.c usbip_network.h
+usbipd_SOURCES = usbipd.c usbip_network.c usbip_network.h
+usbip_bind_driver_SOURCES = bind-driver.c \
+		utils.c utils.h \
+		usbip_network.h usbip_network.c
+
+#usbip_bind_driver_CFLAGS = -Wall -W -Wstrict-prototypes @PACKAGE_CFLAGS@
+#usbip_bind_driver_LDADD = @PACKAGE_LIBS@
+
+#AM_CPPFLAGS = -I../include -Wall -std=gnu99
+INCLUDES = -I$(top_srcdir)/libsrc
+LDADD = ../libsrc/libusbip.la @PACKAGE_LIBS@
+EXTRA_CFLAGS = @EXTRA_CFLAGS@
+AM_CFLAGS = -Wall -W -Wstrict-prototypes -std=gnu99 $(EXTRA_CFLAGS) @PACKAGE_CFLAGS@ -DUSBIDS_FILE='"@USBIDS_DIR@/usb.ids"'
+
diff --git a/drivers/staging/usbip/userspace/src/bind-driver.c b/drivers/staging/usbip/userspace/src/bind-driver.c
new file mode 100644
index 0000000..5226751
--- /dev/null
+++ b/drivers/staging/usbip/userspace/src/bind-driver.c
@@ -0,0 +1,644 @@
+/*
+ * $Id$
+ *
+ * Copyright (C) 2005-2007 Takahiro Hirofuchi
+ */
+
+#include "utils.h"
+
+#define _GNU_SOURCE
+#include <getopt.h>
+#include <glib.h>
+
+
+
+static const struct option longopts[] = {
+	{"usbip",	required_argument,	NULL, 'u'},
+	{"other",	required_argument,	NULL, 'o'},
+	{"list",	no_argument,		NULL, 'l'},
+	{"list2",	no_argument,		NULL, 'L'},
+	{"help",	no_argument,		NULL, 'h'},
+#if 0
+	{"allusbip",	no_argument,		NULL, 'a'},
+	{"export-to",   required_argument,	NULL, 'e'},
+	{"unexport",    required_argument,	NULL, 'x'},
+	{"busid",	required_argument,	NULL, 'b'},
+#endif
+
+	{NULL,		0,			NULL,  0}
+};
+
+static const char match_busid_path[] = "/sys/bus/usb/drivers/usbip/match_busid";
+
+
+static void show_help(void)
+{
+	printf("Usage: usbip_bind_driver [OPTION]\n");
+	printf("Change driver binding for USB/IP.\n");
+	printf("  --usbip busid        make a device exportable\n");
+	printf("  --other busid        use a device by a local driver\n");
+	printf("  --list               print usb devices and their drivers\n");
+	printf("  --list2              print usb devices and their drivers in parseable mode\n");
+#if 0
+	printf("  --allusbip           make all devices exportable\n");
+	printf("  --export-to host     export the device to 'host'\n");
+	printf("  --unexport host      unexport a device previously exported to 'host'\n");
+	printf("  --busid busid        the busid used for --export-to\n");
+#endif
+}
+
+static int modify_match_busid(char *busid, int add)
+{
+	int fd;
+	int ret;
+	char buff[BUS_ID_SIZE + 4];
+
+	/* BUS_IS_SIZE includes NULL termination? */
+	if (strnlen(busid, BUS_ID_SIZE) > BUS_ID_SIZE - 1) {
+		g_warning("too long busid");
+		return -1;
+	}
+
+	fd = open(match_busid_path, O_WRONLY);
+	if (fd < 0)
+		return -1;
+
+	if (add)
+		snprintf(buff, BUS_ID_SIZE + 4, "add %s", busid);
+	else
+		snprintf(buff, BUS_ID_SIZE + 4, "del %s", busid);
+
+	g_debug("write \"%s\" to %s", buff, match_busid_path);
+
+	ret = write(fd, buff, sizeof(buff));
+	if (ret < 0) {
+		close(fd);
+		return -1;
+	}
+
+	close(fd);
+
+	return 0;
+}
+
+static const char unbind_path_format[] = "/sys/bus/usb/devices/%s/driver/unbind";
+
+/* buggy driver may cause dead lock */
+static int unbind_interface_busid(char *busid)
+{
+	char unbind_path[PATH_MAX];
+	int fd;
+	int ret;
+
+	snprintf(unbind_path, sizeof(unbind_path), unbind_path_format, busid);
+
+	fd = open(unbind_path, O_WRONLY);
+	if (fd < 0) {
+		g_warning("opening unbind_path failed: %d", fd);
+		return -1;
+	}
+
+	ret = write(fd, busid, strnlen(busid, BUS_ID_SIZE));
+	if (ret < 0) {
+		g_warning("write to unbind_path failed: %d", ret);
+		close(fd);
+		return -1;
+	}
+
+	close(fd);
+
+	return 0;
+}
+
+static int unbind_interface(char *busid, int configvalue, int interface)
+{
+	char inf_busid[BUS_ID_SIZE];
+	g_debug("unbinding interface");
+
+	snprintf(inf_busid, BUS_ID_SIZE, "%s:%d.%d", busid, configvalue, interface);
+
+	return unbind_interface_busid(inf_busid);
+}
+
+
+static const char bind_path_format[] = "/sys/bus/usb/drivers/%s/bind";
+
+static int bind_interface_busid(char *busid, char *driver)
+{
+	char bind_path[PATH_MAX];
+	int fd;
+	int ret;
+
+	snprintf(bind_path, sizeof(bind_path), bind_path_format, driver);
+
+	fd = open(bind_path, O_WRONLY);
+	if (fd < 0)
+		return -1;
+
+	ret = write(fd, busid, strnlen(busid, BUS_ID_SIZE));
+	if (ret < 0) {
+		close(fd);
+		return -1;
+	}
+
+	close(fd);
+
+	return 0;
+}
+
+static int bind_interface(char *busid, int configvalue, int interface, char *driver)
+{
+	char inf_busid[BUS_ID_SIZE];
+
+	snprintf(inf_busid, BUS_ID_SIZE, "%s:%d.%d", busid, configvalue, interface);
+
+	return bind_interface_busid(inf_busid, driver);
+}
+
+static int unbind(char *busid)
+{
+	int configvalue = 0;
+	int ninterface = 0;
+	int devclass = 0;
+	int i;
+	int failed = 0;
+
+	configvalue = read_bConfigurationValue(busid);
+	ninterface  = read_bNumInterfaces(busid);
+	devclass  = read_bDeviceClass(busid);
+
+	if (configvalue < 0 || ninterface < 0 || devclass < 0) {
+		g_warning("read config and ninf value, removed?");
+		return -1;
+	}
+
+	if (devclass == 0x09) {
+		g_message("skip unbinding of hub");
+		return -1;
+	}
+
+ 	for (i = 0; i < ninterface; i++) {
+ 		char driver[PATH_MAX];
+		int ret;
+
+		bzero(&driver, sizeof(driver));
+
+ 		getdriver(busid, configvalue, i, driver, PATH_MAX-1);
+
+		g_debug(" %s:%d.%d	-> %s ", busid, configvalue, i, driver);
+
+		if (!strncmp("none", driver, PATH_MAX))
+			continue; /* unbound interface */
+
+#if 0
+		if (!strncmp("usbip", driver, PATH_MAX))
+			continue; /* already bound to usbip */
+#endif
+
+		/* unbinding */
+		ret = unbind_interface(busid, configvalue, i);
+		if (ret < 0) {
+			g_warning("unbind driver at %s:%d.%d failed",
+					busid, configvalue, i);
+			failed = 1;
+		}
+	}
+
+	if (failed)
+		return -1;
+	else
+		return 0;
+}
+
+/* call at unbound state */
+static int bind_to_usbip(char *busid)
+{
+	int configvalue = 0;
+	int ninterface = 0;
+	int i;
+	int failed = 0;
+
+	configvalue = read_bConfigurationValue(busid);
+	ninterface  = read_bNumInterfaces(busid);
+
+	if (configvalue < 0 || ninterface < 0) {
+		g_warning("read config and ninf value, removed?");
+		return -1;
+	}
+
+ 	for (i = 0; i < ninterface; i++) {
+		int ret;
+
+		ret = bind_interface(busid, configvalue, i, "usbip");
+		if (ret < 0) {
+			g_warning("bind usbip at %s:%d.%d, failed",
+					busid, configvalue, i);
+			failed = 1;
+			/* need to contine binding at other interfaces */
+		}
+	}
+
+	if (failed)
+		return -1;
+	else
+		return 0;
+}
+
+
+static int use_device_by_usbip(char *busid)
+{
+	int ret;
+
+	ret = unbind(busid);
+	if (ret < 0) {
+		g_warning("unbind drivers of %s, failed", busid);
+		return -1;
+	}
+
+	ret = modify_match_busid(busid, 1);
+	if (ret < 0) {
+		g_warning("add %s to match_busid, failed", busid);
+		return -1;
+	}
+
+	ret = bind_to_usbip(busid);
+	if (ret < 0) {
+		g_warning("bind usbip to %s, failed", busid);
+		modify_match_busid(busid, 0);
+		return -1;
+	}
+
+	g_message("bind %s to usbip, complete!", busid);
+
+	return 0;
+}
+
+
+
+static int use_device_by_other(char *busid)
+{
+	int ret;
+	int config;
+
+	/* read and write the same config value to kick probing */
+	config = read_bConfigurationValue(busid);
+	if (config < 0) {
+		g_warning("read bConfigurationValue of %s, failed", busid);
+		return -1;
+	}
+
+	ret = modify_match_busid(busid, 0);
+	if (ret < 0) {
+		g_warning("del %s to match_busid, failed", busid);
+		return -1;
+	}
+
+	ret = write_bConfigurationValue(busid, config);
+	if (ret < 0) {
+		g_warning("read bConfigurationValue of %s, failed", busid);
+		return -1;
+	}
+
+	g_message("bind %s to other drivers than usbip, complete!", busid);
+
+	return 0;
+}
+
+
+#include <sys/types.h>
+#include <regex.h>
+
+#include <errno.h>
+#include <string.h>
+#include <stdio.h>
+
+
+
+static int is_usb_device(char *busid)
+{
+	int ret;
+
+	regex_t regex;
+	regmatch_t pmatch[1];
+
+	ret = regcomp(&regex, "^[0-9]+-[0-9]+(\\.[0-9]+)*$", REG_NOSUB|REG_EXTENDED);
+	if (ret < 0)
+		g_error("regcomp: %s\n", strerror(errno));
+
+	ret = regexec(&regex, busid, 0, pmatch, 0);
+	if (ret)
+		return 0;	/* not matched */
+
+	return 1;
+}
+
+
+#include <dirent.h>
+static int show_devices(void)
+{
+	DIR *dir;
+
+	dir = opendir("/sys/bus/usb/devices/");
+	if (!dir)
+		g_error("opendir: %s", strerror(errno));
+
+	printf("List USB devices\n");
+	for (;;) {
+		struct dirent *dirent;
+		char *busid;
+
+		dirent = readdir(dir);
+		if (!dirent)
+			break;
+
+		busid = dirent->d_name;
+
+		if (is_usb_device(busid)) {
+			char name[100] = {'\0'};
+			char driver[100] =  {'\0'};
+			int conf, ninf = 0;
+			int i;
+
+			conf = read_bConfigurationValue(busid);
+			ninf = read_bNumInterfaces(busid);
+
+			getdevicename(busid, name, sizeof(name));
+
+			printf(" - busid %s (%s)\n", busid, name);
+
+			for (i = 0; i < ninf; i++) {
+				getdriver(busid, conf, i, driver, sizeof(driver));
+				printf("         %s:%d.%d -> %s\n", busid, conf, i, driver);
+			}
+			printf("\n");
+		}
+	}
+
+	closedir(dir);
+
+	return 0;
+}
+
+static int show_devices2(void)
+{
+	DIR *dir;
+
+	dir = opendir("/sys/bus/usb/devices/");
+	if (!dir)
+		g_error("opendir: %s", strerror(errno));
+
+	for (;;) {
+		struct dirent *dirent;
+		char *busid;
+
+		dirent = readdir(dir);
+		if (!dirent)
+			break;
+
+		busid = dirent->d_name;
+
+		if (is_usb_device(busid)) {
+			char name[100] = {'\0'};
+			char driver[100] =  {'\0'};
+			int conf, ninf = 0;
+			int i;
+
+			conf = read_bConfigurationValue(busid);
+			ninf = read_bNumInterfaces(busid);
+
+			getdevicename(busid, name, sizeof(name));
+
+			printf("busid=%s#usbid=%s#", busid, name);
+
+			for (i = 0; i < ninf; i++) {
+				getdriver(busid, conf, i, driver, sizeof(driver));
+				printf("%s:%d.%d=%s#", busid, conf, i, driver);
+			}
+			printf("\n");
+		}
+	}
+
+	closedir(dir);
+
+	return 0;
+}
+
+
+#if 0
+static int export_to(char *host, char *busid) {
+
+	int ret;
+
+	if( host == NULL ) {
+		printf( "no host given\n\n");
+		show_help();
+		return -1;
+	}
+	if( busid == NULL ) {
+		/* XXX print device list and ask for busnumber, if none is
+		 * given */
+		printf( "no busid given, use --busid switch\n\n");
+		show_help();
+		return -1;
+	}
+
+
+	ret = use_device_by_usbip(busid);
+	if( ret != 0 ) {
+		printf( "could not bind driver to usbip\n");
+		return -1;
+	}
+
+	printf( "DEBUG: exporting device '%s' to '%s'\n", busid, host );
+	ret = export_busid_to_host(host, busid); /* usbip_export.[ch] */
+	if( ret != 0 ) {
+		printf( "could not export device to host\n" );
+		printf( "   host: %s, device: %s\n", host, busid );
+		use_device_by_other(busid);
+		return -1;
+	}
+
+	return 0;
+}
+
+static int unexport_from(char *host, char *busid) {
+
+	int ret;
+
+	if (!host || !busid)
+		g_error("no host or no busid\n");
+
+	g_message("unexport_from: host: '%s', busid: '%s'", host, busid);
+
+	ret = unexport_busid_from_host(host, busid); /* usbip_export.[ch] */
+	if( ret != 0 ) {
+		err( "could not unexport device from host\n" );
+		err( "   host: %s, device: %s\n", host, busid );
+	}
+
+	ret = use_device_by_other(busid);
+	if (ret < 0)
+		g_error("could not unbind device from usbip\n");
+
+	return 0;
+}
+
+
+static int allusbip(void)
+{
+	DIR *dir;
+
+	dir = opendir("/sys/bus/usb/devices/");
+	if (!dir)
+		g_error("opendir: %s", strerror(errno));
+
+	for (;;) {
+		struct dirent *dirent;
+		char *busid;
+
+		dirent = readdir(dir);
+		if (!dirent)
+			break;
+
+		busid = dirent->d_name;
+
+		if (!is_usb_device(busid))
+			continue;
+
+		{
+			char name[PATH_MAX];
+			int conf, ninf = 0;
+			int i;
+			int be_local = 0;
+
+			conf = read_bConfigurationValue(busid);
+			ninf = read_bNumInterfaces(busid);
+
+			getdevicename(busid, name, sizeof(name));
+
+			for (i = 0; i < ninf; i++) {
+				char driver[PATH_MAX];
+
+				getdriver(busid, conf, i, driver, sizeof(driver));
+#if 0
+				if (strncmp(driver, "usbhid", 6) == 0 || strncmp(driver, "usb-storage", 11) == 0) {
+					be_local = 1;
+					break;
+				}
+#endif
+			}
+			
+			if (be_local == 0)
+				use_device_by_usbip(busid);
+		}
+	}
+
+	closedir(dir);
+
+	return 0;
+}
+#endif
+
+int main(int argc, char **argv)
+{
+	char *busid = NULL;
+	char *remote_host = NULL;
+
+	enum {
+		cmd_unknown = 0,
+		cmd_use_by_usbip,
+		cmd_use_by_other,
+		cmd_list,
+		cmd_list2,
+		cmd_allusbip,
+		cmd_export_to,
+		cmd_unexport,
+		cmd_help,
+	} cmd = cmd_unknown;
+
+	if (geteuid() != 0)
+		g_warning("running non-root?");
+
+	for (;;) {
+		int c;
+		int index = 0;
+
+		c = getopt_long(argc, argv, "u:o:hlLae:x:b:", longopts, &index);
+		if (c == -1)
+			break;
+
+		switch (c) {
+			case 'u':
+				cmd = cmd_use_by_usbip;
+				busid = optarg;
+				break;
+			case 'o' :
+				cmd = cmd_use_by_other;
+				busid = optarg;
+				break;
+			case 'l' :
+				cmd = cmd_list;
+				break;
+			case 'L' :
+				cmd = cmd_list2;
+				break;
+			case 'a' :
+				cmd = cmd_allusbip;
+				break;
+			case 'b':
+				busid = optarg;
+				break;
+			case 'e':
+				cmd = cmd_export_to;
+				remote_host = optarg;
+				break;
+			case 'x':
+				cmd = cmd_unexport;
+				remote_host = optarg;
+				break;
+			case 'h': /* fallthrough */
+			case '?':
+				cmd = cmd_help;
+				break;
+			default:
+				g_error("getopt");
+		}
+
+		//if (cmd)
+		//	break;
+	}
+
+	switch (cmd) {
+		case cmd_use_by_usbip:
+			use_device_by_usbip(busid);
+			break;
+		case cmd_use_by_other:
+			use_device_by_other(busid);
+			break;
+		case cmd_list:
+			show_devices();
+			break;
+		case cmd_list2:
+			show_devices2();
+			break;
+#if 0
+		case cmd_allusbip:
+			allusbip();
+			break;
+		case cmd_export_to:
+			export_to(remote_host, busid);
+			break;
+		case cmd_unexport:
+			unexport_from(remote_host, busid);
+			break;
+#endif
+		case cmd_help: /* fallthrough */
+		case cmd_unknown:
+			show_help();
+			break;
+		default:
+			g_error("NOT REACHED");
+	}
+
+	return 0;
+}
diff --git a/drivers/staging/usbip/userspace/src/usbip.c b/drivers/staging/usbip/userspace/src/usbip.c
new file mode 100644
index 0000000..8775394
--- /dev/null
+++ b/drivers/staging/usbip/userspace/src/usbip.c
@@ -0,0 +1,725 @@
+/*
+ * $Id$
+ *
+ * Copyright (C) 2005-2007 Takahiro Hirofuchi
+ */
+
+#ifdef HAVE_CONFIG_H
+#include "../config.h"
+#endif
+
+#include "usbip.h"
+#include "usbip_network.h"
+#include <ctype.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <stdlib.h>
+#include <fcntl.h>
+#include <glib.h>
+
+static const char version[] = PACKAGE_STRING
+	" ($Id$)";
+
+
+/* /sys/devices/platform/vhci_hcd/usb6/6-1/6-1:1.1  -> 1 */
+static int get_interface_number(char *path)
+{
+	char *c;
+
+	c = strstr(path, vhci_driver->hc_device->bus_id);
+	if (!c)
+		return -1;	/* hc exist? */
+	c++;
+	/* -> usb6/6-1/6-1:1.1 */
+
+	c = strchr(c, '/');
+	if (!c)
+		return -1;	/* hc exist? */
+	c++;
+	/* -> 6-1/6-1:1.1 */
+
+	c = strchr(c, '/');
+	if (!c)
+		return -1;	/* no interface path */
+	c++;
+	/* -> 6-1:1.1 */
+
+	c = strchr(c, ':');
+	if (!c)
+		return -1;	/* no configuration? */
+	c++;
+	/* -> 1.1 */
+
+	c = strchr(c, '.');
+	if (!c)
+		return -1;	/* no interface? */
+	c++;
+	/* -> 1 */
+
+
+	return atoi(c);
+}
+
+
+static struct sysfs_device *open_usb_interface(struct usb_device *udev, int i)
+{
+	struct sysfs_device *suinf;
+	char busid[SYSFS_BUS_ID_SIZE];
+
+	snprintf(busid, SYSFS_BUS_ID_SIZE, "%s:%d.%d",
+			udev->busid, udev->bConfigurationValue, i);
+
+	suinf = sysfs_open_device("usb", busid);
+	if (!suinf)
+		err("sysfs_open_device %s", busid);
+
+	return suinf;
+}
+
+
+#define MAX_BUFF 100
+static int record_connection(char *host, char *port, char *busid, int rhport)
+{
+	int fd;
+	char path[PATH_MAX+1];
+	char buff[MAX_BUFF+1];
+	int ret;
+
+	mkdir(VHCI_STATE_PATH, 0700);
+
+	snprintf(path, PATH_MAX, VHCI_STATE_PATH"/port%d", rhport);
+
+	fd = open(path, O_WRONLY|O_CREAT|O_TRUNC, S_IRWXU);
+	if (fd < 0)
+		return -1;
+
+	snprintf(buff, MAX_BUFF, "%s %s %s\n",
+			host, port, busid);
+
+	ret = write(fd, buff, strlen(buff));
+	if (ret != (ssize_t) strlen(buff)) {
+		close(fd);
+		return -1;
+	}
+
+	close(fd);
+
+	return 0;
+}
+
+static int read_record(int rhport, char *host, char *port, char *busid)
+{
+	FILE *file;
+	char path[PATH_MAX+1];
+
+	snprintf(path, PATH_MAX, VHCI_STATE_PATH"/port%d", rhport);
+
+	file = fopen(path, "r");
+	if (!file) {
+		err("fopen");
+		return -1;
+	}
+
+	if (fscanf(file, "%s %s %s\n", host, port, busid) != 3) {
+		err("fscanf");
+		fclose(file);
+		return -1;
+	}
+
+	fclose(file);
+
+	return 0;
+}
+
+
+int usbip_vhci_imported_device_dump(struct usbip_imported_device *idev)
+{
+	char product_name[100];
+	char host[NI_MAXHOST] = "unknown host";
+	char serv[NI_MAXSERV] = "unknown port";
+	char remote_busid[SYSFS_BUS_ID_SIZE];
+	int ret;
+
+	if (idev->status == VDEV_ST_NULL || idev->status == VDEV_ST_NOTASSIGNED) {
+		info("Port %02d: <%s>", idev->port, usbip_status_string(idev->status));
+		return 0;
+	}
+
+	ret = read_record(idev->port, host, serv, remote_busid);
+	if (ret) {
+		err("read_record");
+		return -1;
+	}
+
+	info("Port %02d: <%s> at %s", idev->port,
+			usbip_status_string(idev->status), usbip_speed_string(idev->udev.speed));
+
+	usbip_names_get_product(product_name, sizeof(product_name),
+			idev->udev.idVendor, idev->udev.idProduct);
+
+	info("       %s",  product_name);
+
+	info("%10s -> usbip://%s:%s/%s  (remote devid %08x (bus/dev %03d/%03d))",
+			idev->udev.busid, host, serv, remote_busid,
+			idev->devid,
+			idev->busnum, idev->devnum);
+
+	for (int i=0; i < idev->udev.bNumInterfaces; i++) {
+		/* show interface information */
+		struct sysfs_device *suinf;
+
+		suinf = open_usb_interface(&idev->udev, i);
+		if (!suinf)
+			continue;
+
+		info("       %6s used by %-17s", suinf->bus_id, suinf->driver_name);
+		sysfs_close_device(suinf);
+
+		/* show class device information */
+		struct class_device *cdev;
+
+		dlist_for_each_data(idev->cdev_list, cdev, struct class_device) {
+			int ifnum = get_interface_number(cdev->devpath);
+			if (ifnum == i) {
+				info("           %s", cdev->clspath);
+			}
+		}
+	}
+
+	return 0;
+}
+
+
+
+
+static int query_exported_devices(int sockfd)
+{
+	int ret;
+	struct op_devlist_reply rep;
+	uint16_t code = OP_REP_DEVLIST;
+
+	bzero(&rep, sizeof(rep));
+
+	ret = usbip_send_op_common(sockfd, OP_REQ_DEVLIST, 0);
+	if (ret < 0) {
+		err("send op_common");
+		return -1;
+	}
+
+	ret = usbip_recv_op_common(sockfd, &code);
+	if (ret < 0) {
+		err("recv op_common");
+		return -1;
+	}
+
+	ret = usbip_recv(sockfd, (void *) &rep, sizeof(rep));
+	if (ret < 0) {
+		err("recv op_devlist");
+		return -1;
+	}
+
+	PACK_OP_DEVLIST_REPLY(0, &rep);
+	dbg("exportable %d devices", rep.ndev);
+
+	for (unsigned int i=0; i < rep.ndev; i++) {
+		char product_name[100];
+		char class_name[100];
+		struct usb_device udev;
+
+		bzero(&udev, sizeof(udev));
+
+		ret = usbip_recv(sockfd, (void *) &udev, sizeof(udev));
+		if (ret < 0) {
+			err("recv usb_device[%d]", i);
+			return -1;
+		}
+		pack_usb_device(0, &udev);
+
+		usbip_names_get_product(product_name, sizeof(product_name),
+				udev.idVendor, udev.idProduct);
+		usbip_names_get_class(class_name, sizeof(class_name), udev.bDeviceClass,
+				udev.bDeviceSubClass, udev.bDeviceProtocol);
+
+		info("%8s: %s", udev.busid, product_name);
+		info("%8s: %s", " ", udev.path);
+		info("%8s: %s", " ", class_name);
+
+		for (int j=0; j < udev.bNumInterfaces; j++) {
+			struct usb_interface uinf;
+
+			ret = usbip_recv(sockfd, (void *) &uinf, sizeof(uinf));
+			if (ret < 0) {
+				err("recv usb_interface[%d]", j);
+				return -1;
+			}
+
+			pack_usb_interface(0, &uinf);
+			usbip_names_get_class(class_name, sizeof(class_name), uinf.bInterfaceClass,
+					uinf.bInterfaceSubClass, uinf.bInterfaceProtocol);
+
+			info("%8s: %2d - %s", " ", j, class_name);
+		}
+
+		info(" ");
+	}
+
+	return rep.ndev;
+}
+
+static int import_device(int sockfd, struct usb_device *udev)
+{
+	int ret;
+	int port;
+
+	ret = usbip_vhci_driver_open();
+	if (ret < 0) {
+		err("open vhci_driver");
+		return -1;
+	}
+
+	port = usbip_vhci_get_free_port();
+	if (port < 0) {
+		err("no free port");
+		usbip_vhci_driver_close();
+		return -1;
+	}
+
+	ret = usbip_vhci_attach_device(port, sockfd, udev->busnum,
+			udev->devnum, udev->speed);
+	if (ret < 0) {
+		err("import device");
+		usbip_vhci_driver_close();
+		return -1;
+	}
+
+	usbip_vhci_driver_close();
+
+	return port;
+}
+
+
+static int query_import_device(int sockfd, char *busid)
+{
+	int ret;
+	struct op_import_request request;
+	struct op_import_reply   reply;
+	uint16_t code = OP_REP_IMPORT;
+
+	bzero(&request, sizeof(request));
+	bzero(&reply, sizeof(reply));
+
+
+	/* send a request */
+	ret = usbip_send_op_common(sockfd, OP_REQ_IMPORT, 0);
+	if (ret < 0) {
+		err("send op_common");
+		return -1;
+	}
+
+	strncpy(request.busid, busid, SYSFS_BUS_ID_SIZE-1);
+
+	PACK_OP_IMPORT_REQUEST(0, &request);
+
+	ret = usbip_send(sockfd, (void *) &request, sizeof(request));
+	if (ret < 0) {
+		err("send op_import_request");
+		return -1;
+	}
+
+
+	/* recieve a reply */
+	ret = usbip_recv_op_common(sockfd, &code);
+	if (ret < 0) {
+		err("recv op_common");
+		return -1;
+	}
+
+	ret = usbip_recv(sockfd, (void *) &reply, sizeof(reply));
+	if (ret < 0) {
+		err("recv op_import_reply");
+		return -1;
+	}
+
+	PACK_OP_IMPORT_REPLY(0, &reply);
+
+
+	/* check the reply */
+	if (strncmp(reply.udev.busid, busid, SYSFS_BUS_ID_SIZE)) {
+		err("recv different busid %s", reply.udev.busid);
+		return -1;
+	}
+
+
+	/* import a device */
+	return import_device(sockfd, &reply.udev);
+}
+
+static int attach_device(char *host, char *busid)
+{
+	int sockfd;
+	int ret;
+	int rhport;
+
+	sockfd = tcp_connect(host, USBIP_PORT_STRING);
+	if (sockfd < 0) {
+		err("tcp connect");
+		return -1;
+	}
+
+	rhport = query_import_device(sockfd, busid);
+	if (rhport < 0) {
+		err("query");
+		return -1;
+	}
+
+	close(sockfd);
+
+	ret = record_connection(host, USBIP_PORT_STRING,
+			busid, rhport);
+	if (ret < 0) {
+		err("record connection");
+		return -1;
+	}
+
+	return 0;
+}
+
+static int detach_port(char *port)
+{
+	int ret;
+	uint8_t portnum;
+
+	for (unsigned int i=0; i < strlen(port); i++)
+		if (!isdigit(port[i])) {
+			err("invalid port %s", port);
+			return -1;
+		}
+
+	/* check max port */
+
+	portnum = atoi(port);
+
+	ret = usbip_vhci_driver_open();
+	if (ret < 0) {
+		err("open vhci_driver");
+		return -1;
+	}
+
+	ret = usbip_vhci_detach_device(portnum);
+	if (ret < 0)
+		return -1;
+
+	usbip_vhci_driver_close();
+
+	return ret;
+}
+
+static int show_exported_devices(char *host)
+{
+	int ret;
+	int sockfd;
+
+	sockfd = tcp_connect(host, USBIP_PORT_STRING);
+	if (sockfd < 0) {
+		err("- %s failed", host);
+		return -1;
+	}
+
+	info("- %s", host);
+
+	ret = query_exported_devices(sockfd);
+	if (ret < 0) {
+		err("query");
+		return -1;
+	}
+
+	close(sockfd);
+	return 0;
+}
+
+static int attach_exported_devices(char *host, int sockfd)
+{
+	int ret;
+	struct op_devlist_reply rep;
+	uint16_t code = OP_REP_DEVLIST;
+
+	bzero(&rep, sizeof(rep));
+
+	ret = usbip_send_op_common(sockfd, OP_REQ_DEVLIST, 0);
+	if(ret < 0) {
+		err("send op_common");
+		return -1;
+	}
+
+	ret = usbip_recv_op_common(sockfd, &code);
+	if(ret < 0) {
+		err("recv op_common");
+		return -1;
+	}
+
+	ret = usbip_recv(sockfd, (void *) &rep, sizeof(rep));
+	if(ret < 0) {
+		err("recv op_devlist");
+		return -1;
+	}
+
+	PACK_OP_DEVLIST_REPLY(0, &rep);
+	dbg("exportable %d devices", rep.ndev);
+
+	for(unsigned int i=0; i < rep.ndev; i++) {
+		char product_name[100];
+		char class_name[100];
+		struct usb_device udev;
+
+		bzero(&udev, sizeof(udev));
+
+		ret = usbip_recv(sockfd, (void *) &udev, sizeof(udev));
+		if(ret < 0) {
+			err("recv usb_device[%d]", i);
+			return -1;
+		}
+		pack_usb_device(0, &udev);
+
+		usbip_names_get_product(product_name, sizeof(product_name),
+				udev.idVendor, udev.idProduct);
+		usbip_names_get_class(class_name, sizeof(class_name), udev.bDeviceClass,
+				udev.bDeviceSubClass, udev.bDeviceProtocol);
+
+		dbg("Attaching usb port %s from host %s on usbip, with deviceid: %s", udev.busid, host, product_name);
+
+		for (int j=0; j < udev.bNumInterfaces; j++) {
+			struct usb_interface uinf;
+
+			ret = usbip_recv(sockfd, (void *) &uinf, sizeof(uinf));
+			if (ret < 0) {
+				err("recv usb_interface[%d]", j);
+				return -1;
+			}
+
+			pack_usb_interface(0, &uinf);
+			usbip_names_get_class(class_name, sizeof(class_name), uinf.bInterfaceClass,
+					uinf.bInterfaceSubClass, uinf.bInterfaceProtocol);
+
+			dbg("interface %2d - %s", j, class_name);
+		}
+
+		attach_device(host, udev.busid);
+	}
+
+	return rep.ndev;
+}
+
+static int attach_devices_all(char *host)
+{
+	int ret;
+	int sockfd;
+
+	sockfd = tcp_connect(host, USBIP_PORT_STRING);
+	if(sockfd < 0) {
+		err("- %s failed", host);
+		return -1;
+	}
+
+	info("- %s", host);
+
+	ret = attach_exported_devices(host, sockfd);
+	if(ret < 0) {
+		err("query");
+		return -1;
+	}
+
+	close(sockfd);
+	return 0;
+}
+
+
+const char help_message[] = "\
+Usage: usbip [options]				\n\
+	-a, --attach [host] [bus_id]		\n\
+		Attach a remote USB device.	\n\
+						\n\
+	-x, --attachall [host]		\n\
+		Attach all remote USB devices on the specific host.	\n\
+						\n\
+	-d, --detach [ports]			\n\
+		Detach an imported USB device.	\n\
+						\n\
+	-l, --list [hosts]			\n\
+		List exported USB devices.	\n\
+						\n\
+	-p, --port				\n\
+		List virtual USB port status. 	\n\
+						\n\
+	-D, --debug				\n\
+		Print debugging information.	\n\
+						\n\
+	-v, --version				\n\
+		Show version.			\n\
+						\n\
+	-h, --help 				\n\
+		Print this help.		\n";
+
+static void show_help(void)
+{
+	printf("%s", help_message);
+}
+
+static int show_port_status(void)
+{
+	int ret;
+	struct usbip_imported_device *idev;
+
+	ret = usbip_vhci_driver_open();
+	if (ret < 0)
+		return ret;
+
+	for (int i = 0; i < vhci_driver->nports; i++) {
+		idev = &vhci_driver->idev[i];
+
+		if (usbip_vhci_imported_device_dump(idev) < 0)
+			ret = -1;
+	}
+
+	usbip_vhci_driver_close();
+
+	return ret;
+}
+
+#define _GNU_SOURCE
+#include <getopt.h>
+static const struct option longopts[] = {
+	{"attach",	no_argument,	NULL, 'a'},
+	{"attachall",	no_argument,	NULL, 'x'},
+	{"detach",	no_argument,	NULL, 'd'},
+	{"port",	no_argument,	NULL, 'p'},
+	{"list",	no_argument,	NULL, 'l'},
+	{"version",	no_argument,	NULL, 'v'},
+	{"help",	no_argument,	NULL, 'h'},
+	{"debug",	no_argument,	NULL, 'D'},
+	{"syslog",	no_argument,	NULL, 'S'},
+	{NULL,		0,		NULL,  0}
+};
+
+int main(int argc, char *argv[])
+{
+	int ret;
+
+	enum {
+		cmd_attach = 1,
+		cmd_attachall,
+		cmd_detach,
+		cmd_port,
+		cmd_list,
+		cmd_help,
+		cmd_version
+	} cmd = 0;
+
+	usbip_use_stderr = 1;
+
+	if (geteuid() != 0)
+		g_warning("running non-root?");
+
+ 	ret = usbip_names_init(USBIDS_FILE);
+ 	if (ret)
+ 		notice("failed to open %s", USBIDS_FILE);
+
+	for (;;) {
+		int c;
+		int index = 0;
+
+		c = getopt_long(argc, argv, "adplvhDSx", longopts, &index);
+
+		if (c == -1)
+			break;
+
+		switch(c) {
+			case 'a':
+				if (!cmd)
+					cmd = cmd_attach;
+				else
+					cmd = cmd_help;
+				break;
+			case 'd':
+				if (!cmd)
+					cmd = cmd_detach;
+				else
+					cmd = cmd_help;
+				break;
+			case 'p':
+				if (!cmd)
+					cmd = cmd_port;
+				else cmd = cmd_help;
+				break;
+			case 'l':
+				if (!cmd)
+					cmd = cmd_list;
+				else
+					cmd = cmd_help;
+				break;
+			case 'v':
+				if (!cmd)
+					cmd = cmd_version;
+				else
+					cmd = cmd_help;
+				break;
+			case 'x':
+				if(!cmd)
+					cmd = cmd_attachall;
+				else
+					cmd = cmd_help;
+				break;
+			case 'h':
+				cmd = cmd_help;
+				break;
+			case 'D':
+				usbip_use_debug = 1;
+				break;
+			case 'S':
+				usbip_use_syslog = 1;
+				break;
+			case '?':
+				break;
+
+			default:
+				err("getopt");
+		}
+	}
+
+	ret = 0;
+	switch(cmd) {
+		case cmd_attach:
+			if (optind == argc - 2)
+				ret = attach_device(argv[optind], argv[optind+1]);
+			else
+				show_help();
+			break;
+		case cmd_detach:
+			while (optind < argc)
+				ret = detach_port(argv[optind++]);
+			break;
+		case cmd_port:
+			ret = show_port_status();
+			break;
+		case cmd_list:
+			while (optind < argc)
+				ret = show_exported_devices(argv[optind++]);
+			break;
+		case cmd_attachall:
+			while(optind < argc)
+				ret = attach_devices_all(argv[optind++]);
+			break;
+		case cmd_version:
+			printf("%s\n", version);
+			break;
+		case cmd_help:
+			show_help();
+			break;
+		default:
+			show_help();
+	}
+
+
+	usbip_names_free();
+
+	exit((ret == 0) ? EXIT_SUCCESS : EXIT_FAILURE);
+}
diff --git a/drivers/staging/usbip/userspace/src/usbip_network.c b/drivers/staging/usbip/userspace/src/usbip_network.c
new file mode 100644
index 0000000..a3a955b
--- /dev/null
+++ b/drivers/staging/usbip/userspace/src/usbip_network.c
@@ -0,0 +1,251 @@
+/*
+ * $Id$
+ *
+ * Copyright (C) 2005-2007 Takahiro Hirofuchi
+ */
+
+#include "usbip_network.h"
+
+void pack_uint32_t(int pack, uint32_t *num)
+{
+	uint32_t i;
+
+	if (pack)
+		i = htonl(*num);
+	else
+		i = ntohl(*num);
+
+	*num = i;
+}
+
+void pack_uint16_t(int pack, uint16_t *num)
+{
+	uint16_t i;
+
+	if (pack)
+		i = htons(*num);
+	else
+		i = ntohs(*num);
+
+	*num = i;
+}
+
+void pack_usb_device(int pack, struct usb_device *udev)
+{
+	pack_uint32_t(pack, &udev->busnum);
+	pack_uint32_t(pack, &udev->devnum);
+	pack_uint32_t(pack, &udev->speed );
+
+	pack_uint16_t(pack, &udev->idVendor );
+	pack_uint16_t(pack, &udev->idProduct);
+	pack_uint16_t(pack, &udev->bcdDevice);
+}
+
+void pack_usb_interface(int pack, struct usb_interface *udev)
+{
+	/* uint8_t members need nothing */
+}
+
+
+static ssize_t usbip_xmit(int sockfd, void *buff, size_t bufflen, int sending)
+{
+	ssize_t total = 0;
+
+	if (!bufflen)
+		return 0;
+
+	do {
+		ssize_t nbytes;
+
+		if (sending)
+			nbytes = send(sockfd, buff, bufflen, 0);
+		else
+			nbytes = recv(sockfd, buff, bufflen, MSG_WAITALL);
+
+		if (nbytes <= 0)
+			return -1;
+
+		buff	= (void *) ((intptr_t) buff + nbytes);
+		bufflen	-= nbytes;
+		total	+= nbytes;
+
+	} while (bufflen > 0);
+
+
+	return total;
+}
+
+ssize_t usbip_recv(int sockfd, void *buff, size_t bufflen)
+{
+	return usbip_xmit(sockfd, buff, bufflen, 0);
+}
+
+ssize_t usbip_send(int sockfd, void *buff, size_t bufflen)
+{
+	return usbip_xmit(sockfd, buff, bufflen, 1);
+}
+
+int usbip_send_op_common(int sockfd, uint32_t code, uint32_t status)
+{
+	int ret;
+	struct op_common op_common;
+
+	bzero(&op_common, sizeof(op_common));
+
+	op_common.version	= USBIP_VERSION;
+	op_common.code		= code;
+	op_common.status	= status;
+
+	PACK_OP_COMMON(1, &op_common);
+
+	ret = usbip_send(sockfd, (void *) &op_common, sizeof(op_common));
+	if (ret < 0) {
+		err("send op_common");
+		return -1;
+	}
+
+	return 0;
+}
+
+int usbip_recv_op_common(int sockfd, uint16_t *code)
+{
+	int ret;
+	struct op_common op_common;
+
+	bzero(&op_common, sizeof(op_common));
+
+	ret = usbip_recv(sockfd, (void *) &op_common, sizeof(op_common));
+	if (ret < 0) {
+		err("recv op_common, %d", ret);
+		goto err;
+	}
+
+	PACK_OP_COMMON(0, &op_common);
+
+	if (op_common.version != USBIP_VERSION) {
+		err("version mismatch, %d %d", op_common.version, USBIP_VERSION);
+		goto err;
+	}
+
+	switch(*code) {
+		case OP_UNSPEC:
+			break;
+		default:
+			if (op_common.code != *code) {
+				info("unexpected pdu %d for %d", op_common.code, *code);
+				goto err;
+			}
+	}
+
+	if (op_common.status != ST_OK) {
+		info("request failed at peer, %d", op_common.status);
+		goto err;
+	}
+
+	*code = op_common.code;
+
+	return 0;
+err:
+	return -1;
+}
+
+
+int usbip_set_reuseaddr(int sockfd)
+{
+	const int val = 1;
+	int ret;
+
+	ret = setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val));
+	if (ret < 0)
+		err("setsockopt SO_REUSEADDR");
+
+	return ret;
+}
+
+int usbip_set_nodelay(int sockfd)
+{
+	const int val = 1;
+	int ret;
+
+	ret = setsockopt(sockfd, IPPROTO_TCP, TCP_NODELAY, &val, sizeof(val));
+	if (ret < 0)
+		err("setsockopt TCP_NODELAY");
+
+	return ret;
+}
+
+int usbip_set_keepalive(int sockfd)
+{
+	const int val = 1;
+	int ret;
+
+	ret = setsockopt(sockfd, SOL_SOCKET, SO_KEEPALIVE, &val, sizeof(val));
+	if (ret < 0)
+		err("setsockopt SO_KEEPALIVE");
+
+	return ret;
+}
+
+/* IPv6 Ready */
+/*
+ * moved here from vhci_attach.c
+ */
+int tcp_connect(char *hostname, char *service)
+{
+	struct addrinfo hints, *res, *res0;
+	int sockfd;
+	int err;
+
+
+	memset(&hints, 0, sizeof(hints));
+	hints.ai_socktype = SOCK_STREAM;
+
+	/* get all possible addresses */
+	err = getaddrinfo(hostname, service, &hints, &res0);
+	if (err) {
+		err("%s %s: %s", hostname, service, gai_strerror(err));
+		return -1;
+	}
+
+	/* try all the addresses */
+	for (res = res0; res; res = res->ai_next) {
+		char hbuf[NI_MAXHOST], sbuf[NI_MAXSERV];
+
+		err = getnameinfo(res->ai_addr, res->ai_addrlen,
+				hbuf, sizeof(hbuf), sbuf, sizeof(sbuf), NI_NUMERICHOST | NI_NUMERICSERV);
+		if (err) {
+			err("%s %s: %s", hostname, service, gai_strerror(err));
+			continue;
+		}
+
+		dbg("trying %s port %s\n", hbuf, sbuf);
+
+		sockfd = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
+		if (sockfd < 0) {
+			err("socket");
+			continue;
+		}
+
+		/* should set TCP_NODELAY for usbip */
+		usbip_set_nodelay(sockfd);
+		/* TODO: write code for heatbeat */
+		usbip_set_keepalive(sockfd);
+
+		err = connect(sockfd, res->ai_addr, res->ai_addrlen);
+		if (err < 0) {
+			close(sockfd);
+			continue;
+		}
+
+		/* connected */
+		dbg("connected to %s:%s", hbuf, sbuf);
+		freeaddrinfo(res0);
+		return sockfd;
+	}
+
+
+	dbg("%s:%s, %s", hostname, service, "no destination to connect to");
+	freeaddrinfo(res0);
+
+	return -1;
+}
diff --git a/drivers/staging/usbip/userspace/src/usbip_network.h b/drivers/staging/usbip/userspace/src/usbip_network.h
new file mode 100644
index 0000000..804f83d
--- /dev/null
+++ b/drivers/staging/usbip/userspace/src/usbip_network.h
@@ -0,0 +1,198 @@
+/*
+ * Copyright (C) 2005-2007 Takahiro Hirofuchi
+ */
+
+#ifndef _USBIP_NETWORK_H
+#define _USBIP_NETWORK_H
+
+#include "usbip.h"
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <netinet/tcp.h>
+
+
+/* -------------------------------------------------- */
+/* Define Protocol Format                             */
+/* -------------------------------------------------- */
+
+
+/* ---------------------------------------------------------------------- */
+/* Common header for all the kinds of PDUs. */
+struct op_common {
+	uint16_t version;
+
+#define OP_REQUEST	(0x80 << 8)
+#define OP_REPLY	(0x00 << 8)
+	uint16_t code;
+
+	/* add more error code */
+#define ST_OK	0x00
+#define ST_NA	0x01
+	uint32_t status; /* op_code status (for reply) */
+
+} __attribute__((packed));
+
+#define PACK_OP_COMMON(pack, op_common)  do {\
+	pack_uint16_t(pack, &(op_common)->version);\
+	pack_uint16_t(pack, &(op_common)->code   );\
+	pack_uint32_t(pack, &(op_common)->status );\
+} while (0)
+
+
+/* ---------------------------------------------------------------------- */
+/* Dummy Code */
+#define OP_UNSPEC	0x00
+#define OP_REQ_UNSPEC	OP_UNSPEC
+#define OP_REP_UNSPEC	OP_UNSPEC
+
+/* ---------------------------------------------------------------------- */
+/* Retrieve USB device information. (still not used) */
+#define OP_DEVINFO	0x02
+#define OP_REQ_DEVINFO	(OP_REQUEST | OP_DEVINFO)
+#define OP_REP_DEVINFO	(OP_REPLY   | OP_DEVINFO)
+
+struct op_devinfo_request {
+	char busid[SYSFS_BUS_ID_SIZE];
+} __attribute__((packed));
+
+struct op_devinfo_reply {
+	struct usb_device udev;
+	struct usb_interface uinf[];
+} __attribute__((packed));
+
+
+/* ---------------------------------------------------------------------- */
+/* Import a remote USB device. */
+#define OP_IMPORT	0x03
+#define OP_REQ_IMPORT	(OP_REQUEST | OP_IMPORT)
+#define OP_REP_IMPORT   (OP_REPLY   | OP_IMPORT)
+
+struct op_import_request {
+	char busid[SYSFS_BUS_ID_SIZE];
+} __attribute__((packed));
+
+struct op_import_reply {
+	struct usb_device udev;
+//	struct usb_interface uinf[];
+} __attribute__((packed));
+
+#define PACK_OP_IMPORT_REQUEST(pack, request)  do {\
+} while (0)
+
+#define PACK_OP_IMPORT_REPLY(pack, reply)  do {\
+	pack_usb_device(pack, &(reply)->udev);\
+} while (0)
+
+
+
+/* ---------------------------------------------------------------------- */
+/* Export a USB device to a remote host. */
+#define OP_EXPORT	0x06
+#define OP_REQ_EXPORT	(OP_REQUEST | OP_EXPORT)
+#define OP_REP_EXPORT	(OP_REPLY   | OP_EXPORT)
+
+struct op_export_request {
+	struct usb_device udev;
+} __attribute__((packed));
+
+struct op_export_reply {
+	int returncode; 
+} __attribute__((packed));
+
+
+#define PACK_OP_EXPORT_REQUEST(pack, request)  do {\
+	pack_usb_device(pack, &(request)->udev);\
+} while (0)
+
+#define PACK_OP_EXPORT_REPLY(pack, reply)  do {\
+} while (0)
+
+/* ---------------------------------------------------------------------- */
+/* un-Export a USB device from a remote host. */
+#define OP_UNEXPORT	0x07
+#define OP_REQ_UNEXPORT	(OP_REQUEST | OP_UNEXPORT)
+#define OP_REP_UNEXPORT	(OP_REPLY   | OP_UNEXPORT)
+
+struct op_unexport_request {
+	struct usb_device udev;
+} __attribute__((packed));
+
+struct op_unexport_reply {
+	int returncode; 
+} __attribute__((packed));
+
+#define PACK_OP_UNEXPORT_REQUEST(pack, request)  do {\
+	pack_usb_device(pack, &(request)->udev);\
+} while (0)
+
+#define PACK_OP_UNEXPORT_REPLY(pack, reply)  do {\
+} while (0)
+
+
+
+/* ---------------------------------------------------------------------- */
+/* Negotiate IPSec encryption key. (still not used) */
+#define OP_CRYPKEY	0x04
+#define OP_REQ_CRYPKEY	(OP_REQUEST | OP_CRYPKEY)
+#define OP_REP_CRYPKEY	(OP_REPLY   | OP_CRYPKEY)
+
+struct op_crypkey_request {
+	/* 128bit key */
+	uint32_t key[4];
+} __attribute__((packed));
+
+struct op_crypkey_reply {
+	uint32_t __reserved;
+} __attribute__((packed));
+
+
+/* ---------------------------------------------------------------------- */
+/* Retrieve the list of exported USB devices. */
+#define OP_DEVLIST	0x05
+#define OP_REQ_DEVLIST	(OP_REQUEST | OP_DEVLIST)
+#define OP_REP_DEVLIST	(OP_REPLY   | OP_DEVLIST)
+
+struct op_devlist_request {
+} __attribute__((packed));
+
+struct op_devlist_reply {
+	uint32_t ndev;
+	/* followed by reply_extra[] */
+} __attribute__((packed));
+
+struct op_devlist_reply_extra {
+	struct usb_device    udev;
+	struct usb_interface uinf[];
+} __attribute__((packed));
+
+#define PACK_OP_DEVLIST_REQUEST(pack, request)  do {\
+} while (0)
+
+#define PACK_OP_DEVLIST_REPLY(pack, reply)  do {\
+	pack_uint32_t(pack, &(reply)->ndev);\
+} while (0)
+
+
+/* -------------------------------------------------- */
+/* Declare Prototype Function                         */
+/* -------------------------------------------------- */
+
+void pack_uint32_t(int pack, uint32_t *num);
+void pack_uint16_t(int pack, uint16_t *num);
+void pack_usb_device(int pack, struct usb_device *udev);
+void pack_usb_interface(int pack, struct usb_interface *uinf);
+
+ssize_t usbip_recv(int sockfd, void *buff, size_t bufflen);
+ssize_t usbip_send(int sockfd, void *buff, size_t bufflen);
+int usbip_send_op_common(int sockfd, uint32_t code, uint32_t status);
+int usbip_recv_op_common(int sockfd, uint16_t *code);
+int usbip_set_reuseaddr(int sockfd);
+int usbip_set_nodelay(int sockfd);
+int usbip_set_keepalive(int sockfd);
+
+int tcp_connect(char *hostname, char *service);
+
+#define USBIP_PORT 3240
+#define USBIP_PORT_STRING "3240"
+
+#endif
diff --git a/drivers/staging/usbip/userspace/src/usbipd.c b/drivers/staging/usbip/userspace/src/usbipd.c
new file mode 100644
index 0000000..441dcde
--- /dev/null
+++ b/drivers/staging/usbip/userspace/src/usbipd.c
@@ -0,0 +1,571 @@
+/*
+ * $Id$
+ *
+ * Copyright (C) 2005-2007 Takahiro Hirofuchi
+ */
+
+#ifdef HAVE_CONFIG_H
+#include "../config.h"
+#endif
+
+#include <unistd.h>
+#include <netdb.h>
+#include <strings.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <arpa/inet.h>
+#include <sys/socket.h>
+#include <netinet/in.h>
+
+#ifdef HAVE_LIBWRAP
+#include <tcpd.h>
+#endif
+
+#define _GNU_SOURCE
+#include <getopt.h>
+#include <signal.h>
+
+#include "usbip.h"
+#include "usbip_network.h"
+
+#include <glib.h>
+
+static const char version[] = PACKAGE_STRING
+	" ($Id$)";
+
+
+static int send_reply_devlist(int sockfd)
+{
+	int ret;
+	struct usbip_exported_device *edev;
+	struct op_devlist_reply reply;
+
+
+	reply.ndev = 0;
+
+	/* how many devices are exported ? */
+	dlist_for_each_data(stub_driver->edev_list, edev, struct usbip_exported_device) {
+		reply.ndev += 1;
+	}
+
+	dbg("%d devices are exported", reply.ndev);
+
+	ret = usbip_send_op_common(sockfd, OP_REP_DEVLIST,  ST_OK);
+	if (ret < 0) {
+		err("send op_common");
+		return ret;
+	}
+
+	PACK_OP_DEVLIST_REPLY(1, &reply);
+
+	ret = usbip_send(sockfd, (void *) &reply, sizeof(reply));
+	if (ret < 0) {
+		err("send op_devlist_reply");
+		return ret;
+	}
+
+	dlist_for_each_data(stub_driver->edev_list, edev, struct usbip_exported_device) {
+		struct usb_device pdu_udev;
+
+		dump_usb_device(&edev->udev);
+		memcpy(&pdu_udev, &edev->udev, sizeof(pdu_udev));
+		pack_usb_device(1, &pdu_udev);
+
+		ret = usbip_send(sockfd, (void *) &pdu_udev, sizeof(pdu_udev));
+		if (ret < 0) {
+			err("send pdu_udev");
+			return ret;
+		}
+
+		for (int i=0; i < edev->udev.bNumInterfaces; i++) {
+			struct usb_interface pdu_uinf;
+
+			dump_usb_interface(&edev->uinf[i]);
+			memcpy(&pdu_uinf, &edev->uinf[i], sizeof(pdu_uinf));
+			pack_usb_interface(1, &pdu_uinf);
+
+			ret = usbip_send(sockfd, (void *) &pdu_uinf, sizeof(pdu_uinf));
+			if (ret < 0) {
+				err("send pdu_uinf");
+				return ret;
+			}
+		}
+	}
+
+	return 0;
+}
+
+
+static int recv_request_devlist(int sockfd)
+{
+	int ret;
+	struct op_devlist_request req;
+
+	bzero(&req, sizeof(req));
+
+	ret = usbip_recv(sockfd, (void *) &req, sizeof(req));
+	if (ret < 0) {
+		err("recv devlist request");
+		return -1;
+	}
+
+	ret = send_reply_devlist(sockfd);
+	if (ret < 0) {
+		err("send devlist reply");
+		return -1;
+	}
+
+	return 0;
+}
+
+
+static int recv_request_import(int sockfd)
+{
+	int ret;
+	struct op_import_request req;
+	struct op_common reply;
+	struct usbip_exported_device *edev;
+	int found = 0;
+	int error = 0;
+
+	bzero(&req, sizeof(req));
+	bzero(&reply, sizeof(reply));
+
+	ret = usbip_recv(sockfd, (void *) &req, sizeof(req));
+	if (ret < 0) {
+		err("recv import request");
+		return -1;
+	}
+
+	PACK_OP_IMPORT_REQUEST(0, &req);
+
+	dlist_for_each_data(stub_driver->edev_list, edev, struct usbip_exported_device) {
+		if (!strncmp(req.busid, edev->udev.busid, SYSFS_BUS_ID_SIZE)) {
+			dbg("found requested device %s", req.busid);
+			found = 1;
+			break;
+		}
+	}
+
+	if (found) {
+		/* should set TCP_NODELAY for usbip */
+		usbip_set_nodelay(sockfd);
+
+		/* export_device needs a TCP/IP socket descriptor */
+		ret = usbip_stub_export_device(edev, sockfd);
+		if (ret < 0)
+			error = 1;
+	} else {
+		info("not found requested device %s", req.busid);
+		error = 1;
+	}
+
+
+	ret = usbip_send_op_common(sockfd, OP_REP_IMPORT, (!error ? ST_OK : ST_NA));
+	if (ret < 0) {
+		err("send import reply");
+		return -1;
+	}
+
+	if (!error) {
+		struct usb_device pdu_udev;
+
+		memcpy(&pdu_udev, &edev->udev, sizeof(pdu_udev));
+		pack_usb_device(1, &pdu_udev);
+
+		ret = usbip_send(sockfd, (void *) &pdu_udev, sizeof(pdu_udev));
+		if (ret < 0) {
+			err("send devinfo");
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
+
+
+static int recv_pdu(int sockfd)
+{
+	int ret;
+	uint16_t code = OP_UNSPEC;
+
+
+	ret = usbip_recv_op_common(sockfd, &code);
+	if (ret < 0) {
+		err("recv op_common, %d", ret);
+		return ret;
+	}
+
+
+	ret = usbip_stub_refresh_device_list();
+	if (ret < 0)
+		return -1;
+
+	switch(code) {
+		case OP_REQ_DEVLIST:
+			ret = recv_request_devlist(sockfd);
+			break;
+
+		case OP_REQ_IMPORT:
+			ret = recv_request_import(sockfd);
+			break;
+
+		case OP_REQ_DEVINFO:
+		case OP_REQ_CRYPKEY:
+
+		default:
+			err("unknown op_code, %d", code);
+			ret = -1;
+	}
+
+
+	return ret;
+}
+
+
+
+
+static void log_addrinfo(struct addrinfo *ai)
+{
+	int ret;
+	char hbuf[NI_MAXHOST];
+	char sbuf[NI_MAXSERV];
+
+	ret = getnameinfo(ai->ai_addr, ai->ai_addrlen, hbuf, sizeof(hbuf),
+			sbuf, sizeof(sbuf), NI_NUMERICHOST | NI_NUMERICSERV);
+	if (ret)
+		err("getnameinfo, %s", gai_strerror(ret));
+
+	info("listen at [%s]:%s", hbuf, sbuf);
+}
+
+static struct addrinfo *my_getaddrinfo(char *host, int ai_family)
+{
+	int ret;
+	struct addrinfo hints, *ai_head;
+
+	bzero(&hints, sizeof(hints));
+
+	hints.ai_family   = ai_family;
+	hints.ai_socktype = SOCK_STREAM;
+	hints.ai_flags    = AI_PASSIVE;
+
+	ret = getaddrinfo(host, USBIP_PORT_STRING, &hints, &ai_head);
+	if (ret) {
+		err("%s: %s", USBIP_PORT_STRING, gai_strerror(ret));
+		return NULL;
+	}
+
+	return ai_head;
+}
+
+#define MAXSOCK 20
+static int listen_all_addrinfo(struct addrinfo *ai_head, int lsock[])
+{
+	struct addrinfo *ai;
+	int n = 0;		/* number of sockets */
+
+	for (ai = ai_head; ai && n < MAXSOCK; ai = ai->ai_next) {
+		int ret;
+
+		lsock[n] = socket(ai->ai_family, ai->ai_socktype, ai->ai_protocol);
+		if (lsock[n] < 0)
+			continue;
+
+		usbip_set_reuseaddr(lsock[n]);
+		usbip_set_nodelay(lsock[n]);
+
+		if (lsock[n] >= FD_SETSIZE) {
+			close(lsock[n]);
+			lsock[n] = -1;
+			continue;
+		}
+
+		ret = bind(lsock[n], ai->ai_addr, ai->ai_addrlen);
+		if (ret < 0) {
+			close(lsock[n]);
+			lsock[n] = -1;
+			continue;
+		}
+
+		ret = listen(lsock[n], SOMAXCONN);
+		if (ret < 0) {
+			close(lsock[n]);
+			lsock[n] = -1;
+			continue;
+		}
+
+		log_addrinfo(ai);
+
+		/* next if succeed */
+		n++;
+	}
+
+	if (n == 0) {
+		err("no socket to listen to");
+		return -1;
+	}
+
+	dbg("listen %d address%s", n, (n==1)?"":"es");
+
+	return n;
+}
+
+#ifdef HAVE_LIBWRAP
+static int tcpd_auth(int csock)
+{
+	int ret;
+	struct request_info request;
+
+	request_init(&request, RQ_DAEMON, "usbipd", RQ_FILE, csock, 0);
+
+	fromhost(&request);
+
+	ret = hosts_access(&request);
+	if (!ret)
+		return -1;
+
+	return 0;
+}
+#endif
+
+static int my_accept(int lsock)
+{
+	int csock;
+	struct sockaddr_storage ss;
+	socklen_t len = sizeof(ss);
+	char host[NI_MAXHOST], port[NI_MAXSERV];
+	int ret;
+
+	bzero(&ss, sizeof(ss));
+
+	csock = accept(lsock, (struct sockaddr *) &ss, &len);
+	if (csock < 0) {
+		err("accept");
+		return -1;
+	}
+
+	ret = getnameinfo((struct sockaddr *) &ss, len,
+			host, sizeof(host), port, sizeof(port),
+			(NI_NUMERICHOST | NI_NUMERICSERV));
+	if (ret)
+		err("getnameinfo, %s", gai_strerror(ret));
+
+#ifdef HAVE_LIBWRAP
+	ret = tcpd_auth(csock);
+	if (ret < 0) {
+		info("deny access from %s", host);
+		close(csock);
+		return -1;
+	}
+#endif
+
+	info("connected from %s:%s", host, port);
+
+	return csock;
+}
+
+
+GMainLoop *main_loop;
+
+static void signal_handler(int i)
+{
+	dbg("signal catched, code %d", i);
+
+	if (main_loop)
+		g_main_loop_quit(main_loop);
+}
+
+static void set_signal(void)
+{
+	struct sigaction act;
+
+	bzero(&act, sizeof(act));
+	act.sa_handler = signal_handler;
+	sigemptyset(&act.sa_mask);
+	sigaction(SIGTERM, &act, NULL);
+	sigaction(SIGINT, &act, NULL);
+}
+
+
+gboolean process_comming_request(GIOChannel *gio, GIOCondition condition, gpointer data)
+{
+	int ret;
+
+	if (condition & (G_IO_ERR | G_IO_HUP | G_IO_NVAL))
+		g_error("unknown condition");
+
+
+	if (condition & G_IO_IN) {
+		int lsock;
+		int csock;
+
+		lsock = g_io_channel_unix_get_fd(gio);
+
+		csock = my_accept(lsock);
+		if (csock < 0)
+			return TRUE;
+
+		ret = recv_pdu(csock);
+		if (ret < 0)
+			err("process recieved pdu");
+
+		close(csock);
+	}
+
+	return TRUE;
+}
+
+
+static void do_standalone_mode(gboolean daemonize)
+{
+	int ret;
+	int lsock[MAXSOCK];
+	struct addrinfo *ai_head;
+	int n;
+
+
+
+	ret = usbip_names_init(USBIDS_FILE);
+	if (ret)
+		err("open usb.ids");
+
+	ret = usbip_stub_driver_open();
+	if (ret < 0)
+		g_error("driver open failed");
+
+	if (daemonize) {
+		if (daemon(0,0) < 0)
+			g_error("daemonizing failed: %s", g_strerror(errno));
+
+		usbip_use_syslog = 1;
+	}
+
+	set_signal();
+
+	ai_head = my_getaddrinfo(NULL, PF_UNSPEC);
+	if (!ai_head)
+		return;
+
+	n = listen_all_addrinfo(ai_head, lsock);
+	if (n <= 0)
+		g_error("no socket to listen to");
+
+	for (int i = 0; i < n; i++) {
+		GIOChannel *gio;
+
+		gio = g_io_channel_unix_new(lsock[i]);
+		g_io_add_watch(gio, (G_IO_IN | G_IO_ERR | G_IO_HUP | G_IO_NVAL),
+				process_comming_request, NULL);
+	}
+
+
+	info("usbipd start (%s)", version);
+
+
+	main_loop = g_main_loop_new(FALSE, FALSE);
+	g_main_loop_run(main_loop);
+
+	info("shutdown");
+
+	freeaddrinfo(ai_head);
+	usbip_names_free();
+	usbip_stub_driver_close();
+
+	return;
+}
+
+
+static const char help_message[] = "\
+Usage: usbipd [options]				\n\
+	-D, --daemon				\n\
+		Run as a daemon process.	\n\
+						\n\
+	-d, --debug				\n\
+		Print debugging information.	\n\
+						\n\
+	-v, --version				\n\
+		Show version.			\n\
+						\n\
+	-h, --help 				\n\
+		Print this help.		\n";
+
+static void show_help(void)
+{
+	printf("%s", help_message);
+}
+
+static const struct option longopts[] = {
+	{"daemon",	no_argument,	NULL, 'D'},
+	{"debug",	no_argument,	NULL, 'd'},
+	{"version",	no_argument,	NULL, 'v'},
+	{"help",	no_argument,	NULL, 'h'},
+	{NULL,		0,		NULL,  0}
+};
+
+int main(int argc, char *argv[])
+{
+	gboolean daemonize = FALSE;
+
+	enum {
+		cmd_standalone_mode = 1,
+		cmd_help,
+		cmd_version
+	} cmd = cmd_standalone_mode;
+
+
+	usbip_use_stderr = 1;
+	usbip_use_syslog = 0;
+
+	if (geteuid() != 0)
+		g_warning("running non-root?");
+
+	for (;;) {
+		int c;
+		int index = 0;
+
+		c = getopt_long(argc, argv, "vhdD", longopts, &index);
+
+		if (c == -1)
+			break;
+
+		switch (c) {
+			case 'd':
+				usbip_use_debug = 1;
+				continue;
+			case 'v':
+				cmd = cmd_version;
+				break;
+			case 'h':
+				cmd = cmd_help;
+				break;
+			case 'D':
+				daemonize = TRUE;
+				break;
+			case '?':
+				show_help();
+				exit(EXIT_FAILURE);
+			default:
+				err("getopt");
+		}
+	}
+
+	switch (cmd) {
+		case cmd_standalone_mode:
+			do_standalone_mode(daemonize);
+			break;
+		case cmd_version:
+			printf("%s\n", version);
+			break;
+		case cmd_help:
+			show_help();
+			break;
+		default:
+			info("unknown cmd");
+			show_help();
+	}
+
+	return 0;
+}
diff --git a/drivers/staging/usbip/userspace/src/utils.c b/drivers/staging/usbip/userspace/src/utils.c
new file mode 100644
index 0000000..403c30f
--- /dev/null
+++ b/drivers/staging/usbip/userspace/src/utils.c
@@ -0,0 +1,256 @@
+/*
+ * $Id$
+ *
+ * Copyright (C) 2005-2007 Takahiro Hirofuchi
+ */
+
+#include "utils.h"
+
+int read_integer(char *path)
+{
+	char buff[100];
+	int fd;
+	int ret = 0;
+
+	bzero(buff, sizeof(buff));
+
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		return -1;
+
+	ret = read(fd, buff, sizeof(buff));
+	if (ret < 0) {
+		close(fd);
+		return -1;
+	}
+
+	sscanf(buff, "%d", &ret);
+
+	close(fd);
+
+	return ret;
+}
+
+int read_string(char *path, char *string, size_t len)
+{
+	int fd;
+	int ret = 0;
+	char  *p;
+
+	bzero(string, len);
+
+	fd = open(path, O_RDONLY);
+	if (fd < 0) {
+		string = NULL;
+		return -1;
+	}
+
+	ret = read(fd, string, len-1);
+	if (ret < 0) {
+		string = NULL;
+		close(fd);
+		return -1;
+	}
+
+	p = strchr(string, '\n');
+	*p = '\0';
+
+	close(fd);
+
+	return 0;
+}
+
+int write_integer(char *path, int value)
+{
+	int fd;
+	int ret;
+	char buff[100];
+
+	snprintf(buff, sizeof(buff), "%d", value);
+
+	fd = open(path, O_WRONLY);
+	if (fd < 0)
+		return -1;
+
+	ret = write(fd, buff, strlen(buff));
+	if (ret < 0) {
+		close(fd);
+		return -1;
+	}
+
+	close(fd);
+
+	return 0;
+}
+
+int read_bConfigurationValue(char *busid)
+{
+	char path[PATH_MAX];
+
+	snprintf(path, PATH_MAX, "/sys/bus/usb/devices/%s/bConfigurationValue", busid);
+
+	return read_integer(path);
+}
+
+int write_bConfigurationValue(char *busid, int config)
+{
+	char path[PATH_MAX];
+
+	snprintf(path, PATH_MAX, "/sys/bus/usb/devices/%s/bConfigurationValue", busid);
+
+	return write_integer(path, config);
+}
+
+int read_bNumInterfaces(char *busid)
+{
+	char path[PATH_MAX];
+
+	snprintf(path, PATH_MAX, "/sys/bus/usb/devices/%s/bNumInterfaces", busid);
+
+	return read_integer(path);
+}
+
+int read_bDeviceClass(char *busid)
+{
+	char path[PATH_MAX];
+
+	snprintf(path, PATH_MAX, "/sys/bus/usb/devices/%s/bDeviceClass", busid);
+
+	return read_integer(path);
+}
+
+int getdriver(char *busid, int conf, int infnum, char *driver, size_t len)
+{
+	char path[PATH_MAX];
+	char linkto[PATH_MAX];
+	int ret;
+
+	snprintf(path, PATH_MAX, "/sys/bus/usb/devices/%s:%d.%d/driver", busid, conf, infnum);
+
+	/* readlink does not add NULL */
+	bzero(linkto, sizeof(linkto));
+	ret = readlink(path, linkto, sizeof(linkto)-1);
+	if (ret < 0) {
+		strncpy(driver, "none", len);
+		return -1;
+	} else {
+		strncpy(driver, basename(linkto), len);
+		return 0;
+	}
+}
+
+int getdevicename(char *busid, char *name, size_t len)
+{
+	char path[PATH_MAX];
+	char idProduct[10], idVendor[10];
+
+	snprintf(path, PATH_MAX, "/sys/bus/usb/devices/%s/idVendor", busid);
+	read_string(path, idVendor, sizeof(idVendor));
+
+	snprintf(path, PATH_MAX, "/sys/bus/usb/devices/%s/idProduct", busid);
+	read_string(path, idProduct, sizeof(idProduct));
+
+	if (!idVendor[0] || !idProduct[0])
+		return -1;
+
+	snprintf(name, len, "%s:%s", idVendor, idProduct);
+
+	return 0;
+}
+
+#define MAXLINE 100
+
+/* if this cannot read a whole line, return -1 */
+int readline(int sockfd, char *buff, int bufflen)
+{
+	int ret;
+	char c;
+	int index = 0;
+
+
+	while (index < bufflen) {
+		ret = read(sockfd, &c, sizeof(c));
+		if (ret < 0 && errno == EINTR)
+			continue;
+		if (ret <= 0) {
+			return -1;
+		}
+
+		buff[index] = c;
+
+		if ( index > 0 && buff[index-1] == '\r'  && buff[index] == '\n') {
+			/* end of line */
+			buff[index-1] = '\0';	/* get rid of delimitor */
+			return index;
+		} else
+			index++;
+	}
+
+	return -1;
+}
+
+#if 0
+int writeline(int sockfd, char *str, int strlen)
+{
+	int ret;
+	int index = 0;
+	int len;
+	char buff[MAXLINE];
+
+	if (strlen + 3 > MAXLINE)
+		return -1;
+
+	strncpy(buff, str, strlen);
+	buff[strlen+1] = '\r';
+	buff[strlen+2] = '\n';
+	buff[strlen+3] = '\0';
+
+	len = strlen + 3;
+
+	while (len > 0) {
+		ret = write(sockfd, buff+index, len);
+		if (ret <= 0) {
+			return -1;
+		}
+
+		len -= ret;
+		index += ret;
+	}
+
+	return index;
+}
+#endif
+
+int writeline(int sockfd, char *str, int strlen)
+{
+	int ret;
+	int index = 0;
+	int len;
+	char buff[MAXLINE];
+
+	len = strnlen(str, strlen);
+
+	if (strlen + 2 > MAXLINE)
+		return -1;
+
+	memcpy(buff, str, strlen);
+	buff[strlen] = '\r';
+	buff[strlen+1] = '\n';		/* strlen+1 <= MAXLINE-1 */
+
+	len = strlen + 2;
+
+	while (len > 0) {
+		ret = write(sockfd, buff+index, len);
+		if (ret < 0 && errno == EINTR)
+			continue;
+		if (ret <= 0) {
+			return -1;
+		}
+
+		len -= ret;
+		index += ret;
+	}
+
+	return index;
+}
+
diff --git a/drivers/staging/usbip/userspace/src/utils.h b/drivers/staging/usbip/userspace/src/utils.h
new file mode 100644
index 0000000..6c29ae9
--- /dev/null
+++ b/drivers/staging/usbip/userspace/src/utils.h
@@ -0,0 +1,38 @@
+
+#ifdef HAVE_CONFIG_H
+#include "../config.h"
+#endif
+
+#define _GNU_SOURCE
+#include <string.h>
+#include <sys/un.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+
+#include <sysfs/libsysfs.h>
+#include <glib.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <time.h>
+#include <errno.h>
+
+
+
+/* Be sync to kernel header */
+#define BUS_ID_SIZE 20
+
+int read_string(char *path, char *, size_t len);
+int read_integer(char *path);
+int getdevicename(char *busid, char *name, size_t len);
+int getdriver(char *busid, int conf, int infnum, char *driver, size_t len);
+int read_bNumInterfaces(char *busid);
+int read_bConfigurationValue(char *busid);
+int write_integer(char *path, int value);
+int write_bConfigurationValue(char *busid, int config);
+int read_bDeviceClass(char *busid);
+int readline(int sockfd, char *str, int strlen);
+int writeline(int sockfd, char *buff, int bufflen);
-- 
1.7.5.1

