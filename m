Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab2BPOqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 09:46:21 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:43518 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752463Ab2BPOqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 09:46:19 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Russell King <linux@arm.linux.org.uk>
Cc: Danny Kukawka <dkukawka@suse.de>, "Simtec Linux Team" <linux@simtec.co.uk>,
        Daniel Silverstone <dsilvers@simtec.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch/arm/mach-ks8695/leds.c: included linux/gpio.h twice
Date: Thu, 16 Feb 2012 15:46:14 +0100
Message-Id: <1329403574-32717-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329403579;2d50c2d9;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/arm/mach-ks8695/leds.c: included 'linux/gpio.h' twice,
remove the duplicate.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 arch/arm/mach-ks8695/leds.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-ks8695/leds.c b/arch/arm/mach-ks8695/leds.c
index d6f6502..4bd7075 100644
--- a/arch/arm/mach-ks8695/leds.c
+++ b/arch/arm/mach-ks8695/leds.c
@@ -11,7 +11,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/gpio.h>
 
 #include <asm/leds.h>
 #include <mach/devices.h>
-- 
1.7.8.3

