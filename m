Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746Ab1GRXzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 19:55:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:48199 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829Ab1GRXzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 19:55:20 -0400
Date: Mon, 18 Jul 2011 23:54:55 GMT
From: tip-bot for Borislav Petkov <bp@alien8.de>
Message-ID: <tip-8c400f6ce068366bc3517f1036bb99169cfec9cd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        luto@mit.edu, tglx@linutronix.de, hpa@linux.intel.com, bp@alien8.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@mit.edu, tglx@linutronix.de, bp@alien8.de, hpa@linux.intel.com
In-Reply-To: <20110718191054.GA18359@liondog.tnic>
References: <20110718191054.GA18359@liondog.tnic>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86, vdso: Drop now wrong comment
Git-Commit-ID: 8c400f6ce068366bc3517f1036bb99169cfec9cd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Jul 2011 23:54:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8c400f6ce068366bc3517f1036bb99169cfec9cd
Gitweb:     http://git.kernel.org/tip/8c400f6ce068366bc3517f1036bb99169cfec9cd
Author:     Borislav Petkov <bp@alien8.de>
AuthorDate: Mon, 18 Jul 2011 21:10:54 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 18 Jul 2011 12:29:50 -0700

x86, vdso: Drop now wrong comment

Now that 1b3f2a72bbcfdf92e368a44448c45eb639b05b5e is in, it is very
important that the below lying comment be removed! :-)

Signed-off-by: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/20110718191054.GA18359@liondog.tnic
Acked-by: Andy Lutomirski <luto@mit.edu>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/vdso/vclock_gettime.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 8792d6e..6bc0e72 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -6,7 +6,6 @@
  *
  * The code should have no internal unresolved relocations.
  * Check with readelf after changing.
- * Also alternative() doesn't work.
  */
 
 /* Disable profiling for userspace code: */
