Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758496Ab1E0IFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 04:05:24 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:56907 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092Ab1E0IFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 04:05:19 -0400
X-AuditID: cbfee61a-b7ce2ae000001a8f-61-4ddf5b3dc60a
Date: Fri, 27 May 2011 17:04:49 +0900
From: Donggeun Kim <dg77.kim@samsung.com>
Subject: [PATCH] CPUFREQ/S5PV210,EXYNOS4: Add Kconfig options for S5PV210 and
 EXYNOS4 CPUfreq drivers
In-reply-to: <1306476428-24808-1-git-send-email-dg77.kim@samsung.com>
To: davej@redhat.com, kgene.kim@samsung.com
Cc: cpufreq@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com
Message-id: <1306483489-10432-1-git-send-email-dg77.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
References: <1306476428-24808-1-git-send-email-dg77.kim@samsung.com>
X-OriginalArrivalTime: 27 May 2011 08:05:15.0593 (UTC)
 FILETIME=[CFC32B90:01CC1C44]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds CONFIG_CPU_FREQ_S5PV210 and CONFIG_CPU_FREQ_EXYNOS4
to the machine Kconfig files.

Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos4/Kconfig |    7 +++++++
 arch/arm/mach-s5pv210/Kconfig |    7 +++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-exynos4/Kconfig b/arch/arm/mach-exynos4/Kconfig
index e849f67..123e5e2 100644
--- a/arch/arm/mach-exynos4/Kconfig
+++ b/arch/arm/mach-exynos4/Kconfig
@@ -91,6 +91,13 @@ config EXYNOS4_SETUP_FIMC
 	help
 	  Common setup code for the camera interfaces.
 
+config CPU_FREQ_EXYNOS4
+	bool
+	depends on CPU_FREQ && ARCH_EXYNOS4
+	default y
+	help
+	  This enabls the CPUfreq driver for EXYNOS4.
+
 # machine support
 
 menu "EXYNOS4 Machines"
diff --git a/arch/arm/mach-s5pv210/Kconfig b/arch/arm/mach-s5pv210/Kconfig
index 37b5a97..376e824 100644
--- a/arch/arm/mach-s5pv210/Kconfig
+++ b/arch/arm/mach-s5pv210/Kconfig
@@ -59,6 +59,13 @@ config S5PV210_SETUP_FIMC
 	help
 	  Common setup code for the camera interfaces.
 
+config CPU_FREQ_S5PV210
+	bool
+	depends on CPU_FREQ && CPU_S5PV210
+	default y
+	help
+	  This enabls the CPUfreq driver for S5PV210.
+
 menu "S5PC110 Machines"
 
 config MACH_AQUILA
-- 
1.7.4.1

