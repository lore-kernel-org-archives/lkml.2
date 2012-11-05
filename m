Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964892Ab2KEXXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:23:37 -0500
Received: from smtp.outflux.net ([198.145.64.163]:48959 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755112Ab2KEXF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:26 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 078/104] drivers/uwb: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:35 -0800
Message-Id: <1352156701-4038-79-git-send-email-keescook@chromium.org>
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

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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

