Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab1I0N12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 09:27:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485Ab1I0N10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 09:27:26 -0400
Date: Tue, 27 Sep 2011 09:27:18 -0400
From: Jason Baron <jbaron@redhat.com>
To: David Brown <davidb@codeaurora.org>, akpm@linux-foundation.org
Cc: Randy Dunlap <rdunlap@xenotime.net>, Greg KH <greg@kroah.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Bart Van Assche <bvanassche@acm.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Aug 24 (dynamic_debug)
Message-ID: <20110927132718.GA2533@redhat.com>
References: <20110824160404.ebad6370aee2cad82a990142@canb.auug.org.au>
 <20110824102551.8fc076b5.rdunlap@xenotime.net>
 <20110824193244.GA2540@redhat.com>
 <20110824124248.13aa3ed4.rdunlap@xenotime.net>
 <20110824210902.GA9648@kroah.com>
 <20110926231702.GA16827@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110926231702.GA16827@huya.qualcomm.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 04:17:02PM -0700, David Brown wrote:
> On Wed, Aug 24, 2011 at 02:09:02PM -0700, Greg KH wrote:
> > On Wed, Aug 24, 2011 at 12:42:48PM -0700, Randy Dunlap wrote:
> > > On Wed, 24 Aug 2011 15:32:45 -0400 Jason Baron wrote:
> > > 
> > > > On Wed, Aug 24, 2011 at 10:25:51AM -0700, Randy Dunlap wrote:
> > > > > On Wed, 24 Aug 2011 16:04:04 +1000 Stephen Rothwell wrote:
> > > > > 
> > > > > > Hi all,
> > > > > 
> > > > > When CONFIG_NET is not enabled (I see this on i386 builds):
> > > > > 
> > > > > lib/built-in.o: In function `__dynamic_netdev_dbg':
> > > > > (.text+0x9fda): undefined reference to `__netdev_printk'
> > > > > 
> > > > > ---
> > > > > ~Randy
> > > > > *** Remember to use Documentation/SubmitChecklist when testing your code ***
> > > > 
> > > > Ok, we probably want something, like below, although something keeps
> > > > selecting CONFIG_NET, when I try to unset it, in my .config...so not yet
> > > > tested, but should work.
> > > 
> > > Yes, that works.  Thanks.
> > > 
> > > Acked-by: Randy Dunlap <rdunlap@xenotime.net>
> > 
> > Nice.
> > 
> > Jason, care to resend this, with a proper signed-off-by, so that I can
> > apply it to fix this build error?
> 
> Any status on this, Jason?  This seems to still be broken in
> linux-next.
> 
> Thanks,
> David
> 

Yes, this needs to be resolved asap. I'm sending this to Andrew Morton 
b/c these patches have been merged in the -mm tree. I'm guessing
that b/c of the kernel.org outage they aren't showing up in -next? Since
this has dragged on and on, perhaps, those patches can be moved
somewhere else so they can be pulled into -next. Andrew?

Thanks,

-Jason
