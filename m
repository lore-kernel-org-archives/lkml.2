Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568Ab2E3EsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 00:48:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64887 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab2E3EsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 00:48:24 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        cjb@laptop.org, broonie@opensource.wolfsonmicro.com,
        sameo@linux.intel.com
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 08/22] regulator: Change ab8500 match names to reflect Device Tree
Date: Wed, 30 May 2012 12:47:26 +0800
Message-Id: <1338353260-10097-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1338353260-10097-1-git-send-email-lee.jones@linaro.org>
References: <1338353260-10097-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'name' field in 'struct of_regulator_match' expects to match with
its corresponding regulator device node in the Device Tree. This patch
renames each of the regulators in the ab8500 regulator driver so this
is true.

Cc: linux-kernel@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/ab8500.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index e1b8c54..a739f5c 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -794,17 +794,17 @@ static __devinit int ab8500_regulator_register(struct platform_device *pdev,
 }
 
 static struct of_regulator_match ab8500_regulator_matches[] = {
-	{ .name	= "LDO-AUX1",    .driver_data = (void *) AB8500_LDO_AUX1, },
-	{ .name	= "LDO-AUX2",    .driver_data = (void *) AB8500_LDO_AUX2, },
-	{ .name	= "LDO-AUX3",    .driver_data = (void *) AB8500_LDO_AUX3, },
-	{ .name	= "LDO-INTCORE", .driver_data = (void *) AB8500_LDO_INTCORE, },
-	{ .name	= "LDO-TVOUT",   .driver_data = (void *) AB8500_LDO_TVOUT, },
-	{ .name = "LDO-USB",     .driver_data = (void *) AB8500_LDO_USB, },
-	{ .name = "LDO-AUDIO",   .driver_data = (void *) AB8500_LDO_AUDIO, },
-	{ .name	= "LDO-ANAMIC1", .driver_data = (void *) AB8500_LDO_ANAMIC1, },
-	{ .name	= "LDO-ANAMIC2", .driver_data = (void *) AB8500_LDO_ANAMIC2, },
-	{ .name	= "LDO-DMIC",    .driver_data = (void *) AB8500_LDO_DMIC, },
-	{ .name	= "LDO-ANA",     .driver_data = (void *) AB8500_LDO_ANA, },
+	{ .name	= "ab8500_ldo_aux1",    .driver_data = (void *) AB8500_LDO_AUX1, },
+	{ .name	= "ab8500_ldo_aux2",    .driver_data = (void *) AB8500_LDO_AUX2, },
+	{ .name	= "ab8500_ldo_aux3",    .driver_data = (void *) AB8500_LDO_AUX3, },
+	{ .name	= "ab8500_ldo_intcore", .driver_data = (void *) AB8500_LDO_INTCORE, },
+	{ .name	= "ab8500_ldo_tvout",   .driver_data = (void *) AB8500_LDO_TVOUT, },
+	{ .name = "ab8500_ldo_usb",     .driver_data = (void *) AB8500_LDO_USB, },
+	{ .name = "ab8500_ldo_audio",   .driver_data = (void *) AB8500_LDO_AUDIO, },
+	{ .name	= "ab8500_ldo_anamic1", .driver_data = (void *) AB8500_LDO_ANAMIC1, },
+	{ .name	= "ab8500_ldo_amamic2", .driver_data = (void *) AB8500_LDO_ANAMIC2, },
+	{ .name	= "ab8500_ldo_dmic",    .driver_data = (void *) AB8500_LDO_DMIC, },
+	{ .name	= "ab8500_ldo_ana",     .driver_data = (void *) AB8500_LDO_ANA, },
 };
 
 static __devinit int
-- 
1.7.9.5

