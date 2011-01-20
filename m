Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab1ATSDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 13:03:53 -0500
Received: from kroah.org ([198.145.64.141]:45918 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab1ATSDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 13:03:50 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rogier Wolff <R.E.Wolff@bitwizard.nl>,
        "Michael H. Warfield" <mhw@wittsend.com>
Subject: [PATCH 2/3] tty: move drivers/serial/ to drivers/tty/serial/
Date: Thu, 20 Jan 2011 10:03:44 -0800
Message-Id: <1295546625-30681-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20110120174910.GA30124@kroah.com>
References: <20110120174910.GA30124@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The serial drivers are really just tty drivers, so move them to
drivers/tty/ to make things a bit neater overall.

This is part of the tty/serial driver movement proceedure as proposed by
Arnd Bergmann and approved by everyone involved a number of months ago.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Rogier Wolff <R.E.Wolff@bitwizard.nl>
Cc: Michael H. Warfield <mhw@wittsend.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/Makefile                                  |    3 +--
 drivers/char/Kconfig                              |    2 +-
 drivers/tty/Makefile                              |    1 +
 drivers/{ => tty}/serial/21285.c                  |    0
 drivers/{ => tty}/serial/68328serial.c            |    0
 drivers/{ => tty}/serial/68328serial.h            |    0
 drivers/{ => tty}/serial/68360serial.c            |    0
 drivers/{ => tty}/serial/8250.c                   |    0
 drivers/{ => tty}/serial/8250.h                   |    0
 drivers/{ => tty}/serial/8250_accent.c            |    0
 drivers/{ => tty}/serial/8250_acorn.c             |    0
 drivers/{ => tty}/serial/8250_boca.c              |    0
 drivers/{ => tty}/serial/8250_early.c             |    0
 drivers/{ => tty}/serial/8250_exar_st16c554.c     |    0
 drivers/{ => tty}/serial/8250_fourport.c          |    0
 drivers/{ => tty}/serial/8250_gsc.c               |    0
 drivers/{ => tty}/serial/8250_hp300.c             |    0
 drivers/{ => tty}/serial/8250_hub6.c              |    0
 drivers/{ => tty}/serial/8250_mca.c               |    0
 drivers/{ => tty}/serial/8250_pci.c               |    0
 drivers/{ => tty}/serial/8250_pnp.c               |    0
 drivers/{ => tty}/serial/Kconfig                  |    0
 drivers/{ => tty}/serial/Makefile                 |    0
 drivers/{ => tty}/serial/altera_jtaguart.c        |    0
 drivers/{ => tty}/serial/altera_uart.c            |    0
 drivers/{ => tty}/serial/amba-pl010.c             |    0
 drivers/{ => tty}/serial/amba-pl011.c             |    0
 drivers/{ => tty}/serial/apbuart.c                |    0
 drivers/{ => tty}/serial/apbuart.h                |    0
 drivers/{ => tty}/serial/atmel_serial.c           |    0
 drivers/{ => tty}/serial/bcm63xx_uart.c           |    0
 drivers/{ => tty}/serial/bfin_5xx.c               |    0
 drivers/{ => tty}/serial/bfin_sport_uart.c        |    0
 drivers/{ => tty}/serial/bfin_sport_uart.h        |    0
 drivers/{ => tty}/serial/clps711x.c               |    0
 drivers/{ => tty}/serial/cpm_uart/Makefile        |    0
 drivers/{ => tty}/serial/cpm_uart/cpm_uart.h      |    0
 drivers/{ => tty}/serial/cpm_uart/cpm_uart_core.c |    0
 drivers/{ => tty}/serial/cpm_uart/cpm_uart_cpm1.c |    0
 drivers/{ => tty}/serial/cpm_uart/cpm_uart_cpm1.h |    0
 drivers/{ => tty}/serial/cpm_uart/cpm_uart_cpm2.c |    0
 drivers/{ => tty}/serial/cpm_uart/cpm_uart_cpm2.h |    0
 drivers/{ => tty}/serial/crisv10.c                |    0
 drivers/{ => tty}/serial/crisv10.h                |    0
 drivers/{ => tty}/serial/dz.c                     |    0
 drivers/{ => tty}/serial/dz.h                     |    0
 drivers/{ => tty}/serial/icom.c                   |    0
 drivers/{ => tty}/serial/icom.h                   |    0
 drivers/{ => tty}/serial/ifx6x60.c                |    0
 drivers/{ => tty}/serial/ifx6x60.h                |    0
 drivers/{ => tty}/serial/imx.c                    |    0
 drivers/{ => tty}/serial/ioc3_serial.c            |    0
 drivers/{ => tty}/serial/ioc4_serial.c            |    0
 drivers/{ => tty}/serial/ip22zilog.c              |    0
 drivers/{ => tty}/serial/ip22zilog.h              |    0
 drivers/{ => tty}/serial/jsm/Makefile             |    0
 drivers/{ => tty}/serial/jsm/jsm.h                |    0
 drivers/{ => tty}/serial/jsm/jsm_driver.c         |    0
 drivers/{ => tty}/serial/jsm/jsm_neo.c            |    0
 drivers/{ => tty}/serial/jsm/jsm_tty.c            |    0
 drivers/{ => tty}/serial/kgdboc.c                 |    0
 drivers/{ => tty}/serial/m32r_sio.c               |    0
 drivers/{ => tty}/serial/m32r_sio.h               |    0
 drivers/{ => tty}/serial/m32r_sio_reg.h           |    0
 drivers/{ => tty}/serial/max3100.c                |    0
 drivers/{ => tty}/serial/max3107-aava.c           |    0
 drivers/{ => tty}/serial/max3107.c                |    0
 drivers/{ => tty}/serial/max3107.h                |    0
 drivers/{ => tty}/serial/mcf.c                    |    0
 drivers/{ => tty}/serial/mfd.c                    |    0
 drivers/{ => tty}/serial/mpc52xx_uart.c           |    0
 drivers/{ => tty}/serial/mpsc.c                   |    0
 drivers/{ => tty}/serial/mrst_max3110.c           |    0
 drivers/{ => tty}/serial/mrst_max3110.h           |    0
 drivers/{ => tty}/serial/msm_serial.c             |    0
 drivers/{ => tty}/serial/msm_serial.h             |    0
 drivers/{ => tty}/serial/mux.c                    |    0
 drivers/{ => tty}/serial/netx-serial.c            |    0
 drivers/{ => tty}/serial/nwpserial.c              |    0
 drivers/{ => tty}/serial/of_serial.c              |    0
 drivers/{ => tty}/serial/omap-serial.c            |    0
 drivers/{ => tty}/serial/pch_uart.c               |    0
 drivers/{ => tty}/serial/pmac_zilog.c             |    0
 drivers/{ => tty}/serial/pmac_zilog.h             |    0
 drivers/{ => tty}/serial/pnx8xxx_uart.c           |    0
 drivers/{ => tty}/serial/pxa.c                    |    0
 drivers/{ => tty}/serial/s3c2400.c                |    0
 drivers/{ => tty}/serial/s3c2410.c                |    0
 drivers/{ => tty}/serial/s3c2412.c                |    0
 drivers/{ => tty}/serial/s3c2440.c                |    0
 drivers/{ => tty}/serial/s3c24a0.c                |    0
 drivers/{ => tty}/serial/s3c6400.c                |    0
 drivers/{ => tty}/serial/s5pv210.c                |    0
 drivers/{ => tty}/serial/sa1100.c                 |    0
 drivers/{ => tty}/serial/samsung.c                |    0
 drivers/{ => tty}/serial/samsung.h                |    0
 drivers/{ => tty}/serial/sb1250-duart.c           |    0
 drivers/{ => tty}/serial/sc26xx.c                 |    0
 drivers/{ => tty}/serial/serial_core.c            |    0
 drivers/{ => tty}/serial/serial_cs.c              |    0
 drivers/{ => tty}/serial/serial_ks8695.c          |    0
 drivers/{ => tty}/serial/serial_lh7a40x.c         |    0
 drivers/{ => tty}/serial/serial_txx9.c            |    0
 drivers/{ => tty}/serial/sh-sci.c                 |    0
 drivers/{ => tty}/serial/sh-sci.h                 |    0
 drivers/{ => tty}/serial/sn_console.c             |    0
 drivers/{ => tty}/serial/suncore.c                |    0
 drivers/{ => tty}/serial/suncore.h                |    0
 drivers/{ => tty}/serial/sunhv.c                  |    0
 drivers/{ => tty}/serial/sunsab.c                 |    0
 drivers/{ => tty}/serial/sunsab.h                 |    0
 drivers/{ => tty}/serial/sunsu.c                  |    0
 drivers/{ => tty}/serial/sunzilog.c               |    0
 drivers/{ => tty}/serial/sunzilog.h               |    0
 drivers/{ => tty}/serial/timbuart.c               |    0
 drivers/{ => tty}/serial/timbuart.h               |    0
 drivers/{ => tty}/serial/uartlite.c               |    0
 drivers/{ => tty}/serial/ucc_uart.c               |    0
 drivers/{ => tty}/serial/vr41xx_siu.c             |    0
 drivers/{ => tty}/serial/vt8500_serial.c          |    0
 drivers/{ => tty}/serial/zs.c                     |    0
 drivers/{ => tty}/serial/zs.h                     |    0
 122 files changed, 3 insertions(+), 3 deletions(-)
 rename drivers/{ => tty}/serial/21285.c (100%)
 rename drivers/{ => tty}/serial/68328serial.c (100%)
 rename drivers/{ => tty}/serial/68328serial.h (100%)
 rename drivers/{ => tty}/serial/68360serial.c (100%)
 rename drivers/{ => tty}/serial/8250.c (100%)
 rename drivers/{ => tty}/serial/8250.h (100%)
 rename drivers/{ => tty}/serial/8250_accent.c (100%)
 rename drivers/{ => tty}/serial/8250_acorn.c (100%)
 rename drivers/{ => tty}/serial/8250_boca.c (100%)
 rename drivers/{ => tty}/serial/8250_early.c (100%)
 rename drivers/{ => tty}/serial/8250_exar_st16c554.c (100%)
 rename drivers/{ => tty}/serial/8250_fourport.c (100%)
 rename drivers/{ => tty}/serial/8250_gsc.c (100%)
 rename drivers/{ => tty}/serial/8250_hp300.c (100%)
 rename drivers/{ => tty}/serial/8250_hub6.c (100%)
 rename drivers/{ => tty}/serial/8250_mca.c (100%)
 rename drivers/{ => tty}/serial/8250_pci.c (100%)
 rename drivers/{ => tty}/serial/8250_pnp.c (100%)
 rename drivers/{ => tty}/serial/Kconfig (100%)
 rename drivers/{ => tty}/serial/Makefile (100%)
 rename drivers/{ => tty}/serial/altera_jtaguart.c (100%)
 rename drivers/{ => tty}/serial/altera_uart.c (100%)
 rename drivers/{ => tty}/serial/amba-pl010.c (100%)
 rename drivers/{ => tty}/serial/amba-pl011.c (100%)
 rename drivers/{ => tty}/serial/apbuart.c (100%)
 rename drivers/{ => tty}/serial/apbuart.h (100%)
 rename drivers/{ => tty}/serial/atmel_serial.c (100%)
 rename drivers/{ => tty}/serial/bcm63xx_uart.c (100%)
 rename drivers/{ => tty}/serial/bfin_5xx.c (100%)
 rename drivers/{ => tty}/serial/bfin_sport_uart.c (100%)
 rename drivers/{ => tty}/serial/bfin_sport_uart.h (100%)
 rename drivers/{ => tty}/serial/clps711x.c (100%)
 rename drivers/{ => tty}/serial/cpm_uart/Makefile (100%)
 rename drivers/{ => tty}/serial/cpm_uart/cpm_uart.h (100%)
 rename drivers/{ => tty}/serial/cpm_uart/cpm_uart_core.c (100%)
 rename drivers/{ => tty}/serial/cpm_uart/cpm_uart_cpm1.c (100%)
 rename drivers/{ => tty}/serial/cpm_uart/cpm_uart_cpm1.h (100%)
 rename drivers/{ => tty}/serial/cpm_uart/cpm_uart_cpm2.c (100%)
 rename drivers/{ => tty}/serial/cpm_uart/cpm_uart_cpm2.h (100%)
 rename drivers/{ => tty}/serial/crisv10.c (100%)
 rename drivers/{ => tty}/serial/crisv10.h (100%)
 rename drivers/{ => tty}/serial/dz.c (100%)
 rename drivers/{ => tty}/serial/dz.h (100%)
 rename drivers/{ => tty}/serial/icom.c (100%)
 rename drivers/{ => tty}/serial/icom.h (100%)
 rename drivers/{ => tty}/serial/ifx6x60.c (100%)
 rename drivers/{ => tty}/serial/ifx6x60.h (100%)
 rename drivers/{ => tty}/serial/imx.c (100%)
 rename drivers/{ => tty}/serial/ioc3_serial.c (100%)
 rename drivers/{ => tty}/serial/ioc4_serial.c (100%)
 rename drivers/{ => tty}/serial/ip22zilog.c (100%)
 rename drivers/{ => tty}/serial/ip22zilog.h (100%)
 rename drivers/{ => tty}/serial/jsm/Makefile (100%)
 rename drivers/{ => tty}/serial/jsm/jsm.h (100%)
 rename drivers/{ => tty}/serial/jsm/jsm_driver.c (100%)
 rename drivers/{ => tty}/serial/jsm/jsm_neo.c (100%)
 rename drivers/{ => tty}/serial/jsm/jsm_tty.c (100%)
 rename drivers/{ => tty}/serial/kgdboc.c (100%)
 rename drivers/{ => tty}/serial/m32r_sio.c (100%)
 rename drivers/{ => tty}/serial/m32r_sio.h (100%)
 rename drivers/{ => tty}/serial/m32r_sio_reg.h (100%)
 rename drivers/{ => tty}/serial/max3100.c (100%)
 rename drivers/{ => tty}/serial/max3107-aava.c (100%)
 rename drivers/{ => tty}/serial/max3107.c (100%)
 rename drivers/{ => tty}/serial/max3107.h (100%)
 rename drivers/{ => tty}/serial/mcf.c (100%)
 rename drivers/{ => tty}/serial/mfd.c (100%)
 rename drivers/{ => tty}/serial/mpc52xx_uart.c (100%)
 rename drivers/{ => tty}/serial/mpsc.c (100%)
 rename drivers/{ => tty}/serial/mrst_max3110.c (100%)
 rename drivers/{ => tty}/serial/mrst_max3110.h (100%)
 rename drivers/{ => tty}/serial/msm_serial.c (100%)
 rename drivers/{ => tty}/serial/msm_serial.h (100%)
 rename drivers/{ => tty}/serial/mux.c (100%)
 rename drivers/{ => tty}/serial/netx-serial.c (100%)
 rename drivers/{ => tty}/serial/nwpserial.c (100%)
 rename drivers/{ => tty}/serial/of_serial.c (100%)
 rename drivers/{ => tty}/serial/omap-serial.c (100%)
 rename drivers/{ => tty}/serial/pch_uart.c (100%)
 rename drivers/{ => tty}/serial/pmac_zilog.c (100%)
 rename drivers/{ => tty}/serial/pmac_zilog.h (100%)
 rename drivers/{ => tty}/serial/pnx8xxx_uart.c (100%)
 rename drivers/{ => tty}/serial/pxa.c (100%)
 rename drivers/{ => tty}/serial/s3c2400.c (100%)
 rename drivers/{ => tty}/serial/s3c2410.c (100%)
 rename drivers/{ => tty}/serial/s3c2412.c (100%)
 rename drivers/{ => tty}/serial/s3c2440.c (100%)
 rename drivers/{ => tty}/serial/s3c24a0.c (100%)
 rename drivers/{ => tty}/serial/s3c6400.c (100%)
 rename drivers/{ => tty}/serial/s5pv210.c (100%)
 rename drivers/{ => tty}/serial/sa1100.c (100%)
 rename drivers/{ => tty}/serial/samsung.c (100%)
 rename drivers/{ => tty}/serial/samsung.h (100%)
 rename drivers/{ => tty}/serial/sb1250-duart.c (100%)
 rename drivers/{ => tty}/serial/sc26xx.c (100%)
 rename drivers/{ => tty}/serial/serial_core.c (100%)
 rename drivers/{ => tty}/serial/serial_cs.c (100%)
 rename drivers/{ => tty}/serial/serial_ks8695.c (100%)
 rename drivers/{ => tty}/serial/serial_lh7a40x.c (100%)
 rename drivers/{ => tty}/serial/serial_txx9.c (100%)
 rename drivers/{ => tty}/serial/sh-sci.c (100%)
 rename drivers/{ => tty}/serial/sh-sci.h (100%)
 rename drivers/{ => tty}/serial/sn_console.c (100%)
 rename drivers/{ => tty}/serial/suncore.c (100%)
 rename drivers/{ => tty}/serial/suncore.h (100%)
 rename drivers/{ => tty}/serial/sunhv.c (100%)
 rename drivers/{ => tty}/serial/sunsab.c (100%)
 rename drivers/{ => tty}/serial/sunsab.h (100%)
 rename drivers/{ => tty}/serial/sunsu.c (100%)
 rename drivers/{ => tty}/serial/sunzilog.c (100%)
 rename drivers/{ => tty}/serial/sunzilog.h (100%)
 rename drivers/{ => tty}/serial/timbuart.c (100%)
 rename drivers/{ => tty}/serial/timbuart.h (100%)
 rename drivers/{ => tty}/serial/uartlite.c (100%)
 rename drivers/{ => tty}/serial/ucc_uart.c (100%)
 rename drivers/{ => tty}/serial/vr41xx_siu.c (100%)
 rename drivers/{ => tty}/serial/vt8500_serial.c (100%)
 rename drivers/{ => tty}/serial/zs.c (100%)
 rename drivers/{ => tty}/serial/zs.h (100%)

diff --git a/drivers/Makefile b/drivers/Makefile
index ef51324..1e2cda1 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -24,7 +24,7 @@ obj-$(CONFIG_XEN)		+= xen/
 # regulators early, since some subsystems rely on them to initialize
 obj-$(CONFIG_REGULATOR)		+= regulator/
 
-# char/ comes before serial/ etc so that the VT console is the boot-time
+# tty/ comes before char/ so that the VT console is the boot-time
 # default.
 obj-y				+= tty/
 obj-y				+= char/
@@ -38,7 +38,6 @@ obj-$(CONFIG_CONNECTOR)		+= connector/
 obj-$(CONFIG_FB_I810)           += video/i810/
 obj-$(CONFIG_FB_INTEL)          += video/intelfb/
 
-obj-y				+= serial/
 obj-$(CONFIG_PARPORT)		+= parport/
 obj-y				+= base/ block/ misc/ mfd/ nfc/
 obj-$(CONFIG_NUBUS)		+= nubus/
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 0f175a8..ccac7d0 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -426,7 +426,7 @@ config SGI_MBCS
          If you have an SGI Altix with an attached SABrick
          say Y or M here, otherwise say N.
 
-source "drivers/serial/Kconfig"
+source "drivers/tty/serial/Kconfig"
 
 config UNIX98_PTYS
 	bool "Unix98 PTY support" if EMBEDDED
diff --git a/drivers/tty/Makefile b/drivers/tty/Makefile
index d3685f0..3962772 100644
--- a/drivers/tty/Makefile
+++ b/drivers/tty/Makefile
@@ -10,3 +10,4 @@ obj-$(CONFIG_R3964)		+= n_r3964.o
 
 obj-y				+= vt/
 obj-$(CONFIG_HVC_DRIVER)	+= hvc/
+obj-y				+= serial/
diff --git a/drivers/serial/21285.c b/drivers/tty/serial/21285.c
similarity index 100%
rename from drivers/serial/21285.c
rename to drivers/tty/serial/21285.c
diff --git a/drivers/serial/68328serial.c b/drivers/tty/serial/68328serial.c
similarity index 100%
rename from drivers/serial/68328serial.c
rename to drivers/tty/serial/68328serial.c
diff --git a/drivers/serial/68328serial.h b/drivers/tty/serial/68328serial.h
similarity index 100%
rename from drivers/serial/68328serial.h
rename to drivers/tty/serial/68328serial.h
diff --git a/drivers/serial/68360serial.c b/drivers/tty/serial/68360serial.c
similarity index 100%
rename from drivers/serial/68360serial.c
rename to drivers/tty/serial/68360serial.c
diff --git a/drivers/serial/8250.c b/drivers/tty/serial/8250.c
similarity index 100%
rename from drivers/serial/8250.c
rename to drivers/tty/serial/8250.c
diff --git a/drivers/serial/8250.h b/drivers/tty/serial/8250.h
similarity index 100%
rename from drivers/serial/8250.h
rename to drivers/tty/serial/8250.h
diff --git a/drivers/serial/8250_accent.c b/drivers/tty/serial/8250_accent.c
similarity index 100%
rename from drivers/serial/8250_accent.c
rename to drivers/tty/serial/8250_accent.c
diff --git a/drivers/serial/8250_acorn.c b/drivers/tty/serial/8250_acorn.c
similarity index 100%
rename from drivers/serial/8250_acorn.c
rename to drivers/tty/serial/8250_acorn.c
diff --git a/drivers/serial/8250_boca.c b/drivers/tty/serial/8250_boca.c
similarity index 100%
rename from drivers/serial/8250_boca.c
rename to drivers/tty/serial/8250_boca.c
diff --git a/drivers/serial/8250_early.c b/drivers/tty/serial/8250_early.c
similarity index 100%
rename from drivers/serial/8250_early.c
rename to drivers/tty/serial/8250_early.c
diff --git a/drivers/serial/8250_exar_st16c554.c b/drivers/tty/serial/8250_exar_st16c554.c
similarity index 100%
rename from drivers/serial/8250_exar_st16c554.c
rename to drivers/tty/serial/8250_exar_st16c554.c
diff --git a/drivers/serial/8250_fourport.c b/drivers/tty/serial/8250_fourport.c
similarity index 100%
rename from drivers/serial/8250_fourport.c
rename to drivers/tty/serial/8250_fourport.c
diff --git a/drivers/serial/8250_gsc.c b/drivers/tty/serial/8250_gsc.c
similarity index 100%
rename from drivers/serial/8250_gsc.c
rename to drivers/tty/serial/8250_gsc.c
diff --git a/drivers/serial/8250_hp300.c b/drivers/tty/serial/8250_hp300.c
similarity index 100%
rename from drivers/serial/8250_hp300.c
rename to drivers/tty/serial/8250_hp300.c
diff --git a/drivers/serial/8250_hub6.c b/drivers/tty/serial/8250_hub6.c
similarity index 100%
rename from drivers/serial/8250_hub6.c
rename to drivers/tty/serial/8250_hub6.c
diff --git a/drivers/serial/8250_mca.c b/drivers/tty/serial/8250_mca.c
similarity index 100%
rename from drivers/serial/8250_mca.c
rename to drivers/tty/serial/8250_mca.c
diff --git a/drivers/serial/8250_pci.c b/drivers/tty/serial/8250_pci.c
similarity index 100%
rename from drivers/serial/8250_pci.c
rename to drivers/tty/serial/8250_pci.c
diff --git a/drivers/serial/8250_pnp.c b/drivers/tty/serial/8250_pnp.c
similarity index 100%
rename from drivers/serial/8250_pnp.c
rename to drivers/tty/serial/8250_pnp.c
diff --git a/drivers/serial/Kconfig b/drivers/tty/serial/Kconfig
similarity index 100%
rename from drivers/serial/Kconfig
rename to drivers/tty/serial/Kconfig
diff --git a/drivers/serial/Makefile b/drivers/tty/serial/Makefile
similarity index 100%
rename from drivers/serial/Makefile
rename to drivers/tty/serial/Makefile
diff --git a/drivers/serial/altera_jtaguart.c b/drivers/tty/serial/altera_jtaguart.c
similarity index 100%
rename from drivers/serial/altera_jtaguart.c
rename to drivers/tty/serial/altera_jtaguart.c
diff --git a/drivers/serial/altera_uart.c b/drivers/tty/serial/altera_uart.c
similarity index 100%
rename from drivers/serial/altera_uart.c
rename to drivers/tty/serial/altera_uart.c
diff --git a/drivers/serial/amba-pl010.c b/drivers/tty/serial/amba-pl010.c
similarity index 100%
rename from drivers/serial/amba-pl010.c
rename to drivers/tty/serial/amba-pl010.c
diff --git a/drivers/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
similarity index 100%
rename from drivers/serial/amba-pl011.c
rename to drivers/tty/serial/amba-pl011.c
diff --git a/drivers/serial/apbuart.c b/drivers/tty/serial/apbuart.c
similarity index 100%
rename from drivers/serial/apbuart.c
rename to drivers/tty/serial/apbuart.c
diff --git a/drivers/serial/apbuart.h b/drivers/tty/serial/apbuart.h
similarity index 100%
rename from drivers/serial/apbuart.h
rename to drivers/tty/serial/apbuart.h
diff --git a/drivers/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
similarity index 100%
rename from drivers/serial/atmel_serial.c
rename to drivers/tty/serial/atmel_serial.c
diff --git a/drivers/serial/bcm63xx_uart.c b/drivers/tty/serial/bcm63xx_uart.c
similarity index 100%
rename from drivers/serial/bcm63xx_uart.c
rename to drivers/tty/serial/bcm63xx_uart.c
diff --git a/drivers/serial/bfin_5xx.c b/drivers/tty/serial/bfin_5xx.c
similarity index 100%
rename from drivers/serial/bfin_5xx.c
rename to drivers/tty/serial/bfin_5xx.c
diff --git a/drivers/serial/bfin_sport_uart.c b/drivers/tty/serial/bfin_sport_uart.c
similarity index 100%
rename from drivers/serial/bfin_sport_uart.c
rename to drivers/tty/serial/bfin_sport_uart.c
diff --git a/drivers/serial/bfin_sport_uart.h b/drivers/tty/serial/bfin_sport_uart.h
similarity index 100%
rename from drivers/serial/bfin_sport_uart.h
rename to drivers/tty/serial/bfin_sport_uart.h
diff --git a/drivers/serial/clps711x.c b/drivers/tty/serial/clps711x.c
similarity index 100%
rename from drivers/serial/clps711x.c
rename to drivers/tty/serial/clps711x.c
diff --git a/drivers/serial/cpm_uart/Makefile b/drivers/tty/serial/cpm_uart/Makefile
similarity index 100%
rename from drivers/serial/cpm_uart/Makefile
rename to drivers/tty/serial/cpm_uart/Makefile
diff --git a/drivers/serial/cpm_uart/cpm_uart.h b/drivers/tty/serial/cpm_uart/cpm_uart.h
similarity index 100%
rename from drivers/serial/cpm_uart/cpm_uart.h
rename to drivers/tty/serial/cpm_uart/cpm_uart.h
diff --git a/drivers/serial/cpm_uart/cpm_uart_core.c b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
similarity index 100%
rename from drivers/serial/cpm_uart/cpm_uart_core.c
rename to drivers/tty/serial/cpm_uart/cpm_uart_core.c
diff --git a/drivers/serial/cpm_uart/cpm_uart_cpm1.c b/drivers/tty/serial/cpm_uart/cpm_uart_cpm1.c
similarity index 100%
rename from drivers/serial/cpm_uart/cpm_uart_cpm1.c
rename to drivers/tty/serial/cpm_uart/cpm_uart_cpm1.c
diff --git a/drivers/serial/cpm_uart/cpm_uart_cpm1.h b/drivers/tty/serial/cpm_uart/cpm_uart_cpm1.h
similarity index 100%
rename from drivers/serial/cpm_uart/cpm_uart_cpm1.h
rename to drivers/tty/serial/cpm_uart/cpm_uart_cpm1.h
diff --git a/drivers/serial/cpm_uart/cpm_uart_cpm2.c b/drivers/tty/serial/cpm_uart/cpm_uart_cpm2.c
similarity index 100%
rename from drivers/serial/cpm_uart/cpm_uart_cpm2.c
rename to drivers/tty/serial/cpm_uart/cpm_uart_cpm2.c
diff --git a/drivers/serial/cpm_uart/cpm_uart_cpm2.h b/drivers/tty/serial/cpm_uart/cpm_uart_cpm2.h
similarity index 100%
rename from drivers/serial/cpm_uart/cpm_uart_cpm2.h
rename to drivers/tty/serial/cpm_uart/cpm_uart_cpm2.h
diff --git a/drivers/serial/crisv10.c b/drivers/tty/serial/crisv10.c
similarity index 100%
rename from drivers/serial/crisv10.c
rename to drivers/tty/serial/crisv10.c
diff --git a/drivers/serial/crisv10.h b/drivers/tty/serial/crisv10.h
similarity index 100%
rename from drivers/serial/crisv10.h
rename to drivers/tty/serial/crisv10.h
diff --git a/drivers/serial/dz.c b/drivers/tty/serial/dz.c
similarity index 100%
rename from drivers/serial/dz.c
rename to drivers/tty/serial/dz.c
diff --git a/drivers/serial/dz.h b/drivers/tty/serial/dz.h
similarity index 100%
rename from drivers/serial/dz.h
rename to drivers/tty/serial/dz.h
diff --git a/drivers/serial/icom.c b/drivers/tty/serial/icom.c
similarity index 100%
rename from drivers/serial/icom.c
rename to drivers/tty/serial/icom.c
diff --git a/drivers/serial/icom.h b/drivers/tty/serial/icom.h
similarity index 100%
rename from drivers/serial/icom.h
rename to drivers/tty/serial/icom.h
diff --git a/drivers/serial/ifx6x60.c b/drivers/tty/serial/ifx6x60.c
similarity index 100%
rename from drivers/serial/ifx6x60.c
rename to drivers/tty/serial/ifx6x60.c
diff --git a/drivers/serial/ifx6x60.h b/drivers/tty/serial/ifx6x60.h
similarity index 100%
rename from drivers/serial/ifx6x60.h
rename to drivers/tty/serial/ifx6x60.h
diff --git a/drivers/serial/imx.c b/drivers/tty/serial/imx.c
similarity index 100%
rename from drivers/serial/imx.c
rename to drivers/tty/serial/imx.c
diff --git a/drivers/serial/ioc3_serial.c b/drivers/tty/serial/ioc3_serial.c
similarity index 100%
rename from drivers/serial/ioc3_serial.c
rename to drivers/tty/serial/ioc3_serial.c
diff --git a/drivers/serial/ioc4_serial.c b/drivers/tty/serial/ioc4_serial.c
similarity index 100%
rename from drivers/serial/ioc4_serial.c
rename to drivers/tty/serial/ioc4_serial.c
diff --git a/drivers/serial/ip22zilog.c b/drivers/tty/serial/ip22zilog.c
similarity index 100%
rename from drivers/serial/ip22zilog.c
rename to drivers/tty/serial/ip22zilog.c
diff --git a/drivers/serial/ip22zilog.h b/drivers/tty/serial/ip22zilog.h
similarity index 100%
rename from drivers/serial/ip22zilog.h
rename to drivers/tty/serial/ip22zilog.h
diff --git a/drivers/serial/jsm/Makefile b/drivers/tty/serial/jsm/Makefile
similarity index 100%
rename from drivers/serial/jsm/Makefile
rename to drivers/tty/serial/jsm/Makefile
diff --git a/drivers/serial/jsm/jsm.h b/drivers/tty/serial/jsm/jsm.h
similarity index 100%
rename from drivers/serial/jsm/jsm.h
rename to drivers/tty/serial/jsm/jsm.h
diff --git a/drivers/serial/jsm/jsm_driver.c b/drivers/tty/serial/jsm/jsm_driver.c
similarity index 100%
rename from drivers/serial/jsm/jsm_driver.c
rename to drivers/tty/serial/jsm/jsm_driver.c
diff --git a/drivers/serial/jsm/jsm_neo.c b/drivers/tty/serial/jsm/jsm_neo.c
similarity index 100%
rename from drivers/serial/jsm/jsm_neo.c
rename to drivers/tty/serial/jsm/jsm_neo.c
diff --git a/drivers/serial/jsm/jsm_tty.c b/drivers/tty/serial/jsm/jsm_tty.c
similarity index 100%
rename from drivers/serial/jsm/jsm_tty.c
rename to drivers/tty/serial/jsm/jsm_tty.c
diff --git a/drivers/serial/kgdboc.c b/drivers/tty/serial/kgdboc.c
similarity index 100%
rename from drivers/serial/kgdboc.c
rename to drivers/tty/serial/kgdboc.c
diff --git a/drivers/serial/m32r_sio.c b/drivers/tty/serial/m32r_sio.c
similarity index 100%
rename from drivers/serial/m32r_sio.c
rename to drivers/tty/serial/m32r_sio.c
diff --git a/drivers/serial/m32r_sio.h b/drivers/tty/serial/m32r_sio.h
similarity index 100%
rename from drivers/serial/m32r_sio.h
rename to drivers/tty/serial/m32r_sio.h
diff --git a/drivers/serial/m32r_sio_reg.h b/drivers/tty/serial/m32r_sio_reg.h
similarity index 100%
rename from drivers/serial/m32r_sio_reg.h
rename to drivers/tty/serial/m32r_sio_reg.h
diff --git a/drivers/serial/max3100.c b/drivers/tty/serial/max3100.c
similarity index 100%
rename from drivers/serial/max3100.c
rename to drivers/tty/serial/max3100.c
diff --git a/drivers/serial/max3107-aava.c b/drivers/tty/serial/max3107-aava.c
similarity index 100%
rename from drivers/serial/max3107-aava.c
rename to drivers/tty/serial/max3107-aava.c
diff --git a/drivers/serial/max3107.c b/drivers/tty/serial/max3107.c
similarity index 100%
rename from drivers/serial/max3107.c
rename to drivers/tty/serial/max3107.c
diff --git a/drivers/serial/max3107.h b/drivers/tty/serial/max3107.h
similarity index 100%
rename from drivers/serial/max3107.h
rename to drivers/tty/serial/max3107.h
diff --git a/drivers/serial/mcf.c b/drivers/tty/serial/mcf.c
similarity index 100%
rename from drivers/serial/mcf.c
rename to drivers/tty/serial/mcf.c
diff --git a/drivers/serial/mfd.c b/drivers/tty/serial/mfd.c
similarity index 100%
rename from drivers/serial/mfd.c
rename to drivers/tty/serial/mfd.c
diff --git a/drivers/serial/mpc52xx_uart.c b/drivers/tty/serial/mpc52xx_uart.c
similarity index 100%
rename from drivers/serial/mpc52xx_uart.c
rename to drivers/tty/serial/mpc52xx_uart.c
diff --git a/drivers/serial/mpsc.c b/drivers/tty/serial/mpsc.c
similarity index 100%
rename from drivers/serial/mpsc.c
rename to drivers/tty/serial/mpsc.c
diff --git a/drivers/serial/mrst_max3110.c b/drivers/tty/serial/mrst_max3110.c
similarity index 100%
rename from drivers/serial/mrst_max3110.c
rename to drivers/tty/serial/mrst_max3110.c
diff --git a/drivers/serial/mrst_max3110.h b/drivers/tty/serial/mrst_max3110.h
similarity index 100%
rename from drivers/serial/mrst_max3110.h
rename to drivers/tty/serial/mrst_max3110.h
diff --git a/drivers/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
similarity index 100%
rename from drivers/serial/msm_serial.c
rename to drivers/tty/serial/msm_serial.c
diff --git a/drivers/serial/msm_serial.h b/drivers/tty/serial/msm_serial.h
similarity index 100%
rename from drivers/serial/msm_serial.h
rename to drivers/tty/serial/msm_serial.h
diff --git a/drivers/serial/mux.c b/drivers/tty/serial/mux.c
similarity index 100%
rename from drivers/serial/mux.c
rename to drivers/tty/serial/mux.c
diff --git a/drivers/serial/netx-serial.c b/drivers/tty/serial/netx-serial.c
similarity index 100%
rename from drivers/serial/netx-serial.c
rename to drivers/tty/serial/netx-serial.c
diff --git a/drivers/serial/nwpserial.c b/drivers/tty/serial/nwpserial.c
similarity index 100%
rename from drivers/serial/nwpserial.c
rename to drivers/tty/serial/nwpserial.c
diff --git a/drivers/serial/of_serial.c b/drivers/tty/serial/of_serial.c
similarity index 100%
rename from drivers/serial/of_serial.c
rename to drivers/tty/serial/of_serial.c
diff --git a/drivers/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
similarity index 100%
rename from drivers/serial/omap-serial.c
rename to drivers/tty/serial/omap-serial.c
diff --git a/drivers/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
similarity index 100%
rename from drivers/serial/pch_uart.c
rename to drivers/tty/serial/pch_uart.c
diff --git a/drivers/serial/pmac_zilog.c b/drivers/tty/serial/pmac_zilog.c
similarity index 100%
rename from drivers/serial/pmac_zilog.c
rename to drivers/tty/serial/pmac_zilog.c
diff --git a/drivers/serial/pmac_zilog.h b/drivers/tty/serial/pmac_zilog.h
similarity index 100%
rename from drivers/serial/pmac_zilog.h
rename to drivers/tty/serial/pmac_zilog.h
diff --git a/drivers/serial/pnx8xxx_uart.c b/drivers/tty/serial/pnx8xxx_uart.c
similarity index 100%
rename from drivers/serial/pnx8xxx_uart.c
rename to drivers/tty/serial/pnx8xxx_uart.c
diff --git a/drivers/serial/pxa.c b/drivers/tty/serial/pxa.c
similarity index 100%
rename from drivers/serial/pxa.c
rename to drivers/tty/serial/pxa.c
diff --git a/drivers/serial/s3c2400.c b/drivers/tty/serial/s3c2400.c
similarity index 100%
rename from drivers/serial/s3c2400.c
rename to drivers/tty/serial/s3c2400.c
diff --git a/drivers/serial/s3c2410.c b/drivers/tty/serial/s3c2410.c
similarity index 100%
rename from drivers/serial/s3c2410.c
rename to drivers/tty/serial/s3c2410.c
diff --git a/drivers/serial/s3c2412.c b/drivers/tty/serial/s3c2412.c
similarity index 100%
rename from drivers/serial/s3c2412.c
rename to drivers/tty/serial/s3c2412.c
diff --git a/drivers/serial/s3c2440.c b/drivers/tty/serial/s3c2440.c
similarity index 100%
rename from drivers/serial/s3c2440.c
rename to drivers/tty/serial/s3c2440.c
diff --git a/drivers/serial/s3c24a0.c b/drivers/tty/serial/s3c24a0.c
similarity index 100%
rename from drivers/serial/s3c24a0.c
rename to drivers/tty/serial/s3c24a0.c
diff --git a/drivers/serial/s3c6400.c b/drivers/tty/serial/s3c6400.c
similarity index 100%
rename from drivers/serial/s3c6400.c
rename to drivers/tty/serial/s3c6400.c
diff --git a/drivers/serial/s5pv210.c b/drivers/tty/serial/s5pv210.c
similarity index 100%
rename from drivers/serial/s5pv210.c
rename to drivers/tty/serial/s5pv210.c
diff --git a/drivers/serial/sa1100.c b/drivers/tty/serial/sa1100.c
similarity index 100%
rename from drivers/serial/sa1100.c
rename to drivers/tty/serial/sa1100.c
diff --git a/drivers/serial/samsung.c b/drivers/tty/serial/samsung.c
similarity index 100%
rename from drivers/serial/samsung.c
rename to drivers/tty/serial/samsung.c
diff --git a/drivers/serial/samsung.h b/drivers/tty/serial/samsung.h
similarity index 100%
rename from drivers/serial/samsung.h
rename to drivers/tty/serial/samsung.h
diff --git a/drivers/serial/sb1250-duart.c b/drivers/tty/serial/sb1250-duart.c
similarity index 100%
rename from drivers/serial/sb1250-duart.c
rename to drivers/tty/serial/sb1250-duart.c
diff --git a/drivers/serial/sc26xx.c b/drivers/tty/serial/sc26xx.c
similarity index 100%
rename from drivers/serial/sc26xx.c
rename to drivers/tty/serial/sc26xx.c
diff --git a/drivers/serial/serial_core.c b/drivers/tty/serial/serial_core.c
similarity index 100%
rename from drivers/serial/serial_core.c
rename to drivers/tty/serial/serial_core.c
diff --git a/drivers/serial/serial_cs.c b/drivers/tty/serial/serial_cs.c
similarity index 100%
rename from drivers/serial/serial_cs.c
rename to drivers/tty/serial/serial_cs.c
diff --git a/drivers/serial/serial_ks8695.c b/drivers/tty/serial/serial_ks8695.c
similarity index 100%
rename from drivers/serial/serial_ks8695.c
rename to drivers/tty/serial/serial_ks8695.c
diff --git a/drivers/serial/serial_lh7a40x.c b/drivers/tty/serial/serial_lh7a40x.c
similarity index 100%
rename from drivers/serial/serial_lh7a40x.c
rename to drivers/tty/serial/serial_lh7a40x.c
diff --git a/drivers/serial/serial_txx9.c b/drivers/tty/serial/serial_txx9.c
similarity index 100%
rename from drivers/serial/serial_txx9.c
rename to drivers/tty/serial/serial_txx9.c
diff --git a/drivers/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
similarity index 100%
rename from drivers/serial/sh-sci.c
rename to drivers/tty/serial/sh-sci.c
diff --git a/drivers/serial/sh-sci.h b/drivers/tty/serial/sh-sci.h
similarity index 100%
rename from drivers/serial/sh-sci.h
rename to drivers/tty/serial/sh-sci.h
diff --git a/drivers/serial/sn_console.c b/drivers/tty/serial/sn_console.c
similarity index 100%
rename from drivers/serial/sn_console.c
rename to drivers/tty/serial/sn_console.c
diff --git a/drivers/serial/suncore.c b/drivers/tty/serial/suncore.c
similarity index 100%
rename from drivers/serial/suncore.c
rename to drivers/tty/serial/suncore.c
diff --git a/drivers/serial/suncore.h b/drivers/tty/serial/suncore.h
similarity index 100%
rename from drivers/serial/suncore.h
rename to drivers/tty/serial/suncore.h
diff --git a/drivers/serial/sunhv.c b/drivers/tty/serial/sunhv.c
similarity index 100%
rename from drivers/serial/sunhv.c
rename to drivers/tty/serial/sunhv.c
diff --git a/drivers/serial/sunsab.c b/drivers/tty/serial/sunsab.c
similarity index 100%
rename from drivers/serial/sunsab.c
rename to drivers/tty/serial/sunsab.c
diff --git a/drivers/serial/sunsab.h b/drivers/tty/serial/sunsab.h
similarity index 100%
rename from drivers/serial/sunsab.h
rename to drivers/tty/serial/sunsab.h
diff --git a/drivers/serial/sunsu.c b/drivers/tty/serial/sunsu.c
similarity index 100%
rename from drivers/serial/sunsu.c
rename to drivers/tty/serial/sunsu.c
diff --git a/drivers/serial/sunzilog.c b/drivers/tty/serial/sunzilog.c
similarity index 100%
rename from drivers/serial/sunzilog.c
rename to drivers/tty/serial/sunzilog.c
diff --git a/drivers/serial/sunzilog.h b/drivers/tty/serial/sunzilog.h
similarity index 100%
rename from drivers/serial/sunzilog.h
rename to drivers/tty/serial/sunzilog.h
diff --git a/drivers/serial/timbuart.c b/drivers/tty/serial/timbuart.c
similarity index 100%
rename from drivers/serial/timbuart.c
rename to drivers/tty/serial/timbuart.c
diff --git a/drivers/serial/timbuart.h b/drivers/tty/serial/timbuart.h
similarity index 100%
rename from drivers/serial/timbuart.h
rename to drivers/tty/serial/timbuart.h
diff --git a/drivers/serial/uartlite.c b/drivers/tty/serial/uartlite.c
similarity index 100%
rename from drivers/serial/uartlite.c
rename to drivers/tty/serial/uartlite.c
diff --git a/drivers/serial/ucc_uart.c b/drivers/tty/serial/ucc_uart.c
similarity index 100%
rename from drivers/serial/ucc_uart.c
rename to drivers/tty/serial/ucc_uart.c
diff --git a/drivers/serial/vr41xx_siu.c b/drivers/tty/serial/vr41xx_siu.c
similarity index 100%
rename from drivers/serial/vr41xx_siu.c
rename to drivers/tty/serial/vr41xx_siu.c
diff --git a/drivers/serial/vt8500_serial.c b/drivers/tty/serial/vt8500_serial.c
similarity index 100%
rename from drivers/serial/vt8500_serial.c
rename to drivers/tty/serial/vt8500_serial.c
diff --git a/drivers/serial/zs.c b/drivers/tty/serial/zs.c
similarity index 100%
rename from drivers/serial/zs.c
rename to drivers/tty/serial/zs.c
diff --git a/drivers/serial/zs.h b/drivers/tty/serial/zs.h
similarity index 100%
rename from drivers/serial/zs.h
rename to drivers/tty/serial/zs.h
-- 
1.7.1

