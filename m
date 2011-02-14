Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278Ab1BNQ5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:57:55 -0500
Received: from sous-sol.org ([216.99.217.87]:48338 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756162Ab1BNQ5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:57:53 -0500
Date: Mon, 14 Feb 2011 08:57:47 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: sedat.dilek@gmail.com
Cc: Chris Wright <chrisw@sous-sol.org>, DRI <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression - Xorg start failed
Message-ID: <20110214165747.GK9869@sequoia.sous-sol.org>
References: <AANLkTi=G5pLNqLw1RGNauD+9D76uJfEgNXuef1Po6km7@mail.gmail.com>
 <20110214162057.GI9869@sequoia.sous-sol.org>
 <AANLkTinFN6gmcNvoe=DQ3YPL=Bcj3pKCHO6ZzafE9uak@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinFN6gmcNvoe=DQ3YPL=Bcj3pKCHO6ZzafE9uak@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sedat Dilek (sedat.dilek@googlemail.com) wrote:
> On Mon, Feb 14, 2011 at 5:20 PM, Chris Wright <chrisw@sous-sol.org> wrote:
> > * Sedat Dilek (sedat.dilek@googlemail.com) wrote:
> >> [ As I am not subscribed to both MLs and lazy to pick up all involved people ]
> >>
> >> Hi Chris,
> >>
> >> The original patch had also this part (see the revert in [1]):
> >> ...
> >> +#include <linux/security.h>
> >> ...
> >>
> >> Your new patch in [2] is missing it or is it not required?
> >
> > It was just a patch on top of the bad commit (47970b1b), the #include is
> > required.
> >
> > thanks,
> > -chris
> >
> 
> OK, now I see.
> Might be good to push a v2 as the initial patch was reverted in the meantime?
> The explanations of the fixup patch were helpful (to me) and should be included.

Yeah, I'll send a new patch to James.
