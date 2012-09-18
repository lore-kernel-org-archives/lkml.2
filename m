Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab2IRQgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 12:36:47 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55360 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab2IRQga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 12:36:30 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: khilman@ti.com
Cc: tony@atomide.com, linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH] arch/arm/plat-omap/omap-pm-noop.c: Remove unecessary semicolon
Date: Tue, 18 Sep 2012 18:36:13 +0200
Message-Id: <1347986174-30287-6-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347986174-30287-1-git-send-email-peter.senna@gmail.com>
References: <1347986174-30287-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found by http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 arch/arm/plat-omap/omap-pm-noop.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/plat-omap/omap-pm-noop.c b/arch/arm/plat-omap/omap-pm-noop.c
index 5a97b4d..9e01fac 100644
--- a/arch/arm/plat-omap/omap-pm-noop.c
+++ b/arch/arm/plat-omap/omap-pm-noop.c
@@ -38,7 +38,7 @@ int omap_pm_set_max_mpu_wakeup_lat(struct device *dev, long t)
 	if (!dev || t < -1) {
 		WARN(1, "OMAP PM: %s: invalid parameter(s)", __func__);
 		return -EINVAL;
-	};
+	}
 
 	if (t == -1)
 		pr_debug("OMAP PM: remove max MPU wakeup latency constraint: "
@@ -67,7 +67,7 @@ int omap_pm_set_min_bus_tput(struct device *dev, u8 agent_id, unsigned long r)
 	    agent_id != OCP_TARGET_AGENT)) {
 		WARN(1, "OMAP PM: %s: invalid parameter(s)", __func__);
 		return -EINVAL;
-	};
+	}
 
 	if (r == 0)
 		pr_debug("OMAP PM: remove min bus tput constraint: "
@@ -94,7 +94,7 @@ int omap_pm_set_max_dev_wakeup_lat(struct device *req_dev, struct device *dev,
 	if (!req_dev || !dev || t < -1) {
 		WARN(1, "OMAP PM: %s: invalid parameter(s)", __func__);
 		return -EINVAL;
-	};
+	}
 
 	if (t == -1)
 		pr_debug("OMAP PM: remove max device latency constraint: "
@@ -124,7 +124,7 @@ int omap_pm_set_max_sdma_lat(struct device *dev, long t)
 	if (!dev || t < -1) {
 		WARN(1, "OMAP PM: %s: invalid parameter(s)", __func__);
 		return -EINVAL;
-	};
+	}
 
 	if (t == -1)
 		pr_debug("OMAP PM: remove max DMA latency constraint: "
-- 
1.7.11.4

