Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab2CNPYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 11:24:00 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:40876 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab2CNPX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 11:23:58 -0400
Date: Wed, 14 Mar 2012 08:17:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] rcu: Limit GP initialization to CPUs that have been
 online
Message-ID: <20120314151717.GA2435@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120314002414.GA21561@linux.vnet.ibm.com>
 <1331717099.5752.15.camel@marge.simpson.net>
 <1331728841.7465.7.camel@marge.simpson.net>
 <20120314130801.GA11722@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120314130801.GA11722@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12031415-3352-0000-0000-00000350F0B5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 08:08:01AM -0500, Dimitri Sivanich wrote:
> On Wed, Mar 14, 2012 at 01:40:41PM +0100, Mike Galbraith wrote:
> > On Wed, 2012-03-14 at 10:24 +0100, Mike Galbraith wrote: 
> > > On Tue, 2012-03-13 at 17:24 -0700, Paul E. McKenney wrote: 
> > > > The following builds, but is only very lightly tested.  Probably full
> > > > of bug, especially when exercising CPU hotplug.
> > > 
> > > You didn't say RFT, but...
> > > 
> > > To beat on this in a rotund 3.0 kernel, the equivalent patch would be
> > > the below?  My box may well answer that before you can.. hope not ;-)
> > 
> > (Darn, it did.  Box says boot stall with virgin patch in tip too though.
> > Wedging it straight into 3.0 was perhaps a tad premature;)
> 
> I saw the same thing with 3.3.0-rc7+ and virgin patch on UV.  Boots fine without the patch.

Right...  Bozo here forgot to set the kernel parameters for large-system
emulation during testing.  Apologies for the busted patch, will fix.

And thank you both for the testing!!!

Hey, at least I labeled it "RFC".  ;-)

							Thanx, Paul

