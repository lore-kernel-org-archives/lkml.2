Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750885Ab0JPEJu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 00:09:50 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36296 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab0JPEJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 00:09:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=UbLBiJa5KWKjxlSA+6snua4OdSugn51kfuaxWSWsdTb79MHuVW6kyT7P0UWX9UZOhe
         OvxTz+DAvF0mQXsvlQeUA1j+2RDWiS4zs4fswWQMaz1shwsEsX+t17CieMJgAOnTPOS+
         WiIA9S8Nv/uGbFHBoogcIbeUqm0NseB+1WjC0=
From: Tracey Dent <tdent48227@gmail.com>
To: sage@newdream.net
Cc: ecashin@coraid.com, yehuda@hq.newdream.net, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 1/2] Drivers: block: Makefile: replace the use of <module>-objs with <module>-y
Date: Sat, 16 Oct 2010 00:09:40 -0400
Message-Id: <1287202181-2196-1-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.104.gc752e
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
1.7.3.1.104.gc752e

