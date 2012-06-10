Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab2FJOgv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 10:36:51 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:58001 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab2FJOgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 10:36:49 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/2] m68k: Use asm-generic version of <asm/sections.h>
Date: Sun, 10 Jun 2012 16:36:38 +0200
Message-Id: <1339338998-24629-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1339338998-24629-1-git-send-email-geert@linux-m68k.org>
References: <1339338998-24629-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/Kbuild     |    1 +
 arch/m68k/include/asm/sections.h |    6 ------
 2 files changed, 1 insertions(+), 6 deletions(-)
 delete mode 100644 arch/m68k/include/asm/sections.h

diff --git a/arch/m68k/include/asm/Kbuild b/arch/m68k/include/asm/Kbuild
index 064f867..a74e5d9 100644
--- a/arch/m68k/include/asm/Kbuild
+++ b/arch/m68k/include/asm/Kbuild
@@ -20,6 +20,7 @@ generic-y += mutex.h
 generic-y += percpu.h
 generic-y += resource.h
 generic-y += scatterlist.h
+generic-y += sections.h
 generic-y += siginfo.h
 generic-y += statfs.h
 generic-y += topology.h
diff --git a/arch/m68k/include/asm/sections.h b/arch/m68k/include/asm/sections.h
deleted file mode 100644
index d64967e..0000000
--- a/arch/m68k/include/asm/sections.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_M68K_SECTIONS_H
-#define _ASM_M68K_SECTIONS_H
-
-#include <asm-generic/sections.h>
-
-#endif /* _ASM_M68K_SECTIONS_H */
-- 
1.7.0.4

