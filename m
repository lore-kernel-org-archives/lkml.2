Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab1AKO25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 09:28:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59258 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756008Ab1AKO24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 09:28:56 -0500
Date: Tue, 11 Jan 2011 15:28:51 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org
Subject: Re: Linux 2.6.37
Message-ID: <20110111142851.GA16306@tiehlicka.suse.cz>
References: <AANLkTikKA-nStyNjkdsVa8hd=PFQR3tYTJh3MnfpNkD8@mail.gmail.com>
 <20110106104816.GA4026@tiehlicka.suse.cz>
 <20110111133320.GB10705@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110111133320.GB10705@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 11-01-11 14:33:20, Pavel Machek wrote:
> > Hi,
> > 
> > On Tue 04-01-11 17:15:45, Linus Torvalds wrote:
> > [...]
> > > We did have another revert to fix hopefullythe last "blank screen"
> > > regression on intel graphics.
> > 
> > It seems that there is still a regression for intel graphic cards
> > backlight. One report is https://bugzilla.kernel.org/show_bug.cgi?id=22672.
> > I can reproduce the problem easily by:
> > xset dpms force standby; sleep 3s; xset dpms force on
> 
> (You are using "vesa" or "fbcon" X11 driver, right? I seen same problem
> until I switched to "intel" X11 driver).

I am using intel X11 driver:
[...]
(II) Loading extension DRI2
(II) LoadModule: "intel"
(II) Loading /usr/lib/xorg/modules/drivers/intel_drv.so
[...]

So this doesn't look like the case.

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
