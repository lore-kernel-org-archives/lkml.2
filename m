Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564Ab0JLNB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 09:01:29 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:37658 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932532Ab0JLNB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 09:01:26 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 7/7] ste_dma40: remove channel_type
Date: Tue, 12 Oct 2010 15:00:55 +0200
Message-ID: <1286888455-11385-8-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1286888455-11385-7-git-send-email-linus.walleij@stericsson.com>
References: <1286888455-11385-1-git-send-email-linus.walleij@stericsson.com>
 <1286888455-11385-2-git-send-email-linus.walleij@stericsson.com>
 <1286888455-11385-3-git-send-email-linus.walleij@stericsson.com>
 <1286888455-11385-4-git-send-email-linus.walleij@stericsson.com>
 <1286888455-11385-5-git-send-email-linus.walleij@stericsson.com>
 <1286888455-11385-6-git-send-email-linus.walleij@stericsson.com>
 <1286888455-11385-7-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

It has been replaced with separate fields.

Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/plat-nomadik/include/plat/ste_dma40.h |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/arch/arm/plat-nomadik/include/plat/ste_dma40.h b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
index 07339f1..da1f08f 100644
--- a/arch/arm/plat-nomadik/include/plat/ste_dma40.h
+++ b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
@@ -18,11 +18,6 @@
 #define STEDMA40_DEV_DST_MEMORY (-1)
 #define	STEDMA40_DEV_SRC_MEMORY (-1)
 
-/*
- * Description of bitfields of channel_type variable is available in
- * the info structure.
- */
-
 enum stedma40_mode {
 	STEDMA40_MODE_LOGICAL = 0,
 	STEDMA40_MODE_PHYSICAL,
@@ -38,8 +33,6 @@ enum stedma40_mode_opt {
 	STEDMA40_LCHAN_SRC_LOG_DST_PHY,
 };
 
-/* End of channel_type configuration */
-
 #define STEDMA40_ESIZE_8_BIT  0x0
 #define STEDMA40_ESIZE_16_BIT 0x1
 #define STEDMA40_ESIZE_32_BIT 0x2
@@ -103,7 +96,6 @@ struct stedma40_half_channel_info {
  * struct stedma40_chan_cfg - Structure to be filled by client drivers.
  *
  * @dir: MEM 2 MEM, PERIPH 2 MEM , MEM 2 PERIPH, PERIPH 2 PERIPH
- * @channel_type: priority, mode, mode options and interrupt configuration.
  * @high_priority: true if high-priority
  * @mode: channel mode: physical, logical, or operation
  * @mode_opt: options for the chosen channel mode
@@ -119,7 +111,6 @@ struct stedma40_half_channel_info {
  */
 struct stedma40_chan_cfg {
 	enum stedma40_xfer_dir			 dir;
-	unsigned int				 channel_type;
 	bool					 high_priority;
 	enum stedma40_mode			 mode;
 	enum stedma40_mode_opt			 mode_opt;
-- 
1.6.3.3

