Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993Ab2IUUBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 16:01:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50868 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757741Ab2IUUBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 16:01:21 -0400
Date: Fri, 21 Sep 2012 13:01:10 -0700
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-76f30759f690db21ca567a20665ed2679ad3235b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1348256595-29119-6-git-send-email-hpa@linux.intel.com>
References: <1348256595-29119-6-git-send-email-hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/smap] x86, alternative: Add header guards to <asm/
 alternative-asm.h>
Git-Commit-ID: 76f30759f690db21ca567a20665ed2679ad3235b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 21 Sep 2012 13:01:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  76f30759f690db21ca567a20665ed2679ad3235b
Gitweb:     http://git.kernel.org/tip/76f30759f690db21ca567a20665ed2679ad3235b
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Fri, 21 Sep 2012 12:43:09 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 21 Sep 2012 12:45:26 -0700

x86, alternative: Add header guards to <asm/alternative-asm.h>

Add header guards to protect <asm/alternative-asm.h> against multiple
inclusion.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1348256595-29119-6-git-send-email-hpa@linux.intel.com
---
 arch/x86/include/asm/alternative-asm.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/alternative-asm.h b/arch/x86/include/asm/alternative-asm.h
index 018d29f..372231c 100644
--- a/arch/x86/include/asm/alternative-asm.h
+++ b/arch/x86/include/asm/alternative-asm.h
@@ -1,3 +1,6 @@
+#ifndef _ASM_X86_ALTERNATIVE_ASM_H
+#define _ASM_X86_ALTERNATIVE_ASM_H
+
 #ifdef __ASSEMBLY__
 
 #include <asm/asm.h>
@@ -24,3 +27,5 @@
 .endm
 
 #endif  /*  __ASSEMBLY__  */
+
+#endif /* _ASM_X86_ALTERNATIVE_ASM_H */
