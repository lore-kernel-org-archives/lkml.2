Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161192Ab2COR7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:59:35 -0400
Received: from relay2.sgi.com ([192.48.179.30]:49515 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031066Ab2COR7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:59:34 -0400
Date: Thu, 15 Mar 2012 12:59:33 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Mike Galbraith <efault@gmx.de>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] rcu: Limit GP initialization to CPUs that have
 been online
Message-ID: <20120315175933.GB8705@sgi.com>
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
User-Agent: Mutt/1.5.20 (2009-06-14)
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

Mike,

Could I try your 3.0 enterprise patch?
