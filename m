Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab1EBMXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 08:23:25 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60220 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab1EBMXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 08:23:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UjLe000lHD/ALeTxXXy404zMKw15J4F1ELZEPfFCbF1nZ8MwhimBQnWrWlYs0nUnXy
         1FXzXeqyVmV5WqlOfY/Ca5t7W/mm8X6OIdjejeEGGHxFyKSNxO3RL4OOEzgze6VkVdO7
         c/RH64+XKS7tuekZ9v+ek3jhuuxYx9f2ODBDo=
Date: Mon, 2 May 2011 14:23:19 +0200
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [GIT PULL tip:x86/mm] Unify 32 and 64bit NUMA init paths
Message-ID: <20110502122319.GC22117@htj.dyndns.org>
References: <20110502091334.GB22117@htj.dyndns.org>
 <20110502101828.GB27072@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110502101828.GB27072@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

On Mon, May 02, 2011 at 12:18:28PM +0200, Ingo Molnar wrote:
> Yeah, it's fine to me if you do merges, but could you please do a x86/mm tree 
> where all your merge commit messages are amended with a 'Merge reason' 
> explanation?
> 
> See commit a4c98f8bbeafee12c979c90743f6fda94f7515c7 for an example of how Merge 
> reason lines look like.
> 
> This is what we do for all merge commits in the -tip tree - that way it's clear 
> in retrospect why a particular merge was done.

Branches updated as suggested.  The new HEAD is 356aec8b6e "x86, NUMA:
Trim numa meminfo with max_pfn in a separate loop".

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-mm
  ssh://master.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-mm

And FYI, the following descriptions were used for the two merge
commits.

Author: Tejun Heo <tj@kernel.org>  2011-05-02 14:08:43
Committer: Tejun Heo <tj@kernel.org>  2011-05-02 14:08:47
Parent: c7a7b814c9dca9ee01b38e63b4a46de87156d3b6 (ioremap: Delay sanity check until after a successful mapping)
Parent: 993ba1585cbb03fab012e41d1a5d24330a283b31 (x86-32, numa: Update remap allocator comments)
Child:  ba67cf5cf2ce10ad86a212b70f8c7c75d93a5016 (Merge branch 'x86/urgent' into x86-mm)
Branches: remotes/origin/x86-mm, x86-mm
Follows: v2.6.39-rc2
Precedes: 

    Merge branch 'x86/numa' into x86-mm
    
    Merge reason: Pick up x86-32 remap allocator cleanup changes - 14
    commits, 3fe14ab541^..993ba1585c.
    
      3fe14ab541: x86-32, numa: Fix failure condition check in alloc_remap()
      993ba1585c: x86-32, numa: Update remap allocator comments
    
    Scheduled NUMA init 32/64bit unification changes depend on them.
    
    Signed-off-by: Tejun Heo <tj@kernel.org>

Author: Tejun Heo <tj@kernel.org>  2011-05-02 14:16:37
Committer: Tejun Heo <tj@kernel.org>  2011-05-02 14:16:47
Parent: aff364860aa105b2deacc6f21ec8ef524460e3fc (Merge branch 'x86/numa' into x86-mm)
Parent: 2be19102b71c1a45d37fec50303791daa1a06869 (x86, NUMA: Fix empty memblk detection in numa_cleanup_meminfo())
Child:  9688678a6670c7f0ae3872450a8047c0ad401efb (x86-64, NUMA: Simplify hotadd memory handling)
Branches: remotes/origin/x86-mm, x86-mm
Follows: v2.6.39-rc5
Precedes: 

    Merge branch 'x86/urgent' into x86-mm
    
    Merge reason: Pick up the following two fix commits.
    
      2be19102b7: x86, NUMA: Fix empty memblk detection in numa_cleanup_meminfo()
      765af22da8: x86-32, NUMA: Fix ACPI NUMA init broken by recent x86-64 change
    
    Scheduled NUMA init 32/64bit unification changes depend on these.
    
    Signed-off-by: Tejun Heo <tj@kernel.org>

Thank you.

-- 
tejun
