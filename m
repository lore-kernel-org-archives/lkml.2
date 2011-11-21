Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab1KURmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 12:42:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51980 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249Ab1KURmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 12:42:53 -0500
Date: Mon, 21 Nov 2011 09:36:20 -0800
From: Greg KH <gregkh@suse.de>
To: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Cc: hjk@hansjkoch.de, tglx@linutronix.de, linux-pci@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: extra large DMA buffer for PCI-E device under UIO
Message-ID: <20111121173620.GA5028@suse.de>
References: <B458B2F0-2DDA-461F-A125-8C6C4CDEB6C5@gmail.com>
 <20111118220849.GA25205@suse.de>
 <9E9C8A95-723C-427A-AD01-17284EDF7E4F@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9E9C8A95-723C-427A-AD01-17284EDF7E4F@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 10:31:07AM -0500, Jean-Francois Dagenais wrote:
> Hi Greg, thanks for your answer...
> 
> On Nov 18, 2011, at 17:08, Greg KH wrote:
> 
> > On Fri, Nov 18, 2011 at 04:16:23PM -0500, Jean-Francois Dagenais wrote:
> >> Hello fellow hackers.
> >> 
> >> I am maintaining a UIO based driver for a PCI-E data acquisition device.
> >> 
> >> I map BAR0 of the device to userspace. I also map two memory areas,
> >> one is used to feed instructions to the acquisition device, the other
> >> is used autonomously by the PCI device to write the acquired data.
> > 
> > Nice, have a pointer to your driver anywhere so we can include it in the
> > main kernel tree to make your life easier?
> As I said in a parallel answer from "Hans J. Koch" <hjk@hansjkoch.de>,
> the driver, although GPL'ed, is quite uninteresting except for us here at
> Sonatest.

I really doubt that, and you should submit it anyway to allow us to
change it when the in-kernel apis change in the future.  It will save
you time in the long run and make things easier for you (look, your
driver is automatically included in all distros!, people fix your bugs,
etc.)

> About merging the driver to mainline, I guess it would only be interesting for
> the recipe I demonstrate. Please advise.

That is a recipe that I'm sure others will use, and need help on in the
future.

So please submit a patch, that will make it easier to help you out.

thanks,

greg k-h
