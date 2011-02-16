Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932742Ab1BPBz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:55:27 -0500
Received: from kroah.org ([198.145.64.141]:49330 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758598Ab1BPBvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:51:50 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:47:04 2011
Message-Id: <20110216014704.266921574@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:46:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Young <hidave.darkstar@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>
Subject: [100/115] sched: Remove unused PF_ALIGNWARN flag
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

Commit: 637bbdc5b83615ef9f45f50399d1c7f27473c713 upstream

PF_ALIGNWARN is not implemented and it is for 486 as the
comment.

It is not likely someone will implement this flag feature.
So here remove this flag and leave the valuable 0x00000001 for
future use.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <20100913121903.GB22238@darkstar>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/sched.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1728,8 +1728,6 @@ extern void thread_group_times(struct ta
 /*
  * Per process flags
  */
-#define PF_ALIGNWARN	0x00000001	/* Print alignment warning msgs */
-					/* Not implemented yet, only for 486*/
 #define PF_STARTING	0x00000002	/* being created */
 #define PF_EXITING	0x00000004	/* getting shut down */
 #define PF_EXITPIDONE	0x00000008	/* pi exit done on shut down */


