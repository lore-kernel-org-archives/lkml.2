Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab2DEFtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 01:49:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58585 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab2DEFtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 01:49:13 -0400
Message-ID: <1333604949.7783.76.camel@marge.simpson.net>
Subject: Re: [patch] cgroups: disallow attaching kthreadd
From: Mike Galbraith <mgalbraith@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Date: Thu, 05 Apr 2012 07:49:09 +0200
In-Reply-To: <alpine.DEB.2.00.1204042157530.31186@chino.kir.corp.google.com>
References: <1333475906.7439.7.camel@marge.simpson.net>
	 <alpine.DEB.2.00.1204040008040.5356@chino.kir.corp.google.com>
	 <1333535915.7188.18.camel@marge.simpson.net>
	 <alpine.DEB.2.00.1204040419450.23137@chino.kir.corp.google.com>
	 <1333542649.7188.40.camel@marge.simpson.net>
	 <alpine.DEB.2.00.1204041414220.26086@chino.kir.corp.google.com>
	 <20120404230922.GC2173@dhcp-172-17-108-109.mtv.corp.google.com>
	 <1333601231.7783.31.camel@marge.simpson.net>
	 <alpine.DEB.2.00.1204042157530.31186@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-04 at 21:58 -0700, David Rientjes wrote: 
> On Thu, 5 Apr 2012, Mike Galbraith wrote:
> 
> > Below is user interface only patchlet.  I find it cleaner than the
> > cpuset,cpu variant, but don't have strong feelings either way.
> > 
> > If this one don't fly, I'll just declare buglet immortal, he ain't worth
> > near the electrons he's already wasted ;-) 
> > 
> 
> Why can't you simply propose the cpusets version that both Paul and I 
> liked?  There's _no_ reason to do this for every cgroup, current or 
> future.

I submitted that, and it didn't fly.  I like the generic exclusion
better, so I submit that for consideration.

>From my POV, the problem is known, decision makers can decide any way
they want, but _I_ have posted my last variant.  If this one doesn't
fly, too bad for patchlet, it's not the first one to ever go splat :)

-Mike


