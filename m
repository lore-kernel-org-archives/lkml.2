Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab1DCQCv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 12:02:51 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48423 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab1DCQCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 12:02:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Ccz6KLojlw12A2pDjsNdU3ulTm0Ajliq7xUZUxfg1B3mjd/0IbsTE2LOeIzskKChWF
         tSZPFz98+EQD+bd5D3nxIRRfzEe9j44uhC/dL/cMcE1mRiUrRpLd+z3XK7KNIlhUkE8k
         6NBN2xLYhjxQaFy6+cg1Pt/7HF0UG4Tvntay4=
From: bookjovi@gmail.com
To: bookjovi@gmail.com, gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tty: remove invalid location line in file header
Date: Wed, 30 Mar 2011 05:30:41 -0400
Message-Id: <1301477441-2630-1-git-send-email-bookjovi@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jovi Zhang <bookjovi@gmail.com>

remove invalid location line in each file header after location
moved from driver/char to driver/tty

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
---
 drivers/tty/amiserial.c                     |    2 --
 drivers/tty/cyclades.c                      |    2 --
 drivers/tty/ipwireless/Makefile             |    2 --
 drivers/tty/pty.c                           |    2 --
 drivers/tty/serial/21285.c                  |    2 --
 drivers/tty/serial/8250.c                   |    2 --
 drivers/tty/serial/8250.h                   |    2 --
 drivers/tty/serial/8250_accent.c            |    2 --
 drivers/tty/serial/8250_boca.c              |    2 --
 drivers/tty/serial/8250_exar_st16c554.c     |    2 --
 drivers/tty/serial/8250_fourport.c          |    2 --
 drivers/tty/serial/8250_hub6.c              |    2 --
 drivers/tty/serial/8250_mca.c               |    2 --
 drivers/tty/serial/8250_pci.c               |    2 --
 drivers/tty/serial/8250_pnp.c               |    2 --
 drivers/tty/serial/amba-pl010.c             |    2 --
 drivers/tty/serial/amba-pl011.c             |    2 --
 drivers/tty/serial/atmel_serial.c           |    2 --
 drivers/tty/serial/clps711x.c               |    2 --
 drivers/tty/serial/cpm_uart/cpm_uart.h      |    2 --
 drivers/tty/serial/cpm_uart/cpm_uart_core.c |    2 --
 drivers/tty/serial/cpm_uart/cpm_uart_cpm1.c |    2 --
 drivers/tty/serial/cpm_uart/cpm_uart_cpm1.h |    2 --
 drivers/tty/serial/cpm_uart/cpm_uart_cpm2.c |    2 --
 drivers/tty/serial/cpm_uart/cpm_uart_cpm2.h |    2 --
 drivers/tty/serial/imx.c                    |    2 --
 drivers/tty/serial/msm_serial.c             |    2 +-
 drivers/tty/serial/msm_serial.h             |    2 --
 drivers/tty/serial/msm_smd_tty.c            |    3 +--
 drivers/tty/serial/netx-serial.c            |    2 --
 drivers/tty/serial/pmac_zilog.c             |    2 --
 drivers/tty/serial/pxa.c                    |    2 --
 drivers/tty/serial/s3c2400.c                |    3 +--
 drivers/tty/serial/s3c2410.c                |    3 +--
 drivers/tty/serial/s3c2412.c                |    3 +--
 drivers/tty/serial/s3c2440.c                |    3 +--
 drivers/tty/serial/s3c24a0.c                |    3 +--
 drivers/tty/serial/s3c6400.c                |    3 +--
 drivers/tty/serial/s5pv210.c                |    3 +--
 drivers/tty/serial/sa1100.c                 |    2 --
 drivers/tty/serial/samsung.c                |    3 +--
 drivers/tty/serial/samsung.h                |    3 +--
 drivers/tty/serial/sb1250-duart.c           |    2 --
 drivers/tty/serial/serial_core.c            |    2 --
 drivers/tty/serial/serial_ks8695.c          |    2 --
 drivers/tty/serial/serial_txx9.c            |    2 --
 drivers/tty/serial/sh-sci.c                 |    2 --
 drivers/tty/serial/vt8500_serial.c          |    2 --
 drivers/tty/synclink.c                      |    2 --
 drivers/tty/tty_io.c                        |    2 --
 drivers/tty/tty_ioctl.c                     |    2 --
 drivers/tty/tty_mutex.c                     |    3 ---
 drivers/tty/vt/keyboard.c                   |    2 --
 drivers/tty/vt/selection.c                  |    2 --
 drivers/tty/vt/vc_screen.c                  |    2 --
 drivers/tty/vt/vt.c                         |    2 --
 drivers/tty/vt/vt_ioctl.c                   |    2 --
 57 files changed, 11 insertions(+), 114 deletions(-)

diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index f214e50..2205795 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/char/amiserial.c
- *
  * Serial driver for the amiga builtin port.
  *
  * This code was created by taking serial.c version 4.30 from kernel
diff --git a/drivers/tty/cyclades.c b/drivers/tty/cyclades.c
index c99728f..ec81d64 100644
--- a/drivers/tty/cyclades.c
+++ b/drivers/tty/cyclades.c
@@ -3,8 +3,6 @@
 #undef	Z_EXT_CHARS_IN_BUFFER
 
 /*
- *  linux/drivers/char/cyclades.c
- *
  * This file contains the driver for the Cyclades async multiport
  * serial boards.
  *
diff --git a/drivers/tty/ipwireless/Makefile b/drivers/tty/ipwireless/Makefile
index db80873..fe2e173 100644
--- a/drivers/tty/ipwireless/Makefile
+++ b/drivers/tty/ipwireless/Makefile
@@ -1,6 +1,4 @@
 #
-# drivers/char/pcmcia/ipwireless/Makefile
-#
 # Makefile for the IPWireless driver
 #
 
diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 2107747..a7f1d7f 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/char/pty.c
- *
  *  Copyright (C) 1991, 1992  Linus Torvalds
  *
  *  Added support for a Unix98-style ptmx device.
diff --git a/drivers/tty/serial/21285.c b/drivers/tty/serial/21285.c
index d89aa38..1b37626 100644
--- a/drivers/tty/serial/21285.c
+++ b/drivers/tty/serial/21285.c
@@ -1,6 +1,4 @@
 /*
- * linux/drivers/serial/21285.c
- *
  * Driver for the serial port on the 21285 StrongArm-110 core logic chip.
  *
  * Based on drivers/char/serial.c
diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index b3b881b..20c527c 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/char/8250.c
- *
  *  Driver for 8250/16550-type serial ports
  *
  *  Based on drivers/char/serial.c, by Linus Torvalds, Theodore Ts'o.
diff --git a/drivers/tty/serial/8250.h b/drivers/tty/serial/8250.h
index 6e19ea3..d13b586 100644
--- a/drivers/tty/serial/8250.h
+++ b/drivers/tty/serial/8250.h
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/char/8250.h
- *
  *  Driver for 8250/16550-type serial ports
  *
  *  Based on drivers/char/serial.c, by Linus Torvalds, Theodore Ts'o.
diff --git a/drivers/tty/serial/8250_accent.c b/drivers/tty/serial/8250_accent.c
index 9c10262..34b51c6 100644
--- a/drivers/tty/serial/8250_accent.c
+++ b/drivers/tty/serial/8250_accent.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/serial/8250_accent.c
- *
  *  Copyright (C) 2005 Russell King.
  *  Data taken from include/asm-i386/serial.h
  *
diff --git a/drivers/tty/serial/8250_boca.c b/drivers/tty/serial/8250_boca.c
index 3bfe0f7..d125dc1 100644
--- a/drivers/tty/serial/8250_boca.c
+++ b/drivers/tty/serial/8250_boca.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/serial/8250_boca.c
- *
  *  Copyright (C) 2005 Russell King.
  *  Data taken from include/asm-i386/serial.h
  *
diff --git a/drivers/tty/serial/8250_exar_st16c554.c b/drivers/tty/serial/8250_exar_st16c554.c
index 567143a..bf53aab 100644
--- a/drivers/tty/serial/8250_exar_st16c554.c
+++ b/drivers/tty/serial/8250_exar_st16c554.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/serial/8250_exar.c
- *
  *  Written by Paul B Schroeder < pschroeder "at" uplogix "dot" com >
  *  Based on 8250_boca.
  *
diff --git a/drivers/tty/serial/8250_fourport.c b/drivers/tty/serial/8250_fourport.c
index 6375d68..be15826 100644
--- a/drivers/tty/serial/8250_fourport.c
+++ b/drivers/tty/serial/8250_fourport.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/serial/8250_fourport.c
- *
  *  Copyright (C) 2005 Russell King.
  *  Data taken from include/asm-i386/serial.h
  *
diff --git a/drivers/tty/serial/8250_hub6.c b/drivers/tty/serial/8250_hub6.c
index 7609150..a5c778e 100644
--- a/drivers/tty/serial/8250_hub6.c
+++ b/drivers/tty/serial/8250_hub6.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/serial/8250_hub6.c
- *
  *  Copyright (C) 2005 Russell King.
  *  Data taken from include/asm-i386/serial.h
  *
diff --git a/drivers/tty/serial/8250_mca.c b/drivers/tty/serial/8250_mca.c
index d10be94..d20abf0 100644
--- a/drivers/tty/serial/8250_mca.c
+++ b/drivers/tty/serial/8250_mca.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/serial/8250_mca.c
- *
  *  Copyright (C) 2005 Russell King.
  *  Data taken from include/asm-i386/serial.h
  *
diff --git a/drivers/tty/serial/8250_pci.c b/drivers/tty/serial/8250_pci.c
index 8b8930f..98a7313 100644
--- a/drivers/tty/serial/8250_pci.c
+++ b/drivers/tty/serial/8250_pci.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/char/8250_pci.c
- *
  *  Probe module for 8250/16550-type PCI serial ports.
  *
  *  Based on drivers/char/serial.c, by Linus Torvalds, Theodore Ts'o.
diff --git a/drivers/tty/serial/8250_pnp.c b/drivers/tty/serial/8250_pnp.c
index 4822cb5..fc301f6 100644
--- a/drivers/tty/serial/8250_pnp.c
+++ b/drivers/tty/serial/8250_pnp.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/char/8250_pnp.c
- *
  *  Probe module for 8250/16550-type ISAPNP serial ports.
  *
  *  Based on drivers/char/serial.c, by Linus Torvalds, Theodore Ts'o.
diff --git a/drivers/tty/serial/amba-pl010.c b/drivers/tty/serial/amba-pl010.c
index d742dd2..c0d10c4 100644
--- a/drivers/tty/serial/amba-pl010.c
+++ b/drivers/tty/serial/amba-pl010.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/char/amba.c
- *
  *  Driver for AMBA serial ports
  *
  *  Based on drivers/char/serial.c, by Linus Torvalds, Theodore Ts'o.
diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 57731e8..ac34fb0 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/char/amba.c
- *
  *  Driver for AMBA serial ports
  *
  *  Based on drivers/char/serial.c, by Linus Torvalds, Theodore Ts'o.
diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index f119d17..652bdac 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/char/atmel_serial.c
- *
  *  Driver for Atmel AT91 / AT32 Serial ports
  *  Copyright (C) 2003 Rick Bronson
  *
diff --git a/drivers/tty/serial/clps711x.c b/drivers/tty/serial/clps711x.c
index b6acd19..e6c3dbd 100644
--- a/drivers/tty/serial/clps711x.c
+++ b/drivers/tty/serial/clps711x.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/char/clps711x.c
- *
  *  Driver for CLPS711x serial ports
  *
  *  Based on drivers/char/serial.c, by Linus Torvalds, Theodore Ts'o.
diff --git a/drivers/tty/serial/cpm_uart/cpm_uart.h b/drivers/tty/serial/cpm_uart/cpm_uart.h
index b754dcf..cf34d26 100644
--- a/drivers/tty/serial/cpm_uart/cpm_uart.h
+++ b/drivers/tty/serial/cpm_uart/cpm_uart.h
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/serial/cpm_uart.h
- *
  *  Driver for CPM (SCC/SMC) serial ports
  *
  *  Copyright (C) 2004 Freescale Semiconductor, Inc.
diff --git a/drivers/tty/serial/cpm_uart/cpm_uart_core.c b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
index a9a6a5f..9488da7 100644
--- a/drivers/tty/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/serial/cpm_uart.c
- *
  *  Driver for CPM (SCC/SMC) serial ports; core driver
  *
  *  Based on arch/ppc/cpm2_io/uart.c by Dan Malek
diff --git a/drivers/tty/serial/cpm_uart/cpm_uart_cpm1.c b/drivers/tty/serial/cpm_uart/cpm_uart_cpm1.c
index 3fc1d66..18f7957 100644
--- a/drivers/tty/serial/cpm_uart/cpm_uart_cpm1.c
+++ b/drivers/tty/serial/cpm_uart/cpm_uart_cpm1.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/serial/cpm_uart.c
- *
  *  Driver for CPM (SCC/SMC) serial ports; CPM1 definitions
  *
  *  Maintainer: Kumar Gala (galak@kernel.crashing.org) (CPM2)
diff --git a/drivers/tty/serial/cpm_uart/cpm_uart_cpm1.h b/drivers/tty/serial/cpm_uart/cpm_uart_cpm1.h
index 10eecd6..60c7e94 100644
--- a/drivers/tty/serial/cpm_uart/cpm_uart_cpm1.h
+++ b/drivers/tty/serial/cpm_uart/cpm_uart_cpm1.h
@@ -1,6 +1,4 @@
 /*
- * linux/drivers/serial/cpm_uart/cpm_uart_cpm1.h
- *
  * Driver for CPM (SCC/SMC) serial ports
  *
  * definitions for cpm1
diff --git a/drivers/tty/serial/cpm_uart/cpm_uart_cpm2.c b/drivers/tty/serial/cpm_uart/cpm_uart_cpm2.c
index 814ac00..a4927e6 100644
--- a/drivers/tty/serial/cpm_uart/cpm_uart_cpm2.c
+++ b/drivers/tty/serial/cpm_uart/cpm_uart_cpm2.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/serial/cpm_uart_cpm2.c
- *
  *  Driver for CPM (SCC/SMC) serial ports; CPM2 definitions
  *
  *  Maintainer: Kumar Gala (galak@kernel.crashing.org) (CPM2)
diff --git a/drivers/tty/serial/cpm_uart/cpm_uart_cpm2.h b/drivers/tty/serial/cpm_uart/cpm_uart_cpm2.h
index 7194c63..51e651a 100644
--- a/drivers/tty/serial/cpm_uart/cpm_uart_cpm2.h
+++ b/drivers/tty/serial/cpm_uart/cpm_uart_cpm2.h
@@ -1,6 +1,4 @@
 /*
- * linux/drivers/serial/cpm_uart/cpm_uart_cpm2.h
- *
  * Driver for CPM (SCC/SMC) serial ports
  *
  * definitions for cpm2
diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index dfcf4b1..14a4e74 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/serial/imx.c
- *
  *  Driver for Motorola IMX serial ports
  *
  *  Based on drivers/char/serial.c, by Linus Torvalds, Theodore Ts'o.
diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index bfee9b4..e6ba838 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -1,5 +1,5 @@
 /*
- * drivers/serial/msm_serial.c - driver for msm7k serial device and console
+ * Driver for msm7k serial device and console
  *
  * Copyright (C) 2007 Google, Inc.
  * Author: Robert Love <rlove@google.com>
diff --git a/drivers/tty/serial/msm_serial.h b/drivers/tty/serial/msm_serial.h
index 9b8dc5d..e4acef5 100644
--- a/drivers/tty/serial/msm_serial.h
+++ b/drivers/tty/serial/msm_serial.h
@@ -1,6 +1,4 @@
 /*
- * drivers/serial/msm_serial.h
- *
  * Copyright (C) 2007 Google, Inc.
  * Author: Robert Love <rlove@google.com>
  * Copyright (c) 2011, Code Aurora Forum. All rights reserved.
diff --git a/drivers/tty/serial/msm_smd_tty.c b/drivers/tty/serial/msm_smd_tty.c
index beeff1e..4f41dcd 100644
--- a/drivers/tty/serial/msm_smd_tty.c
+++ b/drivers/tty/serial/msm_smd_tty.c
@@ -1,5 +1,4 @@
-/* drivers/tty/serial/msm_smd_tty.c
- *
+/*
  * Copyright (C) 2007 Google, Inc.
  * Copyright (c) 2011, Code Aurora Forum. All rights reserved.
  * Author: Brian Swetland <swetland@google.com>
diff --git a/drivers/tty/serial/netx-serial.c b/drivers/tty/serial/netx-serial.c
index 7735c9f..d40da78 100644
--- a/drivers/tty/serial/netx-serial.c
+++ b/drivers/tty/serial/netx-serial.c
@@ -1,6 +1,4 @@
 /*
- * drivers/serial/netx-serial.c
- *
  * Copyright (c) 2005 Sascha Hauer <s.hauer@pengutronix.de>, Pengutronix
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/tty/serial/pmac_zilog.c b/drivers/tty/serial/pmac_zilog.c
index 5b9cde7..e4c60b2 100644
--- a/drivers/tty/serial/pmac_zilog.c
+++ b/drivers/tty/serial/pmac_zilog.c
@@ -1,6 +1,4 @@
 /*
- * linux/drivers/serial/pmac_zilog.c
- * 
  * Driver for PowerMac Z85c30 based ESCC cell found in the
  * "macio" ASICs of various PowerMac models
  * 
diff --git a/drivers/tty/serial/pxa.c b/drivers/tty/serial/pxa.c
index 1102a39..4302e6e 100644
--- a/drivers/tty/serial/pxa.c
+++ b/drivers/tty/serial/pxa.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/serial/pxa.c
- *
  *  Based on drivers/serial/8250.c by Russell King.
  *
  *  Author:	Nicolas Pitre
diff --git a/drivers/tty/serial/s3c2400.c b/drivers/tty/serial/s3c2400.c
index fed1a9a..d13051b 100644
--- a/drivers/tty/serial/s3c2400.c
+++ b/drivers/tty/serial/s3c2400.c
@@ -1,5 +1,4 @@
-/* linux/drivers/serial/s3c240.c
- *
+/*
  * Driver for Samsung SoC onboard UARTs.
  *
  * Ben Dooks, Copyright (c) 2003-2005 Simtec Electronics
diff --git a/drivers/tty/serial/s3c2410.c b/drivers/tty/serial/s3c2410.c
index 73f089d..bffe6ff 100644
--- a/drivers/tty/serial/s3c2410.c
+++ b/drivers/tty/serial/s3c2410.c
@@ -1,5 +1,4 @@
-/* linux/drivers/serial/s3c2410.c
- *
+/*
  * Driver for Samsung S3C2410 SoC onboard UARTs.
  *
  * Ben Dooks, Copyright (c) 2003-2008 Simtec Electronics
diff --git a/drivers/tty/serial/s3c2412.c b/drivers/tty/serial/s3c2412.c
index 1700b1a..7e2b950 100644
--- a/drivers/tty/serial/s3c2412.c
+++ b/drivers/tty/serial/s3c2412.c
@@ -1,5 +1,4 @@
-/* linux/drivers/serial/s3c2412.c
- *
+/*
  * Driver for Samsung S3C2412 and S3C2413 SoC onboard UARTs.
  *
  * Ben Dooks, Copyright (c) 2003-2008 Simtec Electronics
diff --git a/drivers/tty/serial/s3c2440.c b/drivers/tty/serial/s3c2440.c
index 094cc39..9e10d41 100644
--- a/drivers/tty/serial/s3c2440.c
+++ b/drivers/tty/serial/s3c2440.c
@@ -1,5 +1,4 @@
-/* linux/drivers/serial/s3c2440.c
- *
+/*
  * Driver for Samsung S3C2440 and S3C2442 SoC onboard UARTs.
  *
  * Ben Dooks, Copyright (c) 2003-2008 Simtec Electronics
diff --git a/drivers/tty/serial/s3c24a0.c b/drivers/tty/serial/s3c24a0.c
index fad6083..914eff2 100644
--- a/drivers/tty/serial/s3c24a0.c
+++ b/drivers/tty/serial/s3c24a0.c
@@ -1,5 +1,4 @@
-/* linux/drivers/serial/s3c24a0.c
- *
+/*
  * Driver for Samsung S3C24A0 SoC onboard UARTs.
  *
  * Based on drivers/serial/s3c2410.c
diff --git a/drivers/tty/serial/s3c6400.c b/drivers/tty/serial/s3c6400.c
index 4be92ab..ded26c4 100644
--- a/drivers/tty/serial/s3c6400.c
+++ b/drivers/tty/serial/s3c6400.c
@@ -1,5 +1,4 @@
-/* linux/drivers/serial/s3c6400.c
- *
+/*
  * Driver for Samsung S3C6400 and S3C6410 SoC onboard UARTs.
  *
  * Copyright 2008 Openmoko,  Inc.
diff --git a/drivers/tty/serial/s5pv210.c b/drivers/tty/serial/s5pv210.c
index 6ebccd7..fb2619f 100644
--- a/drivers/tty/serial/s5pv210.c
+++ b/drivers/tty/serial/s5pv210.c
@@ -1,5 +1,4 @@
-/* linux/drivers/serial/s5pv210.c
- *
+/*
  * Copyright (c) 2010 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com/
  *
diff --git a/drivers/tty/serial/sa1100.c b/drivers/tty/serial/sa1100.c
index 2199d81..ef7a21a 100644
--- a/drivers/tty/serial/sa1100.c
+++ b/drivers/tty/serial/sa1100.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/char/sa1100.c
- *
  *  Driver for SA11x0 serial ports
  *
  *  Based on drivers/char/serial.c, by Linus Torvalds, Theodore Ts'o.
diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index 2335eda..b73cb42 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -1,5 +1,4 @@
-/* linux/drivers/serial/samsuing.c
- *
+/*
  * Driver core for Samsung SoC onboard UARTs.
  *
  * Ben Dooks, Copyright (c) 2003-2008 Simtec Electronics
diff --git a/drivers/tty/serial/samsung.h b/drivers/tty/serial/samsung.h
index 0ac06a0..5b098cd 100644
--- a/drivers/tty/serial/samsung.h
+++ b/drivers/tty/serial/samsung.h
@@ -1,5 +1,4 @@
-/* linux/drivers/serial/samsung.h
- *
+/*
  * Driver for Samsung SoC onboard UARTs.
  *
  * Ben Dooks, Copyright (c) 2003-2008 Simtec Electronics
diff --git a/drivers/tty/serial/sb1250-duart.c b/drivers/tty/serial/sb1250-duart.c
index 602d984..ea2340b 100644
--- a/drivers/tty/serial/sb1250-duart.c
+++ b/drivers/tty/serial/sb1250-duart.c
@@ -1,6 +1,4 @@
 /*
- *	drivers/serial/sb1250-duart.c
- *
  *	Support for the asynchronous serial interface (DUART) included
  *	in the BCM1250 and derived System-On-a-Chip (SOC) devices.
  *
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 733fe8e..e9cd75e 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/char/core.c
- *
  *  Driver core for serial ports
  *
  *  Based on drivers/char/serial.c, by Linus Torvalds, Theodore Ts'o.
diff --git a/drivers/tty/serial/serial_ks8695.c b/drivers/tty/serial/serial_ks8695.c
index b196202..2430319 100644
--- a/drivers/tty/serial/serial_ks8695.c
+++ b/drivers/tty/serial/serial_ks8695.c
@@ -1,6 +1,4 @@
 /*
- *  drivers/serial/serial_ks8695.c
- *
  *  Driver for KS8695 serial ports
  *
  *  Based on drivers/serial/serial_amba.c, by Kam Lee.
diff --git a/drivers/tty/serial/serial_txx9.c b/drivers/tty/serial/serial_txx9.c
index c50e9fb..8e3fc19 100644
--- a/drivers/tty/serial/serial_txx9.c
+++ b/drivers/tty/serial/serial_txx9.c
@@ -1,6 +1,4 @@
 /*
- *  drivers/serial/serial_txx9.c
- *
  * Derived from many drivers using generic_serial interface,
  * especially serial_tx3912.c by Steven J. Hill and r39xx_serial.c
  * (was in Linux/VR tree) by Jim Pick.
diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index eb7958c..e20ecb7 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -1,6 +1,4 @@
 /*
- * drivers/serial/sh-sci.c
- *
  * SuperH on-chip serial module support.  (SCI with no FIFO / with FIFO)
  *
  *  Copyright (C) 2002 - 2011  Paul Mundt
diff --git a/drivers/tty/serial/vt8500_serial.c b/drivers/tty/serial/vt8500_serial.c
index 322bf56..37fc4e3 100644
--- a/drivers/tty/serial/vt8500_serial.c
+++ b/drivers/tty/serial/vt8500_serial.c
@@ -1,6 +1,4 @@
 /*
- * drivers/serial/vt8500_serial.c
- *
  * Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
  *
  * Based on msm_serial.c, which is:
diff --git a/drivers/tty/synclink.c b/drivers/tty/synclink.c
index 18888d0..25d52ff 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -1,6 +1,4 @@
 /*
- * linux/drivers/char/synclink.c
- *
  * $Id: synclink.c,v 4.38 2005/11/07 16:30:34 paulkf Exp $
  *
  * Device driver for Microgate SyncLink ISA and PCI
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 936a4ea..bb70252 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/char/tty_io.c
- *
  *  Copyright (C) 1991, 1992  Linus Torvalds
  */
 
diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index 1a1135d..18b2cb7 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/char/tty_ioctl.c
- *
  *  Copyright (C) 1991, 1992, 1993, 1994  Linus Torvalds
  *
  * Modified by Fred N. van Kempen, 01/29/93, to add line disciplines
diff --git a/drivers/tty/tty_mutex.c b/drivers/tty/tty_mutex.c
index 1336975..3b2bb77 100644
--- a/drivers/tty/tty_mutex.c
+++ b/drivers/tty/tty_mutex.c
@@ -1,6 +1,3 @@
-/*
- * drivers/char/tty_lock.c
- */
 #include <linux/tty.h>
 #include <linux/module.h>
 #include <linux/kallsyms.h>
diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index d6b342b..3761ccf 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -1,6 +1,4 @@
 /*
- * linux/drivers/char/keyboard.c
- *
  * Written for linux by Johan Myreen as a translation from
  * the assembly version by Linus (with diacriticals added)
  *
diff --git a/drivers/tty/vt/selection.c b/drivers/tty/vt/selection.c
index adf0ad2..fb864e7 100644
--- a/drivers/tty/vt/selection.c
+++ b/drivers/tty/vt/selection.c
@@ -1,6 +1,4 @@
 /*
- * linux/drivers/char/selection.c
- *
  * This module exports the functions:
  *
  *     'int set_selection(struct tiocl_selection __user *, struct tty_struct *)'
diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
index 1564261..66825c9 100644
--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -1,6 +1,4 @@
 /*
- * linux/drivers/char/vc_screen.c
- *
  * Provide access to virtual console memory.
  * /dev/vcs0: the screen as it is being viewed right now (possibly scrolled)
  * /dev/vcsN: the screen of /dev/ttyN (1 <= N <= 63)
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index c83cdfb..f3f5838 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/char/vt.c
- *
  *  Copyright (C) 1991, 1992  Linus Torvalds
  */
 
diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index 937d172..5132c4c 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -1,6 +1,4 @@
 /*
- *  linux/drivers/char/vt_ioctl.c
- *
  *  Copyright (C) 1992 obz under the linux copyright
  *
  *  Dynamic diacritical handling - aeb@cwi.nl - Dec 1993
-- 
1.7.2.3

