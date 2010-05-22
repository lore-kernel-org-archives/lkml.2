Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab0EVOPP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 10:15:15 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:63384 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901Ab0EVOPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 10:15:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=dFrYuOG4HdyhwFAViHe07stuyKhOYwXw3N5w74r2xojWx48FeZJwKrChGIczaUquhy
         32F6YzDOsYblWaU7152pNHfDzyQKcEDz+R3+BoxH85E6SCLNUNjSNMUmLFmT83om1cnb
         nkN6xSTKX5mbRTob9xzMc/AgZ6iHt0P2RCgK8=
Message-ID: <4BF7E6EC.7010505@gmail.com>
Date: Sat, 22 May 2010 22:15:08 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] NUC900: add maintainer entries for Wan ZongShun.
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Andrew,

I want to add some files entries in MAINTAINER files
for Winbond/Nuvoton ARM platform.

Could you help me merge this patch?

Thanks a lot.

>From 4e5326dbfbfdad58eb2c333df91c15993bce6c47 Mon Sep 17 00:00:00 2001
From: zswan <zswan@zswan-marvell.(none)>
Date: Sat, 22 May 2010 21:56:26 +0800
Subject: [PATCH] add maintainer file entries

---
 MAINTAINERS |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d329b05..d6b3777 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -970,6 +970,18 @@ M:	Wan ZongShun <mcuos.com@gmail.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.mcuos.com
 S:	Maintained
+F:	arch/arm/mach-w90x900/
+F:	arch/arm/mach-nuc93x/
+F:	drivers/input/keyboard/w90p910_keypad.c
+F:	drivers/input/touchscreen/w90p910_ts.c
+F:	drivers/watchdog/nuc900_wdt.c
+F:	drivers/net/arm/w90p910_ether.c
+F:	drivers/mtd/nand/w90p910_nand.c
+F:	drivers/rtc/rtc-nuc900.c
+F:	drivers/spi/spi_nuc900.c
+F:	drivers/usb/host/ehci-w90x900.c
+F:	drivers/video/nuc900fb.c
+F:	drivers/sound/soc/nuc900/

 ARM/U300 MACHINE SUPPORT
 M:	Linus Walleij <linus.walleij@stericsson.com>
-- 
1.6.3.3
