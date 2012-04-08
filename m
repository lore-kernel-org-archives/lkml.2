Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab2DHL6O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 07:58:14 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60292 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab2DHL6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 07:58:13 -0400
From: Michael Olbrich <m.olbrich@pengutronix.de>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Olbrich <m.olbrich@pengutronix.de>
Subject: [PATCH] watchdog: i6300esb: don't depend on X86
Date: Sun,  8 Apr 2012 13:56:06 +0200
Message-Id: <1333886166-27858-1-git-send-email-m.olbrich@pengutronix.de>
X-Mailer: git-send-email 1.7.9.5
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: mol@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i6300esb is on of the watchdogs QEMU can emulate. It is also available
when emulating ARM. The driver works without problems and is quite
useful to test userspace dealing with /dev/watchdog.

Signed-off-by: Michael Olbrich <m.olbrich@pengutronix.de>
---
 drivers/watchdog/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 3709624..6ea25f9 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -543,7 +543,7 @@ config WAFER_WDT
 
 config I6300ESB_WDT
 	tristate "Intel 6300ESB Timer/Watchdog"
-	depends on X86 && PCI
+	depends on PCI
 	---help---
 	  Hardware driver for the watchdog timer built into the Intel
 	  6300ESB controller hub.
-- 
1.7.9.5

