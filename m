Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157Ab2GMVUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 17:20:39 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:40954 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab2GMVUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 17:20:37 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Hirokazu Takata <takata@linux-m32r.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m32r@ml.linux-m32r.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/6] m32r: Remove duplicate definition of PTRACE_O_TRACESYSGOOD
Date: Fri, 13 Jul 2012 23:20:22 +0200
Message-Id: <1342214427-17607-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/linux/ptrace.h:66:0: warning: "PTRACE_O_TRACESYSGOOD" redefined [enabled by default]
arch/m32r/include/asm/ptrace.h:117:0: note: this is the location of the previous definition

We already have it in <linux/ptrace.h>, so remove it from <asm/ptrace.h>

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m32r/include/asm/ptrace.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/m32r/include/asm/ptrace.h b/arch/m32r/include/asm/ptrace.h
index 5275275..4313aa6 100644
--- a/arch/m32r/include/asm/ptrace.h
+++ b/arch/m32r/include/asm/ptrace.h
@@ -113,9 +113,6 @@ struct pt_regs {
 
 #define PTRACE_OLDSETOPTIONS	21
 
-/* options set using PTRACE_SETOPTIONS */
-#define PTRACE_O_TRACESYSGOOD	0x00000001
-
 #ifdef __KERNEL__
 
 #include <asm/m32r.h>		/* M32R_PSW_BSM, M32R_PSW_BPM */
-- 
1.7.0.4

