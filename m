Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab2BPOoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 09:44:18 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:43364 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752511Ab2BPOoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 09:44:15 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Russell King <linux@arm.linux.org.uk>
Cc: Danny Kukawka <dkukawka@suse.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch/arm/mach-vexpress/v2m.c: included linux/device.h twice
Date: Thu, 16 Feb 2012 15:44:11 +0100
Message-Id: <1329403451-32383-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329403455;0c77221c;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/arm/mach-vexpress/v2m.c: included 'linux/device.h' twice,
remove the duplicate.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 arch/arm/mach-vexpress/v2m.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-vexpress/v2m.c b/arch/arm/mach-vexpress/v2m.c
index b4a28ca..7725766 100644
--- a/arch/arm/mach-vexpress/v2m.c
+++ b/arch/arm/mach-vexpress/v2m.c
@@ -10,7 +10,6 @@
 #include <linux/ata_platform.h>
 #include <linux/smsc911x.h>
 #include <linux/spinlock.h>
-#include <linux/device.h>
 #include <linux/usb/isp1760.h>
 #include <linux/clkdev.h>
 #include <linux/mtd/physmap.h>
-- 
1.7.8.3

