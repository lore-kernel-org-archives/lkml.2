Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab1EBIeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 04:34:16 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:54458 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920Ab1EBIeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 04:34:15 -0400
Date: Mon, 2 May 2011 01:34:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 18/86] rcu: add grace-period age to tracing
Message-ID: <20110502083407.GZ2297@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110501132142.GA25494@linux.vnet.ibm.com>
 <1304256126-26015-18-git-send-email-paulmck@linux.vnet.ibm.com>
 <20110501152509.GB14829@feather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110501152509.GB14829@feather>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 01, 2011 at 08:25:09AM -0700, Josh Triplett wrote:
> On Sun, May 01, 2011 at 06:20:58AM -0700, Paul E. McKenney wrote:
> > From: Paul E. McKenney <paul.mckenney@linaro.org>
> > 
> > This commit adds the age in jiffies of the current grace period along
> > with the duration in jiffies of the longest grace period since boot
> > to the rcu/rcugp debugfs file.
> 
> This change seems to have several other unrelated changes mixed in and
> not documented, related to adding and tracing RCU_KTHREAD_OFFCPU.

Hmmm...  I do have two commits worth of stuff in there, don't I?

Good catch, will fix!

							Thanx, Paul
