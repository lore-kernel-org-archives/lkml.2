Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab2DEGtg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 02:49:36 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33271 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab2DEGte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 02:49:34 -0400
Date: Wed, 4 Apr 2012 23:49:32 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mike Galbraith <mgalbraith@suse.de>
cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [patch] cgroups: disallow attaching kthreadd
In-Reply-To: <1333608177.7783.106.camel@marge.simpson.net>
Message-ID: <alpine.DEB.2.00.1204042344090.8991@chino.kir.corp.google.com>
References: <1333475906.7439.7.camel@marge.simpson.net> <alpine.DEB.2.00.1204040008040.5356@chino.kir.corp.google.com> <1333535915.7188.18.camel@marge.simpson.net> <alpine.DEB.2.00.1204040419450.23137@chino.kir.corp.google.com> <1333542649.7188.40.camel@marge.simpson.net>
 <alpine.DEB.2.00.1204041414220.26086@chino.kir.corp.google.com> <20120404230922.GC2173@dhcp-172-17-108-109.mtv.corp.google.com> <1333601231.7783.31.camel@marge.simpson.net> <alpine.DEB.2.00.1204042157530.31186@chino.kir.corp.google.com>
 <1333604949.7783.76.camel@marge.simpson.net> <alpine.DEB.2.00.1204042303510.7035@chino.kir.corp.google.com> <1333608177.7783.106.camel@marge.simpson.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Apr 2012, Mike Galbraith wrote:

> > The last time we went through this, it was left after Andrew had fixed it 
> > up when the cpusets version was merged in -mm without any disagreement 
> > from Peter who was cc'd and that version was acked both by myself and Paul 
> > Menage at https://lkml.org/lkml/2011/12/14/402.  Andrew dropped it and 
> > asked for a repost since there was some on-going scheduler work going on 
> > in linux-next that caused that version not to apply.  No follow-up was 
> > ever offered.
> 
> Hm, I thought I did that.
> 

There's no reply from you to Andrew's email unless it was private.

> > Why have we now gone in a completely different direction again?
> 
> I already said that after Peter griped and suggested global, I thought
> about it, and liked that better.

I think you're taking Peter's questions as a nack.  He asked a question, I 
answered it.  He didn't participate in the thread after October 20.  
Andrew's email to you asking for a new version is December 14 with these 
lines:

Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Paul Menage <paul@paulmenage.org>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>

He's been cc'd the whole time.  Looking through the lengthy emails, he 
never actually nack'd _any_ version of this patch.  He asked why not do it 
for all cgroups.  That's it.

If cpusets is a cgroup, why would he nack a patch that does it for cpusets 
that addresses a cpusets problem if he was asking to do it for _all_ 
cgroups including cpusets?

> The submitted patchlet can either fly
> or die.  It's not a big deal.
> 

I'm hoping you will take this bug more seriously.
