Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab2BSPM5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 10:12:57 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:41676 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199Ab2BSPME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 10:12:04 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 1/5] blackfin: s/#if CONFIG/#ifdef CONFIG/
Date: Sun, 19 Feb 2012 16:11:55 +0100
Message-Id: <1329664319-3128-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org
---
 arch/blackfin/mach-common/entry.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index e413729..48bb434 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -1244,7 +1244,7 @@ ENTRY(_software_trace_buff)
 	.endr
 #endif /* CONFIG_DEBUG_BFIN_HWTRACE_EXPAND */
 
-#if CONFIG_EARLY_PRINTK
+#ifdef CONFIG_EARLY_PRINTK
 __INIT
 ENTRY(_early_trap)
 	SAVE_ALL_SYS
-- 
1.7.0.4

