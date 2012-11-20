Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab2KTHx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 02:53:59 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46413 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751513Ab2KTHx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 02:53:58 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: wm5102: Make FLL NCO test registers readable
Date: Tue, 20 Nov 2012 16:53:47 +0900
Message-Id: <1353398027-15811-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They contain documented status readback fields.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5102-tables.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
index 645c0d6..6a0e943 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -1054,6 +1054,7 @@ static bool wm5102_readable_register(struct device *dev, unsigned int reg)
 	case ARIZONA_FLL1_CONTROL_5:
 	case ARIZONA_FLL1_CONTROL_6:
 	case ARIZONA_FLL1_LOOP_FILTER_TEST_1:
+	case ARIZONA_FLL1_NCO_TEST_0:
 	case ARIZONA_FLL1_SYNCHRONISER_1:
 	case ARIZONA_FLL1_SYNCHRONISER_2:
 	case ARIZONA_FLL1_SYNCHRONISER_3:
@@ -1069,6 +1070,7 @@ static bool wm5102_readable_register(struct device *dev, unsigned int reg)
 	case ARIZONA_FLL2_CONTROL_5:
 	case ARIZONA_FLL2_CONTROL_6:
 	case ARIZONA_FLL2_LOOP_FILTER_TEST_1:
+	case ARIZONA_FLL2_NCO_TEST_0:
 	case ARIZONA_FLL2_SYNCHRONISER_1:
 	case ARIZONA_FLL2_SYNCHRONISER_2:
 	case ARIZONA_FLL2_SYNCHRONISER_3:
@@ -1822,6 +1824,8 @@ static bool wm5102_volatile_register(struct device *dev, unsigned int reg)
 	case ARIZONA_SAMPLE_RATE_3_STATUS:
 	case ARIZONA_HAPTICS_STATUS:
 	case ARIZONA_ASYNC_SAMPLE_RATE_1_STATUS:
+	case ARIZONA_FLL1_NCO_TEST_0:
+	case ARIZONA_FLL2_NCO_TEST_0:
 	case ARIZONA_FX_CTRL2:
 	case ARIZONA_INTERRUPT_STATUS_1:
 	case ARIZONA_INTERRUPT_STATUS_2:
-- 
1.7.10.4

