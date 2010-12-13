Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892Ab0LMOIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 09:08:48 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39835 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757825Ab0LMOIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 09:08:47 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Use NULL to initialise NULL pointers in ab8500-debugfs
Date: Mon, 13 Dec 2010 14:08:40 +0000
Message-Id: <1292249320-17633-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Partly for coding style reasons, but mostly because sparse warns on it.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/ab8500-debugfs.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index dfdc76e..3c1541a 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -189,7 +189,7 @@ static struct ab8500_i2c_ranges debug_ranges[AB8500_NUM_BANKS] = {
 	},
 	[AB8500_DBI] = {
 		.num_ranges = 0,
-		.range = 0,
+		.range = NULL,
 	},
 	[AB8500_ECI_AV_ACC] = {
 		.num_ranges = 1,
@@ -202,7 +202,7 @@ static struct ab8500_i2c_ranges debug_ranges[AB8500_NUM_BANKS] = {
 	},
 	[0x9] = {
 		.num_ranges = 0,
-		.range = 0,
+		.range = NULL,
 	},
 	[AB8500_GPADC] = {
 		.num_ranges = 1,
@@ -278,7 +278,7 @@ static struct ab8500_i2c_ranges debug_ranges[AB8500_NUM_BANKS] = {
 	},
 	[AB8500_INTERRUPT] = {
 		.num_ranges = 0,
-		.range = 0,
+		.range = NULL,
 	},
 	[AB8500_RTC] = {
 		.num_ranges = 1,
@@ -328,19 +328,19 @@ static struct ab8500_i2c_ranges debug_ranges[AB8500_NUM_BANKS] = {
 	},
 	[0x11] = {
 		.num_ranges = 0,
-		.range = 0,
+		.range = NULL,
 	},
 	[0x12] = {
 		.num_ranges = 0,
-		.range = 0,
+		.range = NULL,
 	},
 	[0x13] = {
 		.num_ranges = 0,
-		.range = 0,
+		.range = NULL,
 	},
 	[0x14] = {
 		.num_ranges = 0,
-		.range = 0,
+		.range = NULL,
 	},
 	[AB8500_OTP_EMUL] = {
 		.num_ranges = 1,
-- 
1.7.1

