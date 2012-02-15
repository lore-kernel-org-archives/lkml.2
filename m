Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab2BOTTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 14:19:17 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:60001 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754965Ab2BOTTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 14:19:15 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Russell King <linux@arm.linux.org.uk>
Cc: Danny Kukawka <dkukawka@suse.de>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch/arm/mach-pxa/pxa27x.c: included linux/device.h twice
Date: Wed, 15 Feb 2012 20:19:09 +0100
Message-Id: <1329333549-31663-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329333555;10bafb33;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/arm/mach-lpc32xx/phy3250.c included 'linux/device.h' twice,
remove the duplicate.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 arch/arm/mach-lpc32xx/phy3250.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-lpc32xx/phy3250.c b/arch/arm/mach-lpc32xx/phy3250.c
index bfee5b4..8e312db 100644
--- a/arch/arm/mach-lpc32xx/phy3250.c
+++ b/arch/arm/mach-lpc32xx/phy3250.c
@@ -22,7 +22,6 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/dma-mapping.h>
-#include <linux/device.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/eeprom.h>
 #include <linux/leds.h>
-- 
1.7.8.3

