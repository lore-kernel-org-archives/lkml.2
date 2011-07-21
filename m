Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab1GUKZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 06:25:41 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53038 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab1GUKZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 06:25:39 -0400
X-AuditID: cbfee61a-b7cf0ae000006bc6-22-4e27fea114ff
Date: Thu, 21 Jul 2011 19:26:04 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH] ARM: EXYNOS4: Update config file of NURI to enable RTC
To: Kukjin Kim <kgene.kim@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <4E27FEBC.7050302@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
X-OriginalArrivalTime: 21 Jul 2011 10:26:00.0835 (UTC)
 FILETIME=[963D1530:01CC4790]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch update config file of NURI board to enable RTC

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos4/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-exynos4/Kconfig b/arch/arm/mach-exynos4/Kconfig
index b735705..bb675fb 100644
--- a/arch/arm/mach-exynos4/Kconfig
+++ b/arch/arm/mach-exynos4/Kconfig
@@ -184,6 +184,7 @@ config MACH_NURI
 	bool "Mobile NURI Board"
 	select CPU_EXYNOS4210
 	select S3C_DEV_WDT
+	select S3C_DEV_RTC
 	select S3C_DEV_HSMMC
 	select S3C_DEV_HSMMC2
 	select S3C_DEV_HSMMC3
-- 
1.7.0.4

