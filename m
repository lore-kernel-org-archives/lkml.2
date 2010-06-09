Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434Ab0FITip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 15:38:45 -0400
Received: from mail.perches.com ([173.55.12.10]:2938 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932219Ab0FITin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 15:38:43 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Wan ZongShun <mcuos.com@gmail.com>
Subject: [PATCH 02/12] MAINTAINERS: Update ARM/NUVOTON W90X900 ARM ARCHITECTURE file patterns
Date: Wed,  9 Jun 2010 12:38:28 -0700
Message-Id: <6d429f15de979525b295a490c68004a9ac2551a0.1276112117.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
In-Reply-To: <cover.1276112117.git.joe@perches.com>
References: <cover.1276112117.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
Cc:  Wan ZongShun <mcuos.com@gmail.com>
---
 MAINTAINERS |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2af46b6..9046e97 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -974,12 +974,11 @@ F:	drivers/input/keyboard/w90p910_keypad.c
 F:	drivers/input/touchscreen/w90p910_ts.c
 F:	drivers/watchdog/nuc900_wdt.c
 F:	drivers/net/arm/w90p910_ether.c
-F:	drivers/mtd/nand/w90p910_nand.c
+F:	drivers/mtd/nand/nuc900_nand.c
 F:	drivers/rtc/rtc-nuc900.c
 F:	drivers/spi/spi_nuc900.c
 F:	drivers/usb/host/ehci-w90x900.c
 F:	drivers/video/nuc900fb.c
-F:	drivers/sound/soc/nuc900/
 
 ARM/U300 MACHINE SUPPORT
 M:	Linus Walleij <linus.walleij@stericsson.com>
-- 
1.7.1.244.gbdc4

