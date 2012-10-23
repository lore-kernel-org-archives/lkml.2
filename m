Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965180Ab2JWUpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:45:50 -0400
Received: from smtp.outflux.net ([198.145.64.163]:44566 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933797Ab2JWUFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:25 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 159/193] net/9p: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:52 -0700
Message-Id: <1351022666-6960-160-git-send-email-keescook@chromium.org>
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

CC: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/9p/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/9p/Kconfig b/net/9p/Kconfig
index d9ea09b..a75174a 100644
--- a/net/9p/Kconfig
+++ b/net/9p/Kconfig
@@ -23,7 +23,7 @@ config NET_9P_VIRTIO
 	  guest partitions and a host partition.
 
 config NET_9P_RDMA
-	depends on INET && INFINIBAND && INFINIBAND_ADDR_TRANS && EXPERIMENTAL
+	depends on INET && INFINIBAND && INFINIBAND_ADDR_TRANS
 	tristate "9P RDMA Transport (Experimental)"
 	help
 	  This builds support for an RDMA transport.
-- 
1.7.9.5

