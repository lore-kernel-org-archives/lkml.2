Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab1GAAWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 20:22:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:57929 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286Ab1GAAWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 20:22:06 -0400
Date: Fri, 1 Jul 2011 00:21:59 GMT
From: tip-bot for Greg Dietsche <Gregory.Dietsche@cuw.edu>
Message-ID: <tip-a5fd117a8fda8621e1ae1bb3b8d55e4c0ebabd94@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        Gregory.Dietsche@cuw.edu, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        Gregory.Dietsche@cuw.edu, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1309473108-5337-1-git-send-email-Gregory.Dietsche@cuw.edu>
References: <1309473108-5337-1-git-send-email-Gregory.Dietsche@cuw.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, smpboot: Mark names[] array as const
Git-Commit-ID: a5fd117a8fda8621e1ae1bb3b8d55e4c0ebabd94
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 01 Jul 2011 00:22:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a5fd117a8fda8621e1ae1bb3b8d55e4c0ebabd94
Gitweb:     http://git.kernel.org/tip/a5fd117a8fda8621e1ae1bb3b8d55e4c0ebabd94
Author:     Greg Dietsche <Gregory.Dietsche@cuw.edu>
AuthorDate: Thu, 30 Jun 2011 17:31:48 -0500
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 30 Jun 2011 16:44:12 -0700

x86, smpboot: Mark names[] array as const

The array names[] in __inquire_remote_apic is read-only. Make it
explicit by marking as const.

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
Link: http://lkml.kernel.org/r/1309473108-5337-1-git-send-email-Gregory.Dietsche@cuw.edu
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/smpboot.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index a3c430b..4dbf60e 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -425,7 +425,7 @@ static void impress_friends(void)
 void __inquire_remote_apic(int apicid)
 {
 	unsigned i, regs[] = { APIC_ID >> 4, APIC_LVR >> 4, APIC_SPIV >> 4 };
-	char *names[] = { "ID", "VERSION", "SPIV" };
+	const char const *names[] = { "ID", "VERSION", "SPIV" };
 	int timeout;
 	u32 status;
 
