Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab1BOWvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 17:51:24 -0500
Received: from kroah.org ([198.145.64.141]:40241 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756371Ab1BOWvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 17:51:21 -0500
Subject: Patch "sched: Remove  some dead code" has been added to the 2.6.32-longterm tree
To: error27@gmail.com, 20100315082148.GD18181@bicker, a.p.zijlstra@chello.nl,
        dhaval.giani@gmail.com, efault@gmx.de, gregkh@suse.de,
        kay.sievers@vrfy.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@suse.de>
Date: Tue, 15 Feb 2011 14:51:11 -0800
In-Reply-To: <1297404285.7865.21.camel@marge.simson.net>
Message-ID: <12978102711506@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    sched: Remove  some dead code

to the 2.6.32-longterm tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/longterm/longterm-queue-2.6.32.git;a=summary

The filename of the patch is:
     sched-remove-some-dead-code.patch
and it can be found in the queue-2.6.32 subdirectory.

If you, or anyone else, feels it should not be added to the 2.6.32 longterm tree,
please let <stable@kernel.org> know about it.


>From efault@gmx.de  Tue Feb 15 14:39:20 2011
From: Dan Carpenter <error27@gmail.com>
Date: Fri, 11 Feb 2011 07:04:45 +0100
Subject: sched: Remove  some dead code
To: Dhaval Giani <dhaval.giani@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Message-ID: <1297404285.7865.21.camel@marge.simson.net>


From: Dan Carpenter <error27@gmail.com>

commit 618765801ebc271fe0ba3eca99fcfd62a1f786e1 upstream.

This was left over from "7c9414385e sched: Remove USER_SCHED"

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Dhaval Giani <dhaval.giani@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
LKML-Reference: <20100315082148.GD18181@bicker>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/user.c |    2 --
 1 file changed, 2 deletions(-)

--- a/kernel/user.c
+++ b/kernel/user.c
@@ -170,8 +170,6 @@ struct user_struct *alloc_uid(struct use
 
 	return up;
 
-	put_user_ns(new->user_ns);
-	kmem_cache_free(uid_cachep, new);
 out_unlock:
 	return NULL;
 }


Patches currently in longterm-queue-2.6.32 which might be from error27@gmail.com are

