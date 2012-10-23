Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965103Ab2JWUre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:47:34 -0400
Received: from smtp.outflux.net ([198.145.64.163]:45550 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933790Ab2JWUFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:24 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>
Subject: [PATCH 141/193] fs/bfs: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:34 -0700
Message-Id: <1351022666-6960-142-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351022666-6960-1-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config item has not carried much meaning for a while now and is
almost always enabled by default. As agreed during the Linux kernel
summit, remove it.

CC: "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>
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

