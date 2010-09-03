Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab0ICW3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 18:29:13 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37616 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab0ICW3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 18:29:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=l8mjqrM9+iGjFEh2s5GyupR+LKpIQjtQhSFRIMEdHos0jMPJf4GT1GFi9Qd+fdekth
         T4rMhb0EG5PmKtFQGEofUQ4wb7jzKi/nR2vO7ifX9CCz8Pe/lZ8tD1eFJdJFqYmtJbWv
         1mLWQghZXGdiFykO1FQ+aCBhLu4JmBSxrYnQs=
From: "Mark F. Brown" <mark.brown314@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        "Mark F. Brown" <mark.brown314@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Cc: "Mark F. Brown" <mark.brown314@gmail.com>
Subject: [PATCH v2 1/6 RESEND] ARM: pxa27x/pxa3xx: moved pxa27x_keypad.h to platform pxa directory
Date: Fri,  3 Sep 2010 18:28:06 -0400
Message-Id: <1283552891-13966-2-git-send-email-mark.brown314@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283552891-13966-1-git-send-email-mark.brown314@gmail.com>
References: <1283552891-13966-1-git-send-email-mark.brown314@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mach-mmp utilizes pxa27x_keypad code so we need to move header to
platform pxa directory.

Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>
---
 arch/arm/mach-pxa/devices.c                        |    2 +-
 arch/arm/mach-pxa/em-x270.c                        |    2 +-
 arch/arm/mach-pxa/ezx.c                            |    2 +-
 arch/arm/mach-pxa/littleton.c                      |    2 +-
 arch/arm/mach-pxa/mainstone.c                      |    4 ++--
 arch/arm/mach-pxa/mioa701.c                        |    2 +-
 arch/arm/mach-pxa/palmld.c                         |    2 +-
 arch/arm/mach-pxa/palmt5.c                         |    2 +-
 arch/arm/mach-pxa/palmtreo.c                       |    2 +-
 arch/arm/mach-pxa/palmtx.c                         |    2 +-
 arch/arm/mach-pxa/palmz72.c                        |    2 +-
 arch/arm/mach-pxa/tavorevb.c                       |    2 +-
 arch/arm/mach-pxa/z2.c                             |    2 +-
 arch/arm/mach-pxa/zylonite.c                       |    2 +-
 .../mach => plat-pxa/include/plat}/pxa27x_keypad.h |    0
 drivers/input/keyboard/pxa27x_keypad.c             |    2 +-
 16 files changed, 16 insertions(+), 16 deletions(-)
 rename arch/arm/{mach-pxa/include/mach => plat-pxa/include/plat}/pxa27x_keypad.h (100%)

diff --git a/arch/arm/mach-pxa/devices.c b/arch/arm/mach-pxa/devices.c
index a2fc859..08b4103 100644
--- a/arch/arm/mach-pxa/devices.c
+++ b/arch/arm/mach-pxa/devices.c
@@ -11,7 +11,7 @@
 #include <mach/mmc.h>
 #include <mach/irda.h>
 #include <mach/ohci.h>
-#include <mach/pxa27x_keypad.h>
+#include <plat/pxa27x_keypad.h>
 #include <mach/pxa2xx_spi.h>
 #include <mach/camera.h>
 #include <mach/audio.h>
diff --git a/arch/arm/mach-pxa/em-x270.c b/arch/arm/mach-pxa/em-x270.c
index 0517c17..51286a7 100644
--- a/arch/arm/mach-pxa/em-x270.c
+++ b/arch/arm/mach-pxa/em-x270.c
@@ -43,7 +43,7 @@
 #include <mach/pxafb.h>
 #include <mach/ohci.h>
 #include <mach/mmc.h>
-#include <mach/pxa27x_keypad.h>
+#include <plat/pxa27x_keypad.h>
 #include <plat/i2c.h>
 #include <mach/camera.h>
 #include <mach/pxa2xx_spi.h>
diff --git a/arch/arm/mach-pxa/ezx.c b/arch/arm/mach-pxa/ezx.c
index 3fe61f4..f997e84 100644
--- a/arch/arm/mach-pxa/ezx.c
+++ b/arch/arm/mach-pxa/ezx.c
@@ -32,7 +32,7 @@
 #include <mach/ohci.h>
 #include <plat/i2c.h>
 #include <mach/hardware.h>
