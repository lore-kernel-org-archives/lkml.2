Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab0K3Rt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 12:49:57 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:35104 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab0K3Rt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 12:49:56 -0500
Date: Tue, 30 Nov 2010 18:49:49 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Haavard Skinnemoen has left Atmel
Message-ID: <20101130184949.4e54dba3@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haavard's e-mail address at Atmel is no longer valid.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 drivers/dma/dmatest.c               |    2 +-
 drivers/i2c/busses/i2c-gpio.c       |    2 +-
 drivers/net/macb.c                  |    2 +-
 drivers/spi/atmel_spi.c             |    2 +-
 drivers/usb/gadget/atmel_usba_udc.c |    2 +-
 drivers/video/backlight/ltv350qv.c  |    2 +-
 scripts/checkstack.pl               |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

--- linux-2.6.37-rc3.orig/drivers/dma/dmatest.c	2010-10-21 10:01:12.000000000 +0200
+++ linux-2.6.37-rc3/drivers/dma/dmatest.c	2010-11-30 18:43:39.000000000 +0100
@@ -624,5 +624,5 @@ static void __exit dmatest_exit(void)
 }
 module_exit(dmatest_exit);
 
-MODULE_AUTHOR("Haavard Skinnemoen <hskinnemoen@atmel.com>");
+MODULE_AUTHOR("Haavard Skinnemoen (Atmel)");
 MODULE_LICENSE("GPL v2");
--- linux-2.6.37-rc3.orig/drivers/i2c/busses/i2c-gpio.c	2010-08-02 00:11:14.000000000 +0200
+++ linux-2.6.37-rc3/drivers/i2c/busses/i2c-gpio.c	2010-11-30 18:43:10.000000000 +0100
@@ -219,7 +219,7 @@ static void __exit i2c_gpio_exit(void)
 }
 module_exit(i2c_gpio_exit);
 
-MODULE_AUTHOR("Haavard Skinnemoen <hskinnemoen@atmel.com>");
+MODULE_AUTHOR("Haavard Skinnemoen (Atmel)");
 MODULE_DESCRIPTION("Platform-independent bitbanging I2C driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:i2c-gpio");
--- linux-2.6.37-rc3.orig/drivers/net/macb.c	2010-11-02 09:19:35.000000000 +0100
+++ linux-2.6.37-rc3/drivers/net/macb.c	2010-11-30 18:43:22.000000000 +0100
@@ -1351,5 +1351,5 @@ module_exit(macb_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Atmel MACB Ethernet driver");
-MODULE_AUTHOR("Haavard Skinnemoen <hskinnemoen@atmel.com>");
+MODULE_AUTHOR("Haavard Skinnemoen (Atmel)");
 MODULE_ALIAS("platform:macb");
--- linux-2.6.37-rc3.orig/drivers/spi/atmel_spi.c	2010-11-02 09:19:36.000000000 +0100
+++ linux-2.6.37-rc3/drivers/spi/atmel_spi.c	2010-11-30 18:43:31.000000000 +0100
@@ -931,6 +931,6 @@ static void __exit atmel_spi_exit(void)
 module_exit(atmel_spi_exit);
 
 MODULE_DESCRIPTION("Atmel AT32/AT91 SPI Controller driver");
-MODULE_AUTHOR("Haavard Skinnemoen <hskinnemoen@atmel.com>");
+MODULE_AUTHOR("Haavard Skinnemoen (Atmel)");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:atmel_spi");
--- linux-2.6.37-rc3.orig/drivers/usb/gadget/atmel_usba_udc.c	2010-11-30 15:53:30.000000000 +0100
+++ linux-2.6.37-rc3/drivers/usb/gadget/atmel_usba_udc.c	2010-11-30 18:43:48.000000000 +0100
@@ -2093,6 +2093,6 @@ static void __exit udc_exit(void)
 module_exit(udc_exit);
 
 MODULE_DESCRIPTION("Atmel USBA UDC driver");
-MODULE_AUTHOR("Haavard Skinnemoen <hskinnemoen@atmel.com>");
+MODULE_AUTHOR("Haavard Skinnemoen (Atmel)");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:atmel_usba_udc");
--- linux-2.6.37-rc3.orig/drivers/video/backlight/ltv350qv.c	2010-08-02 00:11:14.000000000 +0200
+++ linux-2.6.37-rc3/drivers/video/backlight/ltv350qv.c	2010-11-30 18:43:00.000000000 +0100
@@ -326,7 +326,7 @@ static void __exit ltv350qv_exit(void)
 module_init(ltv350qv_init);
 module_exit(ltv350qv_exit);
 
-MODULE_AUTHOR("Haavard Skinnemoen <hskinnemoen@atmel.com>");
+MODULE_AUTHOR("Haavard Skinnemoen (Atmel)");
 MODULE_DESCRIPTION("Samsung LTV350QV LCD Driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("spi:ltv350qv");
--- linux-2.6.37-rc3.orig/scripts/checkstack.pl	2010-08-02 00:11:14.000000000 +0200
+++ linux-2.6.37-rc3/scripts/checkstack.pl	2010-11-30 18:43:57.000000000 +0100
@@ -12,7 +12,7 @@
 #	sh64 port by Paul Mundt
 #	Random bits by Matt Mackall <mpm@selenic.com>
 #	M68k port by Geert Uytterhoeven and Andreas Schwab
-#	AVR32 port by Haavard Skinnemoen <hskinnemoen@atmel.com>
+#	AVR32 port by Haavard Skinnemoen (Atmel)
 #	PARISC port by Kyle McMartin <kyle@parisc-linux.org>
 #	sparc port by Martin Habets <errandir_news@mph.eclipse.co.uk>
 #


-- 
Jean Delvare
