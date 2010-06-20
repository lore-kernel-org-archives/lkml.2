Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab0FTV0k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 17:26:40 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:55319 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754971Ab0FTV0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 17:26:36 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Jonas Aaberg <jonas.aberg@stericsson.com>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 15/19] DMAENGINE: ste_dma40: add DB8500 memcpy channels
Date: Sun, 20 Jun 2010 23:26:30 +0200
Message-ID: <1277069190-31343-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

This adds all available memcpy channels to the DB8500 in the
ux500 platform (and fixes a typo).

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/mach-ux500/devices-db8500.c   |    2 ++
 arch/arm/mach-ux500/ste-dma40-db8500.h |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-ux500/devices-db8500.c b/arch/arm/mach-ux500/devices-db8500.c
index 8d94bc6..a001e4c 100644
--- a/arch/arm/mach-ux500/devices-db8500.c
+++ b/arch/arm/mach-ux500/devices-db8500.c
@@ -177,10 +177,12 @@ static const dma_addr_t dma40_rx_map[STEDMA40_NR_DEV];
 
 /* Reserved event lines for memcpy only */
 static int dma40_memcpy_event[] = {
+	STEDMA40_MEMCPY_TX_0,
 	STEDMA40_MEMCPY_TX_1,
 	STEDMA40_MEMCPY_TX_2,
 	STEDMA40_MEMCPY_TX_3,
 	STEDMA40_MEMCPY_TX_4,
+	STEDMA40_MEMCPY_TX_5,
 };
 
 static struct stedma40_platform_data dma40_plat_data = {
diff --git a/arch/arm/mach-ux500/ste-dma40-db8500.h b/arch/arm/mach-ux500/ste-dma40-db8500.h
index e701627..9d9d379 100644
--- a/arch/arm/mach-ux500/ste-dma40-db8500.h
+++ b/arch/arm/mach-ux500/ste-dma40-db8500.h
@@ -136,7 +136,7 @@ enum dma_dest_dev_type {
 	STEDMA40_DEV_CAC1_TX = 48,
 	STEDMA40_DEV_CAC1_TX_HAC1_TX = 49,
 	STEDMA40_DEV_HAC1_TX = 50,
-	STEDMA40_MEMXCPY_TX_0 = 51,
+	STEDMA40_MEMCPY_TX_0 = 51,
 	STEDMA40_DEV_SLIM1_CH0_TX_HSI_TX_CH4 = 52,
 	STEDMA40_DEV_SLIM1_CH1_TX_HSI_TX_CH5 = 53,
 	STEDMA40_DEV_SLIM1_CH2_TX_HSI_TX_CH6 = 54,
-- 
1.6.3.3

