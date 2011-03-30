Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798Ab1DCJ6d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 05:58:33 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45738 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab1DCJ6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 05:58:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jjre3SoaaTXKMJPcefGK5xdhi6ntrh1IvqAAnGgIHA1oeDBjRcT/tdLPZowHCDM1Ek
         shGB/3rDbGzs2JA0qXjj8Z0w9ngfH/L+QHxrLVveVjBLFYTqa//W50uKzezFzrtalNGp
         dJIofPG1uuEQlDgqrlpgnOm63+ATUbXGHqsZw=
From: bookjovi@gmail.com
To: bookjovi@gmail.com, gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tty: update file header info correctly
Date: Tue, 29 Mar 2011 23:29:13 -0400
Message-Id: <1301455753-2866-1-git-send-email-bookjovi@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jovi Zhang <bookjovi@gmail.com>

After some files changed location from drivers/char to driver/tty,
file header info also need to update

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
---
 drivers/tty/amiserial.c                     |    2 +-
 drivers/tty/cyclades.c                      |    2 +-
 drivers/tty/ipwireless/Makefile             |    2 +-
 drivers/tty/pty.c                           |    2 +-
 drivers/tty/serial/21285.c                  |    2 +-
 drivers/tty/serial/8250.c                   |    2 +-
 drivers/tty/serial/8250.h                   |    2 +-
 drivers/tty/serial/8250_accent.c            |    2 +-
 drivers/tty/serial/8250_acorn.c             |    2 +-
 drivers/tty/serial/8250_exar_st16c554.c     |    2 +-
 drivers/tty/serial/8250_fourport.c          |    2 +-
 drivers/tty/serial/8250_hub6.c              |    2 +-
 drivers/tty/serial/8250_mca.c               |    2 +-
 drivers/tty/serial/8250_pci.c               |    2 +-
 drivers/tty/serial/8250_pnp.c               |    2 +-
 drivers/tty/serial/amba-pl010.c             |    2 +-
 drivers/tty/serial/amba-pl011.c             |    2 +-
 drivers/tty/serial/atmel_serial.c           |    2 +-
 drivers/tty/serial/clps711x.c               |    2 +-
 drivers/tty/serial/cpm_uart/cpm_uart.h      |    2 +-
 drivers/tty/serial/cpm_uart/cpm_uart_core.c |    2 +-
 drivers/tty/serial/cpm_uart/cpm_uart_cpm1.c |    2 +-
 drivers/tty/serial/cpm_uart/cpm_uart_cpm1.h |    2 +-
 drivers/tty/serial/cpm_uart/cpm_uart_cpm2.c |    2 +-
 drivers/tty/serial/cpm_uart/cpm_uart_cpm2.h |    2 +-
 drivers/tty/serial/imx.c                    |    2 +-
 drivers/tty/serial/msm_serial.c             |    2 +-
 drivers/tty/serial/msm_serial.h             |    2 +-
 drivers/tty/serial/netx-serial.c            |    2 +-
 drivers/tty/serial/pmac_zilog.c             |    2 +-
 drivers/tty/serial/pxa.c                    |    2 +-
 drivers/tty/serial/s3c2400.c                |    2 +-
 drivers/tty/serial/s3c2410.c                |    2 +-
 drivers/tty/serial/s3c2412.c                |    2 +-
 drivers/tty/serial/s3c2440.c                |    2 +-
 drivers/tty/serial/s3c24a0.c                |    2 +-
 drivers/tty/serial/s3c6400.c                |    2 +-
 drivers/tty/serial/s5pv210.c                |    2 +-
 drivers/tty/serial/sa1100.c                 |    2 +-
 drivers/tty/serial/samsung.c                |    2 +-
 drivers/tty/serial/samsung.h                |    2 +-
 drivers/tty/serial/sb1250-duart.c           |    2 +-
 drivers/tty/serial/serial_core.c            |    2 +-
 drivers/tty/serial/serial_ks8695.c          |    2 +-
 drivers/tty/serial/serial_txx9.c            |    2 +-
 drivers/tty/serial/sh-sci.c                 |    2 +-
 drivers/tty/serial/vt8500_serial.c          |    2 +-
 drivers/tty/synclink.c                      |    2 +-
 drivers/tty/tty_io.c                        |    2 +-
 drivers/tty/tty_ioctl.c                     |    2 +-
 drivers/tty/tty_mutex.c                     |    2 +-
 drivers/tty/vt/keyboard.c                   |    2 +-
 drivers/tty/vt/selection.c                  |    2 +-
 drivers/tty/vt/vc_screen.c                  |    2 +-
 drivers/tty/vt/vt.c                         |    2 +-
 drivers/tty/vt/vt_ioctl.c                   |    2 +-
 56 files changed, 56 insertions(+), 56 deletions(-)

diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index f214e50..90c7a12 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/char/amiserial.c
+ *  linux/drivers/tty/amiserial.c
  *
  * Serial driver for the amiga builtin port.
  *
diff --git a/drivers/tty/cyclades.c b/drivers/tty/cyclades.c
index c99728f..dfd5f6e 100644
--- a/drivers/tty/cyclades.c
+++ b/drivers/tty/cyclades.c
@@ -3,7 +3,7 @@
 #undef	Z_EXT_CHARS_IN_BUFFER
 
 /*
- *  linux/drivers/char/cyclades.c
+ *  linux/drivers/tty/cyclades.c
  *
  * This file contains the driver for the Cyclades async multiport
  * serial boards.
diff --git a/drivers/tty/ipwireless/Makefile b/drivers/tty/ipwireless/Makefile
index db80873..7f8e217 100644
--- a/drivers/tty/ipwireless/Makefile
+++ b/drivers/tty/ipwireless/Makefile
@@ -1,5 +1,5 @@
 #
-# drivers/char/pcmcia/ipwireless/Makefile
+# drivers/tty/ipwireless/Makefile
 #
 # Makefile for the IPWireless driver
 #
diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 2107747..2661426 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/char/pty.c
+ *  linux/drivers/tty/pty.c
  *
  *  Copyright (C) 1991, 1992  Linus Torvalds
  *
diff --git a/drivers/tty/serial/21285.c b/drivers/tty/serial/21285.c
index d89aa38..e5fee2a 100644
--- a/drivers/tty/serial/21285.c
+++ b/drivers/tty/serial/21285.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/serial/21285.c
+ * linux/drivers/tty/serial/21285.c
  *
  * Driver for the serial port on the 21285 StrongArm-110 core logic chip.
  *
diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index b3b881b..94609b4 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/char/8250.c
+ *  linux/drivers/tty/serial/8250.c
  *
  *  Driver for 8250/16550-type serial ports
  *
diff --git a/drivers/tty/serial/8250.h b/drivers/tty/serial/8250.h
index 6e19ea3..1afce7c 100644
--- a/drivers/tty/serial/8250.h
+++ b/drivers/tty/serial/8250.h
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/char/8250.h
+ *  linux/drivers/tty/serial/8250.h
  *
  *  Driver for 8250/16550-type serial ports
  *
diff --git a/drivers/tty/serial/8250_accent.c b/drivers/tty/serial/8250_accent.c
index 9c10262..429ff68 100644
--- a/drivers/tty/serial/8250_accent.c
+++ b/drivers/tty/serial/8250_accent.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/serial/8250_accent.c
+ *  linux/drivers/tty/serial/8250_accent.c
  *
  *  Copyright (C) 2005 Russell King.
  *  Data taken from include/asm-i386/serial.h
diff --git a/drivers/tty/serial/8250_acorn.c b/drivers/tty/serial/8250_acorn.c
index b0ce8c5..81dd07b 100644
--- a/drivers/tty/serial/8250_acorn.c
+++ b/drivers/tty/serial/8250_acorn.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/serial/acorn.c
+ *  linux/drivers/tty/serial/acorn.c
  *
  *  Copyright (C) 1996-2003 Russell King.
  *
diff --git a/drivers/tty/serial/8250_exar_st16c554.c b/drivers/tty/serial/8250_exar_st16c554.c
index 567143a..2be8557 100644
--- a/drivers/tty/serial/8250_exar_st16c554.c
+++ b/drivers/tty/serial/8250_exar_st16c554.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/serial/8250_exar.c
+ *  linux/drivers/tty/serial/8250_exar_st16c554.c
  *
  *  Written by Paul B Schroeder < pschroeder "at" uplogix "dot" com >
  *  Based on 8250_boca.
diff --git a/drivers/tty/serial/8250_fourport.c b/drivers/tty/serial/8250_fourport.c
index 6375d68..ff401e7 100644
--- a/drivers/tty/serial/8250_fourport.c
+++ b/drivers/tty/serial/8250_fourport.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/serial/8250_fourport.c
+ *  linux/drivers/tty/serial/8250_fourport.c
  *
  *  Copyright (C) 2005 Russell King.
  *  Data taken from include/asm-i386/serial.h
diff --git a/drivers/tty/serial/8250_hub6.c b/drivers/tty/serial/8250_hub6.c
index 7609150..492fe54 100644
--- a/drivers/tty/serial/8250_hub6.c
+++ b/drivers/tty/serial/8250_hub6.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/serial/8250_hub6.c
+ *  linux/drivers/tty/serial/8250_hub6.c
  *
  *  Copyright (C) 2005 Russell King.
  *  Data taken from include/asm-i386/serial.h
diff --git a/drivers/tty/serial/8250_mca.c b/drivers/tty/serial/8250_mca.c
index d10be94..2c3a8b2 100644
--- a/drivers/tty/serial/8250_mca.c
+++ b/drivers/tty/serial/8250_mca.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/serial/8250_mca.c
+ *  linux/drivers/tty/serial/8250_mca.c
  *
  *  Copyright (C) 2005 Russell King.
  *  Data taken from include/asm-i386/serial.h
diff --git a/drivers/tty/serial/8250_pci.c b/drivers/tty/serial/8250_pci.c
index 8b8930f..afc14f4 100644
--- a/drivers/tty/serial/8250_pci.c
+++ b/drivers/tty/serial/8250_pci.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/char/8250_pci.c
+ *  linux/drivers/tty/serial/8250_pci.c
  *
  *  Probe module for 8250/16550-type PCI serial ports.
  *
diff --git a/drivers/tty/serial/8250_pnp.c b/drivers/tty/serial/8250_pnp.c
index 4822cb5..be5f04d 100644
--- a/drivers/tty/serial/8250_pnp.c
+++ b/drivers/tty/serial/8250_pnp.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/char/8250_pnp.c
+ *  linux/drivers/tty/serial/8250_pnp.c
  *
  *  Probe module for 8250/16550-type ISAPNP serial ports.
  *
diff --git a/drivers/tty/serial/amba-pl010.c b/drivers/tty/serial/amba-pl010.c
index d742dd2..5ff62eb 100644
--- a/drivers/tty/serial/amba-pl010.c
+++ b/drivers/tty/serial/amba-pl010.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/char/amba.c
+ *  linux/drivers/tty/serial/amba-pl010.c
  *
  *  Driver for AMBA serial ports
  *
diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 57731e8..4160efd 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/char/amba.c
+ *  linux/drivers/tty/serial/amba-pl011.c
  *
  *  Driver for AMBA serial ports
  *
diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index f119d17..73400ab 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/char/atmel_serial.c
+ *  linux/drivers/tty/serial/atmel_serial.c
  *
  *  Driver for Atmel AT91 / AT32 Serial ports
  *  Copyright (C) 2003 Rick Bronson
diff --git a/drivers/tty/serial/clps711x.c b/drivers/tty/serial/clps711x.c
index b6acd19..ce3c928 100644
--- a/drivers/tty/serial/clps711x.c
+++ b/drivers/tty/serial/clps711x.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/char/clps711x.c
+ *  linux/drivers/tty/serial/clps711x.c
  *
  *  Driver for CLPS711x serial ports
  *
diff --git a/drivers/tty/serial/cpm_uart/cpm_uart.h b/drivers/tty/serial/cpm_uart/cpm_uart.h
index b754dcf..f3bca5f 100644
--- a/drivers/tty/serial/cpm_uart/cpm_uart.h
+++ b/drivers/tty/serial/cpm_uart/cpm_uart.h
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/serial/cpm_uart.h
+ *  linux/drivers/tty/serial/cpm_uart/cpm_uart.h
  *
  *  Driver for CPM (SCC/SMC) serial ports
  *
diff --git a/drivers/tty/serial/cpm_uart/cpm_uart_core.c b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
index a9a6a5f..52f0e27 100644
--- a/drivers/tty/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/serial/cpm_uart.c
+ *  linux/drivers/tty/serial/cpm_uart/cpm_uart_core.c
  *
  *  Driver for CPM (SCC/SMC) serial ports; core driver
  *
diff --git a/drivers/tty/serial/cpm_uart/cpm_uart_cpm1.c b/drivers/tty/serial/cpm_uart/cpm_uart_cpm1.c
index 3fc1d66..88f1fc7 100644
--- a/drivers/tty/serial/cpm_uart/cpm_uart_cpm1.c
+++ b/drivers/tty/serial/cpm_uart/cpm_uart_cpm1.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/serial/cpm_uart.c
+ *  linux/drivers/tty/serial/cpm_uart/cpm_uart_cpm1.c
  *
  *  Driver for CPM (SCC/SMC) serial ports; CPM1 definitions
  *
diff --git a/drivers/tty/serial/cpm_uart/cpm_uart_cpm1.h b/drivers/tty/serial/cpm_uart/cpm_uart_cpm1.h
index 10eecd6..053a0d6 100644
--- a/drivers/tty/serial/cpm_uart/cpm_uart_cpm1.h
+++ b/drivers/tty/serial/cpm_uart/cpm_uart_cpm1.h
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/serial/cpm_uart/cpm_uart_cpm1.h
+ * linux/drivers/tty/serial/cpm_uart/cpm_uart_cpm1.h
  *
  * Driver for CPM (SCC/SMC) serial ports
  *
diff --git a/drivers/tty/serial/cpm_uart/cpm_uart_cpm2.c b/drivers/tty/serial/cpm_uart/cpm_uart_cpm2.c
index 814ac00..eb896c4 100644
--- a/drivers/tty/serial/cpm_uart/cpm_uart_cpm2.c
+++ b/drivers/tty/serial/cpm_uart/cpm_uart_cpm2.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/serial/cpm_uart_cpm2.c
+ *  linux/drivers/tty/serial/cpm_uart/cpm_uart_cpm2.c
  *
  *  Driver for CPM (SCC/SMC) serial ports; CPM2 definitions
  *
diff --git a/drivers/tty/serial/cpm_uart/cpm_uart_cpm2.h b/drivers/tty/serial/cpm_uart/cpm_uart_cpm2.h
index 7194c63..fceec04 100644
--- a/drivers/tty/serial/cpm_uart/cpm_uart_cpm2.h
+++ b/drivers/tty/serial/cpm_uart/cpm_uart_cpm2.h
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/serial/cpm_uart/cpm_uart_cpm2.h
+ * linux/drivers/tty/serial/cpm_uart/cpm_uart_cpm2.h
  *
  * Driver for CPM (SCC/SMC) serial ports
  *
diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index dfcf4b1..c529d31 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/serial/imx.c
+ *  linux/drivers/tty/serial/imx.c
  *
  *  Driver for Motorola IMX serial ports
  *
diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index bfee9b4..794dc7b 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -1,5 +1,5 @@
 /*
- * drivers/serial/msm_serial.c - driver for msm7k serial device and console
+ * drivers/tty/serial/msm_serial.c - driver for msm7k serial device and console
  *
  * Copyright (C) 2007 Google, Inc.
  * Author: Robert Love <rlove@google.com>
diff --git a/drivers/tty/serial/msm_serial.h b/drivers/tty/serial/msm_serial.h
index 9b8dc5d..f230d00 100644
--- a/drivers/tty/serial/msm_serial.h
+++ b/drivers/tty/serial/msm_serial.h
@@ -1,5 +1,5 @@
 /*
- * drivers/serial/msm_serial.h
+ * drivers/tty/serial/msm_serial.h
  *
  * Copyright (C) 2007 Google, Inc.
  * Author: Robert Love <rlove@google.com>
diff --git a/drivers/tty/serial/netx-serial.c b/drivers/tty/serial/netx-serial.c
index 7735c9f..0a15e57 100644
--- a/drivers/tty/serial/netx-serial.c
+++ b/drivers/tty/serial/netx-serial.c
@@ -1,5 +1,5 @@
 /*
- * drivers/serial/netx-serial.c
+ * drivers/tty/serial/netx-serial.c
  *
  * Copyright (c) 2005 Sascha Hauer <s.hauer@pengutronix.de>, Pengutronix
  *
diff --git a/drivers/tty/serial/pmac_zilog.c b/drivers/tty/serial/pmac_zilog.c
index 5b9cde7..64c9c77 100644
--- a/drivers/tty/serial/pmac_zilog.c
+++ b/drivers/tty/serial/pmac_zilog.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/serial/pmac_zilog.c
+ * linux/drivers/tty/serial/pmac_zilog.c
  * 
  * Driver for PowerMac Z85c30 based ESCC cell found in the
  * "macio" ASICs of various PowerMac models
diff --git a/drivers/tty/serial/pxa.c b/drivers/tty/serial/pxa.c
index 1102a39..bbfeda7 100644
--- a/drivers/tty/serial/pxa.c
+++ b/drivers/tty/serial/pxa.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/serial/pxa.c
+ *  linux/drivers/tty/serial/pxa.c
  *
  *  Based on drivers/serial/8250.c by Russell King.
  *
diff --git a/drivers/tty/serial/s3c2400.c b/drivers/tty/serial/s3c2400.c
index fed1a9a..10d72a8 100644
--- a/drivers/tty/serial/s3c2400.c
+++ b/drivers/tty/serial/s3c2400.c
@@ -1,4 +1,4 @@
-/* linux/drivers/serial/s3c240.c
+/* linux/drivers/tty/serial/s3c240.c
  *
  * Driver for Samsung SoC onboard UARTs.
  *
diff --git a/drivers/tty/serial/s3c2410.c b/drivers/tty/serial/s3c2410.c
index 73f089d..94a6a01 100644
--- a/drivers/tty/serial/s3c2410.c
+++ b/drivers/tty/serial/s3c2410.c
@@ -1,4 +1,4 @@
-/* linux/drivers/serial/s3c2410.c
+/* linux/drivers/tty/serial/s3c2410.c
  *
  * Driver for Samsung S3C2410 SoC onboard UARTs.
  *
diff --git a/drivers/tty/serial/s3c2412.c b/drivers/tty/serial/s3c2412.c
index 1700b1a..7f43144 100644
--- a/drivers/tty/serial/s3c2412.c
+++ b/drivers/tty/serial/s3c2412.c
@@ -1,4 +1,4 @@
-/* linux/drivers/serial/s3c2412.c
+/* linux/drivers/tty/serial/s3c2412.c
  *
  * Driver for Samsung S3C2412 and S3C2413 SoC onboard UARTs.
  *
diff --git a/drivers/tty/serial/s3c2440.c b/drivers/tty/serial/s3c2440.c
index 094cc39..8361135 100644
--- a/drivers/tty/serial/s3c2440.c
+++ b/drivers/tty/serial/s3c2440.c
@@ -1,4 +1,4 @@
-/* linux/drivers/serial/s3c2440.c
+/* linux/drivers/tty/serial/s3c2440.c
  *
  * Driver for Samsung S3C2440 and S3C2442 SoC onboard UARTs.
  *
diff --git a/drivers/tty/serial/s3c24a0.c b/drivers/tty/serial/s3c24a0.c
index fad6083..6979613 100644
--- a/drivers/tty/serial/s3c24a0.c
+++ b/drivers/tty/serial/s3c24a0.c
@@ -1,4 +1,4 @@
-/* linux/drivers/serial/s3c24a0.c
+/* linux/drivers/tty/serial/s3c24a0.c
  *
  * Driver for Samsung S3C24A0 SoC onboard UARTs.
  *
diff --git a/drivers/tty/serial/s3c6400.c b/drivers/tty/serial/s3c6400.c
index 4be92ab..70e2f0a 100644
--- a/drivers/tty/serial/s3c6400.c
+++ b/drivers/tty/serial/s3c6400.c
@@ -1,4 +1,4 @@
-/* linux/drivers/serial/s3c6400.c
+/* linux/drivers/tty/serial/s3c6400.c
  *
  * Driver for Samsung S3C6400 and S3C6410 SoC onboard UARTs.
  *
diff --git a/drivers/tty/serial/s5pv210.c b/drivers/tty/serial/s5pv210.c
index 6ebccd7..ef99392 100644
--- a/drivers/tty/serial/s5pv210.c
+++ b/drivers/tty/serial/s5pv210.c
@@ -1,4 +1,4 @@
-/* linux/drivers/serial/s5pv210.c
+/* linux/drivers/tty/serial/s5pv210.c
  *
  * Copyright (c) 2010 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com/
diff --git a/drivers/tty/serial/sa1100.c b/drivers/tty/serial/sa1100.c
index 2199d81..acbc769 100644
--- a/drivers/tty/serial/sa1100.c
+++ b/drivers/tty/serial/sa1100.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/char/sa1100.c
+ *  linux/drivers/tty/serial/sa1100.c
  *
  *  Driver for SA11x0 serial ports
  *
diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index 2335eda..8361041 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -1,4 +1,4 @@
-/* linux/drivers/serial/samsuing.c
+/* linux/drivers/tty/serial/samsung.c
  *
  * Driver core for Samsung SoC onboard UARTs.
  *
diff --git a/drivers/tty/serial/samsung.h b/drivers/tty/serial/samsung.h
index 0ac06a0..e9053bc 100644
--- a/drivers/tty/serial/samsung.h
+++ b/drivers/tty/serial/samsung.h
@@ -1,4 +1,4 @@
-/* linux/drivers/serial/samsung.h
+/* linux/drivers/tty/serial/samsung.h
  *
  * Driver for Samsung SoC onboard UARTs.
  *
diff --git a/drivers/tty/serial/sb1250-duart.c b/drivers/tty/serial/sb1250-duart.c
index 602d984..f1bca1e 100644
--- a/drivers/tty/serial/sb1250-duart.c
+++ b/drivers/tty/serial/sb1250-duart.c
@@ -1,5 +1,5 @@
 /*
- *	drivers/serial/sb1250-duart.c
+ *	drivers/tty/serial/sb1250-duart.c
  *
  *	Support for the asynchronous serial interface (DUART) included
  *	in the BCM1250 and derived System-On-a-Chip (SOC) devices.
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 733fe8e..3e4c52e 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/char/core.c
+ *  linux/drivers/tty/serial/serial_core.c
  *
  *  Driver core for serial ports
  *
diff --git a/drivers/tty/serial/serial_ks8695.c b/drivers/tty/serial/serial_ks8695.c
index b196202..f97c2df 100644
--- a/drivers/tty/serial/serial_ks8695.c
+++ b/drivers/tty/serial/serial_ks8695.c
@@ -1,5 +1,5 @@
 /*
- *  drivers/serial/serial_ks8695.c
+ *  drivers/tty/serial/serial_ks8695.c
  *
  *  Driver for KS8695 serial ports
  *
diff --git a/drivers/tty/serial/serial_txx9.c b/drivers/tty/serial/serial_txx9.c
index c50e9fb..f665de7 100644
--- a/drivers/tty/serial/serial_txx9.c
+++ b/drivers/tty/serial/serial_txx9.c
@@ -1,5 +1,5 @@
 /*
- *  drivers/serial/serial_txx9.c
+ *  drivers/tty/serial/serial_txx9.c
  *
  * Derived from many drivers using generic_serial interface,
  * especially serial_tx3912.c by Steven J. Hill and r39xx_serial.c
diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index eb7958c..f517f15 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -1,5 +1,5 @@
 /*
- * drivers/serial/sh-sci.c
+ * drivers/tty/serial/sh-sci.c
  *
  * SuperH on-chip serial module support.  (SCI with no FIFO / with FIFO)
  *
diff --git a/drivers/tty/serial/vt8500_serial.c b/drivers/tty/serial/vt8500_serial.c
index 322bf56..4677671 100644
--- a/drivers/tty/serial/vt8500_serial.c
+++ b/drivers/tty/serial/vt8500_serial.c
@@ -1,5 +1,5 @@
 /*
- * drivers/serial/vt8500_serial.c
+ * drivers/tty/serial/vt8500_serial.c
  *
  * Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
  *
diff --git a/drivers/tty/synclink.c b/drivers/tty/synclink.c
index 18888d0..06fa731 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/char/synclink.c
+ * linux/drivers/tty/synclink.c
  *
  * $Id: synclink.c,v 4.38 2005/11/07 16:30:34 paulkf Exp $
  *
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 936a4ea..998e646 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/char/tty_io.c
+ *  linux/drivers/tty/tty_io.c
  *
  *  Copyright (C) 1991, 1992  Linus Torvalds
  */
diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index 1a1135d..3fcfc80 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/char/tty_ioctl.c
+ *  linux/drivers/tty/tty_ioctl.c
  *
  *  Copyright (C) 1991, 1992, 1993, 1994  Linus Torvalds
  *
diff --git a/drivers/tty/tty_mutex.c b/drivers/tty/tty_mutex.c
index 1336975..b3be7a2 100644
--- a/drivers/tty/tty_mutex.c
+++ b/drivers/tty/tty_mutex.c
@@ -1,5 +1,5 @@
 /*
- * drivers/char/tty_lock.c
+ * drivers/tty/tty_mutex.c
  */
 #include <linux/tty.h>
 #include <linux/module.h>
diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index d6b342b..56dade5 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/char/keyboard.c
+ * linux/drivers/tty/vt/keyboard.c
  *
  * Written for linux by Johan Myreen as a translation from
  * the assembly version by Linus (with diacriticals added)
diff --git a/drivers/tty/vt/selection.c b/drivers/tty/vt/selection.c
index adf0ad2..248964b 100644
--- a/drivers/tty/vt/selection.c
+++ b/drivers/tty/vt/selection.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/char/selection.c
+ * linux/drivers/tty/vt/selection.c
  *
  * This module exports the functions:
  *
diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
index 1564261..41c74d8 100644
--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/char/vc_screen.c
+ * linux/drivers/tty/vt/vc_screen.c
  *
  * Provide access to virtual console memory.
  * /dev/vcs0: the screen as it is being viewed right now (possibly scrolled)
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index c83cdfb..34541ed 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/char/vt.c
+ *  linux/drivers/tty/vt/vt.c
  *
  *  Copyright (C) 1991, 1992  Linus Torvalds
  */
diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index 937d172..ba66048 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/char/vt_ioctl.c
+ *  linux/drivers/tty/vt/vt_ioctl.c
  *
  *  Copyright (C) 1992 obz under the linux copyright
  *
-- 
1.7.2.3

