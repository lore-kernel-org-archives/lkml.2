Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab2LCTsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 14:48:20 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:45643 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab2LCTsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 14:48:18 -0500
Date: Mon, 3 Dec 2012 20:48:17 +0100
From: Andreas Mohr <andi@lisas.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andreas Mohr <andi@lisas.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [YASB] Re: Linux 3.7-rc7
Message-ID: <20121203194817.GA14594@rhlx01.hs-esslingen.de>
References: <CA+55aFyetqyMa2BQu7kE=cqFdAysUh9gV=O5as5Chgg1EMCW7g@mail.gmail.com>
 <20121203193310.GA32762@rhlx01.hs-esslingen.de>
 <CA+55aFygWCxz=Mmogp8FoSr51rNct6ANw0Kw3y=u4Pu2iDK48Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFygWCxz=Mmogp8FoSr51rNct6ANw0Kw3y=u4Pu2iDK48Q@mail.gmail.com>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 03, 2012 at 11:39:07AM -0800, Linus Torvalds wrote:
> On Mon, Dec 3, 2012 at 11:33 AM, Andreas Mohr <andi@lisas.de> wrote:
> > Florian Fainelli (1):
> >       x86/ce4100: Fix pm_poweroff
> >
> > sounds like it *might* happen to be a candidate (I could try to add a
> > revert on top, of certain likely candidates).
> 
> That can only matter if you select support for CONFIG_X86_INTEL_CE
> ("CE4100 TV platform") which you should never do unless you actually
> compile for that platform.

OK, nevermind.

> So it's something else (or you have an insane config file). Bisection
> would be wonderful.

At least the config file part of my side seems to be sane ;)

Will try script to unload half of all drivers etc.
(heavy amounts of bisection wouldn't be joyful on this box).


I failed to mention the effects:
Suspend starts, disk does spin down, yet display backlight stays
until finally monitor blanks.

Thanks,

Andreas Mohr
