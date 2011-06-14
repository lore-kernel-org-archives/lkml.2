Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab1FNPcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 11:32:22 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:36442 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278Ab1FNPcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 11:32:17 -0400
Date: Tue, 14 Jun 2011 08:32:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Alex,Shi" <alex.shi@intel.com>, "Li, Shaohua" <shaohua.li@intel.com>,
        Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>, rostedt@goodmis.org
Subject: Re: rcu: performance regression
Message-ID: <20110614153213.GE2288@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1308029185.15392.147.camel@sli10-conroe>
 <1308040388.21027.1847.camel@debian>
 <20110614130203.GF2264@linux.vnet.ibm.com>
 <1308057298.19856.40.camel@twins>
 <1308057522.19856.41.camel@twins>
 <20110614150155.GC2288@linux.vnet.ibm.com>
 <1308064225.19856.76.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308064225.19856.76.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 05:10:25PM +0200, Peter Zijlstra wrote:
> On Tue, 2011-06-14 at 08:01 -0700, Paul E. McKenney wrote:
> > Hmmm...  This is going to be fun for the -rt guys given the mapping of
> > softirq and irq to kthreads, but then again, perhaps people will
> > confine use of -rt to smaller systems. 
> 
> Its those -rt guys that wrote this stuff :-)

Fair point!  ;-)

							Thanx, Paul
