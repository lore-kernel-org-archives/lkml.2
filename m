Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab1HMA1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 20:27:40 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:61717 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab1HMA1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 20:27:39 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 01/10]arch:mips:sibyte:sb1250:setup.c Remove pointless "@" from various parts of the kernel 
Date: Fri, 12 Aug 2011 17:27:06 -0700
Message-Id: <1313195235-4522-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The patch series below removes some pointless "@"'s in various parts of the kernel.
Note: some might be useful, but then again, some just seemed a waste of space.
(and since the kernel is becomeing bloated, might as well diet! even if its a few bits)

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/mips/sibyte/sb1250/setup.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/mips/sibyte/sb1250/setup.c b/arch/mips/sibyte/sb1250/setup.c
index 92da315..81f9b74 100644
--- a/arch/mips/sibyte/sb1250/setup.c
+++ b/arch/mips/sibyte/sb1250/setup.c
@@ -202,9 +202,9 @@ void __init sb1250_setup(void)
 	switch (war_pass) {
 	case K_SYS_REVISION_BCM1250_PASS1:
 #ifndef CONFIG_SB1_PASS_1_WORKAROUNDS
-		printk("@@@@ This is a BCM1250 A0-A2 (Pass 1) board, "
+		printk("This is a BCM1250 A0-A2 (Pass 1) board, "
 		            "and the kernel doesn't have the proper "
-		            "workarounds compiled in. @@@@\n");
+		            "workarounds compiled in.\n");
 		bad_config = 1;
 #endif
 		break;
@@ -212,29 +212,28 @@ void __init sb1250_setup(void)
 		/* Pass 2 - easiest as default for now - so many numbers */
 #if !defined(CONFIG_SB1_PASS_2_WORKAROUNDS) || \
     !defined(CONFIG_SB1_PASS_2_1_WORKAROUNDS)
-		printk("@@@@ This is a BCM1250 A3-A10 board, and the "
+		printk("This is a BCM1250 A3-A10 board, and the "
 		            "kernel doesn't have the proper workarounds "
-		            "compiled in. @@@@\n");
+		            "compiled in.\n");
 		bad_config = 1;
 #endif
 #ifdef CONFIG_CPU_HAS_PREFETCH
-		printk("@@@@ Prefetches may be enabled in this kernel, "
-		            "but are buggy on this board.  @@@@\n");
+		printk("Prefetches may be enabled in this kernel, "
+		            "but are buggy on this board.\n");
 		bad_config = 1;
 #endif
 		break;
 	case K_SYS_REVISION_BCM1250_PASS2_2:
 #ifndef CONFIG_SB1_PASS_2_WORKAROUNDS
-		printk("@@@@ This is a BCM1250 B1/B2. board, and the "
+		printk("This is a BCM1250 B1/B2. board, and the "
 		            "kernel doesn't have the proper workarounds "
-		            "compiled in. @@@@\n");
+		            "compiled in.\n");
 		bad_config = 1;
 #endif
 #if defined(CONFIG_SB1_PASS_2_1_WORKAROUNDS) || \
     !defined(CONFIG_CPU_HAS_PREFETCH)
-		printk("@@@@ This is a BCM1250 B1/B2, but the kernel is "
-		            "conservatively configured for an 'A' stepping. "
-		            "@@@@\n");
+		printk("This is a BCM1250 B1/B2, but the kernel is "
+		            "conservatively configured for an 'A' stepping.\n");
 #endif
 		break;
 	default:
-- 
1.7.6

