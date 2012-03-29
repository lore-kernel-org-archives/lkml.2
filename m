Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783Ab2C2N3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 09:29:32 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:49685 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757666Ab2C2N16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 09:27:58 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Cc: plagnioj@jcrosoft.com, ludovic.desroches@atmel.com,
        linux-kernel@vger.kernel.org, arnd@arndb.de, olof@lixom.net,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 01/12] ARM: at91/at91sam9x5: add clkdev entries for DMA controllers
Date: Thu, 29 Mar 2012 15:27:12 +0200
Message-Id: <5e980fb93069db1362c29c23534a47d08feb3e2a.1333026637.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9.4
In-Reply-To: <cover.1333026637.git.nicolas.ferre@atmel.com>
References: <cover.1333026637.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1333026637.git.nicolas.ferre@atmel.com>
References: <cover.1333026637.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
---
 arch/arm/mach-at91/at91sam9x5.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-at91/at91sam9x5.c b/arch/arm/mach-at91/at91sam9x5.c
index b6831ee..13c8cae 100644
--- a/arch/arm/mach-at91/at91sam9x5.c
+++ b/arch/arm/mach-at91/at91sam9x5.c
@@ -223,6 +223,8 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_DEV_ID("usart", "f8028000.serial", &usart3_clk),
 	CLKDEV_CON_DEV_ID("t0_clk", "f8008000.timer", &tcb0_clk),
 	CLKDEV_CON_DEV_ID("t0_clk", "f800c000.timer", &tcb0_clk),
+	CLKDEV_CON_DEV_ID("dma_clk", "ffffec00.dma-controller", &dma0_clk),
+	CLKDEV_CON_DEV_ID("dma_clk", "ffffee00.dma-controller", &dma1_clk),
 	CLKDEV_CON_ID("pioA", &pioAB_clk),
 	CLKDEV_CON_ID("pioB", &pioAB_clk),
 	CLKDEV_CON_ID("pioC", &pioCD_clk),
-- 
1.7.9.4

