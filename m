Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab1FNWu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 18:50:27 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:37699 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab1FNWu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 18:50:26 -0400
Date: Tue, 14 Jun 2011 15:50:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] signal.c: fix kernel-doc notation
Message-Id: <20110614155011.fa9b4cf0.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090208.4DF7E5AF.0061:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warnings in signal.c:

Warning(kernel/signal.c:2374): No description found for parameter 'nset'
Warning(kernel/signal.c:2374): Excess function parameter 'set' description in 'sys_rt_sigprocmask'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-30-rc3.orig/kernel/signal.c
+++ lnx-30-rc3/kernel/signal.c
@@ -2365,7 +2365,7 @@ int sigprocmask(int how, sigset_t *set, 
 /**
  *  sys_rt_sigprocmask - change the list of currently blocked signals
  *  @how: whether to add, remove, or set signals
- *  @set: stores pending signals
+ *  @nset: stores pending signals
  *  @oset: previous value of signal mask if non-null
  *  @sigsetsize: size of sigset_t type
  */
