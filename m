Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933884Ab2JWUih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:38:37 -0400
Received: from smtp.outflux.net ([198.145.64.163]:56101 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933830Ab2JWUFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:33 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 182/193] net/sunrpc: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:04:15 -0700
Message-Id: <1351022666-6960-183-git-send-email-keescook@chromium.org>
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

CC: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: "J. Bruce Fields" <bfields@fieldses.org>
CC: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/sunrpc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/Kconfig b/net/sunrpc/Kconfig
index 03d03e3..516fe2c 100644
--- a/net/sunrpc/Kconfig
+++ b/net/sunrpc/Kconfig
@@ -10,7 +10,7 @@ config SUNRPC_BACKCHANNEL
 
 config SUNRPC_XPRT_RDMA
 	tristate
-	depends on SUNRPC && INFINIBAND && INFINIBAND_ADDR_TRANS && EXPERIMENTAL
+	depends on SUNRPC && INFINIBAND && INFINIBAND_ADDR_TRANS
 	default SUNRPC && INFINIBAND
 	help
 	  This option allows the NFS client and server to support
-- 
1.7.9.5

