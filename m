Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab1IOAnC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 20:43:02 -0400
Received: from claw.goop.org ([74.207.240.146]:38277 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592Ab1IOAm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 20:42:59 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 01/10] x86/ticketlocks: remove obsolete comment
Date: Wed, 14 Sep 2011 17:31:33 -0700
Message-Id: <d877f0625b36bdc0e31ec243fbdc1751d3fdb6a4.1315878463.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1315878463.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1315878463.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1315878463.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1315878463.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

The note about partial registers is not really relevent now that we
rely on gcc to generate all the assembler.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/spinlock.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index f5695ee..972c260 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -49,10 +49,6 @@
  * issues and should be optimal for the uncontended case. Note the tail must be
  * in the high part, because a wide xadd increment of the low part would carry
  * up and contaminate the high part.
- *
- * With fewer than 2^8 possible CPUs, we can use x86's partial registers to
- * save some instructions and make the code more elegant. There really isn't
- * much between them in performance though, especially as locks are out of line.
  */
 static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
 {
-- 
1.7.6

