Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823Ab2IRQg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 12:36:29 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55360 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab2IRQg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 12:36:26 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: linux@maxim.org.za
Cc: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH] arch/arm/mach-at91/gpio.c: Remove unecessary semicolon
Date: Tue, 18 Sep 2012 18:36:08 +0200
Message-Id: <1347986174-30287-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found by http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 arch/arm/mach-at91/gpio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/gpio.c b/arch/arm/mach-at91/gpio.c
index be42cf0..ea31e96 100644
--- a/arch/arm/mach-at91/gpio.c
+++ b/arch/arm/mach-at91/gpio.c
@@ -658,7 +658,7 @@ static int at91_gpio_show(struct seq_file *s, void *unused)
 	seq_printf(s, "Pin\t");
 	for (bank = 0; bank < gpio_banks; bank++) {
 		seq_printf(s, "PIO%c\t\t", 'A' + bank);
-	};
+	}
 	seq_printf(s, "\n\n");
 
 	/* print pin status */
-- 
1.7.11.4

