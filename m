Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097Ab2HQOjF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:39:05 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35832 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758088Ab2HQOiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:38:20 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 4/4] s390: Remove leftover account_tick_vtime() header
Date: Fri, 17 Aug 2012 16:37:58 +0200
Message-Id: <1345214278-6245-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1345214278-6245-1-git-send-email-fweisbec@gmail.com>
References: <1345214278-6245-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function doesn't seem to exist anymore.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 arch/s390/include/asm/switch_to.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/switch_to.h b/arch/s390/include/asm/switch_to.h
index e7f9b3d..314cc94 100644
--- a/arch/s390/include/asm/switch_to.h
+++ b/arch/s390/include/asm/switch_to.h
@@ -89,8 +89,6 @@ static inline void restore_access_regs(unsigned int *acrs)
 	prev = __switch_to(prev,next);					\
 } while (0)
 
-extern void account_tick_vtime(struct task_struct *);
-
 #define finish_arch_switch(prev) do {					     \
 	set_fs(current->thread.mm_segment);				     \
 } while (0)
-- 
1.7.5.4

