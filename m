Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085Ab2HQHuL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 03:50:11 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42488 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932284Ab2HQHuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 03:50:08 -0400
From: Il Han <corone.il.han@gmail.com>
To: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Neil Brown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, Il Han <corone.il.han@gmail.com>
Subject: [PATCH] twl4030: It would be better not to use the 0b-prefix.
Date: Fri, 17 Aug 2012 16:49:43 +0900
Message-Id: <1345189783-19200-1-git-send-email-corone.il.han@gmail.com>
X-Mailer: git-send-email 1.7.11.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It would be better not to use the 0b-prefix for earlier versions of gcc-4.3.
Please, Modify it.

Signed-off-by: Il Han <corone.il.han@gmail.com>
---
 drivers/power/twl4030_charger.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/power/twl4030_charger.c b/drivers/power/twl4030_charger.c
index 15f4d5d..8d6bc68 100644
--- a/drivers/power/twl4030_charger.c
+++ b/drivers/power/twl4030_charger.c
@@ -41,16 +41,16 @@
 #define TWL4030_STS_VBUS	BIT(7)
 #define TWL4030_STS_USB_ID	BIT(2)
 #define TWL4030_BBCHEN		BIT(4)
-#define TWL4030_BBSEL_MASK	0b1100
-#define TWL4030_BBSEL_2V5	0b0000
-#define TWL4030_BBSEL_3V0	0b0100
-#define TWL4030_BBSEL_3V1	0b1000
-#define TWL4030_BBSEL_3V2	0b1100
-#define TWL4030_BBISEL_MASK	0b11
-#define TWL4030_BBISEL_25uA	0b00
-#define TWL4030_BBISEL_150uA	0b01
-#define TWL4030_BBISEL_500uA	0b10
-#define TWL4030_BBISEL_1000uA	0b11
+#define TWL4030_BBSEL_MASK	0x0c
+#define TWL4030_BBSEL_2V5	0x00
+#define TWL4030_BBSEL_3V0	0x04
+#define TWL4030_BBSEL_3V1	0x08
+#define TWL4030_BBSEL_3V2	0x0c
+#define TWL4030_BBISEL_MASK	0x03
+#define TWL4030_BBISEL_25uA	0x00
+#define TWL4030_BBISEL_150uA	0x01
+#define TWL4030_BBISEL_500uA	0x02
+#define TWL4030_BBISEL_1000uA	0x03
 
 /* BCI interrupts */
 #define TWL4030_WOVF		BIT(0) /* Watchdog overflow */
-- 
1.7.11.1

