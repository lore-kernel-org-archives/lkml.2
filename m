Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab2JHKrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 06:47:48 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60790 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab2JHKrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 06:47:45 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Jiri Kosina <trivial@kernel.org>
Subject: [PATCH] trivial: Fix trailing white space
Date: Mon,  8 Oct 2012 12:47:40 +0200
Message-Id: <1349693260-30580-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just remove trailing white spaces.

Signed-off-by: Michal Simek <monstr@monstr.eu>
CC: Jiri Kosina <trivial@kernel.org>
---
 drivers/block/Kconfig |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index a796407..f819350 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -144,13 +144,13 @@ config CISS_SCSI_TAPE
 	depends on SCSI=y || SCSI=BLK_CPQ_CISS_DA
 	help
 	  When enabled (Y), this option allows SCSI tape drives and SCSI medium
-	  changers (tape robots) to be accessed via a Compaq 5xxx array 
+	  changers (tape robots) to be accessed via a Compaq 5xxx array
 	  controller.  (See <file:Documentation/blockdev/cciss.txt> for more details.)
 
-	  "SCSI support" and "SCSI tape support" must also be enabled for this 
+	  "SCSI support" and "SCSI tape support" must also be enabled for this
 	  option to work.
 
-	  When this option is disabled (N), the SCSI portion of the driver 
+	  When this option is disabled (N), the SCSI portion of the driver
 	  is not compiled.
 
 config BLK_DEV_DAC960
@@ -279,7 +279,7 @@ config BLK_DEV_CRYPTOLOOP
 	select CRYPTO_CBC
 	depends on BLK_DEV_LOOP
 	---help---
-	  Say Y here if you want to be able to use the ciphers that are 
+	  Say Y here if you want to be able to use the ciphers that are
 	  provided by the CryptoAPI as loop transformation. This might be
 	  used as hard disk encryption.
 
@@ -348,7 +348,7 @@ config BLK_DEV_SX8
 	tristate "Promise SATA SX8 support"
 	depends on PCI
 	---help---
-	  Saying Y or M here will enable support for the 
+	  Saying Y or M here will enable support for the
 	  Promise SATA SX8 controllers.
 
 	  Use devices /dev/sx8/$N and /dev/sx8/$Np$M.
-- 
1.7.0.4

