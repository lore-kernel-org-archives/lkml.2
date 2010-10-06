Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734Ab0JFHnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 03:43:22 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6374 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758684Ab0JFHnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 03:43:18 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6127"; a="56883650"
X-IronPort-AV: E=Sophos;i="4.57,287,1283756400"; 
   d="scan'208";a="88852287"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Steve Muckle <smuckle@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>
Subject: [PATCH 03/20 v2] msm: initial irq definitions for MSM8X60
Date: Wed,  6 Oct 2010 00:42:42 -0700
Message-Id: <1286350979-19328-4-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1286350979-19328-1-git-send-email-johlstei@codeaurora.org>
References: <1286350979-19328-1-git-send-email-johlstei@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve Muckle <smuckle@codeaurora.org>

IRQ assignments are different for MSM8X60 than other existing MSMs.

Signed-off-by: Steve Muckle <smuckle@codeaurora.org>
---
 arch/arm/mach-msm/include/mach/irqs-8x60.h |   43 ++++++++++++++++++++++++++++
 arch/arm/mach-msm/include/mach/irqs.h      |    2 +
 2 files changed, 45 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-msm/include/mach/irqs-8x60.h

diff --git a/arch/arm/mach-msm/include/mach/irqs-8x60.h b/arch/arm/mach-msm/include/mach/irqs-8x60.h
new file mode 100644
index 0000000..9fae253
--- /dev/null
+++ b/arch/arm/mach-msm/include/mach/irqs-8x60.h
@@ -0,0 +1,43 @@
+/* Copyright (c) 2010 Code Aurora Forum. All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *     * Redistributions of source code must retain the above copyright
+ *       notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above copyright
+ *       notice, this list of conditions and the following disclaimer in the
+ *       documentation and/or other materials provided with the distribution.
+ *     * Neither the name of Code Aurora nor
+ *       the names of its contributors may be used to endorse or promote
+ *       products derived from this software without specific prior written
+ *       permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
+ * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
+ * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
+ * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
+ * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
+ * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
+ * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
+ * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+
+#ifndef __ASM_ARCH_MSM_IRQS_8X60_H
+#define __ASM_ARCH_MSM_IRQS_8X60_H
+
+/* MSM ACPU Interrupt Numbers */
+
+/* 0-15:  STI/SGI (software triggered/generated interrupts)
+ * 16-31: PPI (private peripheral interrupts)
+ * 32+:   SPI (shared peripheral interrupts)
+ */
+
+#define NR_GPIO_IRQS 173
+#define NR_MSM_IRQS 256
+#define NR_BOARD_IRQS 0
+
+#endif
diff --git a/arch/arm/mach-msm/include/mach/irqs.h b/arch/arm/mach-msm/include/mach/irqs.h
index 164d355..8679a45 100644
--- a/arch/arm/mach-msm/include/mach/irqs.h
+++ b/arch/arm/mach-msm/include/mach/irqs.h
@@ -24,6 +24,8 @@
 #elif defined(CONFIG_ARCH_QSD8X50)
 #include "irqs-8x50.h"
 #include "sirc.h"
+#elif defined(CONFIG_ARCH_MSM8X60)
+#include "irqs-8x60.h"
 #elif defined(CONFIG_ARCH_MSM_ARM11)
 #include "irqs-7x00.h"
 #else
-- 
1.7.2.1

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
