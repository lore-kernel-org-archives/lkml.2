Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932551Ab0JLNB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 09:01:28 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:36289 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932473Ab0JLNBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 09:01:23 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 5/7] ste_dma40: remove TIM_FOR_LINK option
Date: Tue, 12 Oct 2010 15:00:53 +0200
Message-ID: <1286888455-11385-6-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1286888455-11385-5-git-send-email-linus.walleij@stericsson.com>
References: <1286888455-11385-1-git-send-email-linus.walleij@stericsson.com>
 <1286888455-11385-2-git-send-email-linus.walleij@stericsson.com>
 <1286888455-11385-3-git-send-email-linus.walleij@stericsson.com>
 <1286888455-11385-4-git-send-email-linus.walleij@stericsson.com>
 <1286888455-11385-5-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

This does not seem to be implemented.

Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/mach-ux500/devices-db8500.c           |    1 -
 arch/arm/plat-nomadik/include/plat/ste_dma40.h |    5 -----
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-ux500/devices-db8500.c b/arch/arm/mach-ux500/devices-db8500.c
index 8a707b9..bb3b9d6 100644
--- a/arch/arm/mach-ux500/devices-db8500.c
+++ b/arch/arm/mach-ux500/devices-db8500.c
@@ -223,7 +223,6 @@ struct stedma40_chan_cfg dma40_memcpy_conf_phy = {
 };
 /* Default configuration for logical memcpy */
 struct stedma40_chan_cfg dma40_memcpy_conf_log = {
-	.channel_type = STEDMA40_NO_TIM_FOR_LINK,
 	.dir = STEDMA40_MEM_TO_MEM,
 
 	.src_info.endianess = STEDMA40_LITTLE_ENDIAN,
diff --git a/arch/arm/plat-nomadik/include/plat/ste_dma40.h b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
index eb72423..d57f37e 100644
--- a/arch/arm/plat-nomadik/include/plat/ste_dma40.h
+++ b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
@@ -38,11 +38,6 @@ enum stedma40_mode_opt {
 	STEDMA40_LCHAN_SRC_LOG_DST_PHY,
 };
 
-/* Interrupt */
-#define STEDMA40_INFO_TIM_POS 10
-#define STEDMA40_NO_TIM_FOR_LINK (0x0 << STEDMA40_INFO_TIM_POS)
-#define STEDMA40_TIM_FOR_LINK (0x1 << STEDMA40_INFO_TIM_POS)
-
 /* End of channel_type configuration */
 
 #define STEDMA40_ESIZE_8_BIT  0x0
-- 
1.6.3.3

