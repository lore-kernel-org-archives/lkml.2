Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965197Ab2JWUz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:55:29 -0400
Received: from smtp.outflux.net ([198.145.64.163]:40449 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933746Ab2JWUFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:19 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>
Subject: [PATCH 126/193] drivers/uwb: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:19 -0700
Message-Id: <1351022666-6960-127-git-send-email-keescook@chromium.org>
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
 drivers/uwb/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/uwb/Kconfig b/drivers/uwb/Kconfig
index d100f54..2431eed 100644
--- a/drivers/uwb/Kconfig
+++ b/drivers/uwb/Kconfig
@@ -3,8 +3,7 @@
 #
 
 menuconfig UWB
-	tristate "Ultra Wideband devices (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "Ultra Wideband devices"
 	depends on PCI
 	default n
 	help
-- 
1.7.9.5

