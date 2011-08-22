Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab1HVXPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 19:15:43 -0400
Received: from claw.goop.org ([74.207.240.146]:48626 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754202Ab1HVXP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 19:15:26 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 09/15] x86/cmpxchg: linux/alternative.h has LOCK_PREFIX
Date: Mon, 22 Aug 2011 16:15:05 -0700
Message-Id: <42b443a0f873c24fa6444f25ed7fa69dca5c45bb.1314054734.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1314045780.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314045780.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1314054734.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314054734.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Not linux/bitops.h.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/cmpxchg_32.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxchg_32.h
index 284a6e8..8d53b16 100644
--- a/arch/x86/include/asm/cmpxchg_32.h
+++ b/arch/x86/include/asm/cmpxchg_32.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_X86_CMPXCHG_32_H
 #define _ASM_X86_CMPXCHG_32_H
 
-#include <linux/bitops.h> /* for LOCK_PREFIX */
+#include <asm/alternative.h> /* Provides LOCK_PREFIX */
 
 /*
  * Note: if you use set64_bit(), __cmpxchg64(), or their variants, you
-- 
1.7.6

