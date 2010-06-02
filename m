Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912Ab0FBLiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 07:38:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62310 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab0FBLio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 07:38:44 -0400
From: Thomas Weber <weber@corscience.de>
To: linux-omap@vger.kernel.org
Cc: Thomas Weber <weber@corscience.de>, Tony Lindgren <tony@atomide.com>,
       Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2 02/11] OMAP2: Devkit8000: change panel to generic panel
Date: Wed,  2 Jun 2010 13:37:42 +0200
Message-Id: <1275478671-24563-3-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275478671-24563-1-git-send-email-weber@corscience.de>
References: <1275478671-24563-1-git-send-email-weber@corscience.de>
X-Provags-ID: V01U2FsdGVkX1/OIMj3FKzz80Fjky5vxHdjyCUJ6TOWmWPJTMf
 W+AwXqDc+6/URmkdAbIlayI7dx51R9dOOYtSRgzkE+r27blPk/
 wyRBPLSV+h1+Yt9Y7ZOYQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Choose the generic panel for lcd code of Devkit8000.

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 arch/arm/mach-omap2/board-devkit8000.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
index 08a2a01..3bde0e6 100644
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@ -175,7 +175,7 @@ static struct regulator_consumer_supply devkit8000_vio_supplies[] = {
 
 static struct omap_dss_device devkit8000_lcd_device = {
 	.name                   = "lcd",
-	.driver_name            = "innolux_at_panel",
+	.driver_name            = "generic_panel",
 	.type                   = OMAP_DISPLAY_TYPE_DPI,
 	.phy.dpi.data_lines     = 24,
 	.platform_enable        = devkit8000_panel_enable_lcd,
-- 
1.7.1

