Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab1IUNLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 09:11:20 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44762 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab1IUNLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 09:11:18 -0400
Date: Wed, 21 Sep 2011 14:10:52 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, Peter Huewe <peterhuewe@gmx.de>
Subject: Re: [PATCH] spi: Fix builderror in spi-pl022.c
Message-ID: <20110921131052.GG17169@n2100.arm.linux.org.uk>
References: <E1Qvo1q-0000qv-TQ@rmk-PC.arm.linux.org.uk> <1314559619-19923-1-git-send-email-peterhuewe@gmx.de> <CACRpkdb=Bt2j4iMV5NJHmPG8wDi6__CRD6kn_KOoaQ1R6uwrWQ@mail.gmail.com> <CACRpkdbsUMCvBofKjExiB2wCbK9CwpcXr5xmShJ4SHEGAAH4Bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbsUMCvBofKjExiB2wCbK9CwpcXr5xmShJ4SHEGAAH4Bw@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
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

Isn't it already fixed?  I've had this in my tree for quite some time
(since 5th September) which should also be in linux-next.

b21c57c ARM: 7079/1: spi: Fix builderror in spi-pl022.c
612f2eb PM: add runtime PM support to MMCI
67fc8b9 PM: add runtime PM support to core Primecell driver
