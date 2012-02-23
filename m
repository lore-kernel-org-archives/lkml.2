Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab2BWBCM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 20:02:12 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:41452 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab2BWBCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 20:02:10 -0500
Date: Wed, 22 Feb 2012 17:01:38 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH 2/3 RFC paul/rcu/srcu] srcu: only increase the upper bit
 for srcu_read_lock()
Message-ID: <20120223010138.GQ2416@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4F41F315.1040900@cn.fujitsu.com>
 <20120220174418.GI2470@linux.vnet.ibm.com>
 <4F42EF53.6060400@cn.fujitsu.com>
 <20120221015037.GE2384@linux.vnet.ibm.com>
 <4F435966.9020106@cn.fujitsu.com>
 <20120221172442.GG2375@linux.vnet.ibm.com>
 <4F44B57C.3020104@cn.fujitsu.com>
 <20120222212056.GJ2416@linux.vnet.ibm.com>
 <20120222212630.GA6759@linux.vnet.ibm.com>
 <1329946755.25686.120.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329946755.25686.120.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022301-7408-0000-0000-000002E24B9A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 04:39:15PM -0500, Steven Rostedt wrote:
> On Wed, 2012-02-22 at 13:26 -0800, Paul E. McKenney wrote:
> 
> > Make that without underflow -- one increment and 2^31+1 decrements would
> > in fact return the counter to its original value, but that would require
> > cramming more than two billion tasks into a 32-bit address space, which
> > I believe to be sufficiently unlikely.  (Famous last words...)
> 
> I'll just expect to see you as President of the United States, counting
> your money you won in the lottery, and being awarded a Nobel Prize for
> curing cancer.

Those possibilities also seem to me to be sufficiently unlikely.  ;-)

							Thanx, Paul

