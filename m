Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933163Ab2EPHrQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 03:47:16 -0400
Received: from vostochny.stro.at ([78.47.22.85]:42568 "EHLO vostochny.stro.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759599Ab2EPHrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 03:47:14 -0400
From: maximilian attems <max@stro.at>
To: linux-ia64@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        maximilian attems <max@stro.at>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH] ia64: add cmpxchg.h to exported userspace headers
Date: Wed, 16 May 2012 09:46:30 +0200
Message-Id: <1337154390-23185-1-git-send-email-max@stro.at>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes klibc build on ia64 after 85f8f7759e418c814ee2ceacf73eddb9bed39492.

Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: maximilian attems <max@stro.at>
---
 arch/ia64/include/asm/Kbuild |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/ia64/include/asm/Kbuild b/arch/ia64/include/asm/Kbuild
index 241d1c5..d4eb938 100644
--- a/arch/ia64/include/asm/Kbuild
+++ b/arch/ia64/include/asm/Kbuild
@@ -1,6 +1,7 @@
 include include/asm-generic/Kbuild.asm
 
 header-y += break.h
+header-y += cmpxchg.h
 header-y += fpu.h
 header-y += gcc_intrin.h
 header-y += ia64regs.h
-- 
1.7.10

