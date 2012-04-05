Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409Ab2DEGnE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 02:43:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60256 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160Ab2DEGnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 02:43:02 -0400
Message-ID: <1333608177.7783.106.camel@marge.simpson.net>
Subject: Re: [patch] cgroups: disallow attaching kthreadd
From: Mike Galbraith <mgalbraith@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>
Date: Thu, 05 Apr 2012 08:42:57 +0200
In-Reply-To: <alpine.DEB.2.00.1204042303510.7035@chino.kir.corp.google.com>
References: <1333475906.7439.7.camel@marge.simpson.net>
	 <alpine.DEB.2.00.1204040008040.5356@chino.kir.corp.google.com>
	 <1333535915.7188.18.camel@marge.simpson.net>
	 <alpine.DEB.2.00.1204040419450.23137@chino.kir.corp.google.com>
	 <1333542649.7188.40.camel@marge.simpson.net>
	 <alpine.DEB.2.00.1204041414220.26086@chino.kir.corp.google.com>
	 <20120404230922.GC2173@dhcp-172-17-108-109.mtv.corp.google.com>
	 <1333601231.7783.31.camel@marge.simpson.net>
	 <alpine.DEB.2.00.1204042157530.31186@chino.kir.corp.google.com>
	 <1333604949.7783.76.camel@marge.simpson.net>
	 <alpine.DEB.2.00.1204042303510.7035@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-04 at 23:07 -0700, David Rientjes wrote: 
> On Thu, 5 Apr 2012, Mike Galbraith wrote:
> 
> > I submitted that, and it didn't fly.  I like the generic exclusion
> > better, so I submit that for consideration.
> > 
> 
> [+akpm]
> 
> The last time we went through this, it was left after Andrew had fixed it 
> up when the cpusets version was merged in -mm without any disagreement 
> from Peter who was cc'd and that version was acked both by myself and Paul 
> Menage at https://lkml.org/lkml/2011/12/14/402.  Andrew dropped it and 
> asked for a repost since there was some on-going scheduler work going on 
> in linux-next that caused that version not to apply.  No follow-up was 
> ever offered.

Hm, I thought I did that.

> Why have we now gone in a completely different direction again?

I already said that after Peter griped and suggested global, I thought
about it, and liked that better.  The submitted patchlet can either fly
or die.  It's not a big deal.

If I need a reason to like global better, posix like: the user shall not
fool around with my "mom" vs a wishy washy comedy variant of same ;-)

-Mike

