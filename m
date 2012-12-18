Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab2LRAcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 19:32:09 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:57275 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab2LRAcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 19:32:08 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] ARM: Dove: cleanup includes
Date: Tue, 18 Dec 2012 01:24:28 +0100
Message-Id: <1355790269-10596-2-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355790269-10596-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1355790269-10596-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With DT board setup removed from common code, it is a good time
to cleanup unneccessary includes from common dove code.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-dove/common.c |   30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff --git a/arch/arm/mach-dove/common.c b/arch/arm/mach-dove/common.c
index 7dda832..0e61cc4 100644
--- a/arch/arm/mach-dove/common.c
+++ b/arch/arm/mach-dove/common.c
@@ -8,35 +8,23 @@
  * warranty of any kind, whether express or implied.
  */
 
-#include <linux/kernel.h>
-#include <linux/delay.h>
 #include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/pci.h>
 #include <linux/clk-provider.h>
-#include <linux/clk/mvebu.h>
-#include <linux/ata_platform.h>
-#include <linux/gpio.h>
-#include <linux/of.h>
-#include <linux/of_platform.h>
-#include <asm/page.h>
-#include <asm/setup.h>
-#include <asm/timex.h>
+#include <linux/kernel.h>
+#include <linux/pci.h>
+#include <linux/platform_data/usb-ehci-orion.h>
+#include <linux/platform_data/dma-mv_xor.h>
+#include <linux/platform_device.h>
 #include <asm/hardware/cache-tauros2.h>
 #include <asm/mach/map.h>
 #include <asm/mach/time.h>
-#include <asm/mach/pci.h>
+#include <mach/bridge-regs.h>
 #include <mach/dove.h>
 #include <mach/pm.h>
-#include <mach/bridge-regs.h>
-#include <asm/mach/arch.h>
-#include <linux/irq.h>
-#include <plat/time.h>
-#include <linux/platform_data/usb-ehci-orion.h>
-#include <linux/platform_data/dma-mv_xor.h>
-#include <plat/irq.h>
-#include <plat/common.h>
 #include <plat/addr-map.h>
+#include <plat/common.h>
+#include <plat/irq.h>
+#include <plat/time.h>
 #include "common.h"
 
 /*****************************************************************************
-- 
1.7.10.4

