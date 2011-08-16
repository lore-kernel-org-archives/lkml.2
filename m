Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab1HPTbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 15:31:35 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49476 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab1HPTbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 15:31:33 -0400
Date: Tue, 16 Aug 2011 12:31:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Nivedita Singhvi <niv@us.ibm.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.0.1-rt11
Message-ID: <20110816193128.GE2404@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1313232790.25267.7.camel@twins>
 <1313236135.4486.10.camel@marge.simson.net>
 <1313236713.25267.10.camel@twins>
 <1313243965.4486.36.camel@marge.simson.net>
 <20110813162735.GA2650@linux.vnet.ibm.com>
 <1313295821.6334.5.camel@marge.simson.net>
 <4E4A7BE3.5090902@us.ibm.com>
 <1313507408.6321.4.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313507408.6321.4.camel@marge.simson.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 05:10:08PM +0200, Mike Galbraith wrote:
> On Tue, 2011-08-16 at 07:17 -0700, Nivedita Singhvi wrote:
> 
> > Mike,
> > 
> > Which test were you running? Because I'm not seeing it
> > on our x3550 M3..
> 
> -rt11 did not trip up just idling along like a couple earlier releases
> did, but did stall when I tried to run ltp realtime testcases.

But please note that if your realtime workload is CPU-bound with prio
greater than that of RCU_SOFTIRQ, stalls would be expected.

							Thanx, Paul
