Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab2H3XXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 19:23:16 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:46249 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab2H3XWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 19:22:25 -0400
X-Originating-IP: 217.70.178.133
X-Originating-IP: 173.246.103.110
Date: Thu, 30 Aug 2012 16:22:16 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: git@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 0/5] Documentation and rcutorture changes
Message-ID: <20120830232216.GC11928@jtriplet-mobl1>
References: <20120830184448.GA31753@linux.vnet.ibm.com>
 <20120830185608.GA6749@jtriplet-mobl1>
 <20120830214603.GJ30381@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120830214603.GJ30381@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 02:46:03PM -0700, Paul E. McKenney wrote:
> On Thu, Aug 30, 2012 at 11:56:09AM -0700, Josh Triplett wrote:
> > On Thu, Aug 30, 2012 at 11:44:48AM -0700, Paul E. McKenney wrote:
> > > Hello!
> > > 
> > > This series covers changes to rcutorture and documentation updates.
> > > The individual patches in this series are as follows:
> > > 
> > > 1.	Update rcutorture default values so that casual rcutorture
> > > 	users will do more aggressive testing.
> > > 2.	Make rcutorture track CPU-hotplug latency statistics.
> > > 3.	Document SRCU's new-found ability to be used by offline and
> > > 	idle CPUs, and also emphasize SRCU's limitations.
> > > 4.	Use the new pr_*() interfaces in rcutorture.
> > > 5.	Prevent kthread-initialization races in rcutorture.
> > > 
> > > 							Thanx, Paul
> > > 
> > > ------------------------------------------------------------------------
> > > 
> > >  b/Documentation/RCU/checklist.txt |    6 +
> > >  b/Documentation/RCU/whatisRCU.txt |    9 +-
> > >  b/kernel/rcutorture.c             |    4 -
> > >  kernel/rcutorture.c               |  152 +++++++++++++++++++++++---------------
> > >  4 files changed, 108 insertions(+), 63 deletions(-)
> > 
> > Something seems wrong with this diffstat; how'd the b/ prefixes get
> > there, and why does it list kernel/rcutorture.c twice, once with and
> > once without?
> 
> Hmmm...  It seems quite reproducible.  I did the usual git-format-patch
> and ran the resulting set of patches through diffstat.  I seem to have a
> broken diffstat...
> 
> However, git diff --stat v3.6-rc1..hotplug.2012.08.28a generates the
> following:
> 
>  kernel/rcutree.c       |   93 +++++++++++-------------------------------------
>  kernel/rcutree.h       |    3 --
>  kernel/rcutree_trace.c |    4 +-
>  kernel/sched/core.c    |   41 ++++++++++-----------
>  4 files changed, 43 insertions(+), 98 deletions(-)
> 
> Which does look much better.

You might try generating your cover letter template via git format-patch
--cover-letter, which will automatically give you a list of patches and
a git-produced diffstat; much easier than trying to format a cover
letter by hand.  Meanwhile, you might consider sending your patches as a
bug report to diffstat upstream: Thomas E. Dickey
<dickey@invisible-island.net>.

- Josh Triplett
