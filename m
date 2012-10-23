Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964789Ab2JWUFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:05:39 -0400
Received: from smtp.outflux.net ([198.145.64.163]:43284 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757450Ab2JWUF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:26 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        "J. Bruce Fields" <bfields@fieldses.org>
Subject: [PATCH 151/193] fs/nfsd: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:44 -0700
Message-Id: <1351022666-6960-152-git-send-email-keescook@chromium.org>
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

CC: "J. Bruce Fields" <bfields@fieldses.org>
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

