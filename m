Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab1C3Vum (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:50:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:58287 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933444Ab1C3VHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411277608"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: hidave.darkstar@gmail.com, ak@linux.intel.com, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, mingo@elte.hu, efault@gmx.de,
        gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [99/275] sched: Remove unused PF_ALIGNWARN flag
Message-Id: <20110330210537.DB6613E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
Commit: 637bbdc5b83615ef9f45f50399d1c7f27473c713 upstream

PF_ALIGNWARN is not implemented and it is for 486 as the
comment.

It is not likely someone will implement this flag feature.
So here remove this flag and leave the valuable 0x00000001 for
future use.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
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

Index: linux-2.6.35.y/include/linux/sched.h
===================================================================
--- linux-2.6.35.y.orig/include/linux/sched.h	2011-03-29 23:03:00.145296453 -0700
+++ linux-2.6.35.y/include/linux/sched.h	2011-03-29 23:55:01.200436460 -0700
@@ -1685,8 +1685,6 @@
 /*
  * Per process flags
  */
-#define PF_ALIGNWARN	0x00000001	/* Print alignment warning msgs */
-					/* Not implemented yet, only for 486*/
 #define PF_STARTING	0x00000002	/* being created */
 #define PF_EXITING	0x00000004	/* getting shut down */
 #define PF_EXITPIDONE	0x00000008	/* pi exit done on shut down */
