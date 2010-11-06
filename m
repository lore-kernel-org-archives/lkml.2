Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab0KFS63 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 14:58:29 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41682 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab0KFS62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 14:58:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=C8UYstWZNdneX5Y06ySv8SgA8GRbXcoTc2YYKQaar3AEXYI38yoM7FRv1MQqrqtEFG
         OCdWb2556HtMT92hkRn0mrXS6ReXsYigb31Z1MbTQli80IEJnaRIuypcvKTdt2CEtxDj
         UzlwBA7QHH12h82JC0+KLkRRNgHUrawAc6xP4=
From: Tracey Dent <tdent48227@gmail.com>
To: ecashin@coraid.com, sage@newdream.net
Cc: yehuda@hq.newdream.net, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [Resend][PATCH 1/2] Drivers: block: Makefile: replace the use of <module>-objs with <module>-y
Date: Sat,  6 Nov 2010 14:58:37 -0400
Message-Id: <1289069918-2085-1-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/block/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index d7f463d..40528ba 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -39,4 +39,4 @@ obj-$(CONFIG_XEN_BLKDEV_FRONTEND)	+= xen-blkfront.o
 obj-$(CONFIG_BLK_DEV_DRBD)     += drbd/
 obj-$(CONFIG_BLK_DEV_RBD)     += rbd.o
 
-swim_mod-objs	:= swim.o swim_asm.o
+swim_mod-y	:= swim.o swim_asm.o
-- 
1.7.3.2.146.gca209

