Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997Ab1FPIrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 04:47:47 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:16076 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab1FPIrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 04:47:46 -0400
X-AuditID: cbfee61b-b7c62ae0000056ed-57-4df9c330d8b1
Date: Thu, 16 Jun 2011 17:47:44 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH] Samsung SoC: header file revised to prevent declaring
 duplicated.
In-reply-to: <1308213184-6607-1-git-send-email-myungjoo.ham@samsung.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com,
        dg77.kim@samsung.com
Message-id: <1308214064-12796-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
References: <1308213184-6607-1-git-send-email-myungjoo.ham@samsung.com>
X-OriginalArrivalTime: 16 Jun 2011 08:47:31.0883 (UTC)
 FILETIME=[07C54FB0:01CC2C02]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There has been no #ifndef - #define - #endif protection for this header
file. The patch adds it for Exynos4-ADC support

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 arch/arm/plat-samsung/include/plat/devs.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-samsung/include/plat/devs.h b/arch/arm/plat-samsung/include/plat/devs.h
index 4af108f..3c87779 100644
--- a/arch/arm/plat-samsung/include/plat/devs.h
+++ b/arch/arm/plat-samsung/include/plat/devs.h
@@ -12,6 +12,9 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
 */
+#ifndef __PLAT_DEVS_H
+#define __PLAT_DEVS_H __FILE__
+
 #include <linux/platform_device.h>
 
 struct s3c24xx_uart_resources {
@@ -159,3 +162,5 @@ extern struct platform_device s3c_device_ac97;
  */
 extern void *s3c_set_platdata(void *pd, size_t pdsize,
 			      struct platform_device *pdev);
+
+#endif /* __PLAT_DEVS_H */
-- 
1.7.4.1

