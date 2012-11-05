Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932956Ab2KEXSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:18:54 -0500
Received: from smtp.outflux.net ([198.145.64.163]:50641 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133Ab2KEXF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:27 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Steve French <sfrench@samba.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 093/104] fs/cifs: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:50 -0800
Message-Id: <1352156701-4038-94-git-send-email-keescook@chromium.org>
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

CC: Steve French <sfrench@samba.org>
CC: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/cifs/Kconfig |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index 2075ddf..8a354d1 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -147,14 +147,14 @@ config CIFS_DFS_UPCALL
 	    points. If unsure, say N.
 
 config CIFS_NFSD_EXPORT
-	  bool "Allow nfsd to export CIFS file system (EXPERIMENTAL)"
-	  depends on CIFS && EXPERIMENTAL && BROKEN
+	  bool "Allow nfsd to export CIFS file system"
+	  depends on CIFS && BROKEN
 	  help
 	   Allows NFS server to export a CIFS mounted share (nfsd over cifs)
 
 config CIFS_SMB2
-	bool "SMB2 network file system support (EXPERIMENTAL)"
-	depends on CIFS && EXPERIMENTAL && INET
+	bool "SMB2 network file system support"
+	depends on CIFS && INET
 	select NLS
 	select KEYS
 	select FSCACHE
-- 
1.7.9.5

