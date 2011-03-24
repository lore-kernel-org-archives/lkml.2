Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933473Ab1CXJCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 05:02:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:38308 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932768Ab1CXJCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 05:02:16 -0400
Date: Thu, 24 Mar 2011 09:01:59 GMT
From: tip-bot for Rakib Mullick <rakib.mullick@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rakib.mullick@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rakib.mullick@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <AANLkTikh3y+is3xixKBdyHhr_cHxzPFJF729Fcvt8+Ns@mail.gmail.com>
References: <AANLkTikh3y+is3xixKBdyHhr_cHxzPFJF729Fcvt8+Ns@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, mpparse: Remove unnecessary variable
Message-ID: <tip-9f1f1bfd8d7e579f07dbe56d6f93bd594da43b3d@git.kernel.org>
Git-Commit-ID: 9f1f1bfd8d7e579f07dbe56d6f93bd594da43b3d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 24 Mar 2011 09:01:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9f1f1bfd8d7e579f07dbe56d6f93bd594da43b3d
Gitweb:     http://git.kernel.org/tip/9f1f1bfd8d7e579f07dbe56d6f93bd594da43b3d
Author:     Rakib Mullick <rakib.mullick@gmail.com>
AuthorDate: Wed, 23 Mar 2011 21:31:40 +0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 24 Mar 2011 09:05:40 +0100

x86, mpparse: Remove unnecessary variable

'ret' isn't used by check_slot(), gets initialized but has no real use,
so remove it.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
LKML-Reference: <AANLkTikh3y+is3xixKBdyHhr_cHxzPFJF729Fcvt8+Ns@mail.gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/mpparse.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 6f789a8..ef32d4c 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -722,14 +722,12 @@ inline void __init check_irq_src(struct mpc_intsrc *m, int *nr_m_spare) {}
 static int
 check_slot(unsigned long mpc_new_phys, unsigned long mpc_new_length, int count)
 {
-	int ret = 0;
-
 	if (!mpc_new_phys || count <= mpc_new_length) {
 		WARN(1, "update_mptable: No spare slots (length: %x)\n", count);
 		return -1;
 	}
 
-	return ret;
+	return 0;
 }
 
 static int  __init replace_intsrc_all(struct mpc_table *mpc,
