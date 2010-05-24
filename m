Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780Ab0EXXI2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:08:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:55405 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758378Ab0EXXI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:08:27 -0400
Date: Mon, 24 May 2010 23:08:04 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akpm@linux-foundation.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, akpm@linux-foundation.org, tglx@linutronix.de,
       hpa@linux.intel.com
In-Reply-To: <201005241913.o4OJDJe9010881@imap1.linux-foundation.org>
References: <201005241913.o4OJDJe9010881@imap1.linux-foundation.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: remove last traces of quicklist usage
Message-ID: <tip-48691ff86d91db1090551ec2a5ae0d80ef59105f@git.kernel.org>
Git-Commit-ID: 48691ff86d91db1090551ec2a5ae0d80ef59105f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 24 May 2010 23:08:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  48691ff86d91db1090551ec2a5ae0d80ef59105f
Gitweb:     http://git.kernel.org/tip/48691ff86d91db1090551ec2a5ae0d80ef59105f
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 24 May 2010 12:13:19 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 24 May 2010 13:33:31 -0700

x86: remove last traces of quicklist usage

We still have a stray quicklist header included even though we axed
quicklist usage quite a while back.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <201005241913.o4OJDJe9010881@imap1.linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/pgtable_32.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
index 7928540..cac7184 100644
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -9,7 +9,6 @@
 #include <linux/pagemap.h>
 #include <linux/spinlock.h>
 #include <linux/module.h>
-#include <linux/quicklist.h>
 
 #include <asm/system.h>
 #include <asm/pgtable.h>
