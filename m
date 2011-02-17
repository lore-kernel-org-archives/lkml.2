Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab1BQIRr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 03:17:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34007 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170Ab1BQIRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 03:17:45 -0500
Date: Thu, 17 Feb 2011 09:17:41 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Greg Thelen <gthelen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: clarify use_hierarchy documentation
In-Reply-To: <20110217104932.9e2c741b.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.LNX.2.00.1102170917320.2160@pobox.suse.cz>
References: <1297907483-3672-1-git-send-email-gthelen@google.com> <20110217104932.9e2c741b.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Feb 2011, KAMEZAWA Hiroyuki wrote:

> On Wed, 16 Feb 2011 17:51:23 -0800
> Greg Thelen <gthelen@google.com> wrote:
> 
> > The memcg code does not allow changing memory.use_hierarchy if the
> > parent cgroup has enabled use_hierarchy.  Update documentation to match
> > the code.
> > 
> > Signed-off-by: Greg Thelen <gthelen@google.com>
> 
> Thank you,
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Applied, thanks.

> 
> Because I tend to read linux-mm list 1st, I'm glad if you CC linux-mm in
> the next time.
> 
> > ---
> >  Documentation/cgroups/memory.txt |    5 +++--
> >  1 files changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
> > index 7781857..b6ed61c 100644
> > --- a/Documentation/cgroups/memory.txt
> > +++ b/Documentation/cgroups/memory.txt
> > @@ -485,8 +485,9 @@ The feature can be disabled by
> >  
> >  # echo 0 > memory.use_hierarchy
> >  
> > -NOTE1: Enabling/disabling will fail if the cgroup already has other
> > -       cgroups created below it.
> > +NOTE1: Enabling/disabling will fail if either the cgroup already has other
> > +       cgroups created below it, or if the parent cgroup has use_hierarchy
> > +       enabled.
> >  
> >  NOTE2: When panic_on_oom is set to "2", the whole system will panic in
> >         case of an OOM event in any cgroup.
> > -- 
> > 1.7.3.1
> > 
> > 
> 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
