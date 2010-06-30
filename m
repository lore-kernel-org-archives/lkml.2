Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab0F3QBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 12:01:43 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:40039 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754561Ab0F3QBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 12:01:41 -0400
Date: Wed, 30 Jun 2010 18:01:39 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH 24/33] Removing dead ARCH_GUMSTIX_ORIG
Message-ID: <e2a294ec1d41f1198f7ffae0e8bed2f67b41bbe8.1277911346.git.siccegge@cs.fau.de>
References: <cover.1277911345.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1277911345.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARCH_GUMSTIX_ORIG doesn't exist in Kconfig, therefore removing all
references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/arm/mach-pxa/include/mach/gumstix.h |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-pxa/include/mach/gumstix.h b/arch/arm/mach-pxa/include/mach/gumstix.h
index 06abd41..9b89868 100644
--- a/arch/arm/mach-pxa/include/mach/gumstix.h
+++ b/arch/arm/mach-pxa/include/mach/gumstix.h
@@ -14,25 +14,15 @@
 
 /*
 GPIOn - Input from MAX823 (or equiv), normalizing USB +5V into a clean
-interrupt signal for determining cable presence. On the original gumstix,
-this is GPIO81, and GPIO83 needs to be defined as well. On the gumstix F,
+interrupt signal for determining cable presence. On the gumstix F,
 this moves to GPIO17 and GPIO37. */
 
 /* GPIOx - Connects to USB D+ and used as a pull-up after GPIOn
 has detected a cable insertion; driven low otherwise. */
 
-#ifdef CONFIG_ARCH_GUMSTIX_ORIG
-
-#define GPIO_GUMSTIX_USB_GPIOn		81
-#define GPIO_GUMSTIX_USB_GPIOx		83
-
-#else
-
 #define GPIO_GUMSTIX_USB_GPIOn		35
 #define GPIO_GUMSTIX_USB_GPIOx		41
 
-#endif
-
 /* usb state change */
 #define GUMSTIX_USB_INTR_IRQ		IRQ_GPIO(GPIO_GUMSTIX_USB_GPIOn)
 
-- 
1.7.0.4

