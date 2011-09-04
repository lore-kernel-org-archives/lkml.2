Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab1IDThM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 15:37:12 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53245 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152Ab1IDThI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 15:37:08 -0400
Date: Sun, 4 Sep 2011 12:37:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 05/32] nohz: Move rcu dynticks idle mode handling to
 idle enter/exit APIs
Message-ID: <20110904193703.GA9775@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110830153343.GW9748@somewhere.redhat.com>
 <1314737918.19586.8.camel@twins>
 <20110830222432.GD15953@somewhere.redhat.com>
 <1314782245.23993.9.camel@twins>
 <20110831133754.GA20598@somewhere>
 <1314801660.3578.41.camel@twins>
 <20110901164040.GC2286@linux.vnet.ibm.com>
 <1314897180.1485.12.camel@twins>
 <20110902014101.GA2405@linux.vnet.ibm.com>
 <1314951871.1301.2.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314951871.1301.2.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 10:24:31AM +0200, Peter Zijlstra wrote:
> On Thu, 2011-09-01 at 18:41 -0700, Paul E. McKenney wrote:
> > > Now we could possibly add magic to rcu_read_unlock_special() to restart
> > > the tick in that case.
> > 
> > Not from NMI handlers we can't.  Unless I am really confused about the
> > code that restarts the tick.  Which is not impossible, but ... 
> 
> Uhm.. good point ;-) yes that will be somewhat detrimental to the
> overall OS health if we attempt such a thing.

But if you don't mind, I would very much like to use your question as
a Quick Quiz.  It should be a good one.  ;-)

							Thanx, Paul
