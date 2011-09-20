Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381Ab1ITUpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 16:45:43 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44256 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab1ITUpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 16:45:42 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdb=Bt2j4iMV5NJHmPG8wDi6__CRD6kn_KOoaQ1R6uwrWQ@mail.gmail.com>
References: <E1Qvo1q-0000qv-TQ@rmk-PC.arm.linux.org.uk>
	<1314559619-19923-1-git-send-email-peterhuewe@gmx.de>
	<CACRpkdb=Bt2j4iMV5NJHmPG8wDi6__CRD6kn_KOoaQ1R6uwrWQ@mail.gmail.com>
Date: Tue, 20 Sep 2011 22:45:41 +0200
Message-ID: <CACRpkdbsUMCvBofKjExiB2wCbK9CwpcXr5xmShJ4SHEGAAH4Bw@mail.gmail.com>
Subject: Re: [PATCH] spi: Fix builderror in spi-pl022.c
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, Peter Huewe <peterhuewe@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 5, 2011 at 2:45 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Sun, Aug 28, 2011 at 9:26 PM, Peter Huewe <peterhuewe@gmx.de> wrote:
>
>> This patch fixes a build error, introduced by commit (67fc8b9f, "PM: add
>> runtime PM support to core Primecell driver") which unfortunately was a little
>> bit incomplete and did contain a typo (11 instead of 22).
>> I'm not sure how this patch could have been tested back then, if it
>> doesn't even compile ;)
>
> Grant can you please apply this patch? Right now linux-next is
> breaking because of this missing patch...

Ping on this... ignore if it's been picked already.

Thanks,
Linus Walleij
