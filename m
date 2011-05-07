Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab1EGS51 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 14:57:27 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:52684 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755991Ab1EGS5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 14:57:14 -0400
Date: Sat, 7 May 2011 20:55:42 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Chris Zankel <chris@zankel.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] xtensa: unbalanced parentheses
Message-ID: <20110507205542.67bd6d33@absol.kitzblitz>
Organization: -
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwAQMAAABtzGvEAAAAAXNSR0IArs4c6QAAAAZQTFRF
 AJnV/f/88sgWwwAAAKNJREFUGNM10LENwyAQheFHKCgZgTVSRHI2gy5reROTDSiREvnyHhdXnwXS+
 T+ACJgBYTiGSmDDOTdR7XDeTi9ksxEcoKFcTOCJLO7kC5SWFjPZCR69nI9+x5u6OJM1RN5UYUiNKa
 ZRpHHUoqh1v8hKEZ1FSGCrYOvgVmxd9DIXcSJwLTycm7bj0e4wkJGB48w/FckAwUKl/OGDZAcqItk
 BU+wHXLqKsjYyPeMAAAAASUVORK5CYII=
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
Untested.

 arch/xtensa/variants/s6000/gpio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/xtensa/variants/s6000/gpio.c b/arch/xtensa/variants/s6000/gpio.c
index 7af0757..50b02c2 100644
--- a/arch/xtensa/variants/s6000/gpio.c
+++ b/arch/xtensa/variants/s6000/gpio.c
@@ -164,7 +164,7 @@ static void demux_irqs(unsigned int irq, struct irq_desc *desc)
 	int cirq;
 
 	chip->irq_mask(&desc->irq_data);
-	chip->irq_ack(&desc->irq_data));
+	chip->irq_ack(&desc->irq_data);
 	pending = readb(S6_REG_GPIO + S6_GPIO_BANK(0) + S6_GPIO_MIS) & *mask;
 	cirq = IRQ_BASE - 1;
 	while (pending) {
@@ -173,7 +173,7 @@ static void demux_irqs(unsigned int irq, struct irq_desc *desc)
 		pending >>= n;
 		generic_handle_irq(cirq);
 	}
-	chip->irq_unmask(&desc->irq_data));
+	chip->irq_unmask(&desc->irq_data);
 }
 
 extern const signed char *platform_irq_mappings[XTENSA_NR_IRQS];
-- 
1.7.5.rc3
