Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab1IEMpG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 08:45:06 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54383 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab1IEMpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 08:45:02 -0400
MIME-Version: 1.0
In-Reply-To: <1314559619-19923-1-git-send-email-peterhuewe@gmx.de>
References: <E1Qvo1q-0000qv-TQ@rmk-PC.arm.linux.org.uk>
	<1314559619-19923-1-git-send-email-peterhuewe@gmx.de>
Date: Mon, 5 Sep 2011 14:45:00 +0200
Message-ID: <CACRpkdb=Bt2j4iMV5NJHmPG8wDi6__CRD6kn_KOoaQ1R6uwrWQ@mail.gmail.com>
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

On Sun, Aug 28, 2011 at 9:26 PM, Peter Huewe <peterhuewe@gmx.de> wrote:

> This patch fixes a build error, introduced by commit (67fc8b9f, "PM: add
> runtime PM support to core Primecell driver") which unfortunately was a little
> bit incomplete and did contain a typo (11 instead of 22).
> I'm not sure how this patch could have been tested back then, if it
> doesn't even compile ;)

Grant can you please apply this patch? Right now linux-next is
breaking because of this missing patch...

Thanks,
Linus Walleij
