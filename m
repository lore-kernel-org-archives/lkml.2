Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab1BPWAK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:00:10 -0500
Received: from kroah.org ([198.145.64.141]:55279 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754843Ab1BPWAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:00:04 -0500
Date: Wed, 16 Feb 2011 13:40:17 -0800
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@suse.de>, stable@kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Larry.Finger@lwfinger.net
Subject: Re: [stable] [Stable-review] [39/45] OHCI: work around for nVidia
 shutdown problem
Message-ID: <20110216214017.GE5027@kroah.com>
References: <20101122175523.GA18867@suse.de>
 <Pine.LNX.4.44L0.1101061531330.4414-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1101061531330.4414-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 11:51:59AM -0500, Alan Stern wrote:
> On Mon, 22 Nov 2010, Greg KH wrote:
> 
> > On Sat, Nov 20, 2010 at 11:51:39AM -0500, Alan Stern wrote:
> > > On Sat, 20 Nov 2010, Ben Hutchings wrote:
> ...
> > > > This last bit seems like a major change in behaviour, and this commit
> > > > has only just gone into the 2.6.37 cycle.  How thoroughly has this been
> > > > tested on other OHCI controllers?  Wouldn't it make more sense to use
> > > > the same quirk condition?
> > > 
> > > Ben is right; let's hold off on putting this patch into any of the 
> > > stable kernels.  There has been a bug report submitted against it, 
> > > Bugzilla #22562.
> > 
> > Good point, I'll go drop it.
> > 
> > Alan, when it all gets worked out, care to resend it to
> > stable@kernel.org?
> 
> Okay, I'm resending it now that 2.6.37 has been out for a couple of
> weeks.  The Bugzilla report has been resolved; apparently the problem
> was a hardware issue in one particular computer and not a fault of the
> patch.  Go ahead and add this to the stable kernels.

Ok, now added to the .32 stable queue.

thanks,

greg k-h
