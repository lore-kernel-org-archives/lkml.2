Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab1HXNbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 09:31:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53698 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab1HXNbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 09:31:22 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de, lakml@pengutronix.de
Date: Wed, 24 Aug 2011 15:28:23 +0200
Message-Id: <1314192505-23499-4-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1314192505-23499-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20110824132740.GA28197@pengutronix.de>
 <1314192505-23499-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ukl@pengutronix.de
Subject: [PATCH 4/6] ARM: imx: use mc13xxx constants instead of mc13783
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latter constants are going to be removed in favour of the former

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 arch/arm/mach-imx/mach-mx27_3ds.c |    4 ++--
 arch/arm/mach-imx/mach-mx31_3ds.c |    2 +-
 arch/arm/mach-imx/mach-pcm038.c   |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-imx/mach-mx27_3ds.c b/arch/arm/mach-imx/mach-mx27_3ds.c
index 6fa6934..3856855 100644
--- a/arch/arm/mach-imx/mach-mx27_3ds.c
+++ b/arch/arm/mach-imx/mach-mx27_3ds.c
@@ -293,8 +293,8 @@ static struct mc13xxx_platform_data mc13783_pdata = {
 		.num_regulators = ARRAY_SIZE(mx27_3ds_regulators),
 
 	},
-	.flags  = MC13783_USE_REGULATOR | MC13783_USE_TOUCHSCREEN |
-	MC13783_USE_RTC,
+	.flags  = MC13XXX_USE_REGULATOR | MC13XXX_USE_TOUCHSCREEN |
+		MC13XXX_USE_RTC,
 };
 
 /* SPI */
diff --git a/arch/arm/mach-imx/mach-mx31_3ds.c b/arch/arm/mach-imx/mach-mx31_3ds.c
index c20be75..aa2ebe6 100644
--- a/arch/arm/mach-imx/mach-mx31_3ds.c
+++ b/arch/arm/mach-imx/mach-mx31_3ds.c
@@ -494,7 +494,7 @@ static struct mc13xxx_platform_data mc13783_pdata = {
 		.regulators = mx31_3ds_regulators,
 		.num_regulators = ARRAY_SIZE(mx31_3ds_regulators),
 	},
-	.flags  = MC13783_USE_REGULATOR | MC13783_USE_TOUCHSCREEN,
+	.flags  = MC13XXX_USE_REGULATOR | MC13XXX_USE_TOUCHSCREEN,
 };
 
 /* SPI */
diff --git a/arch/arm/mach-imx/mach-pcm038.c b/arch/arm/mach-imx/mach-pcm038.c
index 2d6a64b..d033774 100644
--- a/arch/arm/mach-imx/mach-pcm038.c
+++ b/arch/arm/mach-imx/mach-pcm038.c
@@ -266,8 +266,8 @@ static struct mc13xxx_platform_data pcm038_pmic = {
 		.regulators = pcm038_regulators,
 		.num_regulators = ARRAY_SIZE(pcm038_regulators),
 	},
-	.flags = MC13783_USE_ADC | MC13783_USE_REGULATOR |
-		 MC13783_USE_TOUCHSCREEN,
+	.flags = MC13XXX_USE_ADC | MC13XXX_USE_REGULATOR |
+		 MC13XXX_USE_TOUCHSCREEN,
 };
 
 static struct spi_board_info pcm038_spi_board_info[] __initdata = {
-- 
1.7.5.4

