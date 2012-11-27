Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab2K0RhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 12:37:20 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36651 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756620Ab2K0RhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 12:37:17 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: arizona: Register haptics devices
Date: Tue, 27 Nov 2012 17:37:13 +0000
Message-Id: <1354037834-32061-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both WM5102 and WM5110 support haptics, register the device.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 5e4e9c5..8572dfd 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -272,6 +272,7 @@ static struct mfd_cell early_devs[] = {
 static struct mfd_cell wm5102_devs[] = {
 	{ .name = "arizona-extcon" },
 	{ .name = "arizona-gpio" },
+	{ .name = "arizona-haptics" },
 	{ .name = "arizona-micsupp" },
 	{ .name = "arizona-pwm" },
 	{ .name = "wm5102-codec" },
@@ -280,6 +281,7 @@ static struct mfd_cell wm5102_devs[] = {
 static struct mfd_cell wm5110_devs[] = {
 	{ .name = "arizona-extcon" },
 	{ .name = "arizona-gpio" },
+	{ .name = "arizona-haptics" },
 	{ .name = "arizona-micsupp" },
 	{ .name = "arizona-pwm" },
 	{ .name = "wm5110-codec" },
-- 
1.7.10.4

