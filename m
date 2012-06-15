Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087Ab2FOSJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 14:09:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49976 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756906Ab2FOSJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 14:09:35 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: core: Actually use the data in _notifier_call_chain()
Date: Fri, 15 Jun 2012 19:09:33 +0100
Message-Id: <1339783773-18788-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index a2c5cfb..770f08e 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2690,7 +2690,7 @@ static void _notifier_call_chain(struct regulator_dev *rdev,
 				  unsigned long event, void *data)
 {
 	/* call rdev chain first */
-	blocking_notifier_call_chain(&rdev->notifier, event, NULL);
+	blocking_notifier_call_chain(&rdev->notifier, event, data);
 }
 
 /**
-- 
1.7.10

