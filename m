Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834Ab0FQI7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 04:59:00 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37525 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932804Ab0FQI66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 04:58:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=HCeZT93yqj9kJNvoSu33zXU/5A0mlBPuEWi3If1DBcuRrqvkpjvofkzDR40i7cWXd6
         UCVZ4fv4CvOX3iU8BcTonPDd0N1Ra17YFV1a0rzcKTVnA1IKswTIUjM3BaqvrPlPs2gV
         mOjE7ukjPXWQhwD+fw7PMzlKJTRYF9S+a/Eqk=
From: Matti Lammi <mattij.lammi@gmail.com>
To: gregkh@suse.de, mattij.lammi@gmail.com, mithlesh@linsyssoft.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Drivers: Staging: Fixed all the space issues
Date: Thu, 17 Jun 2010 11:58:52 +0300
Message-Id: <1276765132-15759-1-git-send-email-mattij.lammi@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed all warning reported by the checkpatch.pl tool by removing unnecessary
spaces.

Signed-off-by: Matti Lammi <mattij.lammi@gmail.com>
---
 drivers/staging/otus/oal_marc.h |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/otus/oal_marc.h b/drivers/staging/otus/oal_marc.h
index e7a9081..5ee677d 100644
--- a/drivers/staging/otus/oal_marc.h
+++ b/drivers/staging/otus/oal_marc.h
@@ -62,0 +62,0 @@

 /***** Byte order converting *****/
 #ifdef ZM_CONFIG_BIG_ENDIAN
-#define zmw_cpu_to_le32(v)    	(((v & 0xff000000) >> 24) | 	\
-				((v & 0x00ff0000) >> 8)  | 	\
-				((v & 0x0000ff00) << 8)  | 	\
+#define zmw_cpu_to_le32(v)    (((v & 0xff000000) >> 24) |	\
+			       ((v & 0x00ff0000) >> 8)  |	\
+			       ((v & 0x0000ff00) << 8)  |	\
 				((v & 0x000000ff) << 24))

-#define zmw_le32_to_cpu(v)    (((v & 0xff000000) >> 24) | 	\
-				((v & 0x00ff0000) >> 8) | 	\
-				((v & 0x0000ff00) << 8) | 	\
+#define zmw_le32_to_cpu(v)    (((v & 0xff000000) >> 24) |	\
+			       ((v & 0x00ff0000) >> 8) |	\
+			       ((v & 0x0000ff00) << 8) |	\
 				((v & 0x000000ff) << 24))

 #define zmw_cpu_to_le16(v)    (((v & 0xff00) >> 8) | \
@@ -101,0 +101,0 @@

 #define zmw_buf_readb(dev, buf, offset) zfwBufReadByte(dev, buf, offset)
 #define zmw_buf_readh(dev, buf, offset) zfwBufReadHalfWord(dev, buf, offset)
-#define zmw_buf_writeb(dev, buf, offset, value) 			\
+#define zmw_buf_writeb(dev, buf, offset, value)				\
 			zfwBufWriteByte(dev, buf, offset, value)
 #define zmw_buf_writeh(dev, buf, offset, value)				\
 			zfwBufWriteHalfWord(dev, buf, offset, value)
@@ -118,10 +118,9 @@
 	msg, (u32_t)val);
 #define zm_debug_msg_s(msg, val) printk(KERN_DEBUG "%s:%s%s\n", __func__, \
 	msg, val);
-#define zm_debug_msg_p(msg, val1, val2) do { 			\
+#define zm_debug_msg_p(msg, val1, val2) do {			\
 			printk(KERN_DEBUG "%s:%s%01ld.%02ld\n",	\
-						__func__, 	\
+			       __func__,				\
 			msg, (val1/val2), (((val1*100)/val2)%100));
 			} while (0)
 #define zm_dbg(S) printk S
--
1.6.0.4

