Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639Ab2JKLzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 07:55:50 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36396 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758612Ab2JKLzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 07:55:46 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <peter.ujfalusi@ti.com>
Subject: [PATCH 6/6] MFD: twl6040: Rename the core driver
Date: Thu, 11 Oct 2012 13:55:33 +0200
Message-ID: <1349956533-6374-7-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1349956533-6374-1-git-send-email-peter.ujfalusi@ti.com>
References: <1349956533-6374-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the regmap_irq conversion there is no need to call the driver
as twl6040-core.c since there is only one c file remained.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/Makefile                      | 2 +-
 drivers/mfd/{twl6040-core.c => twl6040.c} | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename drivers/mfd/{twl6040-core.c => twl6040.c} (100%)

diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 360233f..8c8331b 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -63,7 +63,7 @@ obj-$(CONFIG_TWL4030_CORE)	+= twl-core.o twl4030-irq.o twl6030-irq.o
 obj-$(CONFIG_TWL4030_MADC)      += twl4030-madc.o
 obj-$(CONFIG_TWL4030_POWER)    += twl4030-power.o
 obj-$(CONFIG_MFD_TWL4030_AUDIO)	+= twl4030-audio.o
-obj-$(CONFIG_TWL6040_CORE)	+= twl6040-core.o
+obj-$(CONFIG_TWL6040_CORE)	+= twl6040.o
 
 obj-$(CONFIG_MFD_MC13XXX)	+= mc13xxx-core.o
 obj-$(CONFIG_MFD_MC13XXX_SPI)	+= mc13xxx-spi.o
diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040.c
similarity index 100%
rename from drivers/mfd/twl6040-core.c
rename to drivers/mfd/twl6040.c
-- 
1.7.12

