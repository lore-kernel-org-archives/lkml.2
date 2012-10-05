Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab2JEPeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 11:34:46 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:40368 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327Ab2JEPcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 11:32:04 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 03/10] mfd: Correct copy and paste mistake in stmpe
Date: Fri,  5 Oct 2012 16:31:39 +0100
Message-Id: <1349451107-8009-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349451107-8009-1-git-send-email-lee.jones@linaro.org>
References: <1349451107-8009-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When specifying IRQ numbers for the stmpe1601, IRQ defines for the
stmpe24xx were used instead. Fortunately, the defined numbers are
the same, hence why it survived testing. This fix is merely an
aesthetic one.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/stmpe.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index 5c8d8f2..e50ebdf 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -519,12 +519,12 @@ static const u8 stmpe1601_regs[] = {
 static struct stmpe_variant_block stmpe1601_blocks[] = {
 	{
 		.cell	= &stmpe_gpio_cell,
-		.irq	= STMPE24XX_IRQ_GPIOC,
+		.irq	= STMPE1601_IRQ_GPIOC,
 		.block	= STMPE_BLOCK_GPIO,
 	},
 	{
 		.cell	= &stmpe_keypad_cell,
-		.irq	= STMPE24XX_IRQ_KEYPAD,
+		.irq	= STMPE1601_IRQ_KEYPAD,
 		.block	= STMPE_BLOCK_KEYPAD,
 	},
 };
-- 
1.7.9.5

