Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab2KEXIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:08:22 -0500
Received: from smtp.outflux.net ([198.145.64.163]:38039 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932376Ab2KEXFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:54 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 091/104] fs/bfs: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:48 -0800
Message-Id: <1352156701-4038-92-git-send-email-keescook@chromium.org>
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

Cc: "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/bfs/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bfs/Kconfig b/fs/bfs/Kconfig
index c2336c6..3728a64 100644
--- a/fs/bfs/Kconfig
+++ b/fs/bfs/Kconfig
@@ -1,6 +1,6 @@
 config BFS_FS
-	tristate "BFS file system support (EXPERIMENTAL)"
-	depends on BLOCK && EXPERIMENTAL
+	tristate "BFS file system support"
+	depends on BLOCK
 	help
 	  Boot File System (BFS) is a file system used under SCO UnixWare to
 	  allow the bootloader access to the kernel image and other important
-- 
1.7.9.5

