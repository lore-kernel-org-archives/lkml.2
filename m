Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030347Ab2CBPlL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 10:41:11 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47835 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030331Ab2CBPlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 10:41:10 -0500
From: Richard Weinberger <richard@nod.at>
To: jonas@southpole.se
Cc: linux@openrisc.net, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/2] OpenRISC: Remove memory_start/end prototypes
Date: Fri,  2 Mar 2012 16:41:02 +0100
Message-Id: <1330702862-5688-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1330702862-5688-1-git-send-email-richard@nod.at>
References: <1330702862-5688-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OpenRISC does not have global memory_start and memory_end
symbols.
The prototypes are in vain.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/openrisc/include/asm/page.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/openrisc/include/asm/page.h b/arch/openrisc/include/asm/page.h
index c4ffaee..108906f 100644
--- a/arch/openrisc/include/asm/page.h
+++ b/arch/openrisc/include/asm/page.h
@@ -71,9 +71,6 @@ typedef struct page *pgtable_t;
 #define __pgd(x)	((pgd_t) { (x) })
 #define __pgprot(x)	((pgprot_t) { (x) })
 
-extern unsigned long memory_start;
-extern unsigned long memory_end;
-
 #endif /* !__ASSEMBLY__ */
 
 
-- 
1.7.7.3

