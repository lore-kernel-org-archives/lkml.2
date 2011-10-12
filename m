Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab1JLT2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 15:28:46 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:59865 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab1JLT2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 15:28:45 -0400
Subject: [PATCH] [TRIVIAL] microblaze: add missing CONFIG_ prefixes
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
        microblaze-uclinux@itee.uq.edu.au
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 21:28:36 +0200
Message-ID: <1318447716.8345.3.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Entirely untested. Somehow, I don't feel too bad about that. Added the
maintainer and the mailinglist because this could change the behavior of
this code.

 arch/microblaze/mm/init.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/microblaze/mm/init.c b/arch/microblaze/mm/init.c
index 213f2d6..36a133e 100644
--- a/arch/microblaze/mm/init.c
+++ b/arch/microblaze/mm/init.c
@@ -304,11 +304,11 @@ asmlinkage void __init mmu_init(void)
 	/* Map in all of RAM starting at CONFIG_KERNEL_START */
 	mapin_ram();
 
-#ifdef HIGHMEM_START_BOOL
-	ioremap_base = HIGHMEM_START;
+#ifdef CONFIG_HIGHMEM_START_BOOL
+	ioremap_base = CONFIG_HIGHMEM_START;
 #else
 	ioremap_base = 0xfe000000UL;	/* for now, could be 0xfffff000 */
-#endif /* CONFIG_HIGHMEM */
+#endif /* CONFIG_HIGHMEM_START_BOOL */
 	ioremap_bot = ioremap_base;
 
 	/* Initialize the context management stuff */
-- 
1.7.4.4



