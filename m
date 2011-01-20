Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab1ATSED (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 13:04:03 -0500
Received: from kroah.org ([198.145.64.141]:45924 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215Ab1ATSDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 13:03:51 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/3] tty: update MAINTAINERS file due to driver movement
Date: Thu, 20 Jan 2011 10:03:45 -0800
Message-Id: <1295546625-30681-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20110120174910.GA30124@kroah.com>
References: <20110120174910.GA30124@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes up the MAINTAINERS file due to moving the serial
drivers to the drivers/tty/ directory.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 MAINTAINERS |   50 +++++++++++++++++++++++++-------------------------
 1 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 78162c4..fd05bb7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -162,7 +162,7 @@ L:	linux-serial@vger.kernel.org
 W:	http://serial.sourceforge.net
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty-2.6.git
-F:	drivers/serial/8250*
+F:	drivers/tty/serial/8250*
 F:	include/linux/serial_8250.h
 
 8390 NETWORK DRIVERS [WD80x3/SMC-ELITE, SMC-ULTRA, NE2000, 3C503, etc.]
@@ -888,8 +888,8 @@ F:	arch/arm/mach-msm/
 F:	drivers/video/msm/
 F:	drivers/mmc/host/msm_sdcc.c
 F:	drivers/mmc/host/msm_sdcc.h
-F:	drivers/serial/msm_serial.h
-F:	drivers/serial/msm_serial.c
+F:	drivers/tty/serial/msm_serial.h
+F:	drivers/tty/serial/msm_serial.c
 T:	git git://codeaurora.org/quic/kernel/davidb/linux-msm.git
 S:	Maintained
 
@@ -1256,7 +1256,7 @@ F:	drivers/mmc/host/atmel-mci-regs.h
 ATMEL AT91 / AT32 SERIAL DRIVER
 M:	Nicolas Ferre <nicolas.ferre@atmel.com>
 S:	Supported
-F:	drivers/serial/atmel_serial.c
+F:	drivers/tty/serial/atmel_serial.c
 
 ATMEL LCDFB DRIVER
 M:	Nicolas Ferre <nicolas.ferre@atmel.com>
@@ -1412,7 +1412,7 @@ M:	Sonic Zhang <sonic.zhang@analog.com>
 L:	uclinux-dist-devel@blackfin.uclinux.org
 W:	http://blackfin.uclinux.org
 S:	Supported
-F:	drivers/serial/bfin_5xx.c
+F:	drivers/tty/serial/bfin_5xx.c
 
 BLACKFIN WATCHDOG DRIVER
 M:	Mike Frysinger <vapier.adi@gmail.com>
@@ -1862,7 +1862,7 @@ L:	linux-cris-kernel@axis.com
 W:	http://developer.axis.com
 S:	Maintained
 F:	arch/cris/
-F:	drivers/serial/crisv10.*
+F:	drivers/tty/serial/crisv10.*
 
 CRYPTO API
 M:	Herbert Xu <herbert@gondor.apana.org.au>
@@ -2201,7 +2201,7 @@ F:	drivers/net/wan/dscc4.c
 DZ DECSTATION DZ11 SERIAL DRIVER
 M:	"Maciej W. Rozycki" <macro@linux-mips.org>
 S:	Maintained
-F:	drivers/serial/dz.*
+F:	drivers/tty/serial/dz.*
 
 EATA-DMA SCSI DRIVER
 M:	Michael Neuffer <mike@i-Connect.Net>
@@ -2621,7 +2621,7 @@ FREESCALE QUICC ENGINE UCC UART DRIVER
 M:	Timur Tabi <timur@freescale.com>
 L:	linuxppc-dev@lists.ozlabs.org
 S:	Supported
-F:	drivers/serial/ucc_uart.c
+F:	drivers/tty/serial/ucc_uart.c
 
 FREESCALE SOC SOUND DRIVERS
 M:	Timur Tabi <timur@freescale.com>
@@ -3328,7 +3328,7 @@ IOC3 SERIAL DRIVER
 M:	Pat Gefre <pfg@sgi.com>
 L:	linux-serial@vger.kernel.org
 S:	Maintained
-F:	drivers/serial/ioc3_serial.c
+F:	drivers/tty/serial/ioc3_serial.c
 
 IP MASQUERADING
 M:	Juanjo Ciarlante <jjciarla@raiz.uncu.edu.ar>
@@ -3505,7 +3505,7 @@ JSM Neo PCI based serial card
 M:	Breno Leitao <leitao@linux.vnet.ibm.com>
 L:	linux-serial@vger.kernel.org
 S:	Maintained
-F:	drivers/serial/jsm/
+F:	drivers/tty/serial/jsm/
 
 K8TEMP HARDWARE MONITORING DRIVER
 M:	Rudolf Marek <r.marek@assembler.cz>
@@ -3648,7 +3648,7 @@ L:	kgdb-bugreport@lists.sourceforge.net
 S:	Maintained
 F:	Documentation/DocBook/kgdb.tmpl
 F:	drivers/misc/kgdbts.c
-F:	drivers/serial/kgdboc.c
+F:	drivers/tty/serial/kgdboc.c
 F:	include/linux/kdb.h
 F:	include/linux/kgdb.h
 F:	kernel/debug/
@@ -5510,7 +5510,7 @@ M:	Pat Gefre <pfg@sgi.com>
 L:	linux-ia64@vger.kernel.org
 S:	Supported
 F:	Documentation/ia64/serial.txt
-F:	drivers/serial/ioc?_serial.c
+F:	drivers/tty/serial/ioc?_serial.c
 F:	include/linux/ioc?.h
 
 SGI VISUAL WORKSTATION 320 AND 540
@@ -5532,7 +5532,7 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	Documentation/arm/Sharp-LH/ADC-LH7-Touchscreen
 F:	arch/arm/mach-lh7a40x/
-F:	drivers/serial/serial_lh7a40x.c
+F:	drivers/tty/serial/serial_lh7a40x.c
 F:	drivers/usb/gadget/lh7a40*
 F:	drivers/usb/host/ohci-lh7a40*
 
@@ -5752,14 +5752,14 @@ L:	sparclinux@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-2.6.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-next-2.6.git
 S:	Maintained
-F:	drivers/serial/suncore.c
-F:	drivers/serial/suncore.h
-F:	drivers/serial/sunhv.c
-F:	drivers/serial/sunsab.c
-F:	drivers/serial/sunsab.h
-F:	drivers/serial/sunsu.c
-F:	drivers/serial/sunzilog.c
-F:	drivers/serial/sunzilog.h
+F:	drivers/tty/serial/suncore.c
+F:	drivers/tty/serial/suncore.h
+F:	drivers/tty/serial/sunhv.c
+F:	drivers/tty/serial/sunsab.c
+F:	drivers/tty/serial/sunsab.h
+F:	drivers/tty/serial/sunsu.c
+F:	drivers/tty/serial/sunzilog.c
+F:	drivers/tty/serial/sunzilog.h
 
 SPEAR PLATFORM SUPPORT
 M:	Viresh Kumar <viresh.kumar@st.com>
@@ -6089,8 +6089,8 @@ TTY LAYER
 M:	Greg Kroah-Hartman <gregkh@suse.de>
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty-2.6.git
-F:	drivers/char/tty_*
-F:	drivers/serial/serial_core.c
+F:	drivers/tty/*
+F:	drivers/tty/serial/serial_core.c
 F:	include/linux/serial_core.h
 F:	include/linux/serial.h
 F:	include/linux/tty.h
@@ -6829,7 +6829,7 @@ XILINX UARTLITE SERIAL DRIVER
 M:	Peter Korsgaard <jacmet@sunsite.dk>
 L:	linux-serial@vger.kernel.org
 S:	Maintained
-F:	drivers/serial/uartlite.c
+F:	drivers/tty/serial/uartlite.c
 
 YAM DRIVER FOR AX.25
 M:	Jean-Paul Roubelat <jpr@f6fbb.org>
@@ -6875,7 +6875,7 @@ F:	drivers/media/video/zoran/
 ZS DECSTATION Z85C30 SERIAL DRIVER
 M:	"Maciej W. Rozycki" <macro@linux-mips.org>
 S:	Maintained
-F:	drivers/serial/zs.*
+F:	drivers/tty/serial/zs.*
 
 GRE DEMULTIPLEXER DRIVER
 M:	Dmitry Kozlov <xeb@mail.ru>
-- 
1.7.1

