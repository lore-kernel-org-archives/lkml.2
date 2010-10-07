Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab0JGFyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 01:54:51 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57655 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369Ab0JGFyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 01:54:50 -0400
From: Omar Ramirez Luna <omar.ramirez@ti.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        Ernesto Ramos <ernesto@ti.com>,
        Ivan Gomez Castellanos <ivan.gomez@ti.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tidspbridge: bind driver name to device name
Date: Thu,  7 Oct 2010 00:45:10 -0500
Message-Id: <1286430310-20175-1-git-send-email-omar.ramirez@ti.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the device name has changed use the new name to
bind the driver to it.

Signed-off-by: Omar Ramirez Luna <omar.ramirez@ti.com>
---
 drivers/staging/tidspbridge/rmgr/drv_interface.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tidspbridge/rmgr/drv_interface.c b/drivers/staging/tidspbridge/rmgr/drv_interface.c
index 63052b0..1981e46 100644
--- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
+++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
@@ -66,7 +66,6 @@
 #include <mach-omap2/omap3-opp.h>
 #endif
 
-#define BRIDGE_NAME "C6410"
 /*  ----------------------------------- Globals */
 #define DRIVER_NAME  "DspBridge"
 #define DSPBRIDGE_VERSION	"0.3"
@@ -465,7 +464,7 @@ static int BRIDGE_RESUME(struct platform_device *pdev)
 
 static struct platform_driver bridge_driver = {
 	.driver = {
-		   .name = BRIDGE_NAME,
+		   .name = "omap-dsp",
 		   },
 	.probe = omap34_xx_bridge_probe,
 	.remove = __devexit_p(omap34_xx_bridge_remove),
-- 
1.7.1

