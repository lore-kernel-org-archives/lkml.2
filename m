Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959Ab2EBUZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 16:25:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43969 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407Ab2EBUZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 16:25:16 -0400
Date: Wed, 2 May 2012 13:25:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Nico Schottelius <nico-linux-20120419@schottelius.org>,
        Francois Rigaut <frigaut@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux Support for Thunderbolt using Apple Monitor
Message-ID: <20120502202509.GA26798@kroah.com>
References: <20120419163800.GB13977@schottelius.org>
 <CAMVeQ8r_3vuAxzbLyKoecOHOOGijUDkLfw+MK7o-WoWbuOGSrg@mail.gmail.com>
 <20120502163629.GE928@schottelius.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120502163629.GE928@schottelius.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 06:36:29PM +0200, Nico Schottelius wrote:
> Hey Francois,
> 
> Francois Rigaut [Mon, Apr 30, 2012 at 11:45:52AM +1000]:
> > I have a MBA 13" (mid 2011), and I believe we already have been in contact
> > about the state of linux on it. Thanks for your early work on it, it helped
> > me quite a bit in the initial setup.
> 
> Great to have helped!
> 
> > I agree with you that linux is now pretty stable on MBAs. I'm exclusively
> > running linux on mine, and beside the thunderbold/displayport support issue
> > (that's why I am replying to this thread), I have been more than happy with
> > it. btw, I don't experience the X crashes myself, and the network (both
> > wired and wireless) is working flawlessly.
> 
> Network is mostly working fine nowadays as well, besides having to issue
> "reassociate" in wpa_cli after each resume/suspend and a new bug in Xorg
> that forces me to "rmmod bcm5974; modprobe bcm5974;" to make Xorg
> recognsie the touchpad again (speaking of Linux 3.3.3-1-ARCH and
> X.Org X Server 1.12.1 and xf86-input-synaptics 1.5.99.904-1).
> 
> > Now to the thunderbolt support: I have myself a thunderbolt 27" at work. In
> > a nutshell: [...]
> 
> This smells exactly like in the old Linux days, when an external monitor
> only worked when it was connected at startup.
> 
> I've tried to get some information about thunderbolt, but it seems Intel
> is currently unwillingly to give information out:
> 
>   http://communities.intel.com/message/155263#155263
> 
> I'm wondering if anyone from the Intel developers reading this list
> can comment on this?

Thunderbolt should show up to the kernel just as a "normal" PCIE link,
so there shouldn't be anything special we need to do to handle this at
all (or at least my Intel contacts said that.)

Note, I haven't tested this yet, so I can't verify it, but if you have
the hardware, you should be able to.

greg k-h
