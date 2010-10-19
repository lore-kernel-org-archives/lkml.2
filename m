Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab0JSVza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 17:55:30 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:37054
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920Ab0JSVz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 17:55:29 -0400
X-SpamScore: 6
X-BigFish: VS6(zcb8kzc8kzz1202hzz8275bhz2dh2a8h63h)
X-Spam-TCS-SCL: 2:0
From: <Dinh.Nguyen@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <s.hauer@pengutronix.de>, <u.kleine-koenig@pengutronix.de>,
        <valentin.longchamp@epfl.ch>, <daniel@caiaq.de>,
        <grant.likely@secretlab.ca>, <amit.kucheria@canonical.com>,
        <xiao-lizhang@freescale.com>, Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCH] ARM: imx: change mx51.h into mx5x.h
Date: Tue, 19 Oct 2010 16:57:03 -0500
Message-ID: <1287525423-22329-1-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: de01egw01.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <Dinh.Nguyen@freescale.com>

In preparation for submitting i.MX53 support, change mx51.h to
mx5x.h so that mx5x.h can contain MX53 information as well.

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
---
 arch/arm/mach-mx5/devices-imx51.h                 |    2 +-
 arch/arm/plat-mxc/include/mach/debug-macro.S      |    2 +-
 arch/arm/plat-mxc/include/mach/hardware.h         |    2 +-
 arch/arm/plat-mxc/include/mach/{mx51.h => mx5x.h} |    0
 4 files changed, 3 insertions(+), 3 deletions(-)
 rename arch/arm/plat-mxc/include/mach/{mx51.h => mx5x.h} (100%)

diff --git a/arch/arm/mach-mx5/devices-imx51.h b/arch/arm/mach-mx5/devices-imx51.h
index 5cc910e..f6abe2d 100644
--- a/arch/arm/mach-mx5/devices-imx51.h
+++ b/arch/arm/mach-mx5/devices-imx51.h
@@ -6,7 +6,7 @@
  * the terms of the GNU General Public License version 2 as published by the
  * Free Software Foundation.
  */
-#include <mach/mx51.h>
+#include <mach/mx5x.h>
 #include <mach/devices-common.h>
 
 extern const struct imx_fec_data imx51_fec_data __initconst;
diff --git a/arch/arm/plat-mxc/include/mach/debug-macro.S b/arch/arm/plat-mxc/include/mach/debug-macro.S
index 2560640..ac8a2bf 100644
--- a/arch/arm/plat-mxc/include/mach/debug-macro.S
+++ b/arch/arm/plat-mxc/include/mach/debug-macro.S
@@ -49,7 +49,7 @@
 #ifdef UART_PADDR
 #error "CONFIG_DEBUG_LL is incompatible with multiple archs"
 #endif
-#include <mach/mx51.h>
+#include <mach/mx5x.h>
 #define UART_PADDR	MX51_UART1_BASE_ADDR
 #define UART_VADDR	MX51_AIPS1_IO_ADDRESS(MX51_UART1_BASE_ADDR)
 #endif
diff --git a/arch/arm/plat-mxc/include/mach/hardware.h b/arch/arm/plat-mxc/include/mach/hardware.h
index ebadf4a..5a7395a 100644
--- a/arch/arm/plat-mxc/include/mach/hardware.h
+++ b/arch/arm/plat-mxc/include/mach/hardware.h
@@ -28,7 +28,7 @@
 	 (addr) - (module ## _BASE_ADDR) + (module ## _BASE_ADDR_VIRT) : 0))
 
 #ifdef CONFIG_ARCH_MX5
-#include <mach/mx51.h>
+#include <mach/mx5x.h>
 #endif
 
 #ifdef CONFIG_ARCH_MX3
diff --git a/arch/arm/plat-mxc/include/mach/mx51.h b/arch/arm/plat-mxc/include/mach/mx5x.h
similarity index 100%
rename from arch/arm/plat-mxc/include/mach/mx51.h
rename to arch/arm/plat-mxc/include/mach/mx5x.h
-- 
1.6.0.4


