Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab2FEPQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 11:16:03 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52577 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752632Ab2FEPQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 11:16:01 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Myungjoo Ham <myungjoo.ham@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: max77693: Staticise pm_ops
Date: Tue,  5 Jun 2012 16:15:59 +0100
Message-Id: <1338909359-31380-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They're not referenced outside this file.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/max77693.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index e9e4278..753a0e0 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -215,7 +215,7 @@ static int max77693_resume(struct device *dev)
 	return max77693_irq_resume(max77693);
 }
 
-const struct dev_pm_ops max77693_pm = {
+static const struct dev_pm_ops max77693_pm = {
 	.suspend = max77693_suspend,
 	.resume = max77693_resume,
 };
-- 
1.7.10

