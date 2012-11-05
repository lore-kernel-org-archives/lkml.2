Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546Ab2KEXOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:14:47 -0500
Received: from smtp.outflux.net ([198.145.64.163]:50737 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755151Ab2KEXFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:31 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Neil Brown <neilb@suse.de>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 095/104] fs/efs: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:52 -0800
Message-Id: <1352156701-4038-96-git-send-email-keescook@chromium.org>
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

Cc: Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/efs/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/efs/Kconfig b/fs/efs/Kconfig
index 6ebfc1c..d020e3c 100644
--- a/fs/efs/Kconfig
+++ b/fs/efs/Kconfig
@@ -1,6 +1,6 @@
 config EFS_FS
-	tristate "EFS file system support (read only) (EXPERIMENTAL)"
-	depends on BLOCK && EXPERIMENTAL
+	tristate "EFS file system support (read only)"
+	depends on BLOCK
 	help
 	  EFS is an older file system used for non-ISO9660 CD-ROMs and hard
 	  disk partitions by SGI's IRIX operating system (IRIX 6.0 and newer
-- 
1.7.9.5

