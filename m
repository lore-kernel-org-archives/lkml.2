Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab1KQWi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 17:38:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:12670 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669Ab1KQWhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 17:37:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="77077674"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-kernel@vger.kernel.org, kbuild@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "H.J. Lu" <hjl.tools@gmail.com>, David Woodhouse <dwmw2@infradead.org>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 3/8] x86-64, syscall: Adjust comment spacing and remove typo
Date: Thu, 17 Nov 2011 14:37:21 -0800
Message-Id: <1321569446-20433-4-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1321569446-20433-1-git-send-email-hpa@linux.intel.com>
References: <1321569446-20433-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

Adjust spacing for comment so that it matches the multiline comment
style used in the rest of the kernel, and remove word duplication.

It is not really clear what version of gcc this refers to, but the
extra & doesn't cause any harm, so there is no reason to remove it.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/syscall_64.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/syscall_64.c b/arch/x86/kernel/syscall_64.c
index de87d60..0edfafa 100644
--- a/arch/x86/kernel/syscall_64.c
+++ b/arch/x86/kernel/syscall_64.c
@@ -21,9 +21,9 @@ extern void sys_ni_syscall(void);
 
 const sys_call_ptr_t sys_call_table[__NR_syscall_max+1] = {
 	/*
-	*Smells like a like a compiler bug -- it doesn't work
-	*when the & below is removed.
-	*/
+	 * Smells like a compiler bug -- it doesn't work
+	 * when the & below is removed.
+	 */
 	[0 ... __NR_syscall_max] = &sys_ni_syscall,
 #include <asm/unistd_64.h>
 };
-- 
1.7.6.4

