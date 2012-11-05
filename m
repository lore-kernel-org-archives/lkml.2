Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab2KEXPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:15:51 -0500
Received: from smtp.outflux.net ([198.145.64.163]:50991 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676Ab2KEXFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:30 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Ralf Baechle <ralf@linux-mips.org>,
        Jiri Kosina <jkosina@suse.cz>, Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH 031/104] arch/mips/sgi-ip27: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:03:48 -0800
Message-Id: <1352156701-4038-32-git-send-email-keescook@chromium.org>
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

