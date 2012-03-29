Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694Ab2C2HEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 03:04:33 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59236 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757915Ab2C2HE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 03:04:27 -0400
Message-ID: <1333004662.8548.3.camel@phoenix>
Subject: [PATCH 2/2] regulator: Trivial comment fix for wm831x-ldo driver
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 29 Mar 2012 15:04:22 +0800
In-Reply-To: <1333004575.8548.1.camel@phoenix>
References: <1333004575.8548.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm831x-ldo.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
index 641e9f6..a86a7be 100644
--- a/drivers/regulator/wm831x-ldo.c
+++ b/drivers/regulator/wm831x-ldo.c
@@ -105,7 +105,7 @@ static int wm831x_gp_ldo_list_voltage(struct regulator_dev *rdev,
 	/* 0.9-1.6V in 50mV steps */
 	if (selector <= WM831X_GP_LDO_SELECTOR_LOW)
 		return 900000 + (selector * 50000);
-	/* 1.7-3.3V in 50mV steps */
+	/* 1.7-3.3V in 100mV steps */
 	if (selector <= WM831X_GP_LDO_MAX_SELECTOR)
 		return 1600000 + ((selector - WM831X_GP_LDO_SELECTOR_LOW)
 				  * 100000);
@@ -414,7 +414,7 @@ static int wm831x_aldo_list_voltage(struct regulator_dev *rdev,
 	/* 1-1.6V in 50mV steps */
 	if (selector <= WM831X_ALDO_SELECTOR_LOW)
 		return 1000000 + (selector * 50000);
-	/* 1.7-3.5V in 50mV steps */
+	/* 1.7-3.5V in 100mV steps */
 	if (selector <= WM831X_ALDO_MAX_SELECTOR)
 		return 1600000 + ((selector - WM831X_ALDO_SELECTOR_LOW)
 				  * 100000);
-- 
1.7.5.4



