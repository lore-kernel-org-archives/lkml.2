Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab1HXU2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 16:28:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:51737 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826Ab1HXU2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 16:28:30 -0400
Date: Wed, 24 Aug 2011 20:28:20 GMT
From: tip-bot for Andy Lutomirski <luto@mit.edu>
Message-ID: <tip-7e49b1c8c6d64f55ac83e1f5901b22fa9e51ab80@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        luto@mit.edu, tglx@linutronix.de, hpa@linux.intel.com,
        hjl.tools@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@mit.edu, tglx@linutronix.de, hpa@linux.intel.com,
        hjl.tools@gmail.com
In-Reply-To: <b4cb60ef45db3a675a0e2b9d51bcb022b0a9ab9c.1314195481.git.luto@mit.edu>
References: <b4cb60ef45db3a675a0e2b9d51bcb022b0a9ab9c.1314195481.git.luto@mit.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86-64, unistd: Remove bogus __IGNORE_getcpu
Git-Commit-ID: 7e49b1c8c6d64f55ac83e1f5901b22fa9e51ab80
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (hera.kernel.org [127.0.0.1]); Wed, 24 Aug 2011 20:28:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7e49b1c8c6d64f55ac83e1f5901b22fa9e51ab80
Gitweb:     http://git.kernel.org/tip/7e49b1c8c6d64f55ac83e1f5901b22fa9e51ab80
Author:     Andy Lutomirski <luto@mit.edu>
AuthorDate: Wed, 24 Aug 2011 10:19:44 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 24 Aug 2011 10:23:51 -0700

x86-64, unistd: Remove bogus __IGNORE_getcpu

The change:

commit fce8dc06423d6fb2709469dc5c55b04e09c1d126
Author: Andy Lutomirski <luto@mit.edu>
Date:   Wed Aug 10 11:15:31 2011 -0400

    x86-64: Wire up getcpu syscall

added getcpu as a real syscall, so we shouldn't ignore it any more.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
Link: http://lkml.kernel.org/r/b4cb60ef45db3a675a0e2b9d51bcb022b0a9ab9c.1314195481.git.luto@mit.edu
Reported-by: H.J. Lu <hjl.tools@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/unistd_64.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index d92641c..940d720 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -624,7 +624,6 @@ __SYSCALL(__NR_vmsplice, sys_vmsplice)
 __SYSCALL(__NR_move_pages, sys_move_pages)
 #define __NR_utimensat				280
 __SYSCALL(__NR_utimensat, sys_utimensat)
-#define __IGNORE_getcpu		/* implemented as a vsyscall */
 #define __NR_epoll_pwait			281
 __SYSCALL(__NR_epoll_pwait, sys_epoll_pwait)
 #define __NR_signalfd				282
