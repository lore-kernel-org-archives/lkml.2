Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab1C2QhG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 12:37:06 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:56791 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab1C2QhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 12:37:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=qI6xEgjwRNryznFG33LAIJ3C874C9LKV2i/HklP9oDaw+85c5RM72wFrRZxT6fAIbp
         C1s2UDLLNGANfhXB+/pfCmOElwcKVOdSqxwlrk/mXSDN2ndvYRfJfidpgsqrtvqieypl
         aATKJ9FIFtbpVXnGgGofZ7311IcJgK5Um05DY=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: fweisbec@gmail.com, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]arch:Kconfig.locks Remove unused config option.
Date: Tue, 29 Mar 2011 09:36:51 -0700
Message-Id: <1301416611-3651-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

using a cleanup script I found this, could be real/fake not sure
I grepped the whole kernel and only found this. If/when you have
time let me know..

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/Kconfig         |    3 ---
 kernel/Kconfig.locks |    2 +-
 2 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index f78c2be..8d24bac 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -144,9 +144,6 @@ config HAVE_CLK
 config HAVE_DMA_API_DEBUG
 	bool
 
-config HAVE_DEFAULT_NO_SPIN_MUTEXES
-	bool
-
 config HAVE_HW_BREAKPOINT
 	bool
 	depends on PERF_EVENTS
diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
index 88c92fb..5e62baf 100644
--- a/kernel/Kconfig.locks
+++ b/kernel/Kconfig.locks
@@ -199,4 +199,4 @@ config INLINE_WRITE_UNLOCK_IRQRESTORE
 	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
 
 config MUTEX_SPIN_ON_OWNER
-	def_bool SMP && !DEBUG_MUTEXES && !HAVE_DEFAULT_NO_SPIN_MUTEXES
+	def_bool SMP && !DEBUG_MUTEXES 
-- 
1.7.4.1

