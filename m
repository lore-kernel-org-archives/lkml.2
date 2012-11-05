Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964793Ab2KEXFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:05:40 -0500
Received: from smtp.outflux.net ([198.145.64.163]:35809 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932376Ab2KEXFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:19 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 008/104] drivers/net/ethernet/sun: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:03:25 -0800
Message-Id: <1352156701-4038-9-git-send-email-keescook@chromium.org>
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
 drivers/net/ethernet/sun/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sun/Kconfig b/drivers/net/ethernet/sun/Kconfig
index 57bfd85..ae3a355 100644
--- a/drivers/net/ethernet/sun/Kconfig
+++ b/drivers/net/ethernet/sun/Kconfig
@@ -32,8 +32,8 @@ config HAPPYMEAL
 	  will be called sunhme.
 
 config SUNBMAC
-	tristate "Sun BigMAC 10/100baseT support (EXPERIMENTAL)"
-	depends on SBUS && EXPERIMENTAL
+	tristate "Sun BigMAC 10/100baseT support"
+	depends on SBUS
 	select CRC32
 	---help---
 	  This driver supports the "be" interface available as an Sbus option.
-- 
1.7.9.5

