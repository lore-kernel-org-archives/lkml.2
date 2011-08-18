Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab1HRTHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:07:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47484 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab1HRTHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:07:10 -0400
Date: Thu, 18 Aug 2011 20:07:09 +0100
To: richard@nod.at
Subject: Subject: [PATCH 49/91] um: trim kern.h
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7vp-0007nu-Mj@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


most of the functions in there are not used in anything that ends up
including that header...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/include/shared/kern.h |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/arch/um/include/shared/kern.h b/arch/um/include/shared/kern.h
index 4ce3fc6..6cd0124 100644
--- a/arch/um/include/shared/kern.h
+++ b/arch/um/include/shared/kern.h
@@ -13,28 +13,10 @@
  * includes.
  */
 
-extern int errno;
-
-extern int clone(int (*proc)(void *), void *sp, int flags, void *data);
-extern int sleep(int);
 extern int printf(const char *fmt, ...);
-extern char *strerror(int errnum);
-extern char *ptsname(int __fd);
-extern int munmap(void *, int);
 extern void *sbrk(int increment);
-extern void *malloc(int size);
-extern void perror(char *err);
-extern int kill(int pid, int sig);
-extern int getuid(void);
-extern int getgid(void);
 extern int pause(void);
-extern int write(int, const void *, int);
 extern void exit(int);
-extern int close(int);
-extern int read(unsigned int, char *, int);
-extern int pipe(int *);
-extern int sched_yield(void);
-extern int ptrace(int op, int pid, long addr, long data);
 
 #endif
 
-- 
1.7.2.5


