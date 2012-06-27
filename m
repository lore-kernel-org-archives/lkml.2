Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab2F0OKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 10:10:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57106 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756682Ab2F0OKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 10:10:18 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 4/4] regulator: wm831x-ldo: Specify enable time for alive LDO
Date: Wed, 27 Jun 2012 15:10:12 +0100
Message-Id: <1340806212-30457-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340806212-30457-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1340806212-30457-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm831x-ldo.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
index 04d8a41..5cb70ca 100644
--- a/drivers/regulator/wm831x-ldo.c
+++ b/drivers/regulator/wm831x-ldo.c
@@ -701,6 +701,7 @@ static __devinit int wm831x_alive_ldo_probe(struct platform_device *pdev)
 	ldo->desc.enable_mask = 1 << id;
 	ldo->desc.min_uV = 800000;
 	ldo->desc.uV_step = 50000;
+	ldo->desc.enable_time = 1000;
 
 	config.dev = pdev->dev.parent;
 	if (pdata)
-- 
1.7.10

