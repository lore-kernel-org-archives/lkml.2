Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab2DPJVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 05:21:19 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:35334 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab2DPJVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 05:21:17 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, arnd@arndb.de, olof@lixom.net
Cc: plagnioj@jcrosoft.com, ludovic.desroches@atmel.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/12] ARM: at91: fix rm9200ek flash size
Date: Mon, 16 Apr 2012 11:20:51 +0200
Message-Id: <bf66b0d1dad30cc1241dc4e3ac193251a4694f5c.1334567594.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1334567594.git.nicolas.ferre@atmel.com>
References: <cover.1334567594.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1334567594.git.nicolas.ferre@atmel.com>
References: <cover.1334567594.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

The flash size is 8MiB.

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/board-rm9200ek.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/board-rm9200ek.c b/arch/arm/mach-at91/board-rm9200ek.c
index 11cbaa8..b2e4fe2 100644
--- a/arch/arm/mach-at91/board-rm9200ek.c
+++ b/arch/arm/mach-at91/board-rm9200ek.c
@@ -117,7 +117,7 @@ static struct i2c_board_info __initdata ek_i2c_devices[] = {
 };
 
 #define EK_FLASH_BASE	AT91_CHIPSELECT_0
-#define EK_FLASH_SIZE	SZ_2M
+#define EK_FLASH_SIZE	SZ_8M
 
 static struct physmap_flash_data ek_flash_data = {
 	.width		= 2,
-- 
1.7.10

