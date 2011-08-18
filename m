Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab1HRTNf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:13:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48446 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab1HRTNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:13:30 -0400
Date: Thu, 18 Aug 2011 20:13:30 +0100
To: richard@nod.at
Subject: Subject: [PATCH 87/91] um: asm/pda.h is not needed anymore
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu81y-00088a-2D@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/include/asm/pda.h |   21 ---------------------
 1 files changed, 0 insertions(+), 21 deletions(-)
 delete mode 100644 arch/um/include/asm/pda.h

diff --git a/arch/um/include/asm/pda.h b/arch/um/include/asm/pda.h
deleted file mode 100644
index ddcd774..0000000
--- a/arch/um/include/asm/pda.h
+++ /dev/null
@@ -1,21 +0,0 @@
-/*
- * Copyright 2003 PathScale, Inc.
- *
- * Licensed under the GPL
- */
-
-#ifndef __UM_PDA_X86_64_H
-#define __UM_PDA_X86_64_H
-
-/* XXX */
-struct foo {
-	unsigned int __softirq_pending;
-	unsigned int __nmi_count;
-};
-
-extern struct foo me;
-
-#define read_pda(me) (&me)
-
-#endif
-
-- 
1.7.2.5


