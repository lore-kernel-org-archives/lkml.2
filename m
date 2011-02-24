Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab1BXRXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 12:23:43 -0500
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:59780 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751852Ab1BXRXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 12:23:40 -0500
Date: Thu, 24 Feb 2011 19:23:27 +0200
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@suse.de>
Cc: Felipe Balbi <balbi@ti.com>, Alexander Holler <holler@ahsoftware.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Michael Jones <michael.jones@matrix-vision.de>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        USB list <linux-usb@vger.kernel.org>, linux-omap@vger.kernel.org
Subject: Re: [024/115] USB: prevent buggy hubs from crashing the USB stack
Message-ID: <20110224172327.GF3528@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <4D64C81B.5060807@ahsoftware.de>
 <Pine.LNX.4.44L0.1102231021210.2233-100000@iolanthe.rowland.org>
 <20110224085735.GD3528@legolas.emea.dhcp.ti.com>
 <4D6621AB.10205@ahsoftware.de>
 <20110224091638.GH3528@legolas.emea.dhcp.ti.com>
 <20110224171814.GA8376@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110224171814.GA8376@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 09:18:14AM -0800, Greg KH wrote:
> On Thu, Feb 24, 2011 at 11:16:38AM +0200, Felipe Balbi wrote:
> > Hi,
> > 
> > On Thu, Feb 24, 2011 at 10:15:23AM +0100, Alexander Holler wrote:
> > > >On Wed, Feb 23, 2011 at 10:26:20AM -0500, Alan Stern wrote:
> > > >>In both cases, it appears that the problem is caused by the fact that
> > > >>the musb host-controller driver doesn't set the hcd->has_tt flag.
> > > >>
> > > >>Felipe, you should know where it belongs.  It should be easy enough to
> > > >>add.
> > > >
> > > >Sure Alan, it's attached to this mail. Compile tested only though.
> > > >Michael, would you care to give your tested-by ?
> > > 
> > > I can do, I'm using exactly the same patch since yesterday. ;)
> > > 
> > > Tested-by: Alexander Holler <holler@ahsoftware.de>
> > 
> > Thanks a lot Alex, Greg, can you still take this to -rc ? Do you need a
> > pull request or you can take this one patch ?
> 
> Wait, where does this need to go?  For the final 2.6.38 release and then
> also for .37-stable?
> 
> Or just .37-stable?
> 
> confused.
> 
> And no, I don't need a pull request, I can handle one patch through
> email :)

final .38 and .37-stable :-) Thanks Greg :-)

-- 
balbi
