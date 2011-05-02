Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab1EBRyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 13:54:16 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:54106 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab1EBRyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 13:54:13 -0400
X-Originating-IP: 217.70.178.134
X-Originating-IP: 50.43.15.19
Date: Mon, 2 May 2011 10:53:57 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 11/86] rcu: Add boosting to TREE_PREEMPT_RCU
 tracing
Message-ID: <20110502175357.GE24574@feather>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
 <1304256126-26015-11-git-send-email-paulmck@linux.vnet.ibm.com>
 <20110501155225.GF14829@feather>
 <20110502082711.GW2297@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110502082711.GW2297@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 01:27:11AM -0700, Paul E. McKenney wrote:
> On Sun, May 01, 2011 at 08:52:25AM -0700, Josh Triplett wrote:
> > On Sun, May 01, 2011 at 06:20:51AM -0700, Paul E. McKenney wrote:
> > > From: Paul E. McKenney <paul.mckenney@linaro.org>
> > > 
> > > Includes total number of tasks boosted, number boosted on behalf of each
> > > of normal and expedited grace periods, and statistics on attempts to
> > > initiate boosting that failed for various reasons.
> > 
> > In this patch series, you have several cases where you improve the trace
> > output in one patch, and then update the documentation in a subsequent
> > patch.  You might consider doing both in the same patch, so that at each
> > step the documentation matches the kernel.
> 
> The reason I do the documentation second is that it allows me to copy
> the exact output from a test run, which has the nice side-effect of
> making sure that I really am getting the documentation correct.  Or at
> least of reducing the probability of getting it wrong...  ;-)

I definitely agree that you should copy the output from a test run to
make the documentation accurate; I just mean that once you do so, you
should put both the code changes and corresponding documentation into a
single commit.

- Josh Triplett
