Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964915Ab2JWUug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:50:36 -0400
Received: from smtp.outflux.net ([198.145.64.163]:35811 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933768Ab2JWUFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:22 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 032/193] arch/x86/um: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:01:45 -0700
Message-Id: <1351022666-6960-33-git-send-email-keescook@chromium.org>
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

CC: Jeff Dike <jdike@addtoit.com>
CC: Richard Weinberger <richard@nod.at>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/um/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/um/Kconfig b/arch/x86/um/Kconfig
index 0761175..3a43b7a 100644
--- a/arch/x86/um/Kconfig
+++ b/arch/x86/um/Kconfig
@@ -37,9 +37,8 @@ config RWSEM_GENERIC_SPINLOCK
 	def_bool !RWSEM_XCHGADD_ALGORITHM
 
 config 3_LEVEL_PGTABLES
-	bool "Three-level pagetables (EXPERIMENTAL)" if !64BIT
+	bool "Three-level pagetables" if !64BIT
 	default 64BIT
-	depends on EXPERIMENTAL
 	help
 	Three-level pagetables will let UML have more than 4G of physical
 	memory.  All the memory that can't be mapped directly will be treated
-- 
1.7.9.5

