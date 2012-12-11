Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab2LKHuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 02:50:09 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61101 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab2LKHuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 02:50:07 -0500
Date: Tue, 11 Dec 2012 08:50:01 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core/locking change for v3.8
Message-ID: <20121211075001.GA20769@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-locking-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-locking-for-linus

   HEAD: 99fb4a122e96203dfd6c67d99d908aafd20f4753 lockdep: Use KSYM_NAME_LEN'ed buffer for __get_key_name()

Just a oneliner cleanup.

 Thanks,

	Ingo

------------------>
Cyrill Gorcunov (1):
      lockdep: Use KSYM_NAME_LEN'ed buffer for __get_key_name()


 kernel/lockdep_proc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index 91c32a0..b2c71c5 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -39,7 +39,7 @@ static void l_stop(struct seq_file *m, void *v)
 
 static void print_name(struct seq_file *m, struct lock_class *class)
 {
-	char str[128];
+	char str[KSYM_NAME_LEN];
 	const char *name = class->name;
 
 	if (!name) {

