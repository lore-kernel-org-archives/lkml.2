Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140Ab2ECSwB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 14:52:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51360 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab2ECSwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 14:52:00 -0400
Date: Thu, 3 May 2012 11:51:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Nico Schottelius <nico-linux-20120419@schottelius.org>,
        Francois Rigaut <frigaut@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux Support for Thunderbolt using Apple Monitor
Message-ID: <20120503185155.GA554@kroah.com>
References: <20120419163800.GB13977@schottelius.org>
 <CAMVeQ8r_3vuAxzbLyKoecOHOOGijUDkLfw+MK7o-WoWbuOGSrg@mail.gmail.com>
 <20120502163629.GE928@schottelius.org>
 <20120502202509.GA26798@kroah.com>
 <20120503065003.GB13386@schottelius.org>
 <CAMVeQ8qYu4bShd_+pwRv8bShhusJMDa-jjoqu7EujS4jt7RSNA@mail.gmail.com>
 <20120503153547.GD20334@kroah.com>
 <20120503184008.GB9432@schottelius.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120503184008.GB9432@schottelius.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 08:40:08PM +0200, Nico Schottelius wrote:
> Greg,
> 
> Greg KH [Thu, May 03, 2012 at 08:35:47AM -0700]:
> > [...]
> > 
> > How about if you load the acpiphp module instead?  Some BIOSes use that
> > instead of pciehp.
> > 
> > You need one of those drivers in order for this to work properly.
> > 
> > Also, speaking of BIOS, make sure you have the latest updates, there
> > were a lot of initial problems with Thunderbolt hotplug issues that were
> > fixed in newer BIOS versions, so that will be required to be updated.
> 
> I'm confused - to which BIOS are you referring to? I understood that
> Apple's Mac Book Air has its custom "similar to EFI" (*) code and not a
> traditional BIOS in place.

It's still a BIOS, and needs to be updated.  If that BIOS boots using
EFI or the "old" format is not an issue here.

> (*) Which would also be interesting to replace with something like
>     LinuxBios/Coreboot.

Good luck with that :)

greg k-h
