Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab2CPEpe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 00:45:34 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:37424 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750908Ab2CPEpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 00:45:33 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18XSaJWHNcXNY44rsexRADIIOcHr4QZup0vlZeD7+
	7ejZLBDILdp9UE
Message-ID: <1331873113.7399.19.camel@marge.simpson.net>
Subject: Re: [PATCH RFC] rcu: Limit GP initialization to CPUs that have been
 online
From: Mike Galbraith <efault@gmx.de>
To: paulmck@linux.vnet.ibm.com
Cc: Dimitri Sivanich <sivanich@sgi.com>, linux-kernel@vger.kernel.org
Date: Fri, 16 Mar 2012 05:45:13 +0100
In-Reply-To: <20120315170236.GF2381@linux.vnet.ibm.com>
References: <20120314002414.GA21561@linux.vnet.ibm.com>
	 <1331717099.5752.15.camel@marge.simpson.net>
	 <1331728841.7465.7.camel@marge.simpson.net>
	 <20120314130801.GA11722@sgi.com> <20120314151717.GA2435@linux.vnet.ibm.com>
	 <20120314165657.GA19117@linux.vnet.ibm.com>
	 <1331779343.14263.6.camel@marge.simpson.net>
	 <1331780831.14263.15.camel@marge.simpson.net>
	 <20120315170236.GF2381@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-15 at 10:02 -0700, Paul E. McKenney wrote: 
> On Thu, Mar 15, 2012 at 04:07:11AM +0100, Mike Galbraith wrote:
> > On Thu, 2012-03-15 at 03:42 +0100, Mike Galbraith wrote: 
> > > On Wed, 2012-03-14 at 09:56 -0700, Paul E. McKenney wrote:
> > > 
> > > > Does the following work better?  It does pass my fake-big-system tests
> > > > (more testing in the works).
> > > 
> > > Yup, tip booted fine.  Thanks!  I'll test, see if it gets upset.
> > 
> > Wedged into 3.0 enterprise booted fine too, is now running rcutorture.
> > I'll add hotplug after it runs explosion free for a while.  Any
> > suggestions for giving both virgin and 3.0 a thorough trouncing?
> 
> It would be good to check the latency of RCU's grace-period
> initialization, and comparing the results with and without this patch.
> Dimitri might have scripting for that.

Yeah, I'll zoom in.  Generic irqsoff tracing with rcutorture running
was... not the cleverest of ideas.  (between fbcon and serial console, a
300us RCU blip would be a pimple on giants left butt cheek)

-Mike

