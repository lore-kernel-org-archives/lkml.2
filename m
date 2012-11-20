Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab2KTNXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 08:23:41 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36763 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab2KTNXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 08:23:40 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: arm@kernel.org
Cc: josh.cartwright@ni.com, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: zynq: Remove all unused mach headers
Date: Tue, 20 Nov 2012 14:23:37 +0100
Message-Id: <1353417817-15513-1-git-send-email-michal.simek@xilinx.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove empty unused mach/hardware.h.
mach/irqs.h is unused because SPARSE_IRQ are ON by default.
mach/timex.h is unused because of CONFIG_ARCH_MULTIPLATFORM.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>

---
Based on Josh multiplatform patches.
http://git.xilinx.com/?p=linux-xlnx.git;a=shortlog;h=refs/heads/arm-next
---
 arch/arm/mach-zynq/include/mach/hardware.h |   18 ------------------
 arch/arm/mach-zynq/include/mach/irqs.h     |   21 ---------------------
 arch/arm/mach-zynq/include/mach/timex.h    |   23 -----------------------
 3 files changed, 0 insertions(+), 62 deletions(-)
 delete mode 100644 arch/arm/mach-zynq/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-zynq/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-zynq/include/mach/timex.h

diff --git a/arch/arm/mach-zynq/include/mach/hardware.h b/arch/arm/mach-zynq/include/mach/hardware.h
deleted file mode 100644
index d558d8a..0000000
--- a/arch/arm/mach-zynq/include/mach/hardware.h
+++ /dev/null
@@ -1,18 +0,0 @@
-/* arch/arm/mach-zynq/include/mach/hardware.h
- *
- *  Copyright (C) 2011 Xilinx
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#ifndef __MACH_HARDWARE_H__
-#define __MACH_HARDWARE_H__
-
-#endif
diff --git a/arch/arm/mach-zynq/include/mach/irqs.h b/arch/arm/mach-zynq/include/mach/irqs.h
deleted file mode 100644
index 5fb04fd..0000000
--- a/arch/arm/mach-zynq/include/mach/irqs.h
+++ /dev/null
@@ -1,21 +0,0 @@
-/* arch/arm/mach-zynq/include/mach/irqs.h
- *
- *  Copyright (C) 2011 Xilinx
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#ifndef __MACH_IRQS_H
-#define __MACH_IRQS_H
-
-#define ARCH_NR_GPIOS	118
-#define NR_IRQS		(128 + ARCH_NR_GPIOS)
-
-#endif
diff --git a/arch/arm/mach-zynq/include/mach/timex.h b/arch/arm/mach-zynq/include/mach/timex.h
deleted file mode 100644
index 6c0245e..0000000
--- a/arch/arm/mach-zynq/include/mach/timex.h
+++ /dev/null
@@ -1,23 +0,0 @@
-/* arch/arm/mach-zynq/include/mach/timex.h
- *
- *  Copyright (C) 2011 Xilinx
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#ifndef __MACH_TIMEX_H__
-#define __MACH_TIMEX_H__
-
-/* the following is needed for the system to build but will be removed
-   in the future, the value is not important but won't hurt
-*/
-#define CLOCK_TICK_RATE	(100 * HZ)
-
-#endif
-- 
1.7.0.4

