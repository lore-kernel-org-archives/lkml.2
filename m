Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933Ab2KWDFn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 22:05:43 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55265 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757489Ab2KWDFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 22:05:41 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        stable@vger.kernel.org
Subject: [PATCH] mfd: wm8994: Add support for WM1811 rev E
Date: Fri, 23 Nov 2012 12:05:33 +0900
Message-Id: <1353639933-28790-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is supported identically to the previous revisions.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: stable@vger.kernel.org
---
 drivers/mfd/wm8994-core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 0b6455a..2f6f7db 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -624,6 +624,7 @@ static __devinit int wm8994_device_init(struct wm8994 *wm8994, int irq)
 		case 1:
 		case 2:
 		case 3:
+		case 4:
 			regmap_patch = wm1811_reva_patch;
 			patch_regs = ARRAY_SIZE(wm1811_reva_patch);
 			break;
-- 
1.7.10.4

