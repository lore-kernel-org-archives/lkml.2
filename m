Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749Ab1LNSGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 13:06:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55156 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466Ab1LNSGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 13:06:33 -0500
Date: Wed, 14 Dec 2011 10:08:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: manual merge of the akpm tree with the cgroup tree
Message-Id: <20111214100851.2ead3872.akpm@linux-foundation.org>
In-Reply-To: <20111214161628.GC10791@somewhere.redhat.com>
References: <20111214175101.daac0549e5ed9d766c3a9bb5@canb.auug.org.au>
	<20111214161628.GC10791@somewhere.redhat.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Dec 2011 17:16:31 +0100 Frederic Weisbecker <fweisbec@gmail.com> wrote:

> > 
> > cgroups: new cancel_attach_task() subsystem callback
> > cgroups: ability to stop res charge propagation on bounded ancestor
> > cgroups: add res counter common ancestor searching
> > res_counter: allow charge failure pointer to be null
> > cgroups: pull up res counter charge failure interpretation to caller
> > cgroups: allow subsystems to cancel a fork
> > cgroups: add a task counter subsystem
> > cgroups: ERR_PTR needs err.h
> > cgroup: Fix task counter common ancestor logic
> > cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes
> > 
> > I am wondering if that patch set should be included in the cgroup tree?
> 
> That would be probably the easier solution.
> Andrew, do you mind if I rebase these patches and target them to Tejun's
> tree instead?

Sure, that works,  I'll drop them.

> We can keep them on a standalone branch there based on Tejuns until
> we reach an agreement on their upstreamability.

I wondered what had been happening with that discussion.  I guess we
need to restart it.

