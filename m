Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab2BMOhT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 09:37:19 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:35053
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751234Ab2BMOhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 09:37:17 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: kernel@wantstofly.org, nico@fluxnic.net,
        linux-arm-kernel@lists.infradead.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] mach-orion5x: Fix typo in db88f5281-setup.c and rd88f5182-setup.c
Date: Mon, 13 Feb 2012 23:29:56 +0900
Message-Id: <1329143396-2525-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "faield" to "failed" in
arch/arm/mach-orion5x/db88f5281-setup.c and
arch/arm/mach-orion5x/rd88f5182-setup.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/arm/mach-orion5x/db88f5281-setup.c |    4 ++--
 arch/arm/mach-orion5x/rd88f5182-setup.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-orion5x/db88f5281-setup.c b/arch/arm/mach-orion5x/db88f5281-setup.c
index a104d5a..e52108c 100644
--- a/arch/arm/mach-orion5x/db88f5281-setup.c
+++ b/arch/arm/mach-orion5x/db88f5281-setup.c
@@ -214,7 +214,7 @@ void __init db88f5281_pci_preinit(void)
 		if (gpio_direction_input(pin) == 0) {
 			irq_set_irq_type(gpio_to_irq(pin), IRQ_TYPE_LEVEL_LOW);
 		} else {
-			printk(KERN_ERR "db88f5281_pci_preinit faield to "
+			printk(KERN_ERR "db88f5281_pci_preinit failed to "
 					"set_irq_type pin %d\n", pin);
 			gpio_free(pin);
 		}
@@ -227,7 +227,7 @@ void __init db88f5281_pci_preinit(void)
 		if (gpio_direction_input(pin) == 0) {
 			irq_set_irq_type(gpio_to_irq(pin), IRQ_TYPE_LEVEL_LOW);
 		} else {
-			printk(KERN_ERR "db88f5281_pci_preinit faield "
+			printk(KERN_ERR "db88f5281_pci_preinit failed "
 					"to set_irq_type pin %d\n", pin);
 			gpio_free(pin);
 		}
diff --git a/arch/arm/mach-orion5x/rd88f5182-setup.c b/arch/arm/mach-orion5x/rd88f5182-setup.c
index 96438b6..e3ce617 100644
--- a/arch/arm/mach-orion5x/rd88f5182-setup.c
+++ b/arch/arm/mach-orion5x/rd88f5182-setup.c
@@ -149,7 +149,7 @@ void __init rd88f5182_pci_preinit(void)
 		if (gpio_direction_input(pin) == 0) {
 			irq_set_irq_type(gpio_to_irq(pin), IRQ_TYPE_LEVEL_LOW);
 		} else {
-			printk(KERN_ERR "rd88f5182_pci_preinit faield to "
+			printk(KERN_ERR "rd88f5182_pci_preinit failed to "
 					"set_irq_type pin %d\n", pin);
 			gpio_free(pin);
 		}
@@ -162,7 +162,7 @@ void __init rd88f5182_pci_preinit(void)
 		if (gpio_direction_input(pin) == 0) {
 			irq_set_irq_type(gpio_to_irq(pin), IRQ_TYPE_LEVEL_LOW);
 		} else {
-			printk(KERN_ERR "rd88f5182_pci_preinit faield to "
+			printk(KERN_ERR "rd88f5182_pci_preinit failed to "
 					"set_irq_type pin %d\n", pin);
 			gpio_free(pin);
 		}
-- 
1.7.6.5

