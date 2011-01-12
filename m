Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab1ALTX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 14:23:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750741Ab1ALTXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 14:23:23 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1101120601100.6210@skynet.skynet.ie>
References: <alpine.DEB.2.00.1101120601100.6210@skynet.skynet.ie>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 12 Jan 2011 11:22:58 -0800
Message-ID: <AANLkTimgs8UfGWk5PCZi4PM5SsvejJd5Y4bb3nHGyZy2@mail.gmail.com>
Subject: Re: [git pull] drm intel only fixes
To: Dave Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 10:03 PM, Dave Airlie <airlied@linux.ie> wrote:
>
> I'm stuck at home with just my i5 laptop due to the office being shut due
> to the ongoing floods. But I've booted and ran this for a few hours and it
> seems to be better than the current tree. It contains a couple of patches
> to fix DMAR interaction issues I see on this laptop on top of Chris's
> pull.

Hmm. I'm not seeing the screensaver issue any more, but there's
something wrong with video. At least the TED ones (I'm not seeing it
on a youtube video i tried). See for example

  http://www.ted.com/talks/lang/eng/david_gallo_shows_underwater_astonishments.html

and when there is fast movement in the video (like when the octopus is
spooked), I get these odd lines of noise.

In fact, while I noticed the lines in the video itself, it's actually
most repeatably noticeable in the buttons underneath while the video
is playing: make your mouse go back-and-forth between the "rate" and
"share" buttons, and they get corrupted (and it also corrupts the
progress bar).

It looks a bit like the noise you get with insufficient memory
bandwidth, but I doubt that's the case here. Perhaps just some
motion-comp problem?

Any ideas?

                              Linus
