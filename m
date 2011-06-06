Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab1FFVkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 17:40:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:55123 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756131Ab1FFVko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 17:40:44 -0400
Date: Mon, 6 Jun 2011 21:40:08 GMT
From: tip-bot for Andy Lutomirski <luto@mit.edu>
Message-ID: <tip-8d6316596441de42e3f30c8e536579f6292b46a0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        luto@mit.edu, torvalds@linux-foundation.org, mikpe@it.uu.se,
        tglx@linutronix.de, mingo@elte.hu, luto@mit.edu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@mit.edu, torvalds@linux-foundation.org, mikpe@it.uu.se,
        tglx@linutronix.de, mingo@elte.hu, luto@mit.edu
In-Reply-To: <ab1699caaea6c7863fb74abc2f5718353680070c.1307380481.git.luto@mit.edu>
References: <ab1699caaea6c7863fb74abc2f5718353680070c.1307380481.git.luto@mit.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86-64: Fix outdated comments in vsyscall_64.c
Git-Commit-ID: 8d6316596441de42e3f30c8e536579f6292b46a0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Jun 2011 21:40:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8d6316596441de42e3f30c8e536579f6292b46a0
Gitweb:     http://git.kernel.org/tip/8d6316596441de42e3f30c8e536579f6292b46a0
Author:     Andy Lutomirski <luto@MIT.EDU>
AuthorDate: Mon, 6 Jun 2011 13:27:23 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 6 Jun 2011 19:47:20 +0200

x86-64: Fix outdated comments in vsyscall_64.c

Signed-off-by: Andy Lutomirski <luto@mit.edu>
Cc: pageexec@freemail.hu
Cc: Mikael Pettersson <mikpe@it.uu.se>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/ab1699caaea6c7863fb74abc2f5718353680070c.1307380481.git.luto@mit.edu
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/vsyscall_64.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 27d49b7..0b50b3c 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -11,10 +11,11 @@
  *  vsyscalls. One vsyscall can reserve more than 1 slot to avoid
  *  jumping out of line if necessary. We cannot add more with this
  *  mechanism because older kernels won't return -ENOSYS.
- *  If we want more than four we need a vDSO.
  *
- *  Note: the concept clashes with user mode linux. If you use UML and
- *  want per guest time just set the kernel.vsyscall64 sysctl to 0.
+ *  This mechanism is deprecated in favor of the vDSO.
+ *
+ *  Note: the concept clashes with user mode linux.  UML users should
+ *  use the vDSO.
  */
 
 /* Disable profiling for userspace code: */
