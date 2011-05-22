Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab1EVOvW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 10:51:22 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:43792 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754297Ab1EVOu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 10:50:57 -0400
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 6/7] um: include linux/prefetch.h
Date: Sun, 22 May 2011 16:48:35 +0200
Message-Id: <1306075716-20042-6-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1306075716-20042-1-git-send-email-richard@nod.at>
References: <1306075716-20042-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build failures on UML.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/include/asm/processor-generic.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/um/include/asm/processor-generic.h b/arch/um/include/asm/processor-generic.h
index d1d1b0d..98d01bc 100644
--- a/arch/um/include/asm/processor-generic.h
+++ b/arch/um/include/asm/processor-generic.h
@@ -14,6 +14,8 @@ struct task_struct;
 #include "registers.h"
 #include "sysdep/archsetjmp.h"
 
+#include <linux/prefetch.h>
+
 struct mm_struct;
 
 struct thread_struct {
-- 
1.7.4.2

