Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab0HIMJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 08:09:22 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:37564 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756535Ab0HIMJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 08:09:16 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Jonas Aaberg <jonas.aberg@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 12/14] DMAENGINE: ste_dma40: removed non-used variable from struct
Date: Mon, 9 Aug 2010 14:09:04 +0200
Message-ID: <1281355744-13567-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

The reqrite of the LCLA code rendered this variable unused.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/mach-ux500/devices-db8500.c           |    1 -
 arch/arm/plat-nomadik/include/plat/ste_dma40.h |    2 --
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-ux500/devices-db8500.c b/arch/arm/mach-ux500/devices-db8500.c
index 6aff288..23a7564 100644
--- a/arch/arm/mach-ux500/devices-db8500.c
+++ b/arch/arm/mach-ux500/devices-db8500.c
@@ -279,7 +279,6 @@ static struct stedma40_platform_data dma40_plat_data = {
 	.memcpy_len = ARRAY_SIZE(dma40_memcpy_event),
 	.memcpy_conf_phy = &dma40_memcpy_conf_phy,
 	.memcpy_conf_log = &dma40_memcpy_conf_log,
-	.llis_per_log = 8,
 	.disabled_channels = {-1},
 };
 
diff --git a/arch/arm/plat-nomadik/include/plat/ste_dma40.h b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
index 879a6c1..1620492 100644
--- a/arch/arm/plat-nomadik/include/plat/ste_dma40.h
+++ b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
@@ -148,7 +148,6 @@ struct stedma40_chan_cfg {
  * @memcpy_len: length of memcpy
  * @memcpy_conf_phy: default configuration of physical channel memcpy
  * @memcpy_conf_log: default configuration of logical channel memcpy
- * @llis_per_log: number of max linked list items per logical channel
  * @disabled_channels: A vector, ending with -1, that marks physical channels
  * that are for different reasons not available for the driver.
  */
@@ -160,7 +159,6 @@ struct stedma40_platform_data {
 	u32				 memcpy_len;
 	struct stedma40_chan_cfg	*memcpy_conf_phy;
 	struct stedma40_chan_cfg	*memcpy_conf_log;
-	unsigned int			 llis_per_log;
 	int				 disabled_channels[STEDMA40_MAX_PHYS];
 };
 
-- 
1.6.3.3

