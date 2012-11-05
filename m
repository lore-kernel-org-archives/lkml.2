Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab2KEXTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:19:52 -0500
Received: from smtp.outflux.net ([198.145.64.163]:34599 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755125Ab2KEXF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:27 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Adam Belay <abelay@mit.edu>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 070/104] drivers/pnp/pnpbios: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:27 -0800
Message-Id: <1352156701-4038-71-git-send-email-keescook@chromium.org>
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

CC: Adam Belay <abelay@mit.edu>
CC: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/pnp/pnpbios/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pnp/pnpbios/Kconfig b/drivers/pnp/pnpbios/Kconfig
index b986d9f..50c3dd0 100644
--- a/drivers/pnp/pnpbios/Kconfig
+++ b/drivers/pnp/pnpbios/Kconfig
@@ -2,8 +2,8 @@
 # Plug and Play BIOS configuration
 #
 config PNPBIOS
-	bool "Plug and Play BIOS support (EXPERIMENTAL)"
-	depends on ISA && X86 && EXPERIMENTAL
+	bool "Plug and Play BIOS support"
+	depends on ISA && X86
 	default n
 	---help---
 	  Linux uses the PNPBIOS as defined in "Plug and Play BIOS
-- 
1.7.9.5

