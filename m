Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569Ab2CZNq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 09:46:27 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33422 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932456Ab2CZNo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 09:44:59 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH v2 3/5] spi: omap2-mcspi: convert to module_platform_driver
Date: Mon, 26 Mar 2012 19:14:38 +0530
Message-ID: <1332769480-28069-4-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1332769480-28069-1-git-send-email-shubhrajyoti@ti.com>
References: <1332769480-28069-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <balbi@ti.com>

this will delete a few lines of code, no functional
changes.

Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/spi/spi-omap2-mcspi.c |   15 +--------------
 1 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 26dd79f..66cbf22 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1324,18 +1324,5 @@ static struct platform_driver omap2_mcspi_driver = {
 	.remove =	__devexit_p(omap2_mcspi_remove),
 };
 
-
-static int __init omap2_mcspi_init(void)
-{
-	return platform_driver_register(&omap2_mcspi_driver);
-}
-subsys_initcall(omap2_mcspi_init);
-
-static void __exit omap2_mcspi_exit(void)
-{
-	platform_driver_unregister(&omap2_mcspi_driver);
-
-}
-module_exit(omap2_mcspi_exit);
-
+module_platform_driver(omap2_mcspi_driver);
 MODULE_LICENSE("GPL");
-- 
1.7.1

