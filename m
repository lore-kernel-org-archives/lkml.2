Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab1JJJoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 05:44:55 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:57392 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab1JJJoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 05:44:54 -0400
Subject: [PATCH] [TRIVIAL] Kconfig: remove CONFIG_ prefix on two symbols
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Oct 2011 11:44:51 +0200
Message-ID: <1318239891.29265.7.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
These two changes are trivial in the sense that it's clear what is
intended here. On the other hand I assume they influence the output of
the config tools. So perhaps these two changes need review by the
maintainers of these files.

 arch/powerpc/platforms/85xx/Kconfig |    2 +-
 drivers/ide/Kconfig                 |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/85xx/Kconfig b/arch/powerpc/platforms/85xx/Kconfig
index 498534c..12f5932 100644
--- a/arch/powerpc/platforms/85xx/Kconfig
+++ b/arch/powerpc/platforms/85xx/Kconfig
@@ -80,7 +80,7 @@ config P1010_RDB
 config P1022_DS
 	bool "Freescale P1022 DS"
 	select DEFAULT_UIMAGE
-	select CONFIG_PHYS_64BIT	# The DTS has 36-bit addresses
+	select PHYS_64BIT	# The DTS has 36-bit addresses
 	select SWIOTLB
 	help
 	  This option enables support for the Freescale P1022DS reference board.
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 9827c5e..075f322 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -681,7 +681,7 @@ config BLK_DEV_IDE_AU1XXX
        select IDE_XFER_MODE
 choice
        prompt "IDE Mode for AMD Alchemy Au1200"
-       default CONFIG_BLK_DEV_IDE_AU1XXX_PIO_DBDMA
+       default BLK_DEV_IDE_AU1XXX_PIO_DBDMA
        depends on SOC_AU1200 && BLK_DEV_IDE_AU1XXX
 
 config BLK_DEV_IDE_AU1XXX_PIO_DBDMA
-- 
1.7.4.4

