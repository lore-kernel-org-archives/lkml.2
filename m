Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab1BVWbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:31:35 -0500
Received: from eazy.amigager.de ([213.239.192.238]:44254 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727Ab1BVWb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:31:27 -0500
Date: Tue, 22 Feb 2011 23:31:20 +0100
From: Tino Keitel <tino.keitel@tikei.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alex Riesen <raa.lkml@gmail.com>, Indan Zupancic <indan@nul.nu>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix backlight brightness on intel LVDS panel after
 reopening lid
Message-ID: <20110222223120.GA3567@x61.home>
Mail-Followup-To: Jesse Barnes <jbarnes@virtuousgeek.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Alex Riesen <raa.lkml@gmail.com>, Indan Zupancic <indan@nul.nu>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com>
 <20110216192658.GA7225@blimp.localdomain>
 <20110217221329.GA3332@x61.home>
 <3f792aaf90cf0b3d49be21baa2682d5d.squirrel@webmail.greenhost.nl>
 <AANLkTik20vCMhXqjxkoebZ1cWFb0zQLP5OZvVx4GWMPb@mail.gmail.com>
 <AANLkTik3ECs5z5td6GYuDExrc74_18mC-bk-hsq4e1+i@mail.gmail.com>
 <AANLkTik9XHcDUbPTPh6t--TwQompeQBY9TNuuBRk++-6@mail.gmail.com>
 <20110222130440.21a27714@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110222130440.21a27714@jbarnes-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 13:04:40 -0800, Jesse Barnes wrote:
> On Sat, 19 Feb 2011 15:07:49 -0800
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Sat, Feb 19, 2011 at 4:26 AM, Alex Riesen <raa.lkml@gmail.com> wrote:
> > > On Sat, Feb 19, 2011 at 13:11, Alex Riesen <raa.lkml@gmail.com> wrote:
> > >>> Lastly, could you verify that my patch at https://lkml.org/lkml/2011/2/16/447 fixes
> > >>> it for you too? (Make sure you're at max brightness before rebooting.)
> > >>
> > >> I'll try it now.
> > >>
> > >
> > > I can confirm that it does fix backlight in my case (Dell XPS 1330,
> > > LVDS panel, GM965/GL960).
> > >
> > > Tested-by: Alex Riesen <raa.lkml@gmail.com>
> > 
> > Guys, should I apply this, or will I get it through somebody's pull?
> 
> I'm worried that removing combo mode will break some working setups,
> but if it's seen a lot of testing and is ok, then I'm fine with it, as
> it definitely simplifies things.

Hi,

I just tried 2.6.38-rc6 on my ThinkPad X61s without any other DRM
related patches, and my backlight issue is gone.

Regards,
Tino
