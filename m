Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243Ab1DYKNM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 06:13:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:48701 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439Ab1DYKNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 06:13:10 -0400
Date: Mon, 25 Apr 2011 10:12:55 GMT
From: "tip-bot for Justin P. Mattock" <justinmattock@gmail.com>
Message-ID: <tip-fa7b69475a6c192853949ba496dd9c37b497b548@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, justinmattock@gmail.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, gorcunov@gmail.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, justinmattock@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, gorcunov@gmail.com,
        mingo@elte.hu
In-Reply-To: <1303492132-3004-1-git-send-email-justinmattock@gmail.com>
References: <1303492132-3004-1-git-send-email-justinmattock@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf events, x86, P4: Fix typo in comment
Git-Commit-ID: fa7b69475a6c192853949ba496dd9c37b497b548
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 25 Apr 2011 10:12:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fa7b69475a6c192853949ba496dd9c37b497b548
Gitweb:     http://git.kernel.org/tip/fa7b69475a6c192853949ba496dd9c37b497b548
Author:     Justin P. Mattock <justinmattock@gmail.com>
AuthorDate: Fri, 22 Apr 2011 10:08:52 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 24 Apr 2011 13:16:04 +0200

perf events, x86, P4: Fix typo in comment

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Acked-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: trivial@kernel.org
Link: http://lkml.kernel.org/r/1303492132-3004-1-git-send-email-justinmattock@gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_p4.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index ae31e96..f4c1da2 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -1187,7 +1187,7 @@ static __init int p4_pmu_init(void)
 {
 	unsigned int low, high;
 
-	/* If we get stripped -- indexig fails */
+	/* If we get stripped -- indexing fails */
 	BUILD_BUG_ON(ARCH_P4_MAX_CCCR > X86_PMC_MAX_GENERIC);
 
 	rdmsr(MSR_IA32_MISC_ENABLE, low, high);
