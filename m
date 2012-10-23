Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965138Ab2JWUoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:44:37 -0400
Received: from smtp.outflux.net ([198.145.64.163]:39460 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933804Ab2JWUF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:26 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Sage Weil <sage@inktank.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 161/193] net/ceph: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:54 -0700
Message-Id: <1351022666-6960-162-git-send-email-keescook@chromium.org>
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
CC: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/ceph/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ceph/Kconfig b/net/ceph/Kconfig
index cc04dd6..e50cc69 100644
--- a/net/ceph/Kconfig
+++ b/net/ceph/Kconfig
@@ -1,6 +1,6 @@
 config CEPH_LIB
-        tristate "Ceph core library (EXPERIMENTAL)"
-	depends on INET && EXPERIMENTAL
+	tristate "Ceph core library"
+	depends on INET
 	select LIBCRC32C
 	select CRYPTO_AES
 	select CRYPTO
-- 
1.7.9.5

