Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474Ab0FBLl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 07:41:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60734 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab0FBLip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 07:38:45 -0400
From: Thomas Weber <weber@corscience.de>
To: linux-omap@vger.kernel.org
Cc: Thomas Weber <weber@corscience.de>, Tony Lindgren <tony@atomide.com>,
       Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2 05/11] OMAP2: Devkit8000: Remove unneeded VDVI supply
Date: Wed,  2 Jun 2010 13:37:45 +0200
Message-Id: <1275478671-24563-6-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275478671-24563-1-git-send-email-weber@corscience.de>
References: <1275478671-24563-1-git-send-email-weber@corscience.de>
X-Provags-ID: V01U2FsdGVkX18YNxlH2v8oMsHpnleOOxSA8e+PDp7/LE9Msz3
 LKu7vKCt21szsbmYVSzChlr9qE54LPlNNlJl7GzPS9S8YDZ1XL
 iDT3a+28AR6W2Fc+KoghQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VDVI power supply is no longer needed in
board code with the new DSS2 interface.

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 arch/arm/mach-omap2/board-devkit8000.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
index 70552d8..8cc8c3b 100644
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@ -314,10 +314,6 @@ static struct twl4030_gpio_platform_data devkit8000_gpio_data = {
 
 static struct regulator_consumer_supply devkit8000_vpll1_supplies[] = {
 	{
-	.supply		= "vdvi",
-	.dev		= &devkit8000_lcd_device.dev,
-	},
-	{
 	.supply		= "vdds_dsi",
 	.dev		= &devkit8000_dss_device.dev,
 	}
@@ -370,7 +366,6 @@ static struct regulator_init_data devkit8000_vdac = {
 /* VPLL1 for digital video outputs */
 static struct regulator_init_data devkit8000_vpll1 = {
 	.constraints = {
-		.name			= "VDVI",
 		.min_uV			= 1800000,
 		.max_uV			= 1800000,
 		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-- 
1.7.1

