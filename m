Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965543Ab2JWVB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:01:28 -0400
Received: from smtp.outflux.net ([198.145.64.163]:48300 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933707Ab2JWUFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:14 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>
Subject: [PATCH 083/193] drivers/net/ethernet/intel: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:36 -0700
Message-Id: <1351022666-6960-84-git-send-email-keescook@chromium.org>
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

CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC: Jesse Brandeburg <jesse.brandeburg@intel.com>
CC: Bruce Allan <bruce.w.allan@intel.com>
CC: Carolyn Wyborny <carolyn.wyborny@intel.com>
CC: Don Skidmore <donald.c.skidmore@intel.com>
CC: Greg Rose <gregory.v.rose@intel.com>
CC: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
CC: Alex Duyck <alexander.h.duyck@intel.com>
CC: John Ronciak <john.ronciak@intel.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/intel/Kconfig |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index 0cafe4f..ec45200 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -5,11 +5,6 @@
 config NET_VENDOR_INTEL
 	bool "Intel devices"
 	default y
-	depends on PCI || PCI_MSI || ISA || ISA_DMA_API || ARM || \
-		   ARCH_ACORN || MCA || MCA_LEGACY || SNI_RM || SUN3 || \
-		   GSC || BVME6000 || MVME16x || \
-		   (ARM && ARCH_IXP4XX && IXP4XX_NPE && IXP4XX_QMGR) || \
-		   EXPERIMENTAL
 	---help---
 	  If you have a network (Ethernet) card belonging to this class, say Y
 	  and read the Ethernet-HOWTO, available from
@@ -123,7 +118,7 @@ config IGB_DCA
 config IGB_PTP
 	bool "PTP Hardware Clock (PHC)"
 	default n
-	depends on IGB && EXPERIMENTAL
+	depends on IGB
 	select PPS
 	select PTP_1588_CLOCK
 	---help---
@@ -225,7 +220,7 @@ config IXGBE_DCB
 config IXGBE_PTP
 	bool "PTP Clock Support"
 	default n
-	depends on IXGBE && EXPERIMENTAL
+	depends on IXGBE
 	select PPS
 	select PTP_1588_CLOCK
 	---help---
-- 
1.7.9.5

