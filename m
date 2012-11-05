Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063Ab2KEXVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:21:14 -0500
Received: from smtp.outflux.net ([198.145.64.163]:39477 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755048Ab2KEXF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:27 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 089/104] fs/afs: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:46 -0800
Message-Id: <1352156701-4038-90-git-send-email-keescook@chromium.org>
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

CC: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/afs/Kconfig |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/afs/Kconfig b/fs/afs/Kconfig
index 8f975f2..ebba3b1 100644
--- a/fs/afs/Kconfig
+++ b/fs/afs/Kconfig
@@ -1,6 +1,6 @@
 config AFS_FS
-	tristate "Andrew File System support (AFS) (EXPERIMENTAL)"
-	depends on INET && EXPERIMENTAL
+	tristate "Andrew File System support (AFS)"
+	depends on INET
 	select AF_RXRPC
 	select DNS_RESOLVER
 	help
@@ -22,8 +22,7 @@ config AFS_DEBUG
 	  If unsure, say N.
 
 config AFS_FSCACHE
-	bool "Provide AFS client caching support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "Provide AFS client caching support"
 	depends on AFS_FS=m && FSCACHE || AFS_FS=y && FSCACHE=y
 	help
 	  Say Y here if you want AFS data to be cached locally on disk through
-- 
1.7.9.5

