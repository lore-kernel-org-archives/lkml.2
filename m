Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab1DHRxu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 13:53:50 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:43916 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751871Ab1DHRxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 13:53:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ckQhCTk4a8sZb9Q52zOsAM1/va2Hd/dYQCFnhRXa/ca28Ab7/Ue6aSoFqNfkRgOnUPK0tqFFxXoPTsTMe5lQ2pwP5npMBPKO7ZpArA1X/2lB2sHZKVI+TL4tRcaoDktE;
Date: Fri, 8 Apr 2011 10:53:46 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Matt Fleming <matt@console-pimps.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] signal.c: fix erroneous syscall kernel-doc
Message-Id: <20110408105346.9218d4db.rdunlap@xenotime.net>
In-Reply-To: <20110405093214.0dd7278d@mfleming-mobl1.ger.corp.intel.com>
References: <20110404145803.8663081d.rdunlap@xenotime.net>
	<20110404150026.46478a04.rdunlap@xenotime.net>
	<20110405093214.0dd7278d@mfleming-mobl1.ger.corp.intel.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix erroneous syscall kernel-doc comments in kernel/signal.c. 

Reported-by: Matt Fleming <matt@console-pimps.org>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 kernel/signal.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.39-rc2.orig/kernel/signal.c
+++ linux-2.6.39-rc2/kernel/signal.c
@@ -2711,8 +2711,8 @@ out:
 /**
  *  sys_rt_sigaction - alter an action taken by a process
  *  @sig: signal to be sent
- *  @act: the thread group ID of the thread
- *  @oact: the PID of the thread
+ *  @act: new sigaction
+ *  @oact: used to save the previous sigaction
  *  @sigsetsize: size of sigset_t type
  */
 SYSCALL_DEFINE4(rt_sigaction, int, sig,
