Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933371Ab2C2Xej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 19:34:39 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933072Ab2C2Xeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 19:34:31 -0400
From: Richard Weinberger <richard@nod.at>
To: x86@kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, jeremy@goop.org,
        jbeulich@suse.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH] x86: spinlock.h: Remove REG_PTR_MODE
Date: Fri, 30 Mar 2012 01:38:03 +0200
Message-Id: <1333064283-3109-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

REG_PTR_MODE has no users at all.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/x86/include/asm/spinlock.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 76bfa2c..b315a33 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -20,10 +20,8 @@
 
 #ifdef CONFIG_X86_32
 # define LOCK_PTR_REG "a"
-# define REG_PTR_MODE "k"
 #else
 # define LOCK_PTR_REG "D"
-# define REG_PTR_MODE "q"
 #endif
 
 #if defined(CONFIG_X86_32) && \
-- 
1.7.7

