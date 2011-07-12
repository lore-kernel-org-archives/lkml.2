Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab1GLUFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 16:05:45 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:35688 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679Ab1GLUFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 16:05:44 -0400
Date: Tue, 12 Jul 2011 13:05:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        julie Sullivan <kernelmail.jms@gmail.com>,
        linux-kernel@vger.kernel.org, chengxu@linux.vnet.ibm.com
Subject: Re: PROBLEM: 3.0-rc kernels unbootable since -rc3
Message-ID: <20110712200515.GK2326@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110711201508.GN2245@linux.vnet.ibm.com>
 <20110711210954.GA15745@dumpdata.com>
 <20110712105506.GB2253@linux.vnet.ibm.com>
 <20110712141228.GA7831@dumpdata.com>
 <20110712144936.GD2326@linux.vnet.ibm.com>
 <20110712160324.GA1186@dumpdata.com>
 <20110712163947.GF2326@linux.vnet.ibm.com>
 <20110712180151.GA18257@dumpdata.com>
 <20110712185907.GJ2326@linux.vnet.ibm.com>
 <1310497836.14978.34.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310497836.14978.34.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 09:10:36PM +0200, Peter Zijlstra wrote:
> On Tue, 2011-07-12 at 11:59 -0700, Paul E. McKenney wrote:
> > OK, so the infinite loop in task_waking_fair() happens even if RCU callbacks
> > are deferred until after the scheduler is fully initialized.  Sounds like
> > one for the scheduler guys.  ;-) 
> 
> https://lkml.org/lkml/2011/7/12/150
> 
> ?

Looks like that would do the trick, thank you Peter!

Konrad, Julie, Ravi, could you please try out Peter's patch?

							Thanx, Paul
