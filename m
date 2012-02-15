Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab2BOTTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 14:19:07 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:59977 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754779Ab2BOTTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 14:19:05 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: David Brown <davidb@codeaurora.org>
Cc: Danny Kukawka <dkukawka@suse.de>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch/arm/mach-msm: linux/gpio.h included twice
Date: Wed, 15 Feb 2012 20:18:48 +0100
Message-Id: <1329333528-31605-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329333545;97d5bfeb;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/arm/mach-msm/board-msm7x30.c and arch/arm/mach-msm/board-qsd8x50.c
included 'linux/gpio.h' twice, remove the duplicates.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 arch/arm/mach-msm/board-msm7x30.c |    1 -
 arch/arm/mach-msm/board-qsd8x50.c |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-msm/board-msm7x30.c b/arch/arm/mach-msm/board-msm7x30.c
index db81ed5..75b3cfc 100644
--- a/arch/arm/mach-msm/board-msm7x30.c
+++ b/arch/arm/mach-msm/board-msm7x30.c
@@ -17,7 +17,6 @@
 #include <linux/gpio.h>
 #include <linux/kernel.h>
 #include <linux/irq.h>
-#include <linux/gpio.h>
 #include <linux/platform_device.h>
 #include <linux/delay.h>
 #include <linux/io.h>
diff --git a/arch/arm/mach-msm/board-qsd8x50.c b/arch/arm/mach-msm/board-qsd8x50.c
index 7e8909c..fbaa4ed 100644
--- a/arch/arm/mach-msm/board-qsd8x50.c
+++ b/arch/arm/mach-msm/board-qsd8x50.c
@@ -17,7 +17,6 @@
 #include <linux/gpio.h>
 #include <linux/kernel.h>
 #include <linux/irq.h>
-#include <linux/gpio.h>
 #include <linux/platform_device.h>
 #include <linux/delay.h>
 #include <linux/usb/msm_hsusb.h>
-- 
1.7.8.3

