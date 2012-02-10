Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759039Ab2BJKFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 05:05:52 -0500
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:32842 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758983Ab2BJKFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 05:05:48 -0500
MIME-Version: 1.0
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/7] regulator: twl-regulator: Add fixed LDO for V1V8, V2V1 supply
Date: Fri, 10 Feb 2012 12:05:11 +0200
Message-Id: <1328868316-24749-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1328868316-24749-1-git-send-email-peter.ujfalusi@ti.com>
References: <1328868316-24749-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V1V8 supply most common use is to provide VIO for the system.
V2V1 supply is used on SDP4430/PandaBoards to provide 2.1V to
twl6040, and also as an input to VCXIO_IN, VDAC_IN of twl6030.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/regulator/twl-regulator.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 181a2cf..e4d8d3c 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -1005,6 +1005,8 @@ static struct twlreg_info twl_regs[] = {
 	TWL6030_ADJUSTABLE_LDO(VMMC, 0x68, 1000, 3300),
 	TWL6030_ADJUSTABLE_LDO(VPP, 0x6c, 1000, 3300),
 	TWL6030_ADJUSTABLE_LDO(VUSIM, 0x74, 1000, 3300),
+	TWL6030_FIXED_LDO(V1V8, 0x16, 1800, 0),
+	TWL6030_FIXED_LDO(V2V1, 0x1c, 2100, 0),
 	TWL6030_FIXED_LDO(VANA, 0x50, 2100, 0),
 	TWL6030_FIXED_LDO(VCXIO, 0x60, 1800, 0),
 	TWL6030_FIXED_LDO(VDAC, 0x64, 1800, 0),
-- 
1.7.8.4

