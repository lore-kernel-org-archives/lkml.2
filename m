Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682Ab1EBWT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 18:19:29 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38274 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755221Ab1EBWT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 18:19:28 -0400
Date: Mon, 2 May 2011 15:19:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 17/86] rcu: fix boost-tracing bug and
 update tracing documentation
Message-ID: <20110502221919.GJ2294@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110501132142.GA25494@linux.vnet.ibm.com>
 <1304256126-26015-17-git-send-email-paulmck@linux.vnet.ibm.com>
 <20110501154310.GD14829@feather>
 <20110502083301.GY2297@linux.vnet.ibm.com>
 <20110502174442.GB24574@feather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110502174442.GB24574@feather>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 10:44:42AM -0700, Josh Triplett wrote:
> On Mon, May 02, 2011 at 01:33:01AM -0700, Paul E. McKenney wrote:
> > On Sun, May 01, 2011 at 08:43:10AM -0700, Josh Triplett wrote:
> > > Also, does rcu/rcutorture appear with rcutorture not loaded?  Hopefully
> > > not, since rcutorture shouldn't take up any additional resources when
> > > not loaded.
> > 
> > Not much choice, unfortunately.  If I put the info into rcutorture, then
> > I lose it when rcutorture is unloaded.  This is problematic in automated
> > tests that repeatedly load and unload rcutorture.
> > 
> > But the amount of data is small, and I set things up so that TINY_RCU
> > can omit this.  TREE_RCU is big enough that it doesn't really matter.
> 
> You could omit it entirely if CONFIG_RCU_TORTURE_TEST=n (rather than
> =m).

I could, but it doesn't seem worth it.  Of course, it might be just
the fact that I am writing this from the Toronto airport...

						Thanx, Paul
