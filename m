Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab1HJMTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 08:19:09 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:38593 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754160Ab1HJMTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 08:19:04 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 19/19] mach-sa1100: delete irq_to_gpio() function
Date: Wed, 10 Aug 2011 14:18:48 +0200
Message-ID: <1312978728-18704-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This function is not used in the assabet build, and on the whole the
call is hard to consolidate so get rid of it from this machine.

Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-sa1100/include/mach/gpio.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-sa1100/include/mach/gpio.h b/arch/arm/mach-sa1100/include/mach/gpio.h
index ab45b43..7036318 100644
--- a/arch/arm/mach-sa1100/include/mach/gpio.h
+++ b/arch/arm/mach-sa1100/include/mach/gpio.h
@@ -53,7 +53,5 @@ static inline void gpio_set_value(unsigned gpio, int value)
 
 #define gpio_to_irq(gpio)	((gpio < 11) ? (IRQ_GPIO0 + gpio) : \
 					(IRQ_GPIO11 - 11 + gpio))
-#define irq_to_gpio(irq)	((irq < IRQ_GPIO11_27) ? (irq - IRQ_GPIO0) : \
-					(irq - IRQ_GPIO11 + 11))
 
 #endif
-- 
1.7.3.2

