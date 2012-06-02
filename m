Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965811Ab2FBUgb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 16:36:31 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:42687 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965077Ab2FBUfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 16:35:55 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Yoshinori Sato <ysato@users.sourceforge.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Tony Breeds <tony@bakeyournoodle.com>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/5] h8300/pgtable: Add missing #include <asm-generic/pgtable.h>
Date: Sat,  2 Jun 2012 22:35:35 +0200
Message-Id: <1338669339-23214-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1338669339-23214-1-git-send-email-geert@linux-m68k.org>
References: <1338669339-23214-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/sched/core.c: In function 'context_switch':
kernel/sched/core.c:2061:2: error: implicit declaration of function 'arch_start_context_switch' [-Werror=implicit-function-declaration]

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/h8300/include/asm/pgtable.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/h8300/include/asm/pgtable.h b/arch/h8300/include/asm/pgtable.h
index a09230a..62ef176 100644
--- a/arch/h8300/include/asm/pgtable.h
+++ b/arch/h8300/include/asm/pgtable.h
@@ -70,4 +70,7 @@ extern int is_in_rom(unsigned long);
 #define	VMALLOC_END	0xffffffff
 
 #define arch_enter_lazy_cpu_mode()    do {} while (0)
+
+#include <asm-generic/pgtable.h>
+
 #endif /* _H8300_PGTABLE_H */
-- 
1.7.0.4

