Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965458Ab2JWU7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:59:41 -0400
Received: from smtp.outflux.net ([198.145.64.163]:41694 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933426Ab2JWUFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:15 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 098/193] drivers/net/usb: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:51 -0700
Message-Id: <1351022666-6960-99-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351022666-6960-1-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config item has not carried much meaning for a while now and is
almost always enabled by default. As agreed during the Linux kernel
summit, remove it.

CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/usb/Kconfig |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index c1ae769..4d5c34d 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -8,8 +8,7 @@ menu "USB Network Adapters"
 	depends on USB && NET
 
 config USB_CATC
-	tristate "USB CATC NetMate-based Ethernet device support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "USB CATC NetMate-based Ethernet device support"
 	select CRC32
 	---help---
 	  Say Y if you want to use one of the following 10Mbps USB Ethernet
@@ -83,8 +82,7 @@ config USB_PEGASUS
 	  module will be called pegasus.
 
 config USB_RTL8150
-	tristate "USB RTL8150 based ethernet device support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "USB RTL8150 based ethernet device support"
 	select NET_CORE
 	select MII
 	help
@@ -188,7 +186,7 @@ config USB_NET_CDCETHER
 
 config USB_NET_CDC_EEM
 	tristate "CDC EEM support"
-	depends on USB_USBNET && EXPERIMENTAL
+	depends on USB_USBNET
 	help
 	  This option supports devices conforming to the Communication Device
 	  Class (CDC) Ethernet Emulation Model, a specification that's easy to
@@ -265,7 +263,7 @@ config USB_NET_PLUSB
 	tristate "Prolific PL-2301/2302/25A1 based cables"
 	# if the handshake/init/reset problems, from original 'plusb',
 	# are ever resolved ... then remove "experimental"
-	depends on USB_USBNET && EXPERIMENTAL
+	depends on USB_USBNET
 	help
 	  Choose this option if you're using a host-to-host cable
 	  with one of these chips.
@@ -279,8 +277,8 @@ config USB_NET_MCS7830
 	  adapters marketed under the DeLOCK brand.
 
 config USB_NET_RNDIS_HOST
-	tristate "Host for RNDIS and ActiveSync devices (EXPERIMENTAL)"
-	depends on USB_USBNET && EXPERIMENTAL
+	tristate "Host for RNDIS and ActiveSync devices"
+	depends on USB_USBNET
 	select USB_NET_CDCETHER
 	help
 	  This option enables hosting "Remote NDIS" USB networking links,
@@ -358,7 +356,7 @@ config USB_EPSON2888
 
 config USB_KC2190
 	boolean "KT Technology KC2190 based cables (InstaNet)"
-	depends on USB_NET_CDC_SUBSET && EXPERIMENTAL
+	depends on USB_NET_CDC_SUBSET
 	help
 	  Choose this option if you're using a host-to-host cable
 	  with one of these chips.
-- 
1.7.9.5