-#include <mach/pxa27x_keypad.h>
+#include <plat/pxa27x_keypad.h>
 #include <mach/camera.h>
 
 #include "devices.h"
diff --git a/arch/arm/mach-pxa/littleton.c b/arch/arm/mach-pxa/littleton.c
index 83f3236..eb58506 100644
--- a/arch/arm/mach-pxa/littleton.c
+++ b/arch/arm/mach-pxa/littleton.c
@@ -43,7 +43,7 @@
 #include <mach/pxafb.h>
 #include <mach/mmc.h>
 #include <mach/pxa2xx_spi.h>
-#include <mach/pxa27x_keypad.h>
+#include <plat/pxa27x_keypad.h>
 #include <mach/littleton.h>
 #include <plat/i2c.h>
 #include <plat/pxa3xx_nand.h>
diff --git a/arch/arm/mach-pxa/mainstone.c b/arch/arm/mach-pxa/mainstone.c
index c2a8717..126dca1 100644
--- a/arch/arm/mach-pxa/mainstone.c
+++ b/arch/arm/mach-pxa/mainstone.c
@@ -41,7 +41,7 @@
 #include <asm/mach/irq.h>
 #include <asm/mach/flash.h>
 
-#include <mach/pxa27x.h>
+#include <plat/pxa27x.h>
 #include <mach/gpio.h>
 #include <mach/mainstone.h>
 #include <mach/audio.h>
@@ -50,7 +50,7 @@
 #include <mach/mmc.h>
 #include <mach/irda.h>
 #include <mach/ohci.h>
-#include <mach/pxa27x_keypad.h>
+#include <plat/pxa27x_keypad.h>
 
 #include "generic.h"
 #include "devices.h"
diff --git a/arch/arm/mach-pxa/mioa701.c b/arch/arm/mach-pxa/mioa701.c
index dc66942..ffb3f5a 100644
--- a/arch/arm/mach-pxa/mioa701.c
+++ b/arch/arm/mach-pxa/mioa701.c
@@ -45,7 +45,7 @@
 
 #include <mach/pxa27x.h>
 #include <mach/regs-rtc.h>
-#include <mach/pxa27x_keypad.h>
+#include <plat/pxa27x_keypad.h>
 #include <mach/pxafb.h>
 #include <mach/mmc.h>
 #include <mach/udc.h>
diff --git a/arch/arm/mach-pxa/palmld.c b/arch/arm/mach-pxa/palmld.c
index 91038ee..3ff0c4a 100644
--- a/arch/arm/mach-pxa/palmld.c
+++ b/arch/arm/mach-pxa/palmld.c
@@ -39,7 +39,7 @@
 #include <mach/mmc.h>
 #include <mach/pxafb.h>
 #include <mach/irda.h>
-#include <mach/pxa27x_keypad.h>
+#include <plat/pxa27x_keypad.h>
 #include <mach/palmasoc.h>
 #include <mach/palm27x.h>
 
diff --git a/arch/arm/mach-pxa/palmt5.c b/arch/arm/mach-pxa/palmt5.c
index 1c28199..5b9f766 100644
--- a/arch/arm/mach-pxa/palmt5.c
+++ b/arch/arm/mach-pxa/palmt5.c
@@ -39,7 +39,7 @@
 #include <mach/mmc.h>
 #include <mach/pxafb.h>
 #include <mach/irda.h>
-#include <mach/pxa27x_keypad.h>
+#include <plat/pxa27x_keypad.h>
 #include <mach/udc.h>
 #include <mach/palmasoc.h>
 #include <mach/palm27x.h>
diff --git a/arch/arm/mach-pxa/palmtreo.c b/arch/arm/mach-pxa/palmtreo.c
index 52defd5..f685a60 100644
--- a/arch/arm/mach-pxa/palmtreo.c
+++ b/arch/arm/mach-pxa/palmtreo.c
@@ -39,7 +39,7 @@
 #include <mach/mmc.h>
 #include <mach/pxafb.h>
 #include <mach/irda.h>
