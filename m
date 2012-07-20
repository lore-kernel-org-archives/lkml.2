Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab2GTVxG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 17:53:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52653 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab2GTVxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 17:53:04 -0400
Date: Fri, 20 Jul 2012 14:52:50 -0700
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-lgr6482ufk1bvxzvc2hr8qbp@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpufeature] x86, cpufeature:
  Add the RDSEED and ADX features
Git-Commit-ID: 30d5c4546a7dae29a1aa76abdb69a78bb00136be
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 20 Jul 2012 14:52:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  30d5c4546a7dae29a1aa76abdb69a78bb00136be
Gitweb:     http://git.kernel.org/tip/30d5c4546a7dae29a1aa76abdb69a78bb00136be
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Fri, 20 Jul 2012 13:35:06 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 20 Jul 2012 13:36:41 -0700

x86, cpufeature: Add the RDSEED and ADX features

Add the RDSEED and ADX features documented in section 9.1 of the Intel
Architecture Instruction Set Extensions Programming Reference,
document 319433, version 013b, available from
http://software.intel.com/en-us/avx/

The PREFETCHW bit is already supported in Linux under the name
3DNOWPREFETCH.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/n/tip-lgr6482ufk1bvxzvc2hr8qbp@git.kernel.org
---
 arch/x86/include/asm/cpufeature.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index f91e80f..6b7ee5f 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -207,6 +207,8 @@
 #define X86_FEATURE_ERMS	(9*32+ 9) /* Enhanced REP MOVSB/STOSB */
 #define X86_FEATURE_INVPCID	(9*32+10) /* Invalidate Processor Context ID */
 #define X86_FEATURE_RTM		(9*32+11) /* Restricted Transactional Memory */
+#define X86_FEATURE_RDSEED	(9*32+18) /* The RDSEED instruction */
+#define X86_FEATURE_ADX		(9*32+19) /* The ADCX and ADOX instructions */
 
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
