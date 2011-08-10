Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab1HJMRH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 08:17:07 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:56506 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753930Ab1HJMRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 08:17:04 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 03/19] mach-u300: delete irq_to_gpio() function
Date: Wed, 10 Aug 2011 14:16:41 +0200
Message-ID: <1312978601-18169-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This function is not used in the U300 build, and on the whole the
call is hard to consolidate so get rid of it from this machine.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-u300/include/mach/gpio.h |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-u300/include/mach/gpio.h b/arch/arm/mach-u300/include/mach/gpio.h
index 6a3f24d..430a054 100644
--- a/arch/arm/mach-u300/include/mach/gpio.h
+++ b/arch/arm/mach-u300/include/mach/gpio.h
@@ -44,13 +44,4 @@ static inline unsigned gpio_to_irq(unsigned gpio)
 }
 #define gpio_to_irq gpio_to_irq
 
-static inline unsigned irq_to_gpio(unsigned irq)
-{
-	/*
-	 * FIXME: This is no 1-1 mapping at all, it points to the
-	 * whole block of 8 pins.
-	 */
-	return (irq - IRQ_U300_GPIO_PORT0) << 3;
-}
-
 #endif /* __MACH_U300_GPIO_H */
-- 
1.7.3.2

