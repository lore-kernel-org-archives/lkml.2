Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965891Ab2EPUWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 16:22:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37431 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965649Ab2EPUWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 16:22:39 -0400
Date: Wed, 16 May 2012 13:22:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: edwin_rong <edwin_rong@realsil.com.cn>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH] staging: update TODO files for rts5139 & rts_pstor
Message-ID: <20120516202230.GA20954@kroah.com>
References: <1337049392-8544-1-git-send-email-edwin_rong@realsil.com.cn>
 <20120515153931.GA25240@kroah.com>
 <4FB30DE9.8040406@realsil.com.cn>
 <20120516072028.GK16984@mwanda>
 <4FB36E89.80404@realsil.com.cn>
 <20120516101957.GJ16999@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120516101957.GJ16999@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 01:19:57PM +0300, Dan Carpenter wrote:
> On Wed, May 16, 2012 at 05:08:25PM +0800, edwin_rong wrote:
> > On 05/16/2012 03:20 PM, Dan Carpenter wrote:
> > > When is the new driver going to be released?  How can we tell if
> > > it's better than the cleaned up staging driver without seeing it?
> > >
> > > regards,
> > > dan carpenter
> > Hi Dan carpenter,
> > 
> > > When is the new driver going to be released?
> > 
> > I'm afraid it will take a long time before we release it to kernel. You
> > know that Realtek now has several series of card reader on the market, and
> > we have to integrated these ICs into the new driver, and make sure it
> > works well, in addition, now we're working on another new card reader IC.
> > Once everything is done, the driver will be released.
> > 
> > >  How can we tell if it's better than the cleaned up staging driver without seeing it?
> > Yes, quite right. Seeing is believing.
> > 
> 
> This seems like we're going down the broadcom model where we have
> the b34_legacy, b43, brcm drivers.  We've got three drivers for
> broadcom cards and there is some overlap on which hardware they
> support.  The first two were developed by the community and the brcm
> driver was developed by Broadcom and it's the only one they support.
> It was a frustrating experience.  We came very close to dropping the
> brcm drivers.
> 
> The thing about the brcm drivers was that the Broadcom devs did all
> their development in the open.  We knew they had worked hard and
> were responsive to bug reports and code criticism.
> 
> The kernel history is full of people working hard for years on code
> and then having it rejected and not merged.  When it comes to
> drivers we often think we'll write a new driver and drop the old one
> but it doesn't always happen.  We still have OSS sound drivers from
> 90s.
> 
> It's best to put up a git tree with the new driver as soon as
> possible.  I would try get stuff merged into the kernel as soon as
> possible.

I agree, you need to post code, even if it's not quite working, or
finished, as soon as possible.  Don't expect to wait until you are all
finished, and drop a whole new driver subsystem on us and think that it
will be instantly accepted.  It takes review time, and when you are
creating a whole new way to handle this hardware, it will take a few
tries to get it all correct.

So please, post code now, if possible.  But in the mean time, users will
continue to use this staging driver, as that is all that they have, so I
will not reject patches fixing and cleaning it up, as we really have no
way of knowing if anything else will ever end up in the kernel tree,
right?

thanks,

greg k-h
