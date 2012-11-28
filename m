Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab2K1PnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 10:43:00 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:57591 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab2K1Pm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 10:42:59 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] messages: i2o: Fix typo in messages/i2o
Date: Thu, 29 Nov 2012 00:42:51 +0900
Message-Id: <1354117371-5452-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.0.1.244.g77b598b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in messages/i2o.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/message/i2o/README.ioctl | 12 ++++++------
 drivers/message/i2o/i2o_block.c  |  2 +-
 drivers/message/i2o/i2o_config.c |  2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/message/i2o/README.ioctl b/drivers/message/i2o/README.ioctl
index 5fb195af4..4a7d2eb 100644
--- a/drivers/message/i2o/README.ioctl
+++ b/drivers/message/i2o/README.ioctl
@@ -138,7 +138,7 @@ VI. Setting Parameters
 
    The return value is the size in bytes of the data written into
    ops->resbuf if no errors occur.  If an error occurs, -1 is returned 
-   and errno is set appropriatly:
+   and errno is set appropriately:
 
       EFAULT      Invalid user space pointer was passed
       ENXIO       Invalid IOP number
@@ -222,7 +222,7 @@ VIII. Downloading Software
    RETURNS
 
    This function returns 0 no errors occur. If an error occurs, -1 
-   is returned and errno is set appropriatly:
+   is returned and errno is set appropriately:
 
       EFAULT      Invalid user space pointer was passed
       ENXIO       Invalid IOP number
@@ -264,7 +264,7 @@ IX. Uploading Software
    RETURNS
 
    This function returns 0 if no errors occur.  If an error occurs, -1
-   is returned and errno is set appropriatly:
+   is returned and errno is set appropriately:
 
       EFAULT      Invalid user space pointer was passed
       ENXIO       Invalid IOP number
@@ -301,7 +301,7 @@ X. Removing Software
    RETURNS
 
    This function returns 0 if no errors occur.  If an error occurs, -1
-   is returned and errno is set appropriatly:
+   is returned and errno is set appropriately:
 
       EFAULT      Invalid user space pointer was passed
       ENXIO       Invalid IOP number
@@ -325,7 +325,7 @@ X. Validating Configuration
    RETURNS
 
    This function returns 0 if no erro occur.  If an error occurs, -1 is
-   returned and errno is set appropriatly:
+   returned and errno is set appropriately:
 
       ETIMEDOUT   Timeout waiting for reply message
       ENXIO       Invalid IOP number
@@ -360,7 +360,7 @@ XI. Configuration Dialog
    RETURNS
 
    This function returns 0 if no error occur. If an error occurs, -1
-   is returned and errno is set appropriatly:
+   is returned and errno is set appropriately:
 
       EFAULT      Invalid user space pointer was passed
       ENXIO       Invalid IOP number
diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
index 4796bbf..49e86ae 100644
--- a/drivers/message/i2o/i2o_block.c
+++ b/drivers/message/i2o/i2o_block.c
@@ -609,7 +609,7 @@ static int i2o_block_release(struct gendisk *disk, fmode_t mode)
 	u8 operation;
 
 	/*
-	 * This is to deail with the case of an application
+	 * This is to deal with the case of an application
 	 * opening a device and then the device disappears while
 	 * it's in use, and then the application tries to release
 	 * it.  ex: Unmounting a deleted RAID volume at reboot.
diff --git a/drivers/message/i2o/i2o_config.c b/drivers/message/i2o/i2o_config.c
index 9a49c24..5451bef 100644
--- a/drivers/message/i2o/i2o_config.c
+++ b/drivers/message/i2o/i2o_config.c
@@ -189,7 +189,7 @@ static int i2o_cfg_parms(unsigned long arg, unsigned int type)
 		return -ENXIO;
 
 	/*
-	 * Stop users being able to try and allocate arbitary amounts
+	 * Stop users being able to try and allocate arbitrary amounts
 	 * of DMA space. 64K is way more than sufficient for this.
 	 */
 	if (kcmd.oplen > 65536)
-- 
1.8.0.1.244.g77b598b

