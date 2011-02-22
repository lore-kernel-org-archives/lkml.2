Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab1BVVEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 16:04:47 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:41423 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750915Ab1BVVEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 16:04:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=YBbPIruOXYUgUhsrIwC59H2Y5IuZVpZp8+JK/aYtQwekVCGX9DjTrTlQPDyVQYu7aExR2ZiOZe09GjHlPJiOSgy/ai4KIosDKasqvU8+gGfhlFla5V43fydh3L2CqwVk;
Date: Tue, 22 Feb 2011 13:04:40 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alex Riesen <raa.lkml@gmail.com>, Indan Zupancic <indan@nul.nu>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix backlight brightness on intel LVDS panel after
 reopening lid
Message-ID: <20110222130440.21a27714@jbarnes-desktop>
In-Reply-To: <AANLkTik9XHcDUbPTPh6t--TwQompeQBY9TNuuBRk++-6@mail.gmail.com>
References: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com>
	<20110216192658.GA7225@blimp.localdomain>
	<20110217221329.GA3332@x61.home>
	<3f792aaf90cf0b3d49be21baa2682d5d.squirrel@webmail.greenhost.nl>
	<AANLkTik20vCMhXqjxkoebZ1cWFb0zQLP5OZvVx4GWMPb@mail.gmail.com>
	<AANLkTik3ECs5z5td6GYuDExrc74_18mC-bk-hsq4e1+i@mail.gmail.com>
	<AANLkTik9XHcDUbPTPh6t--TwQompeQBY9TNuuBRk++-6@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Feb 2011 15:07:49 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, Feb 19, 2011 at 4:26 AM, Alex Riesen <raa.lkml@gmail.com> wrote:
> > On Sat, Feb 19, 2011 at 13:11, Alex Riesen <raa.lkml@gmail.com> wrote:
> >>> Lastly, could you verify that my patch at https://lkml.org/lkml/2011/2/16/447 fixes
> >>> it for you too? (Make sure you're at max brightness before rebooting.)
> >>
> >> I'll try it now.
> >>
> >
> > I can confirm that it does fix backlight in my case (Dell XPS 1330,
> > LVDS panel, GM965/GL960).
> >
> > Tested-by: Alex Riesen <raa.lkml@gmail.com>
> 
> Guys, should I apply this, or will I get it through somebody's pull?

I'm worried that removing combo mode will break some working setups,
but if it's seen a lot of testing and is ok, then I'm fine with it, as
it definitely simplifies things.

-- 
Jesse Barnes, Intel Open Source Technology Center
