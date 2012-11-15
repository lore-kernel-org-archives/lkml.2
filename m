Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768674Ab2KOSWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 13:22:11 -0500
Received: from 81-89-104-214.blue.kundencontroller.de ([81.89.104.214]:35955
	"EHLO tomweber.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768375Ab2KOSWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 13:22:09 -0500
X-Greylist: delayed 569 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Nov 2012 13:22:09 EST
From: Thomas Weber <thomas@tomweber.eu>
To: Tony Lindgren <tony@atomide.com> (maintainer:OMAP SUPPORT)
Cc: Thomas Weber <thomas@tomweber.eu>,
        Russell King <linux@arm.linux.org.uk> (maintainer:ARM PORT),
        linux-omap@vger.kernel.org (open list:OMAP SUPPORT),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM
	SUB-ARCHITECT...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] ARM: OMAP3: Devkit8000: Add DDC i2c_bus_num
Date: Thu, 15 Nov 2012 19:12:03 +0100
Message-Id: <1353003123-7335-1-git-send-email-thomas@tomweber.eu>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add i2c bus number for DVI output.
The driver uses this to detect if a panel is connected and to read EDID.

Signed-off-by: Thomas Weber <thomas@tomweber.eu>
---
 arch/arm/mach-omap2/board-devkit8000.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
index 1fd161e..6f04f0f 100644
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@ -139,6 +139,7 @@ static struct omap_dss_device devkit8000_lcd_device = {
 
 static struct tfp410_platform_data dvi_panel = {
 	.power_down_gpio	= -1,
+	.i2c_bus_num		= 1,
 };
 
 static struct omap_dss_device devkit8000_dvi_device = {
-- 
1.8.0

