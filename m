Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab0KOJWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 04:22:23 -0500
Received: from mail1.elettra.trieste.it ([140.105.4.201]:56296 "EHLO
	elettra.trieste.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751786Ab0KOJWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 04:22:22 -0500
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Nov 2010 04:22:22 EST
From: Alessio Igor Bogani <abogani@texware.it>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Tim Bird <tim.bird@am.sony.com>,
        Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH] powerpc: Update a comment
Date: Mon, 15 Nov 2010 09:21:40 +0100
Message-Id: <1289809300-4038-1-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 5e3d20a remove bkl from startup code so setup_arch() it isn't called
with bkl held anymore. Update the comment on top of that function.

This work was supported by a hardware donation from the CE Linux Forum.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 arch/powerpc/kernel/setup_64.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 2a178b0..71f44e5 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -497,9 +497,8 @@ static void __init emergency_stack_init(void)
 }
 
 /*
- * Called into from start_kernel, after lock_kernel has been called.
- * Initializes bootmem, which is unsed to manage page allocation until
- * mem_init is called.
+ * Called into from start_kernel this initializes bootmem, which is unsed
+ * to manage page allocation until mem_init is called.
  */
 void __init setup_arch(char **cmdline_p)
 {
-- 
1.7.0.4

