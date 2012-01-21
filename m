Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751068Ab2AUSD6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 13:03:58 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:33359 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750778Ab2AUSD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 13:03:57 -0500
Message-ID: <4F1B0BC0.3070508@xenotime.net>
Date: Sat, 21 Jan 2012 11:02:24 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>
Subject: [PATCH 1/14] kernel-doc: fix new warnings in auditsc.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix new kernel-doc warnings in auditsc.c:

Warning(kernel/auditsc.c:1875): No description found for parameter 'success'
Warning(kernel/auditsc.c:1875): No description found for parameter 'return_code'
Warning(kernel/auditsc.c:1875): Excess function parameter 'pt_regs' description in '__audit_syscall_exit'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
---
 kernel/auditsc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- lnx-33-rc1.orig/kernel/auditsc.c
+++ lnx-33-rc1/kernel/auditsc.c
@@ -1863,11 +1863,12 @@ void __audit_syscall_entry(int arch, int
 
 /**
  * audit_syscall_exit - deallocate audit context after a system call
- * @pt_regs: syscall registers
+ * @success: success value of the syscall
+ * @return_code: return value of the syscall
  *
  * Tear down after system call.  If the audit context has been marked as
  * auditable (either because of the AUDIT_RECORD_CONTEXT state from
- * filtering, or because some other part of the kernel write an audit
+ * filtering, or because some other part of the kernel wrote an audit
  * message), then write out the syscall information.  In call cases,
  * free the names stored from getname().
  */
