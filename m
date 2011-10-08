Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab1JHJiA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 05:38:00 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49877 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab1JHJh5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 05:37:57 -0400
MIME-Version: 1.0
In-Reply-To: <1317629883-13582-1-git-send-email-linus.walleij@stericsson.com>
References: <1317629883-13582-1-git-send-email-linus.walleij@stericsson.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 8 Oct 2011 17:37:36 +0800
Message-ID: <CAGsJ_4wJogkvhoJ0JNJGbv9FvaA7zHxFKRwvkXdY0g5SbLXuJA@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinmux: add a driver for the U300 pinmux
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static void __init u300_pmx_dumpregs(struct u300_pmx *upmx)
> +{
> +       u16 regval;
> +       int i;
> +
> +       for (i = 0; i < ARRAY_SIZE(u300_pmx_registers); i++) {
> +               regval = readw(upmx->virtbase + u300_pmx_registers[i]);
> +               dev_info(upmx->dev, "PMX%u: 0x%04x\n", i, regval);
> +       }
> +}
> +

is this a debug information or do you want it to be in mainline?

-barry
