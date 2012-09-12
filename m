Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760916Ab2ILRLt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:11:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56548 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760641Ab2ILRLp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:11:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 12/16] ARM: nomadik: move platform_data definitions
Date: Wed, 12 Sep 2012 16:24:27 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Alessandro Rubini <rubini@unipv.it>,
        STEricsson <STEricsson_nomadik_linux@list.st.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Felipe Balbi <balbi@ti.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Andreas Westin <andreas.westin@stericsson.com>
References: <1347368350-31212-1-git-send-email-arnd@arndb.de> <1347368390-31252-12-git-send-email-arnd@arndb.de> <CACRpkdb5Tkb5xGzuU=Mw9amfG+218dyzQaQsRZKm9cws71Vd9w@mail.gmail.com>
In-Reply-To: <CACRpkdb5Tkb5xGzuU=Mw9amfG+218dyzQaQsRZKm9cws71Vd9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201209121624.27657.arnd@arndb.de>
X-Provags-ID: V02:K0:iA+pBoYKuI9MZUIB8SwY24t38NesGrnY+S4jS4/jNGM
 RprEWLBYxKAnjv8uir/ObXUIUhLdYamagHF9m/+OMxC7X6NbyY
 rM2tMzqpnRlxqW5bblwvZeV+i44YI00PA1K8cd56UjLbr4JaPC
 cl7i76SPLjxZqwMujy3A7dvdRWDdo64xnOmOg41oSH/CgJd4Ru
 EuUnsiunRo8DZICitqU6it/z5SAnaiZIzZ3c8LjCK40Xqfuzu1
 gdvbFSOKIuSZT0PpMyhniClzIW63XavktEyI3mkkI0rlFCkXy4
 6w72HY/r2VIhvACLp0PusPX+TW9JiWkoxiuC47P585OPM48EDw
 z5IC1uC8XluYIbz/06VI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 September 2012, Linus Walleij wrote:
> I sent a patch for moving gpio-u300.h like this in commit
> 651728507140246e9cf4e809f1877cb2eddbc84e
> that is already in linux-next, is this the same patch or
> another one?

I've dropped that part from my patch now, this is the new version:

	Arnd

>From bb95f134f891ff75c5eabf740f93d11ff0ea5eca Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 24 Aug 2012 15:19:33 +0200
Subject: [PATCH 12/16] ARM: nomadik: move platform_data definitions

