Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759523Ab2CTKaQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 06:30:16 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39741 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab2CTKaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 06:30:10 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH 2/3] spi: omap2-mcspi: convert to module_platform_driver
Date: Tue, 20 Mar 2012 15:59:48 +0530
Message-ID: <1332239389-1897-3-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1332239389-1897-1-git-send-email-shubhrajyoti@ti.com>
References: <1332239389-1897-1-git-send-email-shubhrajyoti@ti.com>
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
index 5f4419e..7745f91 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1291,18 +1291,5 @@ static struct platform_driver omap2_mcspi_driver = {
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

