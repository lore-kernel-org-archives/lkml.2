Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546Ab1EZC2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 22:28:39 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:26843 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab1EZC2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 22:28:38 -0400
Date: Wed, 25 May 2011 19:28:15 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH] signal.c: fix kernel-doc warning
Message-Id: <20110525192815.01c9227f.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4DDDBACB.0071:SCFMA922111,ss=1,fgs=0
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

--- linux-2.6.39-git10.orig/kernel/signal.c
+++ linux-2.6.39-git10/kernel/signal.c
@@ -2365,7 +2365,7 @@ int sigprocmask(int how, sigset_t *set, 
 /**
  *  sys_rt_sigprocmask - change the list of currently blocked signals
  *  @how: whether to add, remove, or set signals
- *  @set: stores pending signals
+ *  @nset: stores pending signals
  *  @oset: previous value of signal mask if non-null
  *  @sigsetsize: size of sigset_t type
  */
