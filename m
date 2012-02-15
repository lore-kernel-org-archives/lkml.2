Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab2BOTTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 14:19:35 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:60041 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754872Ab2BOTTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 14:19:31 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Danny Kukawka <dkukawka@suse.de>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch/arm/mach-pxa/pxa27x.c: included linux/gpio.h twice
Date: Wed, 15 Feb 2012 20:19:25 +0100
Message-Id: <1329333565-31718-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329333571;272ed504;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/arm/mach-pxa/pxa27x.c included 'linux/gpio.h' twice, remove
the duplicate.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 arch/arm/mach-pxa/pxa27x.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-pxa/pxa27x.c b/arch/arm/mach-pxa/pxa27x.c
index aed6cbc..c1673b3 100644
--- a/arch/arm/mach-pxa/pxa27x.c
+++ b/arch/arm/mach-pxa/pxa27x.c
@@ -22,7 +22,6 @@
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/i2c/pxa-i2c.h>
-#include <linux/gpio.h>
 
 #include <asm/mach/map.h>
 #include <mach/hardware.h>
-- 
1.7.8.3

