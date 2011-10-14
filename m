Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832Ab1JNMca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 08:32:30 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:39681 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932724Ab1JNMc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 08:32:27 -0400
Subject: [PATCH 20/21] staging: drop unused Kconfig symbols
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 14:30:58 +0200
Message-ID: <1318595458.6132.79.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/staging/et131x/Kconfig   |    9 ---------
 drivers/staging/pohmelfs/Kconfig |    8 --------
 2 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/et131x/Kconfig b/drivers/staging/et131x/Kconfig
index e11cf34..f0ed08d 100644
--- a/drivers/staging/et131x/Kconfig
+++ b/drivers/staging/et131x/Kconfig
@@ -7,12 +7,3 @@ config ET131X
 
 	  To compile this driver as a module, choose M here. The module
 	  will be called et131x.
-
-config ET131X_DEBUG
-	bool "Enable et131x debugging"
-	depends on ET131X
-	default n
-	---help---
-	  Say Y for detailed debug information.
-
-	  If in doubt, say N.
diff --git a/drivers/staging/pohmelfs/Kconfig b/drivers/staging/pohmelfs/Kconfig
index 58158b8..8d53b1a 100644
--- a/drivers/staging/pohmelfs/Kconfig
+++ b/drivers/staging/pohmelfs/Kconfig
@@ -18,11 +18,3 @@ config POHMELFS_DEBUG
 	  Turns on excessive POHMELFS debugging facilities.
 	  You usually do not want to slow things down noticeably and get really
 	  lots of kernel messages in syslog.
-
-config POHMELFS_CRYPTO
-	bool "POHMELFS crypto support"
-	depends on POHMELFS
-	help
-	  This option allows to encrypt and/or protect with strong
-	  cryptographic hash all dataflow between server and clients.
-	  Each config group can have its own keys.
-- 
1.7.4.4




