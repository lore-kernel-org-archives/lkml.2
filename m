Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965517Ab2JWVDH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:03:07 -0400
Received: from smtp.outflux.net ([198.145.64.163]:54064 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933700Ab2JWUFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:13 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>
Subject: [PATCH 092/193] drivers/net/ethernet/sun: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:45 -0700
Message-Id: <1351022666-6960-93-git-send-email-keescook@chromium.org>
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

