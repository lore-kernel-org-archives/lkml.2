Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809Ab1EBKw7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 06:52:59 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:34609 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755358Ab1EBKw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 06:52:56 -0400
Date: Mon, 2 May 2011 03:52:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 18/86] rcu: add grace-period age to tracing
Message-ID: <20110502105243.GE2297@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110501132142.GA25494@linux.vnet.ibm.com>
 <1304256126-26015-18-git-send-email-paulmck@linux.vnet.ibm.com>
 <20110501152509.GB14829@feather>
 <20110502083407.GZ2297@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110502083407.GZ2297@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 01:34:07AM -0700, Paul E. McKenney wrote:
> On Sun, May 01, 2011 at 08:25:09AM -0700, Josh Triplett wrote:
> > On Sun, May 01, 2011 at 06:20:58AM -0700, Paul E. McKenney wrote:
> > > From: Paul E. McKenney <paul.mckenney@linaro.org>
> > > 
> > > This commit adds the age in jiffies of the current grace period along
> > > with the duration in jiffies of the longest grace period since boot
> > > to the rcu/rcugp debugfs file.
> > 
> > This change seems to have several other unrelated changes mixed in and
> > not documented, related to adding and tracing RCU_KTHREAD_OFFCPU.
> 
> Hmmm...  I do have two commits worth of stuff in there, don't I?
> 
> Good catch, will fix!

But after reviewing again, it looks like the best fix is to make the
commit log better reflect what is happening.  All the changes are adding
more tracing, so no need to split the commit.  After all, it is not like
this series is particularly short on commits...  ;-)

							Thanx, Paul
