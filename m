Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab2KHNxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:53:10 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:57577 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755897Ab2KHNxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:53:07 -0500
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5/5] drivers: Remove reference to feature-removal-schedule.txt.
Date: Thu,  8 Nov 2012 21:50:35 +0800
Message-Id: <1352382635-2773-5-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1352382635-2773-1-git-send-email-tm@tao.ma>
References: <1352382402-2706-1-git-send-email-tm@tao.ma>
 <1352382635-2773-1-git-send-email-tm@tao.ma>
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 122.224.222.226 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

In 9c0ece069, Linus removed feature-removal-schedule.txt from Documentation,
but there is still some reference to this file. So remove them.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 drivers/mmc/host/Kconfig     |    4 +---
 drivers/net/wireless/Kconfig |    6 +-----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 9bf10e7..82fc4c8 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -282,9 +282,7 @@ config MMC_AT91
 	depends on ARCH_AT91
 	help
 	  This selects the AT91 MCI controller. This driver will
-	  be removed soon (for more information have a look to
-	  Documentation/feature-removal-schedule.txt). Please use
-	  MMC_ATMEL_MCI.
+	  be removed soon. Please use MMC_ATMEL_MCI.
 
 	  If unsure, say N.
 
diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 6deaae1..28aa05f 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -156,11 +156,7 @@ config PRISM54
 	---help---
 	  This enables support for FullMAC PCI/Cardbus prism54 devices. This
 	  driver is now deprecated in favor for the SoftMAC driver, p54pci.
-	  p54pci supports FullMAC PCI/Cardbus devices as well. For details on
-	  the scheduled removal of this driver on the kernel see the feature
-	  removal schedule:
-
-	  Documentation/feature-removal-schedule.txt
+	  p54pci supports FullMAC PCI/Cardbus devices as well.
 
 	  For more information refer to the p54 wiki:
 
-- 
1.7.0.4

