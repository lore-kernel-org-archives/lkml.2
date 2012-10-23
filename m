Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965715Ab2JWVO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:14:58 -0400
Received: from smtp.outflux.net ([198.145.64.163]:36222 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933639Ab2JWUFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:00 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Doug Thompson <dougthompson@xmission.com>
Subject: [PATCH 042/193] drivers/edac: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:01:55 -0700
Message-Id: <1351022666-6960-43-git-send-email-keescook@chromium.org>
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

CC: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/edac/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 409b92b..2ab1b22 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -157,7 +157,7 @@ config EDAC_I3000
 
 config EDAC_I3200
 	tristate "Intel 3200"
-	depends on EDAC_MM_EDAC && PCI && X86 && EXPERIMENTAL
+	depends on EDAC_MM_EDAC && PCI && X86
 	help
 	  Support for error detection and correction on the Intel
 	  3200 and 3210 server chipsets.
@@ -223,7 +223,7 @@ config EDAC_I7300
 config EDAC_SBRIDGE
 	tristate "Intel Sandy-Bridge Integrated MC"
 	depends on EDAC_MM_EDAC && PCI && X86_64 && X86_MCE_INTEL
-	depends on PCI_MMCONFIG && EXPERIMENTAL
+	depends on PCI_MMCONFIG
 	help
 	  Support for error detection and correction the Intel
 	  Sandy Bridge Integrated Memory Controller.
-- 
1.7.9.5

