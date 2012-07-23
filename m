Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab2GWKRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 06:17:14 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:8607 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab2GWKRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 06:17:12 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-66-500d24a5bc0a
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH] devfreq: exynos4: Fix Kconfig option of
 CONFIG_ARM_EXYNOS4_BUS_DEVFREQ
Date: Mon, 23 Jul 2012 19:16:54 +0900
Message-id: <1343038614-18162-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFJMWRmVeSWpSXmKPExsVy+t9jQd2lKrwBBg+3a1lc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MbUuvMRYcY614NTG6gfESSxcjJ4eEgInEws6V7BC2mMSFe+vZ
	uhi5OIQEpjNKnGu4xQzhLGWS+DKtmwmkik1AR+L/vptgHSICChKbe5+xghQxCzQxSny9spoR
	JCEsECnx8dBEVhCbRUBV4szJPcwgNq+Ah8TnbTuh1ilILLj3lm0CI/cCRoZVjKKpBckFxUnp
	uUZ6xYm5xaV56XrJ+bmbGME+fCa9g3FVg8UhRgEORiUe3oflPAFCrIllxZW5hxglOJiVRHgv
	X+cOEOJNSaysSi3Kjy8qzUktPsQozcGiJM5r4v3VX0ggPbEkNTs1tSC1CCbLxMEp1cA4+9c+
	/vINb2aad6kI+Vdl5GycozbX/sHhpF/f938MMHkYzcZbKSRkeXxyxZeWntV6kWy7+gym/mxW
	jJn98NfcpNu31pVermHMXZQV3Lkgyn/KhuCuJTM1uvUPBFgWObS/nnFh9qL5QryTDx1e/KQh
	vsx8efClo69XSVtzGm+KPRA2W/FmdWmQEktxRqKhFnNRcSIAzMmpTN0BAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes typo in devfreq's Kconfig.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 drivers/devfreq/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
index 464fa21..5900267 100644
--- a/drivers/devfreq/Kconfig
+++ b/drivers/devfreq/Kconfig
@@ -67,7 +67,7 @@ comment "DEVFREQ Drivers"
 
 config ARM_EXYNOS4_BUS_DEVFREQ
 	bool "ARM Exynos4210/4212/4412 Memory Bus DEVFREQ Driver"
-	depends on CPU_EXYNOS4210 || CPU_EXYNOS4212 || CPU_EXYNOS4412
+	depends on CPU_EXYNOS4210 || SOC_EXYNOS4212 || SOC_EXYNOS4412
 	select ARCH_HAS_OPP
 	select DEVFREQ_GOV_SIMPLE_ONDEMAND
 	help
-- 
1.7.4.1

