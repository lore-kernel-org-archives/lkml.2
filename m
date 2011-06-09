Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab1FIPWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 11:22:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58897 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752525Ab1FIPW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 11:22:26 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/3] regulator: Increase the limit on sysfs file names
Date: Thu,  9 Jun 2011 16:22:20 +0100
Message-Id: <1307632942-667-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With verbose filenames we can easily hit 32 characters.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 53e46ee..d2d5001 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1035,7 +1035,7 @@ static void unset_regulator_supplies(struct regulator_dev *rdev)
 	}
 }
 
-#define REG_STR_SIZE	32
+#define REG_STR_SIZE	64
 
 static struct regulator *create_regulator(struct regulator_dev *rdev,
 					  struct device *dev,
-- 
1.7.5.3

