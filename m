Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127Ab2E3IHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 04:07:38 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:35989 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab2E3IHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 04:07:34 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org
Subject: [PATCH] ia64: remove configuration for GENERIC_LOCKBREAK
Date: Wed, 30 May 2012 16:07:24 +0800
Message-Id: <1338365244-11971-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

'def_bool n' is pointless and ia64 has realized ticket
spinlock.

'grep' makes me think ia64 has GENERIC_LOCKBREAK set,
then notice that it's off by default.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-ia64@vger.kernel.org
---
 arch/ia64/Kconfig |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 8186ec5..5e6b361 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -78,9 +78,6 @@ config SWIOTLB
 config STACKTRACE_SUPPORT
 	def_bool y
 
-config GENERIC_LOCKBREAK
-	def_bool n
-
 config RWSEM_XCHGADD_ALGORITHM
 	bool
 	default y
-- 
1.7.5.4

