Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab1BTNHh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 08:07:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:52622 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064Ab1BTNHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 08:07:35 -0500
Date: Sun, 20 Feb 2011 13:07:09 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, mingo@elte.hu, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, borislav.petkov@amd.com, mingo@elte.hu
In-Reply-To: <1298044056-31104-1-git-send-email-bp@amd64.org>
References: <1298044056-31104-1-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86, system.h: Drop unused __SAVE/__RESTORE macros
Message-ID: <tip-2b15cd96e5e93f9aa4f7041c91c1e7c344a62cbb@git.kernel.org>
Git-Commit-ID: 2b15cd96e5e93f9aa4f7041c91c1e7c344a62cbb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 20 Feb 2011 13:07:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2b15cd96e5e93f9aa4f7041c91c1e7c344a62cbb
Gitweb:     http://git.kernel.org/tip/2b15cd96e5e93f9aa4f7041c91c1e7c344a62cbb
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Fri, 18 Feb 2011 16:47:36 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 20 Feb 2011 13:38:47 +0100

x86, system.h: Drop unused __SAVE/__RESTORE macros

Those are unused since at least the beginning of git history.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <1298044056-31104-1-git-send-email-bp@amd64.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/system.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index 33ecc3e..12569e6 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -98,8 +98,6 @@ do {									\
  */
 #define HAVE_DISABLE_HLT
 #else
-#define __SAVE(reg, offset) "movq %%" #reg ",(14-" #offset ")*8(%%rsp)\n\t"
-#define __RESTORE(reg, offset) "movq (14-" #offset ")*8(%%rsp),%%" #reg "\n\t"
 
 /* frame pointer must be last for get_wchan */
 #define SAVE_CONTEXT    "pushf ; pushq %%rbp ; movq %%rsi,%%rbp\n\t"
