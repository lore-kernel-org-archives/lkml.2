Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965648Ab2JWVLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:11:15 -0400
Received: from smtp.outflux.net ([198.145.64.163]:53455 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933662Ab2JWUFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:04 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Ralf Baechle <ralf@linux-mips.org>,
        Jiri Kosina <jkosina@suse.cz>, Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH 018/193] arch/mips/sgi-ip27: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:01:31 -0700
Message-Id: <1351022666-6960-19-git-send-email-keescook@chromium.org>
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

CC: Ralf Baechle <ralf@linux-mips.org>
CC: Jiri Kosina <jkosina@suse.cz>
CC: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/mips/sgi-ip27/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/mips/sgi-ip27/Kconfig b/arch/mips/sgi-ip27/Kconfig
index 4b2ea28..4d8705a 100644
--- a/arch/mips/sgi-ip27/Kconfig
+++ b/arch/mips/sgi-ip27/Kconfig
@@ -13,7 +13,6 @@ config SGI_SN_M_MODE
 
 config SGI_SN_N_MODE
 	bool "IP27 N-Mode"
-	depends on EXPERIMENTAL
 	help
 	  The nodes of Origin, Onyx, Fuel and Tezro systems can be configured
 	  in either N-Modes which allows for more nodes or M-Mode which allows
-- 
1.7.9.5

