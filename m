Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab2KENog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:44:36 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58057 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208Ab2KENof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:44:35 -0500
Message-ID: <1352123068.14769.6.camel@phoenix>
Subject: [PATCH] pinctrl: sirf: Staticize non-exported symbol
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Barry Song <baohua.song@csr.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Mon, 05 Nov 2012 21:44:28 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Staticize sirfsoc_gpio_irq_map() function.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/pinctrl-sirf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-sirf.c b/drivers/pinctrl/pinctrl-sirf.c
index 9ecacf3..e3b2c53 100644
--- a/drivers/pinctrl/pinctrl-sirf.c
+++ b/drivers/pinctrl/pinctrl-sirf.c
@@ -1621,8 +1621,8 @@ static void sirfsoc_gpio_set_value(struct gpio_chip *chip, unsigned offset,
 	spin_unlock_irqrestore(&bank->lock, flags);
 }
 
-int sirfsoc_gpio_irq_map(struct irq_domain *d, unsigned int irq,
-	irq_hw_number_t hwirq)
+static int sirfsoc_gpio_irq_map(struct irq_domain *d, unsigned int irq,
+				irq_hw_number_t hwirq)
 {
 	struct sirfsoc_gpio_bank *bank = d->host_data;
 
-- 
1.7.9.5



