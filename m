Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965525Ab2JWU7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:59:47 -0400
Received: from smtp.outflux.net ([198.145.64.163]:36650 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933714Ab2JWUFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:14 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 081/193] drivers/net/ethernet/i825xx: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:34 -0700
Message-Id: <1351022666-6960-82-git-send-email-keescook@chromium.org>
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

CC: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: "David S. Miller" <davem@davemloft.net>
CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/i825xx/Kconfig |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/i825xx/Kconfig b/drivers/net/ethernet/i825xx/Kconfig
index 959faf7..dedfa3a 100644
--- a/drivers/net/ethernet/i825xx/Kconfig
+++ b/drivers/net/ethernet/i825xx/Kconfig
@@ -5,9 +5,7 @@
 config NET_VENDOR_I825XX
 	bool "Intel (82586/82593/82596) devices"
 	default y
-	depends on NET_VENDOR_INTEL && (ISA || ISA_DMA_API || ARM || \
-		   ARCH_ACORN || MCA || MCA_LEGACY || SNI_RM || SUN3 || \
-		   GSC || BVME6000 || MVME16x || EXPERIMENTAL)
+	depends on NET_VENDOR_INTEL
 	---help---
 	  If you have a network (Ethernet) card belonging to this class, say Y
 	  and read the Ethernet-HOWTO, available from
@@ -33,8 +31,8 @@ config ELPLUS
 	  will be called 3c505.
 
 config EL16
-	tristate "3c507 \"EtherLink 16\" support (EXPERIMENTAL)"
-	depends on ISA && EXPERIMENTAL
+	tristate "3c507 \"EtherLink 16\" support"
+	depends on ISA
 	---help---
 	  If you have a network (Ethernet) card of this type, say Y and read
 	  the Ethernet-HOWTO, available from
@@ -149,8 +147,8 @@ config SUN3_82586
 	  VME boards.
 
 config ZNET
-	tristate "Zenith Z-Note support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && ISA_DMA_API && X86
+	tristate "Zenith Z-Note support"
+	depends on ISA_DMA_API && X86
 	---help---
 	  The Zenith Z-Note notebook computer has a built-in network
 	  (Ethernet) card, and this is the Linux driver for it. Note that the
-- 
1.7.9.5

