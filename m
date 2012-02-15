Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab2BOTTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 14:19:45 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:60065 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754972Ab2BOTTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 14:19:42 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Danny Kukawka <dkukawka@suse.de>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch/arm/mach-ux500/board-mop500-u8500uib.c: included linux/gpio.h twice
Date: Wed, 15 Feb 2012 20:19:38 +0100
Message-Id: <1329333578-31773-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329333582;9eb1a1f3;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/arm/mach-ux500/board-mop500-u8500uib.c included 'linux/gpio.h'
remove the duplicate.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 arch/arm/mach-ux500/board-mop500-u8500uib.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-u8500uib.c b/arch/arm/mach-ux500/board-mop500-u8500uib.c
index feb5744..ead91c9 100644
--- a/arch/arm/mach-ux500/board-mop500-u8500uib.c
+++ b/arch/arm/mach-ux500/board-mop500-u8500uib.c
@@ -8,7 +8,6 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/i2c.h>
-#include <linux/gpio.h>
 #include <linux/interrupt.h>
 #include <linux/mfd/tc3589x.h>
 #include <linux/input/matrix_keypad.h>
-- 
1.7.8.3

