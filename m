Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab0HYE6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 00:58:44 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2664 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab0HYE6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 00:58:18 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6084"; a="52012231"
X-IronPort-AV: E=Sophos;i="4.56,265,1280732400"; 
   d="scan'208";a="72366132"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Daniel Walker <dwalker@codeaurora.org>,
        Steve Muckle <smuckle@codeaurora.org>,
        Jeff Ohlstein <johlstei@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 02/24] arm: Kconfig option for ARCH_MSM_SCORPIONMP
Date: Tue, 24 Aug 2010 21:57:31 -0700
Message-Id: <1282712273-344-3-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1282712273-344-1-git-send-email-johlstei@codeaurora.org>
References: <1282712273-344-1-git-send-email-johlstei@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve Muckle <smuckle@codeaurora.org>

ScorpionMP is a configuration of Scorpion processors. It supports local
timers.

Signed-off-by: Steve Muckle <smuckle@codeaurora.org>
Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
---
 arch/arm/Kconfig          |    3 ++-
 arch/arm/mach-msm/Kconfig |    2 ++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 8036e46..d4d9f55 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1173,7 +1173,8 @@ config HOTPLUG_CPU
 config LOCAL_TIMERS
 	bool "Use local timer interrupts"
 	depends on SMP && (REALVIEW_EB_ARM11MP || MACH_REALVIEW_PB11MP || \
-		REALVIEW_EB_A9MP || MACH_REALVIEW_PBX || ARCH_OMAP4 || ARCH_U8500)
+		REALVIEW_EB_A9MP || MACH_REALVIEW_PBX || ARCH_OMAP4 || ARCH_U8500 || \
+		ARCH_MSM_SCORPIONMP)
 	default y
 	select HAVE_ARM_TWD if (ARCH_REALVIEW || ARCH_OMAP4 || ARCH_U8500)
 	help
diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 08ed76c..3b9bece 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -39,6 +39,8 @@ config  ARCH_MSM_ARM11
 	bool
 config  ARCH_MSM_SCORPION
 	bool
+config  ARCH_MSM_SCORPIONMP
+	bool
 
 config  MSM_VIC
 	bool
-- 
1.7.2.1

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
