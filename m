Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab1IZXRH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 19:17:07 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54860 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab1IZXRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 19:17:05 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6481"; a="121607750"
Date: Mon, 26 Sep 2011 16:17:02 -0700
From: David Brown <davidb@codeaurora.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Greg KH <greg@kroah.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Bart Van Assche <bvanassche@acm.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Aug 24 (dynamic_debug)
Message-ID: <20110926231702.GA16827@huya.qualcomm.com>
References: <20110824160404.ebad6370aee2cad82a990142@canb.auug.org.au>
 <20110824102551.8fc076b5.rdunlap@xenotime.net>
 <20110824193244.GA2540@redhat.com>
 <20110824124248.13aa3ed4.rdunlap@xenotime.net>
 <20110824210902.GA9648@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110824210902.GA9648@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 02:09:02PM -0700, Greg KH wrote:
> On Wed, Aug 24, 2011 at 12:42:48PM -0700, Randy Dunlap wrote:
> > On Wed, 24 Aug 2011 15:32:45 -0400 Jason Baron wrote:
> > 
> > > On Wed, Aug 24, 2011 at 10:25:51AM -0700, Randy Dunlap wrote:
> > > > On Wed, 24 Aug 2011 16:04:04 +1000 Stephen Rothwell wrote:
> > > > 
> > > > > Hi all,
> > > > 
> > > > When CONFIG_NET is not enabled (I see this on i386 builds):
> > > > 
> > > > lib/built-in.o: In function `__dynamic_netdev_dbg':
> > > > (.text+0x9fda): undefined reference to `__netdev_printk'
> > > > 
> > > > ---
> > > > ~Randy
> > > > *** Remember to use Documentation/SubmitChecklist when testing your code ***
> > > 
> > > Ok, we probably want something, like below, although something keeps
> > > selecting CONFIG_NET, when I try to unset it, in my .config...so not yet
> > > tested, but should work.
> > 
> > Yes, that works.  Thanks.
> > 
> > Acked-by: Randy Dunlap <rdunlap@xenotime.net>
> 
> Nice.
> 
> Jason, care to resend this, with a proper signed-off-by, so that I can
> apply it to fix this build error?

Any status on this, Jason?  This seems to still be broken in
linux-next.

Thanks,
David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
