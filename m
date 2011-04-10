Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408Ab1DJEZs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 00:25:48 -0400
Received: from 63.mail-out.ovh.net ([91.121.185.56]:44172 "HELO
	63.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750997Ab1DJEZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 00:25:27 -0400
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: linux-kernel@vger.kernel.org
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Patrice Vilchez <patrice.vilchez@atmel.com>
Subject: [PATCH 2/2] avr32: At32ap: pio fix typo "))" on gpio_irq_unmask prototype
Date: Sun, 10 Apr 2011 06:17:20 +0200
Message-Id: <1302409040-13791-2-git-send-email-plagnioj@jcrosoft.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1302409040-13791-1-git-send-email-plagnioj@jcrosoft.com>
References: <1302409040-13791-1-git-send-email-plagnioj@jcrosoft.com>
X-Ovh-Tracer-Id: 3545177333337271064
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

introduce in commit d75f1bfdbccb

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Patrice Vilchez <patrice.vilchez@atmel.com>
---
 arch/avr32/mach-at32ap/pio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/avr32/mach-at32ap/pio.c b/arch/avr32/mach-at32ap/pio.c
index f308e1d..2e0aa85 100644
--- a/arch/avr32/mach-at32ap/pio.c
+++ b/arch/avr32/mach-at32ap/pio.c
@@ -257,7 +257,7 @@ static void gpio_irq_mask(struct irq_data *d)
 	pio_writel(pio, IDR, 1 << (gpio & 0x1f));
 }
 
-static void gpio_irq_unmask(struct irq_data *d))
+static void gpio_irq_unmask(struct irq_data *d)
 {
 	unsigned		gpio = irq_to_gpio(d->irq);
 	struct pio_device	*pio = &pio_dev[gpio >> 5];
-- 
1.7.4.1

