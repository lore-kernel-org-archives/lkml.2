Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab2KSIYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 03:24:21 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19675 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab2KSIYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 03:24:19 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 19 Nov 2012 00:24:18 -0800
From: Sivaram Nair <sivaramn@nvidia.com>
To: <a.zummo@towertech.it>, <linux-tegra@vger.kernel.org>
CC: <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>,
        Sivaram Nair <sivaramn@nvidia.com>
Subject: [PATCH 1/1] rtc: tps65910: renaming irq to match device
Date: Mon, 19 Nov 2012 10:23:33 +0200
Message-ID: <1353313413-17382-1-git-send-email-sivaramn@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cosmetic change to rename the irq name to match the device
name.

Signed-off-by: Sivaram Nair <sivaramn@nvidia.com>
---
 drivers/rtc/rtc-tps65910.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-tps65910.c b/drivers/rtc/rtc-tps65910.c
index 7a82337..e8d44bc 100644
--- a/drivers/rtc/rtc-tps65910.c
+++ b/drivers/rtc/rtc-tps65910.c
@@ -261,7 +261,7 @@ static int __devinit tps65910_rtc_probe(struct platform_device *pdev)
 
 	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
 		tps65910_rtc_interrupt, IRQF_TRIGGER_LOW,
-		"rtc-tps65910", &pdev->dev);
+		dev_name(&pdev->dev), &pdev->dev);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "IRQ is not free.\n");
 		return ret;
-- 
1.7.9.5