-#include <mach/pxa27x_keypad.h>
+#include <plat/pxa27x_keypad.h>
 #include <mach/udc.h>
 #include <mach/ohci.h>
 #include <mach/pxa2xx-regs.h>
diff --git a/arch/arm/mach-pxa/palmtx.c b/arch/arm/mach-pxa/palmtx.c
index 144dc2b..89a3792 100644
--- a/arch/arm/mach-pxa/palmtx.c
+++ b/arch/arm/mach-pxa/palmtx.c
@@ -43,7 +43,7 @@
 #include <mach/mmc.h>
 #include <mach/pxafb.h>
 #include <mach/irda.h>
-#include <mach/pxa27x_keypad.h>
+#include <plat/pxa27x_keypad.h>
 #include <mach/udc.h>
 #include <mach/palmasoc.h>
 #include <mach/palm27x.h>
diff --git a/arch/arm/mach-pxa/palmz72.c b/arch/arm/mach-pxa/palmz72.c
index 87e4b10..38f4425 100644
--- a/arch/arm/mach-pxa/palmz72.c
+++ b/arch/arm/mach-pxa/palmz72.c
@@ -41,7 +41,7 @@
 #include <mach/mmc.h>
 #include <mach/pxafb.h>
 #include <mach/irda.h>
-#include <mach/pxa27x_keypad.h>
+#include <plat/pxa27x_keypad.h>
 #include <mach/udc.h>
 #include <mach/palmasoc.h>
 #include <mach/palm27x.h>
diff --git a/arch/arm/mach-pxa/tavorevb.c b/arch/arm/mach-pxa/tavorevb.c
index f02dcb5..0f440c9 100644
--- a/arch/arm/mach-pxa/tavorevb.c
+++ b/arch/arm/mach-pxa/tavorevb.c
@@ -25,7 +25,7 @@
 
 #include <mach/pxa930.h>
 #include <mach/pxafb.h>
-#include <mach/pxa27x_keypad.h>
+#include <plat/pxa27x_keypad.h>
 
 #include "devices.h"
 #include "generic.h"
diff --git a/arch/arm/mach-pxa/z2.c b/arch/arm/mach-pxa/z2.c
index f0d0228..8c44bc4 100644
--- a/arch/arm/mach-pxa/z2.c
+++ b/arch/arm/mach-pxa/z2.c
@@ -37,7 +37,7 @@
 #include <mach/z2.h>
 #include <mach/pxafb.h>
 #include <mach/mmc.h>
-#include <mach/pxa27x_keypad.h>
+#include <plat/pxa27x_keypad.h>
 #include <mach/pxa2xx_spi.h>
 
 #include <plat/i2c.h>
diff --git a/arch/arm/mach-pxa/zylonite.c b/arch/arm/mach-pxa/zylonite.c
index 2edad61..69df3ed 100644
--- a/arch/arm/mach-pxa/zylonite.c
+++ b/arch/arm/mach-pxa/zylonite.c
@@ -30,7 +30,7 @@
 #include <mach/zylonite.h>
 #include <mach/mmc.h>
 #include <mach/ohci.h>
-#include <mach/pxa27x_keypad.h>
+#include <plat/pxa27x_keypad.h>
 #include <plat/pxa3xx_nand.h>
 
 #include "devices.h"
diff --git a/arch/arm/mach-pxa/include/mach/pxa27x_keypad.h b/arch/arm/plat-pxa/include/plat/pxa27x_keypad.h
similarity index 100%
rename from arch/arm/mach-pxa/include/mach/pxa27x_keypad.h
rename to arch/arm/plat-pxa/include/plat/pxa27x_keypad.h
diff --git a/drivers/input/keyboard/pxa27x_keypad.c b/drivers/input/keyboard/pxa27x_keypad.c
index 0e53b3b..0610d10 100644
--- a/drivers/input/keyboard/pxa27x_keypad.c
+++ b/drivers/input/keyboard/pxa27x_keypad.c
@@ -32,7 +32,7 @@
 #include <asm/mach/map.h>
 
 #include <mach/hardware.h>
-#include <mach/pxa27x_keypad.h>
+#include <plat/pxa27x_keypad.h>
 /*
  * Keypad Controller registers
  */
-- 
1.7.0.4

