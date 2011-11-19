Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab1KSAfj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 19:35:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54279 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab1KSAfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 19:35:37 -0500
Date: Fri, 18 Nov 2011 16:35:28 -0800
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-61f1e7e20874e8f11dab69b6a4bf7616badd4fe8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1321569446-20433-4-git-send-email-hpa@linux.intel.com>
References: <1321569446-20433-4-git-send-email-hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/syscall] x86, syscall: Re-fix typo in comment
Git-Commit-ID: 61f1e7e20874e8f11dab69b6a4bf7616badd4fe8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 16:35:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  61f1e7e20874e8f11dab69b6a4bf7616badd4fe8
Gitweb:     http://git.kernel.org/tip/61f1e7e20874e8f11dab69b6a4bf7616badd4fe8
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Fri, 18 Nov 2011 16:25:07 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 18 Nov 2011 16:25:07 -0800

x86, syscall: Re-fix typo in comment

Fix the same typo as was fixed in:

b7641d2c x86-64, syscall: Adjust comment spacing and remove typo

... for the new versions of this file (32-bit and IA32 compat).

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1321569446-20433-4-git-send-email-hpa@linux.intel.com
---
 arch/x86/ia32/syscall_ia32.c |    2 +-
 arch/x86/kernel/syscall_32.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/ia32/syscall_ia32.c b/arch/x86/ia32/syscall_ia32.c
index d04d3db..4754ba0 100644
--- a/arch/x86/ia32/syscall_ia32.c
+++ b/arch/x86/ia32/syscall_ia32.c
@@ -17,7 +17,7 @@ extern void compat_ni_syscall(void);
 
 const sys_call_ptr_t ia32_sys_call_table[__NR_ia32_syscall_max+1] = {
 	/*
-	 * Smells like a like a compiler bug -- it doesn't work
+	 * Smells like a compiler bug -- it doesn't work
 	 * when the & below is removed.
 	 */
 	[0 ... __NR_ia32_syscall_max] = &compat_ni_syscall,
diff --git a/arch/x86/kernel/syscall_32.c b/arch/x86/kernel/syscall_32.c
index b37a573..147fcd4 100644
--- a/arch/x86/kernel/syscall_32.c
+++ b/arch/x86/kernel/syscall_32.c
@@ -17,7 +17,7 @@ extern asmlinkage void sys_ni_syscall(void);
 
 const sys_call_ptr_t sys_call_table[__NR_syscall_max+1] = {
 	/*
-	 * Smells like a like a compiler bug -- it doesn't work
+	 * Smells like a compiler bug -- it doesn't work
 	 * when the & below is removed.
 	 */
 	[0 ... __NR_syscall_max] = &sys_ni_syscall,
