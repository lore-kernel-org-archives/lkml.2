Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab1B0QBx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 11:01:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:58560 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463Ab1B0QBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 11:01:50 -0500
From: Guan Xuetao <epip@hera.kernel.org>
To: arnd@arndb.de
Cc: GuanXuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, greg@kroah.com
Subject: [PATCH 09/17] unicore32: rename PKUNITY_IOSPACE_BASE to PKUNITY_MMIO_BASE
Date: Sun, 27 Feb 2011 15:59:37 +0000
Message-Id: <938ce176eba8fdf4ecc41218712cc1dcd80def67.1298821856.git.epip@hera.kernel.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <cover.1298821856.git.epip@hera.kernel.org>
References: <cover.1298821856.git.epip@hera.kernel.org>
In-Reply-To: <cover.1298821856.git.epip@hera.kernel.org>
References: <cover.1298821856.git.epip@hera.kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 27 Feb 2011 16:01:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: GuanXuetao <gxt@mprc.pku.edu.cn>

for the term IOSPACE normally refers to the PCI PIO space
  -- by advice with Arnd Bergmann

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/include/mach/PKUnity.h  |    2 +-
 arch/unicore32/include/mach/hardware.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/unicore32/include/mach/PKUnity.h b/arch/unicore32/include/mach/PKUnity.h
index fa11eba..940e9ed 100644
--- a/arch/unicore32/include/mach/PKUnity.h
+++ b/arch/unicore32/include/mach/PKUnity.h
@@ -21,7 +21,7 @@
  * Memory Definitions
  */
 #define PKUNITY_SDRAM_BASE		0x00000000 /* 0x00000000 - 0x7FFFFFFF 2GB */
-#define PKUNITY_IOSPACE_BASE            0x80000000 /* 0x80000000 - 0xFFFFFFFF 2GB */
+#define PKUNITY_MMIO_BASE		0x80000000 /* 0x80000000 - 0xFFFFFFFF 2GB */
 #define PKUNITY_PCI_BASE		0x80000000 /* 0x80000000 - 0xBFFFFFFF 1GB */
 #include "regs-pci.h"
 #define PKUNITY_BOOT_ROM2_BASE		0xF4000000 /* 0xF4000000 - 0xF7FFFFFF 64MB */
diff --git a/arch/unicore32/include/mach/hardware.h b/arch/unicore32/include/mach/hardware.h
index 3fb7236..c7d3dd6 100644
--- a/arch/unicore32/include/mach/hardware.h
+++ b/arch/unicore32/include/mach/hardware.h
@@ -17,8 +17,8 @@
 
 #include "PKUnity.h"
 
-#define io_p2v(x)	((x) - PKUNITY_IOSPACE_BASE)
-#define io_v2p(x)	((x) + PKUNITY_IOSPACE_BASE)
+#define io_p2v(x)	((x) - PKUNITY_MMIO_BASE)
+#define io_v2p(x)	((x) + PKUNITY_MMIO_BASE)
 
 #ifndef __ASSEMBLY__
 
-- 
1.7.4.1

