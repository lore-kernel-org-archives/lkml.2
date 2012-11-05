Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab2KEXWD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:22:03 -0500
Received: from smtp.outflux.net ([198.145.64.163]:53083 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755116Ab2KEXF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:26 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Karsten Keil <isdn@linux-pingi.de>
Subject: [PATCH 055/104] drivers/isdn/hisax: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:12 -0800
Message-Id: <1352156701-4038-56-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352156701-4038-1-git-send-email-keescook@chromium.org>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

CC: Karsten Keil <isdn@linux-pingi.de>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/isdn/hisax/Kconfig |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/isdn/hisax/Kconfig b/drivers/isdn/hisax/Kconfig
index 70ecd0c..5313c9e 100644
--- a/drivers/isdn/hisax/Kconfig
+++ b/drivers/isdn/hisax/Kconfig
@@ -389,8 +389,8 @@ config HISAX_TELES_CS
 comment "HiSax sub driver modules"
 
 config HISAX_ST5481
-	tristate "ST5481 USB ISDN modem (EXPERIMENTAL)"
-	depends on USB && EXPERIMENTAL
+	tristate "ST5481 USB ISDN modem"
+	depends on USB
 	select ISDN_HDLC
 	select CRC_CCITT
 	select BITREVERSE
@@ -399,20 +399,19 @@ config HISAX_ST5481
 	  e.g. the BeWan Gazel 128 USB
 
 config HISAX_HFCUSB
-	tristate "HFC USB based ISDN modems (EXPERIMENTAL)"
-	depends on USB && EXPERIMENTAL
+	tristate "HFC USB based ISDN modems"
+	depends on USB
 	help
 	  This enables the driver for HFC USB based ISDN modems.
 
 config HISAX_HFC4S8S
-	tristate "HFC-4S/8S based ISDN cards (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "HFC-4S/8S based ISDN cards"
 	help
 	  This enables the driver for HFC-4S/8S based ISDN cards.
 
 config HISAX_FRITZ_PCIPNP
-	tristate "AVM Fritz!Card PCI/PCIv2/PnP support (EXPERIMENTAL)"
-	depends on PCI && EXPERIMENTAL
+	tristate "AVM Fritz!Card PCI/PCIv2/PnP support"
+	depends on PCI
 	help
 	  This enables the driver for the AVM Fritz!Card PCI,
 	  Fritz!Card PCI v2 and Fritz!Card PnP.
-- 
1.7.9.5

