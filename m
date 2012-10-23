Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965373Ab2JWUyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:54:23 -0400
Received: from smtp.outflux.net ([198.145.64.163]:42338 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933751Ab2JWUFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:20 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Adam Belay <abelay@mit.edu>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 114/193] drivers/pnp/pnpbios: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:07 -0700
Message-Id: <1351022666-6960-115-git-send-email-keescook@chromium.org>
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

