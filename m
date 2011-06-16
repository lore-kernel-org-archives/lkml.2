Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab1FPIdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 04:33:08 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:54478 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab1FPIdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 04:33:06 -0400
X-AuditID: cbfee61b-b7c62ae0000056ed-be-4df9bfc0a4ff
Date: Thu, 16 Jun 2011 17:33:04 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH] Samsung SoC ADC: register address definition for
 S5PV210/S5PC110/Exynos4
In-reply-to: <1308213003-6526-2-git-send-email-myungjoo.ham@samsung.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com,
        dg77.kim@samsung.com
Message-id: <1308213184-6607-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
References: <1308213003-6526-2-git-send-email-myungjoo.ham@samsung.com>
X-OriginalArrivalTime: 16 Jun 2011 08:32:52.0567 (UTC)
 FILETIME=[FBA85670:01CC2BFF]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ADCMUX register is added.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/plat-samsung/include/plat/regs-adc.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-samsung/include/plat/regs-adc.h b/arch/arm/plat-samsung/include/plat/regs-adc.h
index 7554c4f..035e8c3 100644
--- a/arch/arm/plat-samsung/include/plat/regs-adc.h
+++ b/arch/arm/plat-samsung/include/plat/regs-adc.h
@@ -21,6 +21,7 @@
 #define S3C2410_ADCDAT1	   S3C2410_ADCREG(0x10)
 #define S3C64XX_ADCUPDN		S3C2410_ADCREG(0x14)
 #define S3C64XX_ADCCLRINT	S3C2410_ADCREG(0x18)
+#define S5P_ADCMUX		S3C2410_ADCREG(0x1C)
 #define S3C64XX_ADCCLRINTPNDNUP	S3C2410_ADCREG(0x20)
 
 
-- 
1.7.4.1

