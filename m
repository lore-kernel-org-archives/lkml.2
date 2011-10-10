Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab1JJL6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 07:58:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61890 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab1JJL6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 07:58:12 -0400
MIME-Version: 1.0
In-Reply-To: <1318235485-2112-1-git-send-email-linus.walleij@stericsson.com>
References: <1318235485-2112-1-git-send-email-linus.walleij@stericsson.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 10 Oct 2011 19:57:51 +0800
Message-ID: <CAGsJ_4w9y_DTgX-zz7BUFM2M+UPgFF=JDmD5RptQ3SR5-0h1UQ@mail.gmail.com>
Subject: Re: [PATCH v10] pinctrl: add a driver for the U300 pinmux
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>, Lee Jones <lee.jones@linaro.org>,
        Joe Perches <joe@perches.com>, Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/10 Linus Walleij <linus.walleij@stericsson.com>:
> From: Linus Walleij <linus.walleij@linaro.org>
>
> This adds a driver for the U300 pinmux portions of the system
> controller "SYSCON". It also serves as an example of how to use
> the pinmux subsystem. This driver also houses the platform data
> for the only supported platform.
>
> This deletes the old U300 driver in arch/arm/mach-u300 and
> replace it with a driver using the new subsystem.
>
> The new driver is considerably fatter than the old one, but it
> also registers all 467 pins of the system and adds the power
> and EMIF pin groups and corresponding functions. The idea
> is to use this driver as a a reference for other
> implementation so it needs to be as complete and verbose
> as possible.
>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Barry Song <21cnbao@gmail.com>

> ---
> ChangeLog v9 -> v10
> - Removed debug register dump (review from Barry Song)
> - Allocate sizeof(*ptr) instead of sizeof(struct foo)


-barry
