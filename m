Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab0JENgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 09:36:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:49912 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024Ab0JENgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 09:36:11 -0400
Date: Tue, 5 Oct 2010 06:28:29 -0700
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Anisse Astier <anisse@astier.eu>,
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
Message-ID: <20101005132829.GE3548@suse.de>
References: <OjxVjYbf_EJ.A.ReC.pTPqMB@chimera>
 <201010042142.29402.rjw@sisk.pl>
 <AANLkTinsc=DqQwnR18McRP8fLei=GHWV1yykCcYDUCzv@mail.gmail.com>
 <201010050040.59281.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010050040.59281.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 12:40:59AM +0200, Rafael J. Wysocki wrote:
> On Monday, October 04, 2010, Anisse Astier wrote:
> > On Mon, Oct 4, 2010 at 9:42 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > >> I'll provide this patch here in the meantime in case anyone is interested.
> > >
> > > Thanks for the update and the patch.
> > >
> > > Well, I wonder who's going to merge it?
> > >
> > 
> > I'm not sure is going to be merged because most of this code has been
> > re-written and has been sitting in drm-intel-next for a few weeks now.
> > This (welcome) rewrite will likely be merged in 2.6.37 (but I can't
> > speak for Chris).
> > 
> > This is a port of this patch:
> > http://git.kernel.org/?p=linux/kernel/git/ickle/drm-intel.git;a=commit;h=e5e408fc94595aab897f613b6f4e2f5b36870a6f
> > , but on completely different code.
> > 
> > Also this patch is new and didn't see much testing (I tested on 4
> > different Intel GPUs, belonging only to 2 different families); if it's
> > not merged for 2.6.36, it won't be for 2.6.37 (the new code will land
> > first). If that happens, it might not meet conditions to be accepted
> > in -stable (being in linus' tree first).
> 
> It's a panic fix, so I think it is -stable material anyway.  Greg?

That sounds good, please cc: stable@kernel.org with the proper
information for this (git commit id, patch info, etc.)

thanks,

greg k-h
