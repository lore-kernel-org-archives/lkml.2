Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516Ab0HJMA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 08:00:59 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:63763 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752252Ab0HJMAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 08:00:55 -0400
Date: Tue, 10 Aug 2010 14:00:52 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Michal Simek <monstr@monstr.eu>,
        "Steven J. Magnani" <steve@digidescorp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        John Williams <john.williams@petalogix.com>,
        microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH] arch/microblaze: Removing dead CONTIGUOUS_PAGE_ALLOC
 config option
Message-ID: <20100810120052.GA26802@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_CONTIGUOUS_PAGE_ALLOC doesn't exist in Kconfig, therefore removing
all references to it from the source.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 arch/microblaze/include/asm/page.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/microblaze/include/asm/page.h b/arch/microblaze/include/asm/page.h
index 4f268fa..1f033c6 100644
--- a/arch/microblaze/include/asm/page.h
+++ b/arch/microblaze/include/asm/page.h
@@ -205,9 +205,6 @@ extern int page_is_ram(unsigned long pfn);
 #define TOPHYS(addr)  __virt_to_phys(addr)
 
 #ifdef CONFIG_MMU
-#ifdef CONFIG_CONTIGUOUS_PAGE_ALLOC
-#define WANT_PAGE_VIRTUAL 1 /* page alloc 2 relies on this */
-#endif
 
 #define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | VM_EXEC | \
 				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
-- 
1.7.0.4

