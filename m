Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab1CRCvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 22:51:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60298 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755775Ab1CRCvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 22:51:02 -0400
MIME-Version: 1.0
In-Reply-To: <20110317183048.GW7258@atomide.com>
References: <20110317183048.GW7258@atomide.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Mar 2011 19:50:36 -0700
Message-ID: <AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
To: Tony Lindgren <tony@atomide.com>, Russell King <rmk@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 11:30 AM, Tony Lindgren <tony@atomide.com> wrote:
>
> Please pull omap changes for this merge window from:

Gaah. Guys, this whole ARM thing is a f*cking pain in the ass.

You need to stop stepping on each others toes. There is no way that
your changes to those crazy clock-data files should constantly result
in those annoying conflicts, just because different people in
different ARM trees do some masturbatory renaming of some random
device. Seriously.

That usb_musb_init() thing in arch/arm/mach-omap2/usb-musb.c also
seems to be totally insane. I wonder what kind of insanity I'm missing
just because I don't happen to see the merge conflicts, just because
people were lucky enough to happen to not touch the same file within a
few lines.

Somebody needs to get a grip in the ARM community. I do want to do
these merges, just to see how screwed up things are, but guys, this is
just ridiculous. The pure amount of crazy churn is annoying in itself,
but when I then get these "independent" pull requests from four
different people, and they touch the same files, that indicates that
something is wrong.

And stop the crazy renaming already! Just leave it off. Don't rename
boards and drivers "just because", at least not when there clearly are
clashes. There's no point. I'm not even talking about the file renames
(which happened and can also make it "fun" to try to resolve the
conflicts when somebody else then makes _other_ changes), but about
the stupid "change human-readable names in board files just to annoy
whoever needs to merge the crap".

Somebody in the ARM community really needs to step up and tell people
to stop dicking around.

(I'm replying to the omap pull request, because that's the one I did
last, but I don't know who to "blame". I don't care. It really doesn't
matter. I realize thar ARM vendors do crazy shit and haven't figured
out this whole "platform" thing yet, but you guys need to push back on
the people sending you crap).

                                   Linus
