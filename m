Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab1EVUNN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 16:13:13 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:48822 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791Ab1EVUNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 16:13:06 -0400
Date: Sun, 22 May 2011 13:13:02 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Mysterious CFQ crash and RCU
Message-ID: <20110522201302.GM2271@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110519222404.GG12600@redhat.com>
 <20110521210013.GJ2271@linux.vnet.ibm.com>
 <1306016630.2066.44.camel@x61.thuisdomein>
 <20110521235408.GK2271@linux.vnet.ibm.com>
 <1306092657.2066.53.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306092657.2066.53.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 22, 2011 at 09:30:57PM +0200, Paul Bolle wrote:
> On Sat, 2011-05-21 at 16:54 -0700, Paul E. McKenney wrote:
> > On Sun, May 22, 2011 at 12:23:50AM +0200, Paul Bolle wrote: 
> > > Is anyone able to spot one or more commits in v2.6.39-rc7..v2.6.39 that
> > > might have fixed this Oops? Or did my chance of hitting this Oops,
> > > somehow, just got a lot smaller in v.2.6.39?
> 
> As I just discovered, Fedora Rawhide ships release candidates configured
> with a lot more debugging options set than it ships final releases. So,
> sadly, this didn't get fixed in v2.6.39. It just didn't show up because
> one or more configuration options weren't set while they used to be set
> in the preceding release candidates kernels.
> 
> > 5f45c69589b7d ("read_lock() does not always imply rcu_read_lock()") might
> > well be a fix.
> 
> It doesn't really matter anymore, but that one was actually already
> included in v2.6.39-rc5.

OK, so maybe time to try out the debug approaches I called out earlier?

							Thanx, Paul