Platform data for device drivers should be defined in
include/linux/platform_data/*.h, not in the architecture
and platform specific directories.

This moves such data out of the nomadik include directories

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Nicolas Pitre <nico@linaro.org>
Acked-by: Felipe Balbi <balbi@ti.com>
Acked-by: Alessandro Rubini <rubini@unipv.it>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Cc: STEricsson <STEricsson_nomadik_linux@list.st.com>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Andreas Westin <andreas.westin@stericsson.com>
---
 arch/arm/mach-nomadik/board-nhk8815.c                                |    2 +-
 arch/arm/mach-u300/core.c                                            |    2 +-
 arch/arm/mach-ux500/board-mop500.c                                   |    2 +-
 arch/arm/mach-ux500/cpu-db8500.c                                     |    2 +-
 arch/arm/mach-ux500/devices-common.h                                 |    2 +-
 arch/arm/mach-ux500/usb.c                                            |    2 +-
 drivers/crypto/ux500/cryp/cryp_core.c                                |    2 +-
 drivers/crypto/ux500/hash/hash_core.c                                |    2 +-
 drivers/input/keyboard/nomadik-ske-keypad.c                          |    2 +-
 drivers/mtd/nand/nomadik_nand.c                                      |    2 +-
 drivers/pinctrl/pinctrl-coh901.c                                     |    2 +-
 drivers/usb/musb/ux500_dma.c                                         |    2 +-
 .../include/mach => include/linux/platform_data}/crypto-ux500.h      |    0
 .../plat/ske.h => include/linux/platform_data/keypad-nomadik-ske.h   |    0
 .../mach/nand.h => include/linux/platform_data/mtd-nomadik-nand.h    |    0
 .../mach/usb.h => include/linux/platform_data/usb-musb-ux500.h       |    0
 17 files changed, 12 insertions(+), 12 deletions(-)
 rename {arch/arm/mach-ux500/include/mach => include/linux/platform_data}/crypto-ux500.h (100%)
 rename arch/arm/plat-nomadik/include/plat/ske.h => include/linux/platform_data/keypad-nomadik-ske.h (100%)
 rename arch/arm/mach-nomadik/include/mach/nand.h => include/linux/platform_data/mtd-nomadik-nand.h (100%)
 rename arch/arm/mach-ux500/include/mach/usb.h => include/linux/platform_data/usb-musb-ux500.h (100%)

diff --git a/arch/arm/mach-nomadik/board-nhk8815.c b/arch/arm/mach-nomadik/board-nhk8815.c
index f4535a7..381c080 100644
--- a/arch/arm/mach-nomadik/board-nhk8815.c
+++ b/arch/arm/mach-nomadik/board-nhk8815.c
@@ -34,7 +34,7 @@
 #include <plat/gpio-nomadik.h>
 #include <plat/mtu.h>
 
-#include <mach/nand.h>
+#include <linux/platform_data/mtd-nomadik-nand.h>
 #include <mach/fsmc.h>
 
 #include "cpu-8815.h"
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 8674a89..38854d4 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -48,7 +48,7 @@
 #include <mach/setup.h>
 #include <mach/devices.h>
 #include <mach/irqs.h>
-#include <mach/crypto-ux500.h>
+#include <linux/platform_data/crypto-ux500.h>
 
 #include "ste-dma40-db8500.h"
 #include "devices-db8500.h"
diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index db3c52d..1bef4c3 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -24,7 +24,7 @@
 #include <mach/hardware.h>
 #include <mach/setup.h>
 #include <mach/devices.h>
-#include <mach/usb.h>
+#include <linux/platform_data/usb-musb-ux500.h>
 #include <mach/db8500-regs.h>
 
 #include "devices-db8500.h"
diff --git a/arch/arm/mach-ux500/devices-common.h b/arch/arm/mach-ux500/devices-common.h
index ecdd838..7fbf0ba 100644
--- a/arch/arm/mach-ux500/devices-common.h
+++ b/arch/arm/mach-ux500/devices-common.h
@@ -13,7 +13,7 @@
 #include <linux/sys_soc.h>
 #include <linux/amba/bus.h>
 #include <linux/platform_data/i2c-nomadik.h>
-#include <mach/crypto-ux500.h>
+#include <linux/platform_data/crypto-ux500.h>
 
 struct spi_master_cntlr;
 
diff --git a/arch/arm/mach-ux500/usb.c b/arch/arm/mach-ux500/usb.c
index a74af38..145482e 100644
--- a/arch/arm/mach-ux500/usb.c
+++ b/arch/arm/mach-ux500/usb.c
@@ -10,7 +10,7 @@
 
 #include <plat/ste_dma40.h>
 #include <mach/hardware.h>
-#include <mach/usb.h>
+#include <linux/platform_data/usb-musb-ux500.h>
 
 #define MUSB_DMA40_RX_CH { \
 		.mode = STEDMA40_MODE_LOGICAL, \
diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 1c307e1..ef17e38 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -32,7 +32,7 @@
 
 #include <plat/ste_dma40.h>
 
-#include <mach/crypto-ux500.h>
+#include <linux/platform_data/crypto-ux500.h>
 #include <mach/hardware.h>
 
 #include "cryp_p.h"
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 08d5032..0876507 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -31,7 +31,7 @@
 #include <crypto/scatterwalk.h>
 #include <crypto/algapi.h>
 
-#include <mach/crypto-ux500.h>
+#include <linux/platform_data/crypto-ux500.h>
 #include <mach/hardware.h>
 
 #include "hash_alg.h"
diff --git a/drivers/input/keyboard/nomadik-ske-keypad.c b/drivers/input/keyboard/nomadik-ske-keypad.c
index a880e74..49f5fa6 100644
--- a/drivers/input/keyboard/nomadik-ske-keypad.c
+++ b/drivers/input/keyboard/nomadik-ske-keypad.c
@@ -20,7 +20,7 @@
 #include <linux/clk.h>
 #include <linux/module.h>
 
-#include <plat/ske.h>
+#include <linux/platform_data/keypad-nomadik-ske.h>
 
 /* SKE_CR bits */
 #define SKE_KPMLT	(0x1 << 6)
diff --git a/drivers/mtd/nand/nomadik_nand.c b/drivers/mtd/nand/nomadik_nand.c
index a86aa81..9ee0c4e 100644
--- a/drivers/mtd/nand/nomadik_nand.c
+++ b/drivers/mtd/nand/nomadik_nand.c
@@ -31,7 +31,7 @@
 #include <linux/mtd/partitions.h>
 #include <linux/io.h>
 #include <linux/slab.h>
-#include <mach/nand.h>
+#include <linux/platform_data/mtd-nomadik-nand.h>
 #include <mach/fsmc.h>
 
 #include <mtd/mtd-abi.h>
diff --git a/drivers/usb/musb/ux500_dma.c b/drivers/usb/musb/ux500_dma.c
index d05c7fb..f82246d 100644
--- a/drivers/usb/musb/ux500_dma.c
+++ b/drivers/usb/musb/ux500_dma.c
@@ -30,7 +30,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/dmaengine.h>
 #include <linux/pfn.h>
-#include <mach/usb.h>
+#include <linux/platform_data/usb-musb-ux500.h>
 #include "musb_core.h"
 
 struct ux500_dma_channel {
diff --git a/arch/arm/mach-ux500/include/mach/crypto-ux500.h b/include/linux/platform_data/crypto-ux500.h
similarity index 100%
rename from arch/arm/mach-ux500/include/mach/crypto-ux500.h
rename to include/linux/platform_data/crypto-ux500.h
diff --git a/arch/arm/plat-nomadik/include/plat/ske.h b/include/linux/platform_data/keypad-nomadik-ske.h
similarity index 100%
rename from arch/arm/plat-nomadik/include/plat/ske.h
rename to include/linux/platform_data/keypad-nomadik-ske.h
diff --git a/arch/arm/mach-nomadik/include/mach/nand.h b/include/linux/platform_data/mtd-nomadik-nand.h
similarity index 100%
rename from arch/arm/mach-nomadik/include/mach/nand.h
rename to include/linux/platform_data/mtd-nomadik-nand.h
diff --git a/arch/arm/mach-ux500/include/mach/usb.h b/include/linux/platform_data/usb-musb-ux500.h
similarity index 100%
rename from arch/arm/mach-ux500/include/mach/usb.h
rename to include/linux/platform_data/usb-musb-ux500.h
-- 
1.7.10

