Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab2GIJPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 05:15:24 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49546 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab2GIJPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 05:15:23 -0400
Date: Mon, 9 Jul 2012 11:15:17 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [PATCH 03/16] sched: aggregate load contributed by task entities
 on parenting cfs_rq
Message-ID: <20120709091517.GC2901@gmail.com>
References: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
 <20120628022414.30496.73426.stgit@kitami.mtv.corp.google.com>
 <1341415726.19870.0.camel@laptop>
 <1341586388.7709.51.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341586388.7709.51.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2012-07-04 at 17:28 +0200, Peter Zijlstra wrote:
> > On Wed, 2012-06-27 at 19:24 -0700, Paul Turner wrote:
> > > For a given task t, we can compute its contribution to load as:
> > >   task_load(t) = runnable_avg(t) * weight(t)
> > > 
> > > On a parenting cfs_rq we can then aggregate
> > >   runnable_load(cfs_rq) = \Sum task_load(t), for all runnable children t
> > > 
> > > Maintain this bottom up, with task entities adding their contributed load to
> > > the parenting cfs_rq sum.  When a task entities load changes we add the same
> > > delta to the maintained sum.
> > > 
> > > Signed-off-by: Paul Turner <pjt@google.com>
> > > Signed-off-by: Ben Segall <bsegall@google.com> 
> > 
> > A lot of patches have this funny sob trail.. Ben never send me these
> > patches, so uhm. ?
> > 
> > Should that be Reviewed-by, or what is the deal with those?
> 
> Ben could you clarify what your exact contribution was?
> 
> Ingo, supposing Ben is co-author and wrote a significant part 
> of the patch, what are we supposed to do with these tags?

There can be only one author SOB - additional contributions 
should be reflected via credits in the changelog, copyright 
lines and/or Originally-From: tags, or so.

Thanks,

	Ingo
