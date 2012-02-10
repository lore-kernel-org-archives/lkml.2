Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759114Ab2BJKGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 05:06:38 -0500
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:54752 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759018Ab2BJKFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 05:05:52 -0500
MIME-Version: 1.0
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 5/7] OMAP: 4430SDP: Use common configuration for V1V8, V2V1 supplies
Date: Fri, 10 Feb 2012 12:05:14 +0200
Message-Id: <1328868316-24749-6-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1328868316-24749-1-git-send-email-peter.ujfalusi@ti.com>
References: <1328868316-24749-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These supplies going to be needed for the twl6040 driver.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/mach-omap2/board-4430sdp.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/board-4430sdp.c b/arch/arm/mach-omap2/board-4430sdp.c
index d02172d..2b3ff4b 100644
--- a/arch/arm/mach-omap2/board-4430sdp.c
+++ b/arch/arm/mach-omap2/board-4430sdp.c
@@ -612,7 +612,9 @@ static int __init omap4_i2c_init(void)
 			TWL_COMMON_REGULATOR_VANA |
 			TWL_COMMON_REGULATOR_VCXIO |
 			TWL_COMMON_REGULATOR_VUSB |
-			TWL_COMMON_REGULATOR_CLK32KG);
+			TWL_COMMON_REGULATOR_CLK32KG |
+			TWL_COMMON_REGULATOR_V1V8 |
+			TWL_COMMON_REGULATOR_V2V1);
 	omap4_pmic_init("twl6030", &sdp4430_twldata,
 			&twl6040_data, OMAP44XX_IRQ_SYS_2N);
 	omap_register_i2c_bus(2, 400, NULL, 0);
-- 
1.7.8.4

