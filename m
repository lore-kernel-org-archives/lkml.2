Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab2KEXQu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:16:50 -0500
Received: from smtp.outflux.net ([198.145.64.163]:46194 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933040Ab2KEXF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:29 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 099/104] fs/nfsd: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:56 -0800
Message-Id: <1352156701-4038-100-git-send-email-keescook@chromium.org>
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

CC: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/nfsd/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/Kconfig b/fs/nfsd/Kconfig
index 8df1ea4..430b687 100644
--- a/fs/nfsd/Kconfig
+++ b/fs/nfsd/Kconfig
@@ -65,8 +65,8 @@ config NFSD_V3_ACL
 	  If unsure, say N.
 
 config NFSD_V4
-	bool "NFS server support for NFS version 4 (EXPERIMENTAL)"
-	depends on NFSD && PROC_FS && EXPERIMENTAL
+	bool "NFS server support for NFS version 4"
+	depends on NFSD && PROC_FS
 	select NFSD_V3
 	select FS_POSIX_ACL
 	select SUNRPC_GSS
-- 
1.7.9.5

