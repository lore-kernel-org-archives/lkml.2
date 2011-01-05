Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580Ab1AEHVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 02:21:38 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:58946 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751475Ab1AEHVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 02:21:37 -0500
Date: Wed, 5 Jan 2011 08:21:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dave Airlie <airlied@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.37-rc8
Message-ID: <20110105072153.GA2248@elf.ucw.cz>
References: <AANLkTi=-dNeeDjcSoznKtwcaNyw1mMXSqepFY89R2i+2@mail.gmail.com>
 <20110104142604.GA6591@ucw.cz>
 <849307$b0n4jp@azsmga001.ch.intel.com>
 <20110104210408.GA2008@elf.ucw.cz>
 <AANLkTim2PC5tgLfuz4+jO4L_xSX9bPuLhy+gtE2mgcJH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim2PC5tgLfuz4+jO4L_xSX9bPuLhy+gtE2mgcJH@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2011-01-05 07:15:42, Dave Airlie wrote:
> On Wed, Jan 5, 2011 at 7:04 AM, Pavel Machek <pavel@ucw.cz> wrote:
> > Hi!
> >
> >> > I still see blank screen on thinkpad x60... but so do I on 2.6.36 with
> >> > same config, so maybe it is just tricky to configure?
> >>
> >> Old bug? I thought we had KMS on 945 pretty well understood by now. Care
> >> to attach the dmesg with drm.debug=0xe? And to check against linus/master
> >> for the most recent regression fixes.
> >
> > dmesg is attached (delme.gz), as is config.
> >
> > And yes, I did git pull few minutes ago...
> 
> Disable CONFIG_FB_VESA or remove the vga= line from the commandline for a
> first test.

Ok, that helped with 2.6.35 I had compiled and which had same
problem. Will retry with 2.6.37-rc8-git.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
