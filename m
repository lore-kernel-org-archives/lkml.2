Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab0JEQM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 12:12:26 -0400
Received: from cable-static-49-187.intergga.ch ([157.161.49.187]:56047 "EHLO
	mail.ffwll.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755386Ab0JEQMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 12:12:25 -0400
X-Greylist: delayed 389 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Oct 2010 12:12:24 EDT
X-Spam-ASN: 
X-Spam-Hammy: 0.000-+--sk:stable, 0.000-+--H*Ad:D*kernel.org,
	0.000-+--H*Ad:D*vger.kernel.org
X-Spam-Spammy: 0.962-+--H*r:mail.ffwll.ch
Date: Tue, 5 Oct 2010 18:08:22 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Greg KH <gregkh@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Anisse Astier <anisse@astier.eu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Eric Anholt <eric@anholt.net>,
        Tim Gardner <tim.gardner@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [Bug #16891] Kernel panic while loading intel module during
 boot
Message-ID: <20101005160821.GA3565@viiv.ffwll.ch>
Mail-Followup-To: Greg KH <gregkh@suse.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Anisse Astier <anisse@astier.eu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	Florian Mickler <florian@mickler.org>,
	Eric Anholt <eric@anholt.net>,
	Tim Gardner <tim.gardner@canonical.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Chris Wilson <chris@chris-wilson.co.uk>
References: <OjxVjYbf_EJ.A.ReC.pTPqMB@chimera>
 <201010042142.29402.rjw@sisk.pl>
 <AANLkTinsc=DqQwnR18McRP8fLei=GHWV1yykCcYDUCzv@mail.gmail.com>
 <201010050040.59281.rjw@sisk.pl>
 <20101005132829.GE3548@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101005132829.GE3548@suse.de>
X-Operating-System: Linux viiv 2.6.36-rc1-00209-gb0f6b62-dirty 
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 06:28:29AM -0700, Greg KH wrote:
> On Tue, Oct 05, 2010 at 12:40:59AM +0200, Rafael J. Wysocki wrote:
> > On Monday, October 04, 2010, Anisse Astier wrote:
> > > Also this patch is new and didn't see much testing (I tested on 4
> > > different Intel GPUs, belonging only to 2 different families); if it's
> > > not merged for 2.6.36, it won't be for 2.6.37 (the new code will land
> > > first). If that happens, it might not meet conditions to be accepted
> > > in -stable (being in linus' tree first).
> > 
> > It's a panic fix, so I think it is -stable material anyway.  Greg?
> 
> That sounds good, please cc: stable@kernel.org with the proper
> information for this (git commit id, patch info, etc.)

I'll do that as soon as drm-intel-next has hit -linus. I've written the
original fix and marked it cc: stable so it won't get lost. I've been
rather cautious with pushing this because it's the 3rd trial to fix a bug
in late .35-rc. The previous fixes already caused regressions in -stable
and I'd simply like to avoid causing yet another regression over the same
problem.

Yours, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
