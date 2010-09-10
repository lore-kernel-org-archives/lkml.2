Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab0IJLgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 07:36:22 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:9203 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424Ab0IJLgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 07:36:21 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        avictor.za@gmail.com
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] AT91: at91sam9261ek: remove C99 comments but keep information
Date: Fri, 10 Sep 2010 14:42:25 +0200
Message-Id: <1284122545-14715-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <4C8A15AB.4030209@atmel.com>
References: <4C8A15AB.4030209@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/board-sam9261ek.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-at91/board-sam9261ek.c b/arch/arm/mach-at91/board-sam9261ek.c
index 19d4d2c..65eb094 100644
--- a/arch/arm/mach-at91/board-sam9261ek.c
+++ b/arch/arm/mach-at91/board-sam9261ek.c
@@ -351,16 +351,14 @@ static struct spi_board_info ek_spi_devices[] = {
 };
 
 #else /* CONFIG_SPI_ATMEL_* */
+/* spi0 and mmc/sd share the same PIO pins: cannot be used at the same time */
 
 /*
  * MCI (SD/MMC)
- * spi0 and mmc/sd share the same PIO pins: cannot be used at the same time
+ * det_pin, wp_pin and vcc_pin are not connected
  */
 static struct at91_mmc_data __initdata ek_mmc_data = {
 	.wire4		= 1,
-//	.det_pin	= ... not connected
-//	.wp_pin		= ... not connected
-//	.vcc_pin	= ... not connected
 };
 
 #endif /* CONFIG_SPI_ATMEL_* */
-- 
1.5.6.5

