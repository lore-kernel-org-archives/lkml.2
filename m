Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161149Ab2CORDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:03:52 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:54008 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161086Ab2CORDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:03:48 -0400
Date: Thu, 15 Mar 2012 10:02:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Dimitri Sivanich <sivanich@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] rcu: Limit GP initialization to CPUs that have been
 online
Message-ID: <20120315170236.GF2381@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120314002414.GA21561@linux.vnet.ibm.com>
 <1331717099.5752.15.camel@marge.simpson.net>
 <1331728841.7465.7.camel@marge.simpson.net>
 <20120314130801.GA11722@sgi.com>
 <20120314151717.GA2435@linux.vnet.ibm.com>
 <20120314165657.GA19117@linux.vnet.ibm.com>
 <1331779343.14263.6.camel@marge.simpson.net>
 <1331780831.14263.15.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331780831.14263.15.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12031517-5518-0000-0000-000002FA02E1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 04:07:11AM +0100, Mike Galbraith wrote:
> On Thu, 2012-03-15 at 03:42 +0100, Mike Galbraith wrote: 
> > On Wed, 2012-03-14 at 09:56 -0700, Paul E. McKenney wrote:
> > 
> > > Does the following work better?  It does pass my fake-big-system tests
> > > (more testing in the works).
> > 
> > Yup, tip booted fine.  Thanks!  I'll test, see if it gets upset.
> 
> Wedged into 3.0 enterprise booted fine too, is now running rcutorture.
> I'll add hotplug after it runs explosion free for a while.  Any
> suggestions for giving both virgin and 3.0 a thorough trouncing?

It would be good to check the latency of RCU's grace-period
initialization, and comparing the results with and without this patch.
Dimitri might have scripting for that.

							Thanx, Paul

