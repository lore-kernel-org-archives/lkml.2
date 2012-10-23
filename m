Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965532Ab2JWVB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:01:27 -0400
Received: from smtp.outflux.net ([198.145.64.163]:42423 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933709Ab2JWUFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:14 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 085/193] drivers/net/ethernet/natsemi: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:38 -0700
Message-Id: <1351022666-6960-86-git-send-email-keescook@chromium.org>
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
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/natsemi/Kconfig |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/Kconfig b/drivers/net/ethernet/natsemi/Kconfig
index f157334..a100860 100644
--- a/drivers/net/ethernet/natsemi/Kconfig
+++ b/drivers/net/ethernet/natsemi/Kconfig
@@ -5,9 +5,6 @@
 config NET_VENDOR_NATSEMI
 	bool "National Semi-conductor devices"
 	default y
-	depends on AMIGA_PCMCIA || ARM || EISA || EXPERIMENTAL || H8300 || \
-		   ISA || M32R || MAC || MACH_JAZZ || MACH_TX49XX || MIPS || \
-		   PCI || PCMCIA || SUPERH || XTENSA_PLATFORM_XT2000 || ZORRO
 	---help---
 	  If you have a network (Ethernet) card belonging to this class, say Y
 	  and read the Ethernet-HOWTO, available from
-- 
1.7.9.5

