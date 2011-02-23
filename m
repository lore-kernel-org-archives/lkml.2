Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab1BWSxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 13:53:37 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:48425 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932197Ab1BWSxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 13:53:36 -0500
Date: Wed, 23 Feb 2011 19:53:34 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@linux.ie>, Eric Anholt <eric@anholt.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: Re: [git pull] drm for rc1
Message-ID: <20110223185334.GA711@atrey.karlin.mff.cuni.cz>
References: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie> <AANLkTinW8Yp1K1w+G+BgLa-fPaFANkGsRjqH_W8N+9VL@mail.gmail.com> <AANLkTim5oVZqMBtan5_TMOxaWbqkF=aDcBYFNYy55kt_@mail.gmail.com> <0aea052d-70ff-41ea-8776-c6d974c10337@email.android.com> <20110111133329.GD10705@atrey.karlin.mff.cuni.cz> <0d30dc$knd39a@orsmga001.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d30dc$knd39a@orsmga001.jf.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > >>> Highlights:
> > > >>> core/drivers: add support for high precision vblank timestamps
> > > >>> radeon: pageflipping support, Gen2 PCIE support
> > > >>> nouveau: reworked VRAM and VM support
> > > >>> intel: better ILK/SNB powersaving support, Full GTT support
> > > >>
> > > >> Lowlights: it's broken.
> > 
> > Heh, at this point I expected Linus to complain about milion merges in
> > changelog...

(Ok, I chould have put a smiley there :-).

> > > Arg.  It's been ok on my ILK systems, but Chris has found some
> > >issues with out watermarking code iirc; apparently we're underflowing
> > >the display FIFO, causing all sorts of trouble.  If it works before
> > >the pull of Dave's tree, can you bisect?
> > 
> > Watermarking code? What goes on there?
> 
> FIFO watermarks, they determine when the display fetches from the scanout
> buffer to fill the pipe. If we run out of FIFO entries then the display
> flickers at best, at worst we may hard hang the machine.

Thanks for info. I was afraid it was trying to do some watermarks on
video signal, to catch evil videotapers or something like that...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
