Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab1B0JqM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 04:46:12 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:34964 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751884Ab1B0JqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 04:46:10 -0500
Date: Sun, 27 Feb 2011 10:46:52 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org, Indan Zupancic <indan@nul.nu>
Subject: Re: [git pull] drm fixes
Message-ID: <20110227094652.GA6402@elf.ucw.cz>
References: <alpine.DEB.2.00.1102232316030.5315@skynet.skynet.ie>
 <AANLkTikc5KeAepsUUE_LfkDKSbgkYYqrz0QVy6ctWALy@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikc5KeAepsUUE_LfkDKSbgkYYqrz0QVy6ctWALy@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Nothing too major,
> >
> > Two regression fixers (one revert that got fixes properly elsewhere), some
> > timestamp fixes and an agp module reload fix.
> 
> Pulled. However, what about the report from	Pavel Machek <pavel@ucw.cz>:

Are you sure it was me?

> > >      drm/i915: Completely disable fence pipelining.
> >
> > Reverting this commit helps in v2.6.38-rc5+ when screen is not fully updated,
> > or has a corrupted picture like horizontal black or white stripes. Using a
> > compositor like compiz may help to avoid the problem.
> >
> > See bug https://bugzilla.kernel.org/show_bug.cgi?id=27572

I don't see myself there, nor do I remember having that problem.

DRM_I915_KMS seems to have vesafb... but I'm afraid it always did..
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
