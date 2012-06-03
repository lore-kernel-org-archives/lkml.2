Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab2FCJCh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 05:02:37 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:10161 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406Ab2FCJCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 05:02:35 -0400
X-AuditID: cbfee61a-b7f996d000000ec4-f7-4fcb2829a07b
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, grant.likely@secretlab.ca
Subject: [PATCH] gpio: samsung: fix typo in name of exynos5 gpio chip list
Date: Sun, 03 Jun 2012 14:47:40 +0530
Message-id: <1338715060-20420-1-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLJMWRmVeSWpSXmKPExsVy+t9jAV0tjdP+BneXMVtc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGU0znvPWHCFreJl72P2BsYjrF2MnBwSAiYSFw59YYew
	xSQu3FvP1sXIxSEksIhR4u+7DUwgCSGBNiaJ591CIDabgIHEo4XvwBpEBJwlbn/4xgJiMwMN
	mrPuHpgtLOAl8enwPLBeFgFViRvXvgMt4+DgFfCUePuQCWKXksSG3qNMExi5FzAyrGIUTS1I
	LihOSs811CtOzC0uzUvXS87P3cQI9uQzqR2MKxssDjEKcDAq8fBK7DvlL8SaWFZcmXuIUYKD
	WUmEV2wxUIg3JbGyKrUoP76oNCe1+BCjNAeLkjiv3eId/kIC6YklqdmpqQWpRTBZJg5OqQbG
	KY/LkhVU2K4xXWCYPIVbKdhXvy3R8Gl7SEh+xD2924a/PXs6LrKuPzj/T4yT6Oxn2ppKNx75
	5DW7tau5cQT1Lb3y597rE7anN0WybDo27/j3dabGLUX2V84EKzwN1V7+alLB6mXvWY9efrxh
	Qidf1b/m6XOm821+IvEtgakvU7DaXfiq5IR9SizFGYmGWsxFxYkAxmRg0+ABAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 30b842889eea ("Merge tag 'soc2' of git://git.kernel.org/pub/scm/
linux/kernel/git/arm/arm-soc) introduced a typo in the name of the list
of gpio chips for Exynos5 gpio controller. Fix this typo.

Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
---
 drivers/gpio/gpio-samsung.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
index 7bb0044..b6453d0 100644
--- a/drivers/gpio/gpio-samsung.c
+++ b/drivers/gpio/gpio-samsung.c
@@ -2833,7 +2833,7 @@ static __init void exynos5_gpiolib_init(void)
 	}
 
 	/* need to set base address for gpc4 */
-	exonys5_gpios_1[11].base = gpio_base1 + 0x2E0;
+	exynos5_gpios_1[11].base = gpio_base1 + 0x2E0;
 
 	/* need to set base address for gpx */
 	chip = &exynos5_gpios_1[21];
-- 
1.6.6.rc2

