Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab2ITF5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 01:57:17 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4888 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab2ITF5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 01:57:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 19 Sep 2012 22:48:29 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <akpm@linux-foundation.org>, <a.zummo@towertech.it>
CC: <linux-kernel@vger.kernel.org>, <rtc-linux@googlegroups.com>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH] rtc: tps65910: Changing RTC driver name as per mfd
Date: Thu, 20 Sep 2012 11:26:48 +0530
Message-ID: <1348120608-27697-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As TPS65910 mfd uses "tps65910-rtc" as driver name, changing
driver name in the RTC driver to match with the same.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 drivers/rtc/rtc-tps65910.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-tps65910.c b/drivers/rtc/rtc-tps65910.c
index 691ab96..7c4ca86 100644
--- a/drivers/rtc/rtc-tps65910.c
+++ b/drivers/rtc/rtc-tps65910.c
@@ -341,7 +341,7 @@ static struct platform_driver tps65910_rtc_driver = {
 	.remove		= __devexit_p(tps65910_rtc_remove),
 	.driver		= {
 		.owner	= THIS_MODULE,
-		.name	= "rtc-tps65910",
+		.name	= "tps65910-rtc",
 		.pm	= DEV_PM_OPS,
 	},
 };
-- 
1.7.1.1

