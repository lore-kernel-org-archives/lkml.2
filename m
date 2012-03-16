Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965467Ab2CPIJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 04:09:53 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:60993 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S964807Ab2CPIJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 04:09:48 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/CyEQ1fDDCuM6mJXICvdljYYqJepGI3w+GO9XlNc
	0zgivV+WId6PIw
Message-ID: <1331885384.11010.15.camel@marge.simpson.net>
Subject: Re: [PATCH RFC] rcu: Limit GP initialization to CPUs that have been
 online
From: Mike Galbraith <efault@gmx.de>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Date: Fri, 16 Mar 2012 09:09:44 +0100
In-Reply-To: <1331882861.11010.13.camel@marge.simpson.net>
References: <20120314002414.GA21561@linux.vnet.ibm.com>
	 <1331717099.5752.15.camel@marge.simpson.net>
	 <1331728841.7465.7.camel@marge.simpson.net>
	 <20120314130801.GA11722@sgi.com> <20120314151717.GA2435@linux.vnet.ibm.com>
	 <20120314165657.GA19117@linux.vnet.ibm.com>
	 <1331779343.14263.6.camel@marge.simpson.net>
	 <1331780831.14263.15.camel@marge.simpson.net>
	 <20120315175933.GB8705@sgi.com>
	 <1331882861.11010.13.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-16 at 08:27 +0100, Mike Galbraith wrote: 
> On Thu, 2012-03-15 at 12:59 -0500, Dimitri Sivanich wrote: 
> > On Thu, Mar 15, 2012 at 04:07:11AM +0100, Mike Galbraith wrote:
> > > On Thu, 2012-03-15 at 03:42 +0100, Mike Galbraith wrote: 
> > > > On Wed, 2012-03-14 at 09:56 -0700, Paul E. McKenney wrote:
> > > > 
> > > > > Does the following work better?  It does pass my fake-big-system tests
> > > > > (more testing in the works).
> > > > 
> > > > Yup, tip booted fine.  Thanks!  I'll test, see if it gets upset.
> > > 
> > > Wedged into 3.0 enterprise booted fine too, is now running rcutorture.
> > > I'll add hotplug after it runs explosion free for a while.  Any
> > > suggestions for giving both virgin and 3.0 a thorough trouncing?
> > 
> > Mike,
> > 
> > Could I try your 3.0 enterprise patch?
> 
> Sure, v3 below.

Erm, a bit of that went missing.  I'll put it back.

-Mike

