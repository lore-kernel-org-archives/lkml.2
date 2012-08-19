Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab2HSC6d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 22:58:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:42975 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182Ab2HSC52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="182675625"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 39/74] x86, lto: Mark vdso variables __visible
Date: Sat, 18 Aug 2012 19:56:35 -0700
Message-Id: <1345345030-22211-40-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/vvar.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
index de656ac..d76ac40 100644
--- a/arch/x86/include/asm/vvar.h
+++ b/arch/x86/include/asm/vvar.h
@@ -35,7 +35,7 @@
 
 #define DEFINE_VVAR(type, name)						\
 	type name							\
-	__attribute__((section(".vvar_" #name), aligned(16)))
+	__attribute__((section(".vvar_" #name), aligned(16))) __visible
 
 #define VVAR(name) (*vvaraddr_ ## name)
 
-- 
1.7.7.6

