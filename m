Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab1BBUR0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 15:17:26 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57596 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752470Ab1BBURZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 15:17:25 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Fix warning with CONFIG_BUG disabled
Date: Wed,  2 Feb 2011 20:17:22 +0000
Message-Id: <1296677842-26867-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm831x-dcdc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index 8b0d2c4..06df898 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -120,6 +120,7 @@ static unsigned int wm831x_dcdc_get_mode(struct regulator_dev *rdev)
 		return REGULATOR_MODE_IDLE;
 	default:
 		BUG();
+		return -EINVAL;
 	}
 }
 
-- 
1.7.2.3

