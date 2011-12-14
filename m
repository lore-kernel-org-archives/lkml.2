Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093Ab1LNQQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 11:16:39 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37011 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab1LNQQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 11:16:36 -0500
Date: Wed, 14 Dec 2011 17:16:31 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: manual merge of the akpm tree with the cgroup tree
Message-ID: <20111214161628.GC10791@somewhere.redhat.com>
References: <20111214175101.daac0549e5ed9d766c3a9bb5@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111214175101.daac0549e5ed9d766c3a9bb5@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 05:51:01PM +1100, Stephen Rothwell wrote:
> Hi Andrew,
> 
> Today's linux-next merge of the akpme tree got conflicts in several files
> between commits from the cgroup  tree and commit "cgroups: add previous
> cgroup in can_attach_task/attach_task callbacks" from the akpm tree.
> 
> This got a bit to hard to resolve, so I dropped that patch and the
> following from the akpm tree.

Yeah there are many things I need to update to get a clean rebase.

> 
> cgroups: new cancel_attach_task() subsystem callback
> cgroups: ability to stop res charge propagation on bounded ancestor
> cgroups: add res counter common ancestor searching
> res_counter: allow charge failure pointer to be null
> cgroups: pull up res counter charge failure interpretation to caller
> cgroups: allow subsystems to cancel a fork
> cgroups: add a task counter subsystem
> cgroups: ERR_PTR needs err.h
> cgroup: Fix task counter common ancestor logic
> cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes
> 
> I am wondering if that patch set should be included in the cgroup tree?

That would be probably the easier solution.
Andrew, do you mind if I rebase these patches and target them to Tejun's
tree instead? We can keep them on a standalone branch there based on Tejuns until
we reach an agreement on their upstreamability.
