Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab2KEXPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:15:48 -0500
Received: from smtp.outflux.net ([198.145.64.163]:42329 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754706Ab2KEXFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:30 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Eric Van Hensbergen <ericvh@gmail.com>,
        Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 086/104] fs/9p: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:43 -0800
Message-Id: <1352156701-4038-87-git-send-email-keescook@chromium.org>
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

CC: Eric Van Hensbergen <ericvh@gmail.com>
CC: Ron Minnich <rminnich@sandia.gov>
CC: Latchesar Ionkov <lucho@ionkov.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/9p/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/9p/Kconfig b/fs/9p/Kconfig
index 0a93dc1..55abfd6 100644
--- a/fs/9p/Kconfig
+++ b/fs/9p/Kconfig
@@ -11,8 +11,7 @@ config 9P_FS
 
 if 9P_FS
 config 9P_FSCACHE
-	bool "Enable 9P client caching support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "Enable 9P client caching support"
 	depends on 9P_FS=m && FSCACHE || 9P_FS=y && FSCACHE=y
 	help
 	  Choose Y here to enable persistent, read-only local
-- 
1.7.9.5

