Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab0JHAEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:04:52 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55788 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048Ab0JHACe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:02:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SsolZOvFpPcqtSKPeszbe0FA1lCEkit5aUDor0Ap8gySZVvI6KsfUW+4Rb+r7kK6zH
         wfGxnZ5REDIlimt2UhnzIqcqhc5RFL6w7Ww7S+iL8WCYozAgL6uyhbe3+9HubYLCgShx
         dgNWJWL3g5etxM73V2qBeQlL0KlrTyg5UOu0w=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 24/33] Staging: smbfs: Makefile: Makefile clean up
Date: Thu,  7 Oct 2010 20:01:44 -0400
Message-Id: <1286496113-11897-24-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
References: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.
Also Replace EXTRA_CFLAGS with ccflags-y.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/smbfs/Makefile |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/smbfs/Makefile b/drivers/staging/smbfs/Makefile
index 4faf8c4..d2a92c5 100644
--- a/drivers/staging/smbfs/Makefile
+++ b/drivers/staging/smbfs/Makefile
@@ -4,15 +4,15 @@
 
 obj-$(CONFIG_SMB_FS) += smbfs.o
 
-smbfs-objs := proc.o dir.o cache.o sock.o inode.o file.o ioctl.o getopt.o \
+smbfs-y := proc.o dir.o cache.o sock.o inode.o file.o ioctl.o getopt.o \
 		symlink.o smbiod.o request.o
 
 # If you want debugging output, you may add these flags to the EXTRA_CFLAGS
 # SMBFS_PARANOIA should normally be enabled.
 
-EXTRA_CFLAGS += -DSMBFS_PARANOIA
-#EXTRA_CFLAGS += -DSMBFS_DEBUG
-#EXTRA_CFLAGS += -DSMBFS_DEBUG_VERBOSE
-#EXTRA_CFLAGS += -DDEBUG_SMB_TIMESTAMP
-#EXTRA_CFLAGS += -Werror
+ccflags-y := -DSMBFS_PARANOIA
+#ccflags-y += -DSMBFS_DEBUG
+#ccflags-y += -DSMBFS_DEBUG_VERBOSE
+#ccflags-y += -DDEBUG_SMB_TIMESTAMP
+#ccflags-y += -Werror
 
-- 
1.7.3.1.50.g1e633

