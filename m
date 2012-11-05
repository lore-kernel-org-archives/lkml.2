Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933534Ab2KEXNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:13:17 -0500
Received: from smtp.outflux.net ([198.145.64.163]:35497 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162Ab2KEXFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:34 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 012/104] drivers/net/wireless: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:03:29 -0800
Message-Id: <1352156701-4038-13-git-send-email-keescook@chromium.org>
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

CC: "John W. Linville" <linville@tuxdriver.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/Kconfig |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 6deaae1..fbeb7ac 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -138,7 +138,7 @@ config AIRO_CS
 
 config PCMCIA_WL3501
 	tristate "Planet WL3501 PCMCIA cards"
-	depends on EXPERIMENTAL && PCMCIA
+	depends on PCMCIA
 	select WIRELESS_EXT
 	select WEXT_SPY
 	help
@@ -148,7 +148,7 @@ config PCMCIA_WL3501
 
 config PRISM54
 	tristate 'Intersil Prism GT/Duette/Indigo PCI/Cardbus (DEPRECATED)'
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	select WIRELESS_EXT
 	select WEXT_SPY
 	select WEXT_PRIV
@@ -191,7 +191,7 @@ config USB_ZD1201
 
 config USB_NET_RNDIS_WLAN
 	tristate "Wireless RNDIS USB support"
-	depends on USB && EXPERIMENTAL
+	depends on USB
 	depends on CFG80211
 	select USB_USBNET
 	select USB_NET_CDCETHER
@@ -221,7 +221,7 @@ source "drivers/net/wireless/rtl818x/Kconfig"
 
 config ADM8211
 	tristate "ADMtek ADM8211 support"
-	depends on MAC80211 && PCI && EXPERIMENTAL
+	depends on MAC80211 && PCI
 	select CRC32
 	select EEPROM_93CX6
 	---help---
@@ -261,7 +261,7 @@ config MAC80211_HWSIM
 
 config MWL8K
 	tristate "Marvell 88W8xxx PCI/PCIe Wireless support"
-	depends on MAC80211 && PCI && EXPERIMENTAL
+	depends on MAC80211 && PCI
 	---help---
 	  This driver supports Marvell TOPDOG 802.11 wireless cards.
 
-- 
1.7.9.5

