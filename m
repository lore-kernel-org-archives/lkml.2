Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001Ab2KEXV4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:21:56 -0500
Received: from smtp.outflux.net ([198.145.64.163]:48628 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754326Ab2KEXF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:26 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 088/104] fs/affs: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:45 -0800
Message-Id: <1352156701-4038-89-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352156701-4038-1-git-send-email-keescook@chromium.org>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/affs/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/affs/Kconfig b/fs/affs/Kconfig
index cfad9af..a04d9e8 100644
--- a/fs/affs/Kconfig
+++ b/fs/affs/Kconfig
@@ -1,6 +1,6 @@
 config AFFS_FS
-	tristate "Amiga FFS file system support (EXPERIMENTAL)"
-	depends on BLOCK && EXPERIMENTAL
+	tristate "Amiga FFS file system support"
+	depends on BLOCK
 	help
 	  The Fast File System (FFS) is the common file system used on hard
 	  disks by Amiga(tm) systems since AmigaOS Version 1.3 (34.20).  Say Y
-- 
1.7.9.5

