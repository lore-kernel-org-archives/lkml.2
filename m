Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab0I3Onz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 10:43:55 -0400
Received: from smtp.netsonic.fi ([194.29.192.26]:43681 "EHLO smtp.netsonic.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756593Ab0I3Onx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 10:43:53 -0400
From: Timo Juhani Lindfors <timo.lindfors@iki.fi>
To: linux-watchdog@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Timo Juhani Lindfors <timo.lindfors@iki.fi>
Subject: [PATCH 1/2] watchdog: it8712f_wdt: Add comments for config/control register names
Date: Thu, 30 Sep 2010 17:08:03 +0300
Message-Id: <1285855684-8369-1-git-send-email-timo.lindfors@iki.fi>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Timo Juhani Lindfors <timo.lindfors@iki.fi>
---
 drivers/watchdog/it8712f_wdt.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/watchdog/it8712f_wdt.c b/drivers/watchdog/it8712f_wdt.c
index f52c162..b08fae6 100644
--- a/drivers/watchdog/it8712f_wdt.c
+++ b/drivers/watchdog/it8712f_wdt.c
@@ -75,15 +75,15 @@ static unsigned short address;
 #define WDT_CONFIG	0x72	/* WDT Register: Configuration */
 #define WDT_TIMEOUT	0x73	/* WDT Register: Timeout Value */
 
-#define WDT_RESET_GAME	0x10
-#define WDT_RESET_KBD	0x20
-#define WDT_RESET_MOUSE	0x40
-#define WDT_RESET_CIR	0x80
+#define WDT_RESET_GAME	0x10	/* Reset timer on read or write to game port */
+#define WDT_RESET_KBD	0x20	/* Reset timer on keyboard interrupt */
+#define WDT_RESET_MOUSE	0x40	/* Reset timer on mouse interrupt */
+#define WDT_RESET_CIR	0x80	/* Reset timer on consumer IR interrupt */
 
 #define WDT_UNIT_SEC	0x80	/* If 0 in MINUTES */
 
-#define WDT_OUT_PWROK	0x10
-#define WDT_OUT_KRST	0x40
+#define WDT_OUT_PWROK	0x10	/* Pulse PWROK on timeout */
+#define WDT_OUT_KRST	0x40	/* Pulse reset on timeout */
 
 static int superio_inb(int reg)
 {
-- 
1.7.1

