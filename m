Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab1FXLRQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 07:17:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60088 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754779Ab1FXLRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 07:17:14 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Add devices for WM831x clocking module
Date: Fri, 24 Jun 2011 12:17:07 +0100
Message-Id: <1308914227-3474-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the new generic clk API that should appear at some point we should be
able to support the clocking sensibly in Linux.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-core.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index 9370b8c..f25c339 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -691,6 +691,9 @@ static struct mfd_cell wm8310_devs[] = {
 		.resources = wm831x_dcdc4_resources,
 	},
 	{
+		.name = "wm831x-clk",
+	},
+	{
 		.name = "wm831x-epe",
 		.id = 1,
 	},
@@ -842,6 +845,9 @@ static struct mfd_cell wm8311_devs[] = {
 		.resources = wm831x_dcdc4_resources,
 	},
 	{
+		.name = "wm831x-clk",
+	},
+	{
 		.name = "wm831x-epe",
 		.id = 1,
 	},
@@ -969,6 +975,9 @@ static struct mfd_cell wm8312_devs[] = {
 		.resources = wm831x_dcdc4_resources,
 	},
 	{
+		.name = "wm831x-clk",
+	},
+	{
 		.name = "wm831x-epe",
 		.id = 1,
 	},
@@ -1120,6 +1129,9 @@ static struct mfd_cell wm8320_devs[] = {
 		.resources = wm8320_dcdc4_buck_resources,
 	},
 	{
+		.name = "wm831x-clk",
+	},
+	{
 		.name = "wm831x-gpio",
 		.num_resources = ARRAY_SIZE(wm831x_gpio_resources),
 		.resources = wm831x_gpio_resources,
-- 
1.7.5.4

