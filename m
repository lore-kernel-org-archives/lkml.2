Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759937Ab2IHBBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 21:01:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46206 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759510Ab2IHBBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 21:01:05 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: arizona: Remove unused variable
Date: Sat,  8 Sep 2012 09:00:59 +0800
Message-Id: <1347066059-11401-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Left over as bitrot from previous changes.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/arizona-irq.c b/drivers/mfd/arizona-irq.c
index a062153..f7886c8 100644
--- a/drivers/mfd/arizona-irq.c
+++ b/drivers/mfd/arizona-irq.c
@@ -95,7 +95,7 @@ static irqreturn_t arizona_irq_thread(int irq, void *data)
 {
 	struct arizona *arizona = data;
 	unsigned int val;
-	int i, ret;
+	int ret;
 
 	ret = pm_runtime_get_sync(arizona->dev);
 	if (ret < 0) {
-- 
1.7.10.4

