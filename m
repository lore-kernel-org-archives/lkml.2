Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030613Ab2B2Pj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 10:39:58 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46265 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964877Ab2B2Pj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 10:39:57 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3.3] mfd: Correct readability of WM8994 DC servo 4E register
Date: Wed, 29 Feb 2012 15:37:59 +0000
Message-Id: <1330529879-5345-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should be marked as readable but wasn't, breaking DC servo operation.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

This needs to go in for 3.3, it's a substantial regression.

 drivers/mfd/wm8994-regmap.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm8994-regmap.c b/drivers/mfd/wm8994-regmap.c
index 47743fa..ba383f6 100644
--- a/drivers/mfd/wm8994-regmap.c
+++ b/drivers/mfd/wm8994-regmap.c
@@ -806,6 +806,7 @@ static bool wm1811_readable_register(struct device *dev, unsigned int reg)
 	case WM8994_DC_SERVO_2:
 	case WM8994_DC_SERVO_READBACK:
 	case WM8994_DC_SERVO_4:
+	case WM8994_DC_SERVO_4E:
 	case WM8994_ANALOGUE_HP_1:
 	case WM8958_MIC_DETECT_1:
 	case WM8958_MIC_DETECT_2:
-- 
1.7.9.1

