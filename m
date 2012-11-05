Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab2KEXSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:18:51 -0500
Received: from smtp.outflux.net ([198.145.64.163]:40053 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755138Ab2KEXF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:27 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Chris Mason <chris.mason@fusionio.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 092/104] fs/btrfs: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:49 -0800
Message-Id: <1352156701-4038-93-git-send-email-keescook@chromium.org>
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

Cc: Chris Mason <chris.mason@fusionio.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/btrfs/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index d33f01c..ccd25ba 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -1,6 +1,5 @@
 config BTRFS_FS
-	tristate "Btrfs filesystem (EXPERIMENTAL) Unstable disk format"
-	depends on EXPERIMENTAL
+	tristate "Btrfs filesystem Unstable disk format"
 	select LIBCRC32C
 	select ZLIB_INFLATE
 	select ZLIB_DEFLATE
-- 
1.7.9.5

