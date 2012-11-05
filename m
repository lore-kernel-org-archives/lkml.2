Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933627Ab2KEXc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:32:26 -0500
Received: from smtp.outflux.net ([198.145.64.163]:51714 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755005Ab2KEXFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:15 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 005/104] drivers/net/ethernet/racal: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:03:22 -0800
Message-Id: <1352156701-4038-6-git-send-email-keescook@chromium.org>
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

Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/racal/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/racal/Kconfig b/drivers/net/ethernet/racal/Kconfig
index 01969e0..53c6af1 100644
--- a/drivers/net/ethernet/racal/Kconfig
+++ b/drivers/net/ethernet/racal/Kconfig
@@ -19,8 +19,8 @@ config NET_VENDOR_RACAL
 if NET_VENDOR_RACAL
 
 config NI5010
-	tristate "NI5010 support (EXPERIMENTAL)"
-	depends on ISA && EXPERIMENTAL && BROKEN_ON_SMP
+	tristate "NI5010 support"
+	depends on ISA && BROKEN_ON_SMP
 	---help---
 	  If you have a network (Ethernet) card of this type, say Y and read
 	  the Ethernet-HOWTO, available from
-- 
1.7.9.5

