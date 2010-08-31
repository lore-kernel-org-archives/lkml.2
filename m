Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab0HaEw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 00:52:56 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:53756 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754479Ab0HaEwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 00:52:55 -0400
From: Virupax Sadashivpetimath <virupax.sadashivpetimath@stericsson.com>
To: <sameo@linux.intel.com>, <w.sang@pengutronix.de>,
        <linux-kernel@vger.kernel.org>
Cc: <STEricsson_nomadik_linux@list.st.com>,
        <virupax.sadashivpetimath@stericsson.com>,
        <rabin.vincent@stericsson.com>, <linus.walleij@stericsson.com>
Subject: [PATCH] stmpe-gpio: Handle platform data with no gpio base
Date: Tue, 31 Aug 2010 10:04:56 +0530
Message-ID: <1283229296-16733-1-git-send-email-virupax.sadashivpetimath@stericsson.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the requirement that gpio base be supplied in
platform data.

Signed-off-by: Virupax Sadashivpetimath <virupax.sadashivpetimath@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/gpio/stmpe-gpio.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/stmpe-gpio.c b/drivers/gpio/stmpe-gpio.c
index 65b9960..932759d 100644
--- a/drivers/gpio/stmpe-gpio.c
+++ b/drivers/gpio/stmpe-gpio.c
@@ -291,8 +291,6 @@ static int __devinit stmpe_gpio_probe(struct platform_device *pdev)
 	int irq;
 
 	pdata = stmpe->pdata->gpio;
-	if (!pdata)
-		return -ENODEV;
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
-- 
1.7.1

