Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab0HYE7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 00:59:14 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17518 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab0HYE6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 00:58:23 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6084"; a="52012258"
X-IronPort-AV: E=Sophos;i="4.56,265,1280732400"; 
   d="scan'208";a="72366144"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Daniel Walker <dwalker@codeaurora.org>,
        Jeff Ohlstein <johlstei@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Gregory Bean <gbean@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Subject: [PATCH 14/24] msm: add hotplug stub functions
Date: Tue, 24 Aug 2010 21:57:43 -0700
Message-Id: <1282712273-344-15-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1282712273-344-1-git-send-email-johlstei@codeaurora.org>
References: <1282712273-344-1-git-send-email-johlstei@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Walker <dwalker@codeaurora.org>

We don't actually do anything for hotplug yet. This just lets
everything compile, even when hotplug is enabled.

Signed-off-by: Daniel Walker <dwalker@codeaurora.org>
Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
---
 arch/arm/mach-msm/Makefile  |    1 +
 arch/arm/mach-msm/hotplug.c |   22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-msm/hotplug.c

diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index ff19e01..8a01f8a 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -21,4 +21,5 @@ obj-y += gpiomux.o
 obj-$(CONFIG_ARCH_MSM7X30) += gpiomux-7x30.o gpiomux-7x00.o
 obj-$(CONFIG_ARCH_QSD8X50) += gpiomux-8x50.o gpiomux-7x00.o
 obj-$(CONFIG_ARCH_MSM8X60) += gpiomux-8x60.o
+obj-$(CONFIG_HOTPLUG_CPU)        += hotplug.o
 obj-$(CONFIG_MACH_MSM8X60_RUMI3) += board-msm8x60.o
diff --git a/arch/arm/mach-msm/hotplug.c b/arch/arm/mach-msm/hotplug.c
new file mode 100644
index 0000000..ba0803a
--- /dev/null
+++ b/arch/arm/mach-msm/hotplug.c
@@ -0,0 +1,22 @@
+/*
+ * Do nothing for now.
+ */
+
+int platform_cpu_kill(unsigned int cpu)
+{
+        return 0;
+}
+
+void platform_cpu_die(unsigned int cpu)
+{
+}
+
+int platform_cpu_disable(unsigned int cpu)
+{
+        return 0;
+}
+
+void local_timer_stop(void)
+{
+}
+
-- 
1.7.2.1

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
