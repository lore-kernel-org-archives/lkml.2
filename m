Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab1FUCHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 22:07:36 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22030 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab1FUCHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 22:07:33 -0400
X-AuditID: cbfee61a-b7c59ae000003b70-c9-4dfffcd357b3
Date: Tue, 21 Jun 2011 11:07:12 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v2 3/4] Exynos4 NURI: configure ADC.
In-reply-to: <1308622033-2521-1-git-send-email-myungjoo.ham@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        myungjoo.ham@gmail.com, dg77.kim@samsung.com
Message-id: <1308622033-2521-4-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
References: <20110620103124.GD31864@opensource.wolfsonmicro.com>
 <1308622033-2521-1-git-send-email-myungjoo.ham@samsung.com>
X-OriginalArrivalTime: 21 Jun 2011 02:06:38.0224 (UTC)
 FILETIME=[DABCF900:01CC2FB7]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos4/mach-nuri.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-exynos4/mach-nuri.c b/arch/arm/mach-exynos4/mach-nuri.c
index 25b9bcb..51f55b4 100644
--- a/arch/arm/mach-exynos4/mach-nuri.c
+++ b/arch/arm/mach-exynos4/mach-nuri.c
@@ -29,6 +29,7 @@
 #include <asm/mach/arch.h>
 #include <asm/mach-types.h>
 
+#include <plat/adc.h>
 #include <plat/regs-serial.h>
 #include <plat/exynos4.h>
 #include <plat/cpu.h>
@@ -1017,6 +1018,7 @@ static struct platform_device *nuri_devices[] __initdata = {
 	&s3c_device_i2c3,
 	&s3c_device_i2c5,
 	&i2c9_gpio,
+	&s3c_device_adc,
 
 	/* NURI Devices */
 	&nuri_gpio_keys,
-- 
1.7.4.1

