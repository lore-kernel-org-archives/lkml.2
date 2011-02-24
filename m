Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab1BXSOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 13:14:49 -0500
Received: from cantor.suse.de ([195.135.220.2]:55819 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566Ab1BXSOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 13:14:48 -0500
Date: Thu, 24 Feb 2011 10:12:46 -0800
From: Greg KH <gregkh@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Felipe Balbi <balbi@ti.com>, Alexander Holler <holler@ahsoftware.de>,
        Michael Jones <michael.jones@matrix-vision.de>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        USB list <linux-usb@vger.kernel.org>, linux-omap@vger.kernel.org
Subject: Re: [024/115] USB: prevent buggy hubs from crashing the USB stack
Message-ID: <20110224181246.GA10139@suse.de>
References: <20110224172327.GF3528@legolas.emea.dhcp.ti.com>
 <Pine.LNX.4.44L0.1102241255100.2084-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1102241255100.2084-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 12:57:20PM -0500, Alan Stern wrote:
> On Thu, 24 Feb 2011, Felipe Balbi wrote:
> 
> > On Thu, Feb 24, 2011 at 09:18:14AM -0800, Greg KH wrote:
> > > On Thu, Feb 24, 2011 at 11:16:38AM +0200, Felipe Balbi wrote:
> > > > Hi,
> > > > 
> > > > On Thu, Feb 24, 2011 at 10:15:23AM +0100, Alexander Holler wrote:
> > > > > >On Wed, Feb 23, 2011 at 10:26:20AM -0500, Alan Stern wrote:
> > > > > >>In both cases, it appears that the problem is caused by the fact that
> > > > > >>the musb host-controller driver doesn't set the hcd->has_tt flag.
> > > > > >>
> > > > > >>Felipe, you should know where it belongs.  It should be easy enough to
> > > > > >>add.
> > > > > >
> > > > > >Sure Alan, it's attached to this mail. Compile tested only though.
> > > > > >Michael, would you care to give your tested-by ?
> > > > > 
> > > > > I can do, I'm using exactly the same patch since yesterday. ;)
> > > > > 
> > > > > Tested-by: Alexander Holler <holler@ahsoftware.de>
> > > > 
> > > > Thanks a lot Alex, Greg, can you still take this to -rc ? Do you need a
> > > > pull request or you can take this one patch ?
> > > 
> > > Wait, where does this need to go?  For the final 2.6.38 release and then
> > > also for .37-stable?
> > > 
> > > Or just .37-stable?
> > > 
> > > confused.
> > > 
> > > And no, I don't need a pull request, I can handle one patch through
> > > email :)
> > 
> > final .38 and .37-stable :-) Thanks Greg :-)
> 
> It's important that this patch appear in .37-stable at the same time as
> the $SUBJECT patch.  If that means delaying $SUBJECT for one release, 
> so be it -- it was not a very important change.

Ok, I'll drop this from the next .37-stable release until this happens.

thanks for letting me know.

greg k-h
