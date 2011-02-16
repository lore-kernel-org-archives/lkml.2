Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539Ab1BPBw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:52:27 -0500
Received: from kroah.org ([198.145.64.141]:51382 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758659Ab1BPBwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:52:16 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:47:05 2011
Message-Id: <20110216014705.654816731@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:46:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
        Dhaval Giani <dhaval.giani@gmail.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <error27@gmail.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>
Subject: [114/115] sched: Remove  some dead code
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------


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


