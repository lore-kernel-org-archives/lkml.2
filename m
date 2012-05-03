Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516Ab2ECPeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 11:34:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59149 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab2ECPeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 11:34:16 -0400
Date: Thu, 3 May 2012 08:34:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Nico Schottelius <nico-linux-20120419@schottelius.org>,
        Francois Rigaut <frigaut@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux Support for Thunderbolt using Apple Monitor
Message-ID: <20120503153411.GC20334@kroah.com>
References: <20120419163800.GB13977@schottelius.org>
 <CAMVeQ8r_3vuAxzbLyKoecOHOOGijUDkLfw+MK7o-WoWbuOGSrg@mail.gmail.com>
 <20120502163629.GE928@schottelius.org>
 <20120502202509.GA26798@kroah.com>
 <20120503065003.GB13386@schottelius.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120503065003.GB13386@schottelius.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 08:50:03AM +0200, Nico Schottelius wrote:
> Greg KH [Wed, May 02, 2012 at 01:25:09PM -0700]:
> > Thunderbolt should show up to the kernel just as a "normal" PCIE link,
> > so there shouldn't be anything special we need to do to handle this at
> > all (or at least my Intel contacts said that.)
> 
> Well, at least from my lspci point of view (before/after disconnect same
> output), this seems to be wrong (no dmesg output as well).
> 
> Additionally as far as I understand
> thunderbolt, it's bundling display port and pci-e into a single channel,
> so I'm not sure if this is 100% transparent pci-e + displayport from our
> side.
> 
> Or, the better question is probably: How should Linux realise that there
> is a change (apple monitor with ethernet, usb, co. plugged in) going on?
> 
> > Note, I haven't tested this yet, so I can't verify it, but if you have
> > the hardware, you should be able to.
> 
> I can test stuff here, but would be thankful for a round of pointers on
> how to debug / approach this.

Have you loaded the pciehp module (or maybe acpiphp, depending on your
BIOS)?  One of those should be what will control the pci hotplug for
your system to work properly.

thanks,

greg k-h
