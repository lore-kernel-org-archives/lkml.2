Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964816Ab2JWUcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:32:20 -0400
Received: from smtp.outflux.net ([198.145.64.163]:56323 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964796Ab2JWUFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:42 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Steve French <sfrench@samba.org>
Subject: [PATCH 144/193] fs/cifs: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:37 -0700
Message-Id: <1351022666-6960-145-git-send-email-keescook@chromium.org>
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

CC: Steve French <sfrench@samba.org>
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

