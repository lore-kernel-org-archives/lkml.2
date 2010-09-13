Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab0IMNWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 09:22:19 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43187 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab0IMNWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 09:22:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=AwrPSBqjB5j/ws2jSho9bmnKb8Y09ZJ+yHUj5Q3wSBk1KMmztV6dreka8LWZiqtSyZ
         jRDY/NhKg5RD9wOnBw8mjArD24q/yYaspTW7NoMFpo3mlPWbBYLywXbfpwmeh1Oo5sWG
         f6+FtvU1q1MZ12qjF5hl1PYlDp10CVrvtLLvg=
MIME-Version: 1.0
In-Reply-To: <1284135579-13578-6-git-send-email-wellsk40@gmail.com>
References: <1284135579-13578-1-git-send-email-wellsk40@gmail.com>
	<1284135579-13578-6-git-send-email-wellsk40@gmail.com>
Date: Mon, 13 Sep 2010 15:22:16 +0200
Message-ID: <AANLkTimNnA=tNCE7pLiibwB66R86dNmCDpCuQMkTvw9J@mail.gmail.com>
Subject: Re: [PATCH 5/5] spi: amba_pl022: Remove unused fields from pl022_config_chip
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: wellsk40@gmail.com
Cc: spi-devel-general@lists.sourceforge.net, sameo@linux.intel.com,
        rabin.vincent@stericsson.com, srinidhi.kasagar@stericsson.com,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        tj@kernel.org, grant.likely@secretlab.ca, Lukasz.Baj@tieto.com,
        quentinyang05@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/10  <wellsk40@gmail.com>:

> From: Kevin Wells <wellsk40@gmail.com>
>
> Some of the fields in the pl022_config_chip structure are no
> longer needed with the spi->mode updates. These fields have been
> removed.

I think you have to do a more thorough patch:

drivers/spi/amba-pl022.c: In function 'verify_controller_parameters':
drivers/spi/amba-pl022.c:1598: error: 'struct pl022_config_chip' has
no member named 'lbm'
drivers/spi/amba-pl022.c:1599: error: 'struct pl022_config_chip' has
no member named 'lbm'
drivers/spi/amba-pl022.c:1629: error: 'struct pl022_config_chip' has
no member named 'endian_rx'
(... etc)

Yours,
Linus Walleij
