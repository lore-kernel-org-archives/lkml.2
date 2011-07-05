Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab1GEUVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 16:21:54 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:32850 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab1GEUVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 16:21:52 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>, ben-linux@fluff.org,
        khali@linux-fr.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] i2c: tegra: Use engineering names in DT compatible property
Date: Tue,  5 Jul 2011 14:21:46 -0600
Message-Id: <1309897306-22953-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Engineering names are more stable than marketing names. Hence, use them
for Device Tree compatible properties instead.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
Grant, this is against devicetree/arm and also makes sense for
devicetree/test.

 drivers/i2c/busses/i2c-tegra.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 8914bd1..99b1b6d 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -716,7 +716,7 @@ static int tegra_i2c_resume(struct platform_device *pdev)
 #if defined(CONFIG_OF)
 /* Match table for of_platform binding */
 static const struct of_device_id tegra_i2c_of_match[] __devinitconst = {
-	{ .compatible = "nvidia,tegra250-i2c", },
+	{ .compatible = "nvidia,tegra20-i2c", },
 	{},
 };
 MODULE_DEVICE_TABLE(of, tegra_i2c_of_match);
-- 
1.7.0.4

