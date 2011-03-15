Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab1COXMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 19:12:36 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:50369 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752597Ab1COXMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 19:12:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=d+d+zeZrJtzH9HT2mML+WoOKKAZZqc+HTatPLcMsKLK4ZiHuwvtdELJ07czwB8IwF3yXghefyHeLU7QxcbMWqbVAHbGOT7z5D+InpB/keetaSYsx3Qq1hn70g4YoWQlr;
Date: Tue, 15 Mar 2011 16:12:30 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 6/6] sched.c: fix kernel-doc for runqueue_is_locked()
Message-Id: <20110315161230.c4e1e8e3.rdunlap@xenotime.net>
In-Reply-To: <20110315134316.465b6e2c.rdunlap@xenotime.net>
References: <20110315134316.465b6e2c.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 173.50.240.230 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warning for runqueue_is_locked():

Warning(kernel/sched.c:664): missing initial short description on line:

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- lnx-2638-rc8.orig/kernel/sched.c
+++ lnx-2638-rc8/kernel/sched.c
@@ -664,10 +664,9 @@ static void update_rq_clock(struct rq *r
 #endif
 
 /**
- * runqueue_is_locked
+ * runqueue_is_locked - Returns true if the current cpu runqueue is locked
  * @cpu: the processor in question.
  *
- * Returns true if the current cpu runqueue is locked.
  * This interface allows printk to be called with the runqueue lock
  * held and know whether or not it is OK to wake up the klogd.
  */
