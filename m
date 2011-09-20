Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab1ITVwI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 17:52:08 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59579 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab1ITVwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 17:52:06 -0400
Date: Tue, 20 Sep 2011 15:52:02 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, Peter Huewe <peterhuewe@gmx.de>
Subject: Re: [PATCH] spi: Fix builderror in spi-pl022.c
Message-ID: <20110920215202.GQ7781@ponder.secretlab.ca>
References: <E1Qvo1q-0000qv-TQ@rmk-PC.arm.linux.org.uk>
 <1314559619-19923-1-git-send-email-peterhuewe@gmx.de>
 <CACRpkdb=Bt2j4iMV5NJHmPG8wDi6__CRD6kn_KOoaQ1R6uwrWQ@mail.gmail.com>
 <CACRpkdbsUMCvBofKjExiB2wCbK9CwpcXr5xmShJ4SHEGAAH4Bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbsUMCvBofKjExiB2wCbK9CwpcXr5xmShJ4SHEGAAH4Bw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 10:45:41PM +0200, Linus Walleij wrote:
> On Mon, Sep 5, 2011 at 2:45 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> > On Sun, Aug 28, 2011 at 9:26 PM, Peter Huewe <peterhuewe@gmx.de> wrote:
> >
> >> This patch fixes a build error, introduced by commit (67fc8b9f, "PM: add
> >> runtime PM support to core Primecell driver") which unfortunately was a little
> >> bit incomplete and did contain a typo (11 instead of 22).
> >> I'm not sure how this patch could have been tested back then, if it
> >> doesn't even compile ;)
> >
> > Grant can you please apply this patch? Right now linux-next is
> > breaking because of this missing patch...
> 
> Ping on this... ignore if it's been picked already.

It's not a patch that went through my tree, so I cannot pick it up.

g.

