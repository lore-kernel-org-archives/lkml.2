Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471Ab0ENNlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 09:41:16 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41947 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab0ENNlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 09:41:15 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Greg KH <gregkh@suse.de>,
       Wolfram Sang <w.sang@pengutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Florian Fainelli <florian@openwrt.org>,
       Eugene Konev <ejka@imfi.kspu.ru>
Subject: [PATCH] vlynq: make whole Kconfig-menu dependant on architecture
Date: Fri, 14 May 2010 15:40:45 +0200
Message-Id: <1273844445-15508-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.0
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes an empty menu for most platforms.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---

 drivers/vlynq/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/vlynq/Kconfig b/drivers/vlynq/Kconfig
index a9efb16..d874b4f 100644
--- a/drivers/vlynq/Kconfig
+++ b/drivers/vlynq/Kconfig
@@ -1,8 +1,8 @@
 menu "TI VLYNQ"
+	depends on AR7 && EXPERIMENTAL
 
 config VLYNQ
 	bool "TI VLYNQ bus support"
-	depends on AR7 && EXPERIMENTAL
 	help
 	  Support for Texas Instruments(R) VLYNQ bus.
 	  The VLYNQ bus is a high-speed, serial and packetized
-- 
1.7.0

