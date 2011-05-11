Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab1EKA2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 20:28:54 -0400
Received: from mail.perches.com ([173.55.12.10]:1465 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab1EKA2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 20:28:52 -0400
Subject: Re: [PATCH 2/4] pinmux: add a driver for the U300 pinmux
From: Joe Perches <joe@perches.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Martin Persson <martin.persson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
In-Reply-To: <BANLkTinnPWu9TZ72xdnXayrG0QYF+0mMBg@mail.gmail.com>
References: <1304363798-30409-1-git-send-email-linus.walleij@stericsson.com>
	 <1304365233.7792.42.camel@Joe-Laptop>
	 <BANLkTinnPWu9TZ72xdnXayrG0QYF+0mMBg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 17:28:51 -0700
Message-ID: <1305073731.19586.175.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-11 at 02:17 +0200, Linus Walleij wrote:
> 2011/5/2 Joe Perches <joe@perches.com>:
> > On Mon, 2011-05-02 at 21:16 +0200, Linus Walleij wrote:
> > []
> >> diff --git a/drivers/pinmux/pinmux-u300.c b/drivers/pinmux/pinmux-u300.c
> >> +++ b/drivers/pinmux/pinmux-u300.c
> >> +struct u300_pin_desc {
> >> +     unsigned number;
> >> +     char *name;
> > const char *name?
> Thanks, fixed!
> Can I have your reviewed-by for this patch given I fixed that?

Hi Linus.

I've only looked at the code not compiled, used or tested it
and so I think my sign-off isn't particularly valuable.

But your design and implementation seem sensible.

Anyway if you want for the whole series:

Reviewed-but-not-compiled-used-or-tested-by: Joe Perches <joe@perches.com>

(that way I won't get copied by get_maintainer.pl ;)

cheers, Joe

