Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab2BPOps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 09:45:48 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:43485 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752523Ab2BPOpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 09:45:47 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Danny Kukawka <dkukawka@suse.de>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch/arm/mach-pxa/: included linux/gpio.h twice
Date: Thu, 16 Feb 2012 15:45:42 +0100
Message-Id: <1329403542-32606-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329403546;f6acdb2a;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/arm/mach-pxa/pxa25x.c and arch/arm/mach-pxa/saarb.c
included 'linux/gpio.h' twice, remove the duplicates.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 arch/arm/mach-pxa/pxa25x.c |    1 -
 arch/arm/mach-pxa/saarb.c  |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-pxa/pxa25x.c b/arch/arm/mach-pxa/pxa25x.c
index 91e4f6c..00d6eac 100644
--- a/arch/arm/mach-pxa/pxa25x.c
+++ b/arch/arm/mach-pxa/pxa25x.c
@@ -25,7 +25,6 @@
 #include <linux/suspend.h>
 #include <linux/syscore_ops.h>
 #include <linux/irq.h>
-#include <linux/gpio.h>
 
 #include <asm/mach/map.h>
 #include <asm/suspend.h>
diff --git a/arch/arm/mach-pxa/saarb.c b/arch/arm/mach-pxa/saarb.c
index febc809..5aded5e 100644
--- a/arch/arm/mach-pxa/saarb.c
+++ b/arch/arm/mach-pxa/saarb.c
@@ -15,7 +15,6 @@
 #include <linux/i2c.h>
 #include <linux/i2c/pxa-i2c.h>
 #include <linux/mfd/88pm860x.h>
-#include <linux/gpio.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
-- 
1.7.8.3

