Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab0GWNik (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 09:38:40 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40425 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab0GWNii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 09:38:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=ZxctlAu47hBPNxA+aN84svd8Sgbrcbp05nd035uUN7GV5PGjLTYMzsgW/DLU/58slu
         BZI2C/qRGgypsZG+9Di24SmRckVn8TptOi+tPz+7kjj7EUn66/ybxRIL9RPdTroUfMlO
         ftZ/IvPuWtuXKLxSvkH+a7kYYCuN6341mjAiU=
Message-ID: <4C499B53.5090400@gmail.com>
Date: Fri, 23 Jul 2010 21:38:27 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] ARM/nuc900: patch for adding the global control registers
 definition
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to add the global control registers definition,
many drivers need it, such as usb driver,I need it to control
usb phy open or close, so I sent this patch.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

---
 arch/arm/mach-w90x900/include/mach/regs-gcr.h |   39 +++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-w90x900/include/mach/regs-gcr.h

diff --git a/arch/arm/mach-w90x900/include/mach/regs-gcr.h b/arch/arm/mach-w90x900/include/mach/regs-gcr.h
new file mode 100644
index 0000000..6087abd
--- /dev/null
+++ b/arch/arm/mach-w90x900/include/mach/regs-gcr.h
@@ -0,0 +1,39 @@
+/*
+ * arch/arm/mach-w90x900/include/mach/regs-gcr.h
+ *
+ * Copyright (c) 2010 Nuvoton technology corporation
+ * All rights reserved.
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#ifndef __ASM_ARCH_REGS_GCR_H
+#define __ASM_ARCH_REGS_GCR_H
+
+/* Global control registers */
+
+#define GCR_BA		W90X900_VA_GCR
+#define REG_PDID	(GCR_BA+0x000)
+#define REG_PWRON	(GCR_BA+0x004)
+#define REG_ARBCON	(GCR_BA+0x008)
+#define REG_MFSEL	(GCR_BA+0x00C)
+#define REG_EBIDPE	(GCR_BA+0x010)
+#define REG_LCDDPE	(GCR_BA+0x014)
+#define REG_GPIOCPE	(GCR_BA+0x018)
+#define REG_GPIODPE	(GCR_BA+0x01C)
+#define REG_GPIOEPE	(GCR_BA+0x020)
+#define REG_GPIOFPE	(GCR_BA+0x024)
+#define REG_GPIOGPE	(GCR_BA+0x028)
+#define REG_GPIOHPE	(GCR_BA+0x02C)
+#define REG_GPIOIPE	(GCR_BA+0x030)
+#define REG_GTMP1	(GCR_BA+0x034)
+#define REG_GTMP2	(GCR_BA+0x038)
+#define REG_GTMP3	(GCR_BA+0x03C)
+
+#endif /*  __ASM_ARCH_REGS_GCR_H */
-- 
1.6.3.3
