Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab2LANYR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 08:24:17 -0500
Received: from smtp-out-239.synserver.de ([212.40.185.239]:1065 "EHLO
	smtp-out-239.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab2LANYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 08:24:13 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 11086
From: Lars-Peter Clausen <lars@metafoo.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Salter <msalter@redhat.com>, Aurelien Jacquiot <a-jacquiot@ti.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        linux-c6x-dev@linux-c6x.org, linux-kernel@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, linux-arch@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH resend 1/5] asm-generic/mmu.h: Remove unused vmlist field from mm_context_t
Date: Sat,  1 Dec 2012 14:24:40 +0100
Message-Id: <1354368284-11625-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing is using the vmlist field in mm_context_t anymore. It has been removed
from the non-generic versions over 3 years ago 8feae1311 ("NOMMU: Make VMAs per
MM as for MMU-mode linux").

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 include/asm-generic/mmu.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/mmu.h b/include/asm-generic/mmu.h
index 4f4aa56..a67ae0a9 100644
--- a/include/asm-generic/mmu.h
+++ b/include/asm-generic/mmu.h
@@ -7,7 +7,6 @@
  */
 #ifndef __ASSEMBLY__
 typedef struct {
-	struct vm_list_struct	*vmlist;
 	unsigned long		end_brk;
 } mm_context_t;
 #endif
-- 
1.7.2.5

