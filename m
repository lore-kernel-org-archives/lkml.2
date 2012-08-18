Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145Ab2HRRdl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 13:33:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:44596 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755654Ab2HRRaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 13:30:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,791,1336374000"; 
   d="scan'208";a="182607891"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 08/31] sections: Fix section conflicts in arch/score
Date: Sat, 18 Aug 2012 10:29:59 -0700
Message-Id: <1345311022-26328-9-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
References: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/score/kernel/sys_score.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/score/kernel/sys_score.c b/arch/score/kernel/sys_score.c
index e478bf9..21e8679 100644
--- a/arch/score/kernel/sys_score.c
+++ b/arch/score/kernel/sys_score.c
@@ -112,6 +112,7 @@ score_execve(struct pt_regs *regs)
  * Do a system call from kernel instead of calling sys_execve so we
  * end up with proper pt_regs.
  */
+asmlinkage
 int kernel_execve(const char *filename,
 		  const char *const argv[],
 		  const char *const envp[])
-- 
1.7.7.6

