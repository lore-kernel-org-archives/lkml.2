Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab0HYE70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 00:59:26 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17531 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab0HYE60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 00:58:26 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6084"; a="52012269"
X-IronPort-AV: E=Sophos;i="4.56,265,1280732400"; 
   d="scan'208";a="72366149"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Daniel Walker <dwalker@codeaurora.org>,
        Steve Muckle <smuckle@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Gregory Bean <gbean@codeaurora.org>,
        Brian Swetland <swetland@google.com>,
        Jeff Ohlstein <johlstei@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Subject: [PATCH 19/24] msm: add msm8x60_surf machine
Date: Tue, 24 Aug 2010 21:57:48 -0700
Message-Id: <1282712273-344-20-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1282712273-344-1-git-send-email-johlstei@codeaurora.org>
References: <1282712273-344-1-git-send-email-johlstei@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve Muckle <smuckle@codeaurora.org>

Signed-off-by: Steve Muckle <smuckle@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig         |    7 +++++++
 arch/arm/mach-msm/Makefile        |    1 +
 arch/arm/mach-msm/board-msm8x60.c |    7 +++++++
 3 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index dfa67d8..3017e12 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -98,6 +98,13 @@ config MACH_MSM8X60_RUMI3
 	help
 	  Support for the Qualcomm MSM8x60 RUMI3 emulator.
 
+config MACH_MSM8X60_SURF
+	depends on ARCH_MSM8X60
+	default n
+	bool "MSM8x60 SURF"
+	help
+	  Support for the Qualcomm MSM8x60 SURF eval board.
+
 endmenu
 
 config MSM_DEBUG_UART
diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 17c03fa..1d62025 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -28,3 +28,4 @@ obj-$(CONFIG_ARCH_QSD8X50) += gpiomux-8x50.o gpiomux-7x00.o
 obj-$(CONFIG_ARCH_MSM8X60) += gpiomux-8x60.o
 obj-$(CONFIG_HOTPLUG_CPU)        += hotplug.o
 obj-$(CONFIG_MACH_MSM8X60_RUMI3) += board-msm8x60.o
+obj-$(CONFIG_MACH_MSM8X60_SURF) += board-msm8x60.o
diff --git a/arch/arm/mach-msm/board-msm8x60.c b/arch/arm/mach-msm/board-msm8x60.c
index e2e5a5c..fd953c2 100644
--- a/arch/arm/mach-msm/board-msm8x60.c
+++ b/arch/arm/mach-msm/board-msm8x60.c
@@ -78,3 +78,10 @@ MACHINE_START(MSM8X60_RUMI3, "QCT MSM8X60 RUMI3")
 	.init_machine = msm8x60_init,
 	.timer = &msm_timer,
 MACHINE_END
+
+MACHINE_START(MSM8X60_SURF, "QCT MSM8X60 SURF")
+	.map_io = msm8x60_map_io,
+	.init_irq = msm8x60_init_irq,
+	.init_machine = msm8x60_init,
+	.timer = &msm_timer,
+MACHINE_END
-- 
1.7.2.1

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
