Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965063Ab2JWUkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:40:12 -0400
Received: from smtp.outflux.net ([198.145.64.163]:59506 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933820Ab2JWUFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:31 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Ivo van Doorn <IvDoorn@gmail.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 106/193] drivers/net/wireless/rt2x00: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:59 -0700
Message-Id: <1351022666-6960-107-git-send-email-keescook@chromium.org>
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

CC: Ivo van Doorn <IvDoorn@gmail.com>
CC: Gertjan van Wingerde <gwingerde@gmail.com>
CC: Helmut Schaa <helmut.schaa@googlemail.com>
CC: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/rt2x00/Kconfig |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index c7548da..b3d7e9a 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -81,8 +81,7 @@ config RT2800PCI_RT33XX
 	  Supported chips: RT3390
 
 config RT2800PCI_RT35XX
-	bool "rt2800pci - Include support for rt35xx devices (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "rt2800pci - Include support for rt35xx devices"
 	default y
 	---help---
 	  This adds support for rt35xx wireless chipset family to the
@@ -91,8 +90,7 @@ config RT2800PCI_RT35XX
 
 
 config RT2800PCI_RT53XX
-       bool "rt2800pci - Include support for rt53xx devices (EXPERIMENTAL)"
-       depends on EXPERIMENTAL
+       bool "rt2800pci - Include support for rt53xx devices"
        default y
        ---help---
          This adds support for rt53xx wireless chipset family to the
@@ -100,8 +98,7 @@ config RT2800PCI_RT53XX
          Supported chips: RT5390
 
 config RT2800PCI_RT3290
-       bool "rt2800pci - Include support for rt3290 devices (EXPERIMENTAL)"
-       depends on EXPERIMENTAL
+       bool "rt2800pci - Include support for rt3290 devices"
        default y
        ---help---
          This adds support for rt3290 wireless chipset family to the
@@ -158,8 +155,7 @@ config RT2800USB_RT33XX
 	  Supported chips: RT3370
 
 config RT2800USB_RT35XX
-	bool "rt2800usb - Include support for rt35xx devices (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "rt2800usb - Include support for rt35xx devices"
 	default y
 	---help---
 	  This adds support for rt35xx wireless chipset family to the
@@ -167,8 +163,7 @@ config RT2800USB_RT35XX
 	  Supported chips: RT3572
 
 config RT2800USB_RT53XX
-       bool "rt2800usb - Include support for rt53xx devices (EXPERIMENTAL)"
-       depends on EXPERIMENTAL
+       bool "rt2800usb - Include support for rt53xx devices"
        ---help---
          This adds support for rt53xx wireless chipset family to the
          rt2800usb driver.
-- 
1.7.9.5

