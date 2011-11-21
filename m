Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab1KUSRf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 13:17:35 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:45498 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815Ab1KUSRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 13:17:33 -0500
Date: Mon, 21 Nov 2011 19:17:24 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Greg KH <gregkh@suse.de>
Cc: Jean-Francois Dagenais <jeff.dagenais@gmail.com>, hjk@hansjkoch.de,
        tglx@linutronix.de, linux-pci@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: extra large DMA buffer for PCI-E device under UIO
Message-ID: <20111121181724.GB12011@local>
References: <B458B2F0-2DDA-461F-A125-8C6C4CDEB6C5@gmail.com>
 <20111118220849.GA25205@suse.de>
 <9E9C8A95-723C-427A-AD01-17284EDF7E4F@gmail.com>
 <20111121173620.GA5028@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121173620.GA5028@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 09:36:20AM -0800, Greg KH wrote:
> On Mon, Nov 21, 2011 at 10:31:07AM -0500, Jean-Francois Dagenais wrote:
> > Hi Greg, thanks for your answer...
> > 
> > On Nov 18, 2011, at 17:08, Greg KH wrote:
> > 
> > > On Fri, Nov 18, 2011 at 04:16:23PM -0500, Jean-Francois Dagenais wrote:
> > >> Hello fellow hackers.
> > >> 
> > >> I am maintaining a UIO based driver for a PCI-E data acquisition device.
> > >> 
> > >> I map BAR0 of the device to userspace. I also map two memory areas,
> > >> one is used to feed instructions to the acquisition device, the other
> > >> is used autonomously by the PCI device to write the acquired data.
> > > 
> > > Nice, have a pointer to your driver anywhere so we can include it in the
> > > main kernel tree to make your life easier?
> > As I said in a parallel answer from "Hans J. Koch" <hjk@hansjkoch.de>,
> > the driver, although GPL'ed, is quite uninteresting except for us here at
> > Sonatest.
> 
> I really doubt that,

So do I. We never had a driver allocating so much memory.

> and you should submit it anyway to allow us to
> change it when the in-kernel apis change in the future.  It will save
> you time in the long run and make things easier for you (look, your
> driver is automatically included in all distros!, people fix your bugs,
> etc.)

Exactly.

> 
> > About merging the driver to mainline, I guess it would only be interesting for
> > the recipe I demonstrate. Please advise.
> 
> That is a recipe that I'm sure others will use, and need help on in the
> future.

They already needed it in the past, and they usually try to get it by
writing me private mail.

> 
> So please submit a patch, that will make it easier to help you out.

Yes, please do. The more different drivers we have under /drivers/uio, the
better. Didn't you use one of the existing drivers as a template for yours?

Thanks,
Hans
