Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab0KIPS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 10:18:26 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:42870 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751838Ab0KIPSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 10:18:24 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 10/11] hwmon: applesmc: Silence driver
Date: Tue,  9 Nov 2010 16:15:10 +0100
Message-Id: <1289315711-3011-11-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289315711-3011-1-git-send-email-rydberg@euromail.se>
References: <1289315711-3011-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1PFpx0-0004HS-5r.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PFpx0-0004HS-5r 1db2e6a8b99d15ff671270c27a16ccdb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the driver report a single line on success.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hwmon/applesmc.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index b907c20..576dcb4 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -1270,8 +1270,6 @@ static int __init applesmc_init(void)
 		goto out_light_ledclass;
 	}
 
-	pr_info("driver successfully loaded\n");
-
 	return 0;
 
 out_light_ledclass:
@@ -1312,8 +1310,6 @@ static void __exit applesmc_exit(void)
 	platform_device_unregister(pdev);
 	platform_driver_unregister(&applesmc_driver);
 	release_region(APPLESMC_DATA_PORT, APPLESMC_NR_PORTS);
-
-	pr_info("driver unloaded\n");
 }
 
 module_init(applesmc_init);
-- 
1.7.1

