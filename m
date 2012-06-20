Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353Ab2FTQ6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 12:58:16 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:39304 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757068Ab2FTQ6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 12:58:13 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/2] sparc32: Remove superfluous extern declarations for prom_*() functions
Date: Wed, 20 Jun 2012 18:58:07 +0200
Message-Id: <1340211487-24534-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1340211487-24534-1-git-send-email-geert@linux-m68k.org>
References: <1340211487-24534-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

prom_meminit() and prom_ranges_init() are declared in <asm/oplib_32.h>.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
--
Not even compile-tested

 arch/sparc/prom/init_32.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/sparc/prom/init_32.c b/arch/sparc/prom/init_32.c
index a8d9342..9ac30c2 100644
--- a/arch/sparc/prom/init_32.c
+++ b/arch/sparc/prom/init_32.c
@@ -31,9 +31,6 @@ struct linux_nodeops *prom_nodeops;
  * It gets passed the pointer to the PROM vector.
  */
 
-extern void prom_meminit(void);
-extern void prom_ranges_init(void);
-
 void __init prom_init(struct linux_romvec *rp)
 {
 	romvec = rp;
-- 
1.7.0.4

