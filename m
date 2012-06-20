Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333Ab2FTQ6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 12:58:15 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:34530 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757042Ab2FTQ6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 12:58:13 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/2] sparc: Correct comments about prom_init() return values
Date: Wed, 20 Jun 2012 18:58:06 +0200
Message-Id: <1340211487-24534-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

prom_init() returns void.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/sparc/prom/init_32.c |    4 ++--
 arch/sparc/prom/init_64.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/sparc/prom/init_32.c b/arch/sparc/prom/init_32.c
index 26c64ce..a8d9342 100644
--- a/arch/sparc/prom/init_32.c
+++ b/arch/sparc/prom/init_32.c
@@ -27,8 +27,8 @@ EXPORT_SYMBOL(prom_root_node);
 struct linux_nodeops *prom_nodeops;
 
 /* You must call prom_init() before you attempt to use any of the
- * routines in the prom library.  It returns 0 on success, 1 on
- * failure.  It gets passed the pointer to the PROM vector.
+ * routines in the prom library.
+ * It gets passed the pointer to the PROM vector.
  */
 
 extern void prom_meminit(void);
diff --git a/arch/sparc/prom/init_64.c b/arch/sparc/prom/init_64.c
index 5016c5e..d95db75 100644
--- a/arch/sparc/prom/init_64.c
+++ b/arch/sparc/prom/init_64.c
@@ -22,8 +22,8 @@ int prom_stdout;
 phandle prom_chosen_node;
 
 /* You must call prom_init() before you attempt to use any of the
- * routines in the prom library.  It returns 0 on success, 1 on
- * failure.  It gets passed the pointer to the PROM vector.
+ * routines in the prom library.
+ * It gets passed the pointer to the PROM vector.
  */
 
 extern void prom_cif_init(void *, void *);
-- 
1.7.0.4

