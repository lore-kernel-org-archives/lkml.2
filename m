Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168Ab2KEXTt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:19:49 -0500
Received: from smtp.outflux.net ([198.145.64.163]:39976 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755128Ab2KEXF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:27 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 096/104] fs/hfs: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:53 -0800
Message-Id: <1352156701-4038-97-git-send-email-keescook@chromium.org>
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
 fs/hfs/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/hfs/Kconfig b/fs/hfs/Kconfig
index b77c5bc..998e3a6 100644
--- a/fs/hfs/Kconfig
+++ b/fs/hfs/Kconfig
@@ -1,6 +1,6 @@
 config HFS_FS
-	tristate "Apple Macintosh file system support (EXPERIMENTAL)"
-	depends on BLOCK && EXPERIMENTAL
+	tristate "Apple Macintosh file system support"
+	depends on BLOCK
 	select NLS
 	help
 	  If you say Y here, you will be able to mount Macintosh-formatted
-- 
1.7.9.5

