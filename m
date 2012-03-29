Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760198Ab2C2Wkg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 18:40:36 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759508Ab2C2Wkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 18:40:32 -0400
From: Richard Weinberger <richard@nod.at>
To: x86@kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, jeremy@goop.org,
        jbeulich@suse.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH] x86: spinlock.h: Fix comment
Date: Fri, 30 Mar 2012 00:40:21 +0200
Message-Id: <1333060821-16947-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This comment is no longer true.
We support up to 2^16 CPUs because __ticket_t is an u16 if
NR_CPUS is larger than 256.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/x86/include/asm/spinlock.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 76bfa2c..85a6b57 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -12,8 +12,7 @@
  * Simple spin lock operations.  There are two variants, one clears IRQ's
  * on the local processor, one does not.
  *
- * These are fair FIFO ticket locks, which are currently limited to 256
- * CPUs.
+ * These are fair FIFO ticket locks, which support up to 2^16 CPUs.
  *
  * (the type definitions are in asm/spinlock_types.h)
  */
-- 
1.7.7.3

