Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab0JDWlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 18:41:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44093 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558Ab0JDWlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 18:41:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Anisse Astier <anisse@astier.eu>, "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: Re: [Bug #16891] Kernel panic while loading intel module during boot
Date: Tue, 5 Oct 2010 00:40:59 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc6-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Eric Anholt <eric@anholt.net>,
        Tim Gardner <tim.gardner@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Chris Wilson <chris@chris-wilson.co.uk>
References: <OjxVjYbf_EJ.A.ReC.pTPqMB@chimera> <201010042142.29402.rjw@sisk.pl> <AANLkTinsc=DqQwnR18McRP8fLei=GHWV1yykCcYDUCzv@mail.gmail.com>
In-Reply-To: <AANLkTinsc=DqQwnR18McRP8fLei=GHWV1yykCcYDUCzv@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010050040.59281.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 04, 2010, Anisse Astier wrote:
> On Mon, Oct 4, 2010 at 9:42 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> I'll provide this patch here in the meantime in case anyone is interested.
> >
> > Thanks for the update and the patch.
> >
> > Well, I wonder who's going to merge it?
> >
> 
> I'm not sure is going to be merged because most of this code has been
> re-written and has been sitting in drm-intel-next for a few weeks now.
> This (welcome) rewrite will likely be merged in 2.6.37 (but I can't
> speak for Chris).
> 
> This is a port of this patch:
> http://git.kernel.org/?p=linux/kernel/git/ickle/drm-intel.git;a=commit;h=e5e408fc94595aab897f613b6f4e2f5b36870a6f
> , but on completely different code.
> 
> Also this patch is new and didn't see much testing (I tested on 4
> different Intel GPUs, belonging only to 2 different families); if it's
> not merged for 2.6.36, it won't be for 2.6.37 (the new code will land
> first). If that happens, it might not meet conditions to be accepted
> in -stable (being in linus' tree first).

It's a panic fix, so I think it is -stable material anyway.  Greg?

Thanks,
Rafael
