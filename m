Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965440Ab2JWU7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:59:20 -0400
Received: from smtp.outflux.net ([198.145.64.163]:53508 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933671Ab2JWUFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:16 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Greg Ungerer <gerg@uclinux.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 077/193] drivers/net/ethernet/8390: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:30 -0700
Message-Id: <1351022666-6960-78-git-send-email-keescook@chromium.org>
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

CC: "David S. Miller" <davem@davemloft.net>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Mathieu Poirier <mathieu.poirier@linaro.org>
CC: Greg Ungerer <gerg@uclinux.org>
CC: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/8390/Kconfig |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/8390/Kconfig b/drivers/net/ethernet/8390/Kconfig
index e1219e0..8e15bd4 100644
--- a/drivers/net/ethernet/8390/Kconfig
+++ b/drivers/net/ethernet/8390/Kconfig
@@ -5,10 +5,7 @@
 config NET_VENDOR_8390
 	bool "National Semi-conductor 8390 devices"
 	default y
-	depends on NET_VENDOR_NATSEMI && (AMIGA_PCMCIA || PCI || SUPERH || \
-		   ISA || MCA || EISA || MAC || M32R || MACH_TX49XX || \
-		   MCA_LEGACY || H8300 || ARM || MIPS || ZORRO || PCMCIA || \
-		   EXPERIMENTAL)
+	depends on NET_VENDOR_NATSEMI
 	---help---
 	  If you have a network (Ethernet) card belonging to this class, say Y
 	  and read the Ethernet-HOWTO, available from
@@ -34,8 +31,8 @@ config EL2
 	  will be called 3c503.
 
 config AC3200
-	tristate "Ansel Communications EISA 3200 support (EXPERIMENTAL)"
-	depends on PCI && (ISA || EISA) && EXPERIMENTAL
+	tristate "Ansel Communications EISA 3200 support"
+	depends on PCI && (ISA || EISA)
 	select CRC32
 	---help---
 	  If you have a network (Ethernet) card of this type, say Y and read
@@ -87,8 +84,8 @@ config E2100
 	  will be called e2100.
 
 config ES3210
-	tristate "Racal-Interlan EISA ES3210 support (EXPERIMENTAL)"
-	depends on PCI && EISA && EXPERIMENTAL
+	tristate "Racal-Interlan EISA ES3210 support"
+	depends on PCI && EISA
 	select CRC32
 	---help---
 	  If you have a network (Ethernet) card of this type, say Y and read
@@ -141,8 +138,8 @@ config ARM_ETHERH
 	  should say Y to this option if you wish to use it with Linux.
 
 config LNE390
-	tristate "Mylex EISA LNE390A/B support (EXPERIMENTAL)"
-	depends on PCI && EISA && EXPERIMENTAL
+	tristate "Mylex EISA LNE390A/B support"
+	depends on PCI && EISA
 	select CRC32
 	---help---
 	  If you have a network (Ethernet) card of this type, say Y and read
@@ -227,8 +224,8 @@ config APNE
 	  will be called apne.
 
 config NE3210
-	tristate "Novell/Eagle/Microdyne NE3210 EISA support (EXPERIMENTAL)"
-	depends on PCI && EISA && EXPERIMENTAL
+	tristate "Novell/Eagle/Microdyne NE3210 EISA support"
+	depends on PCI && EISA
 	select CRC32
 	---help---
 	  If you have a network (Ethernet) card of this type, say Y and read
-- 
1.7.9.5

