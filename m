Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab0IMMTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 08:19:12 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:35548 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab0IMMTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 08:19:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=nZxmkIlw6PNVgrbstXk7KeT9ZNgop3PmeUXruupXtwAWH/HfWkbHzEUwobjSWP+Vv2
         RzafABzwj2WohqY61mzayrhKRCz/HRaolk53hsrYtODSYgjyO59F4vgIorNOkhSYWBpV
         HTbm8t3P0KnAuATIFBY6Z88OkRt47fq4xcCJs=
Date: Mon, 13 Sep 2010 20:19:03 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] remove unused PF_ALIGNWARN flag
Message-ID: <20100913121903.GB22238@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PF_ALIGNWARN is not implemented and it is for 486 as the comment.

It is not likely someone will implement this flag feature.
So here remove this flag and leave the valuable 0x00000001 for future use.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 include/linux/sched.h |    2 --
 1 file changed, 2 deletions(-)

--- linux-2.6.orig/include/linux/sched.h	2010-08-20 10:29:22.000000000 +0800
+++ linux-2.6/include/linux/sched.h	2010-09-13 18:03:33.496667520 +0800
@@ -1681,8 +1681,6 @@ extern void thread_group_times(struct ta
 /*
  * Per process flags
  */
-#define PF_ALIGNWARN	0x00000001	/* Print alignment warning msgs */
-					/* Not implemented yet, only for 486*/
 #define PF_STARTING	0x00000002	/* being created */
 #define PF_EXITING	0x00000004	/* getting shut down */
 #define PF_EXITPIDONE	0x00000008	/* pi exit done on shut down */
