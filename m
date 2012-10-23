Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965241Ab2JWUpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:45:54 -0400
Received: from smtp.outflux.net ([198.145.64.163]:52629 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933791Ab2JWUFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:25 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Eric Van Hensbergen <ericvh@gmail.com>,
        Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>
Subject: [PATCH 136/193] fs/9p: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:29 -0700
Message-Id: <1351022666-6960-137-git-send-email-keescook@chromium.org>
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

CC: Eric Van Hensbergen <ericvh@gmail.com>
CC: Ron Minnich <rminnich@sandia.gov>
CC: Latchesar Ionkov <lucho@ionkov.net>
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

