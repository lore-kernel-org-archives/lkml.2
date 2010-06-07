Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab0FGVJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 17:09:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752871Ab0FGVJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 17:09:21 -0400
Date: Mon, 7 Jun 2010 14:03:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@gmail.com>
cc: Dave Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm fixes
In-Reply-To: <AANLkTinDSMqlwOsNfX-K2vDN9HeQL19mtXEDAp8mqVjz@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1006071352510.4506@i5.linux-foundation.org>
References: <alpine.DEB.2.00.1006070404510.29029@skynet.skynet.ie> <alpine.LFD.2.00.1006071057300.3515@i5.linux-foundation.org> <AANLkTimSFtaDzUPDEq4Z2J4O5sFG4vDkFHqs1eA1wG44@mail.gmail.com> <AANLkTinDSMqlwOsNfX-K2vDN9HeQL19mtXEDAp8mqVjz@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Jun 2010, Dave Airlie wrote:
> 
> Oh the one where I said to the reporter, I've reproduced this, and
> will fix it tomorrow when I have proper time and access to my test
> machine?
> 
> I didn't think writing a fix in the 5 mins before I left the test
> machine and sending it you was acceptable, again can you maintain some
> semblance of consistency across maintainers/releases?

No, no. I really didn't imply that you should hurry and not be careful. I 
was just unhappy about the mixing of non-regression fixes with the 
regression fixes.

> Like I'm happy if you really enforce this no features idea, I'd be
> really happy if you did it every release since it makes it a lot
> easier to push back to submaintainers if you can point at Linus not
> pulling features from people.

I already had another person state their happiness with me pushing back, 
and while I had my reasons for doing it this particular release, I do know 
that I've been letting things slide wrt the merge window a bit too much.

So let's see how the 2.6.35 release cycle ends up looking when all is said 
and done. If pushing back harder ends up actually making things easier and 
the release cycle ends up working better as a result, I'm certainly very 
open to just being hardnosed in general.

I suspect it won't even be very painful if people just get used to it. And 
if it ends up really helping sub-maintainers ("I can't do that, because 
Linus wouldn't pull the result anyway"), then that would be a really good 
reason for me to be rather stricter about the rules.

			Linus
