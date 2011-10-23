Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845Ab1JWP1u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 11:27:50 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:57437 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab1JWP1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 11:27:48 -0400
Subject: [PATCH] [TRIVIAL] powerpc: 4xx: remove commented out Kconfig
 entries
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 23 Oct 2011 17:25:59 +0200
Message-ID: <1319383559.6286.9.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These Kconfig entries have been commented out ever since commit f6557331
("[...] Re-organize Kconfig code for 4xx in arch/powerpc"). There's no
indication why they're commented out. It looks like they're just "old,
unused [...] config options" that were not removed, as other entries
were in that commit, but only commented out. They might as well be
removed now.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
"git grep" tested only.

 arch/powerpc/platforms/40x/Kconfig |   38 ------------------------------------
 arch/powerpc/platforms/44x/Kconfig |   16 ---------------
 2 files changed, 0 insertions(+), 54 deletions(-)

diff --git a/arch/powerpc/platforms/40x/Kconfig b/arch/powerpc/platforms/40x/Kconfig
index d733d7c..e568e85 100644
--- a/arch/powerpc/platforms/40x/Kconfig
+++ b/arch/powerpc/platforms/40x/Kconfig
@@ -1,19 +1,3 @@
-#config BUBINGA
-#	bool "Bubinga"
-#	depends on 40x
-#	default n
-#	select 405EP
-#	help
-#	  This option enables support for the IBM 405EP evaluation board.
-
-#config CPCI405
-#	bool "CPCI405"
-#	depends on 40x
-#	default n
-#	select 405GP
-#	help
-#	  This option enables support for the CPCI405 board.
-
 config ACADIA
 	bool "Acadia"
 	depends on 40x
@@ -73,14 +57,6 @@ config MAKALU
 	help
 	  This option enables support for the AMCC PPC405EX board.
 
-#config SYCAMORE
-#	bool "Sycamore"
-#	depends on 40x
-#	default n
-#	select 405GPR
-#	help
-#	  This option enables support for the IBM PPC405GPr evaluation board.
-
 config WALNUT
 	bool "Walnut"
 	depends on 40x
@@ -185,17 +161,3 @@ config IBM405_ERR77
 # All 40x-based cores, up until the 405GPR and 405EP have this errata.
 config IBM405_ERR51
 	bool
-
-#config BIOS_FIXUP
-#	bool
-#	depends on BUBINGA || EP405 || SYCAMORE || WALNUT
-#	default y
-
-#config PPC4xx_DMA
-#	bool "PPC4xx DMA controller support"
-#	depends on 4xx
-
-#config PPC4xx_EDMA
-#	bool
-#	depends on !STB03xxx && PPC4xx_DMA
-#	default y
diff --git a/arch/powerpc/platforms/44x/Kconfig b/arch/powerpc/platforms/44x/Kconfig
index e958b6f..595e28a 100644
--- a/arch/powerpc/platforms/44x/Kconfig
+++ b/arch/powerpc/platforms/44x/Kconfig
@@ -197,22 +197,6 @@ config ICON
 	help
 	  This option enables support for the AMCC PPC440SPe evaluation board.
 
-#config LUAN
-#	bool "Luan"
-#	depends on 44x
-#	default n
-#	select 440SP
-#	help
-#	  This option enables support for the IBM PPC440SP evaluation board.
-
-#config OCOTEA
-#	bool "Ocotea"
-#	depends on 44x
-#	default n
-#	select 440GX
-#	help
-#	  This option enables support for the IBM PPC440GX evaluation board.
-
 config XILINX_VIRTEX440_GENERIC_BOARD
 	bool "Generic Xilinx Virtex 5 FXT board support"
 	depends on 44x
-- 
1.7.4.4



