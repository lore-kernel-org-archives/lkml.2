Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932946Ab0HNIUx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 04:20:53 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:58350 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932664Ab0HNIUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 04:20:51 -0400
Date: Sat, 14 Aug 2010 09:59:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Brian Swetland <swetland@google.com>, "Ted Ts'o" <tytso@mit.edu>,
        Alan Stern <stern@rowland.harvard.edu>, paulmck@linux.vnet.ibm.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, david@lang.hm,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, florian@mickler.org,
        rjw@sisk.pl, peterz@infradead.org, tglx@linutronix.de,
        menage@google.com, david-b@pacbell.net, James.Bottomley@suse.de,
        arjan@infradead.org, swmike@swm.pp.se, galibert@pobox.com,
        dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Message-ID: <20100814075923.GC27430@elf.ucw.cz>
References: <AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com>
 <Pine.LNX.4.44L0.1008120733130.21006-100000@netrider.rowland.org>
 <AANLkTinMwt27wuDUh32F36wpoC54Syzp1_nK9UCxYmEK@mail.gmail.com>
 <20100812125248.GA2763@thunk.org>
 <AANLkTin4=qpDWEKLwes_af6mSCW+ED7v-fWzD34JywU1@mail.gmail.com>
 <20100812182128.GC2763@thunk.org>
 <AANLkTinZ_gViUjVmEbkmour3BC=PcchJDARs4GaCuQwO@mail.gmail.com>
 <AANLkTimjfU2zu4reEVdOwWwtFHPQ33_Gna6xS2XHRG-h@mail.gmail.com>
 <20100812125712.48b7fc26@virtuousgeek.org>
 <AANLkTinbsXEk7YL31Q2GHHjeVRHGgpm0mpLzDBY1Ob4z@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinbsXEk7YL31Q2GHHjeVRHGgpm0mpLzDBY1Ob4z@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> Question though -- has every feature ever added to the kernel been a
> >> feature that there's pre-existing usage of?  Seems like a chicken and
> >> egg problem.  Also, some people seem to think there's value in being
> >> able to build kernels "out of the box" that work with the Android
> >> userspace -- given that there are a few devices out there that have
> >> that userspace on 'em.
> >
> > We generally try to merge new features like this along with code that
> > uses said feature, but there are always exceptions.  We've merged code
> > one release or more before the new code gets used for example, which is
> > fine IMO.  What we don't want to see is some new drop of code added and
> > abandoned, but you already knew that.
> 
> If Android guys provided a bare minimal Debian system with suspend
> blockers that people can take a look at and try, I think that would be
> a good proof of concept. And a bare minimum to get the patches merged.

Yes, that would certainly help.

I guess this is the major point -- as suspend blockers seem very
suitable for android, they don't seem suitable for anyone else...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
