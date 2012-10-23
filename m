Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965290Ab2JWUrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:47:42 -0400
Received: from smtp.outflux.net ([198.145.64.163]:55286 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933783Ab2JWUFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:23 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Sage Weil <sage@inktank.com>
Subject: [PATCH 143/193] fs/ceph: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:36 -0700
Message-Id: <1351022666-6960-144-git-send-email-keescook@chromium.org>
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

CC: Sage Weil <sage@inktank.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/ceph/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/Kconfig b/fs/ceph/Kconfig
index 9eb134e..49bc782 100644
--- a/fs/ceph/Kconfig
+++ b/fs/ceph/Kconfig
@@ -1,6 +1,6 @@
 config CEPH_FS
-        tristate "Ceph distributed file system (EXPERIMENTAL)"
-	depends on INET && EXPERIMENTAL
+	tristate "Ceph distributed file system"
+	depends on INET
 	select CEPH_LIB
 	select LIBCRC32C
 	select CRYPTO_AES
-- 
1.7.9.5

