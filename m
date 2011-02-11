Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362Ab1BKGEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 01:04:52 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:47490 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750981Ab1BKGEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 01:04:50 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19WtSJfX0dW6UazbmDNMD5ODHLP4J9JxQCrGla48C
	UBiuMYjWoNrAv8
Subject: [PATCH 29/28] sched: Remove  some dead code
From: Mike Galbraith <efault@gmx.de>
To: Dhaval Giani <dhaval.giani@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <AANLkTimbHE9H5_vmS3=L84z=OkL0GNAxg4xOUjnco5SL@mail.gmail.com>
References: <1297340643.5512.1.camel@marge.simson.net>
	 <AANLkTikLM=Q_p0dk3USsYtLJ6GXKZsNoQuK3J+dA_z9V@mail.gmail.com>
	 <AANLkTimbHE9H5_vmS3=L84z=OkL0GNAxg4xOUjnco5SL@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Feb 2011 07:04:45 +0100
Message-ID: <1297404285.7865.21.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-10 at 19:35 +0100, Dhaval Giani wrote:
> >
> > There were a few more patches after this which cleaned up a few things
> > as well. Let me search them out and let you know the commit IDs.
> >
> 
> 6427462bfa50f50dc6c088c07037264fcc73eca1

From: Dan Carpenter <error27@gmail.com>
Date: Mon, 15 Mar 2010 11:21:48 +0300
Subject: sched: Remove some dead code


commit 618765801ebc271fe0ba3eca99fcfd62a1f786e1 upstream.

This was left over from "7c9414385e sched: Remove USER_SCHED"

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Dhaval Giani <dhaval.giani@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
LKML-Reference: <20100315082148.GD18181@bicker>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>

---
 kernel/user.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/user.c b/kernel/user.c
index 65be394..8e1c8c0 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -170,8 +170,6 @@ struct user_struct *alloc_uid(struct user_namespace *ns, uid_t uid)
 
 	return up;
 
-	put_user_ns(new->user_ns);
-	kmem_cache_free(uid_cachep, new);
 out_unlock:
 	return NULL;
 }


