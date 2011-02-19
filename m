Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab1BSB0O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 20:26:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:59126 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755755Ab1BSB0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 20:26:11 -0500
Date: Sat, 19 Feb 2011 01:25:42 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        brgerst@gmail.com, castet.matthieu@free.fr, tglx@linutronix.de,
        sfr@canb.auug.org.au, hpa@linux.intel.com, rjw@sisk.pl
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        brgerst@gmail.com, castet.matthieu@free.fr, tglx@linutronix.de,
        sfr@canb.auug.org.au, hpa@linux.intel.com, rjw@sisk.pl
In-Reply-To: <AANLkTik6UJ680mWJcu_W+jerLcqPjwjvaXyxB1jAMaG0@mail.gmail.com>
References: <AANLkTik6UJ680mWJcu_W+jerLcqPjwjvaXyxB1jAMaG0@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trampoline] x86-64, trampoline: Remove unused variable
Message-ID: <tip-1c4badbdeae53d2584bb5395a062cfebed76696e@git.kernel.org>
Git-Commit-ID: 1c4badbdeae53d2584bb5395a062cfebed76696e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 19 Feb 2011 01:25:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1c4badbdeae53d2584bb5395a062cfebed76696e
Gitweb:     http://git.kernel.org/tip/1c4badbdeae53d2584bb5395a062cfebed76696e
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Fri, 18 Feb 2011 15:50:36 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 18 Feb 2011 15:50:36 -0800

x86-64, trampoline: Remove unused variable

Removed unused variable left over from development.

Reported-by: Brian Gerst <brgerst@gmail.com>
LKML-Reference: <AANLkTik6UJ680mWJcu_W+jerLcqPjwjvaXyxB1jAMaG0@mail.gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Matthieu Castet <castet.matthieu@free.fr>
---
 arch/x86/kernel/trampoline_64.S |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/trampoline_64.S b/arch/x86/kernel/trampoline_64.S
index 49c77a6..09ff517 100644
--- a/arch/x86/kernel/trampoline_64.S
+++ b/arch/x86/kernel/trampoline_64.S
@@ -157,8 +157,6 @@ startup_64_vector:
 	.word	__KERNEL_CS, 0
 
 	.balign 4
-fixup_base:
-	.long	0
 ENTRY(trampoline_status)
 	.long	0
 
