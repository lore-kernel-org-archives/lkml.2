Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab1HJBIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 21:08:40 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:35812 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841Ab1HJBIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 21:08:39 -0400
Date: Tue, 9 Aug 2011 18:08:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.0.1-rt8
Message-ID: <20110810010837.GC2737@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1312580681.28695.44.camel@twins>
 <4E417D12.70608@localhost>
 <1312915646.1083.79.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312915646.1083.79.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, 2011 at 08:47:26PM +0200, Peter Zijlstra wrote:
> On Tue, 2011-08-09 at 11:31 -0700, Fernando Lopez-Lezcano wrote:
> > Hmmm, what are reasonable values for CONFIG_RCU_BOOST_PRIO and 
> > CONFIG_RCU_BOOST_DELAY? (or at least what are you using?).
> 
> I'm using the defaults, since I haven't actually got a workload besides
> compiling kernels ;-)
> 
> Changing these values is very much workload dependent, the PRIO should
> be high enough not to cause memory starvation, but low enough not to
> disrupt anything important, and thus completely dependent on you
> favourite RT workload.
> 
> The same goes for the DELAY, too long and you run out of memory, too
> short and you get more overhead, depends on your workload, your machine
> memory size etc..
> 
> Paul should of course be put on trial for giving us these knobs, but
> seeing where they come from I totally understand they exist ;-)

You mean my experience at the tail end of 3.0 -wasn't- being put
on trial?  ;-)

							Thanx, Paul
