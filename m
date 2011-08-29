Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab1H2Ils (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 04:41:48 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38367 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab1H2Ilk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 04:41:40 -0400
MIME-Version: 1.0
In-Reply-To: <1314559619-19923-1-git-send-email-peterhuewe@gmx.de>
References: <E1Qvo1q-0000qv-TQ@rmk-PC.arm.linux.org.uk>
	<1314559619-19923-1-git-send-email-peterhuewe@gmx.de>
Date: Mon, 29 Aug 2011 10:41:39 +0200
Message-ID: <CACRpkdavhLpsfFwHy3jnHO3o9EC+e6=dt1joMGQD_e3O=HTT-A@mail.gmail.com>
Subject: Re: [PATCH] spi: Fix builderror in spi-pl022.c
From: Linus Walleij <linus.walleij@linaro.org>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org
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
>
> The build failure was:
> drivers/spi/spi-pl022.c:2292: error: 'adev' undeclared (first use in
> this function)
> drivers/spi/spi-pl022.c:2344: error: 'pl022_suspend' undeclared here
> (not in a function)
>
> The build failure appears e.g. for the u8500 and realview defconfig.
>
> LinuxVersion: linux next-20110826
>
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks!
Linus Walleij
