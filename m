Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab1ERFNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 01:13:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:47172 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624Ab1ERFNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 01:13:17 -0400
Date: Wed, 18 May 2011 05:13:08 GMT
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Message-ID: <tip-dc23c0bccf5eea171c87b3db285d032b9a5f06c4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1305683069-25394-3-git-send-email-fenghua.yu@intel.com>
References: <1305683069-25394-3-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/smep] x86, cpu: Add SMEP CPU feature in CR4
Git-Commit-ID: dc23c0bccf5eea171c87b3db285d032b9a5f06c4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 18 May 2011 05:13:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dc23c0bccf5eea171c87b3db285d032b9a5f06c4
Gitweb:     http://git.kernel.org/tip/dc23c0bccf5eea171c87b3db285d032b9a5f06c4
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Tue, 17 May 2011 18:44:27 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 17 May 2011 21:06:42 -0700

x86, cpu: Add SMEP CPU feature in CR4

Add support for newly documented SMEP (Supervisor Mode Execution Protection)
CPU feature in CR4.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
LKML-Reference: <1305683069-25394-3-git-send-email-fenghua.yu@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/processor-flags.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/processor-flags.h b/arch/x86/include/asm/processor-flags.h
index a898a2b..59ab4df 100644
--- a/arch/x86/include/asm/processor-flags.h
+++ b/arch/x86/include/asm/processor-flags.h
@@ -60,6 +60,7 @@
 #define X86_CR4_OSXMMEXCPT 0x00000400 /* enable unmasked SSE exceptions */
 #define X86_CR4_VMXE	0x00002000 /* enable VMX virtualization */
 #define X86_CR4_OSXSAVE 0x00040000 /* enable xsave and xrestore */
+#define X86_CR4_SMEP	0x00100000 /* enable SMEP support */
 
 /*
  * x86-64 Task Priority Register, CR8
