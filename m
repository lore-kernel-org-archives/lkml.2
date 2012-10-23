Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965306Ab2JWUuc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:50:32 -0400
Received: from smtp.outflux.net ([198.145.64.163]:35991 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933770Ab2JWUFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:22 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, David Howells <dhowells@redhat.com>
Subject: [PATCH 139/193] fs/afs: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:32 -0700
Message-Id: <1351022666-6960-140-git-send-email-keescook@chromium.org>
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

CC: David Howells <dhowells@redhat.com>
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

