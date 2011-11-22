Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566Ab1KVLn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 06:43:29 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52778 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756937Ab1KVLmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 06:42:40 -0500
MIME-Version: 1.0
In-Reply-To: <1321880398-12605-1-git-send-email-linus.walleij@stericsson.com>
References: <1321880398-12605-1-git-send-email-linus.walleij@stericsson.com>
Date: Tue, 22 Nov 2011 17:12:39 +0530
Message-ID: <CAJuYYwQU7A1ikPoy=vNfCMtG-cQc6+t6PS=d4TCh1=KatZWADg@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: GPIO direction support for muxing
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Igor Grinberg <grinberg@compulab.co.il>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 November 2011 18:29, Linus Walleij <linus.walleij@stericsson.com> wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
>
> When requesting a single GPIO pin to be muxed in, some controllers
> will need to poke a different value into the control register
> depending on whether the pin will be used for GPIO output or GPIO
> input. So create pinmux counterparts to gpio_direction_[input|output]
> in the pinctrl framework.

Reviewed-by: Thomas Abraham <thomas.abraham@linaro.org>

One minor comment below.

>

[...]

> diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
> index 214b961..4a946ba 100644
> --- a/Documentation/pinctrl.txt
> +++ b/Documentation/pinctrl.txt

[...]

> +Alternatively to using these special functions, it is fully allowed to use
> +named functions for each GPIO pin, the pinmux_request_gpio() will attempt to
> +obtain the function "gpioN" where "N" is the global GPIO pin number if no
> +special GPIO-handler is registered.
> +
> +The public functions to enable a certain GPIO pin

Is the above sentence incomplete?

Thanks,
Thomas.
